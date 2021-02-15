library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;

entity minority_comparator is
		generic ( N: integer);
		port	( A: in std_logic_vector(N-1 downto 0);
				  B: in std_logic_vector(N-1 downto 0);
				  R: out std_logic_vector(N-1 downto 0));
end minority_comparator;

architecture behavior of minority_comparator is

	
	begin

	process (A,B)
	
	begin
	
	if (A<B) then
		  R(N-1 downto 1)<= (others => '0');
        R(0 downto 0)<= (others => '1');
		
	else
		R <= (others =>'0');
		
	end if;
	
	end process;

	end behavior;
		
			
			
