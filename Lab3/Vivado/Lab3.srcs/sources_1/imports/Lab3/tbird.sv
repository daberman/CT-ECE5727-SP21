`timescale 1ns / 1ps

module tbird #(parameter SIM_ONLY = 0)(
    input  SYSCLK,
    input  HAZARD_BTN,
    input  LEFT,
    input  RIGHT,
    output logic [3:0] LEDS
);

// Divides the clock from 100 MHz down to 4 Hz
localparam CLK_DIV_VALUE = SIM_ONLY ? 5 : 12500000;

// FSM States
typedef enum{
              ST_OFF
            , ST_L1
            , ST_L2
            , ST_L3
            , ST_R1
            , ST_R2
            , ST_R3
            , ST_HON
            , ST_HOFF
            } Tbird_States;


/******************
**   Variables
******************/

// Clock & Reset
logic clk, locked, rst, slowReset;
logic [7:0] rstPipe, slowResetPipe;

integer clkDivCnt;
logic   clkEn;
logic   slowClk;

// Switches
(* ASYNC_REG = "TRUE" *) logic i_left, i_right;
(* ASYNC_REG = "TRUE" *) logic leftSwitch, rightSwitch;

// Hazard Button
logic hazardBtn, hazardBtn_r;
logic hazardPushed, hazardEnable;

// State Machine
Tbird_States state; // Use for 1-process FSM
Tbird_States currState, nextState; // Use for 2-process FSM


/***********************
** Module Instantiations
***********************/

// Clock Wizard IP Core to generate a stable 100MHz clock from the board clock
clk_gen clk_gen_inst
(
    // Clock out ports
    .clk_100(clk),      // output clk @ 100 MHz
    // Status and control signals
    .locked(locked),    // output locked
    // Clock in ports
    .clk_in1(SYSCLK)    // input clk @ 125 MHz
);

// Place the slow clock into an fpga clocking tree
BUFG slow_clk_buf (.I(clkEn), .O(slowClk));

// Debounce the hazard button
debouncer #(.SIM_ONLY(SIM_ONLY))
    hzd_debouncer (.clk(clk), .rst(rst), .i_sig(HAZARD_BTN), .o_sig(hazardBtn));


/***************
**     RTL
***************/

// FSM

// One-process - comment this out if you want to write a two-process FSM
always_ff @(posedge slowClk) begin

    LEDS <= 4'b0;
    
    // Your FSM code goes here
    case (state)
        ST_OFF : begin
            // Placeholder code
            if (hazardEnable) LEDS <= 4'b1111;
            if (leftSwitch) LEDS <= 4'b1110;
            if (rightSwitch) LEDS <= 4'b0111;
        end
        default: state <= ST_OFF;
    endcase
    
    // Reset
    if (slowReset) begin
        state <= ST_OFF;
    end
end

//// Two-process - uncomment if you want to write a two-process FSM
//always_comb begin
    
//    LEDS      <= 4'b0;
//    nextState <= currState;
    
//    // Your FSM code goes here
//    case (currState)
//        ST_OFF : begin
//            // Placeholder code
//            if (hazardEnable) LEDS <= 4'b1111;
//            if (leftSwitch) LEDS <= 4'b1110;
//            if (rightSwitch) LEDS <= 4'b0111;
//        end
//        default: nextState <= ST_OFF;
//    endcase            
//end

//always_ff @(posedge slowClk) begin
//    if (slowReset) begin
//        currState <= ST_OFF;
//    end else begin
//        currState <= nextState;
//    end
//end


//
// DO NOT EDIT CODE BELOW THIS LINE
//

assign hazardPushed = hazardBtn && !hazardBtn_r;

always_ff @(posedge slowClk) begin

    i_left      <= LEFT;
    i_right     <= RIGHT;
    leftSwitch  <= i_left;
    rightSwitch <= i_right;

    hazardBtn_r  <= hazardBtn;
    hazardEnable <= hazardEnable ^ hazardPushed;

    if (slowReset) begin
        hazardEnable <= 0;
    end
end

// Generate the slow clock
// Toggling at 8Hz will create a 4Hz clock w/ 50% duty cycle
always @(posedge clk) begin

    clkDivCnt <= clkDivCnt + 1;

    if (clkDivCnt == CLK_DIV_VALUE-1) begin
        clkDivCnt   <= 0;
        clkEn       <= !clkEn;
    end

    if (rst) begin
        clkDivCnt   <= 0;
        clkEn       <= 1'b0;
    end
end

// Generate internal resets
always @(posedge clk, negedge locked) begin
    if (!locked) rstPipe <= 8'hff;
    else rstPipe <= rstPipe << 1;
    
    rst <= |rstPipe; // Hold in reset until clk is locked and freely running
end

always @(posedge slowClk, posedge rst) begin
    if (rst) slowResetPipe <= 8'hff;
    else slowResetPipe <= slowResetPipe << 1;
    
    slowReset <= |slowResetPipe; // Hold in reset until slowClk is freely running
end

endmodule