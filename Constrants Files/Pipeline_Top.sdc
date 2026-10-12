## ---- Units ----
set_units -time ns
set_units -capacitance pF
set_units -voltage V
set_units -current mA

## ---- Clock ----
create_clock -name sys_clk -period 10.000 -waveform {0.000 5.000} [get_ports clk]

set_clock_uncertainty -setup 0.100 [get_clocks sys_clk]
set_clock_uncertainty -hold  0.050 [get_clocks sys_clk]

set_clock_transition -rise 0.100 [get_clocks sys_clk]
set_clock_transition -fall 0.100 [get_clocks sys_clk]

set_clock_latency -source 0.500 [get_clocks sys_clk]
set_clock_latency         0.300 [get_clocks sys_clk]

## ---- Reset ----
## Async assert / sync deassert. Only the raw pin gets a false path.
## (Feed rst_sync_n from a 2-FF synchronizer into the pipeline FFs.)
set_false_path -from [get_ports rst_n]

## ---- I/O (only Result_Debug[*] is real I/O now) ----
## Remove or adjust if these are internal-only in your SoC.
set_output_delay -clock sys_clk -max 2.000 [get_ports {Result_Debug[*]}]
set_output_delay -clock sys_clk -min 0.500 [get_ports {Result_Debug[*]}]

## ---- Design rules ----
set_max_transition 0.300 [current_design]
set_max_capacitance 0.500 [current_design]