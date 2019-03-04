library ieee;
use ieee.std_logic_1164.all;

entity d_flipflop is 
	port(clk, d, enable : in std_logic;
			q : out std_logic
	);
end d_flipflop;

architecture behavioral of d_flipflop is
begin
	process(clk) is
	begin
		if (rising_edge(clk) and enable = '1') then
			q <= d;
		end if;
	
	end process;
	
end architecture behavioral;
