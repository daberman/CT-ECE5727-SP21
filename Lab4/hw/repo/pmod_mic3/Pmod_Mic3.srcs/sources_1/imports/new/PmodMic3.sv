`timescale 1ns / 1ps

module PmodMic3 #(
    parameter DATA_WIDTH    = 12,   // data width of a single spi transaction
    parameter LEADING_ZEROS = 4,    // number of leading zeros in spi transaction
    parameter TX_COUNT      = 32    // number of spi clks between start of each read tx
    )(
    input clk,
    input rst,

    // Sample Control Signals
    input [3:0] i_divRateSelect, // See mux logic for values

    // Data Out
    output logic [DATA_WIDTH-1:0] o_data,
    output logic                  o_dataVld,

    // Pmod SPI signals
    (* IOB = "true" *) output logic sclk,
    (* IOB = "true" *) output logic cs_n,
                       input        miso
    );


integer divRate, divCnt, sclkCnt;
logic sclk_i;
logic sclkFall, sclkRise;
logic [DATA_WIDTH-1:0] sreg;

// Decode desired clk divider value to generate sclk
always_ff @(posedge clk) begin
    case (i_divRateSelect)
        4'h0 : divRate <= 24;
        4'h1 : divRate <= 16;
        4'h2 : divRate <= 12;
        4'h3 : divRate <= 8;
        4'h4 : divRate <= 6;
        4'h5 : divRate <= 4;
        4'h6 : divRate <= 2;
        4'h7 : divRate <= 1;
        default : divRate <= 4;
    endcase
end

// Generate sclk
always_ff @(posedge clk) begin
    divCnt   <= divCnt + 1;
    sclkRise <= 1'b0;
    sclkFall <= 1'b0;

    if (divCnt == (divRate-1)) begin
        divCnt   <= 0;
        sclk_i   <= !sclk_i;
        sclkRise <= !sclk_i;
        sclkFall <= sclk_i;
    end

    // Reset
    if (rst) begin
        divCnt <= 0;
        sclk_i <= 1'b0;
    end
end

// SPI data in, parallel data out
always_ff @(posedge clk) begin

    // Defaults
    cs_n <= 1'b1;
    sclk <= 1'b1;
    o_dataVld <= 1'b0;

    // SPI transaction in process - drive sclk, keep cs_n low
    if (sclkCnt <= DATA_WIDTH+LEADING_ZEROS-1) begin
        cs_n <= 1'b0;
        sclk <= sclk_i;
    end

    // Data is shifted in on rising-edges
    if (sclkRise && sclkCnt < (DATA_WIDTH+LEADING_ZEROS-1)) begin
        sreg <= {sreg, miso};
    end

    // SPI transactions are initiated/finished with falling-edges
    if (sclkFall) begin
        sclkCnt <= sclkCnt + 1;

        // Current SPI transaction complete
        if (sclkCnt == DATA_WIDTH+LEADING_ZEROS-1) begin
            cs_n <= 1'b1;
            sclk <= 1'b1;

            o_data    <= sreg; // Output data
            o_dataVld <= 1'b1; // Strobe output data valid
        end

        // Start new transaction
        if (sclkCnt == (TX_COUNT-1)) begin
            sclkCnt <= 0;
            cs_n    <= 1'b0;
            sclk    <= 1'b0;
        end
    end

    // Need to have cs_n preempt the initial falling edge of sclk for a new tx
    if (divCnt == (divRate-1) && sclk_i && sclkCnt == (TX_COUNT-1)) cs_n <= 1'b0;

    // Reset
    if (rst) begin
        sclkCnt <= DATA_WIDTH+LEADING_ZEROS;
    end
end

endmodule
