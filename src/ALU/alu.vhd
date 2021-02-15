library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;



entity alu is
			generic (N : integer := 32) ;
			port ( A : in std_logic_vector (N-1 downto 0);
				   B : in std_logic_vector (N-1 downto 0);
				   control_bits: in std_logic_vector (2 downto 0);
				   Result : out std_logic_vector (N-1 downto 0);
				   Equal: out std_logic);
end alu;

architecture struct of alu is

-----------------------------------------
--------COMPONENTS-----------------------

component minority_comparator is
		generic ( N: integer);
		port	( A: in std_logic_vector(N-1 downto 0);
				  B: in std_logic_vector(N-1 downto 0);
				  R: out std_logic_vector(N-1 downto 0));
end component;

component equality_comparator is
		generic ( N: integer);
		port	( A: in std_logic_vector(N-1 downto 0);
				  B: in std_logic_vector(N-1 downto 0);
				  R: out std_logic);
end component;

component adder is
			generic (N : integer) ;
			port ( A : in std_logic_vector (N-1 downto 0);
				   B : in std_logic_vector (N-1 downto 0);
				   S : out std_logic_vector (N-1 downto 0));
end component;

component right_shift is
			generic (N : integer) ;
			port ( A : in std_logic_vector (N-1 downto 0);
				   B : in std_logic_vector (N-1 downto 0);
				   R : out std_logic_vector (N-1 downto 0));
end component;

component xor_operation is
			generic (N : integer) ;
			port ( A : in std_logic_vector (N-1 downto 0);
				   B : in std_logic_vector (N-1 downto 0);
				   R : out std_logic_vector (N-1 downto 0));
end component;

component and_operation is
			generic (N : integer) ;
			port ( A : in std_logic_vector (N-1 downto 0);
				   B : in std_logic_vector (N-1 downto 0);
				   R : out std_logic_vector (N-1 downto 0));
end component;

------------------------------------------
-----------SIGNALS------------------------

signal Result_minority_comparator : std_logic_vector (N-1 downto 0);
signal Result_equality_comparator: std_logic;
signal Result_adder : std_logic_vector (N-1 downto 0);
signal Result_right_shift : std_logic_vector (N-1 downto 0);
signal Result_xor : std_logic_vector (N-1 downto 0);
signal Result_and : std_logic_vector (N-1 downto 0);
signal Result_tmp : std_logic_vector (N-1 downto 0);
signal Equal_tmp : std_logic;


	begin
	
	process (control_bits,Result_minority_comparator,Result_equality_comparator,Result_adder,Result_right_shift,Result_xor,Result_and,B)

	begin
	
	case control_bits is
	
		when "000" => 
						Result_tmp <= Result_minority_comparator;	
						Equal_tmp<='0';
						
		when "001" => 
						Equal_tmp <= Result_equality_comparator;
						Result_tmp <= (others=>'0');
		
		when "010" => 
						Result_tmp <= Result_adder;
						Equal_tmp<='0';
	
	   when "011" => 
						Result_tmp <= Result_right_shift;
						Equal_tmp<='0';
							
		when "100" => 
						Result_tmp <= Result_xor;
						Equal_tmp<='0';
							
		when "101" => 	
						Result_tmp <= Result_and;
						Equal_tmp<='0';
						
		when "110" => 
						Result_tmp <= B;   --QUI SI IMPLEMENTA IL BYPASS IN ALU PER OPERAZIONI LUI
						Equal_tmp <= '0';
						
		when others => 
						Result_tmp	<= (others => '0');
						Equal_tmp <= '0';
							
	end case;
	
	end process;
	
---------------------------------------
-----PORT MAPS-------------------------

minority_comparator_instance: minority_comparator
					generic map (N => 32)
					port map 	(A => A,
								B => B,
								R => Result_minority_comparator);

equality_comparator_instance: equality_comparator
					generic map (N => 32)
					port map 	(A => A,
								B => B,
								R => Result_equality_comparator);
								
right_shift_instance: right_shift
					generic map (N => 32)
					port map 	(A => A,
								B => B,
								R => Result_right_shift);
								
adder_instance: adder
					generic map (N => 32)
					port map 	(A => A,
								B => B,
								S => Result_adder);
								
xor_operation_instance: xor_operation
					generic map (N => 32)
					port map 	(A => A,
								B => B,
								R => Result_xor);
								
and_operation_instance: and_operation
					generic map (N => 32)
					port map 	(A => A,
								B => B,
								R => Result_and);
								
								
------------------------------------------------------
----------OUTPUT ASSIGNMENT---------------------------

Result <= Result_tmp;
Equal <= Equal_tmp;

end struct;
	