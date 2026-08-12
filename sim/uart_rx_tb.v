`timescale 1ns / 1ps

module uart_rx_tb;

    reg        clk;
    reg        reset;
    reg        baud_tick;
    reg        rx;

    wire [7:0] data_out;
    wire       data_valid;

    uart_rx dut (
        .clk        (clk),
        .reset      (reset),
        .baud_tick  (baud_tick),
        .rx         (rx),
        .data_out   (data_out),
        .data_valid (data_valid)
    );

    // 100 MHz clock
    always #5 clk = ~clk;

    // Generate baud tick
    initial begin
        baud_tick = 1'b0;

        forever begin
            repeat (10) @(posedge clk);
            baud_tick = 1'b1;

            @(posedge clk);
            baud_tick = 1'b0;
        end
    end

    // Send one UART bit and wait for its baud period
    task send_bit;
        input bit_value;
        begin
            rx = bit_value;
            @(posedge baud_tick);
        end
    endtask

    initial begin

        clk   = 1'b0;
        reset = 1'b1;
        rx    = 1'b1;

        // Reset
        #50;
        reset = 1'b0;

        // Idle
        repeat (2) @(posedge clk);

        // --------------------------------
        // Send A5 = 1010_0101
        // LSB first
        // --------------------------------

        // Start bit
        send_bit(1'b0);

        // Data bits
        send_bit(1'b1);  // D0
        send_bit(1'b0);  // D1
        send_bit(1'b1);  // D2
        send_bit(1'b0);  // D3
        send_bit(1'b0);  // D4
        send_bit(1'b1);  // D5
        send_bit(1'b0);  // D6
        send_bit(1'b1);  // D7

        // Stop bit
        send_bit(1'b1);

        // Idle
        rx = 1'b1;

        #100;

        $finish;

    end

endmodule
