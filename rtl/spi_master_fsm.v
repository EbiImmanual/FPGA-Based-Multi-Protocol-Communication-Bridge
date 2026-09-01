//==============================================================
// Module Name : spi_master_fsm
// Description : SPI Master FSM (Corrected)
//==============================================================

module spi_master_fsm(
    input wire clk,
    input wire rst,
    input wire spi_start,
    input wire shift_tick,

    output reg cs,
    output reg load,
    output reg shift,
    output reg busy,
    output reg done
);

localparam IDLE  = 2'd0;
localparam LOAD  = 2'd1;
localparam SHIFT = 2'd2;
localparam DONE  = 2'd3;

reg [1:0] state,next_state;
reg [2:0] bit_count;

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
            if(spi_start)
                next_state = LOAD;

        LOAD:
            next_state = SHIFT;

        SHIFT:
            if(shift_tick && bit_count == 3'd7)
                next_state = DONE;

        DONE:
            next_state = IDLE;

        default:
            next_state = IDLE;
    endcase
end

always @(posedge clk) begin
    if(rst) begin
        bit_count <= 3'd0;
        cs <= 1'b1;
        load <= 1'b0;
        shift <= 1'b0;
        busy <= 1'b0;
        done <= 1'b0;
    end
    else begin
        load <= 1'b0;
        shift <= 1'b0;
        done <= 1'b0;

        case(state)
            IDLE: begin
                cs <= 1'b1;
                busy <= 1'b0;
                bit_count <= 3'd0;
            end

            LOAD: begin
                cs <= 1'b0;
                busy <= 1'b1;
                load <= 1'b1;
            end

            SHIFT: begin
                cs <= 1'b0;
                busy <= 1'b1;

                if(shift_tick) begin
                    shift <= 1'b1;
                    bit_count <= bit_count + 1'b1;
                end
            end

            DONE: begin
                cs <= 1'b1;
                busy <= 1'b0;
                done <= 1'b1;
                bit_count <= 3'd0;
            end
        endcase
    end
end

endmodule