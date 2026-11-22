// SPDX-License-Identifier: LicenseRef-RAQM-Research-Only-No-Commercial-Production-1.0
`timescale 1ns/1ps
// Asynchronous assertion, two-clock synchronous deassertion for one PL clock domain.
module raqm_reset_sync (
    input  logic clk,
    input  logic async_resetn,
    output logic resetn
);
    (* ASYNC_REG = "TRUE" *) logic [1:0] sync_ff;

    always_ff @(posedge clk or negedge async_resetn) begin
        if (!async_resetn)
            sync_ff <= 2'b00;
        else
            sync_ff <= {sync_ff[0], 1'b1};
    end

    assign resetn = sync_ff[1];
endmodule
