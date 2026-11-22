// SPDX-License-Identifier: LicenseRef-RAQM-Research-Only-No-Commercial-Production-1.0
`timescale 1ns/1ps
// UART packet endpoint. Host side is an isolated 2-wire RS-485 half-duplex bus.
// Request:  A5 | SEQ | DATA[1:0] | CFG | MASKS | CRC8
// Response: 5A | SEQ | STATUS | DATA[1:0] | CRC8
// CRC-8 polynomial 0x07, init 0x00; excludes SOF and CRC byte.
module raqm_packet_engine (
    input  logic       clk,
    input  logic       resetn,

    input  logic [7:0] rx_data,
    input  logic       rx_valid,
    output logic [7:0] tx_data,
    output logic       tx_start,
    input  logic       tx_busy,
    output logic       rs485_tx_enable,

    output logic       core_host_req,
    input  logic       core_host_ack,
    output logic [1:0] core_host_data,
    output logic [1:0] core_branch_mode,
    output logic       core_merge_sel,
    output logic       core_feedback_en,
    output logic [1:0] core_mask_b,
    output logic [1:0] core_mask_c,

    input  logic       core_out_valid,
    output logic       core_out_ack,
    input  logic [1:0] core_out_data,
    input  logic [7:0] core_out_status
);

    typedef enum logic [3:0] {
        P_RX_SOF, P_RX_SEQ, P_RX_DATA, P_RX_CFG, P_RX_MASK, P_RX_CRC,
        P_CORE_WAIT_ACK_HI, P_CORE_WAIT_ACK_LO, P_CORE_WAIT_OUT,
        P_TX_INIT, P_TX_WAIT_BUSY, P_TX_WAIT_DONE, P_CORE_ACK, P_CORE_CLEAR
    } pstate_t;
    pstate_t state;

    logic [7:0] seq_q, data_q, cfg_q, masks_q, crc_q;
    logic [7:0] resp_status_q, resp_data_q, resp_crc_q;
    logic [2:0] tx_index;
    logic       core_result_pending;

    function automatic [7:0] crc8_next(input logic [7:0] crc_in,
                                       input logic [7:0] data_in);
        logic [7:0] c;
        integer i;
        begin
            c = crc_in ^ data_in;
            for (i = 0; i < 8; i = i + 1) begin
                if (c[7]) c = (c << 1) ^ 8'h07;
                else      c = (c << 1);
            end
            crc8_next = c;
        end
    endfunction

    function automatic [7:0] response_byte(input logic [2:0] idx,
                                           input logic [7:0] seq,
                                           input logic [7:0] status,
                                           input logic [7:0] data,
                                           input logic [7:0] crc);
        begin
            case (idx)
                3'd0: response_byte = 8'h5A;
                3'd1: response_byte = seq;
                3'd2: response_byte = status;
                3'd3: response_byte = data;
                default: response_byte = crc;
            endcase
        end
    endfunction

    task automatic prepare_response(input logic [7:0] status,
                                     input logic [7:0] data,
                                     input logic needs_core_ack);
        begin
            resp_status_q <= status;
            resp_data_q   <= data;
            resp_crc_q    <= crc8_next(crc8_next(crc8_next(8'h00, seq_q), status), data);
            core_result_pending <= needs_core_ack;
            state <= P_TX_INIT;
        end
    endtask

    always_ff @(posedge clk) begin
        if (!resetn) begin
            state <= P_RX_SOF;
            seq_q <= 8'h00;
            data_q <= 8'h00;
            cfg_q <= 8'h00;
            masks_q <= 8'h00;
            crc_q <= 8'h00;
            resp_status_q <= 8'h00;
            resp_data_q <= 8'h00;
            resp_crc_q <= 8'h00;
            tx_index <= 3'd0;
            tx_data <= 8'h00;
            tx_start <= 1'b0;
            rs485_tx_enable <= 1'b0;
            core_host_req <= 1'b0;
            core_host_data <= 2'b00;
            core_branch_mode <= 2'b11;
            core_merge_sel <= 1'b0;
            core_feedback_en <= 1'b0;
            core_mask_b <= 2'b00;
            core_mask_c <= 2'b00;
            core_out_ack <= 1'b0;
            core_result_pending <= 1'b0;
        end else begin
            tx_start <= 1'b0;
            core_out_ack <= 1'b0;

            case (state)
                P_RX_SOF: begin
                    if (rx_valid && rx_data == 8'hA5) state <= P_RX_SEQ;
                end
                P_RX_SEQ: begin
                    if (rx_valid) begin
                        seq_q <= rx_data;
                        crc_q <= crc8_next(8'h00, rx_data);
                        state <= P_RX_DATA;
                    end
                end
                P_RX_DATA: begin
                    if (rx_valid) begin
                        data_q <= rx_data;
                        crc_q <= crc8_next(crc_q, rx_data);
                        state <= P_RX_CFG;
                    end
                end
                P_RX_CFG: begin
                    if (rx_valid) begin
                        cfg_q <= rx_data;
                        crc_q <= crc8_next(crc_q, rx_data);
                        state <= P_RX_MASK;
                    end
                end
                P_RX_MASK: begin
                    if (rx_valid) begin
                        masks_q <= rx_data;
                        crc_q <= crc8_next(crc_q, rx_data);
                        state <= P_RX_CRC;
                    end
                end
                P_RX_CRC: begin
                    if (rx_valid) begin
                        if (rx_data != crc_q) begin
                            prepare_response(8'h10, 8'h00, 1'b0); // CRC error
                        end else if ((cfg_q[7:4] != 4'h0) ||
                                     (masks_q[7:4] != 4'h0) ||
                                     (data_q[7:2] != 6'h00)) begin
                            prepare_response(8'h11, 8'h00, 1'b0); // Reserved bits
                        end else begin
                            core_host_data    <= data_q[1:0];
                            core_branch_mode  <= cfg_q[1:0];
                            core_merge_sel    <= cfg_q[2];
                            core_feedback_en  <= cfg_q[3];
                            core_mask_b       <= masks_q[1:0];
                            core_mask_c       <= masks_q[3:2];
                            core_host_req     <= 1'b1;
                            state <= P_CORE_WAIT_ACK_HI;
                        end
                    end
                end

                P_CORE_WAIT_ACK_HI: begin
                    if (core_host_ack) begin
                        core_host_req <= 1'b0;
                        state <= P_CORE_WAIT_ACK_LO;
                    end
                end
                P_CORE_WAIT_ACK_LO: begin
                    if (!core_host_ack) state <= P_CORE_WAIT_OUT;
                end
                P_CORE_WAIT_OUT: begin
                    if (core_out_valid) begin
                        prepare_response(core_out_status,
                                         {6'b000000, core_out_data},
                                         1'b1);
                    end
                end

                P_TX_INIT: begin
                    tx_index <= 3'd0;
                    tx_data <= response_byte(3'd0, seq_q, resp_status_q,
                                             resp_data_q, resp_crc_q);
                    tx_start <= 1'b1;
                    rs485_tx_enable <= 1'b1;
                    state <= P_TX_WAIT_BUSY;
                end
                P_TX_WAIT_BUSY: begin
                    if (tx_busy) state <= P_TX_WAIT_DONE;
                end
                P_TX_WAIT_DONE: begin
                    if (!tx_busy) begin
                        if (tx_index == 3'd4) begin
                            rs485_tx_enable <= 1'b0;
                            if (core_result_pending) state <= P_CORE_ACK;
                            else state <= P_RX_SOF;
                        end else begin
                            tx_index <= tx_index + 1'b1;
                            tx_data <= response_byte(tx_index + 1'b1, seq_q,
                                                     resp_status_q, resp_data_q,
                                                     resp_crc_q);
                            tx_start <= 1'b1;
                            state <= P_TX_WAIT_BUSY;
                        end
                    end
                end
                P_CORE_ACK: begin
                    core_out_ack <= 1'b1;
                    core_result_pending <= 1'b0;
                    state <= P_CORE_CLEAR;
                end
                P_CORE_CLEAR: begin
                    if (!core_out_valid) state <= P_RX_SOF;
                end
                default: state <= P_RX_SOF;
            endcase
        end
    end
endmodule
