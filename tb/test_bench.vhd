 library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
entity test_bench is
end test_bench;

architecture struct of test_bench is

component clk_gen is
  port (
    CLK     : out std_logic;
    RST_n   : out std_logic);
end component;

component data_memory is
port(Address: in std_logic_vector(31 downto 0);
	 mem_read : in std_logic;
	 DATA_out: out std_logic_vector(31 downto 0));
end component;

component instruction_memory is
port(address: in std_logic_vector(31 downto 0);
	 out_instruction_memory: out std_logic_vector(31 downto 0));
end component;

component data_sink is
  port (
    CLK   : in std_logic;
	WRITE_ENABLE : in std_logic;
	ADDRESS : in std_logic_vector(31 downto 0);
    DIN   : in std_logic_vector(31 downto 0)); 
end component;

component riscv is
 port(
	  clk : in std_logic;
	  rst : in std_logic;
      instruction : in std_logic_vector (31 downto 0);
	  read_data_data_memory : in std_logic_vector (31 downto 0);
	  address : out std_logic_vector (31 downto 0);
	  address_data_memory : out std_logic_vector (31 downto 0);
	  write_data_data_memory : out std_logic_vector (31 downto 0);
	  mem_write : out std_logic;
	  mem_read : out std_logic
  );
end component;

-------------------------------------
---------SIGNALS---------------------
signal  clk_tmp : std_logic;
signal  rst_n_tmp : std_logic;
signal  instruction_tmp : std_logic_vector(31 downto 0);
signal  read_data_data_memory_tmp : std_logic_vector(31 downto 0);
signal  address_tmp : std_logic_vector(31 downto 0);
signal  address_data_memory_tmp: std_logic_vector(31 downto 0);
signal  write_data_data_memory_tmp: std_logic_vector (31 downto 0);
signal  mem_write_tmp : std_logic;
signal  mem_read_tmp : std_logic;

begin

CG: clk_gen
	port map(
	CLK   => clk_tmp,
	RST_n => rst_n_tmp
	);
	
DATA_m : data_memory 
	port map(
	Address  => address_data_memory_tmp,
	mem_read => mem_read_tmp,
    DATA_out => read_data_data_memory_tmp
	);
	
INSTRUCTION_m : instruction_memory
	port map(
	address => address_tmp,
    out_instruction_memory => instruction_tmp
	);
	
DS : data_sink
	port map(
	CLK   => clk_tmp,
	WRITE_ENABLE => mem_write_tmp,
    ADDRESS => address_data_memory_tmp,
    DIN   => write_data_data_memory_tmp
	);
	
DUT : riscv
	port map(
	clk => clk_tmp,
	rst => rst_n_tmp,
    instruction => instruction_tmp,
	read_data_data_memory => read_data_data_memory_tmp,
	address => address_tmp,
	address_data_memory => address_data_memory_tmp,
	write_data_data_memory => write_data_data_memory_tmp,
	mem_write => mem_write_tmp,
	mem_read => mem_read_tmp
	);
	
end struct;
	