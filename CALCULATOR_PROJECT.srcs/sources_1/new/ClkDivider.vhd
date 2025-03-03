library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ClkDiv is
    Port(
         Clk : in STD_LOGIC;
         OutClk : out STD_LOGIC);
end ClkDiv;

architecture Behavioral of clkDiv is

begin

    process(Clk)
    variable var : integer := 0;
    begin
    if(Clk'EVENT) and ( CLK = '1') then
        OutCLK <= '0';
        var := var + 1;
        if(var = 2**10) then
            var := 0;
        else if (var = 2**10 - 1) then
          OUTCLK <= '1';
          end if;
          end if;
          end if;
          end process;
          end Behavioral;