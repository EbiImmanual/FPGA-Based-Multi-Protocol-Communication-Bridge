//==============================================================
// Module Name : bridge_controller_fsm
// Description : Bridge Controller FSM (Corrected)
//==============================================================

module bridge_controller_fsm(
    input wire clk,
    input wire rst,
    input wire fifo_empty,
    input wire spi_busy,
    input wire spi_done,

    output reg fifo_rd_en,
    output reg spi_start
);

localparam IDLE      = 3'd0;
localparam READ_FIFO = 3'd1;
localparam WAIT_DATA = 3'd2;
localparam START_SPI = 3'd3;
localparam WAIT_DONE = 3'd4;

reg [2:0] state,next_state;

always @(posedge clk) begin
    if(rst)
        state <= IDLE;
    else
        state <= next_state;
end

always @(*) begin
    next_state = state;

    case(state)
        IDLE:
            if(!fifo_empty)
                next_state = READ_FIFO;

        READ_FIFO:
            next_state = WAIT_DATA;

        WAIT_DATA:
            next_state = START_SPI;

        START_SPI:
            if(spi_busy)
                next_state = WAIT_DONE;

        WAIT_DONE:
            if(spi_done)
                next_state = IDLE;

        default:
            next_state = IDLE;
    endcase
end

always @(posedge clk) begin
    if(rst) begin
        fifo_rd_en <= 1'b0;
        spi_start <= 1'b0;
    end
    else begin
        fifo_rd_en <= 1'b0;
        spi_start <= 1'b0;

        case(state)
            READ_FIFO:
                fifo_rd_en <= 1'b1;

            START_SPI:
                spi_start <= 1'b1;
        endcase
    end
end

endmodule
