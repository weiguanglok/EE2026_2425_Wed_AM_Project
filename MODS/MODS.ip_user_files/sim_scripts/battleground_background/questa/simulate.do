onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib battleground_background_opt

do {wave.do}

view wave
view structure
view signals

do {battleground_background.udo}

run -all

quit -force
