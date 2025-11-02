`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.10.2025 18:01:49
// Design Name: 
// Module Name: uart_rx
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


module uart_rx (
    input wire i_clk,
    input wire i_rst_n,
    input wire i_rx_serial,
    input wire i_baud_tick_16x,
    output reg [7:0] o_rx_data,
    output reg o_rx_valid
);

localparam STATE_IDLE = 2'b00;
localparam STATE_START = 2'b01;
localparam STATE_DATA = 2'b10;
localparam STATE_STOP = 2'b11;

reg [1:0] r_state = STATE_IDLE;
reg [3:0] r_tick_count = 0;
reg [2:0] r_bit_count = 0;
reg [7:0] r_rx_data_reg = 0;
reg r_rx_prev = 1'b1;
wire w_start_edge = r_rx_prev & ~i_rx_serial;

always @(posedge i_clk or negedge i_rst_n) begin
    if (!i_rst_n) begin
        r_rx_prev <= 1'b1;
    end else begin
        r_rx_prev <= i_rx_serial;
    end
end

always @(posedge i_clk or negedge i_rst_n) begin
    if (!i_rst_n) begin
        r_state <= STATE_IDLE;
        o_rx_valid <= 1'b0;
        r_tick_count <= 0;
        r_bit_count <= 0;
        r_rx_data_reg <= 0;
        o_rx_data <= 0;
    end else begin
        o_rx_valid <= 1'b0;
        
        case (r_state)
            STATE_IDLE: begin
                if (w_start_edge) begin
                    r_tick_count <= 0;
                    r_state <= STATE_START;
                end
            end
            STATE_START: begin
                if (i_baud_tick_16x) begin
                    if (r_tick_count == 7) begin
                        if (i_rx_serial == 1'b0) begin
                            r_tick_count <= 0;
                            r_bit_count <= 0;
                            r_state <= STATE_DATA;
                        end else begin
                            r_state <= STATE_IDLE;
                        end
                    end else begin
                        r_tick_count <= r_tick_count + 1;
                    end
                end
            end
            STATE_DATA: begin
                if (i_baud_tick_16x) begin
                    if (r_tick_count == 7) begin
                        r_rx_data_reg[r_bit_count] <= i_rx_serial;
                    end
                    
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
                if (i_baud_tick_16x) begin
                    if (r_tick_count == 15) begin
                        if (i_rx_serial == 1'b1) begin
                            o_rx_data <= r_rx_data_reg;
                            o_rx_valid <= 1'b1;
                        end
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
