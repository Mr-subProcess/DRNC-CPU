// SPDX-License-Identifier: LicenseRef-RAQM-Research-Only-No-Commercial-Production-1.0
`timescale 1ns/1ps
module tb_raqm_reset_sync;
    logic clk = 0;
    logic async_resetn = 1;
    logic resetn;

    always #5 clk = ~clk;

    raqm_reset_sync dut (
        .clk(clk),
        .async_resetn(async_resetn),
        .resetn(resetn)
    );

    initial begin
        #1;
        async_resetn = 1'b0;
        #1;
        if (resetn !== 1'b0)
            $fatal(1, "reset must assert asynchronously low");

        repeat (2) begin
            @(posedge clk); #1;
            if (resetn !== 1'b0)
                $fatal(1, "reset deasserted while async reset was active");
        end

        @(negedge clk);
        async_resetn = 1'b1;
        @(posedge clk); #1;
        if (resetn !== 1'b0)
            $fatal(1, "reset deasserted after only one clock edge");
        @(posedge clk); #1;
        if (resetn !== 1'b1)
            $fatal(1, "reset did not deassert after two clock edges");

        #2;
        async_resetn = 1'b0;
        #1;
        if (resetn !== 1'b0)
            $fatal(1, "reset assertion was not asynchronous");

        $display("PASS: reset async assertion / two-cycle synchronous deassertion");
        $finish;
    end
endmodule
