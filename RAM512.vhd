library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.mem_init.all;


entity RAM512 is
   port
   (
      data	: in std_logic_vector(31 downto 0);
      address	: in std_logic_vector(8 downto 0);
      wren	: in std_logic;
		rden	: in std_logic;
      q	: out std_logic_vector(31 downto 0);
		RAMcontents : out mem
   );
end entity;
architecture logic of RAM512 is
signal ram_block : mem := initial_mem;
begin
process (wren, rden, address, data, ram_block)
begin
q <= (others => '0');
RAMcontents <= ram_block;
if(wren = '1') then
	ram_block(to_integer(unsigned(address))) <= data;
elsif(rden = '1') then
	q <= ram_block(to_integer(unsigned(address)));
end if;
end process;
end architecture;