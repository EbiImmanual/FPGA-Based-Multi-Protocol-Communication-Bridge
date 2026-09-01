
//==============================================================
// Module Name : edge_detector
// Description : Rising Edge Detector
//==============================================================

module edge_detector(
    input wire clk,
    input wire rst,
    input wire signal_in,

    output reg rising_edge
);

reg signal_d;

always @(posedge clk) begin
    if(rst) begin
        signal_d <= 1'b0;
        rising_edge <= 1'b0;
    end
    else begin
        rising_edge <= signal_in & ~signal_d;
        signal_d <= signal_in;
    end
end

endmodule