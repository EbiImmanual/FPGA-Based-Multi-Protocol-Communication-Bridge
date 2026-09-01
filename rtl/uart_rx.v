//==============================================================
// Module Name : uart_rx
// Description : UART Receiver Datapath (16x Oversampling)
//==============================================================

module uart_rx(
    input wire clk,
    input wire rst,
    input wire rx,
    input wire start_rx,
    input wire shift_en,
    input wire done,

    output reg [7:0] data_out,
    output reg data_valid,
    output reg byte_received
);

reg [7:0] shift_reg;
reg [2:0] bit_count;

always @(posedge clk) begin
    if(rst) begin
        shift_reg <= 8'd0;
        bit_count <= 3'd0;
        data_out <= 8'd0;
        data_valid <= 1'b0;
        byte_received <= 1'b0;
    end
    else begin
        data_valid <= 1'b0;
        byte_received <= 1'b0;

        if(start_rx)
            bit_count <= 3'd0;

        if(shift_en) begin
            shift_reg <= {rx,shift_reg[7:1]};

            if(bit_count == 3'd7) begin
                bit_count <= 3'd0;
                byte_received <= 1'b1;
            end
            else
                bit_count <= bit_count + 1'b1;
        end

        if(done) begin
            data_out <= shift_reg;
            data_valid <= 1'b1;
        end
    end
end

endmodule