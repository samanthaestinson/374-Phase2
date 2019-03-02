library ieee;
use ieee.std_logic_1164.all;

entity busMuxxx is
port (R0out, R1out, R2out, R3out, R4out, R5out, R6out, R7out, R8out, R9out, R10out,
		R11out, R12out, R13out, R14out, R15out : in std_logic;
		HIout, LOout, ZHout, ZLout, PCout, MDRout, inPortOut, CSignOut : in std_logic;
		
		R0BusMuxIn, R1BusMuxIn, R2BusMuxIN, R3BusMuxIn, R4BusMuxIn, R5BusMuxIn, R6BusMuxIn, R7BusMuxIn, R8BusMuxIn,
		R9BusMuxIn, R10BusMuxIn, R11BusMuxIn, R12BusMuxIn, R13BusMuxIn, R14BusMuxIn, R15BusMuxIn : in std_logic_vector(31 downto 0);
		
		BusMuxInHI, BusMuxInLO, BusMuxInZH, BusMuxInZL, BusMuxInPC, BusMuxInMDR,
		BusMuxIninPort, CSignExt : in std_logic_vector(31 downto 0);
		
		BusMuxOut : out std_logic_vector(31 downto 0)
		);
		
end entity busMuxxx;

architecture procedural of busMuxxx is

begin
	BusMuxOut <= R0BusMuxIn when (R0out = '1') else 
				R1BusMuxIn when (R1out = '1')else
			   R2BusMuxIn when (R2out = '1')else
			   R3BusMuxIn when (R3out = '1')else
			   R4BusMuxIn when (R4out = '1')else
			   R5BusMuxIn when (R5out = '1')else
			   R6BusMuxIn when (R6out = '1')else
			   R7BusMuxIn when (R7out = '1')else
			   R8BusMuxIn when (R8out = '1')else
			   R9BusMuxIn when (R9out = '1')else
			   R10BusMuxIn when (R10out = '1')else
			   R11BusMuxIn when (R11out = '1')else
			   R12BusMuxIn when (R12out = '1')else
			   R13BusMuxIn when (R13out = '1')else
			   R14BusMuxIn when (R14out = '1')else
			   R15BusMuxIn when (R15out = '1')else
			   BusMuxInHI when (HIout = '1')else
			   BusMuxInLO when (LOout = '1')else
			   BusMuxInZH when (ZHout = '1')else
			   BusMuxInZL when (ZLout = '1')else
			   BusMuxInPC when (PCout = '1')else
			   BusMuxInMDR when (MDRout = '1')else
			   BusMuxIninPort when (inPortOut = '1')else
			   CSignExt when (CsignOut = '1')else
			   (others => '0');

end procedural;
					  
		

	