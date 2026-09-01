
//==============================================================
// Module Name : spi_shift_register
// Description : SPI Shift Register
//==============================================================

module spi_shift_register(
    input wire clk,
    input wire rst,
    input wire load,
    input wire shift,
    input wire [7:0] data_in,

    output wire mosi,
    output reg [7:0] shift_reg
);

assign mosi = shift_reg[7];

always @(posedge clk) begin
    if(rst)
        shift_reg <= 8'd0;
    else if(load)
        shift_reg <= data_in;
    else if(shift)
        shift_reg <= {shift_reg[6:0],1'b0};
end

endmodule