
#################################################################################
# FPGA Based Smart Traffic Light Controller
# Constraints File (.xdc)
# Target Device : Artix-7 FPGA
# Tool          : Vivado 2024.x
#################################################################################

set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]

########################
# CLOCK INPUT
########################

set_property PACKAGE_PIN W5 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]
create_clock -period 10.000 -name sys_clk_pin -waveform {0 5} [get_ports clk]

########################
# RESET INPUT
########################

set_property PACKAGE_PIN U18 [get_ports reset]
set_property IOSTANDARD LVCMOS33 [get_ports reset]

########################
# PEDESTRIAN REQUEST
########################

set_property PACKAGE_PIN T18 [get_ports pedestrian_request]
set_property IOSTANDARD LVCMOS33 [get_ports pedestrian_request]

########################
# EMERGENCY REQUEST
########################

set_property PACKAGE_PIN W19 [get_ports emergency_request]
set_property IOSTANDARD LVCMOS33 [get_ports emergency_request]

########################
# NIGHT MODE INPUT
########################

set_property PACKAGE_PIN T17 [get_ports night_mode]
set_property IOSTANDARD LVCMOS33 [get_ports night_mode]

########################
# MAIN ROAD TRAFFIC LIGHTS
########################

set_property PACKAGE_PIN U16 [get_ports {main_traffic_lights[0]}]
set_property PACKAGE_PIN E19 [get_ports {main_traffic_lights[1]}]
set_property PACKAGE_PIN U19 [get_ports {main_traffic_lights[2]}]

set_property IOSTANDARD LVCMOS33 [get_ports {main_traffic_lights[*]}]

########################
# SIDE ROAD TRAFFIC LIGHTS
########################

set_property PACKAGE_PIN V19 [get_ports {side_traffic_lights[0]}]
set_property PACKAGE_PIN W18 [get_ports {side_traffic_lights[1]}]
set_property PACKAGE_PIN U15 [get_ports {side_traffic_lights[2]}]

set_property IOSTANDARD LVCMOS33 [get_ports {side_traffic_lights[*]}]

########################
# PEDESTRIAN CROSSING ENABLE
########################

set_property PACKAGE_PIN V17 [get_ports ped_crossing_enable]
set_property IOSTANDARD LVCMOS33 [get_ports ped_crossing_enable]

########################
# TIME OUTPUTS
########################

set_property PACKAGE_PIN W16 [get_ports {Time[0]}]
set_property PACKAGE_PIN V16 [get_ports {Time[1]}]
set_property PACKAGE_PIN W17 [get_ports {Time[2]}]
set_property PACKAGE_PIN V15 [get_ports {Time[3]}]
set_property PACKAGE_PIN W15 [get_ports {Time[4]}]
set_property PACKAGE_PIN P17 [get_ports {Time[5]}]
set_property PACKAGE_PIN R18 [get_ports {Time[6]}]

set_property IOSTANDARD LVCMOS33 [get_ports {Time[*]}]

#################################################################################
# End of Constraints
#################################################################################
