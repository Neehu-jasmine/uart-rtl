`timescale 1ns / 1ps

module uart_top_tb;

    reg        clk;
    reg        reset;
    reg [7:0]  tx_data;
    reg        tx_start;
    wire       tx;

    wire [7:0] rx_data;
    wire       rx_valid;
    wire       tx_busy;

    // Loop TX directly back into RX
    wire rx;

    assign rx = tx;

    // DUT
    uart_top dut (
        .clk      (clk),
        .reset    (reset),
        .tx_data  (tx_data),
        .tx_start (tx_start),
        .rx       (rx),
        .tx       (tx),
        .rx_data  (rx_data),
        .rx_valid (rx_valid),
        .tx_busy  (tx_busy)
    );

    // 100 MHz clock
    always #5 clk = ~clk;

    initial begin

        // Initial conditions
        clk      = 1'b0;
        reset    = 1'b1;
        tx_data  = 8'h00;
        tx_start = 1'b0;

        // Reset
        #100;
        reset = 1'b0;

        // Load byte
       tx_data = 8'h3C;

        // Start transmission
        #100;
        tx_start = 1'b1;

        #10;
        tx_start = 1'b0;

        // Wait until transmission begins
        wait (tx_busy == 1'b1);

        // Wait for RX to report received byte
        wait (rx_valid == 1'b1);

        // Display received result
        $display("----------------------------------------");
        $display("UART INTEGRATION TEST");
        $display("TX DATA = %h", tx_data);
        $display("RX DATA = %h", rx_data);

        if (rx_data == tx_data)
            $display("TEST PASSED!");
        else
            $display("TEST FAILED!");

        $display("----------------------------------------");

        #100;

        $finish;
    end

endmodule
