// SPDX-License-Identifier: LicenseRef-RAQM-Research-Only-No-Commercial-Production-1.0
`timescale 1ns/1ps
module uart_tx #(
    parameter integer CLKS_PER_BIT = 50  // 100 MHz / 2 Mbps
) (
    input  logic       clk,
    input  logic       resetn,
    input  logic       start_i,
    input  logic [7:0] data_i,
    output logic       tx_o,
    output logic       busy_o
);
    typedef enum logic [1:0] {TX_IDLE, TX_START, TX_DATA, TX_STOP} tx_state_t;
    tx_state_t state;
    logic [15:0] count;
    logic [2:0] bit_index;
    logic [7:0] shift;

    always_ff @(posedge clk) begin
        if (!resetn) begin
            state <= TX_IDLE;
            count <= 16'd0;
            bit_index <= 3'd0;
            shift <= 8'd0;
            tx_o <= 1'b1;
            busy_o <= 1'b0;
        end else begin
            case (state)
                TX_IDLE: begin
                    tx_o <= 1'b1;
                    busy_o <= 1'b0;
                    if (start_i) begin
                        shift <= data_i;
                        count <= CLKS_PER_BIT - 1;
                        bit_index <= 0;
                        tx_o <= 1'b0;
                        busy_o <= 1'b1;
                        state <= TX_START;
                    end
                end
                TX_START: begin
                    if (count == 0) begin
                        tx_o <= shift[0];
                        count <= CLKS_PER_BIT - 1;
                        bit_index <= 0;
                        state <= TX_DATA;
                    end else count <= count - 1'b1;
                end
                TX_DATA: begin
                    if (count == 0) begin
                        count <= CLKS_PER_BIT - 1;
                        if (bit_index == 3'd7) begin
                            tx_o <= 1'b1;
                            state <= TX_STOP;
                        end else begin
                            bit_index <= bit_index + 1'b1;
                            tx_o <= shift[bit_index + 1'b1];
                        end
                    end else count <= count - 1'b1;
                end
                TX_STOP: begin
                    if (count == 0) begin
                        tx_o <= 1'b1;
                        busy_o <= 1'b0;
                        state <= TX_IDLE;
                    end else count <= count - 1'b1;
                end
                default: state <= TX_IDLE;
            endcase
        end
    end
endmodule
