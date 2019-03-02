library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
entity reg_file is 
	port(
		R0in, R1in, R2in, R3in, R4in, R5in, R6in, R7in, R8in, R9in, R10in, R11in, R12in, R13in, R14in, R15in: in std_logic;
		BusMuxOut : in std_logic_vector(31 downto 0);
		clock : in std_logic;
		clear : in std_logic;
		R0out, R1out, R2out, R3out, R4out, R5out, R6out, R7out, R8out, R9out, R10out, R11out, R12out, R13out, R14out, R15out: out std_logic_vector (31 downto 0)
	);
end reg_file;

architecture behaviour of reg_file is
	component register32
	port (D	: in std_logic_vector (31 downto 0);
			Q	: out std_logic_vector (31 downto 0);
			clk	: in std_logic;
			clr	: in std_logic;
			enable	: in std_logic);
	end component;
	
	signal R0_Q : std_logic_vector(31 downto 0) := (others => '0');
	
begin	
	R0: register32 port map(BusMuxOut, R0_Q, clock, clear, R0in);
	R0out <= R0_Q;
	R1: register32 port map(BusMuxOut, R1out, clock, clear, R1in);
	R2: register32 port map(BusMuxOut, R2out, clock, clear, R2in);	
	R3: register32 port map(BusMuxOut, R3out, clock, clear, R3in);	
	R4: register32 port map(BusMuxOut, R4out, clock, clear, R4in);
	R5: register32 port map(BusMuxOut, R5out, clock, clear, R5in);
	R6: register32 port map(BusMuxOut, R6out, clock, clear, R6in);
	R7: register32 port map(BusMuxOut, R7out, clock, clear, R7in);
	R8: register32 port map(BusMuxOut, R8out, clock, clear, R8in);
	R9: register32 port map(BusMuxOut, R9out, clock, clear, R9in);
	R10: register32 port map(BusMuxOut, R10out, clock, clear, R10in);
	R11: register32 port map(BusMuxOut, R11out, clock, clear, R11in);
	R12: register32 port map(BusMuxOut, R12out, clock, clear, R12in);
	R13: register32 port map(BusMuxOut, R13out, clock, clear, R13in);
	R14: register32 port map(BusMuxOut, R14out, clock, clear, R14in);
	R15: register32 port map(BusMuxOut, R15out, clock, clear, R15in);
end architecture;