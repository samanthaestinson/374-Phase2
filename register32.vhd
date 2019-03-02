library ieee;
use ieee.std_logic_1164.all;


entity register32 is 
port (D	: in std_logic_vector (31 downto 0);
		Q	: out std_logic_vector (31 downto 0);
		clk	: in std_logic;
		clr	: in std_logic;
		enable	: in std_logic);
end register32;

architecture behavioral of register32 is
begin
	process (clk, clr, enable)
	begin
      if clr = '1' then
            Q <= (others=>'0');
	  elsif (rising_edge(clk)) then
		if enable='1' then
			Q <= D;
		end if;
	  end if;
    end process;
end behavioral;

