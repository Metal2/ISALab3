set target 1

vlib work

if {$target == 0} {
	#RISCV
	vcom -93 -work ./work ../src/RISC_V_PACKAGE.vhd
	vcom -93 -work ./work ../src/control_unit.vhd
	vcom -93 -work ./work ../src/forwarding_unit.vhd
	vcom -93 -work ./work ../src/Hazard_detection_unit.vhd
	vcom -93 -work ./work ../src/imm_gen.vhd
	vcom -93 -work ./work ../src/mux_4to1.vhd
	vcom -93 -work ./work ../src/register.vhd
	vcom -93 -work ./work ../src/register_file.vhd
	vcom -93 -work ./work ../src/ALU/adder.vhd
	vcom -93 -work ./work ../src/ALU/alu_control.vhd
	vcom -93 -work ./work ../src/ALU/and_operation.vhd
	vcom -93 -work ./work ../src/ALU/comparator.vhd
	vcom -93 -work ./work ../src/ALU/equality_comparator.vhd
	vcom -93 -work ./work ../src/ALU/mux.vhd
	vcom -93 -work ./work ../src/ALU/right_shift.vhd
	vcom -93 -work ./work ../src/ALU/xor_operation.vhd
	vcom -93 -work ./work ../src/ALU/alu.vhd
	vcom -93 -work ./work ../tb/clock_generator.vhd
	vcom -93 -work ./work ../tb/data_memory.vhd
	vcom -93 -work ./work ../tb/data_sink.vhd
	vcom -93 -work ./work ../tb/instruction_memory.vhd
	vlog -work ./work ../innovus/riscv/riscv_innovus.v
	vcom -93 -work ./work ../tb/test_bench.vhd
	vsim -L /software/dk/nangate45/verilog/msim6.2g -sdftyp /test_bench/DUT=../innovus/riscv/riscv_innovus.sdf work.test_bench
	run 1400 ns

} else { #RISCV SPECIAL

	vcom -93 -work ./work ../src/SPECIAL_UNIT/RISC_V_PACKAGE_special.vhd
	vcom -93 -work ./work ../src/SPECIAL_UNIT/control_unit_abs.vhd	
	vcom -93 -work ./work ../src/SPECIAL_UNIT/abs_special_unit.vhd	
	vcom -93 -work ./work ../src/forwarding_unit.vhd
	vcom -93 -work ./work ../src/Hazard_detection_unit.vhd
	vcom -93 -work ./work ../src/imm_gen.vhd
	vcom -93 -work ./work ../src/mux_4to1.vhd
	vcom -93 -work ./work ../src/register.vhd
	vcom -93 -work ./work ../src/register_file.vhd
	vcom -93 -work ./work ../src/ALU/adder.vhd
	vcom -93 -work ./work ../src/ALU/alu_control.vhd
	vcom -93 -work ./work ../src/ALU/and_operation.vhd
	vcom -93 -work ./work ../src/ALU/comparator.vhd
	vcom -93 -work ./work ../src/ALU/equality_comparator.vhd
	vcom -93 -work ./work ../src/ALU/mux.vhd
	vcom -93 -work ./work ../src/ALU/right_shift.vhd
	vcom -93 -work ./work ../src/ALU/xor_operation.vhd
	vcom -93 -work ./work ../src/ALU/alu.vhd
	vcom -93 -work ./work ../tb/clock_generator.vhd
	vcom -93 -work ./work ../tb/data_memory.vhd
	vcom -93 -work ./work ../tb/data_sink.vhd
	vcom -93 -work ./work ../tb/instruction_memory_abs.vhd
	vlog -work ./work ../innovus/riscv_special/riscv_special_innovus.v
	vcom -93 -work ./work ../tb/test_bench.vhd
	vsim -L /software/dk/nangate45/verilog/msim6.2g -sdftyp /test_bench/DUT=../innovus/riscv_special/riscv_special_innovus.sdf work.test_bench
	run 1400 ns
}
