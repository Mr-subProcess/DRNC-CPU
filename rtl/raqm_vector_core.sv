// SPDX-License-Identifier: LicenseRef-RAQM-Research-Only-No-Commercial-Production-1.0
`timescale 1ns/1ps
// RAQM 128-lane synchronous fork/join datapath.
// 128 lanes x 2 bits = 256-bit AXI4-Stream beat.
// All 2-bit payload values are data; AXIS TVALID/TREADY define beat presence.
// B and C transforms are evaluated in parallel. The selected branch result is
// committed to a one-entry elastic output register and optional feedback state.
// This is a synchronous FPGA implementation, NOT a clockless/QDI circuit.
module raqm_vector_core #(
    parameter integer LANES = 128,
    parameter integer DATA_W = LANES * 2,
    parameter integer KEEP_W = DATA_W / 8
) (
    input  logic                  aclk,
    input  logic                  aresetn,
    input  logic                  engine_enable,
    input  logic                  clear_feedback,

    input  logic                  s_axis_tvalid,
    output logic                  s_axis_tready,
    input  logic [DATA_W-1:0]     s_axis_tdata,
    input  logic [KEEP_W-1:0]     s_axis_tkeep,
    input  logic [7:0]            s_axis_tuser,
    input  logic                  s_axis_tlast,

    output logic                  m_axis_tvalid,
    input  logic                  m_axis_tready,
    output logic [DATA_W-1:0]     m_axis_tdata,
    output logic [KEEP_W-1:0]     m_axis_tkeep,
    output logic [7:0]            m_axis_tuser,
    output logic                  m_axis_tlast,

    output logic                  dbg_branch_b_valid,
    output logic                  dbg_branch_c_valid,
    output logic                  dbg_join_valid,
    output logic                  dbg_feedback_valid
);
    localparam logic [7:0] STATUS_OK          = 8'h00;
    localparam logic [7:0] STATUS_BAD_BRANCH  = 8'h01;
    localparam logic [7:0] STATUS_BAD_MERGE   = 8'h02;
    localparam logic [7:0] STATUS_NO_FEEDBACK = 8'h03;
    localparam logic [7:0] STATUS_BAD_TKEEP  = 8'h04;
    localparam logic [KEEP_W-1:0] KEEP_ALL = {KEEP_W{1'b1}};

    logic [DATA_W-1:0] feedback_q;
    logic              feedback_valid_q;
    logic [DATA_W-1:0] source_data;
    logic [DATA_W-1:0] branch_b_data;
    logic [DATA_W-1:0] branch_c_data;
    logic [DATA_W-1:0] selected_data;
    logic [1:0]        branch_mode;
    logic              merge_sel;
    logic              feedback_en;
    logic              output_slot_ready;
    logic              input_accept;
    logic [1:0]        mask_b;
    logic [1:0]        mask_c;
    integer            lane;

    assign branch_mode = s_axis_tuser[1:0];
    assign merge_sel   = s_axis_tuser[2];
    assign feedback_en = s_axis_tuser[3];
    assign mask_b      = s_axis_tuser[5:4];
    assign mask_c      = s_axis_tuser[7:6];

    // A single-entry elastic output stage. Output payload and sidebands are
    // stable while TVALID=1 and TREADY=0. No input is accepted in that state.
    assign output_slot_ready = !m_axis_tvalid || m_axis_tready;
    assign s_axis_tready = aresetn && engine_enable && !clear_feedback &&
                           output_slot_ready;
    assign input_accept = s_axis_tvalid && s_axis_tready;

    always_comb begin
        source_data   = feedback_en ? feedback_q : s_axis_tdata;
        branch_b_data = '0;
        branch_c_data = '0;
        for (lane = 0; lane < LANES; lane = lane + 1) begin
            branch_b_data[(lane*2) +: 2] = source_data[(lane*2) +: 2] ^ mask_b;
            branch_c_data[(lane*2) +: 2] = source_data[(lane*2) +: 2] ^ mask_c;
        end
        selected_data = merge_sel ? branch_c_data : branch_b_data;
    end

    always_ff @(posedge aclk) begin
        if (!aresetn) begin
            m_axis_tvalid      <= 1'b0;
            m_axis_tdata       <= '0;
            m_axis_tkeep       <= KEEP_ALL;
            m_axis_tuser       <= STATUS_OK;
            m_axis_tlast       <= 1'b0;
            feedback_q         <= '0;
            feedback_valid_q   <= 1'b0;
            dbg_branch_b_valid <= 1'b0;
            dbg_branch_c_valid <= 1'b0;
            dbg_join_valid     <= 1'b0;
        end else begin
            if (clear_feedback) begin
                feedback_q       <= '0;
                feedback_valid_q <= 1'b0;
            end

            // A pending output can always retire when downstream is ready,
            // even if software disables new input acceptance in the meantime.
            if (output_slot_ready) begin
                m_axis_tvalid      <= input_accept;
                dbg_branch_b_valid <= 1'b0;
                dbg_branch_c_valid <= 1'b0;
                dbg_join_valid     <= 1'b0;

                if (input_accept) begin
                    m_axis_tkeep <= KEEP_ALL;
                    m_axis_tlast <= s_axis_tlast;

                    if (s_axis_tkeep != KEEP_ALL) begin
                        m_axis_tdata <= '0;
                        m_axis_tuser <= STATUS_BAD_TKEEP;
                    end else if (branch_mode == 2'b00) begin
                        m_axis_tdata <= '0;
                        m_axis_tuser <= STATUS_BAD_BRANCH;
                    end else if (((branch_mode == 2'b01) && merge_sel) ||
                                 ((branch_mode == 2'b10) && !merge_sel)) begin
                        m_axis_tdata <= '0;
                        m_axis_tuser <= STATUS_BAD_MERGE;
                    end else if (feedback_en && !feedback_valid_q) begin
                        m_axis_tdata <= '0;
                        m_axis_tuser <= STATUS_NO_FEEDBACK;
                    end else begin
                        dbg_branch_b_valid <= branch_mode[0];
                        dbg_branch_c_valid <= branch_mode[1];
                        // Join is asserted only when both B and C participated.
                        dbg_join_valid     <= (branch_mode == 2'b11);
                        m_axis_tdata       <= selected_data;
                        m_axis_tuser       <= STATUS_OK;
                        if (!clear_feedback) begin
                            feedback_q       <= selected_data;
                            feedback_valid_q <= 1'b1;
                        end
                    end
                end
            end
        end
    end

    assign dbg_feedback_valid = feedback_valid_q;

`ifndef SYNTHESIS
    initial begin
        if ((DATA_W % 8) != 0)
            $error("DATA_W must be byte-aligned for AXI4-Stream TKEEP");
        if (DATA_W != (LANES * 2))
            $error("DATA_W must equal LANES*2 for the RAQM symbol format");
    end
`endif
endmodule
