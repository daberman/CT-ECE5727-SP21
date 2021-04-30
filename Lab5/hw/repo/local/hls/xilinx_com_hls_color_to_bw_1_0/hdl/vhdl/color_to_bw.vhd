-- ==============================================================
-- RTL generated by Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC
-- Version: 2017.4
-- Copyright (C) 1986-2017 Xilinx, Inc. All Rights Reserved.
-- 
-- ===========================================================

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity color_to_bw is
port (
    stream_in_TDATA : IN STD_LOGIC_VECTOR (23 downto 0);
    stream_in_TKEEP : IN STD_LOGIC_VECTOR (2 downto 0);
    stream_in_TSTRB : IN STD_LOGIC_VECTOR (2 downto 0);
    stream_in_TUSER : IN STD_LOGIC_VECTOR (0 downto 0);
    stream_in_TLAST : IN STD_LOGIC_VECTOR (0 downto 0);
    stream_in_TID : IN STD_LOGIC_VECTOR (0 downto 0);
    stream_in_TDEST : IN STD_LOGIC_VECTOR (0 downto 0);
    stream_out_TDATA : OUT STD_LOGIC_VECTOR (23 downto 0);
    stream_out_TKEEP : OUT STD_LOGIC_VECTOR (2 downto 0);
    stream_out_TSTRB : OUT STD_LOGIC_VECTOR (2 downto 0);
    stream_out_TUSER : OUT STD_LOGIC_VECTOR (0 downto 0);
    stream_out_TLAST : OUT STD_LOGIC_VECTOR (0 downto 0);
    stream_out_TID : OUT STD_LOGIC_VECTOR (0 downto 0);
    stream_out_TDEST : OUT STD_LOGIC_VECTOR (0 downto 0);
    ap_clk : IN STD_LOGIC;
    ap_rst_n : IN STD_LOGIC;
    stream_in_TVALID : IN STD_LOGIC;
    stream_in_TREADY : OUT STD_LOGIC;
    stream_out_TVALID : OUT STD_LOGIC;
    stream_out_TREADY : IN STD_LOGIC;
    ap_done : OUT STD_LOGIC;
    ap_start : IN STD_LOGIC;
    ap_ready : OUT STD_LOGIC;
    ap_idle : OUT STD_LOGIC );
end;


