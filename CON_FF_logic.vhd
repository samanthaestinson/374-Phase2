
library IEEE;
use ieee.std_logic_1164.all;

entity con_ff_logic is 
	port(IR_low_bits : in std_logic_vector(1 downto 0);
			register_in : in std_logic_vector(31 downto 0);
			Con_in, con_clk : in std_logic;
			con_out : out std_logic
	);
end con_ff_logic;

architecture behavioral of con_ff_logic is

component D_flipflop is
	port(clk, d, enable : in std_logic;
			q : out std_logic
	);
end component D_flipflop;

signal or_output : std_logic;

begin
	d_ff_con : D_flipflop port map(clk => con_clk, d => or_output, enable => Con_in, q => con_out);
	
	process(IR_low_bits, register_in, con_in) is
	
	variable out_decoder : std_logic_vector(3 downto 0);
	variable and0, and1, and2, and3 : std_logic;
	variable register_nor : std_logic;
	
	begin
	
		register_nor := register_in(0);
		
		for bit_index in 1 to 31 loop
			register_nor := register_nor nor register_in(bit_index);
		end loop;
	
		case IR_low_bits is
			when "00" => out_decoder := b"0001";					-- brzr
			when "01" => out_decoder := b"0010";					-- brnz
			when "10" => out_decoder := b"0100";					-- brpl
			when "11" => out_decoder := b"1000";					-- brmi
			when others => out_decoder := b"0000";
		end case;
		
		and0 := out_decoder(0) and register_nor; 			-- = 0
		and1 := out_decoder(1) and (not register_nor); 	-- != 0
		and2 := out_decoder(2) and (not register_in(31)); 		-- >= 0
		and3 := out_decoder(3) and register_in(31); 				-- < 0
		
		or_output <= and0 or and1 or and2 or and3;
		
	end process;

end architecture behavioral;