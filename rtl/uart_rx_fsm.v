//==============================================================
// Module Name : uart_rx_fsm
// Description : UART Receiver FSM (16x Oversampling)
//==============================================================

module uart_rx_fsm(
    input wire clk,
    input wire rst,
    input wire rx,
    input wire baud_tick,
    input wire byte_received,

    output reg start_rx,
    output reg shift_en,
    output reg done
);

localparam IDLE  = 2'b00;
localparam START = 2'b01;
localparam DATA  = 2'b10;
localparam STOP  = 2'b11;

reg [1:0] state,next_state;
reg [3:0] tick_count;

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
            if(!rx)
                next_state = START;

        START:
            if(baud_tick && tick_count==4'd7)
                next_state = DATA;

        DATA:
            if(byte_received)
                next_state = STOP;

        STOP:
            if(baud_tick && tick_count==4'd15)
                next_state = IDLE;

        default:
            next_state = IDLE;
    endcase
end

always @(posedge clk) begin
    if(rst) begin
        tick_count <= 4'd0;
        start_rx <= 1'b0;
        shift_en <= 1'b0;
        done <= 1'b0;
    end
    else begin
        start_rx <= 1'b0;
        shift_en <= 1'b0;
        done <= 1'b0;

        case(state)

            IDLE: begin
                tick_count <= 4'd0;
                if(!rx)
                    start_rx <= 1'b1;
            end

            START: begin
                if(baud_tick) begin
                    if(tick_count == 4'd7)
                        tick_count <= 4'd0;
                    else
                        tick_count <= tick_count + 1'b1;
                end
            end

            DATA: begin
                if(baud_tick) begin
                    if(tick_count == 4'd15) begin
                        tick_count <= 4'd0;
                        shift_en <= 1'b1;
                    end
                    else
                        tick_count <= tick_count + 1'b1;
                end
            end

            STOP: begin
                if(baud_tick) begin
                    if(tick_count == 4'd15) begin
                        tick_count <= 4'd0;
                        done <= 1'b1;
                    end
                    else
                        tick_count <= tick_count + 1'b1;
                end
            end

        endcase
    end
end

endmodule