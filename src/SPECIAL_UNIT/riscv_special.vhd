library IEEE;
use IEEE.STD_LOGIC_1164.all;
library work;
use  work.RISC_V_PACKAGE.all;
 
entity riscv is
 port(
	  clk : in std_logic;
	  rst : in std_logic;
      instruction : in std_logic_vector (31 downto 0);
	  read_data_data_memory : in std_logic_vector (31 downto 0);
	  address : out std_logic_vector (31 downto 0);
	  address_data_memory : out std_logic_vector (31 downto 0);
	  write_data_data_memory : out std_logic_vector (31 downto 0);
	  mem_write : out std_logic;
	  mem_read : out std_logic
  );
end riscv;
 
architecture struct of riscv is

begin


-----------------------------------------
-----IF/ID STAGE-------------------------

PC: N_bit_reg                                      --PROGRAM COUNTER
		generic map (N => 32)
		port map 	(	clk   => clk,  
						rst_n => rst,
							ld    => pc_write_tmp,
							d_in  => mux_if_out,
							d_out => pc_out_tmp
						 );
						 
MUX_IF : mux                                     --SELECTS EITHER SEQUENTIAL PC ADDRESS OR PC+IMMEDIATE
		  port map(
        sel      => sel_mux_if,
        mux_in_0 => sum_if_out_tmp,
        mux_in_1 => sum_ex_out_EX,
        mux_out  => mux_if_out
    );
					
ADDER_IF_INSTANCE :adder                        --USED TO INCREMENT PC BY 4
					generic map (N => 32) 
					port map ( 
					A => constant_number_four,
				    B => pc_out_tmp,
				    S => sum_if_out_tmp
					);
					
					
 PIPE_IF : process(clk,rst)
 
 begin
 if (rst='0') then
 pc_out_IF <= (others=> '0' );
 sum_if_out_IF <= (others => '0');
 instruction_IF<= (others => '0');
 
 elsif (rising_edge(clk)) then
 if ((alu_zero_tmp or alu_zero_EX or Jump_ID or Jump_EX)='1') then
 pc_out_IF <= (others=> '0' );
 sum_if_out_IF <= (others => '0');
 instruction_IF<= "00000000000000000000000000010011";
 elsif (IF_write_tmp='1') then
 pc_out_IF <= pc_out_tmp;
 sum_if_out_IF <= sum_if_out_tmp;
 instruction_IF <= instruction_tmp;
 else
 pc_out_IF <= pc_out_IF;
 sum_if_out_IF <= sum_if_out_IF;
 instruction_IF <= instruction_IF;
 end if;
 
 end if;
 
 end process;
 
 
 -----------------------------------------------
 ------ ID/EX STAGE ----------------------------
						 
REG_FILE : register_file
		  port map (
		  clk        => clk,
        rst_n      => rst,
        read_reg1  => instruction_IF (19 downto 15),
        read_reg2  => instruction_IF (24 downto 20),
        read_data1 => read_data_1_tmp,
        read_data2 => read_data_2_tmp,
        write_reg  => write_reg_MEM,
        write_data => mux_wb_out,
        reg_write  => RegWrite_MEM
    );
	 
IMM_GENERATOR : imm_gen
			   port map(
				instruction => instruction_IF,
				immediate   => imm_gen_out_tmp
    );
	
