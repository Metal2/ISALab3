library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity instruction_memory is
port(address: in std_logic_vector(31 downto 0);
out_instruction_memory: out std_logic_vector(31 downto 0));
end instruction_memory;



architecture struct of instruction_memory is
begin

 process(address)
 begin
 case ((to_integer(unsigned(address)))) is
  
when 4194304=> out_instruction_memory<="00000000011100000000100000010011";
when 4194308=> out_instruction_memory<="00001111110000010000001000010111";
when 4194312=> out_instruction_memory<="11111111110000100000001000010011";
when 4194316=> out_instruction_memory<="00001111110000010000001010010111";
when 4194320=> out_instruction_memory<="00000001000000101000001010010011";
when 4194324=> out_instruction_memory<="01000000000000000000011010110111";
when 4194328=> out_instruction_memory<="11111111111101101000011010010011";
when 4194332=> out_instruction_memory<="00000010000010000000100001100011"; --beq
when 4194336=> out_instruction_memory<="00000000000000100010010000000011";
when 4194340=> out_instruction_memory<="01000001111101000101010010010011";
when 4194344=> out_instruction_memory<="00000000100101000100010100110011";
when 4194348=> out_instruction_memory<="00000000000101001111010010010011";
when 4194352=> out_instruction_memory<="00000000100101010000010100110011";
when 4194356=> out_instruction_memory<="00000000010000100000001000010011";
when 4194360=> out_instruction_memory<="11111111111110000000100000010011";
when 4194364=> out_instruction_memory<="00000000110101010010010110110011";
when 4194368=> out_instruction_memory<="11111100000001011000111011100011"; 
when 4194372=> out_instruction_memory<="00000000000001010000011010110011";
when 4194376=> out_instruction_memory<="11111101010111111111000011101111";
when 4194380=> out_instruction_memory<="00000000110100101010000000100011";
when 4194384=> out_instruction_memory<="00000000000000000000000011101111";
when 4194388=> out_instruction_memory<="00000000000000000000000000010011";
when others => out_instruction_memory<="00000000000000000000000000000000";

end case;
end process;
	
end architecture struct;