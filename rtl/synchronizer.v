
//==============================================================
// Module Name : synchronizer
// Description : Two-Flip-Flop Synchronizer
//==============================================================

module synchronizer(
    input wire clk,
    input wire rst,
    input wire async_in,
    output reg sync_out
);

reg sync_ff1;

always @(posedge clk) begin
    if(rst) begin
        sync_ff1 <= 1'b1;
        sync_out <= 1'b1;
    end
    else begin
        sync_ff1 <= async_in;
        sync_out <= sync_ff1;
    end
end

endmodule