library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all; 

entity datapath_shl_tb is
end datapath_shl_tb;

architecture datapath_tb_arch of datapath_shl_tb is
	type state is (default, reg_load1a, reg_load1b, reg_load2a, reg_load2b, reg_load3a, reg_load3b, T0, T1, T2, T3, T4, T5);
	signal present_state: state := default;
	signal clk_tb, clr_tb : std_logic;
	signal R3out_tb, R5out_tb : std_logic;
	signal R1in_tb, R3in_tb, R5in_tb : std_logic;
	signal R1value, R3value, R5value, BusMuxOut_tb : std_logic_vector(31 downto 0);
	signal PCout_tb, ZHout_tb, ZLout_tb, MDRout_tb : std_logic;
	signal MARin_tb, Zin_tb, PCin_tb, MDRin_tb, IRin_tb, Yin_tb: std_logic;
	signal IncPC_tb, Read_tb, ctl_shl_tb : std_logic;
	
	signal Mdatain_tb : std_logic_vector(31 downto 0);
	
	signal R0in_tb, R4in_tb, R2in_tb, R6in_tb, R7in_tb, R8in_tb, R9in_tb, R10in_tb,
		R11in_tb, R12in_tb, R13in_tb, R14in_tb, R15in_tb : std_logic;
	signal	R0out_tb, R1out_tb, R4out_tb, R2out_tb, R6out_tb, R7out_tb, R8out_tb, R9out_tb, R10out_tb,
		R11out_tb, R12out_tb, R13out_tb, R14out_tb, R15out_tb, LOout_tb, HIout_tb : std_logic;
	
	signal	ctl_sub_tb : STD_LOGIC := '0';
	signal	ctl_mul_tb :  STD_LOGIC:= '0';
	signal	ctl_div_tb :  STD_LOGIC:= '0';
	signal	ctl_add_tb :  STD_LOGIC:= '0';
	signal	ctl_shra_tb :  STD_LOGIC:= '0';
	signal	ctl_shr_tb :  STD_LOGIC:= '0';
	signal	ctl_ror_tb :  STD_LOGIC:= '0';
	signal	ctl_rol_tb :  STD_LOGIC:= '0';
	signal	ctl_and_tb :  STD_LOGIC:= '0';
	signal	ctl_or_tb :  STD_LOGIC:= '0';
	signal	ctl_not_tb :  STD_LOGIC:= '0';
	signal	ctl_neg_tb :  STD_LOGIC:= '0';
	
	

component datapath is
	port(
		PCout, ZHout, ZLout, MDRout : in std_logic;
		MARin, Zin, PCin, MDRin,  IRin, Yin : in std_logic;
		IncPC, Rd : in std_logic;
		R0in, R1in, R2in, R3in, R4in, R5in, R6in, R7in, R8in, R9in, R10in,
		R11in, R12in, R13in, R14in, R15in : in std_logic;
		R0out, R1out, R2out, R3out, R4out, R5out, R6out, R7out, R8out, R9out, R10out,
		R11out, R12out, R13out, R14out, R15out, LOout, HIout : in std_logic;
		clk, clr : in std_logic;
		Mdatain  :  in std_logic_vector(31 downto 0);
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
		R9value, R10value, R11value, R12value, R13value, R14value, R15value, ZLvalue, LOvalue, HIvalue, BusMuxOut_tb : out std_logic_vector(31 downto 0)
	);
end component datapath;

begin
DUT: datapath port map(
		clr => clr_tb,
		PCout 	=>	PCout_tb,
		ZHout		=> ZHout_tb,
		ZLout 	=>	ZLout_tb,
		MDRout 	=>	MDRout_tb,
		R0in 	=>	R0in_tb,
		R1in 	=>	R1in_tb,
		R2in 	=>	R2in_tb,
		R3in 	=>	R3in_tb,
		R4in 	=>	R4in_tb,
		R5in 	=>	R5in_tb,
		R6in 	=>	R6in_tb,
		R7in 	=>	R7in_tb,
		R8in 	=>	R8in_tb,
		R9in 	=>	R9in_tb,
		R10in 	=>	R10in_tb,
		R11in 	=>	R11in_tb,
		R12in 	=>	R12in_tb,
		R13in 	=>	R13in_tb,
		R14in 	=>	R14in_tb,
		R15in 	=>	R15in_tb,
		R0out 	=>	R0out_tb,
		R1out 	=>	R1out_tb,
		R2out 	=>	R2out_tb,
		R3out 	=>	R3out_tb,
		R4out 	=>	R4out_tb,
		R5out 	=>	R5out_tb,
		R6out 	=>	R6out_tb,
		R7out 	=>	R7out_tb,
		R8out 	=>	R8out_tb,
		R9out 	=>	R9out_tb,
		R10out 	=>	R10out_tb,
		R11out 	=>	R11out_tb,
		R12out 	=>	R12out_tb,
		R13out 	=>	R13out_tb,
		R14out 	=>	R14out_tb,
		R15out 	=>	R15out_tb,
		LOout		=> LOout_tb,
		HIout		=> HIout_tb,
		MARin 	=>	MARin_tb,
		Zin 		=>	Zin_tb,
		PCin 		=>	PCin_tb,
		MDRin 	=>	MDRin_tb,
		IRin 		=>	IRin_tb,
		Yin 		=>	Yin_tb,
		IncPC 	=>	IncPC_tb,
		Rd			=>	Read_tb,
		ctl_add => ctl_add_tb,
		ctl_sub => ctl_sub_tb,
		ctl_mul => ctl_mul_tb,
		ctl_div => ctl_div_tb,
		ctl_shr => ctl_shr_tb,
		ctl_shra => ctl_shra_tb,
		ctl_shl => ctl_shl_tb,
		ctl_ror => ctl_ror_tb,
		ctl_rol => ctl_rol_tb,
		ctl_and => ctl_and_tb,
		ctl_or  => ctl_or_tb,
		ctl_not => ctl_not_tb,
		ctl_neg => ctl_neg_tb,
		
		clk		=>	clk_tb,
		Mdatain	=>	Mdatain_tb,
		R1value	=> R1value,
		R3value	=> R3value,
		R5value	=> R5value,
		BusMuxOut_tb => BusMuxOut_tb
		);
		
		
