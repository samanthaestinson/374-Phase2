Library ieee;
USE ieee.std_logic_1164.all;

ENTITY phase2_tb IS
END;

ARCHITECTURE phase2_tb_arch OF phase2_tb IS
--SIGNALS & COMPONENTS
COMPONENT phase2 IS
PORT(
	--CONTROL PORTS
	clk :  IN  STD_LOGIC;
    clr :  IN  STD_LOGIC;
    IncPC : IN STD_LOGIC;
    rden : IN STD_LOGIC;  ---RAM_rden            	
    wren : IN STD_LOGIC;    ---RAM_wren             
    strobe : IN STD_LOGIC;
    outport_in  : IN STD_LOGIC;

	--REGISTER CONTROL PORTS
	BAout : IN STD_LOGIC;
    Gra : IN STD_LOGIC;
    Grb : IN STD_LOGIC;
    Grc : IN STD_LOGIC;
	Rin : IN STD_LOGIC;
    Rout : IN STD_LOGIC;
	----RA_en : IN STD_LOGIC;

	--NON-REGISTER CONTROL PORTS 
	-- Enables
	HiIn: IN STD_LOGIC;
    LoIn:IN STD_LOGIC;
    PCin :IN STD_LOGIC;		
    IRin: IN STD_LOGIC;		
    Zin: IN STD_LOGIC;
    Yin: IN STD_LOGIC;
	MARin: IN STD_LOGIC;
    MDRin: IN STD_LOGIC;
    Con_in : IN STD_LOGIC;
	
    --BusMuxSelects
	HIvalue: IN STD_LOGIC;		---HIout
    LOvalue: IN STD_LOGIC;  ---LOOut
    ZHout : IN STD_LOGIC;,	
    ZLout: IN STD_LOGIC;
    PCout: IN STD_LOGIC;
    MDRout: IN STD_LOGIC;
    PortOut: IN STD_LOGIC; 
    Cout: IN STD_LOGIC; 
	input_port_in 	: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
	--END CTL PORTS
		
	--DEMONSTRATION PORTS
	d_Con_FF_out 	: OUT STD_LOGIC;
	d_R0value	d_R1value,	d_R2value,	d_R3value,	d_R4value,	d_R5value,	d_R6value,	d_R7value,
	d_R8value,	d_R9value,	d_R10value,	d_R11value,	d_R12value,	d_R13value,	d_R14value,	d_R15value : OUT STD_LOGIC;
	d_HIvalue,	d_LOvalue : OUT STD_LOGIC;
    d_PCout : OUT STD_LOGIC;
    d_MDRout : OUT STD_LOGIC;	
    d_BusMuxOut: OUT STD_LOGIC;	
    d_IRout: OUT STD_LOGIC;
    d_YOut: OUT STD_LOGIC;			
    d_C_sign_out: OUT STD_LOGIC;	
	d_ZLout: OUT STD_LOGIC; ---in std single for other 	
    d_ZHout: OUT STD_LOGIC;	
    d_MARout: OUT STD_LOGIC; ---new
	outport_out: OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
	--END DEMO PORTS
);
END COMPONENT;

--Non Required Signals
TYPE Operation IS 
    (Default, LoadR2, LoadR3, LoadR4, LoadR5, LoadR6, LoadR7,
    Add, Sub, Mul, Div, AndOp, OrOp, SHR, SHL, RotRight, RotLeft, Neg, NotOp,
    Load, LoadI, LoadR, Store, StoreR, AddI, AndI, OrI, BranchZero, BranchNZero, BranchPos, BranchNeg,
    Jump, JumpAL, Movefhi, Moveflo, Input, Output);

TYPE Stage IS 
    (T0, T1, T2, T3, T4, T5, T6, T7, load);

SIGNAL CurrentOp : Operation;
SIGNAL CurrentStage : Stage;
		
