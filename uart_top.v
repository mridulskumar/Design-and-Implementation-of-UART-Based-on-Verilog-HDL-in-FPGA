`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.10.2025 18:05:07
// Design Name: 
// Module Name: uart_top
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


module uart_top #(
    parameter CLK_FREQ = 50_000_000,
    parameter BAUD_RATE = 19200
) (
    // System signals
    input wire i_clk,
    input wire i_rst_n,

    // UART TX interface
    input wire [7:0] i_tx_data,
    input wire i_tx_start,
    output wire o_tx_serial,
    output wire o_tx_busy,

    // UART RX interface
    input wire i_rx_serial,
    output wire [7:0] o_rx_data,
    output wire o_rx_valid
);

    // Internal baud rate tick
    wire w_baud_tick_16x;

    // Baud Rate Generator
    baud_gen #(
        .CLK_FREQ(CLK_FREQ),
        .BAUD_RATE(BAUD_RATE)
    ) u_baud_gen (
        .i_clk(i_clk),
        .i_rst_n(i_rst_n),
        .o_baud_tick_16x(w_baud_tick_16x)
    );

    // UART Transmitter
    uart_tx u_uart_tx (
        .i_clk(i_clk),
        .i_rst_n(i_rst_n),
        .i_tx_data(i_tx_data),
        .i_tx_start(i_tx_start),
        .i_baud_tick_16x(w_baud_tick_16x),
        .o_tx_serial(o_tx_serial),
        .o_tx_busy(o_tx_busy)
    );

    // UART Receiver
    uart_rx u_uart_rx (
        .i_clk(i_clk),
        .i_rst_n(i_rst_n),
        .i_rx_serial(i_rx_serial),
        .i_baud_tick_16x(w_baud_tick_16x),
        .o_rx_data(o_rx_data),
        .o_rx_valid(o_rx_valid)
    );

endmodule
