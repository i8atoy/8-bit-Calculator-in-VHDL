library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity SevenSegmentDisplay is
    Port (
        clk : in STD_LOGIC;
        reset : in STD_LOGIC;
        FirstDigit : in STD_LOGIC_VECTOR(6 downto 0);
        SecondDigit : in STD_LOGIC_VECTOR(6 downto 0);
        ThirdDigit : in STD_LOGIC_VECTOR(6 downto 0);
        FourthDigit : in STD_LOGIC_VECTOR(6 downto 0);
        FifthDigit : in STD_LOGIC_VECTOR(6 downto 0);
        an : out STD_LOGIC_VECTOR(7 downto 0);
        seg : out STD_LOGIC_VECTOR(6 downto 0)
    );
end SevenSegmentDisplay;

architecture Behavioral of SevenSegmentDisplay is
    signal clk_div : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
    signal current_digit : INTEGER range 0 to 7 := 0;
begin

    -- Clock divider process
    process(clk, reset)
    begin
        if reset = '1' then
            clk_div <= (others => '0');
        elsif rising_edge(clk) then
            clk_div <= clk_div + 1;
        end if;
    end process;

    -- Current digit control process
    process(clk_div, reset)
    begin
        if reset = '1' then
            current_digit <= 0;
        elsif rising_edge(clk_div(15)) then
            current_digit <= (current_digit + 1) mod 8;
        end if;
    end process;

    -- Anode control logic
    process(current_digit, reset)
    begin
        if reset = '1' then
            an <= "11111111";
        else
            case current_digit is
                when 0 => an <= "11111110"; -- Activate digit 0
                when 1 => an <= "11111101"; -- Activate digit 1
                when 2 => an <= "11111011"; -- Activate digit 2
                when 3 => an <= "11110111"; -- Activate digit 3
                when 4 => an <= "11101111"; -- Activate digit 4
                when others => an <= "11111111"; -- Deactivate all digits
            end case;
        end if;
    end process;

    -- Segment control logic
    process(current_digit, reset)
    begin
        if reset = '1' then
            seg <= "0000000"; -- Turn off all segments
        else
            case current_digit is
                when 0 => seg <= FirstDigit;  -- Display FirstDigit
                when 1 => seg <= SecondDigit; -- Display SecondDigit
                when 2 => seg <= ThirdDigit;  -- Display ThirdDigit
                when 3 => seg <= FourthDigit; -- Display FourthDigit
                when 4 => seg <= FifthDigit;  -- Display FifthDigit
                when others => seg <= "0000000"; -- Turn off all segments
            end case;
        end if;
    end process;

end Behavioral;
