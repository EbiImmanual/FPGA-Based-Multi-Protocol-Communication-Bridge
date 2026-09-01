//==============================================================
// Module Name : baud_tick_generator
// Description : 16x Baud Tick Generator
//==============================================================

module baud_tick_generator #(
    parameter CLK_FREQ  = 50_000_000,
    parameter BAUD_RATE = 115200,
    parameter OVERSAMPLE = 16
)(
    input wire clk,
    input wire rst,

    output reg baud_tick
);

localparam integer BAUD_DIV = CLK_FREQ / (BAUD_RATE * OVERSAMPLE);
localparam integer COUNT_WIDTH = $clog2(BAUD_DIV);

reg [COUNT_WIDTH-1:0] counter;

always @(posedge clk) begin
    if(rst) begin
        counter <= 0;
        baud_tick <= 1'b0;
    end
    else begin
        if(counter == BAUD_DIV-1) begin
            counter <= 0;
            baud_tick <= 1'b1;
        end
        else begin
            counter <= counter + 1'b1;
            baud_tick <= 1'b0;
        end
    end
end

endmodule
