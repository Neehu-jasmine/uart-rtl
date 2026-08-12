`timescale 1ns / 1ps

module baud_generator #(
    parameter integer CLKS_PER_BIT = 10416
)(
    input  wire clk,
    input  wire reset,
    output reg  baud_tick
);

    integer count;

    always @(posedge clk) begin
        if (reset) begin
            count     <= 0;
            baud_tick <= 1'b0;
        end
        else begin
            if (count == CLKS_PER_BIT - 1) begin
                count     <= 0;
                baud_tick <= 1'b1;
            end
            else begin
                count     <= count + 1;
                baud_tick <= 1'b0;
            end
        end
    end

endmodule
