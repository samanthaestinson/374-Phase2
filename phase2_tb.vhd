library IEEE;
use ieee.std_logic_1164.all;
ENTITY phase2_tb IS
END;

-- Architecture of the testbench with the signal names
ARCHITECTURE phase2_tb_arch OF phase2_tb IS
  SIGNAL clear_tb, clk_tb : std_logic;
  SIGNAL register_in0_tb, register_in1_tb, register_in2_tb, register_in3_tb, register_in4_tb, register_in5_tb, register_in6_tb, register_in7_tb : std_logic; --enable singals for registers
  SIGNAL register_in8_tb, register_in9_tb, register_in10_tb, register_in11_tb, register_in12_tb, register_in13_tb, register_in14_tb, register_in15_tb : std_logic; --enable singals for registers
  SIGNAL register_in_MDR_tb, register_in_PC_tb, register_in_Zhigh_tb, register_in_Zlow_tb, register_in_LO_tb, register_in_HI_tb, register_in_Y_tb : std_logic; --enable singals for registers
  SIGNAL register_in_Z_tb, register_in_IR_tb, register_in_MAR_tb, register_in_in_port_tb, register_in_C_tb : std_logic; --enable singals for registers
  
  SIGNAL R0_out_tb, R1_out_tb, R2_out_tb, R3_out_tb, R4_out_tb, R5_out_tb, R6_out_tb, R7_out_tb : std_logic_vector(31 downto 0); --bidirectional pins for registers
  SIGNAL R8_out_tb, R9_out_tb, R10_out_tb, R11_out_tb, R12_out_tb, R13_out_tb, R14_out_tb, R15_out_tb : std_logic_vector(31 downto 0); --bidirectional pins for registers
  SIGNAL BusMuxOut_tb, HI_out_tb, LO_out_tb, Zhigh_out_tb, Zlow_out_tb, PC_out_tb, MDR_out_tb, Zhigh_in_tb, Zlow_in_tb, MDR_in_tb, In_port_out_tb, C_sign_out_tb, IR_out_tb, MAR_out_tb, Y_out_tb : std_logic_vector (31 downto 0); --bidirectional pins for registers
  SIGNAL Z_in_tb, ALU_out_tb : std_logic_vector (63 downto 0); --bidirectional pins for registers
  SIGNAL S_out_tb : std_logic_vector (4 downto 0); --bidirectional pins for registers
  
  SIGNAL R0out_tb, R1out_tb, R2out_tb, R3out_tb, R4out_tb, R5out_tb, R6out_tb, R7out_tb, R8out_tb, R9out_tb, R10out_tb, R11out_tb, R12out_tb : std_logic; --inputs to encoder
  SIGNAL R13out_tb, R14out_tb, R15out_tb, HIout_tb, LOout_tb, Zlowout_tb, Zhighout_tb, PCout_tb, MDRout_tb, In_portout_tb, Cout_tb : std_logic; --inputs to encoder
  
  SIGNAL Mdatain_tb : std_logic_vector (31 downto 0); --MDatain from RAM
  SIGNAL read_tb : std_logic; --MDMUX read 
  SIGNAL ALU_cs_tb : std_logic_vector(3 downto 0); --ALU control signal
  
  SIGNAL Gra_tb, Grb_tb, Grc_tb, Rin_tb, Rout_tb, BAout_tb,	Con_in_tb :  STD_LOGIC; --Input for select/encode logic and CON FF logic
  
  SIGNAL Con_out_tb :  STD_LOGIC; --CON FF logic output
  SIGNAL IncPC_enable_tb : STD_LOGIC; --Enable signal for IncPC component
  SIGNAL R14MUX_enable_tb : STD_LOGIC; --Enable signal for R14MUX component
  
  SIGNAL write_tb : std_logic; --RAM write signal 
  SIGNAL register_in_out_port_tb : std_logic; --Out port enable signal
  SIGNAL In_port_in_tb : std_logic_vector(31 downto 0); --In port enable signal
  SIGNAL Out_port_output_tb : std_logic_vector(31 downto 0); --Out port enable signal
  
  TYPE State IS (defaultA, defaultB, load_case1_T0A, load_case1_T0B, load_case1_T1A, load_case1_T1B, load_case1_T2A, load_case1_T2B, load_case1_T3A, load_case1_T3B, load_case1_T4A, load_case1_T4B, load_case1_T5A, load_case1_T5B, load_case1_T6A, load_case1_T6B, load_case1_T7A, load_case1_T7B, 
						load_case2_T0A, load_case2_T0B, load_case2_T1A, load_case2_T1B, load_case2_T2A, load_case2_T2B, load_case2_T3A, load_case2_T3B, load_case2_T4A, load_case2_T4B, load_case2_T5A, load_case2_T5B, load_case2_T6A, load_case2_T6B, load_case2_T7A, load_case2_T7B,
						load_case3_T0A, load_case3_T0B, load_case3_T1A, load_case3_T1B, load_case3_T2A, load_case3_T2B, load_case3_T3A, load_case3_T3B, load_case3_T4A, load_case3_T4B, load_case3_T5A, load_case3_T5B, 
						load_case4_T0A, load_case4_T0B, load_case4_T1A, load_case4_T1B, load_case4_T2A, load_case4_T2B, load_case4_T3A, load_case4_T3B, load_case4_T4A, load_case4_T4B, load_case4_T5A, load_case4_T5B, 
						load_case5_T0A, load_case5_T0B, load_case5_T1A, load_case5_T1B, load_case5_T2A, load_case5_T2B, load_case5_T3A, load_case5_T3B, load_case5_T4A, load_case5_T4B, load_case5_T5A, load_case5_T5B, load_case5_T6A, load_case5_T6B,
						
						store_reg_init_T0A, store_reg_init_T0B, store_reg_init_T1A, store_reg_init_T1B, store_reg_init_T2A, store_reg_init_T2B, store_reg_init_T3A, store_reg_init_T3B, store_reg_init_T4A, store_reg_init_T4B, store_reg_init_T5A, store_reg_init_T5B,
						store_case1_T0A, store_case1_T0B, store_case1_T1A, store_case1_T1B, store_case1_T2A, store_case1_T2B, store_case1_T3A, store_case1_T3B, store_case1_T4A, store_case1_T4B, store_case1_T5A, store_case1_T5B, store_case1_T6A, store_case1_T6B, store_case1_T7A, store_case1_T7B,
						store_check1_T0A, store_check1_T0B, store_check1_T1A, store_check1_T1B, store_check1_T2A, store_check1_T2B, store_check1_T3A, store_check1_T3B, store_check1_T4A, store_check1_T4B, store_check1_T5A, store_check1_T5B, store_check1_T6A, store_check1_T6B, store_check1_T7A, store_check1_T7B,
						store_case2_T0A, store_case2_T0B, store_case2_T1A, store_case2_T1B, store_case2_T2A, store_case2_T2B, store_case2_T3A, store_case2_T3B, store_case2_T4A, store_case2_T4B, store_case2_T5A, store_case2_T5B, store_case2_T6A, store_case2_T6B, store_case2_T7A, store_case2_T7B,
						store_check2_T0A, store_check2_T0B, store_check2_T1A, store_check2_T1B, store_check2_T2A, store_check2_T2B, store_check2_T3A, store_check2_T3B, store_check2_T4A, store_check2_T4B, store_check2_T5A, store_check2_T5B, store_check2_T6A, store_check2_T6B, store_check2_T7A, store_check2_T7B,
						store_case3_T0A, store_case3_T0B, store_case3_T1A, store_case3_T1B, store_case3_T2A, store_case3_T2B, store_case3_T3A, store_case3_T3B, store_case3_T4A, store_case3_T4B, store_case3_T5A, store_case3_T5B, store_case3_T6A, store_case3_T6B,
						store_check3_T0A, store_check3_T0B, store_check3_T1A, store_check3_T1B, store_check3_T2A, store_check3_T2B, store_check3_T3A, store_check3_T3B, store_check3_T4A, store_check3_T4B, store_check3_T5A, store_check3_T5B, store_check3_T6A, store_check3_T6B, store_check3_T7A, store_check3_T7B,
						
						ALU_case1_T0A, ALU_case1_T0B, ALU_case1_T1A, ALU_case1_T1B, ALU_case1_T2A, ALU_case1_T2B, ALU_case1_T3A, ALU_case1_T3B, ALU_case1_T4A, ALU_case1_T4B, ALU_case1_T5A, ALU_case1_T5B,
						ALU_case2_T0A, ALU_case2_T0B, ALU_case2_T1A, ALU_case2_T1B, ALU_case2_T2A, ALU_case2_T2B, ALU_case2_T3A, ALU_case2_T3B, ALU_case2_T4A, ALU_case2_T4B, ALU_case2_T5A, ALU_case2_T5B,
						ALU_case3_T0A, ALU_case3_T0B, ALU_case3_T1A, ALU_case3_T1B, ALU_case3_T2A, ALU_case3_T2B, ALU_case3_T3A, ALU_case3_T3B, ALU_case3_T4A, ALU_case3_T4B, ALU_case3_T5A, ALU_case3_T5B,
						
						branch_reg_init1_T0A, branch_reg_init1_T0B, branch_reg_init1_T1A, branch_reg_init1_T1B, branch_reg_init1_T2A, branch_reg_init1_T2B, branch_reg_init1_T3A, branch_reg_init1_T3B, branch_reg_init1_T4A, branch_reg_init1_T4B, branch_reg_init1_T5A, branch_reg_init1_T5B, 
						branch_case1_T0A, branch_case1_T0B, branch_case1_T1A, branch_case1_T1B, branch_case1_T2A, branch_case1_T2B, branch_case1_T3A, branch_case1_T3B, branch_case1_T4A, branch_case1_T4B,
						branch_reg_init2_T0A, branch_reg_init2_T0B, branch_reg_init2_T1A, branch_reg_init2_T1B, branch_reg_init2_T2A, branch_reg_init2_T2B, branch_reg_init2_T3A, branch_reg_init2_T3B, branch_reg_init2_T4A, branch_reg_init2_T4B, branch_reg_init2_T5A, branch_reg_init2_T5B, 
						branch_reg_init3_T0A, branch_reg_init3_T0B, branch_reg_init3_T1A, branch_reg_init3_T1B, branch_reg_init3_T2A, branch_reg_init3_T2B, branch_reg_init3_T3A, branch_reg_init3_T3B, branch_reg_init3_T4A, branch_reg_init3_T4B, branch_reg_init3_T5A, branch_reg_init3_T5B, 
						branch_case2_T0A, branch_case2_T0B, branch_case2_T1A, branch_case2_T1B, branch_case2_T2A, branch_case2_T2B, branch_case2_T3A, branch_case2_T3B, branch_case2_T4A, branch_case2_T4B,
						branch_reg_init4_T0A, branch_reg_init4_T0B, branch_reg_init4_T1A, branch_reg_init4_T1B, branch_reg_init4_T2A, branch_reg_init4_T2B, branch_reg_init4_T3A, branch_reg_init4_T3B, branch_reg_init4_T4A, branch_reg_init4_T4B, branch_reg_init4_T5A, branch_reg_init4_T5B, 
						branch_case3_T0A, branch_case3_T0B, branch_case3_T1A, branch_case3_T1B, branch_case3_T2A, branch_case3_T2B, branch_case3_T3A, branch_case3_T3B, branch_case3_T4A, branch_case3_T4B,
						branch_reg_init5_T0A, branch_reg_init5_T0B, branch_reg_init5_T1A, branch_reg_init5_T1B, branch_reg_init5_T2A, branch_reg_init5_T2B, branch_reg_init5_T3A, branch_reg_init5_T3B, branch_reg_init5_T4A, branch_reg_init5_T4B, branch_reg_init5_T5A, branch_reg_init5_T5B,	
						branch_reg_init6_T0A, branch_reg_init6_T0B, branch_reg_init6_T1A, branch_reg_init6_T1B, branch_reg_init6_T2A, branch_reg_init6_T2B, branch_reg_init6_T3A, branch_reg_init6_T3B, branch_reg_init6_T4A, branch_reg_init6_T4B, branch_reg_init6_T5A, branch_reg_init6_T5B, 
						branch_case4_T0A, branch_case4_T0B, branch_case4_T1A, branch_case4_T1B, branch_case4_T2A, branch_case4_T2B, branch_case4_T3A, branch_case4_T3B, branch_case4_T4A, branch_case4_T4B,
						
						jump_reg_init1_T0A, jump_reg_init1_T0B, jump_reg_init1_T1A, jump_reg_init1_T1B, jump_reg_init1_T2A, jump_reg_init1_T2B, jump_reg_init1_T3A, jump_reg_init1_T3B, jump_reg_init1_T4A, jump_reg_init1_T4B, jump_reg_init1_T5A, jump_reg_init1_T5B, 
						jump_case1_T0A, jump_case1_T0B, jump_case1_T1A, jump_case1_T1B, jump_case1_T2A, jump_case1_T2B, jump_case1_T3A, jump_case1_T3B,
						jump_reg_init2_T0A, jump_reg_init2_T0B, jump_reg_init2_T1A, jump_reg_init2_T1B, jump_reg_init2_T2A, jump_reg_init2_T2B, jump_reg_init2_T3A, jump_reg_init2_T3B, jump_reg_init2_T4A, jump_reg_init2_T4B, jump_reg_init2_T5A, jump_reg_init2_T5B, 
						jump_case2_T0A, jump_case2_T0B, jump_case2_T1A, jump_case2_T1B, jump_case2_T2A, jump_case2_T2B, jump_case2_T3A, jump_case2_T3B,
						move_reg_init1_T0A, move_reg_init1_T0B, move_reg_init1_T1A, move_reg_init1_T1B, move_reg_init1_T2A, move_reg_init1_T2B, move_reg_init1_T3A, move_reg_init1_T3B, move_reg_init1_T4A, move_reg_init1_T4B, move_reg_init1_T5A, move_reg_init1_T5B, 
						move_reg_init2_T0A, move_reg_init2_T0B, move_reg_init2_T1A, move_reg_init2_T1B, move_reg_init2_T2A, move_reg_init2_T2B, move_reg_init2_T3A, move_reg_init2_T3B, move_reg_init2_T4A, move_reg_init2_T4B, move_reg_init2_T5A, move_reg_init2_T5B, 
						mul_T0A, mul_T0B, mul_T1A, mul_T1B, mul_T2A, mul_T2B, mul_T3A, mul_T3B, mul_T4A, mul_T4B, mul_T5A, mul_T5B, mul_T6A, mul_T6B,
						mfhi_T0A, mfhi_T0B, mfhi_T1A, mfhi_T1B, mfhi_T2A, mfhi_T2B, mfhi_T3A, mfhi_T3B,
						mflo_T0A, mflo_T0B, mflo_T1A, mflo_T1B, mflo_T2A, mflo_T2B, mflo_T3A, mflo_T3B,
						
						In_port_init_T0A, In_port_init_T0B,
						in_T0A, in_T0B, in_T1A, in_T1B, in_T2A, in_T2B, in_T3A, in_T3B,
						out_T0A, out_T0B, out_T1A, out_T1B, out_T2A, out_T2B, out_T3A, out_T3B						
						
						);
  SIGNAL Present_state: State := defaultA;
 
 -- component instantiation of the datapath
COMPONENt datapath_phase2 is
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
end COMPONENT ;

architecture structure of datapath_phase2 is

COMPONENT  datapath_phase1
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
END COMPONENT ;



 BEGIN
 DUT : phase1
--port mapping: between the dut and the testbench signals
  PORT MAP (
  
  
  
