`timescale 1ns / 100ps

module FSM_Example #(
    parameter FSM_TYPE = 2'b10  // [1] 1: 1-state 0: 2-state
                                // [0] 1: Mealy   0: Moore
    )(
    input clk, rst,
    input din,
    output logic dout
    );

typedef enum {  IDLE
              , STATE1
              , STATE2
              , STATE3
              , STATE4
              , STATE5
              , ENABLE
              } StateType;
              
StateType state, currState, nextState;

generate
if (FSM_TYPE[1]) begin : ONE_STATE_FSM

always_ff @(posedge clk) begin : FSM

    // Defaults
    dout <= 1'b0;
    
    case (state)
        IDLE : begin
            if (din) state <= STATE1;
        end
        STATE1 : state <= din ? state  : STATE2;
        STATE2 : state <= din ? STATE3 : IDLE;
        STATE3 : state <= din ? STATE1 : STATE4;
        STATE4 : state <= din ? STATE3 : STATE5;
        STATE5 : begin
            state <= IDLE;
            if (FSM_TYPE[0]) begin
                dout  <= din;
            end else begin
                state <= ENABLE;
            end
        end
        ENABLE : begin
            dout  <= 1'b1;
            state <= din ? STATE1 : IDLE;
        end
        default : state <= IDLE;
    endcase
    
    if (rst) begin
        state <= IDLE;
    end
end

end // generate ONE_STATE_FSM
else begin : TWO_STATE_FSM

always_comb begin : StateCombLogic

    // Defaults
    nextState <= currState;
    dout      <= 1'b0;
    
    case(currState)
        IDLE : begin
            if (din) begin
                nextState <= STATE1;
            end
        end
        
        STATE1 : if (!din) nextState <= STATE2;
        STATE2 : nextState <= din ? STATE3 : IDLE;
        STATE3 : nextState <= din ? STATE1 : STATE4;
        STATE4 : nextState <= din ? STATE3 : STATE5;
        STATE5 : begin
            nextState <= IDLE;
            if (FSM_TYPE[0]) begin
                dout  <= din;
            end else begin
                nextState <= ENABLE;
            end
        end
        ENABLE : begin
            dout      <= 1'b1;
            nextState <= din ? STATE1 : IDLE;
        end
        default : nextState <= IDLE;
    endcase;  
end

always_ff @(posedge clk) begin : CurrStateRegister   
    if (rst) begin
        currState <= IDLE;
    end else begin
        currState <= nextState;
    end
end

end // generate TWO_STATE_FSM

endgenerate
      
endmodule
