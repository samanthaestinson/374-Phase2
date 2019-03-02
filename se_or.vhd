LIBRARY ieee ;
USE ieee.std_logic_1164.all ;

Entity select_encoder_or is
port(
ra : in std_logic_vector(3 downto 0);
rb : in std_logic_vector(3 downto 0);
rc : in std_logic_vector(3 downto 0);
or_out : out std_logic_vector(3 downto 0));
end select_encoder_or;

architecture structure of select_encoder_or is
begin

	or_out <= (ra or rb or rc);

end structure;