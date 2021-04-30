# Maximum targeted pixel clock frequency for dynamic video clock generator is 148.5 MHz.
# However, BUFIO/BUFR/OSERDESE2 primitives need to be overclocked for FPGA. The maximum they will do is 600/120MHz.
# So we are underconstraining the pixel clock tree in general to avoid pulse width errors in the report on those primitives.
# However, we are constraining the pixel clock to its actual frequency. This way the quality of implementation will not change.

# Pixel clock tree underconstrained to 120 MHz to avoid pulse width errors on BUFIO/BUFR/OSERDESE2
# The MMCM outputs 5x this frequency for DVI serial clock, and is divided back by a BUFR.
# Period = 1/(5*120MHz) = 1.667 ns
create_clock -period 1.667 -name video_dynclk [get_pins -regexp .*video_dynclk/.*/mmcm_adv_inst/CLKOUT0 -hierarchical]
# Uncomment below to disable underconstraining and live with the Pulse Width errors (line with BUFR clock further down needs to be commented)
#create_clock -period 1.347 -name video_dynclk [get_pins -regexp .*video_dynclk/.*/mmcm_adv_inst/CLKOUT0 -hierarchical]

# Pixel clock constrained to 148.5 MHz on the output of BUFR
# Works because the clock path delay is not necessary to be analyzed all the way from the source clock of the MMCM, since there is no
# phase requirement between the source clock and the pixel clock
# Comment below to disable underconstraining and live with the Pulse Width errors
create_clock -period 6.734 -name pixel_dynclk [get_pins -regexp .*DVIClocking_0/inst/PixelClkBuffer/O -hierarchical]

# Workaround for FIFO XDC not getting applied
#set_false_path -through [get_pins system_i/MIPI_CSI_2_RX_0/U0/MIPI_CSI2_Rx_inst/LLP_inst/DataFIFO/s_aresetn] -to [get_pins -hierarchical -filter {NAME =~ system_i/MIPI_CSI_2_RX_0/U0/MIPI_CSI2_Rx_inst/LLP_inst/DataFIFO/*rstblk*/*PRE}]
#set_false_path -from [get_cells -hierarchical -filter {NAME =~ system_i/MIPI_CSI_2_RX_0/U0/MIPI_CSI2_Rx_inst/LLP_inst/DataFIFO/*rstblk*/*rst_reg_reg[*]}]



set_false_path -from [get_ports {dphy_data_hs_*[*]}] -to [get_pins {system_i/camera_in/MIPI_D_PHY_RX_0/U0/DataLaneGen[*].DPHY_LaneSFEN_X/HSDeserializerX/Deserializer/DDLY}]
