----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/18/2024 02:27:46 PM
-- Design Name: 
-- Module Name: NegativeDetector - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity NegativeDetector is
    Port ( ANeg : in STD_LOGIC_VECTOR (7 downto 0);
           RES : out STD_LOGIC_VECTOR (7 downto 0);
           Clock : in STD_LOGIC);
end NegativeDetector;

architecture Behavioral of NegativeDetector is

signal sign : STD_LOGIC;
signal NOTA : STD_LOGIC_VECTOR(6 downto 0);
begin
sign <= ANeg(7);

process(ANeg, Clock)
begin
if(rising_edge(Clock)) then
    if(sign = '0') then
        RES <= ANeg;
    else
        NOTA(6 downto 0) <= not ANeg(6 downto 0);
        RES(6 downto 0) <= std_logic_vector(unsigned(NOTA) + 1);
        RES(7) <= sign;
    
    
    end if;
end if;
end process;
    

end Behavioral;
