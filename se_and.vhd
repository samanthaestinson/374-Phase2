LIBRARY ieee ;
USE ieee.std_logic_1164.all ;

Entity select_encoder_and is
port(
r : in std_logic_vector(3 downto 0);
Gr : in std_logic;
and_out : out std_logic_vector(3 downto 0)
);
end select_encoder_and;

architecture structure of select_encoder_and is
begin

process(r(3 downto 0), Gr)

begin

case Gr is

when '0' => and_out <= r(3 downto 0);
when others => and_out <= "0000";

end case;
end process;
end structure;