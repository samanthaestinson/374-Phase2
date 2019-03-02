library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all; 

entity CLA is
	port(x, y: in std_logic_vector(7 downto 0); 
		Cin: in std_logic;
		sum: out std_logic_vector(7 downto 0);
		Cout: out std_logic
	);
end entity;

architecture behavioural of CLA is

signal intern_sum : std_logic_vector(7 downto 0);
signal P, G  : std_logic_vector(7 downto 0);
signal intern_carry : std_logic_vector(7 downto 1);					

begin
	intern_sum <= x XOR y;
	P <= x OR y;
	G <= x AND y;
	process(intern_carry, G, P)
	begin
		intern_carry(1) <= G(0) OR (P(0) AND Cin);
			for i in 1 to 6 loop
				intern_carry(i + 1) <= G(i) OR (P(i) AND intern_carry(i));
			end loop;
		Cout <= G(7) OR (P(7) AND intern_carry(7));
	end process;
	
	sum(0) <= intern_sum(0) XOR Cin;
	sum(7 downto 1) <= intern_sum(7 downto 1) xor intern_carry(7 downto 1);
	
end behavioural;