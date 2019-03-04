Library ieee;
USE ieee.std_logic_1164.all;

ENTITY cpu_codyale_tb IS
END;

-- Architecture of the testbench with the signal names
ARCHITECTURE phase2_tb_arch OF phase2_tb ISnto 0); --Out port enable signal
 -- component instantiation of the datapath
COMPONENt datapath_phase2 is
PORT(
	--CONTROL PORTS
	clk :  IN  STD_LOGIC;
    clr :  IN  STD_LOGIC;
    IncPC : IN STD_LOGIC;
    MARin : IN STD_LOGIC;               	---MemRead
    MDRin  : IN STD_LOGIC;                  ---WriteSig	
    strobe : IN STD_LOGIC;
    ---OutPort_en : IN STD_LOGIC;

	--REGISTER CONTROL PORTS
	BAout : IN STD_LOGIC;
    Gra : IN STD_LOGIC;
    Grb : IN STD_LOGIC;
    Grc : IN STD_LOGIC;
	Rin : IN STD_LOGIC;
    Rout : IN STD_LOGIC;
	---RA_en : IN STD_LOGIC;

	--NON-REGISTER CONTROL PORTS 
	-- Enables
	HIvalue: IN STD_LOGIC; ---31 downto on phase2
    LOvalue: IN STD_LOGIC; ---31 downto on phase2
    ---PCIn,		
    ---IRin,		
    Zin: IN STD_LOGIC;
    Yin: IN STD_LOGIC;
	---MARin,	
    ---MDR_in,
    ---Conin,	---zin???
	
    --BusMuxSelects
	HIvalue: IN STD_LOGIC;		---HIOut
    LOvalue: IN STD_LOGIC;  ---LOOut
    ---ZHIOut,	
    ZLout: IN STD_LOGIC;
    PCout: IN STD_LOGIC;
    MDR_out: IN STD_LOGIC;
    ---PortOut, 
    ---Cout			: IN STD_LOGIC; in phase 1 only??? is it being used in tb?
	input_port_in 	: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
	--END CTL PORTS
		
	--DEMONSTRATION PORTS
	d_Con_FF_out 	: OUT STD_LOGIC;
	d_R0value,	d_R1value,	d_R2value,	d_R3value,	d_R4value,	d_R5value,	d_R6value,	d_R7value,
	d_R8value,	d_R9value,	d_R10value,	d_R11value,	d_R12value,	d_R13value,	d_R14value,	d_R15value,
	d_HIvalue,	d_LOvalue,	
    ---d_PCout its in on ours, does it matter & 1 bit
    --- d_MDRout,	
    d_BusMuxOut, 
    ---d_IROut, its phase 1? do i have to acess it?
    ---d_YOut,		
    ---d_C_sign_extended, doesnt exist?
	d_ZLout, ---in std single for other 	
    d_ZHout,	
    ---d_MARout,??? do we need? in phase 1
	----OutPort		in phase 1
    : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
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
    ---MemRd_tb,   
    ---WriteSig_tb,	
    strobe_tb,  Outport_in_tb, 
    --Register TB Signals
    BAout_tb,	Gra_tb,		Grb_tb,		Grc_tb,		Rin_tb,		Rout_tb,	
    ---RA_en_tb not in diagram
    --Non-Register TB Signals
    --Enable TB Signals
    ---HIin_tb,		LOin_tb, 	
    PCin_tb,		IRin_tb,		Zin_tb,		Yin_tb,
	MARin_tb,	MDRin_tb, 	con_enable_tb,	
	--BusMuxSelect TB Signals
	HIout_tb,	LOout_tb,	ZHout_tb,	ZLout_tb, 	PCout_tb, 	MDRout_tb,	
	outport_in ---PortOut_tb,
    ---Cout_tb	
    : STD_LOGIC;
	SIGNAL input_port_in _tb,	outport_in_tb : STD_LOGIC_VECTOR(31 downto 0); ---or outport_out ???
	SIGNAL --Outputs for Demonstration
		BusMuxOut_tb, IR_out_tb,d_PCout_tb,
		R0value_tb,	R1value_tb,	R2value_tb,	R3value_tb,	R4value_tb,	R5value_tb,	R6value_tb,	R7value_tb,
		R8value_tb,	R9value_tb,	R10value_tb,	R11value_tb,	R12value_tb,	R0value_tb,	R14Out_tb,	R15Out_tb,
		d_HIOut_tb,	d_LOOut_tb,	d_YOut_tb,	d_MDROut_tb,MarOut_tb,	d_ZHiOut_tb,	d_ZLoOut_tb, 	C_sign_extended_tb	: STD_LOGIC_VECTOR(31 DOWNTO 0);
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------		
BEGIN
	--SIGNAL gnd32 STD_LOGIC_VECTOR(31 downto 0) := x"00000000";
	--DUT inst
	DUT : cpu_codyale
	PORT MAP(
		--CONTROL PORTS
		clk => clk_tb,	clr => clr_tb, IncPC => IncPC_tb,
		MemRead=>MemRd_tb, WriteSig=>WriteSig_tb, strobe=>strobe_tb, Outport_en=>Outport_en_tb,
		
		--REGISTER CONTROL PORTS
		BAout=>BAout_tb,	GRA=>GRA_tb,	GRB=>GRB_tb,	GRC=>GRC_tb,	
		Rin=>Rin_tb,	Rout=>Rout_tb,		RA_en=> RA_en_tb,
		--NON-REGISTER CONTROL PORTS 
		-- Enables
		HIIn => HIIn_tb,
		LOIn  =>LOIn_tb,
		PCIn	=>PCIn_tb,
		IRin	=>IRin_tb,
		ZIn	=>ZIn_tb,
		Yin	=>Yin_tb,
		MARin =>MARin_tb,
		MDRin =>MDRin_tb,
		CONin =>CONin_tb,
		--BusMuxSelects
		HIOut => HIOut_tb,
		LOOut => LOOut_tb,
		ZHiOut=> ZHiOut_tb,
		ZLOOut=> ZLOOut_tb,
		PCOut => PCOut_tb,	
		MDROut=> MDROut_tb,
		PortOut=>PortOut_tb,
		COut	=> Cout_tb,
		InPort=> InPort_tb,
		--END CONTROL PORTS
		--DEMONSTRATION PORTS
		d_R00Out => R00Out_tb,
		d_R01Out => R01Out_tb,
		d_R02Out => R02Out_tb,
		d_R03Out => R03Out_tb,
		d_R04Out => R04Out_tb,
		d_R05Out => R05Out_tb,
		d_R06Out => R06Out_tb,
		d_R07Out => R07Out_tb,
		d_R08Out => R08Out_tb,
		d_R09Out => R09Out_tb,
		d_R10Out => R10Out_tb,
		d_R11Out => R11Out_tb,
		d_R12Out => R12Out_tb,
		d_R13Out => R13Out_tb,
		d_R14Out => R14Out_tb,
		d_R15Out => R15Out_tb,
		d_HIOut => d_HIOut_tb,
		d_LOOut => d_LOOut_tb,
		d_PCOut => d_PCOut_tb,
		d_MDROut => d_MDROut_tb,
		d_BusMuxOut => BusMuxOut_tb,
		d_IROut => IRout_tb,
		d_YOut => d_YOut_tb,
		d_ZHiOut => d_ZHiOut_tb,
		d_ZLoOut => d_ZLoOut_tb,
		d_MARout => MarOut_tb,
		d_c_sign_extended => C_sign_extended_tb,
		OutPort => OutPort_tb
	);
	--processes
	clk_process : process
	begin
		clk_tb <= '0', '1' after 5 ns;
		Wait for 10 ns;
	end process clk_process;
