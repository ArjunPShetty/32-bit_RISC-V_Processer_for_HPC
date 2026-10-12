## Pipeline_Top.xdc
## Target board: Digilent Basys3 (xc7a35tcpg236-1)
## Vivado 2020.x+ flow

## ---------------------------------------------------------------
## Clock: Basys3 onboard 100 MHz oscillator -> port "clk"
## ---------------------------------------------------------------
set_property PACKAGE_PIN W5 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]
create_clock -period 10.000 -name sys_clk -waveform {0.000 5.000} [get_ports clk]

## ---------------------------------------------------------------
## Reset: active-low, mapped to BTNC (center button) = U18 on Basys3
## Design treats rst_n = 0 as "in reset", rst_n = 1 as "running"
## ---------------------------------------------------------------
set_property PACKAGE_PIN U18 [get_ports rst_n]
set_property IOSTANDARD LVCMOS33 [get_ports rst_n]

## Async reset is not synchronous to sys_clk -> false path it.
## (If you later add a reset synchronizer, remove this and constrain the
##  synchronized output as normal.)
set_false_path -from [get_ports rst_n]

## Optional: model the button's slow edge as input delay
set_input_delay -clock sys_clk 2.0 [get_ports rst_n]

## ---------------------------------------------------------------
## Debug outputs: Result_Debug[15:0] -> Basys3 LEDs (led[15:0])
## ---------------------------------------------------------------
set_property PACKAGE_PIN U16 [get_ports {Result_Debug[0]}]
set_property PACKAGE_PIN E19 [get_ports {Result_Debug[1]}]
set_property PACKAGE_PIN U19 [get_ports {Result_Debug[2]}]
set_property PACKAGE_PIN V19 [get_ports {Result_Debug[3]}]
set_property PACKAGE_PIN W18 [get_ports {Result_Debug[4]}]
set_property PACKAGE_PIN U15 [get_ports {Result_Debug[5]}]
set_property PACKAGE_PIN U14 [get_ports {Result_Debug[6]}]
set_property PACKAGE_PIN V14 [get_ports {Result_Debug[7]}]
set_property PACKAGE_PIN V13 [get_ports {Result_Debug[8]}]
set_property PACKAGE_PIN V3  [get_ports {Result_Debug[9]}]
set_property PACKAGE_PIN W3  [get_ports {Result_Debug[10]}]
set_property PACKAGE_PIN U3  [get_ports {Result_Debug[11]}]
set_property PACKAGE_PIN P3  [get_ports {Result_Debug[12]}]
set_property PACKAGE_PIN N3  [get_ports {Result_Debug[13]}]
set_property PACKAGE_PIN P1  [get_ports {Result_Debug[14]}]
set_property PACKAGE_PIN L1  [get_ports {Result_Debug[15]}]
set_property IOSTANDARD LVCMOS33 [get_ports {Result_Debug[*]}]
set_output_delay -clock sys_clk 2.0 [get_ports {Result_Debug[*]}]

## ---------------------------------------------------------------
## If Instr_Debug / PC_Debug / RegWrite_Debug are still top-level ports
## in your Pipeline_top, DO NOT add pin assignments unless you are
## prepared to route them to 7-seg / PMOD. Better: remove them from
## the top module and observe them in simulation or through an ILA.
## ---------------------------------------------------------------