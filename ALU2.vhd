library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all; 


entity ALU is
port( 
		A: in std_logic_vector(31 downto 0);
		B: in std_logic_vector(31 downto 0);
		C: out std_logic_vector(63 downto 0);
		
		ctl_add : in std_logic;
		ctl_sub : in std_logic;
		ctl_mul : in std_logic;
		ctl_div : in std_logic;
		
		ctl_shr : in std_logic;
		ctl_shra : in std_logic;
		ctl_shl : in std_logic;
		ctl_ror : in std_logic;
		ctl_rol : in std_logic;
		
		ctl_and : in std_logic;
		ctl_or : in std_logic;
		ctl_not : in std_logic;
		ctl_neg : in std_logic
);
end ALU;

architecture behaviour of ALU is

component lpm_add_sub0 IS
	PORT
	(
		add_sub		: IN STD_LOGIC ;
		dataa		: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		datab		: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		result		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
	);
END component lpm_add_sub0;

component booth_multiplier is--booth multiplier
	port(
		M, Q : in std_logic_vector(31 downto 0);
		result : out std_logic_vector(63 downto 0)
	);

end component booth_multiplier;

component lpm_divide0 IS
	PORT
	(
		denom		: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		numer		: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		quotient		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
		remain		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
	);
END component lpm_divide0;

component arith_shift IS
	PORT
	(
		data		: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		distance		: IN STD_LOGIC_VECTOR (4 DOWNTO 0);
		result		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
	);
END component arith_shift;

component lpm_clshift0 IS
	PORT
	(
		data		: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		direction		: IN STD_LOGIC ;
		distance		: IN STD_LOGIC_VECTOR (4 DOWNTO 0);
		result		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
	);
END component lpm_clshift0;

component lpm_rotate IS
	PORT
	(
		data		: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		direction		: IN STD_LOGIC ;
		distance		: IN STD_LOGIC_VECTOR (4 DOWNTO 0);
		result		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
	);
END component lpm_rotate;

signal add_sub_sel, shift_sel, rot_sel: std_logic :=  '0';
signal sel: std_logic_vector(3 downto 0) := (others => '0');
signal add_sub_out, quotient, remainder, logical_shift_out, arith_shift_out, rot_out : std_logic_vector(31 downto 0) := (others =>'0');
signal mult_out : std_logic_vector(63 downto 0);

begin

adder:			lpm_add_sub0 port map(add_sub=>add_sub_sel, dataa=>A, datab=>B, result=>add_sub_out);
multiplier:		booth_multiplier port map(M=>A, Q=>B, result=>mult_out);
shifter:			lpm_clshift0 port map(data=>A, direction=>shift_sel, distance=>B(4 downto 0), result=>logical_shift_out);
arith_shifter:	arith_shift port map(data=>A, distance=>B(4 downto 0), result=>arith_shift_out);
divide:			lpm_divide0 port map(denom=>B, numer=>A, quotient=>quotient, remain=>remainder);
rotater:		lpm_rotate port map(data=>A, direction=>rot_sel, distance=>B(4 downto 0), result=>rot_out);
	
	sel <= "0001" when (ctl_add = '1') else
			 "0010" when (ctl_sub = '1') else
			 "0011" when (ctl_mul = '1') else
			 "0100" when (ctl_div = '1') else
			 "0101" when (ctl_shr = '1') else
			 "0110" when (ctl_shra = '1') else
			 "0111" when (ctl_shl = '1') else
			 "1000" when (ctl_ror = '1') else
			 "1001" when (ctl_rol = '1') else
			 "1010" when (ctl_and = '1') else
			 "1011" when (ctl_or = '1') else
			 "1100" when (ctl_not = '1') else
			 "1101" when (ctl_neg = '1') else
			 "0000";
			 
	process(sel, A, B, add_sub_out, remainder, quotient, rot_out, arith_shift_out, logical_shift_out, mult_out) is
	begin
		add_sub_sel <= '0';
		rot_sel <= '0';
		shift_sel <= '0';
		case sel is
			when "0001" =>
			--addition
				add_sub_sel <= '1';
				C(31 downto 0) <= add_sub_out;
				C(63 downto 32) <= (others=>'0');
			when "0010" =>
			--subtraction
				add_sub_sel <= '0';
				C(31 downto 0) <= add_sub_out;
				C(63 downto 32) <= (others => '0');
			when "0011" =>
			--multiplication
				C <= mult_out;
			when "0100" =>
			--division
				C(63 downto 32) <= remainder;
				C(31 downto 0) <= quotient;
			when "0101" =>
			--logical shift right
				shift_sel <= '1';
				C(31 downto 0) <= logical_shift_out;
				C(63 downto 32) <= (others => '0');
			when "0110" =>
			--arithmetic shift right
				C(31 downto 0) <= arith_shift_out;
				C(63 downto 32) <= (others => '0');
			when "0111" =>
			--shift left
				shift_sel <= '0';
				C(31 downto 0) <= logical_shift_out;
				C(63 downto 32) <= (others => '0');
			when "1000" =>
			--rotate right
				rot_sel <= '1';
				C(31 downto 0) <= rot_out;
				C(63 downto 32) <= (others => '0');
			when "1001" =>
			--rotate left
				rot_sel <= '0';
				C(31 downto 0) <= rot_out;
				C(63 downto 32) <= (others => '0');
			when "1010" =>
			--and
				C(31 downto 0) <= A and B;
				C(63 downto 32) <= (others => '0');
			when "1011" =>
			--or
				C(31 downto 0) <= A or B;
				C(63 downto 32) <= (others => '0');
			when "1100" =>
			--not
				C(31 downto 0) <= not B;
				C(63 downto 32) <= (others => '0');
			when "1101" =>
			--negate - 2's complement
				C(63 downto 32) <= (others =>'0');
				C(31 downto 0) <= (not B) + 1;
			when others =>
				C <= (others => '0');
				add_sub_sel <= '0';
				rot_sel <= '0';
				shift_sel <= '0';
		end case;
		
	end process;
	
end architecture;
 

