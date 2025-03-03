----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:03:51 01/22/2021 
-- Design Name: 
-- Module Name:    eightbit_fulladder - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity eightBitFULLADDER is
    Port ( A,B : in  STD_LOGIC_VECTOR (7 downto 0);
           S : out  STD_LOGIC_VECTOR (7 downto 0); Cout: out STD_LOGIC);
end eightBitFULLADDER;

architecture Behavioral of eightBitFULLADDER is

component fulladder
Port (Ain,Bin,Cin : in STD_LOGIC;
       S,Cout : out STD_LOGIC);
end component;

signal c : STD_LOGIC_VECTOR(6 downto 0);


begin

FA1: fulladder port map(Ain => A(0), Bin=> B(0), Cin => '0' , S => S(0), Cout => c(0));
FA2: fulladder port map(Ain => A(1), Bin=> B(1), Cin => c(0), S => S(1),Cout => c(1));
FA3: fulladder port map(Ain => A(2), Bin=> B(2), Cin => c(1), S => S(2),Cout => c(2));
FA4: fulladder port map(Ain => A(3), Bin=> B(3), Cin => c(2), S => S(3),Cout => c(3));
FA5: fulladder port map(Ain => A(4), Bin=> B(4), Cin => c(3), S => S(4),Cout => c(4));
FA6: fulladder port map(Ain => A(5), Bin=> B(5), Cin => c(4), S => S(5),Cout => c(5));
FA7: fulladder port map(Ain => A(6), Bin=> B(6), Cin => c(5), S => S(6),Cout => c(6));
FA8: fulladder port map(Ain => A(7), Bin=> B(7), Cin => c(6), S => S(7),Cout => Cout);


end Behavioral;