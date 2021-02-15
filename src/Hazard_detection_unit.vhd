 library IEEE;
use IEEE.STD_LOGIC_1164.all;
library work;
use  work.RISC_V_PACKAGE.all;

entity Hazard_detection_unit is
port(
IF_write :      out std_logic;
pc_write :      out std_logic;
mux_hdu_ctrl:   out std_logic; --controllo mux. se 1 passa il controllo se 0 passa la bolla
MemRead_ID:     in std_logic;
write_reg_ID:   in std_logic_vector (4 downto 0);
rs1_tmp :       in std_logic_vector ( 4 downto 0);
rs2_tmp :       in std_logic_vector (4 downto 0)
);
end entity;

architecture struct of Hazard_detection_unit is

begin

process(MemRead_ID,rs1_tmp,rs2_tmp,write_reg_ID)
begin
if (MemRead_ID='1') then
	if (rs1_tmp=write_reg_ID) then
		IF_write<='0';
		pc_write<='0';
		mux_hdu_ctrl<='0';
	elsif (rs2_tmp=write_reg_ID) then
		IF_write<='0';
		pc_write<='0';
		mux_hdu_ctrl<='0';
	else
		IF_write<='1';
		pc_write<='1';
		mux_hdu_ctrl<='1';
	end if;
else
		IF_write<='1';
		pc_write<='1';
		mux_hdu_ctrl<='1';
end if;
end process;

end struct;
	
	
	
