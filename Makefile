PROJ=bidir_test
VFLAGS= -Wall -g2005

all: ${PROJ}.json

dfu: ${PROJ}.dfu
	dfu-util -a0 -D $<

%.json: verilog/%_top.v
	yosys -p "read_verilog $<; synth_ecp5 -json $@"

%_out.config: %.json
	nextpnr-ecp5 --json $< --textcfg $@ --25k --package CSFBGA285 --lpf orangecrab_r0.2.pcf

%.bit: %_out.config
	ecppack --compress --freq 38.8 --input $< --bit $@

%.dfu : %.bit
	cp $< $@
	dfu-suffix -v 1209 -p 5af0 -a $@

.PHONY:  clean

clean:
	rm -rf *.vcd a.out *.svf *.bit *.config *.json *.dfu 
