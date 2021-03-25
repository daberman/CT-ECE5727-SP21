`timescale 1ns / 1ps

module tbird_tb;

    localparam CLK_PERIOD   = 8;
    localparam HALF_CLK     = CLK_PERIOD / 2;
    localparam DELAY        = 100;  // 100 ns = slow clk period in sim

/*************************
** Instantiate DUT
*************************/

logic SYSCLK;
logic HAZARD_BTN;
logic LEFT;
logic RIGHT;
logic [3:0] LEDS;

tbird #(.SIM_ONLY(1)
    ) dut (
    .SYSCLK(SYSCLK),
    .HAZARD_BTN(HAZARD_BTN),
    .LEFT(LEFT),
    .RIGHT(RIGHT),
    .LEDS(LEDS)
    );

/*************************
** Run Clock
*************************/

initial
    SYSCLK = 1'b0;  // At time 0, set clock to 0

always
    #HALF_CLK SYSCLK = ~SYSCLK; // Invert clock every half period

/*************************
** Testbench - modify as you see fit
*************************/

initial
begin
    HAZARD_BTN  = 1'b0;
    LEFT        = 1'b0;
    RIGHT       = 1'b0;

    #500 // Delay 500 ns to allow for initial clock startup

    #(10*DELAY) // Wait to come out of reset

    #DELAY      LEFT = 1'b1; // Turn on left signal
    #(10*DELAY) LEFT = 1'b0; // Turn off left signal
    
    #DELAY      HAZARD_BTN = 1'b1;
    #20         HAZARD_BTN = 1'b0;
    #20         HAZARD_BTN = 1'b1;
    #(2*DELAY)  HAZARD_BTN = 1'b0;

end

endmodule