//==============================================================
// Module Name : spi_clock_gen
// Description : SPI Clock Generator (Corrected)
//==============================================================

module spi_clock_gen #(
    parameter CLK_FREQ = 50_000_000,
    parameter SPI_FREQ = 1_000_000
)(
    input wire clk,
    input wire rst,
    input wire enable,

    output reg sclk,
    output reg shift_tick
);

localparam integer DIVIDER = CLK_FREQ / (2 * SPI_FREQ);
localparam integer COUNT_WIDTH = $clog2(DIVIDER);

reg [COUNT_WIDTH-1:0] counter;

always @(posedge clk) begin
    if(rst) begin
        counter <= 0;
        sclk <= 1'b0;
        shift_tick <= 1'b0;
    end
    else begin
        shift_tick <= 1'b0;

        if(enable) begin
            if(counter == DIVIDER-1) begin
                counter <= 0;
                sclk <= ~sclk;

                if(sclk)
                    shift_tick <= 1'b1;
            end
            else begin
                counter <= counter + 1'b1;
            end
        end
        else begin
            counter <= 0;
            sclk <= 1'b0;
        end
    end
end

endmodule