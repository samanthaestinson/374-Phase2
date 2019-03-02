-- Copyright (C) 1991-2013 Altera Corporation
-- Your use of Altera Corporation's design tools, logic functions 
-- and other software and tools, and its AMPP partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Altera Program License 
-- Subscription Agreement, Altera MegaCore Function License 
-- Agreement, or other applicable license agreement, including, 
-- without limitation, that your use is for the sole purpose of 
-- programming logic devices manufactured by Altera and sold by 
-- Altera or its authorized distributors.  Please refer to the 
-- applicable agreement for further details.

-- PROGRAM		"Quartus II 64-Bit"
-- VERSION		"Version 13.0.1 Build 232 06/12/2013 Service Pack 1 SJ Full Version"
-- CREATED		"Thu Feb 15 16:58:28 2018"

LIBRARY ieee;
USE ieee.std_logic_1164.all; 

LIBRARY work;

ENTITY datapath_phase1 IS 
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
END datapath_phase1;

ARCHITECTURE bdf_type OF datapath_phase1 IS 

COMPONENT register32
	PORT(clk : IN STD_LOGIC;
		 clr : IN STD_LOGIC;
		 enable : IN STD_LOGIC;
		 D : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 Q : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
END COMPONENT;

component reg_file is 
	port(
		R0in, R1in, R2in, R3in, R4in, R5in, R6in, R7in, R8in, R9in, R10in, R11in, R12in, R13in, R14in, R15in: in std_logic;
		BusMuxOut: in std_logic_vector(31 downto 0);
		clock: in std_logic;
		clear: in std_logic;
		R0out, R1out, R2out, R3out, R4out, R5out, R6out, R7out, R8out, R9out, R10out, R11out, R12out, R13out, R14out, R15out: out std_logic_vector (31 downto 0)
	);
end component reg_file;

COMPONENT busMuxxx
	PORT(R0out : IN STD_LOGIC;
		 R1out : IN STD_LOGIC;
		 R2out : IN STD_LOGIC;
		 R3out : IN STD_LOGIC;
		 R4out : IN STD_LOGIC;
		 R5out : IN STD_LOGIC;
		 R6out : IN STD_LOGIC;
		 R7out : IN STD_LOGIC;
		 R8out : IN STD_LOGIC;
		 R9out : IN STD_LOGIC;
		 R10out : IN STD_LOGIC;
		 R11out : IN STD_LOGIC;
		 R12out : IN STD_LOGIC;
		 R13out : IN STD_LOGIC;
		 R14out : IN STD_LOGIC;
		 R15out : IN STD_LOGIC;
		 HIout : IN STD_LOGIC;
		 LOout : IN STD_LOGIC;
		 ZHout : IN STD_LOGIC;
		 ZLout : IN STD_LOGIC;
		 PCout : IN STD_LOGIC;
		 MDRout : IN STD_LOGIC;
		 inPortOut : IN STD_LOGIC;
		 CSignOut : IN STD_LOGIC;
		 BusMuxInHI : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 BusMuxIninPort : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 BusMuxInLO : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 BusMuxInMDR : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 BusMuxInPC : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 BusMuxInZH : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 BusMuxInZL : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 CSignExt : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 R0BusMuxIn : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 R10BusMuxIn : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 R11BusMuxIn : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 R12BusMuxIn : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 R13BusMuxIn : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 R14BusMuxIn : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 R15BusMuxIn : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 R1BusMuxIn : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 R2BusMuxIN : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 R3BusMuxIn : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 R4BusMuxIn : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 R5BusMuxIn : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 R6BusMuxIn : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 R7BusMuxIn : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 R8BusMuxIn : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 R9BusMuxIn : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 BusMuxOut : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
END COMPONENT;

COMPONENT regz
	PORT(Zin : IN STD_LOGIC;
		 clock : IN STD_LOGIC;
		 clear : IN STD_LOGIC;
		 ALUout : IN STD_LOGIC_VECTOR(63 DOWNTO 0);
		 ZH : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		 ZL : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
END COMPONENT;

COMPONENT alu
	PORT(ctl_add : IN STD_LOGIC;
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
		 A : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 B : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 C : OUT STD_LOGIC_VECTOR(63 DOWNTO 0)
	);
END COMPONENT;
	
component MDR is 
	port(
		rd: in std_logic;
		Mdatain: in std_logic_vector(31 downto 0);
		BusMuxOut: in std_logic_vector(31 downto 0);
		MDRin: in std_logic;
		clock: in std_logic;
		clear: in std_logic;
		BusMuxIn_MDR: out std_logic_vector (31 downto 0)
	);

END COMPONENT;

SIGNAL	ALUout :  STD_LOGIC_VECTOR(63 DOWNTO 0);

SIGNAL	BusMuxOut :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	CSignExtended :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	CSignOut :  STD_LOGIC;
SIGNAL	inPortOut :  STD_LOGIC;
SIGNAL	Yout :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	R0BusMuxIn :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	R1BusMuxIn :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	R2BusMuxIn :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	R3BusMuxIn :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	R4BusMuxIn :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	R5BusMuxIn :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	R6BusMuxIn :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	R7BusMuxIn :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	R8BusMuxIn :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	R9BusMuxIn :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	R10BusMuxIn :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	R11BusMuxIn :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	R12BusMuxIn :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	R13BusMuxIn :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	R14BusMuxIn :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	R15BusMuxIn :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	BusMuxIn_HI :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	BusMuxIn_inPort :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	BusMuxIn_LO :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	BusMuxIn_MDR :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	BusMuxIn_PC :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	BusMuxIn_ZH :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	BusMuxIn_ZL :  STD_LOGIC_VECTOR(31 DOWNTO 0);



BEGIN 


	 
		 
b2v_inst : busmuxxx
PORT MAP(R0out => R0Out,
		 R1out => R1Out,
		 R2out => R2Out,
		 R3out => R3Out,
		 R4out => R4Out,
		 R5out => R5Out,
		 R6out => R6Out,
		 R7out => R7Out,
		 R8out => R8Out,
		 R9out => R9Out,
		 R10out => R10Out,
		 R11out => R11Out,
		 R12out => R12Out,
		 R13out => R13Out,
		 R14out => R14Out,
		 R15out => R15Out,
		 HIout => HIOut,
		 LOout => LOOut,
		 ZHout => ZHOut,
		 ZLout => ZLOut,
		 PCout => PCOut,
		 MDRout => MDROut,
		 inPortOut => inPortOut,
		 CSignOut => CSignOut,
		 BusMuxInHI => BusMuxIn_HI,
		 BusMuxIninPort => BusMuxIn_inPort,
		 BusMuxInLO => BusMuxIn_LO,
		 BusMuxInMDR => BusMuxIn_MDR,
		 BusMuxInPC => BusMuxIn_PC,
		 BusMuxInZH => BusMuxIn_ZH,
		 BusMuxInZL => BusMuxIn_ZL,
		 CSignExt => CSignExtended,
		 
		 R0BusMuxIn => R0BusMuxIn,
		 R1BusMuxIn => R1BusMuxIn,
		 R2BusMuxIN => R2BusMuxIn,
		 R3BusMuxIn => R3BusMuxIn,
		 R4BusMuxIn => R4BusMuxIn,
		 R5BusMuxIn => R5BusMuxIn,
		 R6BusMuxIn => R6BusMuxIn,
		 R7BusMuxIn => R7BusMuxIn,
		 R8BusMuxIn => R8BusMuxIn,
		 R9BusMuxIn => R9BusMuxIn,
		 R10BusMuxIn => R10BusMuxIn,
		 R11BusMuxIn => R11BusMuxIn,
		 R12BusMuxIn => R12BusMuxIn,
		 R13BusMuxIn => R13BusMuxIn,
		 R14BusMuxIn => R14BusMuxIn,
		 R15BusMuxIn => R15BusMuxIn,
		 
		 BusMuxOut => BusMuxOut);


b2v_inst3 : regz
PORT MAP(Zin => Zin,
		 clock => clk,
		 clear => clr,
		 ALUout => ALUout,
		 ZH => BusMuxIn_ZH,
		 ZL => BusMuxIn_ZL);


b2v_inst4 : alu
PORT MAP(ctl_add => ctl_add,
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
		 ctl_neg => ctl_neg,
		 ctl_not => ctl_not,
		 A => Yout,
		 B => BusMuxOut,
		 C => ALUout);


b2v_IR : register32
PORT MAP(clk => clk,
		 clr => clr,
		 enable => IRin,
		 D => BusMuxOut);

b2v_MAR : register32
PORT MAP(clk => clk,
		 clr => clr,
		 enable => MARin,
		 D => IR_out);


b2v_PC : register32
PORT MAP(clk => clk,
		 clr => clr,
		 enable => PCin,
		 D => BusMuxOut,
		 Q => BusMuxIn_PC);

b2v_Y : register32
PORT MAP(clk => clk,
		 clr => clr,
		 enable => Yin,
		 D => BusMuxOut,
		 Q => Yout);
		 
MemData: MDR port map(
		rd => Rd,
		Mdatain => Mdatain,
		BusMuxOut => BusMuxOut,
		MDRin => MDRin,
		clock => clk,
		clear => clr,
		BusMuxIn_MDR => BusMuxIn_MDR);

b2v_HI : register32
PORT MAP(clk => clk,
		 clr => clr,
		 enable => HIin,
		 D => BusMuxOut,
		 Q => BusMuxIn_HI);

b2v_LO : register32
PORT MAP(clk => clk,
		 clr => clr,
		 enable => LOin,
		 D => BusMuxOut,
		 Q => BusMuxIn_LO);			 

registers: reg_file
port map(
		R0in => R0in,
		R1in => R1in,
		R2in => R2in,
	 	R3in => R3in,
		R4in => R4in,
		R5in => R5in,
		R6in => R6in,
		R7in => R7in,
		R8in => R8in,
		R9in => R9in,
		R10in => R10in,
		R11in => R11in,
		R12in => R12in,
		R13in => R13in,
		R14in => R14in,
		R15in => R15in,
		BusMuxOut => BusMuxOut,
		clock => clk,
		clear => clr,
		R0out => R0BusMuxIn,
		R1out => R1BusMuxIn,
		R2out => R2BusMuxIn,
	 	R3out => R3BusMuxIn,
		R4out => R4BusMuxIn,
		R5out => R5BusMuxIn,
		R6out => R6BusMuxIn,
		R7out => R7BusMuxIn,
		R8out => R8BusMuxIn,
		R9out => R9BusMuxIn,
		R10out => R10BusMuxIn,
		R11out => R11BusMuxIn,
		R12out => R12BusMuxIn,
		R13out => R13BusMuxIn,
		R14out => R14BusMuxIn,
		R15out => R15BusMuxIn
	);



R0value <= R0BusMuxIn;
R1value <= R1BusMuxIn;
R2value <= R2BusMuxIn;
R3value <= R3BusMuxIn;
R4value <= R4BusMuxIn;
R5value <= R5BusMuxIn;
R6value <= R6BusMuxIn;
R7value <= R7BusMuxIn;
R8value <= R8BusMuxIn;
R9value <= R9BusMuxIn;
R10value <= R10BusMuxIn;
R11value <= R11BusMuxIn;
R12value <= R12BusMuxIn; 
R13value <= R13BusMuxIn;
R14value <= R14BusMuxIn;
R15value <= R15BusMuxIn;
ZLvalue <= BusMuxIn_ZL;
LOvalue <= BusMuxIn_LO;
HIvalue <= BusMuxIn_HI;
BusMuxOut_tb <= BusMuxOut;
		 
		 
		 
END bdf_type;