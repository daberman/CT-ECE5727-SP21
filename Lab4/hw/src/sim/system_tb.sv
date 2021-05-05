`timescale 1ns/1ps

module system_tb();

localparam PI = 3.14159;

localparam SAMPLE_FREQ = 48000; // 48kHz audio sampling frequency
localparam LF_FREQ     = 500;   // 500Hz for low frequency sine wave
localparam HF_FREQ     = 5000;  // 5kHz for high frequency sine wave

// Top-level signals
wire [14:0]DDR_addr;
wire [2:0]DDR_ba;
wire DDR_cas_n;
wire DDR_ck_n;
wire DDR_ck_p;
wire DDR_cke;
wire DDR_cs_n;
wire [3:0]DDR_dm;
wire [31:0]DDR_dq;
wire [3:0]DDR_dqs_n;
wire [3:0]DDR_dqs_p;
wire DDR_odt;
wire DDR_ras_n;
wire DDR_reset_n;
wire DDR_we_n;
wire FIXED_IO_ddr_vrn;
wire FIXED_IO_ddr_vrp;
wire [53:0]FIXED_IO_mio;
wire FIXED_IO_ps_clk;
wire FIXED_IO_ps_porb;
wire FIXED_IO_ps_srstb;
wire IIC_scl_io;
wire IIC_sda_io;
wire ac_bclk;
wire ac_mclk;
wire [0:0]ac_muten;
wire ac_pbdat;
wire ac_pblrc;
wire ac_recdat;
wire ac_reclrc;
wire [3:0]btns_4bits_tri_i;

logic mic3_cs_n, mic3_sck, mic3_miso;

// Testbench signals for simulating the Mic3 ADC
integer sampleCount;
logic [11:0] sineHf, sineLf, audioSignal;
logic [15:0] sreg;

// Instantiate system
system_wrapper DUT (
    .DDR_addr   (DDR_addr   ),
    .DDR_ba     (DDR_ba     ),
    .DDR_cas_n  (DDR_cas_n  ),
    .DDR_ck_n   (DDR_ck_n   ),
    .DDR_ck_p   (DDR_ck_p   ),
    .DDR_cke    (DDR_cke    ),
    .DDR_cs_n   (DDR_cs_n   ),
    .DDR_dm     (DDR_dm     ),
    .DDR_dq     (DDR_dq     ),
    .DDR_dqs_n  (DDR_dqs_n  ),
    .DDR_dqs_p  (DDR_dqs_p  ),
    .DDR_odt    (DDR_odt    ),
    .DDR_ras_n  (DDR_ras_n  ),
    .DDR_reset_n(DDR_reset_n),
    .DDR_we_n   (DDR_we_n   ),
    .FIXED_IO_ddr_vrn   (FIXED_IO_ddr_vrn ),
    .FIXED_IO_ddr_vrp   (FIXED_IO_ddr_vrp ),
    .FIXED_IO_mio       (FIXED_IO_mio     ),
    .FIXED_IO_ps_clk    (FIXED_IO_ps_clk  ),
    .FIXED_IO_ps_porb   (FIXED_IO_ps_porb ),
    .FIXED_IO_ps_srstb  (FIXED_IO_ps_srstb),
    .IIC_scl_io(IIC_scl_io),
    .IIC_sda_io(IIC_sda_io),
    .ac_bclk    (ac_bclk  ),
    .ac_mclk    (ac_mclk  ),
    .ac_muten   (ac_muten ),
    .ac_pbdat   (ac_pbdat ),
    .ac_pblrc   (ac_pblrc ),
    .ac_recdat  (ac_recdat),
    .ac_reclrc  (ac_reclrc),
    .btns_4bits_tri_i(btns_4bits_tri_i),
    .mic3_cs_n(mic3_cs_n),
    .mic3_miso(mic3_miso),
    .mic3_sck (mic3_sck )
    );

//**********************************************************************************
// Testbench logic
//**********************************************************************************

initial begin
    sampleCount = 0;

    // *** use 'force' to set control register(s) to skip having to create AXI transactions ***

    // Set the audio sample rate. Set to maximum rate ('h7) to speed up simulation
    force DUT.system_i.PmodMic3_0.inst.pmodSampleReg = 32'h07000000;


    #25us // wait for systems to initialize

    // start stream from mic
    force DUT.system_i.PmodMic3_0.inst.pmodControlReg = 32'h00000010;
end

always @(negedge mic3_sck, negedge mic3_cs_n) begin // "sample" audio signal on falling edge of cs_n, shift falling edge of sclk
    if (mic3_sck) begin // start new sample
        sineLf      = getScaledSine(LF_FREQ, sampleCount);
        sineHf      = getScaledSine(HF_FREQ, sampleCount);
        audioSignal = (sineLf >> 1) + (sineHf >> 1); // mix sine signals 50/50
        sampleCount <= sampleCount + 1;
        sreg        <= {4'b0, audioSignal};
    end else begin
        sreg <= sreg << 1;
    end
end

assign mic3_miso = sreg[15];

function [11:0] getScaledSine(input int freq, input int count);
begin
    static real sineVal     = $sin(2*PI*(real(freq*count)/real(SAMPLE_FREQ)));
    static real shiftedSine = 0.5 + 0.5 * sineVal;  // shift range from [-1,1] to [0,1]
    getScaledSine = (2**12-1) * shiftedSine;        // scale to 12-bit unsigned integer
end
endfunction


endmodule