--Required Signals
--TestBench Signals
SIGNAL 	clk_tb, 	clr_tb, 	IncPC_tb,   
    rden_tb,    wren_tb,	
    strobe_tb,   PortOut_tb, 
    --Register TB Signals
    BAout_tb,	Gra_tb,		Grb_tb,		Grc_tb,		Rin_tb,		Rout_tb,	
    ----RA_en_tb not in diagram
    --Non-Register TB Signals
    --Enable TB Signals
    HiIn_tb,		LoIn_tb	: STD_LOGIC;
    PCin_tb,		IRin_tb,		Zin_tb,		Yin_tb : STD_LOGIC;
	MARin_tb,	MDRin_tb : STD_LOGIC con_enable_tb : STD_LOGIC;	
	--BusMuxSelect TB Signals
	HIvalue_tb,	LOvalue_tb,	ZHout_tb,	ZLout_tb, 	PCout_tb, 	MDRout_tb : STD_LOGIC;
	PortOut_tb: STD_LOGIC;
    Cout_tb	: STD_LOGIC;
	SIGNAL InPort_tb,	OutPort_tb : STD_LOGIC_VECTOR(31 downto 0); ---new
	--Outputs for Demonstration
    SIGNAL BusMuxOut_tb, IRout_tb,d_PCout_tb,
		R0value_tb,	R1value_tb,	R2value_tb,	R3value_tb,	R4value_tb,	R5value_tb,	R6value_tb,	R7value_tb, R8value_tb,	R9value_tb,	R10value_tb,	R11value_tb,	R12value_tb,	R13value_tb,	R14value_tb,	R15value_tb : STD_LOGIC_VECTOR(31 DOWNTO 0);
		d_HIvalue_tb,	d_LOvalue_tb,   d_Yout_tb : STD_LOGIC_VECTOR(31 DOWNTO 0);
        d_MDRout_tb,    MarOut_tb : STD_LOGIC_VECTOR(31 DOWNTO 0);
        d_ZHout_tb,	d_ZLout_tb : STD_LOGIC_VECTOR(31 DOWNTO 0);	
        c_sign_out_tb : STD_LOGIC_VECTOR(31 DOWNTO 0);
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------		
BEGIN
	--SIGNAL gnd32 STD_LOGIC_VECTOR(31 downto 0) := x"00000000";
	--DUT inst
	DUT : cpu_codyale
	PORT MAP(
		--CONTROL PORTS
		clk => clk_tb,	clr => clr_tb, IncPC => IncPC_tb,
		rden=>rden_tb, 
    wren=>wren_tb, 
    strobe=>strobe_tb, 
    outport_in=>outport_in_tb, --Outport_en_tb
		
		--REGISTER CONTROL PORTS
		BAout=>BAout_tb,	Gra=>Gra_tb,	Grb=>Grb_tb,	Grc=>Grc_tb,	
		Rin=>Rin_tb,	Rout=>Rout_tb,		
        ---RA_en=> RA_en_tb,

		--NON-REGISTER CONTROL PORTS 
		-- Enables
		HiIn => HiIn_tb,
		LoIn  =>LoIn_tb,
		PCin =>PCin_tb,
		IRin =>IRin_tb,
		Zin	=>Zin_tb,
		Yin	=>Yin_tb,
		MARin =>MARin_tb,
		MDRin =>MDRin_tb,
		Con_in=>Con_in_tb,

		--BusMuxSelects
		HIvalue => HIvalue_tb,
		LOvalue => LOvalue_tb,
		ZHout=> ZHout_tb,
		ZLout=> ZLout_tb,
		PCout => PCout_tb,	
		MDRout=> MDRout_tb,
		PortOut=>PortOut_tb,
		Cout    => Cout_tb,
		input_port_in=> input_port_in_tb,
		--END CONTROL PORTS

		--DEMONSTRATION PORTS
		d_R0value => R0value_tb,
		d_R1value => R1valuet_tb,
		d_R2value => R2value_tb,
		d_R3value => R3value_tb,
		d_R4value => R4value_tb,
		d_R5value => R5value_tb,
		d_R6value => R6value_tb,
		d_R7value => R7value_tb,
		d_R8value => R8value_tb,
		d_R9value => R9value_tb,
		d_R10value => R10value_tb,
		d_R11value => R11value_tb,
		d_R12value => R12value_tb,
		d_R13value => R13value_tb,
		d_R14value => R14value_tb,
		d_R15value => R15value_tb,
		d_HIvalue => d_HIvalue_tb,
		d_LOvalue => d_LOvalue_tb,
		d_PCout => d_PCout_tb,
		d_MDRout => d_MDRout_tb,
		d_BusMuxOut => BusMuxOut_tb,
		d_IRout => IRout_tb,
		d_YOut => d_YOut_tb,
		d_ZHout => d_ZHout_tb,
		d_ZLout => d_ZLout_tb,
		d_MARout => MarOut_tb,
		d_c_sign_out => C_sign_out_tb,
		outport_out => outport_out_tb
	);
	--processes
	clk_process : process
	begin
		clk_tb <= '0', '1' after 5 ns;
		Wait for 10 ns;
	end process clk_process;

