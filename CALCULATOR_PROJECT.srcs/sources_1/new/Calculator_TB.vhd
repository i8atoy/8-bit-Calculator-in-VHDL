


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Calculator_TB is
end Calculator_TB;

architecture Behavioral of Calculator_TB is

component Calculator
    Port ( --9 for each digit(0,1,2,3,4,5,6,7,8,9), 1 for sign
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
           Anodes : out STD_LOGIC_VECTOR(4 downto 0));
end component;
constant clk_period : time := 10 ns;
signal clk : STD_LOGIC := '0';
signal res : STD_LOGIC := '0';
signal conf : STD_LOGIC;
signal confInp : STD_LOGIC;
signal s_Switches : STD_LOGIC_VECTOR(10 downto 0);

begin
uut : Calculator port map(
                          Switches => s_Switches,
                          Clock => clk,
                          Confirm => conf,
                          ConfirmInput => confInp,
                          Reset => res);

clk_process :process
    begin
        while true loop
            clk <= '0';
            wait for clk_period/2;
            clk <= '1';
            wait for clk_period/2;
        end loop;
    end process;
    
stim_proc: process
    begin
        -- hold reset state for 20 ns
        res <= '1';
        wait for 20 ns;  
        res <= '0';
        
        s_Switches <= "00000000000";
        confInp <= '1';
        confInp <= '0';
        s_Switches <= "00010000000";
        confInp <= '1';
        confInp <= '0';
        s_Switches <= "00000000001";
        confInp <= '1';
        confInp <= '0';
        conf <= '1';
        

        -- Insert additional stimulus here
        wait for 100 ns;
        
        -- End simulation
        wait;
    end process;

 
end Behavioral;
