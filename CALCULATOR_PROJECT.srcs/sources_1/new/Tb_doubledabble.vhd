library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity doubledabble_tb is
end doubledabble_tb;

architecture Behavioral of doubledabble_tb is
    constant CLK_PERIOD : time := 10 ns; -- Define clock period
    signal B_tb : std_logic_vector(13 downto 0); -- Input signal
    signal P_tb : std_logic_vector(19 downto 0); -- Output signal

    -- Component declaration for the module under test
    component doubledabble
        Port (B : in STD_LOGIC_VECTOR(13 downto 0);
              P : out STD_LOGIC_VECTOR(19 downto 0));
    end component;

begin
    -- Instantiate the module under test
    UUT : doubledabble
        port map (B => B_tb, P => P_tb);

    -- Stimulus process
    stimulus : process
    begin
        -- Apply stimulus to inputs
        B_tb <= "11111100000001"; -- Example input, change as needed
        
        -- Wait for 100 ns to allow the process to run
        wait for 100 ns;
        
        -- Add more stimulus here if needed
        
        -- End simulation
        wait;
    end process stimulus;

end Behavioral;
