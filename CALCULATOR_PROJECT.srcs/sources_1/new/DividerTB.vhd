----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/27/2024 04:24:08 PM
-- Design Name: 
-- Module Name: DividerTB - Behavioral
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

entity DIVIDER_TB is
end DIVIDER_TB;

architecture Behavioral of DIVIDER_TB is
    signal dividend : STD_LOGIC_VECTOR (7 downto 0);
    signal divisor  : STD_LOGIC_VECTOR (7 downto 0);
    signal quotient : STD_LOGIC_VECTOR (7 downto 0);
    signal remainder: STD_LOGIC_VECTOR (6 downto 0);

begin
    UUT: entity work.DIVIDER
        port map (
            dividend => dividend,
            divisor  => divisor,
            quotient => quotient,
            remainder => remainder
        );

    stimulus: process
    begin
        -- Test case 1: 8 divided by 2
        dividend <= "00001000";
        divisor  <= "00000010";
        wait for 10 ns;

        -- Test case 2: 15 divided by 3
        dividend <= "00001111";
        divisor  <= "00000011";
        wait for 10 ns;

        -- Add more test cases as needed

        wait;
    end process stimulus;
end Behavioral;