architecture behav of color_to_bw is 
    attribute CORE_GENERATION_INFO : STRING;
    attribute CORE_GENERATION_INFO of behav : architecture is
    "color_to_bw,hls_ip_2017_4,{HLS_INPUT_TYPE=cxx,HLS_INPUT_FLOAT=0,HLS_INPUT_FIXED=0,HLS_INPUT_PART=xc7z020clg400-1,HLS_INPUT_CLOCK=6.700000,HLS_INPUT_ARCH=dataflow,HLS_SYN_CLOCK=8.295000,HLS_SYN_LAT=926644,HLS_SYN_TPT=926644,HLS_SYN_MEM=0,HLS_SYN_DSP=3,HLS_SYN_FF=665,HLS_SYN_LUT=1487}";
    constant ap_const_lv24_0 : STD_LOGIC_VECTOR (23 downto 0) := "000000000000000000000000";
    constant ap_const_lv3_0 : STD_LOGIC_VECTOR (2 downto 0) := "000";
    constant ap_const_lv1_0 : STD_LOGIC_VECTOR (0 downto 0) := "0";
    constant ap_const_logic_1 : STD_LOGIC := '1';
    constant ap_const_logic_0 : STD_LOGIC := '0';

    signal ap_rst_n_inv : STD_LOGIC;
    signal AXIvideo2Mat_U0_ap_start : STD_LOGIC;
    signal AXIvideo2Mat_U0_ap_done : STD_LOGIC;
    signal AXIvideo2Mat_U0_ap_continue : STD_LOGIC;
    signal AXIvideo2Mat_U0_ap_idle : STD_LOGIC;
    signal AXIvideo2Mat_U0_ap_ready : STD_LOGIC;
    signal AXIvideo2Mat_U0_start_out : STD_LOGIC;
    signal AXIvideo2Mat_U0_start_write : STD_LOGIC;
    signal AXIvideo2Mat_U0_stream_in_TREADY : STD_LOGIC;
    signal AXIvideo2Mat_U0_img_data_stream_0_V_din : STD_LOGIC_VECTOR (7 downto 0);
    signal AXIvideo2Mat_U0_img_data_stream_0_V_write : STD_LOGIC;
    signal AXIvideo2Mat_U0_img_data_stream_1_V_din : STD_LOGIC_VECTOR (7 downto 0);
    signal AXIvideo2Mat_U0_img_data_stream_1_V_write : STD_LOGIC;
    signal AXIvideo2Mat_U0_img_data_stream_2_V_din : STD_LOGIC_VECTOR (7 downto 0);
    signal AXIvideo2Mat_U0_img_data_stream_2_V_write : STD_LOGIC;
    signal CvtColor_U0_ap_start : STD_LOGIC;
    signal CvtColor_U0_ap_done : STD_LOGIC;
    signal CvtColor_U0_ap_continue : STD_LOGIC;
    signal CvtColor_U0_ap_idle : STD_LOGIC;
    signal CvtColor_U0_ap_ready : STD_LOGIC;
    signal CvtColor_U0_start_out : STD_LOGIC;
    signal CvtColor_U0_start_write : STD_LOGIC;
    signal CvtColor_U0_p_src_data_stream_0_V_read : STD_LOGIC;
    signal CvtColor_U0_p_src_data_stream_1_V_read : STD_LOGIC;
    signal CvtColor_U0_p_src_data_stream_2_V_read : STD_LOGIC;
    signal CvtColor_U0_p_dst_data_stream_0_V_din : STD_LOGIC_VECTOR (7 downto 0);
    signal CvtColor_U0_p_dst_data_stream_0_V_write : STD_LOGIC;
    signal CvtColor_U0_p_dst_data_stream_1_V_din : STD_LOGIC_VECTOR (7 downto 0);
    signal CvtColor_U0_p_dst_data_stream_1_V_write : STD_LOGIC;
    signal CvtColor_U0_p_dst_data_stream_2_V_din : STD_LOGIC_VECTOR (7 downto 0);
    signal CvtColor_U0_p_dst_data_stream_2_V_write : STD_LOGIC;
    signal Mat2AXIvideo_U0_ap_start : STD_LOGIC;
    signal Mat2AXIvideo_U0_ap_done : STD_LOGIC;
    signal Mat2AXIvideo_U0_ap_continue : STD_LOGIC;
    signal Mat2AXIvideo_U0_ap_idle : STD_LOGIC;
    signal Mat2AXIvideo_U0_ap_ready : STD_LOGIC;
    signal Mat2AXIvideo_U0_img_data_stream_0_V_read : STD_LOGIC;
    signal Mat2AXIvideo_U0_img_data_stream_1_V_read : STD_LOGIC;
    signal Mat2AXIvideo_U0_img_data_stream_2_V_read : STD_LOGIC;
    signal Mat2AXIvideo_U0_stream_out_TDATA : STD_LOGIC_VECTOR (23 downto 0);
    signal Mat2AXIvideo_U0_stream_out_TVALID : STD_LOGIC;
    signal Mat2AXIvideo_U0_stream_out_TKEEP : STD_LOGIC_VECTOR (2 downto 0);
    signal Mat2AXIvideo_U0_stream_out_TSTRB : STD_LOGIC_VECTOR (2 downto 0);
    signal Mat2AXIvideo_U0_stream_out_TUSER : STD_LOGIC_VECTOR (0 downto 0);
    signal Mat2AXIvideo_U0_stream_out_TLAST : STD_LOGIC_VECTOR (0 downto 0);
    signal Mat2AXIvideo_U0_stream_out_TID : STD_LOGIC_VECTOR (0 downto 0);
    signal Mat2AXIvideo_U0_stream_out_TDEST : STD_LOGIC_VECTOR (0 downto 0);
    signal ap_sync_continue : STD_LOGIC;
    signal img0_data_stream_0_s_full_n : STD_LOGIC;
    signal img0_data_stream_0_s_dout : STD_LOGIC_VECTOR (7 downto 0);
    signal img0_data_stream_0_s_empty_n : STD_LOGIC;
    signal img0_data_stream_1_s_full_n : STD_LOGIC;
    signal img0_data_stream_1_s_dout : STD_LOGIC_VECTOR (7 downto 0);
    signal img0_data_stream_1_s_empty_n : STD_LOGIC;
    signal img0_data_stream_2_s_full_n : STD_LOGIC;
    signal img0_data_stream_2_s_dout : STD_LOGIC_VECTOR (7 downto 0);
    signal img0_data_stream_2_s_empty_n : STD_LOGIC;
    signal img1_data_stream_0_s_full_n : STD_LOGIC;
    signal img1_data_stream_0_s_dout : STD_LOGIC_VECTOR (7 downto 0);
    signal img1_data_stream_0_s_empty_n : STD_LOGIC;
    signal img1_data_stream_1_s_full_n : STD_LOGIC;
    signal img1_data_stream_1_s_dout : STD_LOGIC_VECTOR (7 downto 0);
    signal img1_data_stream_1_s_empty_n : STD_LOGIC;
    signal img1_data_stream_2_s_full_n : STD_LOGIC;
    signal img1_data_stream_2_s_dout : STD_LOGIC_VECTOR (7 downto 0);
    signal img1_data_stream_2_s_empty_n : STD_LOGIC;
    signal ap_sync_done : STD_LOGIC;
    signal ap_sync_ready : STD_LOGIC;
    signal start_for_CvtColor_U0_din : STD_LOGIC_VECTOR (0 downto 0);
    signal start_for_CvtColor_U0_full_n : STD_LOGIC;
    signal start_for_CvtColor_U0_dout : STD_LOGIC_VECTOR (0 downto 0);
    signal start_for_CvtColor_U0_empty_n : STD_LOGIC;
    signal start_for_Mat2AXIvideo_U0_din : STD_LOGIC_VECTOR (0 downto 0);
    signal start_for_Mat2AXIvideo_U0_full_n : STD_LOGIC;
    signal start_for_Mat2AXIvideo_U0_dout : STD_LOGIC_VECTOR (0 downto 0);
    signal start_for_Mat2AXIvideo_U0_empty_n : STD_LOGIC;
    signal Mat2AXIvideo_U0_start_full_n : STD_LOGIC;
    signal Mat2AXIvideo_U0_start_write : STD_LOGIC;

    component AXIvideo2Mat IS
    port (
        ap_clk : IN STD_LOGIC;
        ap_rst : IN STD_LOGIC;
        ap_start : IN STD_LOGIC;
        start_full_n : IN STD_LOGIC;
        ap_done : OUT STD_LOGIC;
        ap_continue : IN STD_LOGIC;
        ap_idle : OUT STD_LOGIC;
        ap_ready : OUT STD_LOGIC;
        start_out : OUT STD_LOGIC;
        start_write : OUT STD_LOGIC;
        stream_in_TDATA : IN STD_LOGIC_VECTOR (23 downto 0);
        stream_in_TVALID : IN STD_LOGIC;
        stream_in_TREADY : OUT STD_LOGIC;
        stream_in_TKEEP : IN STD_LOGIC_VECTOR (2 downto 0);
        stream_in_TSTRB : IN STD_LOGIC_VECTOR (2 downto 0);
        stream_in_TUSER : IN STD_LOGIC_VECTOR (0 downto 0);
        stream_in_TLAST : IN STD_LOGIC_VECTOR (0 downto 0);
        stream_in_TID : IN STD_LOGIC_VECTOR (0 downto 0);
        stream_in_TDEST : IN STD_LOGIC_VECTOR (0 downto 0);
        img_data_stream_0_V_din : OUT STD_LOGIC_VECTOR (7 downto 0);
        img_data_stream_0_V_full_n : IN STD_LOGIC;
        img_data_stream_0_V_write : OUT STD_LOGIC;
        img_data_stream_1_V_din : OUT STD_LOGIC_VECTOR (7 downto 0);
        img_data_stream_1_V_full_n : IN STD_LOGIC;
        img_data_stream_1_V_write : OUT STD_LOGIC;
        img_data_stream_2_V_din : OUT STD_LOGIC_VECTOR (7 downto 0);
        img_data_stream_2_V_full_n : IN STD_LOGIC;
        img_data_stream_2_V_write : OUT STD_LOGIC );
    end component;


    component CvtColor IS
    port (
        ap_clk : IN STD_LOGIC;
        ap_rst : IN STD_LOGIC;
        ap_start : IN STD_LOGIC;
        start_full_n : IN STD_LOGIC;
        ap_done : OUT STD_LOGIC;
        ap_continue : IN STD_LOGIC;
        ap_idle : OUT STD_LOGIC;
        ap_ready : OUT STD_LOGIC;
        start_out : OUT STD_LOGIC;
        start_write : OUT STD_LOGIC;
        p_src_data_stream_0_V_dout : IN STD_LOGIC_VECTOR (7 downto 0);
        p_src_data_stream_0_V_empty_n : IN STD_LOGIC;
        p_src_data_stream_0_V_read : OUT STD_LOGIC;
        p_src_data_stream_1_V_dout : IN STD_LOGIC_VECTOR (7 downto 0);
        p_src_data_stream_1_V_empty_n : IN STD_LOGIC;
        p_src_data_stream_1_V_read : OUT STD_LOGIC;
        p_src_data_stream_2_V_dout : IN STD_LOGIC_VECTOR (7 downto 0);
        p_src_data_stream_2_V_empty_n : IN STD_LOGIC;
        p_src_data_stream_2_V_read : OUT STD_LOGIC;
        p_dst_data_stream_0_V_din : OUT STD_LOGIC_VECTOR (7 downto 0);
        p_dst_data_stream_0_V_full_n : IN STD_LOGIC;
        p_dst_data_stream_0_V_write : OUT STD_LOGIC;
        p_dst_data_stream_1_V_din : OUT STD_LOGIC_VECTOR (7 downto 0);
        p_dst_data_stream_1_V_full_n : IN STD_LOGIC;
        p_dst_data_stream_1_V_write : OUT STD_LOGIC;
        p_dst_data_stream_2_V_din : OUT STD_LOGIC_VECTOR (7 downto 0);
        p_dst_data_stream_2_V_full_n : IN STD_LOGIC;
        p_dst_data_stream_2_V_write : OUT STD_LOGIC );
    end component;


    component Mat2AXIvideo IS
    port (
        ap_clk : IN STD_LOGIC;
        ap_rst : IN STD_LOGIC;
        ap_start : IN STD_LOGIC;
        ap_done : OUT STD_LOGIC;
        ap_continue : IN STD_LOGIC;
        ap_idle : OUT STD_LOGIC;
        ap_ready : OUT STD_LOGIC;
        img_data_stream_0_V_dout : IN STD_LOGIC_VECTOR (7 downto 0);
        img_data_stream_0_V_empty_n : IN STD_LOGIC;
        img_data_stream_0_V_read : OUT STD_LOGIC;
        img_data_stream_1_V_dout : IN STD_LOGIC_VECTOR (7 downto 0);
        img_data_stream_1_V_empty_n : IN STD_LOGIC;
        img_data_stream_1_V_read : OUT STD_LOGIC;
        img_data_stream_2_V_dout : IN STD_LOGIC_VECTOR (7 downto 0);
        img_data_stream_2_V_empty_n : IN STD_LOGIC;
        img_data_stream_2_V_read : OUT STD_LOGIC;
        stream_out_TDATA : OUT STD_LOGIC_VECTOR (23 downto 0);
        stream_out_TVALID : OUT STD_LOGIC;
        stream_out_TREADY : IN STD_LOGIC;
        stream_out_TKEEP : OUT STD_LOGIC_VECTOR (2 downto 0);
        stream_out_TSTRB : OUT STD_LOGIC_VECTOR (2 downto 0);
        stream_out_TUSER : OUT STD_LOGIC_VECTOR (0 downto 0);
        stream_out_TLAST : OUT STD_LOGIC_VECTOR (0 downto 0);
        stream_out_TID : OUT STD_LOGIC_VECTOR (0 downto 0);
        stream_out_TDEST : OUT STD_LOGIC_VECTOR (0 downto 0) );
    end component;


    component fifo_w8_d1_A IS
    port (
        clk : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        if_read_ce : IN STD_LOGIC;
        if_write_ce : IN STD_LOGIC;
        if_din : IN STD_LOGIC_VECTOR (7 downto 0);
        if_full_n : OUT STD_LOGIC;
        if_write : IN STD_LOGIC;
        if_dout : OUT STD_LOGIC_VECTOR (7 downto 0);
        if_empty_n : OUT STD_LOGIC;
        if_read : IN STD_LOGIC );
    end component;


    component start_for_CvtColoeOg IS
    port (
        clk : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        if_read_ce : IN STD_LOGIC;
        if_write_ce : IN STD_LOGIC;
        if_din : IN STD_LOGIC_VECTOR (0 downto 0);
        if_full_n : OUT STD_LOGIC;
        if_write : IN STD_LOGIC;
        if_dout : OUT STD_LOGIC_VECTOR (0 downto 0);
        if_empty_n : OUT STD_LOGIC;
        if_read : IN STD_LOGIC );
    end component;


    component start_for_Mat2AXIfYi IS
    port (
        clk : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        if_read_ce : IN STD_LOGIC;
        if_write_ce : IN STD_LOGIC;
        if_din : IN STD_LOGIC_VECTOR (0 downto 0);
        if_full_n : OUT STD_LOGIC;
        if_write : IN STD_LOGIC;
        if_dout : OUT STD_LOGIC_VECTOR (0 downto 0);
        if_empty_n : OUT STD_LOGIC;
        if_read : IN STD_LOGIC );
    end component;



