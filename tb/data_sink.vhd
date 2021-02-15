 library ieee;
 use ieee.std_logic_1164.all;
 use ieee.std_logic_arith.all;
 use ieee.std_logic_unsigned.all;
 use ieee.std_logic_textio.all;
 
 library std;
 use std.textio.all;      

entity data_sink is
  port (
    CLK   : in std_logic;
	WRITE_ENABLE : in std_logic;
	ADDRESS : in std_logic_vector(31 downto 0);
    DIN   : in std_logic_vector(31 downto 0)); --dato da scrivere in memoria
end data_sink;

architecture beh of data_sink is

begin  -- beh

  process (CLK,WRITE_ENABLE)
    file res_fp : text open WRITE_MODE is "./results_on_data_memory.txt";
    variable line_out : line;    
  begin  -- process
    --if RST_n = '0' then                 -- asynchronous reset (active low)
     -- null;
    if CLK'event and CLK = '1' then  -- rising clock edge
		if (WRITE_ENABLE='1') then
        hwrite(line_out,DIN);
        writeline(res_fp, line_out);
		hwrite(line_out,ADDRESS);
        writeline(res_fp, line_out);
		end if;
    end if;
  end process;

end beh;