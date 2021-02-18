`timescale 1ns / 1ps

module Lab1(
    input clk,
    input rst,
    input rst_n,
    input [15:0] din,
    output logic dout
    );
    
logic [3:0] counter;

// Reset 1
always_ff @(posedge clk, negedge rst_n) begin : reset_1
    if (!rst_n) begin
        counter <= '0;
    end else begin
        counter <= counter + 1;
        dout <= |counter;
    end
end

// Reset 2
//always_ff @(posedge clk) begin : reset_2
//    if (rst) begin
//        counter <= '0;
//    end else begin
//        counter <= counter + 1;
//        dout <= |counter;
//    end
//end

// Reset 3
//always_ff @(posedge clk) begin : reset_3
//    counter <= counter + 1;
//    dout <= |counter;
////    dout <= din[counter];
    
//    if (rst) begin
//        counter <= '0;
//    end
//end

endmodule
