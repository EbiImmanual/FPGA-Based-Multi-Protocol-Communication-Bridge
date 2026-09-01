
//==============================================================
// Module Name : top
// Description : FPGA Multi-Protocol Communication Bridge
//==============================================================

module top(
    input wire clk,
    input wire ext_rst,

    input wire uart_rx,

    output wire spi_sclk,
    output wire spi_mosi,
    output wire spi_cs
);

wire rst;
wire uart_rx_sync;

wire baud_tick;

wire start_rx;
wire shift_en;
wire uart_done;

wire [7:0] uart_data;
wire uart_data_valid;
wire byte_received;

wire fifo_full;
wire fifo_empty;
wire [7:0] fifo_data;

wire fifo_rd_en;

wire spi_start;
wire [7:0] spi_data;

wire spi_busy;
wire spi_done;

reset_controller u_reset(
    .clk(clk),
    .ext_rst(ext_rst),
    .rst(rst)
);

synchronizer u_sync(
    .clk(clk),
    .rst(rst),
    .async_in(uart_rx),
    .sync_out(uart_rx_sync)
);

baud_tick_generator #(
    .CLK_FREQ(50_000_000),
    .BAUD_RATE(115200),
    .OVERSAMPLE(16)
) u_baud(
    .clk(clk),
    .rst(rst),
    .baud_tick(baud_tick)
);

uart_rx_fsm u_uart_fsm(
    .clk(clk),
    .rst(rst),
    .rx(uart_rx_sync),
    .baud_tick(baud_tick),
    .byte_received(byte_received),
    .start_rx(start_rx),
    .shift_en(shift_en),
    .done(uart_done)
);

uart_rx u_uart_rx(
    .clk(clk),
    .rst(rst),
    .rx(uart_rx_sync),
    .start_rx(start_rx),
    .shift_en(shift_en),
    .done(uart_done),
    .data_out(uart_data),
    .data_valid(uart_data_valid),
    .byte_received(byte_received)
);

fifo u_fifo(
    .clk(clk),
    .rst(rst),
    .wr_en(uart_data_valid),
    .rd_en(fifo_rd_en),
    .data_in(uart_data),
    .data_out(fifo_data),
    .full(fifo_full),
    .empty(fifo_empty)
);

bridge_controller u_bridge(
    .clk(clk),
    .rst(rst),
    .fifo_empty(fifo_empty),
    .fifo_data(fifo_data),
    .spi_busy(spi_busy),
    .spi_done(spi_done),
    .fifo_rd_en(fifo_rd_en),
    .spi_start(spi_start),
    .spi_data(spi_data)
);

spi_master u_spi(
    .clk(clk),
    .rst(rst),
    .spi_start(spi_start),
    .data_in(spi_data),
    .sclk(spi_sclk),
    .mosi(spi_mosi),
    .cs(spi_cs),
    .busy(spi_busy),
    .done(spi_done)
);

endmodule