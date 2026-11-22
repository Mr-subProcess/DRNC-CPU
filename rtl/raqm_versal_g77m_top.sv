// SPDX-License-Identifier: LicenseRef-RAQM-Research-Only-No-Commercial-Production-1.0
`timescale 1ns/1ps
// Product datapath wrapper for iWave G77M / AMD Versal AI Edge Gen 2.
// This is an RTL IP boundary intended for instantiation inside a Vivado
// CIPS/NoC platform design. It is not a complete CIPS design or board top.
// AXI4-Lite and AXI4-Stream use the same PL clock/reset domain.
module raqm_versal_g77m_top #(
    parameter integer LANES = 128,
    parameter integer DATA_W = LANES * 2,
    parameter integer KEEP_W = DATA_W / 8
) (
    input  logic                  aclk,
    input  logic                  aresetn_async,

    // AXI4-Lite control/status slave.
    input  logic [31:0]           s_axi_awaddr,
    input  logic [2:0]            s_axi_awprot,
    input  logic                  s_axi_awvalid,
    output logic                  s_axi_awready,
    input  logic [31:0]           s_axi_wdata,
    input  logic [3:0]            s_axi_wstrb,
    input  logic                  s_axi_wvalid,
    output logic                  s_axi_wready,
    output logic [1:0]            s_axi_bresp,
    output logic                  s_axi_bvalid,
    input  logic                  s_axi_bready,
    input  logic [31:0]           s_axi_araddr,
    input  logic [2:0]            s_axi_arprot,
    input  logic                  s_axi_arvalid,
    output logic                  s_axi_arready,
    output logic [31:0]           s_axi_rdata,
    output logic [1:0]            s_axi_rresp,
    output logic                  s_axi_rvalid,
    input  logic                  s_axi_rready,

    // Standard AXI4-Stream input. Full 256-bit beats only; TKEEP must be all 1s.
    input  logic                  s_axis_tvalid,
    output logic                  s_axis_tready,
    input  logic [DATA_W-1:0]     s_axis_tdata,
    input  logic [KEEP_W-1:0]     s_axis_tkeep,
    input  logic [7:0]            s_axis_tuser,
    input  logic                  s_axis_tlast,

    // Standard AXI4-Stream output. TUSER carries an RAQM status byte.
    output logic                  m_axis_tvalid,
    input  logic                  m_axis_tready,
    output logic [DATA_W-1:0]     m_axis_tdata,
    output logic [KEEP_W-1:0]     m_axis_tkeep,
    output logic [7:0]            m_axis_tuser,
    output logic                  m_axis_tlast
);
    logic resetn;
    logic engine_enable, clear_feedback, cfg_override;
    logic [7:0] cfg_tuser, core_tuser;
    logic dbg_b_valid, dbg_c_valid, dbg_join_valid, dbg_feedback_valid;
    logic stream_accept, stream_complete, stream_error;

    raqm_reset_sync u_reset_sync (
        .clk(aclk), .async_resetn(aresetn_async), .resetn(resetn)
    );

    assign core_tuser = cfg_override ? cfg_tuser : s_axis_tuser;
    assign stream_accept = s_axis_tvalid && s_axis_tready;
    assign stream_complete = m_axis_tvalid && m_axis_tready;
    assign stream_error = stream_complete && (m_axis_tuser != 8'h00);

    raqm_axil_ctrl u_axil_ctrl (
        .aclk(aclk), .aresetn(resetn),
        .s_axi_awaddr(s_axi_awaddr), .s_axi_awprot(s_axi_awprot),
        .s_axi_awvalid(s_axi_awvalid), .s_axi_awready(s_axi_awready),
        .s_axi_wdata(s_axi_wdata), .s_axi_wstrb(s_axi_wstrb),
        .s_axi_wvalid(s_axi_wvalid), .s_axi_wready(s_axi_wready),
        .s_axi_bresp(s_axi_bresp), .s_axi_bvalid(s_axi_bvalid),
        .s_axi_bready(s_axi_bready),
        .s_axi_araddr(s_axi_araddr), .s_axi_arprot(s_axi_arprot),
        .s_axi_arvalid(s_axi_arvalid), .s_axi_arready(s_axi_arready),
        .s_axi_rdata(s_axi_rdata), .s_axi_rresp(s_axi_rresp),
        .s_axi_rvalid(s_axi_rvalid), .s_axi_rready(s_axi_rready),
        .engine_enable(engine_enable), .clear_feedback(clear_feedback),
        .cfg_override(cfg_override), .cfg_tuser(cfg_tuser),
        .stream_accept(stream_accept), .stream_complete(stream_complete),
        .stream_error(stream_error), .feedback_valid(dbg_feedback_valid),
        .stream_ready(s_axis_tready), .stream_out_valid(m_axis_tvalid),
        .stream_last_status(m_axis_tuser)
    );

    raqm_vector_core #(
        .LANES(LANES), .DATA_W(DATA_W), .KEEP_W(KEEP_W)
    ) u_vector_core (
        .aclk(aclk), .aresetn(resetn),
        .engine_enable(engine_enable), .clear_feedback(clear_feedback),
        .s_axis_tvalid(s_axis_tvalid), .s_axis_tready(s_axis_tready),
        .s_axis_tdata(s_axis_tdata), .s_axis_tkeep(s_axis_tkeep),
        .s_axis_tuser(core_tuser), .s_axis_tlast(s_axis_tlast),
        .m_axis_tvalid(m_axis_tvalid), .m_axis_tready(m_axis_tready),
        .m_axis_tdata(m_axis_tdata), .m_axis_tkeep(m_axis_tkeep),
        .m_axis_tuser(m_axis_tuser), .m_axis_tlast(m_axis_tlast),
        .dbg_branch_b_valid(dbg_b_valid), .dbg_branch_c_valid(dbg_c_valid),
        .dbg_join_valid(dbg_join_valid), .dbg_feedback_valid(dbg_feedback_valid)
    );
endmodule
