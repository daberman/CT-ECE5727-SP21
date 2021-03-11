`timescale 1ns / 100ps

module FSM_Example_TB();

localparam CLK_PERIOD = 10;
localparam NUM_FSMS = 4;
localparam BIT_SEQUENCE = 16'b0110_1010_0100_0111; // Target sequnce to identify is 101001

// DUT signals
logic clk, rst;
logic din;
logic [3:0] dout;

// TB signals
logic [15:0] data;

generate
genvar ii;
for (ii = 0; ii < NUM_FSMS; ii++) begin : Generate_FSM

// Instantiate DUTs
FSM_Example #(.FSM_TYPE(ii)) DUT (
    .clk    (clk),
    .rst    (rst),
    .din    (din),
    .dout   (dout[ii])
    );
    
// Check dout
initial begin
    wait(dout[ii]);
    
    $timeformat(-9, 0, " ns");
    $display("[%3t]: FSM%1d sequence found", $realtime, ii);
    
    #1
    
    forever #CLK_PERIOD assert(!dout[ii]);
end

end
endgenerate

// Run clock & reset
initial begin
    clk = 0;
    rst = 1;
    #(5*CLK_PERIOD) rst = 0;
end
always #(CLK_PERIOD/2.0) clk = ~clk;

// Shift in bit sequence
always @(posedge clk) begin
    din  <= data[$bits(data)-1];
    data <= data << 1;
    
    if (rst) begin
        din  <= 0;
        data <= BIT_SEQUENCE;
    end
end


endmodule
