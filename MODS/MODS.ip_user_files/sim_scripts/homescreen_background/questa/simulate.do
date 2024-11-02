onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib homescreen_background_opt

do {wave.do}

view wave
view structure
view signals

do {homescreen_background.udo}

run -all

quit -force
