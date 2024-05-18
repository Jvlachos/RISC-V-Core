all: clean comp run

clean:
	\rm -rf simv csrc simv* comp.log sim.log ucli.key verdi_config_file

comp:
	vcs -sverilog -f tb.f  -kdb core_top.sv  -debug_all  -l comp.log

run:
	./simv -l sim.log

run-dve:
	./simv -gui -l sim.log

