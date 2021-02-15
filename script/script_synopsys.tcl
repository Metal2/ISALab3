define_design_lib WORK -path ./WORK

remove_design -designs
set target 1


	if {$target == 0} {     #RISCV, max clock= 3.40

		#FILE RISCV
		analyze -library WORK -format vhdl /home/isa19/Desktop/ISALab3/src/RISC_V_PACKAGE.vhd
		analyze -library WORK -format vhdl /home/isa19/Desktop/ISALab3/src/control_unit.vhd
		analyze -library WORK -format vhdl /home/isa19/Desktop/ISALab3/src/forwarding_unit.vhd
		analyze -library WORK -format vhdl /home/isa19/Desktop/ISALab3/src/Hazard_detection_unit.vhd
		analyze -library WORK -format vhdl /home/isa19/Desktop/ISALab3/src/imm_gen.vhd
		analyze -library WORK -format vhdl /home/isa19/Desktop/ISALab3/src/mux_4to1.vhd
		analyze -library WORK -format vhdl /home/isa19/Desktop/ISALab3/src/register.vhd
		analyze -library WORK -format vhdl /home/isa19/Desktop/ISALab3/src/register_file.vhd
		analyze -library WORK -format vhdl /home/isa19/Desktop/ISALab3/src/ALU/adder.vhd
		analyze -library WORK -format vhdl /home/isa19/Desktop/ISALab3/src/ALU/and_operation.vhd
		analyze -library WORK -format vhdl /home/isa19/Desktop/ISALab3/src/ALU/mux.vhd
		analyze -library WORK -format vhdl /home/isa19/Desktop/ISALab3/src/ALU/comparator.vhd
		analyze -library WORK -format vhdl /home/isa19/Desktop/ISALab3/src/ALU/right_shift.vhd
		analyze -library WORK -format vhdl /home/isa19/Desktop/ISALab3/src/ALU/alu_control.vhd
		analyze -library WORK -format vhdl /home/isa19/Desktop/ISALab3/src/ALU/equality_comparator.vhd
		analyze -library WORK -format vhdl /home/isa19/Desktop/ISALab3/src/ALU/xor_operation.vhd
		analyze -library WORK -format vhdl /home/isa19/Desktop/ISALab3/src/ALU/alu.vhd
		analyze -library WORK -format vhdl /home/isa19/Desktop/ISALab3/src/riscv.vhd
	
		set power_preserve_rtl_hier_names true
		elaborate riscv -arch struct -lib WORK > ./elaborate_riscv.txt
		uniquify
		link

		#CLOCK,INPUT AND OUTPUT DELAY, OUTPUT LOAD
		create_clock -name MY_CLK -period 3.40 clk
		set_dont_touch_network MY_CLK
		set_clock_uncertainty 0.07 [get_clocks MY_CLK]
		set_input_delay 0.5 -max -clock MY_CLK [remove_from_collection [all_inputs] clk]
		set_output_delay 0.5 -max -clock MY_CLK [all_outputs]
		set OLOAD [load_of NangateOpenCellLibrary/BUF_X4/A]
		set_load $OLOAD [all_outputs]

		compile

		#REPORT
		report_timing > ./time_report.txt
		report_area > ./area_report.txt

		#SWITCHING ACTIVITY POWER ESTIMATION
		ungroup -all -flatten
		change_names -hierarchy -rules verilog
		write_sdf ../netlist/riscv.sdf
		write -f verilog -hierarchy -output ../netlist/riscv.v
		write_sdc ../netlist/riscv.sdc

	} else {  

		#FILE RISCV SPECIAL
		analyze -library WORK -format vhdl /home/isa19/Desktop/ISALab3/src/SPECIAL_UNIT/RISC_V_PACKAGE_special.vhd
		analyze -library WORK -format vhdl /home/isa19/Desktop/ISALab3/src/SPECIAL_UNIT/control_unit_abs.vhd
		analyze -library WORK -format vhdl /home/isa19/Desktop/ISALab3/src/forwarding_unit.vhd
		analyze -library WORK -format vhdl /home/isa19/Desktop/ISALab3/src/Hazard_detection_unit.vhd
		analyze -library WORK -format vhdl /home/isa19/Desktop/ISALab3/src/imm_gen.vhd
		analyze -library WORK -format vhdl /home/isa19/Desktop/ISALab3/src/mux_4to1.vhd
		analyze -library WORK -format vhdl /home/isa19/Desktop/ISALab3/src/register.vhd
		analyze -library WORK -format vhdl /home/isa19/Desktop/ISALab3/src/register_file.vhd
		analyze -library WORK -format vhdl /home/isa19/Desktop/ISALab3/src/ALU/adder.vhd
		analyze -library WORK -format vhdl /home/isa19/Desktop/ISALab3/src/ALU/and_operation.vhd
		analyze -library WORK -format vhdl /home/isa19/Desktop/ISALab3/src/ALU/mux.vhd
		analyze -library WORK -format vhdl /home/isa19/Desktop/ISALab3/src/ALU/comparator.vhd
		analyze -library WORK -format vhdl /home/isa19/Desktop/ISALab3/src/ALU/right_shift.vhd
		analyze -library WORK -format vhdl /home/isa19/Desktop/ISALab3/src/ALU/alu_control.vhd
		analyze -library WORK -format vhdl /home/isa19/Desktop/ISALab3/src/ALU/equality_comparator.vhd
		analyze -library WORK -format vhdl /home/isa19/Desktop/ISALab3/src/ALU/xor_operation.vhd
		analyze -library WORK -format vhdl /home/isa19/Desktop/ISALab3/src/ALU/alu.vhd
		analyze -library WORK -format vhdl /home/isa19/Desktop/ISALab3/src/SPECIAL_UNIT/abs_special_unit.vhd
		analyze -library WORK -format vhdl /home/isa19/Desktop/ISALab3/src/SPECIAL_UNIT/riscv_special.vhd

		set power_preserve_rtl_hier_names true
		elaborate riscv -arch struct -lib WORK > ./elaborate_riscv_SPECIAL.txt
		uniquify
		link

		#CLOCK,INPUT AND OUTPUT DELAY, OUTPUT LOAD
		create_clock -name MY_CLK -period 3.40 clk
		set_dont_touch_network MY_CLK
		set_clock_uncertainty 0.07 [get_clocks MY_CLK]
		set_input_delay 0.5 -max -clock MY_CLK [remove_from_collection [all_inputs] clk]
		set_output_delay 0.5 -max -clock MY_CLK [all_outputs]
		set OLOAD [load_of NangateOpenCellLibrary/BUF_X4/A]
		set_load $OLOAD [all_outputs]

		compile

		#REPORT
		report_timing > ./time_report_SPECIAL.txt
		report_area > ./area_report_SPECIAL.txt

		#SWITCHING ACTIVITY POWER ESTIMATION
		ungroup -all -flatten
		change_names -hierarchy -rules verilog
		write_sdf ../netlist/riscv_SPECIAL.sdf
		write -f verilog -hierarchy -output ../netlist/riscv_SPECIAL.v
		write_sdc ../netlist/riscv_SPECIAL.sdc
	}

