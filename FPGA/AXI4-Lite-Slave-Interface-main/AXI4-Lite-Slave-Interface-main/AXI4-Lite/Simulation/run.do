vlib work
vlog *.v
vsim -voptargs="+acc" work.top_module_tb 
do wave.do
run -all