begin
    AXIvideo2Mat_U0 : component AXIvideo2Mat
    port map (
        ap_clk => ap_clk,
        ap_rst => ap_rst_n_inv,
        ap_start => AXIvideo2Mat_U0_ap_start,
        start_full_n => start_for_CvtColor_U0_full_n,
        ap_done => AXIvideo2Mat_U0_ap_done,
        ap_continue => AXIvideo2Mat_U0_ap_continue,
        ap_idle => AXIvideo2Mat_U0_ap_idle,
        ap_ready => AXIvideo2Mat_U0_ap_ready,
        start_out => AXIvideo2Mat_U0_start_out,
        start_write => AXIvideo2Mat_U0_start_write,
        stream_in_TDATA => stream_in_TDATA,
        stream_in_TVALID => stream_in_TVALID,
        stream_in_TREADY => AXIvideo2Mat_U0_stream_in_TREADY,
        stream_in_TKEEP => stream_in_TKEEP,
        stream_in_TSTRB => stream_in_TSTRB,
        stream_in_TUSER => stream_in_TUSER,
        stream_in_TLAST => stream_in_TLAST,
        stream_in_TID => stream_in_TID,
        stream_in_TDEST => stream_in_TDEST,
        img_data_stream_0_V_din => AXIvideo2Mat_U0_img_data_stream_0_V_din,
        img_data_stream_0_V_full_n => img0_data_stream_0_s_full_n,
        img_data_stream_0_V_write => AXIvideo2Mat_U0_img_data_stream_0_V_write,
        img_data_stream_1_V_din => AXIvideo2Mat_U0_img_data_stream_1_V_din,
        img_data_stream_1_V_full_n => img0_data_stream_1_s_full_n,
        img_data_stream_1_V_write => AXIvideo2Mat_U0_img_data_stream_1_V_write,
        img_data_stream_2_V_din => AXIvideo2Mat_U0_img_data_stream_2_V_din,
        img_data_stream_2_V_full_n => img0_data_stream_2_s_full_n,
        img_data_stream_2_V_write => AXIvideo2Mat_U0_img_data_stream_2_V_write);

    CvtColor_U0 : component CvtColor
    port map (
        ap_clk => ap_clk,
        ap_rst => ap_rst_n_inv,
        ap_start => CvtColor_U0_ap_start,
        start_full_n => start_for_Mat2AXIvideo_U0_full_n,
        ap_done => CvtColor_U0_ap_done,
        ap_continue => CvtColor_U0_ap_continue,
        ap_idle => CvtColor_U0_ap_idle,
        ap_ready => CvtColor_U0_ap_ready,
        start_out => CvtColor_U0_start_out,
        start_write => CvtColor_U0_start_write,
        p_src_data_stream_0_V_dout => img0_data_stream_0_s_dout,
        p_src_data_stream_0_V_empty_n => img0_data_stream_0_s_empty_n,
        p_src_data_stream_0_V_read => CvtColor_U0_p_src_data_stream_0_V_read,
        p_src_data_stream_1_V_dout => img0_data_stream_1_s_dout,
        p_src_data_stream_1_V_empty_n => img0_data_stream_1_s_empty_n,
        p_src_data_stream_1_V_read => CvtColor_U0_p_src_data_stream_1_V_read,
        p_src_data_stream_2_V_dout => img0_data_stream_2_s_dout,
        p_src_data_stream_2_V_empty_n => img0_data_stream_2_s_empty_n,
        p_src_data_stream_2_V_read => CvtColor_U0_p_src_data_stream_2_V_read,
        p_dst_data_stream_0_V_din => CvtColor_U0_p_dst_data_stream_0_V_din,
        p_dst_data_stream_0_V_full_n => img1_data_stream_0_s_full_n,
        p_dst_data_stream_0_V_write => CvtColor_U0_p_dst_data_stream_0_V_write,
        p_dst_data_stream_1_V_din => CvtColor_U0_p_dst_data_stream_1_V_din,
        p_dst_data_stream_1_V_full_n => img1_data_stream_1_s_full_n,
        p_dst_data_stream_1_V_write => CvtColor_U0_p_dst_data_stream_1_V_write,
        p_dst_data_stream_2_V_din => CvtColor_U0_p_dst_data_stream_2_V_din,
        p_dst_data_stream_2_V_full_n => img1_data_stream_2_s_full_n,
        p_dst_data_stream_2_V_write => CvtColor_U0_p_dst_data_stream_2_V_write);

    Mat2AXIvideo_U0 : component Mat2AXIvideo
    port map (
        ap_clk => ap_clk,
        ap_rst => ap_rst_n_inv,
        ap_start => Mat2AXIvideo_U0_ap_start,
        ap_done => Mat2AXIvideo_U0_ap_done,
        ap_continue => Mat2AXIvideo_U0_ap_continue,
        ap_idle => Mat2AXIvideo_U0_ap_idle,
        ap_ready => Mat2AXIvideo_U0_ap_ready,
        img_data_stream_0_V_dout => img1_data_stream_0_s_dout,
        img_data_stream_0_V_empty_n => img1_data_stream_0_s_empty_n,
        img_data_stream_0_V_read => Mat2AXIvideo_U0_img_data_stream_0_V_read,
        img_data_stream_1_V_dout => img1_data_stream_1_s_dout,
        img_data_stream_1_V_empty_n => img1_data_stream_1_s_empty_n,
        img_data_stream_1_V_read => Mat2AXIvideo_U0_img_data_stream_1_V_read,
        img_data_stream_2_V_dout => img1_data_stream_2_s_dout,
        img_data_stream_2_V_empty_n => img1_data_stream_2_s_empty_n,
        img_data_stream_2_V_read => Mat2AXIvideo_U0_img_data_stream_2_V_read,
        stream_out_TDATA => Mat2AXIvideo_U0_stream_out_TDATA,
        stream_out_TVALID => Mat2AXIvideo_U0_stream_out_TVALID,
        stream_out_TREADY => stream_out_TREADY,
        stream_out_TKEEP => Mat2AXIvideo_U0_stream_out_TKEEP,
        stream_out_TSTRB => Mat2AXIvideo_U0_stream_out_TSTRB,
        stream_out_TUSER => Mat2AXIvideo_U0_stream_out_TUSER,
        stream_out_TLAST => Mat2AXIvideo_U0_stream_out_TLAST,
        stream_out_TID => Mat2AXIvideo_U0_stream_out_TID,
        stream_out_TDEST => Mat2AXIvideo_U0_stream_out_TDEST);

    img0_data_stream_0_s_U : component fifo_w8_d1_A
    port map (
        clk => ap_clk,
        reset => ap_rst_n_inv,
        if_read_ce => ap_const_logic_1,
        if_write_ce => ap_const_logic_1,
        if_din => AXIvideo2Mat_U0_img_data_stream_0_V_din,
        if_full_n => img0_data_stream_0_s_full_n,
        if_write => AXIvideo2Mat_U0_img_data_stream_0_V_write,
        if_dout => img0_data_stream_0_s_dout,
        if_empty_n => img0_data_stream_0_s_empty_n,
        if_read => CvtColor_U0_p_src_data_stream_0_V_read);

    img0_data_stream_1_s_U : component fifo_w8_d1_A
    port map (
        clk => ap_clk,
        reset => ap_rst_n_inv,
        if_read_ce => ap_const_logic_1,
        if_write_ce => ap_const_logic_1,
        if_din => AXIvideo2Mat_U0_img_data_stream_1_V_din,
        if_full_n => img0_data_stream_1_s_full_n,
        if_write => AXIvideo2Mat_U0_img_data_stream_1_V_write,
        if_dout => img0_data_stream_1_s_dout,
        if_empty_n => img0_data_stream_1_s_empty_n,
        if_read => CvtColor_U0_p_src_data_stream_1_V_read);

    img0_data_stream_2_s_U : component fifo_w8_d1_A
    port map (
        clk => ap_clk,
        reset => ap_rst_n_inv,
        if_read_ce => ap_const_logic_1,
        if_write_ce => ap_const_logic_1,
        if_din => AXIvideo2Mat_U0_img_data_stream_2_V_din,
        if_full_n => img0_data_stream_2_s_full_n,
        if_write => AXIvideo2Mat_U0_img_data_stream_2_V_write,
        if_dout => img0_data_stream_2_s_dout,
        if_empty_n => img0_data_stream_2_s_empty_n,
        if_read => CvtColor_U0_p_src_data_stream_2_V_read);

    img1_data_stream_0_s_U : component fifo_w8_d1_A
    port map (
        clk => ap_clk,
        reset => ap_rst_n_inv,
        if_read_ce => ap_const_logic_1,
        if_write_ce => ap_const_logic_1,
        if_din => CvtColor_U0_p_dst_data_stream_0_V_din,
        if_full_n => img1_data_stream_0_s_full_n,
        if_write => CvtColor_U0_p_dst_data_stream_0_V_write,
        if_dout => img1_data_stream_0_s_dout,
        if_empty_n => img1_data_stream_0_s_empty_n,
        if_read => Mat2AXIvideo_U0_img_data_stream_0_V_read);

    img1_data_stream_1_s_U : component fifo_w8_d1_A
    port map (
        clk => ap_clk,
        reset => ap_rst_n_inv,
        if_read_ce => ap_const_logic_1,
        if_write_ce => ap_const_logic_1,
        if_din => CvtColor_U0_p_dst_data_stream_1_V_din,
        if_full_n => img1_data_stream_1_s_full_n,
        if_write => CvtColor_U0_p_dst_data_stream_1_V_write,
        if_dout => img1_data_stream_1_s_dout,
        if_empty_n => img1_data_stream_1_s_empty_n,
        if_read => Mat2AXIvideo_U0_img_data_stream_1_V_read);

    img1_data_stream_2_s_U : component fifo_w8_d1_A
    port map (
        clk => ap_clk,
        reset => ap_rst_n_inv,
        if_read_ce => ap_const_logic_1,
        if_write_ce => ap_const_logic_1,
        if_din => CvtColor_U0_p_dst_data_stream_2_V_din,
        if_full_n => img1_data_stream_2_s_full_n,
        if_write => CvtColor_U0_p_dst_data_stream_2_V_write,
        if_dout => img1_data_stream_2_s_dout,
        if_empty_n => img1_data_stream_2_s_empty_n,
        if_read => Mat2AXIvideo_U0_img_data_stream_2_V_read);

    start_for_CvtColoeOg_U : component start_for_CvtColoeOg
    port map (
        clk => ap_clk,
        reset => ap_rst_n_inv,
        if_read_ce => ap_const_logic_1,
        if_write_ce => ap_const_logic_1,
        if_din => start_for_CvtColor_U0_din,
        if_full_n => start_for_CvtColor_U0_full_n,
        if_write => AXIvideo2Mat_U0_start_write,
        if_dout => start_for_CvtColor_U0_dout,
        if_empty_n => start_for_CvtColor_U0_empty_n,
        if_read => CvtColor_U0_ap_ready);

    start_for_Mat2AXIfYi_U : component start_for_Mat2AXIfYi
    port map (
        clk => ap_clk,
        reset => ap_rst_n_inv,
        if_read_ce => ap_const_logic_1,
        if_write_ce => ap_const_logic_1,
        if_din => start_for_Mat2AXIvideo_U0_din,
        if_full_n => start_for_Mat2AXIvideo_U0_full_n,
        if_write => CvtColor_U0_start_write,
        if_dout => start_for_Mat2AXIvideo_U0_dout,
        if_empty_n => start_for_Mat2AXIvideo_U0_empty_n,
        if_read => Mat2AXIvideo_U0_ap_ready);




    AXIvideo2Mat_U0_ap_continue <= ap_const_logic_1;
    AXIvideo2Mat_U0_ap_start <= ap_start;
    CvtColor_U0_ap_continue <= ap_const_logic_1;
    CvtColor_U0_ap_start <= start_for_CvtColor_U0_empty_n;
    Mat2AXIvideo_U0_ap_continue <= ap_const_logic_1;
    Mat2AXIvideo_U0_ap_start <= start_for_Mat2AXIvideo_U0_empty_n;
    Mat2AXIvideo_U0_start_full_n <= ap_const_logic_1;
    Mat2AXIvideo_U0_start_write <= ap_const_logic_0;
    ap_done <= Mat2AXIvideo_U0_ap_done;
    ap_idle <= (Mat2AXIvideo_U0_ap_idle and CvtColor_U0_ap_idle and AXIvideo2Mat_U0_ap_idle);
    ap_ready <= AXIvideo2Mat_U0_ap_ready;

    ap_rst_n_inv_assign_proc : process(ap_rst_n)
    begin
                ap_rst_n_inv <= not(ap_rst_n);
    end process;

    ap_sync_continue <= ap_const_logic_1;
    ap_sync_done <= Mat2AXIvideo_U0_ap_done;
    ap_sync_ready <= AXIvideo2Mat_U0_ap_ready;
    start_for_CvtColor_U0_din <= (0=>ap_const_logic_1, others=>'-');
    start_for_Mat2AXIvideo_U0_din <= (0=>ap_const_logic_1, others=>'-');
    stream_in_TREADY <= AXIvideo2Mat_U0_stream_in_TREADY;
    stream_out_TDATA <= Mat2AXIvideo_U0_stream_out_TDATA;
    stream_out_TDEST <= Mat2AXIvideo_U0_stream_out_TDEST;
    stream_out_TID <= Mat2AXIvideo_U0_stream_out_TID;
    stream_out_TKEEP <= Mat2AXIvideo_U0_stream_out_TKEEP;
    stream_out_TLAST <= Mat2AXIvideo_U0_stream_out_TLAST;
    stream_out_TSTRB <= Mat2AXIvideo_U0_stream_out_TSTRB;
    stream_out_TUSER <= Mat2AXIvideo_U0_stream_out_TUSER;
    stream_out_TVALID <= Mat2AXIvideo_U0_stream_out_TVALID;
end behav;
