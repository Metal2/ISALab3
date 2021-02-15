library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity register_file is
    port(
        clk        : in std_logic;                      -- clock 
        rst_n      : in std_logic;                      -- active low reset
        read_reg1  : in std_logic_vector(4 downto 0);   --read address 1
        read_reg2  : in std_logic_vector(4 downto 0);   --read address 2
        read_data1 : out std_logic_vector(31 downto 0); --read output 1
        read_data2 : out std_logic_vector(31 downto 0); --read output 2
        write_reg  : in std_logic_vector(4 downto 0);   --write address
        write_data : in std_logic_vector(31 downto 0);         --write input
        reg_write  : in std_logic                       --control signal
    );
end register_file;
     
architecture behavioral of register_file is

type reg_type is array(0 to 31) of std_logic_vector(31 downto 0); --32 registers, 64 bit wide
signal reg: reg_type;

--RISC_V REGISTERS
--x0 = constant 0
--x1 = return address
--x2 = stack pointer
--x3 = global pointer
--x4 = thread pointer
--x5 to x7 = temporary
--x8 = frame pointer
--x9 = saved register
--x10 and x11 = function arguments/results
--x12 to x17 = function arguments
--x18 to x27 = saved registers
--x28 to x31 = temporary

begin

process(clk,rst_n) 
begin

if (rst_n = '0') then

    	for i in 0 to 31 loop
			reg(i) <= (others=>'0'); --reset all registers
		end loop;


elsif (falling_edge(clk)) then

    --WRITE 
    if (reg_write = '1') then
        reg(to_integer(unsigned(write_reg))) <= write_data;
    end if;

end if;
end process;

    --ASYNCHRONUS READ
    read_data1 <= reg(to_integer(unsigned(read_reg1))); 
    read_data2 <= reg(to_integer(unsigned(read_reg2)));

end behavioral;