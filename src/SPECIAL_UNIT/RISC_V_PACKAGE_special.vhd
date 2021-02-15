library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

PACKAGE RISC_V_PACKAGE IS

-----------------------------------------------------------
------------------OP CODES---------------------------------
--R TYPE
constant R_OP : std_logic_vector(6 downto 0) :=  "0110011";

--I TYPE
constant I_OP1 : std_logic_vector(6 downto 0) := "0010011"; 
constant I_OP2 : std_logic_vector(6 downto 0) := "0000011";

--U TYPE
constant U_OP1 : std_logic_vector(6 downto 0) := "0010111";
constant U_OP2 : std_logic_vector(6 downto 0) := "0110111";                                 

--B TYPE
constant B_OP : std_logic_vector(6 downto 0) :=  "1100011";

--J TYPE
constant J_OP : std_logic_vector(6 downto 0) :=  "1101111";

--S type
constant S_OP : std_logic_vector(6 downto 0) :=  "0100011";
-----------------------------------------------------------
-----------------------------------------------------------



-----------------------------------------------------------
------------------number four------------------------------

constant constant_number_four : std_logic_vector(31 downto 0) :=  "00000000000000000000000000000100";
-----------------------------------------------------------
------------COMPONENTS RISCV-------------------------------
component N_bit_reg is	
	generic(N: integer);
	port(
		clk   : in std_logic;
		rst_n : in std_logic;
		ld    : in std_logic;
		d_in  : in  std_logic_vector(N-1 downto 0);
		d_out : out std_logic_vector(N-1 downto 0));
end component;

component imm_gen is
    port(
        instruction : in  std_logic_vector(31 downto 0);
        immediate   : out std_logic_vector(31 downto 0)
    );
end component;

component register_file is
    port(
        clk        : in std_logic;                      -- clock 
        rst_n      : in std_logic;                      -- active low reset
        read_reg1  : in std_logic_vector(4 downto 0);   --read address 1
        read_reg2  : in std_logic_vector(4 downto 0);   --read address 2
        read_data1 : out std_logic_vector(31 downto 0); --read output 1
        read_data2 : out std_logic_vector(31 downto 0); --read output 2
        write_reg  : in std_logic_vector(4 downto 0);   --write address
        write_data : in std_logic_vector(31 downto 0);         --write input
        reg_write  : in std_logic                       --control signal
    );
end component;


component adder is
			generic (N : integer) ;
			port ( A : in std_logic_vector (N-1 downto 0);
				   B : in std_logic_vector (N-1 downto 0);
				   S : out std_logic_vector (N-1 downto 0));
end component;

component alu is
			generic (N : integer := 32) ;
			port ( A : in std_logic_vector (N-1 downto 0);
				   B : in std_logic_vector (N-1 downto 0);
				   control_bits: in std_logic_vector (2 downto 0);
				   Result : out std_logic_vector (N-1 downto 0);
				   Equal: out std_logic);
end component;

component alu_control is
			port ( ALUop : in std_logic_vector (1 downto 0);
				   funct3 : in std_logic_vector (2 downto 0); 
				   ALUctrl : out std_logic_vector (2 downto 0));
end component;

component mux is
    port(
        sel      : in  std_logic;
        mux_in_0 : in  std_logic_vector(31 downto 0);
        mux_in_1 : in  std_logic_vector(31 downto 0);
        mux_out  : out std_logic_vector(31 downto 0)
    );
end component;

component mux_4to1 is
generic (N : integer);
 port(
 
     A   : in STD_LOGIC_VECTOR (N-1 downto 0);
	  B   : in STD_LOGIC_VECTOR (N-1 downto 0);
	  C   : in STD_LOGIC_VECTOR (N-1 downto 0);
	  D   : in STD_LOGIC_VECTOR (N-1 downto 0);
     Sel : in STD_LOGIC_VECTOR (1 downto 0);
     Z   : out STD_LOGIC_VECTOR (N-1 downto 0)
  );
end component;

component left_shift is	
	generic(N: integer);
	port(
		d_in  : in  std_logic_vector(N-1 downto 0);
		d_out : out std_logic_vector(N-1 downto 0));
end component;

component control_unit IS 
PORT (
		OPCODE   : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
		RegWrite : OUT STD_LOGIC;
		ALUSrc   : OUT STD_LOGIC;
		MemWrite : OUT STD_LOGIC;
		ALUOp    : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
		MemtoReg : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
		MemRead  : OUT STD_LOGIC;
		Jump     : OUT STD_LOGIC;
		ctrl_alu_or_sum_ex_forw : out std_logic;
		Mux_Special : out std_logic
		
		);
end component;

