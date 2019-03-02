---using the clock signal---
---in port register---
library IEEE;
use ieee.std_logic_1164.all;

entity in_port is
	port (	d: in std_logic_vector(7 downto 0); ---from input unit (old q)---
			clock: std_logic;
			clear: std_logic;
			---enable:---
			q: out std_logic_vector(31 downto 0)---BusMuxIn<31..0>---
		);
	end in_port;

architecture behavioral of in_port is
signal output : std_logic_vector(31 downto 0);
begin
		process(clock,clear)
		begin
		if (rising_edge(clock)) then 
			if (clear = '1') then 
				output <= "00000000000000000000000000000000";
			else
				output <= "000000000000000000000000" & d;
			end if;
		end if;
	end process;
end behavioral;

---end of in port---

---out port register---


entity out_port is
	port (	q: out std_logic_vector(7 downto 0); ---output unit---
			d: in std_logic_vector(31 downto 0); ---busMuxOut<31..0>---
			clock: std_logic;
			clear: std_logic
			---strobe from input unit if desired, not used in ours---
		);
	end out_port;

architecture behavioral of out_port is
begin
		process(clock,clear)
		begin
		if (rising_edge(clock)) then 
			if (clear = '1') then 
				output <= "00000000000000000000000000000000";
			else
				output <= "000000000000000000000000" & q;
			end if;
		end if;
	end process;
end behavioral;
		
---end of out port---