CU : control_unit
     port map (
		OPCODE   => instruction_IF (6 downto 0),
		RegWrite => RegWrite_tmp,
		ALUSrc   => ALUSrc_tmp,
		MemWrite => MemWrite_tmp,
		ALUOp    => ALUOp_tmp,
		MemtoReg => MemtoReg_tmp,
		MemRead  => MemRead_tmp,
		Jump     => Jump_tmp,
		ctrl_alu_or_sum_ex_forw => ctrl_alu_or_sum_ex_forw_tmp,
		Mux_Special => Mux_Special_tmp
		);
		
	Hazard_DU : Hazard_detection_unit
	port map(
    IF_write =>   IF_write_tmp,
	pc_write =>   pc_write_tmp,
    mux_hdu_ctrl=>  mux_hdu_ctrl_tmp,
    MemRead_ID=>  MemRead_ID,
    write_reg_ID=> write_reg_ID,
    rs1_tmp =>  rs1_tmp,
    rs2_tmp =>  rs2_tmp
	);
	
  PIPE_ID : process(clk,rst)
  begin
  if(rst='0') then
  pc_out_ID <= (others=> '0' );
  sum_if_out_ID <= (others => '0');
  funct3_ID <= (others=> '0');
  read_data_1_ID <= (others=> '0');
  read_data_2_ID <= (others => '0');
  imm_gen_out_ID <= (others => '0');
  write_reg_ID <= (others => '0');
  rs1_ID <= (others => '0');
  rs2_ID <= (others => '0');
 

  elsif (rising_edge(clk)) then

  pc_out_ID <= pc_out_IF;
  sum_if_out_ID <= sum_if_out_IF;
  funct3_ID <= funct3_tmp;
  read_data_1_ID <= read_data_1_tmp;
  read_data_2_ID <= read_data_2_tmp;
  imm_gen_out_ID <= imm_gen_out_tmp;
  write_reg_ID <= write_reg_tmp;
  rs1_ID <= rs1_tmp;
  rs2_ID <= rs2_tmp;

  end if;
  end process;
  
  control_pipe_ID : process(clk,rst)
 begin
 
 if  (rst='0') then
 RegWrite_ID<='0';
 ALUSrc_ID<='0';
 MemWrite_ID<='0';
 ALUOp_ID<="00"; 
 MemtoReg_ID<="00";
 MemRead_ID<='0';
 Jump_ID<='0';
 ctrl_alu_or_sum_ex_forw_ID<='0';
 Mux_Special_ID<='0';

 
 elsif (rising_edge(clk)) then
 
 if( (not(mux_hdu_ctrl_tmp) or (alu_zero_tmp or Jump_ID) )='1') then
 RegWrite_ID<='0';
 ALUSrc_ID<='0';
 MemWrite_ID<='0';
 ALUOp_ID<="00"; 
 MemtoReg_ID<="00";
 MemRead_ID<='0';
 Jump_ID<='0';
 ctrl_alu_or_sum_ex_forw_ID<='0';
 Mux_Special_ID<='0';

 else
 RegWrite_ID<=RegWrite_tmp;
 ALUSrc_ID<=ALUSrc_tmp;
 MemWrite_ID<=MemWrite_tmp;
 ALUOp_ID<=ALUOp_tmp; 
 MemtoReg_ID<=MemtoReg_tmp;
 MemRead_ID<=MemRead_tmp;
 Jump_ID<=Jump_tmp;
 ctrl_alu_or_sum_ex_forw_ID<=ctrl_alu_or_sum_ex_forw_tmp;
 Mux_Special_ID<=Mux_Special_tmp;

 end if;
 
 end if;
 
 end process;
 
 -----------------------------------------
 ----------EX/MEM STAGE-------------------
	 
MUX_EX : mux                             --SELECTS SECOND ALU OPERAND (REG FILE OR IMMEDIATE)
		  port map(
        sel      => ALUSrc_ID,
        mux_in_0 => read_data_2_ID,
        mux_in_1 => imm_gen_out_ID,
        mux_out  => mux_ex_out
    );
	 
ALU_INSTANCE : alu
				generic map (N => 32) 
			   port map ( A => mux_forwarding_A_out,
				       B => mux_forwarding_B_out,
				       control_bits => alu_ctrl,
				       Result => alu_result_tmp,
				       Equal => alu_zero_tmp
						 );
						 
ALU_CONTROL_INSTANCE : alu_control
							port map ( ALUop => ALUOp_ID,
				         funct3 => funct3_ID,
				         ALUctrl => alu_ctrl
							);
							
					
ADDER_EX_INSTANCE : adder                  --IMMEDIATE + PROGRAM COUNTER
					generic map (N => 32) 
					port map ( 
					A => imm_gen_out_ID,
				   B => pc_out_ID,
				   S => sum_ex_out_tmp
					);
  
		
		
FORWARDING_U : forwarding_unit
	port map(
	  rs1 => rs1_ID,
	  rs2 => rs2_ID,
	  rd_EX => write_reg_EX,
	  rd_MEM => write_reg_MEM,
	  control_forwarding_EX => RegWrite_EX,
	  control_forwarding_MEM => RegWrite_MEM,
	  forwardA => forwardA_in_mux,
	  forwardB => forwardB_in_mux
  );
  
