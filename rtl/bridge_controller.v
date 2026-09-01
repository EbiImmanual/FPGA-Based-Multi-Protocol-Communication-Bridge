module bridge_controller(
    input wire clk,
    input wire rst,
    input wire fifo_empty,
    input wire [7:0] fifo_data,
    input wire spi_busy,
    input wire spi_done,
    output wire fifo_rd_en,
    output wire spi_start,
    output reg [7:0] spi_data
);

reg wait_data;

bridge_controller_fsm controller_fsm(
    .clk(clk),
    .rst(rst),
    .fifo_empty(fifo_empty),
    .spi_busy(spi_busy),
    .spi_done(spi_done),
    .fifo_rd_en(fifo_rd_en),
    .spi_start(spi_start)
);

always @(posedge clk) begin
    if(rst) begin
        spi_data <= 8'd0;
        wait_data <= 1'b0;
    end
    else begin
        wait_data <= fifo_rd_en;

        if(wait_data)
            spi_data <= fifo_data;
    end
end

endmodule