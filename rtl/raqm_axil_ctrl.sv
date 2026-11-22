// SPDX-License-Identifier: LicenseRef-RAQM-Research-Only-No-Commercial-Production-1.0
`timescale 1ns/1ps
// AXI4-Lite control/status slave. One outstanding read and write are supported.
// AW and W are captured independently. Unsupported, read-only write, write-only
// read, and unaligned accesses return SLVERR; response payloads remain stable
// until the corresponding READY handshake.
module raqm_axil_ctrl (
    input  logic        aclk,
    input  logic        aresetn,

    input  logic [31:0] s_axi_awaddr,
    input  logic [2:0]  s_axi_awprot,
    input  logic        s_axi_awvalid,
    output logic        s_axi_awready,
    input  logic [31:0] s_axi_wdata,
    input  logic [3:0]  s_axi_wstrb,
    input  logic        s_axi_wvalid,
    output logic        s_axi_wready,
    output logic [1:0]  s_axi_bresp,
    output logic        s_axi_bvalid,
    input  logic        s_axi_bready,

    input  logic [31:0] s_axi_araddr,
    input  logic [2:0]  s_axi_arprot,
    input  logic        s_axi_arvalid,
    output logic        s_axi_arready,
    output logic [31:0] s_axi_rdata,
    output logic [1:0]  s_axi_rresp,
    output logic        s_axi_rvalid,
    input  logic        s_axi_rready,

    output logic        engine_enable,
    output logic        clear_feedback,
    output logic        cfg_override,
    output logic [7:0]  cfg_tuser,

    input  logic        stream_accept,
    input  logic        stream_complete,
    input  logic        stream_error,
    input  logic        feedback_valid,
    input  logic        stream_ready,
    input  logic        stream_out_valid,
    input  logic [7:0]  stream_last_status
);
    localparam logic [31:0] REG_CTRL       = 32'h0000_0000;
    localparam logic [31:0] REG_CFG        = 32'h0000_0004;
    localparam logic [31:0] REG_STATUS     = 32'h0000_0008;
    localparam logic [31:0] REG_ACCEPTED   = 32'h0000_000C;
    localparam logic [31:0] REG_COMPLETED  = 32'h0000_0010;
    localparam logic [31:0] REG_ERRORS     = 32'h0000_0014;
    localparam logic [31:0] REG_LASTSTATUS = 32'h0000_0018;
    localparam logic [31:0] REG_COUNT_CLR  = 32'h0000_001C;

    logic [31:0] awaddr_q;
    logic        aw_captured;
    logic [31:0] wdata_q;
    logic [3:0]  wstrb_q;
    logic        w_captured;
    logic [31:0] ctrl_q;
    logic [31:0] cfg_q;
    logic [31:0] accepted_count_q;
    logic [31:0] completed_count_q;
    logic [31:0] error_count_q;
    logic [7:0]  last_status_q;
    logic [31:0] read_mux;
    logic [1:0]  bresp_q;
    logic [1:0]  rresp_q;
    integer      byte_index;

    function automatic logic write_addr_valid(input logic [31:0] addr);
        begin
            if (addr[1:0] != 2'b00) write_addr_valid = 1'b0;
            else begin
                case (addr)
                    REG_CTRL, REG_CFG, REG_COUNT_CLR: write_addr_valid = 1'b1;
                    default: write_addr_valid = 1'b0;
                endcase
            end
        end
    endfunction

    function automatic logic read_addr_valid(input logic [31:0] addr);
        begin
            if (addr[1:0] != 2'b00) read_addr_valid = 1'b0;
            else begin
                case (addr)
                    REG_CTRL, REG_CFG, REG_STATUS, REG_ACCEPTED,
                    REG_COMPLETED, REG_ERRORS, REG_LASTSTATUS:
                        read_addr_valid = 1'b1;
                    default: read_addr_valid = 1'b0;
                endcase
            end
        end
    endfunction

    // PROT attributes are accepted but this peripheral does not implement a
    // privilege/security policy. The system interconnect must enforce that.
    assign s_axi_awready = aresetn && !aw_captured && !s_axi_bvalid;
    assign s_axi_wready  = aresetn && !w_captured  && !s_axi_bvalid;
    assign s_axi_bresp   = bresp_q;
    assign s_axi_arready = aresetn && !s_axi_rvalid;
    assign s_axi_rresp   = rresp_q;

    assign engine_enable = ctrl_q[0];
    assign cfg_override  = ctrl_q[2];
    assign cfg_tuser     = cfg_q[7:0];

    always_comb begin
        read_mux = 32'h0000_0000;
        case (s_axi_araddr)
            REG_CTRL:       read_mux = {29'd0, cfg_override, 1'b0, engine_enable};
            REG_CFG:        read_mux = cfg_q;
            REG_STATUS:     read_mux = {24'd0, (last_status_q != 8'h00),
                                        stream_ready, stream_out_valid,
                                        feedback_valid, cfg_override,
                                        engine_enable, 2'b00};
            REG_ACCEPTED:   read_mux = accepted_count_q;
            REG_COMPLETED:  read_mux = completed_count_q;
            REG_ERRORS:     read_mux = error_count_q;
            REG_LASTSTATUS: read_mux = {24'd0, last_status_q};
            default:        read_mux = 32'h0000_0000;
        endcase
    end

    always_ff @(posedge aclk) begin
        if (!aresetn) begin
            awaddr_q          <= 32'h0000_0000;
            aw_captured       <= 1'b0;
            wdata_q           <= 32'h0;
            wstrb_q           <= 4'h0;
            w_captured        <= 1'b0;
            ctrl_q            <= 32'h0;          // fail-safe disabled
            cfg_q             <= 32'h0000_0003; // fork B+C, select B, no masks
            s_axi_bvalid      <= 1'b0;
            s_axi_rvalid      <= 1'b0;
            s_axi_rdata       <= 32'h0;
            bresp_q           <= 2'b00;
            rresp_q           <= 2'b00;
            clear_feedback    <= 1'b0;
            accepted_count_q  <= 32'h0;
            completed_count_q <= 32'h0;
            error_count_q     <= 32'h0;
            last_status_q     <= 8'h00;
        end else begin
            clear_feedback <= 1'b0;

            if (stream_accept)
                accepted_count_q <= accepted_count_q + 1'b1;
            if (stream_complete) begin
                completed_count_q <= completed_count_q + 1'b1;
                last_status_q <= stream_last_status;
            end
            if (stream_error)
                error_count_q <= error_count_q + 1'b1;

            if (s_axi_awvalid && s_axi_awready) begin
                awaddr_q    <= s_axi_awaddr;
                aw_captured <= 1'b1;
            end
            if (s_axi_wvalid && s_axi_wready) begin
                wdata_q    <= s_axi_wdata;
                wstrb_q    <= s_axi_wstrb;
                w_captured <= 1'b1;
            end

            if (s_axi_bvalid && s_axi_bready)
                s_axi_bvalid <= 1'b0;

            if (aw_captured && w_captured && !s_axi_bvalid) begin
                if (!write_addr_valid(awaddr_q)) begin
                    bresp_q <= 2'b10; // SLVERR; invalid writes have no side effects.
                end else begin
                    bresp_q <= 2'b00;
                    case (awaddr_q)
                        REG_CTRL: begin
                            for (byte_index = 0; byte_index < 4; byte_index = byte_index + 1) begin
                                if (wstrb_q[byte_index] && (byte_index == 0)) begin
                                    ctrl_q[0] <= wdata_q[0];
                                    ctrl_q[2] <= wdata_q[2];
                                    if (wdata_q[1]) clear_feedback <= 1'b1;
                                end
                            end
                        end
                        REG_CFG: begin
                            for (byte_index = 0; byte_index < 4; byte_index = byte_index + 1)
                                if (wstrb_q[byte_index])
                                    cfg_q[(byte_index*8) +: 8] <= wdata_q[(byte_index*8) +: 8];
                        end
                        REG_COUNT_CLR: begin
                            if (wstrb_q[0] && wdata_q[0]) begin
                                accepted_count_q  <= 32'h0;
                                completed_count_q <= 32'h0;
                                error_count_q     <= 32'h0;
                            end
                        end
                        default: begin end
                    endcase
                end
                aw_captured <= 1'b0;
                w_captured  <= 1'b0;
                s_axi_bvalid <= 1'b1;
            end

            if (s_axi_arvalid && s_axi_arready) begin
                if (read_addr_valid(s_axi_araddr)) begin
                    s_axi_rdata <= read_mux;
                    rresp_q <= 2'b00;
                end else begin
                    s_axi_rdata <= 32'h0;
                    rresp_q <= 2'b10; // SLVERR; no aliasing of unaligned/unknown addresses.
                end
                s_axi_rvalid <= 1'b1;
            end else if (s_axi_rvalid && s_axi_rready) begin
                s_axi_rvalid <= 1'b0;
            end
        end
    end
endmodule
