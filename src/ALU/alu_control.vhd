library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;

entity alu_control is
			port ( ALUop : in std_logic_vector (1 downto 0); -- in questo caso sono 2 bit
				   funct3 : in std_logic_vector (2 downto 0); --qui usiamo tutti e tre i bit
				   ALUctrl : out std_logic_vector (2 downto 0));
end alu_control;

architecture struct of alu_control is

begin

process (AlUop,funct3)

begin

case ALUop is
	
	when "00" => --operazioni di tipo OP-IMM
			case funct3 is
				when "000" => --ADDI
					ALUctrl<="010";
				when "010" => --LW e SW CHE DEVONO FARE LO STESSO DI ADDI
					ALUctrl<="010";
				when "111" => --ANDI
					ALUctrl<="101";
				when others => --SRAI
					ALUctrl<="011";
			end case;
					
	when "01" => --operazioni di tipo OP
			case funct3 is
				when "000" => --ADD
					ALUctrl<="010";
				when "010" => --SLT
					ALUctrl<="000";
				when others => --XOR
					ALUctrl<="100";
			end case;
	when "11" => --operazioni di tipo BEQ --BEQ essendo l'unica operazione di questo tipo non ha bisogno di funct3
			    ALUctrl<="001";
	when others => --OPERAZIONI DI TIPO LUI (DEVONO PASSARE DALLA ALU NON TOCCATE)
					ALUctrl<="110";
			end case;

end process;

end struct;
