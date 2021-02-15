library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
library work;
use  work.RISC_V_PACKAGE.all;


--immediate generator, RISC_V RV32I
entity imm_gen is
    port(
        instruction : in  std_logic_vector(31 downto 0);
        immediate   : out std_logic_vector(31 downto 0)
    );
end imm_gen;

architecture behavioral of imm_gen is


signal op_code : std_logic_vector(6 downto 0);
signal imm     : std_logic_vector(31 downto 0);

begin

op_code <= instruction(6 downto 0);
immediate <= imm;

process(instruction,op_code)
begin
case op_code is

    when (I_OP1) =>    --ADDI,SRAI,LW,ANDI
                                imm(31 downto 11) <= (others => instruction(31));
                                imm(10 downto 5)  <= instruction(30 downto 25);
                                imm(4 downto 1)   <= instruction(24 downto 21);
                                imm(0)            <= instruction(20);
										  
	 when (I_OP2) =>    --ADDI,SRAI,LW,ANDI
                                imm(31 downto 11) <= (others => instruction(31));
                                imm(10 downto 5)  <= instruction(30 downto 25);
                                imm(4 downto 1)   <= instruction(24 downto 21);
                                imm(0)            <= instruction(20);

    when (U_OP1) =>    --LUI, AUIPC
                                imm(31)           <= instruction(31);
                                imm(30 downto 20) <= instruction(30 downto 20);
                                imm(19 downto 12) <= instruction(19 downto 12);
                                imm(11 downto 0)  <= (others=>'0');
	 when (U_OP2) =>    --LUI, AUIPC
                                imm(31)           <= instruction(31);
                                imm(30 downto 20) <= instruction(30 downto 20);
                                imm(19 downto 12) <= instruction(19 downto 12);
                                imm(11 downto 0)  <= (others=>'0');

    when B_OP   =>              --BEQ
                                imm(31 downto 12) <= (others=> instruction(31));
                                imm(11)           <= instruction(7);
                                imm(10 downto 5)  <= instruction(30 downto 25);
                                imm(4 downto 1)   <= instruction(11 downto 8);
                                imm(0)            <= '0';

    when J_OP   =>              --JAL
                                imm(31 downto 20) <= (others=> instruction(31));
                                imm(19 downto 12) <= instruction(19 downto 12);
                                imm(11)           <= instruction(20);
                                imm(10 downto 5)  <= instruction(30 downto 25);
                                imm(4 downto 1)   <= instruction(24 downto 21);
                                imm(0)            <= '0';

    when S_OP   =>              --SW
                                imm(31 downto 11) <= (others=> instruction(31));
                                imm(10 downto 5)  <= instruction(30 downto 25);
                                imm(4 downto 1)   <= instruction(11 downto 8);
                                imm(0)            <= instruction(7);

    when others =>              --ADD, XOR, SLT  
                                imm <= (others => '0');
end case;
end process;


end behavioral;