MUX_FORWARDING_A : mux_4to1
	generic map (N=>32)
	port map(
		A   => read_data_1_ID, 
		B   => mux_wb_out,
		C   => mux_out_alu_or_sum_ex_forw, 
		D   => (others => '0'),
		Sel => forwardA_in_mux,
		Z   => mux_forwarding_A_out
  );
  
 MUX_FORWARDING_B : mux_4to1
	generic map (N=>32)
	port map(
		A   => mux_ex_out, 
		B   =>  mux_wb_out, 
		C   => mux_out_alu_or_sum_ex_forw, 
		D   => (others => '0'),
		Sel => forwardB_in_mux,
		Z   => mux_forwarding_B_out
  );
  
  MUX_ALU_OR_SUM_EX_FOR_FORWARDING : mux       --USED FOR FORWARDING 
  		port map(
        sel      => ctrl_alu_or_sum_ex_forw_EX,
        mux_in_0 => alu_result_EX,
        mux_in_1 => sum_ex_out_EX,
        mux_out  => mux_out_alu_or_sum_ex_forw
    );
	
   SPECIAL_UNIT_ABS : abs_special_unit
    port map (
		input => mux_forwarding_A_out,
		output => abs_value
		);
	
   MUX_ABS_OR_ALU : mux
  		port map(
        sel      => Mux_Special_ID,
        mux_in_0 => alu_result_tmp,
        mux_in_1 => abs_value,
        mux_out  => result_tmp
    );
	
	
  PIPE_EX : process(clk,rst)
  
  begin
  if (rst='0') then
  sum_if_out_EX <= (others => '0');
  sum_ex_out_EX <= (others => '0');
  read_data_2_EX <= (others => '0');
  alu_result_EX <= (others => '0');
  alu_zero_EX <='0';
  write_reg_EX <= (others => '0');
  elsif (rising_edge(clk)) then
  
  sum_if_out_EX <= sum_if_out_ID;
  sum_ex_out_EX <= sum_ex_out_tmp;
  read_data_2_EX <= read_data_2_ID;
  alu_result_EX <= result_tmp;  -- così prendiamo risultato in uscita dal mux tra alu e special unit
  alu_zero_EX<= alu_zero_tmp;
  write_reg_EX <= write_reg_ID;

  end if;
  end process;
 
 control_pipe_EX : process(clk,rst)
 begin
 
 if (rst='0') then
 RegWrite_EX<='0';
 MemWrite_EX<='0'; 
 MemtoReg_EX<="00";
 MemRead_EX<='0';
 Jump_EX<='0';
 ctrl_alu_or_sum_ex_forw_EX<='0';
 elsif (rising_edge(clk)) then
 RegWrite_EX<=RegWrite_ID;
 MemWrite_EX<=MemWrite_ID;
 MemtoReg_EX<=MemtoReg_ID;
 MemRead_EX<=MemRead_ID;
 Jump_EX<=Jump_ID;
 ctrl_alu_or_sum_ex_forw_EX<=ctrl_alu_or_sum_ex_forw_ID;
 end if;
 
 end process;
	
	
	
	
-----------------------------------------------
--------------- MEM/WB STAGE-----------------
	
  PIPE_MEM  : process(clk,rst)
  
  begin
  if (rst='0') then
  sum_if_out_MEM <= (others => '0');
  sum_ex_out_MEM <= (others => '0');
  alu_result_MEM <= (others => '0');
  read_data_data_memory_MEM <= (others => '0');
  write_reg_MEM <= (others => '0');
  elsif (rising_edge(clk)) then

  sum_if_out_MEM <= sum_if_out_EX;
  sum_ex_out_MEM <= sum_ex_out_EX;
  alu_result_MEM <= alu_result_EX;
  read_data_data_memory_MEM <= read_data_data_memory_tmp;
  write_reg_MEM <= write_reg_EX;

  end if;
  end process;
	
	
 control_pipe_MEM : process(clk,rst)
 begin
 
 if (rst='0') then
 RegWrite_MEM<='0'; 
 MemtoReg_MEM<="00";
 elsif (rising_edge(clk)) then
 RegWrite_MEM<=RegWrite_EX;
 MemtoReg_MEM<=MemtoReg_EX;
 end if;
 
 end process;
 
 ---------------------------------
 -------WB-----------------------
 
 MUX_WB : mux_4to1                    
			 generic map (N=>32)
			 port map(
				A   => alu_result_MEM,
				B   => sum_ex_out_MEM,
				C   => read_data_data_memory_MEM,
				D   => sum_if_out_MEM,
				Sel => MemtoReg_MEM, 
				Z   => mux_wb_out
  );
	
 -----------------------------------
 -----SIGNAL ASSIGNMENT-------------

 instruction_tmp <= instruction;
 funct3_tmp<= instruction_IF (14 downto 12);
 write_reg_tmp<= instruction_IF (11 downto 7);
 sel_mux_if <= Jump_EX or alu_zero_EX;
 rs1_tmp<= instruction_IF (19 downto 15);
 rs2_tmp<= instruction_IF (24 downto 20);
 read_data_data_memory_tmp<= read_data_data_memory;
 address<=pc_out_tmp;
 address_data_memory<= alu_result_EX;
 write_data_data_memory<= read_data_2_EX;
 mem_write<= MemWrite_EX;
 mem_read <= MemRead_EX;
 
end struct;