-----------------------------------------------------------------
---testing process----
---Load default----
test_process: process
    begin
    CurrentOp <= Default;
    CurrentStage <= Load;

    clr_tb<='1';
    IncPC_tb<='0';
    rden_tb<='0';
    wren_tb<='0';
    strobe_tb<='0';
    Gra_tb<='0';
    Gra_tb<='0';
    Grc_tb<='0';
    BAout_tb<='0';
    Rin_tb<='0';
    Rout_tb<='0';
    outport_in_tb<='0';
    HiIn_tb<='0';
    LoIn_tb<='0';
    PCin_tb<='0';
    IRin_tb<='0';
    Zin_tb<='0';
    Yin_tb<='0';
    MARin_tb<='0';
    MDRin_tb<='0';
    Con_in_tb<='0';

    HIvalue_tb<='0';
    LOvalue_tb<='0';
    PCin_tb<='0';
    IRin_tb<='0';
    Zin_tb<='0';
    Yin_tb<='0';
    MARin_tb<='0';
    MDRin_tb<='0';
    Con_in_tb<='0';

    HIvalue_tb<='0';
    LOvalue_tb<='0';
    ZHout_tb<='0';
    ZLout_tb<='0';
    PCout_tb<='0';
    PortOut_tb<='0';
    Cout_tb<='0';

    wait until RISING_EDGE(clk_tb);
    clr_tb<='0';

    ---LOAD instructions---
    ---case 1:ld R1, $75, binary is ---
    ---T0: PCout, MARin, IncPC, Zin---
    ---Memory Address 0 ()
    CurrentOp<= Load;
    CurrentStage<=T0;
    PCout_tb<='1';
    MARin_tb<='1';
    IncPC_tb<='1';
    Zin_tb<='1';
    wait until RISING_EDGE(clk_tb);
    PCout_tb<='0';--reset
    MARin_tb<='0';
    IncPC_tb<='0';
    Zin_tb<='0';

    ---T1:Zlowout, PCin, Read, Mdatain[31..0], MDRin---
    CurrentStage<=T1;
    ZLout_tb<='1';
    PCin_tb<='1';
    rden_tb<='1';
    wren_tb<='1';
    wait until RISING_EDGE(clk_tb);
    wait until RISING_EDGE(clk_tb);
    wait until RISING_EDGE(clk_tb);
    ZLout_tb<='0';--reset
    PCin_tb<='0';
    rden_tb<='0';
    wren_tb<='0';

    ---T2:MDRout, IRin---
    CurrentStage<=T2;
    MDRout_tb<='1';
    IRin_tb<='1';
    wait until RISING_EDGE(clk_tb);
    MDRout_tb<='0'; --reset
    IRin_tb<='0';

    ---T3:Grb, BAout, Yin---
    CurrentStage<=T3;
    Grb_tb<='1';
    BAout_tb<='1';
    Yin_tb<='1';
    wait until RISING_EDGE(clk_tb);
    Grb_tb<='0';
    BAout_tb<='0';
    Yin_tb<='0';

    ---T4:Cout, ADD, Zin---
    CurrentStage<=T4;
    Cout_tb<='1';
    Zin_tb<='1';
    wait until RISING_EDGE(clk_tb);
    Cout_tb<='0';
    Zin_tb<='0';

    ---T5:Zlowout, MARin---
    CurrentStage<=T5;
    ZLout_tb<='1';
    MARin_tb<='1';
    wait until RISING_EDGE(clk_tb);
    ZLout_tb<='0';
    MARin_tb<='0';

    ---T6:Read, Mdatain[31..0], MDRin---
    CurrentStage<=T6;
    rden_tb<='1';
    MDRin_tb<='1';
    wait until RISING_EDGE(clk_tb); 
	  wait until RISING_EDGE(clk_tb); 
	  wait until RISING_EDGE(clk_tb); 
    rden_tb<='0';
    MDRin_tb<='0';

    ---T7:MDRout, Gra, Rin---
    CurrentStage<=T7;
    MDRout_tb<='1';
    Gra_tb<='1';
    Rin_tb<='1';
    wait until RISING_EDGE(clk_tb); 
    MDRout_tb<='0';
    Gra_tb<='0';
    Rin_tb<='0';

    -----------------------------------------------------
    ---case 2: ld R0, $45(R1)---
    ---loads fro ($45+ binary case1), now contains __ in binary---
    ---Memory Address 4()---
    CurrentOp<= Load;
    CurrentStage<=T0;
    PCout_tb<='1';
    MARin_tb<='1';
    IncPC_tb<='1';
    Zin_tb<='1';
    wait until RISING_EDGE(clk_tb);
    PCout_tb<='0';--reset
    MARin_tb<='0';
    IncPC_tb<='0';
    Zin_tb<='0';

    ---T1:Zlowout, PCin, Read, Mdatain[31..0], MDRin---
    CurrentStage<=T1;
    ZLout_tb<='1';
    PCin_tb<='1';
    rden_tb<='1';
    wren_tb<='1';
    wait until RISING_EDGE(clk_tb);
    wait until RISING_EDGE(clk_tb);
    wait until RISING_EDGE(clk_tb);
    ZLout_tb<='0';--reset
    PCin_tb<='0';
    rden_tb<='0';
    wren_tb<='0';

    ---T2:MDRout, IRin---
    CurrentStage<=T2;
    MDRout_tb<='1';
    IRin_tb<='1';
    wait until RISING_EDGE(clk_tb);
    MDRout_tb<='0'; --reset
    IRin_tb<='0';

    ---T3:Grb, BAout, Yin---
    CurrentStage<=T3;
    Grb_tb<='1';
    BAout_tb<='1';
    Yin_tb<='1';
    wait until RISING_EDGE(clk_tb);
    Grb_tb<='0';
    BAout_tb<='0';
    Yin_tb<='0';

    ---T4:Cout, ADD, Zin---
    CurrentStage<=T4;
    Cout_tb<='1';
    Zin_tb<='1';
    wait until RISING_EDGE(clk_tb);
    Cout_tb<='0';
    Zin_tb<='0';

    ---T5:Zlowout, MARin---
    CurrentStage<=T5;
    ZLout_tb<='1';
    MARin_tb<='1';
    wait until RISING_EDGE(clk_tb);
    ZLout_tb<='0';
    MARin_tb<='0';

    ---T6:Read, Mdatain[31..0], MDRin---
    CurrentStage<=T6;
    rden_tb<='1';
    MDRin_tb<='1';
    wait until RISING_EDGE(clk_tb); 
	  wait until RISING_EDGE(clk_tb); 
	  wait until RISING_EDGE(clk_tb); 
    rden_tb<='0';
    MDRin_tb<='0';

    ---T7:MDRout, Gra, Rin---
    CurrentStage<=T7;
    MDRout_tb<='1';
    Gra_tb<='1';
    Rin_tb<='1';
    wait until RISING_EDGE(clk_tb); 
    MDRout_tb<='0';
    Gra_tb<='0';
    Rin_tb<='0';

