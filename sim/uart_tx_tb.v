`timescale 1ns / 1ps

module uart_tx_tb;

    // Testbench signals
    reg        clk;
    reg        reset;
    reg        baud_tick;
    reg [7:0]  data_in;
    reg        start;

    wire       tx;
    wire       busy;

    // DUT
    uart_tx dut (
        .clk       (clk),
        .reset     (reset),
        .baud_tick (baud_tick),
        .data_in   (data_in),
        .start     (start),
        .tx        (tx),
        .busy      (busy)
    );

    // 100 MHz clock
    always #5 clk = ~clk;

    // Generate a baud tick every 10 clock cycles
    initial begin
        baud_tick = 1'b0;

        forever begin
            repeat (10) @(posedge clk);
            baud_tick = 1'b1;

            @(posedge clk);
            baud_tick = 1'b0;
        end
    end

    initial begin

        // Initial values
        clk     = 1'b0;
        reset   = 1'b1;
        data_in = 8'b0;
        start   = 1'b0;

        // Reset
        #50;
        reset = 1'b0;

        // Load test byte
        data_in = 8'b1010_0101;

        // Start transmission
        #20;
        start = 1'b1;

        #10;
        start = 1'b0;

        // Wait for complete transmission
        #1500;

        $finish;
    end

endmodule
