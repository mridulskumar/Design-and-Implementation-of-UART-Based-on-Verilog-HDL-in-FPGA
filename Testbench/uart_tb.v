`timescale 1ns / 1ps
module uart_tb;

localparam CLK_FREQ = 50_000_000;
localparam BAUD_RATE = 19200;
localparam CLK_PERIOD = 1_000_000_000 / CLK_FREQ;

reg tb_clk = 1'b0;
reg tb_rst_n;
reg [7:0] tb_tx_data;
reg tb_tx_start;
wire [7:0] tb_rx_data;
wire tb_rx_valid;
wire tb_tx_serial;
wire tb_tx_busy;

uart_top #(
    .CLK_FREQ(CLK_FREQ),
    .BAUD_RATE(BAUD_RATE)
) DUT (
    .i_clk(tb_clk),
    .i_rst_n(tb_rst_n),
    .i_tx_data(tb_tx_data),
    .i_tx_start(tb_tx_start),
    .o_rx_data(tb_rx_data),
    .o_rx_valid(tb_rx_valid),
    .o_tx_serial(tb_tx_serial),
    .i_rx_serial(tb_tx_serial),
    .o_tx_busy(tb_tx_busy)
);

always #((CLK_PERIOD / 2)) tb_clk = ~tb_clk;

initial begin
    $display("---");
    $display("-- Starting Simplified UART Loopback Test ---");
    $display("--- BAUD_RATE = %0d bps ---", BAUD_RATE);
    $display("---");
    
    tb_rst_n = 1'b0;
    tb_tx_data = 8'hAA;
    tb_tx_start = 1'b0;
    #200;
    
    tb_rst_n = 1'b1;
    $display("INFO: Reset released. Waiting for system to stabilize.");
    repeat (10) @(posedge tb_clk);
    
    $display("INFO: Requesting transmission of data: 0x%h", 8'hAA);
    tb_tx_data = 8'hAA;
    tb_tx_start = 1'b1;
    @(posedge tb_clk);
    tb_tx_start = 1'b0;
    
    wait(tb_tx_busy == 1'b0);
    $display("INFO: Transmitter is no longer busy.");
    
    $display("INFO: Waiting for receiver to assert 'rx_valid'...");
    wait (tb_rx_valid == 1'b1);
    $display("INFO: Receiver has asserted 'rx_valid!");
    
    @(posedge tb_clk);
    if (tb_rx_data == 8'hAA) begin
        $display("---");
        $display("-- TEST PASSED ---");
        $display("-- Received data 0x%h matches expected. ---", tb_rx_data);
        $display("---");
    end else begin
        $display("***************");
        $display("*** TEST FAILED ***");
        $display("*** Data Mismatch Detected ***");
        $display("*** Expected 0xaa, but received 0x%h. ***", tb_rx_data);
        $display("***************");
    end
    
    #1000;
    $display("INFO: Simulation finished.");
    $finish;
end
endmodule
