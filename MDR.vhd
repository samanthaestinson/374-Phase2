library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MDR is 
	port(
		rd: in std_logic;
		Mdatain: in std_logic_vector(31 downto 0);
		BusMuxOut: in std_logic_vector(31 downto 0);
		MDRin: in std_logic;
		clock: in std_logic;
		clear: in std_logic;
		BusMuxIn_MDR: out std_logic_vector (31 downto 0)
	);
end MDR;

architecture behaviour of MDR is
	component register32
	port (D	: in std_logic_vector (31 downto 0);
			Q	: out std_logic_vector (31 downto 0);
			clk	: in std_logic;
			clr	: in std_logic;
			enable	: in std_logic);
	end component;

	signal MDRMuxOut: std_logic_vector(31 downto 0);
	
begin

	process (rd, MDatain, BusMuxOut)
	begin
		if rd = '1' then
			MDRMuxOut <= Mdatain;
		else
			MDRMuxOut <= BusMuxOut;
		end if;
	end process;
	
	reg32: register32 port map (D => MDRMuxOut, Q =>BusMuxIn_MDR, clk =>clock, clr =>clear, enable => MDRin);
	
end architecture;