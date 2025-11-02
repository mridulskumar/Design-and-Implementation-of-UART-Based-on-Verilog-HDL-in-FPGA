`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.10.2025 17:59:22
// Design Name: 
// Module Name: uart_tx
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module uart_tx (
    input wire i_clk,
    input wire i_rst_n,
    input wire [7:0] i_tx_data,
    input wire i_tx_start,
    input wire i_baud_tick_16x,
    output reg o_tx_serial,
    output reg o_tx_busy
);

    // FSM state definitions
    localparam STATE_IDLE = 2'b00;
    localparam STATE_START = 2'b01;
    localparam STATE_DATA = 2'b10;
    localparam STATE_STOP = 2'b11;

    // Registers
    reg [1:0] r_state;
    reg [3:0] r_tick_count;
    reg [2:0] r_bit_count;
    reg [7:0] r_tx_data_reg;

    always @(posedge i_clk or negedge i_rst_n) begin
        if (!i_rst_n) begin
            r_state <= STATE_IDLE;
            o_tx_busy <= 1'b0;
            o_tx_serial <= 1'b1;
            r_tick_count <= 0;
            r_bit_count <= 0;
            r_tx_data_reg <= 0;
        end else begin
            case (r_state)
                STATE_IDLE: begin
                    o_tx_serial <= 1'b1;
                    o_tx_busy <= 1'b0;
                    if (i_tx_start) begin
                        o_tx_busy <= 1'b1;
                        r_tx_data_reg <= i_tx_data;
                        r_tick_count <= 0;
                        r_state <= STATE_START;
                    end
                end
                
                STATE_START: begin
                    o_tx_serial <= 1'b0;
                    if (i_baud_tick_16x) begin
                        if (r_tick_count == 15) begin
                            r_tick_count <= 0;
                            r_state <= STATE_DATA;
                        end else begin
                            r_tick_count <= r_tick_count + 1;
                        end
                    end
                end
                
                STATE_DATA: begin
                    o_tx_serial <= r_tx_data_reg[r_bit_count];
                    if (i_baud_tick_16x) begin
                        if (r_tick_count == 15) begin
                            r_tick_count <= 0;
                            if (r_bit_count == 7) begin
                                r_state <= STATE_STOP;
                            end else begin
                                r_bit_count <= r_bit_count + 1;
                            end
                        end else begin
                            r_tick_count <= r_tick_count + 1;
                        end
                    end
                end
                
                STATE_STOP: begin
                    o_tx_serial <= 1'b1;
                    if (i_baud_tick_16x) begin
                        if (r_tick_count == 15) begin
                            r_tick_count <= 0;
                            r_state <= STATE_IDLE;
                        end else begin
                            r_tick_count <= r_tick_count + 1;
                        end
                    end
                end
                
                default: r_state <= STATE_IDLE;
            endcase
        end
    end

endmodule