Clock_proc : process is
begin
	clk_tb <=  '1', '0' after 10 ns;
	wait for 20 ns;
end process Clock_proc;
		
process(clk_tb) is
begin
	if (rising_edge(clk_tb)) then
		case present_state is
			when default =>
				present_state <= reg_load1a;
			when reg_load1a =>
				present_state <= reg_load1b;
			when reg_load1b =>
				present_state <= reg_load2a;
			when reg_load2a =>
				present_state <= reg_load2b;
			when reg_load2b =>
				present_state <= reg_load3a;
			when reg_load3a =>
				present_state <= reg_load3b;
			when reg_load3b =>
				present_state <= T0;
			when T0 =>
				present_state <= T1;
			when T1 =>
				present_state <= T2;
			when T2 =>
				present_state <= T3;
			when T3 =>
				present_state <= T4;
			when T4 =>
				present_state <= T5;
			when others =>
		end case;
	end if;
end process;

process(present_state) is
begin
	case present_state is
		when default =>
			PCout_tb <= '0'; ZLout_tb <= '0'; MDRout_tb <= '0';
			R3out_tb <= '0'; R5out_tb <= '0'; MARin_tb <= '0'; Zin_tb <= '0';
			PCin_tb <= '0'; MDRin_tb <= '0'; IRin_tb <= '0'; Yin_tb <= '0';
			IncPC_tb <= '0'; Read_tb <= '0'; ctl_shl_tb <= '0';
			R1in_tb <= '0'; R3in_tb <= '0'; R5in_tb <= '0';
			Mdatain_tb <= x"00000000";
		when reg_load1a =>
			Mdatain_tb <= x"00000012";
			Read_tb <= '0', '1' after 10 ns, '0' after 25 ns;
			MDRin_tb <= '0', '1' after 10 ns, '0' after 25 ns;
		when reg_load1b =>
			MDRout_tb <= '0', '1' after 10 ns, '0' after 25 ns;
			R1in_tb <= '0', '1' after 10 ns, '0' after 25 ns;
		when reg_load2a =>
			Mdatain_tb <= x"02349871";
			Read_tb <= '0', '1' after 10 ns, '0' after 25 ns;
			MDRin_tb <= '0', '1' after 10 ns, '0' after 25 ns;
		when reg_load2b =>
			MDRout_tb <= '0', '1' after 10 ns, '0' after 25 ns;
			R3in_tb <= '0', '1' after 10 ns, '0' after 25 ns;
		when reg_load3a =>
			Mdatain_tb <=  x"00000002";
			Read_tb <= '0', '1' after 10 ns, '0' after 25 ns;
			MDRin_tb <= '0', '1' after 10 ns, '0' after 25 ns;
		when reg_load3b =>
			MDRout_tb <= '0', '1' after 10 ns, '0' after 25 ns;
			R5in_tb <= '0', '1' after 10 ns, '0' after 25 ns;
		when T0 =>
			PCout_tb <=  '1';  MARin_tb <= '1' after 10 ns, '0' after 25 ns; IncPC_tb <= '1' after 10 ns, '0' after 25 ns; Zin_tb <= '1' after 10 ns, '0' after 25 ns;
		when T1 =>
			ZLout_tb <= '1' after 10 ns, '0' after 25 ns; PCin_tb <= '1' after 10 ns, '0' after 25 ns; Read_tb <= '1' after 10 ns, '0' after 25 ns; MDRin_tb <= '1' after 10 ns, '0' after 25 ns;
			Mdatain_tb <= x"28918000";
		when T2 =>
			MDRout_tb <= '1' after 10 ns, '0' after 25 ns; IRin_tb <= '1' after 10 ns, '0' after 25 ns;
		when T3 =>
			R3out_tb <= '1' after 10 ns, '0' after 25 ns; Yin_tb <= '1' after 10 ns, '0' after 25 ns;
		when T4 =>
			R5out_tb <= '1' after 10 ns, '0' after 25 ns; ctl_shl_tb <= '1'; Zin_tb <= '1' after 10 ns, '0' after 25 ns;
		when T5 =>
			ZLout_tb <= '1' after 10 ns, '0' after 25 ns; R1in_tb <= '1' after 10 ns, '0' after 25 ns;
		when others =>
	end case;
end process;
end architecture datapath_tb_arch;
