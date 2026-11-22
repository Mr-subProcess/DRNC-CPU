// SPDX-License-Identifier: LicenseRef-RAQM-Research-Only-No-Commercial-Production-1.0
`timescale 1ns/1ps
module tb_raqm_core;
    logic clk = 0;
    always #5 clk = ~clk; // 100 MHz

    logic resetn = 0;
    logic host_req = 0;
    logic host_ack;
    logic [1:0] host_data = 0;
    logic [1:0] branch_mode = 2'b11;
    logic merge_sel = 0;
    logic feedback_en = 0;
    logic [1:0] mask_b = 0, mask_c = 0;
    logic ready, out_valid, out_ack = 0;
    logic [1:0] out_data;
    logic [7:0] out_status;
    logic b_done, c_done, join_done;

    raqm_core #(.B_LATENCY(3), .C_LATENCY(4)) dut (
        .clk(clk), .resetn(resetn),
        .host_req(host_req), .host_ack(host_ack), .host_data(host_data),
        .branch_mode(branch_mode), .merge_sel(merge_sel),
        .feedback_en(feedback_en), .mask_b(mask_b), .mask_c(mask_c),
        .ready(ready), .out_valid(out_valid), .out_ack(out_ack),
        .out_data(out_data), .out_status(out_status),
        .branch_b_done(b_done), .branch_c_done(c_done), .join_done(join_done)
    );

    task automatic run_token(input logic [1:0] data,
                             input logic [1:0] mode,
                             input logic sel,
                             input logic [1:0] mb,
                             input logic [1:0] mc,
                             input logic fb,
                             input logic [1:0] expected,
                             input logic [7:0] expected_status);
        integer timeout;
        begin
            wait (ready);
            @(negedge clk);
            host_data = data;
            branch_mode = mode;
            merge_sel = sel;
            mask_b = mb;
            mask_c = mc;
            feedback_en = fb;
            host_req = 1;
            timeout = 0;
            while (!host_ack && timeout < 100) begin @(posedge clk); timeout = timeout + 1; end
            if (!host_ack) $fatal(1, "timeout waiting for HOST_ACK");
            @(negedge clk); host_req = 0;
            timeout = 0;
            while (host_ack && timeout < 100) begin @(posedge clk); timeout = timeout + 1; end
            if (host_ack) $fatal(1, "timeout waiting for HOST_ACK return-to-zero");
            timeout = 0;
            while (!out_valid && timeout < 100) begin @(posedge clk); timeout = timeout + 1; end
            if (!out_valid) $fatal(1, "timeout waiting for OUT_VALID");
            if (out_status !== expected_status)
                $fatal(1, "status mismatch got=%h expected=%h", out_status, expected_status);
            if (out_data !== expected)
                $fatal(1, "data mismatch got=%b expected=%b", out_data, expected);
            @(negedge clk); out_ack = 1;
            @(negedge clk); out_ack = 0;
            timeout = 0;
            while (!ready && timeout < 100) begin @(posedge clk); timeout = timeout + 1; end
            if (!ready) $fatal(1, "timeout waiting for READY");
        end
    endtask

    initial begin
        repeat (5) @(posedge clk);
        resetn = 1;
        repeat (2) @(posedge clk);

        // All four 2-bit values are valid payload symbols, including 00.
        run_token(2'b00, 2'b11, 1'b0, 2'b00, 2'b00, 1'b0, 2'b00, 8'h00);
        run_token(2'b01, 2'b11, 1'b0, 2'b00, 2'b00, 1'b0, 2'b01, 8'h00);
        run_token(2'b10, 2'b11, 1'b0, 2'b00, 2'b00, 1'b0, 2'b10, 8'h00);
        run_token(2'b11, 2'b11, 1'b0, 2'b00, 2'b00, 1'b0, 2'b11, 8'h00);

        // Both branches execute; select B. B = 01 XOR 01 = 00.
        run_token(2'b01, 2'b11, 1'b0, 2'b01, 2'b10, 1'b0, 2'b00, 8'h00);
        // Both branches execute; select C. C = 01 XOR 10 = 11.
        run_token(2'b01, 2'b11, 1'b1, 2'b01, 2'b10, 1'b0, 2'b11, 8'h00);
        // Feedback uses previous selected output (11); C path: 11 XOR 01 = 10.
        run_token(2'b00, 2'b10, 1'b1, 2'b00, 2'b01, 1'b1, 2'b10, 8'h00);

        $display("PASS: RAQM core handshake, all symbols, fork/join, merge and feedback.");
        $finish;
    end
endmodule
