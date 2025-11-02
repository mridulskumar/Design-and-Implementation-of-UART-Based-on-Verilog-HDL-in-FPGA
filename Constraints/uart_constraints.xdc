## Clock
set_property PACKAGE_PIN Y9 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]

## UART
set_property PACKAGE_PIN T22 [get_ports tx]
set_property PACKAGE_PIN T21 [get_ports rx]
set_property IOSTANDARD LVCMOS33 [get_ports {tx rx}]

## LEDs
set_property PACKAGE_PIN G15 [get_ports {leds[0]}]
set_property PACKAGE_PIN AE26 [get_ports {leds[1]}]
set_property PACKAGE_PIN AD26 [get_ports {leds[2]}]
set_property PACKAGE_PIN AC26 [get_ports {leds[3]}]
set_property PACKAGE_PIN AB26 [get_ports {leds[4]}]
set_property PACKAGE_PIN AA26 [get_ports {leds[5]}]
set_property PACKAGE_PIN W15 [get_ports {leds[6]}]
set_property PACKAGE_PIN AA15 [get_ports {leds[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {leds[*]}]
