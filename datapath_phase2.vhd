library IEEE;
use ieee.std_logic_1164.all;

entity datapath_phase2 is
port(
	clk :  IN  STD_LOGIC;
	clr :  IN  STD_LOGIC;
	PCout, ZHout, ZLout, MDRout: in std_logic;
	MARin, PCin, MDRin, Yin, Zin : in std_logic;
	IR_in : in std_logic_vector(31 downto 0);
	Gra : in std_logic;
	Grb : in std_logic;
	Grc : in std_logic;
	Rin : in std_LOGIC;
	Rout : in std_LOGIC;
	BAout : in std_LOGIC;
	sel_en_Rout : out std_LOGIC_VECTOR(15 downto 0);
	sel_en_Rin : out std_LOGIC_VECTOR(15 downto 0);
	IncPC, Rd: in std_logic;
	MDatain  :  in std_logic_vector(31 downto 0);
	ctl_add : IN STD_LOGIC;
	ctl_sub : IN STD_LOGIC;
	ctl_mul : IN STD_LOGIC;
	ctl_div : IN STD_LOGIC;
	ctl_shr : IN STD_LOGIC;
	ctl_shra : IN STD_LOGIC;
	ctl_shl : IN STD_LOGIC;
	ctl_ror : IN STD_LOGIC;
	ctl_rol : IN STD_LOGIC;
	ctl_and : IN STD_LOGIC;
	ctl_or : IN STD_LOGIC;
	ctl_not : IN STD_LOGIC;
	ctl_neg : IN STD_LOGIC;
	R0value, R1value, R2value, R3value, R4value, R5value, R6value, R7value, R8value,
	R9value, R10value, R11value, R12value, R13value, R14value, R15value, ZLValue, LOvalue, HIvalue, BusMuxOut_tb : out std_logic_vector(31 downto 0)
);
end datapath_phase2;

architecture structure of datapath_phase2 is

component datapath_phase1
PORT
	(
		clk :  IN  STD_LOGIC;
		clr :  IN  STD_LOGIC;
		PCout, ZHout, ZLout, MDRout: in std_logic;
		MARin, PCin, MDRin, IRin, Yin, Zin : in std_logic;
		R0in, R1in, R2in, R3in, R4in, R5in, R6in, R7in, R8in, R9in, R10in,
		R11in, R12in, R13in, R14in, R15in, LOin, HIin : in std_logic;
		R0out, R1out, R2out, R3out, R4out, R5out, R6out, R7out, R8out, R9out, R10out,
		R11out, R12out, R13out, R14out, R15out, LOout, HIout : in std_logic;
		IncPC, Rd: in std_logic;
		MDatain  :  in std_logic_vector(31 downto 0);
		ctl_add : IN STD_LOGIC;
		ctl_sub : IN STD_LOGIC;
		ctl_mul : IN STD_LOGIC;
		ctl_div : IN STD_LOGIC;
		ctl_shr : IN STD_LOGIC;
		ctl_shra : IN STD_LOGIC;
		ctl_shl : IN STD_LOGIC;
		ctl_ror : IN STD_LOGIC;
		ctl_rol : IN STD_LOGIC;
		ctl_and : IN STD_LOGIC;
		ctl_or : IN STD_LOGIC;
		ctl_not : IN STD_LOGIC;
		ctl_neg : IN STD_LOGIC;
		R0value, R1value, R2value, R3value, R4value, R5value, R6value, R7value, R8value,
		R9value, R10value, R11value, R12value, R13value, R14value, R15value, ZLValue, LOvalue, HIvalue, BusMuxOut_tb, IR_out : out std_logic_vector(31 downto 0)
	);
END component;

component select_encoder
port(
IR_in : in std_logic_vector(31 downto 0);
Gra : in std_logic;
Grb : in std_logic;
Grc : in std_logic;
Rin : in std_LOGIC;
Rout : in std_LOGIC;
BAout : in std_LOGIC;
sel_en_Rout : out std_LOGIC_VECTOR(15 downto 0);
sel_en_Rin : out std_LOGIC_VECTOR(15 downto 0)
);
end component;

component CON_FF_logic
	port(IR_low_bits : in std_logic_vector(1 downto 0);
			register_in : in std_logic_vector(31 downto 0);
			Con_in, con_clk : in std_logic;
			con_out : out std_logic
	);
end component;

signal en_Rin, en_Rout : std_LOGIC_VECTOR(15 downto 0);

begin


select_encode : select_encoder
port map(
	IR_in => IR_out,
	Gra => Gra,
	Grb => Grb,
	Grc => Grc,
	Rin => Rin,
	Rout => Rout,
	BAout => BAout,
	sel_en_Rin => en_Rin,
	sel_en_Rout => en_Rout
);