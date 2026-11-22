// SPDX-License-Identifier: LicenseRef-RAQM-Research-Only-No-Commercial-Production-1.0
`timescale 1ns/1ps
module uart_rx #(
    parameter integer CLKS_PER_BIT = 50  // 100 MHz / 2 Mbps
) (
    input  logic       clk,
    input  logic       resetn,
    input  logic       rx_i,
    output logic [7:0] data_o,
    output logic       valid_o
);
    typedef enum logic [1:0] {RX_IDLE, RX_START, RX_DATA, RX_STOP} rx_state_t;
    rx_state_t state;
    (* ASYNC_REG = "TRUE" *) logic rx_meta, rx_sync;
    logic [15:0] count;
    logic [2:0] bit_index;
    logic [7:0] shift;

    always_ff @(posedge clk) begin
        if (!resetn) begin
            rx_meta <= 1'b1;
            rx_sync <= 1'b1;
        end else begin
            rx_meta <= rx_i;
            rx_sync <= rx_meta;
        end
    end

    always_ff @(posedge clk) begin
        if (!resetn) begin
            state <= RX_IDLE;
            count <= 16'd0;
            bit_index <= 3'd0;
            shift <= 8'd0;
            data_o <= 8'd0;
            valid_o <= 1'b0;
        end else begin
            valid_o <= 1'b0;
            case (state)
                RX_IDLE: begin
                    if (!rx_sync) begin
                        count <= (CLKS_PER_BIT/2) - 1;
                        state <= RX_START;
                    end
                end
                RX_START: begin
                    if (count == 0) begin
                        if (!rx_sync) begin
                            count <= CLKS_PER_BIT - 1;
                            bit_index <= 0;
                            state <= RX_DATA;
                        end else begin
                            state <= RX_IDLE;
                        end
                    end else count <= count - 1'b1;
                end
                RX_DATA: begin
                    if (count == 0) begin
                        shift[bit_index] <= rx_sync;
                        count <= CLKS_PER_BIT - 1;
                        if (bit_index == 3'd7) state <= RX_STOP;
                        else bit_index <= bit_index + 1'b1;
                    end else count <= count - 1'b1;
                end
                RX_STOP: begin
                    if (count == 0) begin
                        if (rx_sync) begin
                            data_o <= shift;
                            valid_o <= 1'b1;
                        end
                        state <= RX_IDLE;
                    end else count <= count - 1'b1;
                end
                default: state <= RX_IDLE;
            endcase
        end
    end
endmodule
