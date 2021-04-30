# Run this script to create the Vivado project files NEXT TO THIS script
# If ::create_path global variable is set, the project is created under that path instead of the working dir

if {[info exists ::create_path]} {
	set dest_dir $::create_path
} else {
	set dest_dir [file normalize [file dirname [info script]]]
}
puts "INFO: Creating new project in $dest_dir"
cd $dest_dir

# Set the reference directory for source file relative paths (by default the value is script directory path)
set proj_name "zyboz7_pcam"
set part "xc7z010clg400-1"
set board "digilentinc.com:zybo-z7-10:part0:1.0"
set vivado_version [version -short]

# Set the reference directory for source file relative paths (by default the value is script directory path)
set origin_dir ".."

# Set the directory path for the original project from where this script was exported
set orig_proj_dir "[file normalize "$origin_dir/proj"]"

set src_dir $origin_dir/src
set repo_local_dir $origin_dir/repo/local
set repo_digi_dir  $origin_dir/repo/vivado-library
set repo_global_dir ""

# Create project
create_project $proj_name $dest_dir

# Set the directory path for the new project
set proj_dir [get_property directory [current_project]]

# Set project properties
set obj [get_projects $proj_name]
set_property "default_lib" "xil_defaultlib" $obj
set_property "part" $part $obj
set_property "board_part" $board $obj
set_property "simulator_language" "Mixed" $obj
set_property "target_language" "Verilog" $obj

# Uncomment the following 3 lines to greatly increase build speed while working with IP cores (and/or block diagrams)
set_property "corecontainer.enable" "0" $obj
set_property "ip_cache_permissions" "read write" $obj
#set_property "ip_output_repo" "[file normalize "$origin_dir/repo/cache"]" $obj

# Create 'sources_1' fileset (if not found)
if {[string equal [get_filesets -quiet sources_1] ""]} {
  create_fileset -srcset sources_1
}

# Create 'constrs_1' fileset (if not found)
if {[string equal [get_filesets -quiet constrs_1] ""]} {
  create_fileset -constrset constrs_1
}

# Set IP repository paths
set obj [get_filesets sources_1]
set_property "ip_repo_paths" "[file normalize $repo_local_dir] [file normalize $repo_digi_dir] [file normalize $repo_global_dir]" $obj

# Add conventional sources
add_files -quiet $src_dir/hdl

# Add IPs
add_files -quiet [glob -nocomplain ../src/ip/*.xci]

# Add constraints
add_files -fileset constrs_1 -quiet $src_dir/constraints

# Refresh IP Repositories
update_ip_catalog

# Create 'synth_1' run (if not found)
if {[string equal [get_runs -quiet synth_1] ""]} {
    create_run -name synth_1 -part xc7z010clg400-1 -flow {Vivado Synthesis 2018} -strategy "Vivado Synthesis Defaults" -report_strategy {No Reports} -constrset constrs_1
} else {
  set_property strategy "Vivado Synthesis Defaults" [get_runs synth_1]
  set_property flow "Vivado Synthesis 2018" [get_runs synth_1]
}

set obj [get_runs synth_1]
set_property -name "part" -value "xc7z010clg400-1" -objects $obj
set_property -name "strategy" -value "Vivado Synthesis Defaults" -objects $obj

# set the current synth run
current_run -synthesis [get_runs synth_1]

# Create 'impl_1' run (if not found)
if {[string equal [get_runs -quiet impl_1] ""]} {
    create_run -name impl_1 -part xc7z010clg400-1 -flow {Vivado Implementation 2018} -strategy "Vivado Implementation Defaults" -report_strategy {No Reports} -constrset constrs_1 -parent_run synth_1
} else {
  set_property strategy "Vivado Implementation Defaults" [get_runs impl_1]
  set_property flow "Vivado Implementation 2018" [get_runs impl_1]
}

# set the current impl run
current_run -implementation [get_runs impl_1]

puts "INFO: Project created:$proj_name"

# Comment the following section, if there is no block design
# Create block design
source $origin_dir/src/bd/system_${vivado_version}.tcl

# Generate the wrapper
set design_name [get_bd_designs]
add_files -norecurse [make_wrapper -files [get_files $design_name.bd] -top -force]

set obj [get_filesets sources_1]
set_property "top" "${design_name}_wrapper" $obj
set obj [get_filesets sim_1]
set_property "top" "${design_name}_wrapper" $obj

puts "INFO: Block design created: $design_name.bd"

regenerate_bd_layout

# Create SDK workspace
set sdk_dir $origin_dir/sdk

#set hw_list [glob -nocomplain $sdk_dir/*hw_platform*]
#if {[llength $hw_list] != 0} {
#  foreach hw_plat $hw_list {
#	file delete -force $hw_plat
#  }
#}

#set sdk_list [glob -nocomplain $sdk_dir/*]
#set sdk_list [lsearch -inline -all -not -exact $sdk_list "../sdk/.keep"]
#if {[llength $sdk_list] != 0} {
#	exec xsct -eval "setws -switch ../sdk; importproject ../sdk"
#}