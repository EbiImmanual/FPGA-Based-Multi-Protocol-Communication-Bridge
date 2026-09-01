//==============================================================
// Module Name : spi_master
// Description : SPI Master (Corrected)
//==============================================================

module spi_master(
    input wire clk,
    input wire rst,
    input wire spi_start,
    input wire [7:0] data_in,

    output wire sclk,
    output wire mosi,
    output wire cs,
    output wire busy,
    output wire done
);

wire shift_tick;
wire load;
wire shift;
wire [7:0] shift_reg;

spi_clock_gen #(
    .CLK_FREQ(50_000_000),
    .SPI_FREQ(1_000_000)
) clock_gen(
    .clk(clk),
    .rst(rst),
    .enable(busy),
    .sclk(sclk),
    .shift_tick(shift_tick)
);

spi_shift_register shift_register(
    .clk(clk),
    .rst(rst),
    .load(load),
    .shift(shift),
    .data_in(data_in),
    .mosi(mosi),
    .shift_reg(shift_reg)
);

spi_master_fsm fsm(
    .clk(clk),
    .rst(rst),
    .spi_start(spi_start),
    .shift_tick(shift_tick),
    .cs(cs),
    .load(load),
    .shift(shift),
    .busy(busy),
    .done(done)
);

endmodule