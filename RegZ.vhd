library ieee;
use ieee.std_logic_1164.all;

entity RegZ is 
	port(
		ALUout: in std_logic_vector(63 downto 0);
		Zin: in std_logic;
		clock: in std_logic;
		clear: in std_logic;
		ZH: out std_logic_vector (31 downto 0);
		ZL: out std_logic_vector (31 downto 0)
	);
end RegZ;

architecture behaviour of RegZ is
	component register32
	port (D	: in std_logic_vector (31 downto 0);
			Q	: out std_logic_vector (31 downto 0);
			clk	: in std_logic;
			clr	: in std_logic;
			enable	: in std_logic);
	end component;
	
	signal upperBits, lowerBits : std_logic_vector (31 downto 0);
	
begin

	upperBits <= ALUout(63 downto 32);
	lowerBits <= ALUout(31 downto 0);
	Z_high: register32 port map (D=>upperBits, Q=>ZH, clk=>clock, clr=>clear, enable=>Zin);
	Z_low: register32 port map (D=>lowerBits, Q=>ZL, clk=>clock, clr=>clear, enable=>Zin);
	
end architecture;