library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

--32 bit multiplexer
entity mux is
    port(
        sel      : in  std_logic;
        mux_in_0 : in  std_logic_vector(31 downto 0);
        mux_in_1 : in  std_logic_vector(31 downto 0);
        mux_out  : out std_logic_vector(31 downto 0)
    );
end mux;

architecture behavioral of mux is

    signal tmp_out: std_logic_vector(31 downto 0);

begin

mux_out <= tmp_out;

p_MUX: process(sel,mux_in_0,mux_in_1)
begin
    if (sel = '0') then
        tmp_out <= mux_in_0;
    else
        tmp_out <= mux_in_1;
    end if;
end process;

end behavioral;