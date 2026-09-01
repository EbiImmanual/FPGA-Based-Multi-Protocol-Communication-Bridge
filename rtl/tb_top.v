
`timescale 1ns/1ps

//==============================================================
// Module Name : tb_top
// Description : Testbench for Multi-Protocol Communication Bridge
//==============================================================

module tb_top;

reg clk;
reg ext_rst;
reg uart_rx;

wire spi_sclk;
wire spi_mosi;
wire spi_cs;

parameter CLK_PERIOD = 20;
parameter BAUD_PERIOD = 8680;

top dut(
    .clk(clk),
    .ext_rst(ext_rst),
    .uart_rx(uart_rx),
    .spi_sclk(spi_sclk),
    .spi_mosi(spi_mosi),
    .spi_cs(spi_cs)
);

always #(CLK_PERIOD/2) clk = ~clk;

task uart_send_byte;
input [7:0] data;
integer i;
begin
    uart_rx = 1'b1;
    #(BAUD_PERIOD);

    uart_rx = 1'b0;
    #(BAUD_PERIOD);

    for(i=0;i<8;i=i+1) begin
        uart_rx = data[i];
        #(BAUD_PERIOD);
    end

    uart_rx = 1'b1;
    #(BAUD_PERIOD);
end
endtask

initial begin
    clk = 0;
    ext_rst = 1;
    uart_rx = 1;

    #200;

    ext_rst = 0;

    #100000;

    uart_send_byte(8'h41);

    #200000;

    uart_send_byte(8'h42);

    #200000;

    uart_send_byte(8'h43);

    #500000;

    $stop;
end

endmodule