
test/jr_harvard_tb : rtl/mips_cpu_harvard_tb.v
	iverilog -Wall -g2012 -o rtl/mips_cpu_harvard_tb rtl/mips_cpu_harvard_tb.v rtl/mips_cpu_harvard.v