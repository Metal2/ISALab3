library IEEE;
use IEEE.STD_LOGIC_1164.all;
 
entity mux_4to1 is
generic (N : integer);
 port(
 
     A   : in STD_LOGIC_VECTOR (N-1 downto 0);
	  B   : in STD_LOGIC_VECTOR (N-1 downto 0);
	  C   : in STD_LOGIC_VECTOR (N-1 downto 0);
	  D   : in STD_LOGIC_VECTOR (N-1 downto 0);
     Sel : in STD_LOGIC_VECTOR (1 downto 0);
     Z   : out STD_LOGIC_VECTOR (N-1 downto 0)
  );
end mux_4to1;
 
architecture bhv of mux_4to1 is
begin
process (A,B,C,D,Sel) is
begin
  if (Sel="00") then
      Z <= A;
  elsif (Sel="01") then
      Z <= B;
  elsif (Sel="10") then
      Z <= C;
  else
      Z <= D;
  end if;
 
end process;
end bhv;
