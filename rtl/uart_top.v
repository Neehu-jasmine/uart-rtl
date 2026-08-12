`timescale 1ns / 1ps

module uart_top (
    input  wire       clk,
    input  wire       reset,

    input  wire [7:0] tx_data,
    input  wire       tx_start,

    input  wire       rx,

    output wire       tx,
    output wire [7:0] rx_data,
    output wire       rx_valid,
    output wire       tx_busy
);

    wire baud_tick;

    // Baud Generator
    baud_generator baud_gen (
        .clk       (clk),
        .reset     (reset),
        .baud_tick (baud_tick)
    );

    // UART Transmitter
    uart_tx transmitter (
        .clk       (clk),
        .reset     (reset),
        .baud_tick (baud_tick),
        .data_in   (tx_data),
        .start     (tx_start),
        .tx        (tx),
        .busy      (tx_busy)
    );

    // UART Receiver
    uart_rx receiver (
        .clk        (clk),
        .reset      (reset),
        .baud_tick  (baud_tick),
        .rx         (rx),
        .data_out   (rx_data),
        .data_valid (rx_valid)
    );

endmodule
