library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;	


entity and_operation is
			generic (N : integer) ;
			port ( A : in std_logic_vector (N-1 downto 0);
				   B : in std_logic_vector (N-1 downto 0);
				   R : out std_logic_vector (N-1 downto 0));
end and_operation;

architecture behavior of and_operation is

	begin
	
	and_op: for i in 0 to N-1 generate
			R(i)<= A(i) and B(i);
			end generate;
			
end behavior;