`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.10.2025 17:57:11
// Design Name: 
// Module Name: baud_gen
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


module baud_gen #(
    parameter CLK_FREQ = 50_000_000,
    parameter BAUD_RATE = 9600
) (
    input wire i_clk,
    input wire i_rst_n,
    output reg o_baud_tick_16x
);

localparam DIVISOR = CLK_FREQ / (BAUD_RATE * 16);
reg [$clog2(DIVISOR)-1:0] r_counter = 0;

always @(posedge i_clk or negedge i_rst_n) begin
    if (!i_rst_n) begin
        r_counter <= 0;
        o_baud_tick_16x <= 1'b0;
    end else begin
        if (r_counter == DIVISOR - 1) begin
            r_counter <= 0;
            o_baud_tick_16x <= 1'b1;
        end else begin
            r_counter <= r_counter + 1;
            o_baud_tick_16x <= 1'b0;
        end
    end
end
endmodule