component forwarding_unit is
 port(
	  rs1: in std_logic_vector (4 downto 0);
	  rs2: in std_logic_vector (4 downto 0);
	  rd_EX: in std_logic_vector (4 downto 0);
	  rd_MEM: in std_logic_vector (4 downto 0);
	  control_forwarding_EX : in std_logic;
	  control_forwarding_MEM : in std_logic;
	  forwardA: out std_logic_vector (1 downto 0);
	  forwardB: out std_logic_vector (1 downto 0)
  );
end component;

component Hazard_detection_unit is
port(
IF_write : out std_logic;
pc_write : out std_logic;
mux_hdu_ctrl: out std_logic; --controllo mux. se 0 passa il controllo se 1 passa la bolla
MemRead_ID: in std_logic;
write_reg_ID: in std_logic_vector (4 downto 0);
rs1_tmp : in std_logic_vector ( 4 downto 0);
rs2_tmp : in std_logic_vector (4 downto 0)
);
end component;

component abs_special_unit is
port (
		input: in std_logic_vector (31 downto 0);
		output: out std_logic_vector (31 downto 0)
		);
end component;

---------------------------------------------------------------
-------------------SIGNALS-------------------------------------
signal pc_out_tmp,pc_out_IF,pc_out_ID : std_logic_vector (31 downto 0);
signal sum_ex_out_tmp,sum_ex_out_EX,sum_ex_out_MEM : std_logic_vector (31 downto 0);
signal sum_if_out_tmp,sum_if_out_IF,sum_if_out_ID,sum_if_out_EX,sum_if_out_MEM : std_logic_vector (31 downto 0);
signal mux_if_out : std_logic_vector (31 downto 0);
signal sel_mux_if : std_logic;
signal instruction_tmp,instruction_IF : std_logic_vector (31 downto 0);
signal funct3_tmp,funct3_ID : std_logic_vector (2 downto 0);
signal read_data_1_tmp,read_data_1_ID : std_logic_vector (31 downto 0);
signal read_data_2_tmp,read_data_2_ID,read_data_2_EX : std_logic_vector (31 downto 0);
signal imm_gen_out_tmp,imm_gen_out_ID : std_logic_vector (31 downto 0);
signal shif_left_out : std_logic_vector (31 downto 0);
signal mux_ex_out : std_logic_vector (31 downto 0);
signal alu_result_tmp,alu_result_EX,alu_result_MEM : std_logic_vector (31 downto 0);
signal alu_zero_tmp,alu_zero_EX : std_logic;
signal alu_ctrl : std_logic_vector (2 downto 0);
signal read_data_data_memory_tmp,read_data_data_memory_MEM : std_logic_vector (31 downto 0);
signal mux_wb_out : std_logic_vector (31 downto 0);
signal write_reg_tmp,write_reg_ID,write_reg_EX,write_reg_MEM : std_logic_vector (4 downto 0);
--control unit signals
signal RegWrite_tmp,RegWrite_ID,RegWrite_EX,RegWrite_MEM : std_logic;
signal ALUSrc_tmp,ALUSrc_ID  : std_logic;
signal MemWrite_tmp,MemWrite_ID,MemWrite_EX : std_logic;
signal ALUOp_tmp,ALUOp_ID  : std_logic_vector (1 downto 0);
signal MemtoReg_tmp,MemtoReg_ID,MemtoReg_EX,MemtoReg_MEM : std_logic_vector (1 downto 0);
signal MemRead_tmp,MemRead_ID,MemRead_EX : std_logic;
signal Jump_tmp,Jump_ID,Jump_EX : std_logic; 
--forwarding unit signal
signal rs1_tmp,rs1_ID : std_logic_vector (4 downto 0);
signal rs2_tmp,rs2_ID : std_logic_vector (4 downto 0);
signal control_forwarding_tmp,control_forwarding_ID,control_forwarding_EX,control_forwarding_MEM,control_forwarding_in_unit: std_logic;
signal forwardA_in_mux: std_logic_vector (1 downto 0);
signal forwardB_in_mux: std_logic_vector (1 downto 0);
signal mux_forwarding_A_out : std_logic_vector (31 downto 0);
signal mux_forwarding_B_out : std_logic_vector (31 downto 0);
signal ctrl_alu_or_sum_ex_forw_tmp,ctrl_alu_or_sum_ex_forw_ID,ctrl_alu_or_sum_ex_forw_EX : std_logic;
signal mux_out_alu_or_sum_ex_forw : std_logic_vector (31 downto 0);
--hazard detection unit signals
signal IF_write_tmp: std_logic;     
signal mux_hdu_ctrl_tmp: std_logic;
signal pc_write_tmp : std_logic;
--segnali special unit
signal result_tmp : std_logic_vector (31 downto 0);
signal abs_value : std_logic_vector (31 downto 0);
signal Mux_Special_tmp,Mux_Special_ID : std_logic;


END RISC_V_PACKAGE;