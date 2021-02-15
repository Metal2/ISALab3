library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;

entity equality_comparator is
		generic ( N: integer);
		port	( A: in std_logic_vector(N-1 downto 0);
				  B: in std_logic_vector(N-1 downto 0);
				  R: out std_logic);
end equality_comparator;

architecture behavior of equality_comparator is

	
	begin

	process (A,B)
	
	begin
	
	if (A=B) then
		R <= '1';
		
	else
		R <= '0';
		
	end if;
	
	end process;

	end behavior;