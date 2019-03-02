LIBRARY ieee ;
USE ieee.std_logic_1164.all ;

Entity select_encoder is
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

--R15_out : out std_logic;
--R14_out : out std_logic;
--R13_out : out std_logic;
--R12_out : out std_logic;
--R11_out : out std_logic;
--R10_out : out std_logic;
--R9_out : out std_logic;
--R8_out : out std_logic;
--R7_out : out std_logic;
--R6_out : out std_logic;
--R5_out : out std_logic;
--R4_out : out std_logic;
--R3_out : out std_logic;
--R2_out : out std_logic;
--R1_out : out std_logic;
--R0_out : out std_logic
);
end select_encoder;

architecture structure of select_encoder is
	component se_and
		port(
		r : in std_logic_vector(3 downto 0);
		Gr : in std_logic;
		and_out : out std_logic_vector(3 downto 0));
	end component;
	
	component se_or
	port(
		ra : in std_logic_vector(3 downto 0);
		rb : in std_logic_vector(3 downto 0);
		rc : in std_logic_vector(3 downto 0);
		or_out : out std_logic_vector(3 downto 0));
	end component;
	
	component dec4to16
	port(
		w : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		En : IN STD_LOGIC ;
		y : OUT STD_LOGIC_VECTOR(0 TO 15));
	end component;

signal BAR : std_LOGIC;
signal ra_and_out, rb_and_out, rc_and_out, decoder_in : std_logic_vector(3 downto 0);
signal decoder_out : std_LOGIC_VECTOR(15 downto 0);
	
begin
-- some of these arrow things => might be wrongs
and_a : se_and port map(
	r => IR_in(26 downto 23),
	Gr => Gra,
	and_out => ra_and_out
);

and_b : se_and port map(
	r => IR_in(22 downto 19),
	Gr => Grb,
	and_out => rb_and_out
);

and_c : se_and port map(
	r => IR_in(18 downto 15),
	Gr => Grc,
	and_out => rc_and_out
);

sel_or : se_or port map(
	ra => ra_and_out,
	rb => rb_and_out,
	rc => rc_and_out,
	or_out => decoder_in
);

sel_4to16 : dec4to16 port map(
	w => decoder_in,
	En => '1',
	y => decoder_out
);
-- Gotta make signals or ports for these things
--R15in => decoder_out(15) and Rin;
--R14in => decoder_out(14) and Rin;
--R13in => decoder_out(13) and Rin;
--R12in => decoder_out(12) and Rin;
--R11in => decoder_out(11) and Rin;
--R10in => decoder_out(10) and Rin;
--R9in => decoder_out(9) and Rin;
--R8in => decoder_out(8) and Rin;
--R7in => decoder_out(7) and Rin;
--R6in => decoder_out(6) and Rin;
--R5in => decoder_out(5) and Rin;
--R4in => decoder_out(4) and Rin;
--R3in => decoder_out(3) and Rin;
--R2in => decoder_out(2) and Rin;
--R1in => decoder_out(1) and Rin;
--R0in => decoder_out(0) and Rin;

sel_en_Rin(15) <= decoder_out(15) and Rin;
sel_en_Rin(14) <= decoder_out(15) and Rin;
sel_en_Rin(13) <= decoder_out(15) and Rin;
sel_en_Rin(12) <= decoder_out(15) and Rin;
sel_en_Rin(11) <= decoder_out(15) and Rin;
sel_en_Rin(10) <= decoder_out(15) and Rin;
sel_en_Rin(9) <= decoder_out(15) and Rin;
sel_en_Rin(8) <= decoder_out(15) and Rin;
sel_en_Rin(7) <= decoder_out(15) and Rin;
sel_en_Rin(6) <= decoder_out(15) and Rin;
sel_en_Rin(5) <= decoder_out(15) and Rin;
sel_en_Rin(4) <= decoder_out(15) and Rin;
sel_en_Rin(3) <= decoder_out(15) and Rin;
sel_en_Rin(2) <= decoder_out(15) and Rin;
sel_en_Rin(1) <= decoder_out(15) and Rin;
sel_en_Rin(0) <= decoder_out(15) and Rin;

BAR <= BAout and Rout;

sel_en_Rout(15) <= decoder_out(15) and BAR;
sel_en_Rout(14) <= decoder_out(15) and BAR;
sel_en_Rout(13) <= decoder_out(15) and BAR;
sel_en_Rout(12) <= decoder_out(15) and BAR;
sel_en_Rout(11) <= decoder_out(15) and BAR;
sel_en_Rout(10) <= decoder_out(15) and BAR;
sel_en_Rout(9) <= decoder_out(15) and BAR;
sel_en_Rout(8) <= decoder_out(15) and BAR;
sel_en_Rout(7) <= decoder_out(15) and BAR;
sel_en_Rout(6) <= decoder_out(15) and BAR;
sel_en_Rout(5) <= decoder_out(15) and BAR;
sel_en_Rout(4) <= decoder_out(15) and BAR;
sel_en_Rout(3) <= decoder_out(15) and BAR;
sel_en_Rout(2) <= decoder_out(15) and BAR;
sel_en_Rout(1) <= decoder_out(15) and BAR;
sel_en_Rout(0) <= decoder_out(15) and BAR;



--R15out => decoder_out(15) and BAR;
--R14out => decoder_out(15) and BAR;
--R13out => decoder_out(15) and BAR;
--R12out => decoder_out(15) and BAR;
--R11out => decoder_out(15) and BAR;
--R10out => decoder_out(15) and BAR;
--R9out => decoder_out(15) and BAR;
--R8out => decoder_out(15) and BAR;
--R7out => decoder_out(15) and BAR;
--R6out => decoder_out(15) and BAR;
--R5out => decoder_out(15) and BAR;
--R4out => decoder_out(15) and BAR;
--R3out => decoder_out(15) and BAR;
--R2out => decoder_out(15) and BAR;
--R1out => decoder_out(15) and BAR;
--R0out => decoder_out(15) and BAR;



end;




