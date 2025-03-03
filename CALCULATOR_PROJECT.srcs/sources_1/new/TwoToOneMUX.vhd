----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/18/2024 02:50:23 PM
-- Design Name: 
-- Module Name: TwoToOneMUX - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

library ieee;
use ieee.std_logic_1164.all; 
entity TwoToOneMUX is
  port (a0, a1, s : in std_logic;
     f : out std_logic); 
end TwoToOneMUX;
architecture behaviour of TwoToOneMUX is 
begin
  process(a0, a1, s)
  begin
    if s = '0' then
      f <= a0;
    else
      f <= a1;
    end if;
  end process;
end behaviour;
