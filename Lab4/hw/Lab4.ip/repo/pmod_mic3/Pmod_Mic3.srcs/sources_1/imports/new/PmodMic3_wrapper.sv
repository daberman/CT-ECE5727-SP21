`timescale 1ns / 1ps


module PmodMic3_wrapper #(
    // Stream data width
    parameter C_AXI_STREAM_DATA_WIDTH = 32,
    // AXI-Lite data width
    parameter C_AXI_L_DATA_WIDTH = 32,
    // AXI-Lite address width
    parameter C_AXI_L_ADDR_WIDTH = 6,
    // Width of actual data within AXI-Stream tdata
    parameter C_DATA_WIDTH = 24,
    // Width of MIC data
    parameter MIC_DATA_WIDTH = 12,
    // Number of bits in MIC SPI transaction
    parameter MIC_SPI_WIDTH = 16
    )(
    input sysClk, // system clock (100 MHz) - should be the same as s_axi_l_aclk
    input sysRst, // system reset
    input pmodClk, // clock for pmod mic3 logic (12.288 MHz)
    input pmodClkLocked,

    // SPI interface to PmodMic3
    output sclk,
    output cs_n,
    input  miso,

    // AXI interface to control register(s)
    input                                 s_axi_l_aclk,
    input                                 s_axi_l_aresetn,
    input [C_AXI_L_ADDR_WIDTH-1:0]        s_axi_l_awaddr,
    input [2:0]                           s_axi_l_awprot,
    input                                 s_axi_l_awvalid,
    output logic                          s_axi_l_awready,
    input [C_AXI_L_DATA_WIDTH-1:0]        s_axi_l_wdata,
    input [(C_AXI_L_DATA_WIDTH/8)-1:0]    s_axi_l_wstrb,
    input                                 s_axi_l_wvalid,
    output logic                          s_axi_l_wready,
    output logic [1:0]                    s_axi_l_bresp,
    output logic                          s_axi_l_bvalid,
    input                                 s_axi_l_bready,
    input [C_AXI_L_ADDR_WIDTH-1:0]        s_axi_l_araddr,
    input [2:0]                           s_axi_l_arprot,
    input                                 s_axi_l_arvalid,
    output logic                          s_axi_l_arready,
    output logic [C_AXI_L_DATA_WIDTH-1:0] s_axi_l_rdata,
    output logic [1:0]                    s_axi_l_rresp,
    output logic                          s_axi_l_rvalid,
    input                                 s_axi_l_rready,

    // AXI4-Stream data out
    input                                       m_axis_aclk,
    input                                       m_axis_aresetn,
    output [C_AXI_STREAM_DATA_WIDTH-1:0]        m_axis_tdata,
    output                                      m_axis_tlast,
    output                                      m_axis_tvalid,
    output [(C_AXI_STREAM_DATA_WIDTH/8)-1:0]    m_axis_tkeep,
    input                                       m_axis_tready

    );

localparam ADDR_LSB = (C_AXI_L_DATA_WIDTH/32) + 1;


// Reset for pmod module logic
logic pmodRst;
logic [7:0] resetPipe;

// pmod->axis fifo
logic [MIC_DATA_WIDTH-1:0] micData;
logic [C_DATA_WIDTH-1:0] i_fifo_axis_tdata;
logic micDataVld;
logic micDataVld_q;
logic i_fifo_axis_tvalid, i_fifo_axis_tlast;
logic [24:0] numSamplesRem;

// AXI-Lite controlled registers
logic [C_AXI_L_DATA_WIDTH-1:0] pmodResetReg, pmodControlReg, pmodSampleReg;
logic [C_AXI_L_ADDR_WIDTH-1:0] wrAddr, rdAddr;
logic wrEn, rdEn;

// Register decode
logic        swRst, swRst_sys;
logic [3:0]  divRateSelect, divRateSelect_sys;
logic [23:0] maxSamples, maxSamples_sys;
logic        pktEn, pktEn_sys;
logic        strEn, strEn_sys;


//*************************************
//* Instantiations
//*************************************

PmodMic3 #(
    .DATA_WIDTH(MIC_DATA_WIDTH),
    .LEADING_ZEROS(MIC_SPI_WIDTH-MIC_DATA_WIDTH)
    ) PmodMic3_inst (
    .clk(pmodClk),
    .rst(pmodRst),
    .i_divRateSelect(divRateSelect),
    .o_data(micData),
    .o_dataVld(micDataVld),
    .sclk(sclk),
    .cs_n(cs_n),
    .miso(miso)
);
assign i_fifo_axis_tdata  = micData << (C_DATA_WIDTH-MIC_DATA_WIDTH);
assign i_fifo_axis_tvalid = (micDataVld || micDataVld_q) && (strEn || (pktEn && numSamplesRem > 0));
assign i_fifo_axis_tlast  = pktEn && numSamplesRem == 1;

// Clock domain crossing and put into AXI-Stream format to send out data from PmodMic3
// xpm_fifo_axis: AXI Stream FIFO
// Xilinx Parameterized Macro, version 2020.2

xpm_fifo_axis #(
  .CDC_SYNC_STAGES(2),            // DECIMAL
  .CLOCKING_MODE("independent_clock"), // String
  .ECC_MODE("no_ecc"),            // String
  .FIFO_DEPTH(32),                // DECIMAL
  .FIFO_MEMORY_TYPE("auto"),      // String
  .PACKET_FIFO("false"),          // String
  .PROG_EMPTY_THRESH(10),         // DECIMAL
  .PROG_FULL_THRESH(10),          // DECIMAL
  .RD_DATA_COUNT_WIDTH(1),        // DECIMAL
  .RELATED_CLOCKS(0),             // DECIMAL
  .SIM_ASSERT_CHK(0),             // DECIMAL; 0=disable simulation messages, 1=enable simulation messages
  .TDATA_WIDTH(C_AXI_STREAM_DATA_WIDTH), // DECIMAL
  .TDEST_WIDTH(1),                // DECIMAL
  .TID_WIDTH(1),                  // DECIMAL
  .TUSER_WIDTH(1),                // DECIMAL
  .USE_ADV_FEATURES("1000"),      // String
  .WR_DATA_COUNT_WIDTH(1)         // DECIMAL
)
xpm_fifo_axis_inst (
  .almost_empty_axis(),
  .almost_full_axis(),
  .dbiterr_axis(),
  .m_axis_tdata(m_axis_tdata),             // TDATA_WIDTH-bit output: TDATA: The primary payload that is
                                           // used to provide the data that is passing across the
                                           // interface. The width of the data payload is an integer number
                                           // of bytes.

  .m_axis_tdest(),
  .m_axis_tid(),
  .m_axis_tkeep(m_axis_tkeep),             // TDATA_WIDTH/8-bit output: TKEEP: The byte qualifier that
                                           // indicates whether the content of the associated byte of TDATA
                                           // is processed as part of the data stream. Associated bytes
                                           // that have the TKEEP byte qualifier deasserted are null bytes
                                           // and can be removed from the data stream. For a 64-bit DATA,
                                           // bit 0 corresponds to the least significant byte on DATA, and
                                           // bit 7 corresponds to the most significant byte. For example:
                                           // KEEP[0] = 1b, DATA[7:0] is not a NULL byte KEEP[7] = 0b,
                                           // DATA[63:56] is a NULL byte

  .m_axis_tlast(m_axis_tlast),             // 1-bit output: TLAST: Indicates the boundary of a packet.
  .m_axis_tstrb(),
  .m_axis_tuser(),
  .m_axis_tvalid(m_axis_tvalid),           // 1-bit output: TVALID: Indicates that the master is driving a
                                           // valid transfer. A transfer takes place when both TVALID and
                                           // TREADY are asserted

  .prog_empty_axis(),
  .prog_full_axis(),
  .rd_data_count_axis(),
  // .rd_data_count_axis(fifoRdDataCnt),
  .s_axis_tready(s_axis_tready),           // 1-bit output: TREADY: Indicates that the slave can accept a
                                           // transfer in the current cycle.

  .sbiterr_axis(),
  .wr_data_count_axis(),
  .injectdbiterr_axis(),
  .injectsbiterr_axis(),
  .m_aclk(m_axis_aclk),                    // 1-bit input: Master Interface Clock: All signals on master
                                           // interface are sampled on the rising edge of this clock.

  .m_axis_tready(m_axis_tready),           // 1-bit input: TREADY: Indicates that the slave can accept a
                                           // transfer in the current cycle.

  .s_aclk(pmodClk),                        // 1-bit input: Slave Interface Clock: All signals on slave
                                           // interface are sampled on the rising edge of this clock.

  .s_aresetn(!pmodRst),                    // 1-bit input: Active low asynchronous reset.

  .s_axis_tdata(i_fifo_axis_tdata),        // TDATA_WIDTH-bit input: TDATA: The primary payload that is
                                           // used to provide the data that is passing across the
                                           // interface. The width of the data payload is an integer number
                                           // of bytes.

  .s_axis_tdest(0),                        // TDEST_WIDTH-bit input: TDEST: Provides routing information
                                           // for the data stream.

  .s_axis_tid(0),                          // TID_WIDTH-bit input: TID: The data stream identifier that
                                           // indicates different streams of data.

  .s_axis_tkeep({(C_AXI_STREAM_DATA_WIDTH/8){1'b1}}), // TDATA_WIDTH/8-bit input: TKEEP: The byte qualifier that
                                           // indicates whether the content of the associated byte of TDATA
                                           // is processed as part of the data stream. Associated bytes
                                           // that have the TKEEP byte qualifier deasserted are null bytes
                                           // and can be removed from the data stream. For a 64-bit DATA,
                                           // bit 0 corresponds to the least significant byte on DATA, and
                                           // bit 7 corresponds to the most significant byte. For example:
                                           // KEEP[0] = 1b, DATA[7:0] is not a NULL byte KEEP[7] = 0b,
                                           // DATA[63:56] is a NULL byte

  .s_axis_tlast(i_fifo_axis_tlast),        // 1-bit input: TLAST: Indicates the boundary of a packet.

  .s_axis_tstrb({(C_AXI_STREAM_DATA_WIDTH/8){1'b1}}), // TDATA_WIDTH/8-bit input: TSTRB: The byte qualifier that
                                           // indicates whether the content of the associated byte of TDATA
                                           // is processed as a data byte or a position byte. For a 64-bit
                                           // DATA, bit 0 corresponds to the least significant byte on
                                           // DATA, and bit 0 corresponds to the least significant byte on
                                           // DATA, and bit 7 corresponds to the most significant byte. For
                                           // example: STROBE[0] = 1b, DATA[7:0] is valid STROBE[7] = 0b,
                                           // DATA[63:56] is not valid

  .s_axis_tuser(0),                        // TUSER_WIDTH-bit input: TUSER: The user-defined sideband
                                           // information that can be transmitted alongside the data
                                           // stream.

  .s_axis_tvalid(i_fifo_axis_tvalid) // 1-bit input: TVALID: Indicates that the master is driving a
                                           // valid transfer. A transfer takes place when both TVALID and
                                           // TREADY are asserted

);
// End of xpm_fifo_axis_inst instantiation


// Clock domain crossing from sysClk to pmodClk

// xpm_cdc_array_single: Single-bit Array Synchronizer
// Xilinx Parameterized Macro, version 2020.2

// NOTE: using this instead of more complex XPM_CDC_GRAY b/c any glitching can be ignored since register values
// should not be changing while mic is enabled

xpm_cdc_array_single #(
  .DEST_SYNC_FF(2),   // DECIMAL; range: 2-10
  .INIT_SYNC_FF(0),   // DECIMAL; 0=disable simulation init values, 1=enable simulation init values
  .SIM_ASSERT_CHK(0), // DECIMAL; 0=disable simulation messages, 1=enable simulation messages
  .SRC_INPUT_REG(1),  // DECIMAL; 0=do not register input, 1=register input
  .WIDTH(4)           // DECIMAL; range: 1-1024
)
xpm_cdc_divRateSelect (
  .dest_out(divRateSelect), // WIDTH-bit output: src_in synchronized to the destination clock domain. This
                       // output is registered.

  .dest_clk(pmodClk), // 1-bit input: Clock signal for the destination clock domain.
  .src_clk(sysClk),   // 1-bit input: optional; required when SRC_INPUT_REG = 1
  .src_in(divRateSelect_sys)      // WIDTH-bit input: Input single-bit array to be synchronized to destination clock
                       // domain. It is assumed that each bit of the array is unrelated to the others. This
                       // is reflected in the constraints applied to this macro. To transfer a binary value
                       // losslessly across the two clock domains, use the XPM_CDC_GRAY macro instead.

);

xpm_cdc_array_single #(
  .DEST_SYNC_FF(2),
  .INIT_SYNC_FF(0),
  .SIM_ASSERT_CHK(0),
  .SRC_INPUT_REG(1),
  .WIDTH(24)
)
xpm_cdc_maxSamples (
  .dest_out(maxSamples),
  .dest_clk(pmodClk),
  .src_clk(sysClk),
  .src_in(maxSamples_sys)
);

xpm_cdc_single #(
  .DEST_SYNC_FF(2),
  .INIT_SYNC_FF(0),
  .SIM_ASSERT_CHK(0),
  .SRC_INPUT_REG(1)
)
xpm_cdc_swRst (
  .dest_out(swRst),
  .dest_clk(pmodClk),
  .src_clk(sysClk),
  .src_in(swRst_sys)
);

xpm_cdc_single #(
  .DEST_SYNC_FF(2),
  .INIT_SYNC_FF(0),
  .SIM_ASSERT_CHK(0),
  .SRC_INPUT_REG(1)
)
xpm_cdc_pktEn (
  .dest_out(pktEn),
  .dest_clk(pmodClk),
  .src_clk(sysClk),
  .src_in(pktEn_sys)
);

xpm_cdc_single #(
  .DEST_SYNC_FF(2),
  .INIT_SYNC_FF(0),
  .SIM_ASSERT_CHK(0),
  .SRC_INPUT_REG(1)
)
xpm_cdc_strEn (
  .dest_out(strEn),
  .dest_clk(pmodClk),
  .src_clk(sysClk),
  .src_in(strEn_sys)
);


//**********************
//* Logic
//**********************

// Generate a reset synchronous to the 12.288 MHz clock
always @(posedge pmodClk, negedge pmodClkLocked) begin
    if (!pmodClkLocked) begin
        resetPipe <= 8'hf;
        pmodRst   <= 1'b1;
    end else begin
        resetPipe <= resetPipe << 1;
        pmodRst   <= |resetPipe || swRst;
    end
end

// Decode register(s)
assign swRst_sys         = pmodResetReg[0];
assign pktEn_sys         = pmodControlReg[0];
assign strEn_sys         = pmodControlReg[4];
assign divRateSelect_sys = pmodSampleReg[24 +: 4];
assign maxSamples_sys    = pmodSampleReg[0 +: 24];

// Count mic samples taken
always @(posedge pmodClk) begin
    micDataVld_q <= micDataVld; // Each sample gets stored 2x (L&R channel)
    if ((micDataVld || micDataVld_q) && (strEn || (pktEn && numSamplesRem > 0))) begin
        numSamplesRem <= numSamplesRem - 1;
    end else if (!pktEn) begin
        numSamplesRem <= maxSamples;
    end
end

// AXI-LITE interface

assign wrEn = s_axi_l_awvalid && s_axi_l_wvalid && s_axi_l_awready && s_axi_l_wready;

always @(posedge s_axi_l_aclk) begin : AXI_WR_SIGNALS
    s_axi_l_awready <= 1'b0;
    s_axi_l_wready  <= 1'b0;

    if (s_axi_l_awvalid && s_axi_l_wvalid) begin
        if (!s_axi_l_awready) begin
            s_axi_l_awready <= 1'b1;
            wrAddr <= s_axi_l_awaddr;
        end

        if (!s_axi_l_wready) begin
            s_axi_l_wready <= 1'b1;
        end
    end

    s_axi_l_bresp <= 2'b0;
    if (wrEn) begin
        if (!s_axi_l_bvalid) begin
            s_axi_l_bvalid <= 1'b1;
        end
    end else if (s_axi_l_bready && s_axi_l_bvalid) begin
        s_axi_l_bvalid <= 1'b0;
    end

    // Reset
    if (!s_axi_l_aresetn) begin
        s_axi_l_awready <= 1'b0;
        s_axi_l_wready  <= 1'b0;
        s_axi_l_bresp   <= 2'b0;
        s_axi_l_bvalid  <= 1'b0;
    end
end

always @(posedge s_axi_l_aclk) begin : AXI_WRITE
    integer byteIdx, bitIdx;
    logic [7:0] wdata;
    for (byteIdx = 0; byteIdx < C_AXI_L_DATA_WIDTH/8; byteIdx = byteIdx + 1) begin
        bitIdx = byteIdx * 8;
        wdata  = s_axi_l_wdata[bitIdx +: 8];

        if (wrEn && s_axi_l_wstrb[byteIdx]) begin
            case (wrAddr[ADDR_LSB +: 2])
                2'b00 : pmodResetReg[bitIdx +: 8]   <= wdata;
                2'b01 : pmodControlReg[bitIdx +: 8] <= wdata;
                2'b10 : pmodSampleReg[bitIdx +: 8]  <= wdata;
                default : /* default */;
            endcase
        end
    end

    // Reset
    if (!s_axi_l_aresetn) begin
        pmodResetReg   <= 0;
        pmodControlReg <= 0;
    end
end

assign rdEn = s_axi_l_arvalid && s_axi_l_arready && !s_axi_l_rvalid;

always @(posedge s_axi_l_aclk) begin : AXI_RD_SIGNALS
    s_axi_l_arready <= 1'b0;

    if (s_axi_l_arvalid && !s_axi_l_arready) begin
        s_axi_l_arready <= 1'b1;
        rdAddr <= s_axi_l_araddr;
    end

    s_axi_l_rresp <= 2'b0;
    if (rdEn) begin
        s_axi_l_rvalid <= 1'b1;
    end else if (s_axi_l_rready && s_axi_l_rvalid) begin
        s_axi_l_rvalid <= 1'b0;
    end

    // Reset
    if (!s_axi_l_aresetn) begin
        s_axi_l_arready <= 1'b0;
        s_axi_l_rresp   <= 2'b0;
        s_axi_l_rvalid  <= 1'b0;
    end
end

always @(posedge s_axi_l_aclk) begin : AXI_READ
    if (rdEn) begin
        case (rdAddr[ADDR_LSB +: 2])
            2'b00 : s_axi_l_rdata <= pmodResetReg;
            2'b01 : s_axi_l_rdata <= pmodControlReg;
            2'b10 : s_axi_l_rdata <= pmodSampleReg;
            default : s_axi_l_rdata <= 0;
        endcase
    end

    // Reset
    if (!s_axi_l_aresetn) begin
        s_axi_l_rdata <= 0;
    end
end

endmodule
