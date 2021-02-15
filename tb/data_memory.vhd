library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
entity data_memory is
port(address: in std_logic_vector(31 downto 0);
mem_read : in std_logic;
DATA_out: out std_logic_vector(31 downto 0));
end data_memory;


architecture RTL of data_memory is

begin
 process(address,mem_read)
 begin
 if(mem_read='1') then 
 
 case (address) is
  
when x"10010000"=> DATA_out<= std_logic_vector(to_signed(10,32));
when x"10010004"=> DATA_out<= std_logic_vector(to_signed(-47,32));
when x"10010008"=> DATA_out<= std_logic_vector(to_signed(22,32));
when x"1001000c"=> DATA_out<= std_logic_vector(to_signed(-3,32));
when x"10010010"=> DATA_out<= std_logic_vector(to_signed(15,32));
when x"10010014"=> DATA_out<= std_logic_vector(to_signed(27,32));
when x"10010018"=> DATA_out<= std_logic_vector(to_signed(-4,32));
when others     => DATA_out<= std_logic_vector(to_signed(0,32));

end case;

end if;
end process;

	
end architecture RTL;