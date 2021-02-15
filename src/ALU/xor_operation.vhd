library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;


entity xor_operation is
			generic (N : integer) ;
			port ( A : in std_logic_vector (N-1 downto 0);
				   B : in std_logic_vector (N-1 downto 0);
				   R : out std_logic_vector (N-1 downto 0));
end xor_operation;

architecture behavior of xor_operation is

	begin
	
	xor_op: for i in 0 to N-1 generate
			R(i)<= A(i) xor B(i);
			end generate;
			
end behavior;