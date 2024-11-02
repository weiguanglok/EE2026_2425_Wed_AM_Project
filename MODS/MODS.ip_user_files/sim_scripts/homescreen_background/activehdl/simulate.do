onbreak {quit -force}
onerror {quit -force}

asim -t 1ps +access +r +m+homescreen_background -L xil_defaultlib -L xpm -L blk_mem_gen_v8_4_1 -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.homescreen_background xil_defaultlib.glbl

do {wave.do}

view wave
view structure

do {homescreen_background.udo}

run -all

endsim

quit -force
