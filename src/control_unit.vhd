library ieee;
use ieee.std_logic_1164.all;
USE ieee.numeric_std.all;


ENTITY control_unit IS 
PORT (
		OPCODE   : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
		RegWrite : OUT STD_LOGIC;
		ALUSrc   : OUT STD_LOGIC;
		MemWrite : OUT STD_LOGIC;
		ALUOp    : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
		MemtoReg : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
		MemRead  : OUT STD_LOGIC;
		Jump     : OUT STD_LOGIC;
		ctrl_alu_or_sum_ex_forw : out std_logic
		
		);
END ENTITY ;

ARCHITECTURE Behavior OF control_unit IS 

TYPE State_type IS (R, I, Store, SB, U_LUI, U_AUIPC, UJ, Load, Reset);
SIGNAL present_state: State_type ;


BEGIN 


state_table : PROCESS (OPCODE)--(present_state,OPCODE)

BEGIN 

CASE(OPCODE) IS 

WHEN "0110011" => present_state<= R; -- add, xor, slt 

WHEN "0010011" => present_state<= I; -- addi, srai, andi

WHEN "0010111" => present_state<= U_AUIPC; --auipc : : aggiungere 12 bit meno significativi a 0, lo somma all'addre dell'istruzione e viene salvato nella destinazione 
--- l'uscita del mux va messa sul mux a valle della memoria come terzo/quarto ingresso

WHEN "0110111" => present_state<= U_LUI; --lui : aggiungere 12 bit meno significativi a 0 e viene salvato nella destinazione (non deve essere modificato dalla alu)

WHEN "1100011" => present_state<= SB;  -- beq: se rs1=rs2 faccio salto all'indirizzo Jump+offset 
--- lo shift_1 serve perchÃ¨ gli offset sono composti senza bit 0

WHEN "1101111" => present_state<= UJ; -- jal : somma offset+address e salva PC+4 nel registro per il ritorno nel registro x0, il salto è condizionato da Jump OR Zero dalla alu

WHEN "0100011" => present_state<= Store; -- sw

WHEN "0000011" => present_state<= Load; -- lw

WHEN OTHERS => present_state<=  Reset; -- lw

END CASE; 

END PROCESS;


Uscite: PROCESS (present_state)

BEGIN

CASE(present_state)  IS

WHEN R =>

RegWrite<='1';
ALUSrc<='0';
MemWrite<='0';  
MemtoReg<="00";
MemRead<='0';   -- don't care
Jump <='0'; 
ALUOp <= "01"; 
ctrl_alu_or_sum_ex_forw <= '0';

WHEN I =>

RegWrite <= '1';
ALUSrc<='1';
MemWrite<='0';
MemtoReg<="00"; 
MemRead<='0';
Jump <='0'; 
ALUOp <= "00"; 
ctrl_alu_or_sum_ex_forw <= '0';


WHEN Store =>

RegWrite <='0';
ALUSrc	<='1';
MemWrite	<='1';
MemtoReg	<="00";
MemRead	<='0';
Jump 	<='0'; 
ALUOp 	<="00"; 
ctrl_alu_or_sum_ex_forw <= '0';


WHEN SB =>

RegWrite <='0';
ALUSrc	<='0'; 
MemWrite	<='0';
MemtoReg	<="00";
MemRead	<='0';
Jump 	<='0'; 
ALUOp 	<="11"; 
ctrl_alu_or_sum_ex_forw <= '0';

WHEN U_LUI =>

RegWrite <='1';
ALUSrc	<='1'; 
MemWrite	<='0';
MemtoReg	<="00";
MemRead	<='0';
Jump 	<='0'; 
ALUOp 	<="10"; --dontcare --IN REALTà NON è DONTCARE PERCHé DEVE PASSARE NELLA ALU SENZA CHE QUESTA LO TOCCHI
ctrl_alu_or_sum_ex_forw <= '0';

WHEN U_AUIPC =>

RegWrite <='1';
ALUSrc	<='1'; -- don't care
MemWrite	<='0';
MemtoReg	<="01";
MemRead	<='0'; -- don't care
Jump 	<='0'; 
ALUOp 	<="10"; --dontcare
ctrl_alu_or_sum_ex_forw <= '1';

WHEN UJ =>

RegWrite <='1';
ALUSrc	<='1';   -- don't care
MemWrite	<='0'; 
MemtoReg	<="11";
MemRead	<='0';   -- don't care
Jump 	<='1'; 
ALUOp 	<="00"; -- don't care 
ctrl_alu_or_sum_ex_forw <= '1';

WHEN Load => 

RegWrite <='1';
ALUSrc	<='1';   
MemWrite	<='0';
MemtoReg	<="10";
MemRead	<='1';
Jump 	<='0'; 
ALUOp 	<="00"; -- don't care
ctrl_alu_or_sum_ex_forw <= '0';

WHEN OTHERS =>

RegWrite<='0';
ALUSrc<='0';
MemWrite<='0';
MemtoReg<="00";
MemRead<='0';
Jump<='0';
ALUOp <= "00";
ctrl_alu_or_sum_ex_forw <= '0';
				
END CASE;

END PROCESS;



END ARCHITECTURE;