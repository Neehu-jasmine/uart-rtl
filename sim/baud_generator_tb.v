`timescale 1ns / 1ps

module baud_generator_tb;

    // Testbench signals
    reg clk;
    reg reset;
    wire baud_tick;

    // Instantiate DUT
    baud_generator #(
        .CLKS_PER_BIT(10416)
    ) dut (
        .clk(clk),
        .reset(reset),
        .baud_tick(baud_tick)
    );

    // 100 MHz clock → 10 ns period
    always #5 clk = ~clk;

    initial begin
        // Initial values
        clk   = 1'b0;
        reset = 1'b1;

        // Hold reset for a few clock cycles
        #50;
        reset = 1'b0;

        // Run long enough to observe several baud ticks
        #315000;

        $finish;
    end

endmodule
