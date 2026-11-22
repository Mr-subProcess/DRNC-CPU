// SPDX-License-Identifier: LicenseRef-RAQM-Research-Only-No-Commercial-Production-1.0
`timescale 1ns/1ps
module tb_raqm_vector_core;
    localparam integer LANES = 4;
    localparam integer DATA_W = LANES * 2;

    logic clk = 0;
    logic resetn = 0;
    logic enable = 0;
    logic clear_feedback = 0;
    logic s_valid = 0;
    logic s_ready;
    logic [DATA_W-1:0] s_data = '0;
    logic [7:0] s_user = '0;
    logic [DATA_W/8-1:0] s_keep = '1;
    logic s_last = 0;
    logic m_valid;
    logic m_ready = 1;
    logic [DATA_W-1:0] m_data;
    logic [7:0] m_user;
    logic [DATA_W/8-1:0] m_keep;
    logic m_last;
    logic dbg_b, dbg_c, dbg_join, dbg_feedback;

    always #5 clk = ~clk;

    raqm_vector_core #(.LANES(LANES), .DATA_W(DATA_W)) dut (
        .aclk(clk), .aresetn(resetn), .engine_enable(enable),
        .clear_feedback(clear_feedback),
        .s_axis_tvalid(s_valid), .s_axis_tready(s_ready),
        .s_axis_tdata(s_data), .s_axis_tkeep(s_keep), .s_axis_tuser(s_user), .s_axis_tlast(s_last),
        .m_axis_tvalid(m_valid), .m_axis_tready(m_ready),
        .m_axis_tdata(m_data), .m_axis_tkeep(m_keep), .m_axis_tuser(m_user), .m_axis_tlast(m_last),
        .dbg_branch_b_valid(dbg_b), .dbg_branch_c_valid(dbg_c),
        .dbg_join_valid(dbg_join), .dbg_feedback_valid(dbg_feedback)
    );

    task automatic send_check(
        input logic [DATA_W-1:0] data,
        input logic [7:0] cfg,
        input logic last,
        input logic [DATA_W-1:0] expected_data,
        input logic [7:0] expected_status,
        input logic expected_b,
        input logic expected_c,
        input logic expected_join
    );
        begin
            @(negedge clk);
            while (!s_ready) @(negedge clk);
            s_data = data;
            s_keep = '1;
            s_user = cfg;
            s_last = last;
            s_valid = 1'b1;
            @(posedge clk);
            #1;
            if (!s_ready) $fatal(1, "input was not ready at transfer");
            if (!m_valid) $fatal(1, "missing output valid");
            if (m_data !== expected_data)
                $fatal(1, "data got=%h expected=%h", m_data, expected_data);
            if (m_user !== expected_status)
                $fatal(1, "status got=%h expected=%h", m_user, expected_status);
            if (m_last !== last) $fatal(1, "TLAST mismatch");
            if (m_keep !== {DATA_W/8{1'b1}}) $fatal(1, "TKEEP output mismatch");
            if (dbg_b !== expected_b || dbg_c !== expected_c || dbg_join !== expected_join)
                $fatal(1, "branch/join debug mismatch B=%b C=%b JOIN=%b", dbg_b, dbg_c, dbg_join);
            @(negedge clk);
            s_valid = 1'b0;
            s_last = 1'b0;
            @(posedge clk);
            #1;
            if (m_valid) $fatal(1, "output did not retire");
        end
    endtask

    task automatic clear_fb;
        begin
            @(negedge clk); clear_feedback = 1'b1;
            @(posedge clk); #1;
            @(negedge clk); clear_feedback = 1'b0;
        end
    endtask

    initial begin
        repeat (3) @(negedge clk);
        resetn = 1'b1;
        repeat (2) @(negedge clk);

        if (s_ready) $fatal(1, "engine must default disabled");
        enable = 1'b1;
        @(negedge clk);

        // All symbols including 00 are ordinary data. Fork both; mask B=00.
        send_check(8'b11_10_01_00, 8'b00_00_00_11, 1'b1,
                   8'b11_10_01_00, 8'h00, 1'b1, 1'b1, 1'b1);

        // Back-to-back stream transfers: one beat retires while the next is accepted.
        @(negedge clk);
        while (!s_ready) @(negedge clk);
        s_data = 8'h00; s_keep = '1; s_user = 8'b00_00_00_11; s_last = 1'b0; s_valid = 1'b1;
        @(posedge clk); #1;
        if (!m_valid || m_data !== 8'h00) $fatal(1, "first back-to-back beat failed");
        @(negedge clk);
        s_data = 8'hFF; // Keep TVALID asserted; change payload for the next handshake.
        @(posedge clk); #1;
        if (!m_valid || m_data !== 8'hFF) $fatal(1, "second back-to-back beat failed");
        @(negedge clk); s_valid = 1'b0;
        @(posedge clk); #1;
        if (m_valid) $fatal(1, "back-to-back output did not drain");

        // B/C fork executes both branches; select B, XOR 01.
        send_check(8'b11_10_01_00, 8'b00_01_0_0_11, 1'b0,
                   8'b10_11_00_01, 8'h00, 1'b1, 1'b1, 1'b1);

        // C-only branch, XOR mask C=10.
        send_check(8'b11_10_01_00, 8'b10_10_0_1_10, 1'b0,
                   8'b01_00_11_10, 8'h00, 1'b0, 1'b1, 1'b0);

        // B-only branch with an incompatible merge selection is rejected.
        send_check(8'b11_10_01_00, 8'b00_00_0_1_01, 1'b0,
                   8'h00, 8'h02, 1'b0, 1'b0, 1'b0);

        // Explicitly clear feedback, then feedback without a history is rejected.
        clear_fb();
        if (dbg_feedback) $fatal(1, "feedback valid did not clear");
        send_check(8'b00_00_00_00, 8'b00_00_1_0_11, 1'b0,
                   8'h00, 8'h03, 1'b0, 1'b0, 1'b0);

        // Create a known feedback vector, then transform the prior result.
        send_check(8'b11_10_01_00, 8'b00_01_0_0_11, 1'b0,
                   8'b10_11_00_01, 8'h00, 1'b1, 1'b1, 1'b1);
        send_check(8'b00_00_00_00, 8'b10_10_1_1_10, 1'b0,
                   8'b00_01_10_11, 8'h00, 1'b0, 1'b1, 1'b1);

        // Backpressure: output must remain stable and upstream not-ready.
        @(negedge clk);
        m_ready = 1'b0;
        while (!s_ready) @(negedge clk);
        s_data = 8'b01_10_11_00;
        s_keep = '1;
        s_user = 8'b00_00_00_11;
        s_last = 1'b1;
        s_valid = 1'b1;
        @(posedge clk); #1;
        if (!m_valid || m_data !== 8'b01_10_11_00 || !m_last || m_keep !== 1'b1 || m_user !== 8'h00)
            $fatal(1, "stalled output initial value mismatch");
        repeat (4) begin
            @(posedge clk); #1;
            if (!m_valid || m_data !== 8'b01_10_11_00 || !m_last || m_keep !== 1'b1 || m_user !== 8'h00)
                $fatal(1, "output changed during backpressure");
            if (s_ready) $fatal(1, "input ready asserted while output stalled");
        end
        @(negedge clk); s_valid = 1'b0; m_ready = 1'b1;
        @(posedge clk); #1;
        if (m_valid) $fatal(1, "stalled output did not retire");

        // Disabling the engine must stop new input acceptance but must not
        // freeze an already-valid result when the consumer accepts it.
        @(negedge clk); m_ready = 1'b0;
        while (!s_ready) @(negedge clk);
        s_data = 8'hA5; s_keep = '1; s_user = 8'b00_00_00_11; s_valid = 1'b1;
        @(posedge clk); #1;
        if (!m_valid || m_data !== 8'hA5) $fatal(1, "disable/drain setup failed");
        @(negedge clk); s_valid = 1'b0; enable = 1'b0; m_ready = 1'b1;
        @(posedge clk); #1;
        if (m_valid) $fatal(1, "engine disable froze pending output");
        @(negedge clk); enable = 1'b1;

        // Fixed-width RAQM vector beats require every byte lane to be present.
        // Clear history first, then prove a malformed TKEEP beat cannot seed it.
        clear_fb();
        @(negedge clk);
        while (!s_ready) @(negedge clk);
        s_data = 8'hA5; s_keep = '0; s_user = 8'b00_00_00_11; s_last = 1'b0; s_valid = 1'b1;
        @(posedge clk); #1;
        if (!m_valid || m_user !== 8'h04 || m_data !== 8'h00)
            $fatal(1, "bad TKEEP was not rejected");
        @(negedge clk); s_valid = 1'b0; s_keep = '1;
        @(posedge clk); #1;
        if (m_valid) $fatal(1, "bad TKEEP output did not retire");
        send_check(8'h00, 8'b00_00_1_0_11, 1'b0,
                   8'h00, 8'h03, 1'b0, 1'b0, 1'b0);

        // Invalid branch code 00 is a control error, not a payload symbol.
        send_check(8'h00, 8'b00_00_0_0_00, 1'b0,
                   8'h00, 8'h01, 1'b0, 1'b0, 1'b0);

        $display("PASS: RAQM vector core symbols/fork/join/feedback/errors/backpressure/TLAST");
        $finish;
    end
endmodule
