
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity INPUT_TB is
--  Port ( );
end INPUT_TB;

architecture Behavioral of INPUT_TB is
component Calculator
    port(  --9 for each digit(0,1,2,3,4,5,6,7,8,9), 1 for sign
           -- will use input Switches twice
           -- after filling input1, we can change A for input2
           Switches : in STD_LOGIC_VECTOR(10 downto 0);
           -- 0 addition, 1 subtraction, 2 multiplication, 2 subtraction. 
           Clock : in STD_LOGIC;
           Confirm : in STD_LOGIC;
           ConfirmInput : in STD_LOGIC;
           -- confirm is synonimous to equals and HAS to be a button.
           -- reset should also be a button.
           Reset: in STD_LOGIC;
           SSDOutput : out STD_LOGIC_VECTOR(6 downto 0);
           Anod : out STD_LOGIC_VECTOR(7 downto 0));
           
end component;
signal Switches : STD_LOGIC_VECTOR(10 downto 0);
signal Clock: STD_LOGIC;
Signal Confirm : STD_LOGIC;
signal ConfirmInput : STD_LOGIC;
signal Reset : STD_LOGIC;
signal SSDOutput : STD_LOGIC_VECTOR(6 downto 0);
signal Anod : std_LOGIC_VECTOR(7 downto 0);
begin

uut: Calculator port map(Switches => Switches,
                         Clock => Clock, 
                         Confirm => Confirm, 
                         ConfirmInput => ConfirmInput,
                         Reset => Reset,
                         SSDOutput => SSDOutput,
                         Anod => Anod);
                         
process
begin
    clock <= '0';
    wait for 10 ns;
    clock <= '1';
    wait for 10 ns;
    
end process;

stimproc: process
begin
    reset <= '1';
    wait for 10 ns;
    reset <= '0';
    wait for 10 ns;
    Switches <= "00000000000";
    ConfirmInput <= '1';
    wait for 10 ns;
    ConfirmInput <= '0';
    wait for 10 ns;
    Switches <= "00000000010";
    ConfirmInput <= '1';
    wait for 20 ns;
    ConfirmInput <= '0';
    wait for 10 ns;
    Switches <= "00000000010";
    ConfirmInput <= '1';
    
    wait for 20 ns;
    ConfirmInput <= '0';
    Confirm <= '1';
    
    wait for 20 ns;
    Confirm <= '0';
    Switches <= "00000000000";
    ConfirmInput <= '1';
    
    wait for 20 ns;
    ConfirmInput <= '0';
    Confirm <= '1';
    --state 3
    wait for 20 ns;
    Confirm <= '0';
    Switches <= "00000000000";
    ConfirmInput <= '1';
    wait for 10 ns;
    ConfirmInput <= '0';
    wait for 20 ns;
    Switches <= "00000000010";
    ConfirmInput <= '1';
    wait for 20 ns;
    ConfirmInput <= '0';
    wait for 20 ns;
    Switches <= "00000000010";
    ConfirmInput <= '1';
    
    wait for 20 ns;
    ConfirmInput <= '0';
    Confirm <= '1';
    
    wait for 20 ns;
    
    Confirm <= '0';
    --state 4
    
    
    

    

    
    wait;
    

end process;

end Behavioral;
