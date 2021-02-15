library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;

entity right_shift is
			generic (N : integer) ;
			port ( A : in std_logic_vector (N-1 downto 0);
				   B : in std_logic_vector (N-1 downto 0);
				   R : out std_logic_vector (N-1 downto 0));
end right_shift;

architecture struct of right_shift is

signal shift_dim : std_logic_vector(4 downto 0);

begin

shift_dim <= B(4 downto 0);

process (A,B,shift_dim)

begin

case shift_dim is

 when "00000" => 
             R <= A;

 when "00001" => 
             R(31 downto 31)<= (others => A(31));
             R(30 downto 0)<=A(31 downto 1 );

 when "00010" => 
             R(31 downto 30)<= (others => A(31));
             R(29 downto 0)<=A(31 downto 2 );

 when "00011" => 
             R(31 downto 29)<= (others => A(31));
             R(28 downto 0)<=A(31 downto 3 );

 when "00100" => 
             R(31 downto 28)<= (others => A(31));
             R(27 downto 0)<=A(31 downto 4 );

 when "00101" => 
             R(31 downto 27)<= (others => A(31));
             R(26 downto 0)<=A(31 downto 5 );

 when "00110" => 
             R(31 downto 26)<= (others => A(31));
             R(25 downto 0)<=A(31 downto 6 );

 when "00111" => 
             R(31 downto 25)<= (others => A(31));
             R(24 downto 0)<=A(31 downto 7 );

 when "01000" => 
             R(31 downto 24)<= (others => A(31));
             R(23 downto 0)<=A(31 downto 8 );

 when "01001" => 
             R(31 downto 23)<= (others => A(31));
             R(22 downto 0)<=A(31 downto 9 );

 when "01010" => 
             R(31 downto 22)<= (others => A(31));
             R(21 downto 0)<=A(31 downto 10 );

 when "01011" => 
             R(31 downto 21)<= (others => A(31));
             R(20 downto 0)<=A(31 downto 11 );

 when "01100" => 
             R(31 downto 20)<= (others => A(31));
             R(19 downto 0)<=A(31 downto 12 );

 when "01101" => 
             R(31 downto 19)<= (others => A(31));
             R(18 downto 0)<=A(31 downto 13 );

 when "01110" => 
             R(31 downto 18)<= (others => A(31));
             R(17 downto 0)<=A(31 downto 14 );

 when "01111" => 
             R(31 downto 17)<= (others => A(31));
             R(16 downto 0)<=A(31 downto 15 );

 when "10000" => 
             R(31 downto 16)<= (others => A(31));
             R(15 downto 0)<=A(31 downto 16 );

 when "10001" => 
             R(31 downto 15)<= (others => A(31));
             R(14 downto 0)<=A(31 downto 17 );

 when "10010" => 
             R(31 downto 14)<= (others => A(31));
             R(13 downto 0)<=A(31 downto 18 );

 when "10011" => 
             R(31 downto 13)<= (others => A(31));
             R(12 downto 0)<=A(31 downto 19 );

 when "10100" => 
             R(31 downto 12)<= (others => A(31));
             R(11 downto 0)<=A(31 downto 20 );

 when "10101" => 
             R(31 downto 11)<= (others => A(31));
             R(10 downto 0)<=A(31 downto 21 );

 when "10110" => 
             R(31 downto 10)<= (others => A(31));
             R(9 downto 0)<=A(31 downto 22 );

 when "10111" => 
             R(31 downto 9)<= (others => A(31));
             R(8 downto 0)<=A(31 downto 23 );

 when "11000" => 
             R(31 downto 8)<= (others => A(31));
             R(7 downto 0)<=A(31 downto 24 );

 when "11001" => 
             R(31 downto 7)<= (others => A(31));
             R(6 downto 0)<=A(31 downto 25 );

 when "11010" => 
             R(31 downto 6)<= (others => A(31));
             R(5 downto 0)<=A(31 downto 26 );

 when "11011" => 
             R(31 downto 5)<= (others => A(31));
             R(4 downto 0)<=A(31 downto 27 );

 when "11100" => 
             R(31 downto 4)<= (others => A(31));
             R(3 downto 0)<=A(31 downto 28 );

 when "11101" => 
             R(31 downto 3)<= (others => A(31));
             R(2 downto 0)<=A(31 downto 29 );

 when "11110" => 
             R(31 downto 2)<= (others => A(31));
             R(1 downto 0)<=A(31 downto 30 );

 when others => 
             R(31 downto 1)<= (others => A(31));
             R(0 downto 0)<=A(31 downto 31 );
			 
end case;

end process;

end struct;
