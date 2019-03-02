--algorithm adapted from jonathonReinhart's booth multiplier on github

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all; 

entity booth_multiplier is
	port(
		M, Q : in std_logic_vector(31 downto 0);
		result : out std_logic_vector(63 downto 0)
	);
end entity;

architecture behavioural of booth_multiplier is
	subtype vectorData is std_logic_vector(64 downto 0);
	signal signedM, negM, divisor : vectorData;
	signal output : std_logic_vector(63 downto 0);

function shift_left(data : vectorData; dist : integer)
			return vectorData is
	variable res : vectorData;
	variable i : integer := 0;
begin

	while (i + dist < 64) loop
		res(i+dist) := data(i);
		i := i + 1;
	end loop;
	
	res(dist downto 0) := (others =>'0');

return res;
end shift_left;

function shift_right(data : vectorData; dist : integer)
			return vectorData is
	variable res : vectorData;
	variable i : integer := 0;

begin

	while(i + dist < 64) loop
		res(i) := data(i + dist);
		i := i + 1;
	end loop;
	
	res(64 downto (64 - dist)) := (others => '0');

return res;
end shift_right;

begin

	signedM(64 downto 33) <= M(31 downto 0);
	signedM(32 downto 0) <= (others => '0');
	
	negM(64 downto 33) <= not(M(31 downto 0)) + 1;
	negM(32 downto 0) <= (others => '0');
	
	divisor(64 downto 33) <= (others => '0');
	divisor(32 downto 1) <= Q(31 downto 0);
	divisor(0) <= '0';
	
process(M, Q, divisor, signedM, negM) is
	variable count : integer := 0;
	variable toCheck : std_logic_vector(2 downto 0);
	variable encoding : vectorData;
	variable doneVar : boolean;
begin
	
	encoding := divisor;
	
	for i in 0 to 15 loop
		toCheck := encoding(2 downto 0);
		
		if (toCheck = "001" or toCheck = "010") then
			encoding := encoding + signedM;
		elsif(toCheck = "011") then
			encoding := encoding + shift_left(signedM, 1);
		elsif(toCheck = "100") then
			encoding := encoding + shift_left(negM, 1);
		elsif(toCheck = "101" or toCheck = "110") then
			encoding := encoding + negM;
		end if;

		encoding := shift_right(encoding, 2);
	end loop;
	
		output(63 downto 0) <= encoding(64 downto 1);
		
end process;

	result(63) <= M(31) xor Q(31);
	result(62 downto 0) <= std_logic_vector(output(62 downto 0));

end behavioural;
