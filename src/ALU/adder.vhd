library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;

entity adder is
			generic (N : integer) ;
			port ( A : in std_logic_vector (N-1 downto 0);
				   B : in std_logic_vector (N-1 downto 0);
				   S : out std_logic_vector (N-1 downto 0));
end adder;

architecture behavior of adder is

	begin

		S <= A + B ; 

end behavior;

