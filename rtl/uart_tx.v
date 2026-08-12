`timescale 1ns / 1ps

module uart_tx (
    input  wire       clk,
    input  wire       reset,
    input  wire       baud_tick,
    input  wire [7:0] data_in,
    input  wire       start,

    output reg        tx,
    output reg        busy
);

    // TX states
    localparam IDLE  = 2'b00;
    localparam START = 2'b01;
    localparam DATA  = 2'b10;
    localparam STOP  = 2'b11;

    reg [1:0] state;
    reg [7:0] data_reg;
    reg [2:0] bit_index;

    always @(posedge clk) begin

        if (reset) begin
            state     <= IDLE;
            data_reg  <= 8'b0;
            bit_index <= 3'b0;
            tx        <= 1'b1;
            busy      <= 1'b0;
        end

        else begin

            case (state)

                IDLE: begin
                    tx   <= 1'b1;
                    busy <= 1'b0;

                    if (start) begin
                        data_reg  <= data_in;
                        bit_index <= 3'b0;
                        busy      <= 1'b1;
                        state     <= START;
                    end
                end

                START: begin
                    tx <= 1'b0;

                    if (baud_tick) begin
                        state <= DATA;
                    end
                end

                DATA: begin
                    tx <= data_reg[bit_index];

                    if (baud_tick) begin
                        if (bit_index == 3'd7) begin
                            state <= STOP;
                        end
                        else begin
                            bit_index <= bit_index + 1'b1;
                        end
                    end
                end

                STOP: begin
                    tx <= 1'b1;

                    if (baud_tick) begin
                        state <= IDLE;
                        busy  <= 1'b0;
                    end
                end

                default: begin
                    state <= IDLE;
                    tx    <= 1'b1;
                    busy  <= 1'b0;
                end

            endcase
        end
    end

endmodule