--------------------------------------
    ---Case 3:ldi   R1, $75---
    ---memory address 8()---
    CurrentOp<=LoadI;
    ---T0-T2: Same as before for “Instruction Fetch---
    CurrentStage<=T0;
    PCout_tb<='1';
    MARin_tb<='1';
    IncPC_tb<='1';
    Zin_tb<='1';
    wait until RISING_EDGE(clk_tb);
    PCout_tb<='0';--reset
    MARin_tb<='0';
    IncPC_tb<='0';
    Zin_tb<='0';

    CurrentStage<=T1;
    ZLout_tb<='1';
    PCin_tb<='1';
    rden_tb<='1';
    wren_tb<='1';
    wait until RISING_EDGE(clk_tb);
    wait until RISING_EDGE(clk_tb);
    wait until RISING_EDGE(clk_tb);
    ZLout_tb<='0';--reset
    PCin_tb<='0';
    rden_tb<='0';
    wren_tb<='0';

    ---T2:MDRout, IRin---
    CurrentStage<=T2;
    MDRout_tb<='1';
    IRin_tb<='1';
    wait until RISING_EDGE(clk_tb);
    MDRout_tb<='0'; --reset
    IRin_tb<='0';

    ---T3:Grb, BAout, Yin---
    CurrentStage<=T3;
    Grb_tb<='1';
    BAout_tb<='1';
    Yin_tb<='1';
    Rout_tb<='1';
    wait until RISING_EDGE(clk_tb);
    Grb_tb<='0';
    BAout_tb<='0';
    Yin_tb<='0';
    Rout_tb<='0';

    ---T4: Cout, ADD, Zin---
    CurrentStage<=T4;
    Cout_tb<='1';
    Zin_tb<='1';
    wait unitl RISING_EDGE(clk_tb);
    Cout_tb<='0';
    Zin_tb<='0';

    ---T5: Zlowout, Gra, Rin---
    CurrentStage<=T5;
    ZLout_tb<='1';
    Gra_tb<='1';
    Rin_tb<='1';
    wait unitl RISING_EDGE(clk_tb);
    ZLout_tb<='0';
    Gra_tb<='0';
    Rin_tb<='0';

