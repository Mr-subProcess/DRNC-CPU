// SPDX-License-Identifier: LicenseRef-RAQM-Research-Only-No-Commercial-Production-1.0
`timescale 1ns/1ps
module tb_raqm_axil_ctrl;
    logic clk = 0;
    logic resetn = 0;
    always #5 clk = ~clk;

    logic [31:0] awaddr=0, araddr=0;
    logic [2:0] awprot=3'b000, arprot=3'b000;
    logic awvalid=0, awready;
    logic [31:0] wdata=0, rdata;
    logic [3:0] wstrb=0;
    logic wvalid=0, wready;
    logic [1:0] bresp, rresp;
    logic bvalid, bready=0;
    logic arvalid=0, arready, rvalid, rready=0;
    logic engine_enable, clear_feedback, cfg_override;
    logic [7:0] cfg_tuser;
    logic stream_accept=0, stream_complete=0, stream_error=0;
    logic feedback_valid=0, stream_ready=0, stream_out_valid=0;
    logic [7:0] stream_last_status=0;
    logic clear_seen=0;

    always @(posedge clk) begin
        if (!resetn) clear_seen <= 1'b0;
        else if (clear_feedback) clear_seen <= 1'b1;
    end

    raqm_axil_ctrl dut (
        .aclk(clk), .aresetn(resetn),
        .s_axi_awaddr(awaddr), .s_axi_awprot(awprot), .s_axi_awvalid(awvalid), .s_axi_awready(awready),
        .s_axi_wdata(wdata), .s_axi_wstrb(wstrb), .s_axi_wvalid(wvalid), .s_axi_wready(wready),
        .s_axi_bresp(bresp), .s_axi_bvalid(bvalid), .s_axi_bready(bready),
        .s_axi_araddr(araddr), .s_axi_arprot(arprot), .s_axi_arvalid(arvalid), .s_axi_arready(arready),
        .s_axi_rdata(rdata), .s_axi_rresp(rresp), .s_axi_rvalid(rvalid), .s_axi_rready(rready),
        .engine_enable(engine_enable), .clear_feedback(clear_feedback),
        .cfg_override(cfg_override), .cfg_tuser(cfg_tuser),
        .stream_accept(stream_accept), .stream_complete(stream_complete),
        .stream_error(stream_error), .feedback_valid(feedback_valid),
        .stream_ready(stream_ready), .stream_out_valid(stream_out_valid),
        .stream_last_status(stream_last_status)
    );

    logic [1:0] last_bresp, last_rresp;

    task automatic write_reg(input logic [31:0] addr, input logic [31:0] value);
        begin
            // Deliberately separate AW and W handshakes.
            @(negedge clk); awaddr=addr; awvalid=1;
            do @(posedge clk); while (!awready);
            @(negedge clk); awvalid=0; wdata=value; wstrb=4'hF; wvalid=1;
            do @(posedge clk); while (!wready);
            @(negedge clk); wvalid=0; bready=0;
            do @(posedge clk); while (!bvalid);
            last_bresp = bresp;
            // Verify response payload remains stable while BREADY is low.
            repeat (2) begin
                @(posedge clk);
                if (!bvalid || bresp !== last_bresp)
                    $fatal(1, "B response changed while stalled");
            end
            @(negedge clk); bready=1;
            @(posedge clk);
            @(negedge clk); bready=0;
        end
    endtask

    task automatic read_reg(input logic [31:0] addr, output logic [31:0] value);
        begin
            @(negedge clk); araddr=addr; arvalid=1;
            do @(posedge clk); while (!arready);
            @(negedge clk); arvalid=0; rready=0;
            do @(posedge clk); while (!rvalid);
            value = rdata;
            last_rresp = rresp;
            // Verify RDATA/RRESP remain stable while RREADY is low.
            repeat (2) begin
                @(posedge clk);
                if (!rvalid || rdata !== value || rresp !== last_rresp)
                    $fatal(1, "R response changed while stalled");
            end
            @(negedge clk); rready=1;
            @(posedge clk);
            @(negedge clk); rready=0;
        end
    endtask

    logic [31:0] got;
    initial begin
        repeat (3) @(negedge clk);
        resetn=1;
        repeat (2) @(negedge clk);
        if (engine_enable) $fatal(1, "engine not fail-safe disabled after reset");

        write_reg(8'h00, 32'h0000_0005); // ENABLE + CFG_OVERRIDE
        if (last_bresp !== 2'b00) $fatal(1, "legal CTRL write returned error");
        if (!engine_enable || !cfg_override) $fatal(1, "CTRL write failed");

        write_reg(8'h04, 32'h0000_00B3);
        if (cfg_tuser !== 8'hB3) $fatal(1, "CFG write failed");

        write_reg(8'h00, 32'h0000_0007); // bit1 is a clear-feedback pulse
        if (!clear_seen) $fatal(1, "CLEAR_FEEDBACK pulse was not observed");
        if (clear_feedback) $fatal(1, "CLEAR_FEEDBACK should be a one-cycle pulse");

        stream_accept=1; @(posedge clk); #1; stream_accept=0;
        stream_complete=1; stream_error=1; stream_last_status=8'h02;
        @(posedge clk); #1; stream_complete=0; stream_error=0;

        read_reg(8'h00, got); if (last_rresp !== 2'b00) $fatal(1, "legal CTRL read returned error");
        if (got[2:0] !== 3'b101) $fatal(1, "CTRL readback=%h", got);
        read_reg(8'h04, got); if (got[7:0] !== 8'hB3) $fatal(1, "CFG readback=%h", got);
        read_reg(32'h0000_0100, got); if (got !== 0 || last_rresp !== 2'b10) $fatal(1, "high unsupported address did not SLVERR: data=%h resp=%b", got, last_rresp);
        write_reg(32'h0000_0104, 32'hFFFF_FFFF);
        if (last_bresp !== 2'b10) $fatal(1, "invalid write did not return SLVERR");
        write_reg(32'h0000_0005, 32'hFFFF_FFFF);
        if (last_bresp !== 2'b10) $fatal(1, "unaligned write did not return SLVERR");
        write_reg(32'h0000_000C, 32'hFFFF_FFFF);
        if (last_bresp !== 2'b10) $fatal(1, "write to read-only register did not return SLVERR");
        read_reg(32'h0000_0005, got);
        if (last_rresp !== 2'b10) $fatal(1, "unaligned read did not return SLVERR");
        read_reg(8'h04, got); if (got[7:0] !== 8'hB3) $fatal(1, "high address write aliased into CFG: %h", got);
        read_reg(8'h0C, got); if (got !== 1) $fatal(1, "accepted count=%h", got);
        read_reg(8'h10, got); if (got !== 1) $fatal(1, "completed count=%h", got);
        read_reg(8'h14, got); if (got !== 1) $fatal(1, "error count=%h", got);
        read_reg(8'h18, got); if (got[7:0] !== 8'h02) $fatal(1, "last status=%h", got);

        write_reg(8'h1C, 32'h0000_0001);
        read_reg(8'h0C, got); if (got !== 0) $fatal(1, "counter clear failed");
        $display("PASS: RAQM AXI-Lite independent channels/control/config/counters");
        $finish;
    end
endmodule
