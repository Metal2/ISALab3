library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;

entity abs_special_unit is
port (
		input: in std_logic_vector (31 downto 0);
		output: out std_logic_vector (31 downto 0)
		);
end entity;

architecture struct of abs_special_unit is

signal output_tmp : std_logic_vector (31 downto 0);

begin

process(input)

 begin
 
if (input(31)='0') then

	output_tmp <= input;
else
	output_tmp <= not(input) + 1;
end if;
end process;

output<=output_tmp;

end struct;