----------------------------------------------

    --- ldi	R1, $45(R1) --> loads 120 (45 + 75 (in R1)) ---
    --- Memory Address 12	()---
    CurrentOp<=LoadI;
    ---T0-T2: Same as before for “Instruction Fetch---
    CurrentStage<=T0;
    PCout_tb<='1';
    MARin_tb<='1';
    IncPC_tb<='1';
    Zin_tb<='1';
    wait until RISING_EDGE(clk_tb);
    PCout_tb<='0';--reset
    MARin_tb<='0';
    IncPC_tb<='0';
    Zin_tb<='0';

    CurrentStage<=T1;
    ZLout_tb<='1';
    PCin_tb<='1';
    rden_tb<='1';
    wren_tb<='1';
    wait until RISING_EDGE(clk_tb);
    wait until RISING_EDGE(clk_tb);
    wait until RISING_EDGE(clk_tb);
    ZLout_tb<='0';--reset
    PCin_tb<='0';
    rden_tb<='0';
    wren_tb<='0';

    ---T2:MDRout, IRin---
    CurrentStage<=T2;
    MDRout_tb<='1';
    IRin_tb<='1';
    wait until RISING_EDGE(clk_tb);
    MDRout_tb<='0'; --reset
    IRin_tb<='0';

    ---T3:Grb, BAout, Yin---
    CurrentStage<=T3;
    Grb_tb<='1';
    BAout_tb<='1';
    Yin_tb<='1';
    Rout_tb<='1';
    wait until RISING_EDGE(clk_tb);
    Grb_tb<='0';
    BAout_tb<='0';
    Yin_tb<='0';
    Rout_tb<='0';

    ---T4: Cout, ADD, Zin---
    CurrentStage<=T4;
    Cout_tb<='1';
    Zin_tb<='1';
    wait unitl RISING_EDGE(clk_tb);
    Cout_tb<='0';
    Zin_tb<='0';

    ---T5: Zlowout, Gra, Rin---
    CurrentStage<=T5;
    ZLout_tb<='1';
    Gra_tb<='1';
    Rin_tb<='1';
    wait unitl RISING_EDGE(clk_tb);
    ZLout_tb<='0';
    Gra_tb<='0';
    Rin_tb<='0';


