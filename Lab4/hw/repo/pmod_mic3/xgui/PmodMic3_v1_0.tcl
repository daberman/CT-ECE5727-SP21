# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  set C_AXI_L_ADDR_WIDTH [ipgui::add_param $IPINST -name "C_AXI_L_ADDR_WIDTH" -parent ${Page_0}]
  set_property tooltip {Axi-Lite Address Width} ${C_AXI_L_ADDR_WIDTH}
  ipgui::add_param $IPINST -name "C_AXI_L_DATA_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_AXI_STREAM_DATA_WIDTH" -parent ${Page_0}
  set C_DATA_WIDTH [ipgui::add_param $IPINST -name "C_DATA_WIDTH" -parent ${Page_0}]
  set_property tooltip {Width of right-aligned data within m_axis_tdata} ${C_DATA_WIDTH}
  ipgui::add_param $IPINST -name "MIC_DATA_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "MIC_SPI_WIDTH" -parent ${Page_0}


}

proc update_PARAM_VALUE.C_AXI_L_ADDR_WIDTH { PARAM_VALUE.C_AXI_L_ADDR_WIDTH } {
	# Procedure called to update C_AXI_L_ADDR_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_AXI_L_ADDR_WIDTH { PARAM_VALUE.C_AXI_L_ADDR_WIDTH } {
	# Procedure called to validate C_AXI_L_ADDR_WIDTH
	return true
}

proc update_PARAM_VALUE.C_AXI_L_DATA_WIDTH { PARAM_VALUE.C_AXI_L_DATA_WIDTH } {
	# Procedure called to update C_AXI_L_DATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_AXI_L_DATA_WIDTH { PARAM_VALUE.C_AXI_L_DATA_WIDTH } {
	# Procedure called to validate C_AXI_L_DATA_WIDTH
	return true
}

proc update_PARAM_VALUE.C_AXI_STREAM_DATA_WIDTH { PARAM_VALUE.C_AXI_STREAM_DATA_WIDTH } {
	# Procedure called to update C_AXI_STREAM_DATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_AXI_STREAM_DATA_WIDTH { PARAM_VALUE.C_AXI_STREAM_DATA_WIDTH } {
	# Procedure called to validate C_AXI_STREAM_DATA_WIDTH
	return true
}

proc update_PARAM_VALUE.C_DATA_WIDTH { PARAM_VALUE.C_DATA_WIDTH } {
	# Procedure called to update C_DATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_DATA_WIDTH { PARAM_VALUE.C_DATA_WIDTH } {
	# Procedure called to validate C_DATA_WIDTH
	return true
}

proc update_PARAM_VALUE.MIC_DATA_WIDTH { PARAM_VALUE.MIC_DATA_WIDTH } {
	# Procedure called to update MIC_DATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.MIC_DATA_WIDTH { PARAM_VALUE.MIC_DATA_WIDTH } {
	# Procedure called to validate MIC_DATA_WIDTH
	return true
}

proc update_PARAM_VALUE.MIC_SPI_WIDTH { PARAM_VALUE.MIC_SPI_WIDTH } {
	# Procedure called to update MIC_SPI_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.MIC_SPI_WIDTH { PARAM_VALUE.MIC_SPI_WIDTH } {
	# Procedure called to validate MIC_SPI_WIDTH
	return true
}


proc update_MODELPARAM_VALUE.C_AXI_STREAM_DATA_WIDTH { MODELPARAM_VALUE.C_AXI_STREAM_DATA_WIDTH PARAM_VALUE.C_AXI_STREAM_DATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_AXI_STREAM_DATA_WIDTH}] ${MODELPARAM_VALUE.C_AXI_STREAM_DATA_WIDTH}
}

proc update_MODELPARAM_VALUE.C_AXI_L_DATA_WIDTH { MODELPARAM_VALUE.C_AXI_L_DATA_WIDTH PARAM_VALUE.C_AXI_L_DATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_AXI_L_DATA_WIDTH}] ${MODELPARAM_VALUE.C_AXI_L_DATA_WIDTH}
}

proc update_MODELPARAM_VALUE.C_AXI_L_ADDR_WIDTH { MODELPARAM_VALUE.C_AXI_L_ADDR_WIDTH PARAM_VALUE.C_AXI_L_ADDR_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_AXI_L_ADDR_WIDTH}] ${MODELPARAM_VALUE.C_AXI_L_ADDR_WIDTH}
}

proc update_MODELPARAM_VALUE.C_DATA_WIDTH { MODELPARAM_VALUE.C_DATA_WIDTH PARAM_VALUE.C_DATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_DATA_WIDTH}] ${MODELPARAM_VALUE.C_DATA_WIDTH}
}

proc update_MODELPARAM_VALUE.MIC_DATA_WIDTH { MODELPARAM_VALUE.MIC_DATA_WIDTH PARAM_VALUE.MIC_DATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.MIC_DATA_WIDTH}] ${MODELPARAM_VALUE.MIC_DATA_WIDTH}
}

proc update_MODELPARAM_VALUE.MIC_SPI_WIDTH { MODELPARAM_VALUE.MIC_SPI_WIDTH PARAM_VALUE.MIC_SPI_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.MIC_SPI_WIDTH}] ${MODELPARAM_VALUE.MIC_SPI_WIDTH}
}

