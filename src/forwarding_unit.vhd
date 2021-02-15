library IEEE;
use IEEE.STD_LOGIC_1164.all;
library work;
use  work.RISC_V_PACKAGE.all;
 
entity forwarding_unit is
 port(
	  rs1: in std_logic_vector (4 downto 0);
	  rs2: in std_logic_vector (4 downto 0);
	  rd_EX: in std_logic_vector (4 downto 0);
	  rd_MEM: in std_logic_vector (4 downto 0);
	  control_forwarding_EX : in std_logic;
	  control_forwarding_MEM : in std_logic;
	  forwardA: out std_logic_vector (1 downto 0);
	  forwardB: out std_logic_vector (1 downto 0)
  );
end forwarding_unit;
 
architecture struct of forwarding_unit is

signal zero_EX,zero_MEM : std_logic;
signal control_forwarding : std_logic_vector (1 downto 0);
signal control_zero : std_logic_vector (1 downto 0);

begin

zero_EX<= (rd_EX(4) or rd_EX(3) or rd_EX(2) or rd_EX(1) or rd_EX(0));
zero_MEM<= (rd_MEM(4) or rd_MEM(3) or rd_MEM(2) or rd_MEM(1) or rd_MEM(0));
control_forwarding<= control_forwarding_EX & control_forwarding_MEM;
control_zero<= zero_EX & zero_MEM;

process (rs1,rs2,rd_EX,rd_MEM,control_forwarding,control_zero,zero_EX,zero_MEM)

begin

case (control_forwarding) is

when "11" => 

		case ( control_zero) is
		
	    when "00" =>
					
					forwardA<="00"; --dato dal register file
					forwardB<="00"; --dato dal register file
					
		when "01" =>
					if(rd_MEM=rs1) then
						if (rd_MEM= rs2) then
						forwardA<="01"; --dato bypassato dall mux wb out
						forwardB<="01"; --dato bypassato dal mux wb out
						else
						forwardA<="01"; --dato bypassato dal mux wb out
						forwardB<="00"; --dato dal register file
						end if;
					else
						if (rd_MEM= rs2) then
						forwardA<="00"; --dato dal register file
						forwardB<="01"; --dato bypassato dalla mux wb out
						else
						forwardA<="00"; --dato dal register file
						forwardB<="00"; --dato dal register file
						end if;		
					end if;
					
		when "10" => 
		
					if(rd_EX=rs1) then
						if (rd_EX= rs2) then
						forwardA<="10"; --dato bypassato dalla alu out
						forwardB<="10"; --dato bypassato dalla alu out
						else
						forwardA<="10"; --dato bypassato dalla alu out
						forwardB<="00"; --dato dal register file
						end if;
					else
						if (rd_EX= rs2) then
						forwardA<="00"; --dato dal register file
						forwardB<="10"; --dato bypassato dalla alu out
						else
						forwardA<="00"; --dato dal register file
						forwardB<="00"; --dato dal register file
						end if;		
					end if;
		
		when others => --EX ha sempre priorità su MEM
		
					if(rd_EX=rs1) then
						if(rd_EX=rs2) then
						forwardA<="10"; --dato bypassato dalla alu out
						forwardB<="10"; --dato bypassato dalla alu out
						elsif (rd_MEM=rs2) then
						forwardA<="10"; --dato bypassato dalla alu out
						forwardB<="10"; --dato bypassato dal mux wb out
						else
						forwardA<="10"; --dato bypassato dalla alu out
						forwardB<="00"; --dato dal register file
						end if;
					elsif(rd_MEM=rs1) then
						if(rd_EX=rs2) then
						forwardA<="01"; --dato bypassato dal mux wb out
						forwardB<="10"; --dato bypassato dalla alu out
						elsif (rd_MEM=rs2) then
						forwardA<="01"; --dato bypassato dal mux wb out
						forwardB<="10"; --dato bypassato dal mux wb out
						else
						forwardA<="01"; --dato bypassato dal mux wb out
						forwardB<="00"; --dato dal register file
						end if;	
					else
					    if(rd_EX=rs2) then
						forwardA<="00"; --dato dal register file
						forwardB<="10"; --dato bypassato dalla alu out
						elsif (rd_MEM=rs2) then
						forwardA<="00"; --dato dal register file
						forwardB<="10"; --dato bypassato dal mux wb out
						else
						forwardA<="00"; --dato dal register file
						forwardB<="00"; --dato dal register file
						end if;	
					
					end if;
					
		end case;
		
when "10" =>  
				if (zero_EX = '1') then
					if(rd_EX=rs1) then
						if (rd_EX= rs2) then
						forwardA<="10"; --dato bypassato dalla alu out
						forwardB<="10"; --dato bypassato dalla alu out
						else
						forwardA<="10"; --dato bypassato dalla alu out
						forwardB<="00"; --dato dal register file
						end if;
					else
						if (rd_EX= rs2) then
						forwardA<="00"; --dato dal register file
						forwardB<="10"; --dato bypassato dalla alu out
						else
						forwardA<="00"; --dato dal register file
						forwardB<="00"; --dato dal register file
						end if;		
					end if;
				else
					forwardA<="00"; --dato dal register file
					forwardB<="00"; --dato dal register file	
				end if;

when "01" =>		
				if (zero_MEM='1') then
						if(rd_MEM=rs1) then
						if (rd_MEM= rs2) then
						forwardA<="01"; --dato bypassato dall mux wb out
						forwardB<="01"; --dato bypassato dall muw wb out
						else
						forwardA<="01"; --dato bypassato dalla mux wb out
						forwardB<="00"; --dato dal register file
						end if;
					else
						if (rd_MEM= rs2) then
						forwardA<="00"; --dato dal register file
						forwardB<="01"; --dato bypassato dalla mux wb out
						else
						forwardA<="00"; --dato dal register file
						forwardB<="00"; --dato dal register file
						end if;		
					end if;	
				else
						forwardA<="00"; --dato dal register file
						forwardB<="00"; --dato dal register file
				end if;
				
when others => 
				
				forwardA<="00"; --dato dal register file
				forwardB<="00"; --dato dal register file
				
end case;
end process;
end struct;
         