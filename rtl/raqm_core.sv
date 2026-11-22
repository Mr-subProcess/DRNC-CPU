// SPDX-License-Identifier: LicenseRef-RAQM-Research-Only-No-Commercial-Production-1.0
`timescale 1ns/1ps
// RAQM scalar four-phase REQ/ACK reference core, retained in G77M Rev 3.
// Internal implementation is synchronous to the Versal PL clock.
// The host request/acknowledge and output valid/acknowledge channels
// use four-phase return-to-zero handshakes.
module raqm_core #(
    parameter integer B_LATENCY = 3,
    parameter integer C_LATENCY = 4
) (
    input  logic       clk,
    input  logic       resetn,

    // Request channel. All four 2-bit data values are VALID data.
    input  logic       host_req,
    output logic       host_ack,
    input  logic [1:0] host_data,
    input  logic [1:0] branch_mode,  // 01=B, 10=C, 11=B and C in parallel
    input  logic       merge_sel,    // 0=B result, 1=C result
    input  logic       feedback_en,
    input  logic [1:0] mask_b,
    input  logic [1:0] mask_c,
    output logic       ready,

    // Result channel. out_valid distinguishes an empty channel from data 00.
    output logic       out_valid,
    input  logic       out_ack,
    output logic [1:0] out_data,
    output logic [7:0] out_status,

    // Debug/diagnostic outputs for test points or FPGA ILA.
    output logic       branch_b_done,
    output logic       branch_c_done,
    output logic       join_done
);

    localparam logic [7:0] STATUS_OK             = 8'h00;
    localparam logic [7:0] STATUS_BAD_BRANCH     = 8'h01;
    localparam logic [7:0] STATUS_BAD_MERGE      = 8'h02;
    localparam logic [7:0] STATUS_NO_FEEDBACK    = 8'h03;

    typedef enum logic [1:0] {ST_IDLE, ST_RUN, ST_WAIT_OUT, ST_WAIT_RELEASE} state_t;
    state_t state;

    logic [1:0] token_q, mask_b_q, mask_c_q;
    logic [1:0] branch_q;
    logic       merge_q;
    logic       b_active, c_active;
    logic [15:0] b_count, c_count;
    logic [1:0] b_result, c_result;
    logic [1:0] feedback_data;
    logic       feedback_valid;

    logic b_will_finish, c_will_finish;
    logic [1:0] selected_result;

    always_comb begin
        b_will_finish = b_active && !branch_b_done && (b_count <= 16'd1);
        c_will_finish = c_active && !branch_c_done && (c_count <= 16'd1);
        selected_result = merge_q ? c_result : b_result;
        ready = (state == ST_IDLE);
        join_done = branch_b_done && branch_c_done;
    end

    always_ff @(posedge clk) begin
        if (!resetn) begin
            state           <= ST_IDLE;
            host_ack        <= 1'b0;
            out_valid       <= 1'b0;
            out_data        <= 2'b00;
            out_status      <= STATUS_OK;
            token_q         <= 2'b00;
            mask_b_q        <= 2'b00;
            mask_c_q        <= 2'b00;
            branch_q        <= 2'b00;
            merge_q         <= 1'b0;
            b_active        <= 1'b0;
            c_active        <= 1'b0;
            b_count         <= 16'd0;
            c_count         <= 16'd0;
            b_result        <= 2'b00;
            c_result        <= 2'b00;
            branch_b_done   <= 1'b0;
            branch_c_done   <= 1'b0;
            feedback_data   <= 2'b00;
            feedback_valid  <= 1'b0;
        end else begin
            case (state)
                ST_IDLE: begin
                    host_ack      <= 1'b0;
                    out_valid     <= 1'b0;
                    branch_b_done <= 1'b0;
                    branch_c_done <= 1'b0;
                    if (host_req) begin
                        host_ack <= 1'b1;

                        // Reject invalid configurations, but still complete
                        // the request handshake and return an error response.
                        if (branch_mode == 2'b00) begin
                            out_status <= STATUS_BAD_BRANCH;
                            out_data   <= 2'b00;
                            out_valid  <= 1'b1;
                            state      <= ST_WAIT_OUT;
                        end else if (((branch_mode == 2'b01) && merge_sel) ||
                                     ((branch_mode == 2'b10) && !merge_sel)) begin
                            out_status <= STATUS_BAD_MERGE;
                            out_data   <= 2'b00;
                            out_valid  <= 1'b1;
                            state      <= ST_WAIT_OUT;
                        end else if (feedback_en && !feedback_valid) begin
                            out_status <= STATUS_NO_FEEDBACK;
                            out_data   <= 2'b00;
                            out_valid  <= 1'b1;
                            state      <= ST_WAIT_OUT;
                        end else begin
                            token_q   <= feedback_en ? feedback_data : host_data;
                            mask_b_q  <= mask_b;
                            mask_c_q  <= mask_c;
                            branch_q  <= branch_mode;
                            merge_q   <= merge_sel;
                            b_active  <= branch_mode[0];
                            c_active  <= branch_mode[1];
                            b_count   <= B_LATENCY[15:0];
                            c_count   <= C_LATENCY[15:0];
                            b_result  <= (feedback_en ? feedback_data : host_data) ^ mask_b;
                            c_result  <= (feedback_en ? feedback_data : host_data) ^ mask_c;
                            branch_b_done <= !branch_mode[0];
                            branch_c_done <= !branch_mode[1];
                            state     <= ST_RUN;
                        end
                    end
                end

                ST_RUN: begin
                    // Four-phase request return: ACK remains high until REQ is low.
                    if (!host_req)
                        host_ack <= 1'b0;

                    if (b_active && !branch_b_done) begin
                        if (b_count <= 16'd1) begin
                            branch_b_done <= 1'b1;
                            b_count <= 16'd0;
                        end else begin
                            b_count <= b_count - 16'd1;
                        end
                    end
                    if (c_active && !branch_c_done) begin
                        if (c_count <= 16'd1) begin
                            branch_c_done <= 1'b1;
                            c_count <= 16'd0;
                        end else begin
                            c_count <= c_count - 16'd1;
                        end
                    end

                    if ((branch_b_done || b_will_finish) &&
                        (branch_c_done || c_will_finish)) begin
                        out_data   <= selected_result;
                        out_status <= STATUS_OK;
                        out_valid  <= 1'b1;
                        feedback_data  <= selected_result;
                        feedback_valid <= 1'b1;
                        state <= ST_WAIT_OUT;
                    end
                end

                ST_WAIT_OUT: begin
                    if (!host_req)
                        host_ack <= 1'b0;
                    // Result is held stable until the consumer acknowledges it.
                    if (out_ack) begin
                        out_valid <= 1'b0;
                        state <= ST_WAIT_RELEASE;
                    end
                end

                ST_WAIT_RELEASE: begin
                    if (!host_req)
                        host_ack <= 1'b0;
                    if (!out_ack && !host_req && !host_ack) begin
                        branch_b_done <= 1'b0;
                        branch_c_done <= 1'b0;
                        state <= ST_IDLE;
                    end
                end

                default: state <= ST_IDLE;
            endcase
        end
    end
endmodule
