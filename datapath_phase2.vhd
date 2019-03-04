library IEEE;
use ieee.std_logic_1164.all;

entity datapath_phase2 is
port(
	clk :  IN  STD_LOGIC;
	clr :  IN  STD_LOGIC;
	PCout, ZHout, ZLout, MDRout: in std_logic;
	MARin, PCin, MDRin, IRin, Yin, Zin, con_enable, RAM_wren, outport_in, LOin, HIin, LOout, HIout : in std_logic;
	input_port_in : in std_LOGIC_VECTOR(31 downto 0);
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
	Con_FF_out : out std_LOGIC;
	R0value, R1value, R2value, R3value, R4value, R5value, R6value, R7value, R8value,
	R9value, R10value, R11value, R12value, R13value, R14value, R15value, ZLValue, LOvalue, HIvalue, BusMuxOut, RAM_out, outport_out  : out std_logic_vector(31 downto 0)
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
		BusMux_inport : in std_LOGIC_VECTOR(31 downto 0);
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
		R9value, R10value, R11value, R12value, R13value, R14value, R15value, ZLValue, LOvalue, HIvalue, BusMuxOut_tb, IR_out, MAR_out: out std_logic_vector(31 downto 0)
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

component RAM_1_port
PORT
(
	address		: IN STD_LOGIC_VECTOR (8 DOWNTO 0);
	clock		: IN STD_LOGIC  := '1';
	data		: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
	wren		: IN STD_LOGIC ;
	q		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
);
end component;

component register32
port (D	: in std_logic_vector (31 downto 0);
		Q	: out std_logic_vector (31 downto 0);
		clk	: in std_logic;
		clr	: in std_logic;
		enable	: in std_logic);
end component;

signal en_Rin, en_Rout : std_LOGIC_VECTOR(15 downto 0);
signal R0val, R1val, R2val, R3val, R4val, R5val, R6val, R7val, R8val, R9val, R10val, R11val, R12val, R13val, R14val, R15val : std_LOGIC_VECTOR(31 downto 0);
signal BusMuxOut_temp, ZLvalue_temp, LOvalue_temp, HIvalue_temp, IR_out, MAR_out_temp, inport_out_temp, RAM_out_temp : std_LOGIC_VECTOR(31 downto 0);
signal con_ff_out_temp : std_LOGIC;

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

phase1 : datapath_phase1
port map(
	clk => clk,
	clr => clr,
	PCout => PCout,
	ZHout => ZHout,
	ZLout => ZLout,
	MDRout => MDRout,
	MARin => MARin,
	PCin => PCin,
	MDRin => MDRin,
	IRin =>IRin,
	Yin => Yin,
	Zin => Zin,
	LOin => LOin,
	HIin => HIin,
	LOout => LOout,
	HIout => HIout,
	R0in => en_Rin(0),
	R1in => en_Rin(1),
	R2in => en_Rin(2),
	R3in => en_Rin(3),
	R4in => en_Rin(4),
	R5in => en_Rin(5),
	R6in => en_Rin(6),
	R7in => en_Rin(7),
	R8in => en_Rin(8),
	R9in => en_Rin(9),
	R10in => en_Rin(10),
	R11in => en_Rin(11),
	R12in => en_Rin(12),
	R13in => en_Rin(13),
	R14in => en_Rin(14),
	R15in => en_Rin(15),
	R0out => en_Rout(0),
	R1out => en_Rout(1),
	R2out => en_Rout(2),
	R3out => en_Rout(3),
	R4out => en_Rout(4),
	R5out => en_Rout(5),
	R6out => en_Rout(6),
	R7out => en_Rout(7),
	R8out => en_Rout(8),
	R9out => en_Rout(9),
	R10out => en_Rout(10),
	R11out => en_Rout(11),
	R12out => en_Rout(12),
	R13out => en_Rout(13),
	R14out => en_Rout(14),
	R15out => en_Rout(15),
	BusMux_inport => inport_out_temp,
	IncPC => IncPC,
	Rd => Rd,
	MDatain => MDatain,
	ctl_add => ctl_add,
	ctl_sub => ctl_sub,
	ctl_mul => ctl_mul,
	ctl_div => ctl_div,
	ctl_shr => ctl_shr,
	ctl_shra => ctl_shra,
	ctl_shl => ctl_shl,
	ctl_ror => ctl_ror,
	ctl_rol => ctl_rol,
	ctl_and => ctl_and,
	ctl_or => ctl_or,
	ctl_not => ctl_not,
	ctl_neg => ctl_neg,
	R0Value => R0val,
	R1Value => R1val,
	R2Value => R2val,
	R3Value => R3val,
	R4Value => R4val,
	R5Value => R5val,
	R6Value => R6val,
	R7Value => R7val,
	R8Value => R8val,
	R9Value => R9val,
	R10Value => R10val,
	R11Value => R11val,
	R12Value => R12val,
	R13Value => R13val,
	R14Value => R14val,
	R15Value => R15val,
	
	BusMuxOut_tb => BusMuxOut_temp,
	IR_out => IR_out,
	LOvalue => LOvalue_temp,
	HIvalue => HIvalue_temp,
	ZLValue => ZLvalue_temp,
	MAR_out => MAR_out_temp
);

con_ff : CON_FF_logic
port map(
	IR_low_bits => IR_out(20 downto 19),
	register_in => BusMuxOut_temp,
	Con_in => con_enable,
	con_clk => clk,
	con_out => con_ff_out_temp
);

RAM : RAM_1_port
port map(
clock => clk,
address => MAR_out_temp(8 downto 0),
data => BusMuxOut_temp,
wren => RAM_wren,
q => RAM_out_temp
);

output_port : register32
port map(
D => BusMuxOut_temp,
clk => clk,
clr => clr,
enable => Outport_in,
Q => outport_out
);

input_port : register32
port map(
D => input_port_in,
clr => clr,
clk => clk,
enable => '1',
Q => inport_out_temp
);

R0value <= R0val;
R1value <= R1val;
R2value <= R2val;
R3value <= R3val;
R4value <= R4val;
R5value <= R5val;
R6value <= R6val;
R7value <= R7val;
R8value <= R8val;
R9value <= R9val;
R10value <= R10val;
R11value <= R11val;
R12value <= R12val;
R13value <= R13val;
R14value <= R14val;
R15value <= R15val;
ZLValue <= ZLValue_temp;
LOvalue <= LOvalue_temp;
HIvalue <= HIvalue_temp;
BusMuxOut <= BusMuxOut_temp;
RAM_out <= RAM_out_temp;
Con_FF_out <= con_ff_out_temp;


end structure;
