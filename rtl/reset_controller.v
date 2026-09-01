//==============================================================
// Module Name : reset_controller
// Description : Synchronous Reset Controller
//==============================================================

module reset_controller(
    input wire clk,
    input wire ext_rst,

    output reg rst
);

reg [1:0] rst_cnt;

always @(posedge clk) begin
    if(ext_rst) begin
        rst <= 1'b1;
        rst_cnt <= 2'd0;
    end
    else begin
        if(rst_cnt == 2'd3)
            rst <= 1'b0;
        else begin
            rst <= 1'b1;
            rst_cnt <= rst_cnt + 1'b1;
        end
    end
end

endmodule
