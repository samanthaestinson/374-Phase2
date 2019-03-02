library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all; 


entity add_sub is
	port(
		add_sub_sel : in std_logic;
		xin, yin : in std_logic_vector(31 downto 0);
		result : out std_logic_vector(31 downto 0)
	);
end entity;

architecture behavioural of add_sub is

component CLA is
port(
	x, y: in std_logic_vector(7 downto 0); 
	Cin: in std_logic;
	sum: out std_logic_vector(7 downto 0);
	Cout: out std_logic
	);
end component CLA;

signal intern_c : std_logic_vector(4 downto 0);
signal intern_sum, intern_y : std_logic_vector(31 downto 0);
	
begin

process(add_sub_sel, xin, yin) is
begin
	if (add_sub_sel = '0') then
		intern_y(31 downto 0) <= (not yin(31 downto 0)) + 1;
	else
		intern_y <= yin;
	end if;
	intern_c(0) <= '0';
end process;

a0to7: 	CLA port map(x=>xin(7 downto 0), y=>intern_y(7 downto 0), Cin=>intern_c(0), sum=>result(7 downto 0), Cout=>intern_c(1));
a8to15: 	CLA port map(x=>xin(15 downto 8), y=>intern_y(15 downto 8), Cin=>intern_c(1), sum=>result(15 downto 8), Cout=>intern_c(2));
a16to23: CLA port map(x=>xin(23 downto 16), y=>intern_y(23 downto 16), Cin=>intern_c(2), sum=>result(23 downto 16), Cout=>intern_c(3));
a24to31: CLA port map(x=>xin(31 downto 24), y=>intern_y(31 downto 24), Cin=>intern_c(3), sum=>result(31 downto 24), Cout=>intern_c(4));

end architecture;

	