`timescale 1ns / 1ps

module uart_rx (
    input  wire       clk,
    input  wire       reset,
    input  wire       baud_tick,
    input  wire       rx,

    output reg [7:0]  data_out,
    output reg        data_valid
);

    // RX states
    localparam IDLE  = 2'b00;
    localparam START = 2'b01;
    localparam DATA  = 2'b10;
    localparam STOP  = 2'b11;

    reg [1:0] state;
    reg [7:0] data_reg;
    reg [2:0] bit_index;

    always @(posedge clk) begin

        if (reset) begin
            state      <= IDLE;
            data_reg   <= 8'b0;
            data_out   <= 8'b0;
            bit_index  <= 3'b0;
            data_valid <= 1'b0;
        end

        else begin

            // Default: data_valid is a one-clock pulse
            data_valid <= 1'b0;

            case (state)

                IDLE: begin
                    if (rx == 1'b0) begin
                        state <= START;
                    end
                end

                START: begin
                    if (baud_tick) begin
                        // Confirm start bit
                        if (rx == 1'b0) begin
                            bit_index <= 3'b0;
                            state <= DATA;
                        end
                        else begin
                            // False start
                            state <= IDLE;
                        end
                    end
                end

                DATA: begin
                    if (baud_tick) begin
                        data_reg[bit_index] <= rx;

                        if (bit_index == 3'd7) begin
                            state <= STOP;
                        end
                        else begin
                            bit_index <= bit_index + 1'b1;
                        end
                    end
                end

                STOP: begin
                    if (baud_tick) begin
                        if (rx == 1'b1) begin
                            data_out <= data_reg;
                            data_valid <= 1'b1;
                        end

                        state <= IDLE;
                    end
                end

                default: begin
                    state <= IDLE;
                end

            endcase
        end
    end

endmodule
