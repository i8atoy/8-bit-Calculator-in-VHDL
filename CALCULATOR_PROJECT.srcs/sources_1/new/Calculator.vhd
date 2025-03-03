library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use IEEE.NUMERIC_STD.ALL;

entity Calculator is
    Port ( --9 for each digit(0,1,2,3,4,5,6,7,8,9), 1 for sign
           -- will use input Switches twice
           -- after filling input1, we can change A for input2
           Switches : in STD_LOGIC_VECTOR(10 downto 0);
           -- 0 addition, 1 subtraction, 2 multiplication, 2 subtraction. 
           Clock : in STD_LOGIC;
           Confirm1 : in STD_LOGIC;
           ConfirmInput1 : in STD_LOGIC;
           StateLED : out STD_LOGIC_VECTOR(4 downto 0);
           StateA : out STD_LOGIC_VECTOR(2 downto 0);
           StateB : out STD_LOGIC_VECTOR(2 downto 0);
           -- confirm is synonimous to equals and HAS to be a button.
           -- reset should also be a button.
           Reset1: in STD_LOGIC;
           SSDOutput : out STD_LOGIC_VECTOR(6 downto 0);
           Anod : out STD_LOGIC_VECTOR(7 downto 0));
           
end Calculator;

architecture Behavioral of Calculator is
type states is (state1, state2, state3, state4, state5);
type input is (hundreds, tens, ones);

-- signals for input!

signal CurrentInputStateA : input := hundreds;
signal CurrentInputStateB : input := hundreds;
signal CurrentState : states := state1;
signal input1 : STD_LOGIC_VECTOR(7 downto 0);
signal input2 : STD_LOGIC_VECTOR(7 downto 0);
signal operation : STD_LOGIC_VECTOR(1 downto 0);

-- signals for addition/subtraction

signal ANegDetector : STD_LOGIC_VECTOR(7 downto 0);
signal BNegDetector : STD_LOGIC_VECTOR(7 downto 0);
signal AddSubRes : STD_LOGIC_VECTOR(7 downto 0);
signal PaddedDDInput : STD_LOGIC_VECTOR(15 downto 0);

component AnodeLoop
        Port ( 
        CLK : in std_logic;
        Reset : in std_logic;
        Anodes : out std_logic_vector(0 to 7);
        AnodeBCD : out std_logic_vector(0 to 2));
end component;


component divider
        port(a,b:in std_logic_vector(0 to 7);-- numerele ce se vor imparti
	    p:out std_logic_vector(0 to 7);-- catul
	    rest1: out std_logic_vector(0 to 7));-- restul
end component;

signal ConfirmInput : STD_LOGIC;
signal Confirm : STD_LOGIC;
signal Reset : STD_LOGIC;

component Debouncer is
        Port ( btn : in STD_LOGIC;
           clk : in STD_LOGIC;
           en : out STD_LOGIC);
end component;

signal DivClk : STD_LOGIC;
component ClkDiv
        Port(
            Clk : in STD_LOGIC;
            OutClk : out STD_LOGIC);
end component;

component NegativeDetector
        Port (
            ANeg : in STD_LOGIC_VECTOR (7 downto 0);
            RES : out STD_LOGIC_VECTOR (7 downto 0);
            Clock : in STD_LOGIC);
end component; 

component binary_bcd
        Port ( clk, reset: in std_logic;
               binary_in: in std_logic_vector(15 downto 0);
               bcd0, bcd1, bcd2, bcd3, bcd4: out std_logic_vector(3 downto 0)
			  );
end component;

component BCDtoSSD
        Port ( BCDin : in STD_LOGIC_VECTOR (3 downto 0);
               Seven_Segment : out STD_LOGIC_VECTOR (6 downto 0));
end component;

component eightBitFULLADDER
        Port (
            A,B : in  STD_LOGIC_VECTOR (7 downto 0);
            S : out  STD_LOGIC_VECTOR (7 downto 0);
            Cout: out STD_LOGIC);
end component;

component doubledabble
        Port ( BIN : in  STD_LOGIC_VECTOR(15 downto 0);
           BCD : out  STD_LOGIC_VECTOR(19 downto 0);
           CLK : in STD_LOGIC;
           RESET : in	STD_LOGIC);
end component;

--signals for multiplication.
signal MulResult : STD_LOGIC_VECTOR(14 downto 0); 

component EightBitMultiplier
        port (IN1, IN2 : in STD_LOGIC_VECTOR(7 downto 0);
            PRODUCT : out STD_LOGIC_VECTOR(14 downto 0));
end component;

--signals for division
signal DivResult : STD_LOGIC_VECTOR(7 downto 0);


-- signal for result storing
signal IntResult : STD_LOGIC_VECTOR(7 downto 0);

--signal for double dabble
signal DDInput : STD_LOGIC_VECTOR(13 downto 0) := "00000000000000";
signal AddSign : STD_LOGIC;
signal MulSign : STD_LOGIC;
signal DivSign : STD_LOGIC;


signal signalFirstDigit :  STD_LOGIC_VECTOR(3 downto 0);
signal signalSecondDigit :  STD_LOGIC_VECTOR(3 downto 0);
signal signalThirdDigit :  STD_LOGIC_VECTOR(3 downto 0);
signal signalFourthDigit :  STD_LOGIC_VECTOR(3 downto 0);
signal signalFifthDigit :  STD_LOGIC_VECTOR(3 downto 0);

signal ssdFirstDigit :  STD_LOGIC_VECTOR(6 downto 0);
signal ssdSecondDigit :  STD_LOGIC_VECTOR(6 downto 0);
signal ssdThirdDigit :  STD_LOGIC_VECTOR(6 downto 0);
signal ssdFourthDigit :  STD_LOGIC_VECTOR(6 downto 0);
signal ssdFifthDigit :  STD_LOGIC_VECTOR(6 downto 0);

signal NotAnod : STD_LOGIC_VECTOR(7 downto 0);

signal Sel : STD_LOGIC_VECTOR(2 downto 0);
begin
    
    --need to figure out how to start first state
   StateMachine: process(Confirm, Reset, Clock)
   begin
      
           if(Reset = '1') then 
               CurrentState <= state1;
            elsif(rising_edge(Clock)) then
               if(confirm = '1') then
                   case CurrentState is
                       when state1 => CurrentState <= state2; 
                       when state2 => CurrentState <= state3;
                       when state3 => CurrentState <= state4;
                       when state4 => CurrentState <= state5;
                       when others => CurrentState <= state2;
                   end case;
               end if;
           end if;
   end process StateMachine;
   
   INPUTPROCESS: process(CurrentState, ConfirmInput, Clock)
    variable AtoBinary : STD_LOGIC_VECTOR(7 downto 0);
    variable BtoBinary : STD_LOGIC_VECTOR(7 downto 0);
    begin
            if(Reset = '1') then
                input1 <= "00000000";
                input2 <= "00000000";
                DDInput <= "00000000000000";
                AtoBinary := "00000000";
                BtoBinary := "00000000";
                --will reset functionality of calculator
                CurrentInputStateA <= hundreds;
                CurrentInputStateB <= hundreds;
            elsif(rising_edge(Clock)) then
            case CurrentState is
            when state1 =>
            -- sign bit
                if(Switches(10) = '0') then
                    AtoBinary(7) := '0';
                else
                    AtoBinary(7) := '1';
                end if;
            -- checking if the hundreds digit is 1 (limit is 127 for 8 bits)       
                if(CurrentInputStateA = hundreds) then
                    if(ConfirmInput = '1') then
                        if(Switches(1) = '1') then    
                                AtoBinary(6 downto 0) := "1100100";
                        else  
                                AtoBinary(6 downto 0) := "0000000";
                        end if;
                        CurrentInputStateA <= tens;                   
                    end if;
                end if;
    
            -- for tens
            if(CurrentInputStateA = tens) then
                if(ConfirmInput = '1') then
                    case Switches(9 downto 0) is
                        when "0000000001" =>
                                AtoBinary(6 downto 0) := std_logic_vector(unsigned(AtoBinary(6 downto 0)) + 0);
                        when "0000000010" =>
                                AtoBinary(6 downto 0) := std_logic_vector(unsigned(AtoBinary(6 downto 0)) + 10);
                        when "0000000100" =>
                                AtoBinary(6 downto 0) := std_logic_vector(unsigned(AtoBinary(6 downto 0)) + 20);
                        when "0000001000" =>
                                AtoBinary(6 downto 0) := std_logic_vector(unsigned(AtoBinary(6 downto 0)) + 30);
                        when "0000010000" =>
                                AtoBinary(6 downto 0) := std_logic_vector(unsigned(AtoBinary(6 downto 0)) + 40);
                        when "0000100000" =>
                                AtoBinary(6 downto 0) := std_logic_vector(unsigned(AtoBinary(6 downto 0)) + 50);
                        when "0001000000" =>
                                AtoBinary(6 downto 0) := std_logic_vector(unsigned(AtoBinary(6 downto 0)) + 60);
                        when "0010000000" =>
                                AtoBinary(6 downto 0) := std_logic_vector(unsigned(AtoBinary(6 downto 0)) + 70);
                        when "0100000000" =>
                                AtoBinary(6 downto 0) := std_logic_vector(unsigned(AtoBinary(6 downto 0)) + 80);
                            --dont use others for accidental inputs for more switches on
                        when others =>
                                AtoBinary(6 downto 0) := std_logic_vector(unsigned(AtoBinary(6 downto 0)) + 90);
                    end case;
                CurrentInputStateA <= ones;
                end if;
            end if;
            --for digits
            if(CurrentInputStateA = ones) then
                if(ConfirmInput = '1') then
                    case Switches(9 downto 0) is
                        when "0000000001" =>
                                AtoBinary(6 downto 0) := std_logic_vector(unsigned(AtoBinary(6 downto 0)) + 0);
                        when "0000000010" =>
                                AtoBinary(6 downto 0) := std_logic_vector(unsigned(AtoBinary(6 downto 0)) + 1);
                        when "0000000100" =>
                                AtoBinary(6 downto 0) := std_logic_vector(unsigned(AtoBinary(6 downto 0)) + 2);
                        when "0000001000" =>
                                AtoBinary(6 downto 0) := std_logic_vector(unsigned(AtoBinary(6 downto 0)) + 3);
                        when "0000010000" =>
                                AtoBinary(6 downto 0) := std_logic_vector(unsigned(AtoBinary(6 downto 0)) + 4);
                        when "0000100000" =>
                                AtoBinary(6 downto 0) := std_logic_vector(unsigned(AtoBinary(6 downto 0)) + 5);
                        when "0001000000" =>     
                                AtoBinary(6 downto 0) := std_logic_vector(unsigned(AtoBinary(6 downto 0)) + 6);
                        when "0010000000" =>
                                AtoBinary(6 downto 0) := std_logic_vector(unsigned(AtoBinary(6 downto 0)) + 7);
                        when "0100000000" =>       
                                AtoBinary(6 downto 0) := std_logic_vector(unsigned(AtoBinary(6 downto 0)) + 8);
                        when others =>   
                                AtoBinary(6 downto 0) := std_logic_vector(unsigned(AtoBinary(6 downto 0)) + 9);
                    end case;
                end if;
            end if;
        input1 <= AtoBinary;
        
        when state2 =>
        --state 2
        CurrentInputStateB <= hundreds;
        BtoBinary := "00000000";
        -- 00 addition, 01 subtraction, 10 multiplication, 11 division
            if(ConfirmInput = '1') then
                case Switches(3 downto 0) is
                    when "0001" =>
                            Operation <= "00";
                    when "0010" =>
                            Operation <= "01";
                    when "0100" => 
                            Operation <= "10";
                    when others =>                         
                            Operation <= "11";
                end case;
            end if;
    -- selection of second input
      
            when state3 =>
            -- sign bit
                if(Switches(10) = '0') then
                    BtoBinary(7) := '0';
                else
                    BtoBinary(7) := '1';
                end if;
            -- checking if the hundreds digit is 1 (limit is 127 for 8 bits)       
                if(CurrentInputStateB = hundreds) then
                    if(ConfirmInput = '1') then        
                        if(Switches(1) = '1') then
                                BtoBinary(6 downto 0) := "1100100";
                        else
                                BtoBinary(6 downto 0) :="0000000";
                        end if;
                    CurrentInputStateB <= tens;
                    end if;
                end if;
            -- for tens
            if(CurrentInputStateB = tens) then
                if(ConfirmInput = '1') then  
                    case Switches(9 downto 0) is
                        when "0000000001" =>
                                BtoBinary(6 downto 0) := std_logic_vector(unsigned(BtoBinary(6 downto 0)) + 0);
                        when "0000000010" =>
                                BtoBinary(6 downto 0) := std_logic_vector(unsigned(BtoBinary(6 downto 0)) + 10);
                        when "0000000100" =>
                                BtoBinary(6 downto 0) := std_logic_vector(unsigned(BtoBinary(6 downto 0)) + 20);
                        when "0000001000" =>
                                BtoBinary(6 downto 0) := std_logic_vector(unsigned(BtoBinary(6 downto 0)) + 30); 
                        when "0000010000" =>
                                BtoBinary(6 downto 0) := std_logic_vector(unsigned(BtoBinary(6 downto 0)) + 40);
                        when "0000100000" =>
                                BtoBinary(6 downto 0) := std_logic_vector(unsigned(BtoBinary(6 downto 0)) + 50);
                        when "0001000000" =>
                                BtoBinary(6 downto 0) := std_logic_vector(unsigned(BtoBinary(6 downto 0)) + 60);
                        when "0010000000" =>
                                BtoBinary(6 downto 0) := std_logic_vector(unsigned(BtoBinary(6 downto 0)) + 70);
                        when "0100000000" =>
                                BtoBinary(6 downto 0) := std_logic_vector(unsigned(BtoBinary(6 downto 0)) + 80);
                        when others =>
                                BtoBinary(6 downto 0) := std_logic_vector(unsigned(BtoBinary(6 downto 0)) + 90);
                    end case;
                CurrentInputStateB <= ones;
                end if;
            end if;
            --for digits
            if(CurrentInputStateB = ones) then
                if(ConfirmInput = '1') then
                    case Switches(9 downto 0) is
                        when "0000000001" =>
                                BtoBinary(6 downto 0) := std_logic_vector(unsigned(BtoBinary(6 downto 0)) + 0);
                        when "0000000010" =>
                                BtoBinary(6 downto 0) := std_logic_vector(unsigned(BtoBinary(6 downto 0)) + 1);
                        when "0000000100" =>
                                BtoBinary(6 downto 0) := std_logic_vector(unsigned(BtoBinary(6 downto 0)) + 2);
                        when "0000001000" =>       
                                BtoBinary(6 downto 0) := std_logic_vector(unsigned(BtoBinary(6 downto 0)) + 3);
                        when "0000010000" =>
                                BtoBinary(6 downto 0) := std_logic_vector(unsigned(BtoBinary(6 downto 0)) + 4);
                        when "0000100000" =>
                                BtoBinary(6 downto 0) := std_logic_vector(unsigned(BtoBinary(6 downto 0)) + 5);
                        when "0001000000" =>
                                BtoBinary(6 downto 0) := std_logic_vector(unsigned(BtoBinary(6 downto 0)) + 6);
                        when "0010000000" =>
                                BtoBinary(6 downto 0) := std_logic_vector(unsigned(BtoBinary(6 downto 0)) + 7);
                        when "0100000000" =>
                                BtoBinary(6 downto 0) := std_logic_vector(unsigned(BtoBinary(6 downto 0)) + 8);
                        when others =>
                                BtoBinary(6 downto 0) := std_logic_vector(unsigned(BtoBinary(6 downto 0)) + 9);
                    end case;
                end if;
            end if;
            input2 <= BtoBinary;
        
        when state4 =>
        --result display
            case operation is
            when "00" =>
                DDInput(6 downto 0) <= AddSubRes(6 downto 0);
                AddSign <= AddSubRes(7);
                IntResult <= AddSubRes;
    
            when "01" =>
                DDInput(6 downto 0) <= AddSubRes(6 downto 0);
                AddSign <= AddSubRes(7);
                IntResult <= AddSubRes;
            when "10" =>
                 DDInput <= MulResult(13 downto 0);
                 MulSign <= MulResult(14);
                -- limitation of eight bits
                IntResult <= MulResult(7 downto 0);
            when "11" =>
                DDInput(6 downto 0) <= DivResult(6 downto 0);
                DivSign <= DivResult(7);
                IntResult <= DivResult;
            when others => null;
            end case;
            PaddedDDInput <= "00" & DDInput;
         -- others = state 5
        when others =>   
                input1 <= IntResult;
        end case;
        -- stores result as first operand so we can use it to operate
        -- until reset is activated
        
    end if;    
    end process INPUTPROCESS;
    
    statechecker: process(CurrentState)
    begin
        case CurrentState is
            when state1 => StateLED <= "00001";
            when state2 => StateLED <= "00010";
            when state3 => StateLED <= "00100";
            when state4 => StateLED <= "01000";
            when others => StateLED <= "10000";
        
        end case;
    end process; 
        Divide : divider
            port map(a => input1, b => input2, p => DivResult);
        
        NegativeDetectionA : NegativeDetector
            port map (
                ANeg => input1, RES => ANegDetector, Clock => Clock);
        NegativeDetectionB : NegativeDetector
            port map (
                ANeg => input2, RES => BNegDetector, Clock => Clock);
        AddSub : eightBitFULLADDER
            port map(
                A => ANegDetector,
                B => BNegDetector,
                S => AddSubRes);
        Mul : EightBitMultiplier
            port map(
                    IN1 => input1,
                    IN2 => input2, 
                    PRODUCT => MulResult);
        confDeb : Debouncer
            port map(Clk => Clock,
                     btn => Confirm1,
                     en => Confirm);
                    
         confInpDeb : Debouncer
            port map(Clk => Clock,
                     btn => ConfirmInput1,
                     en => ConfirmInput);
         
          ResetDeb : Debouncer
            port map(btn => Reset1,
                     clk => Clock,
                     en => Reset);
        
        
        doubleD : binary_bcd
            port map(
                    CLK => Clock,
                    RESET => Reset,
                    binary_in => PaddedDDInput,
                    bcd0 => signalFirstDigit, 
                    bcd1 => signalSecondDigit, 
                    bcd2 => signalThirdDigit,
                    bcd3 => signalFourthDigit,
                    bcd4 => signalFifthDigit);
                    
        toSSD1 : BCDtoSSD
            port map(BCDin => signalFirstDigit,
                    Seven_Segment => ssdFirstDigit);
        toSSD2 : BCDtoSSD
            port map(BCDin => signalSecondDigit,
                    Seven_Segment => ssdSecondDigit);
        toSSD3 : BCDtoSSD
            port map(BCDin => signalThirdDigit,
                    Seven_Segment => ssdThirdDigit);
        toSSD4 : BCDtoSSD
            port map(BCDin => signalFourthDigit,
                    Seven_Segment => ssdFourthDigit);
        toSSD5 : BCDtoSSD
            port map(BCDin => signalFifthDigit,
                    Seven_Segment => ssdFifthDigit);
        CLKDIVIDER : ClkDiv
            port map(
                     Clk => Clock,
                     OutClk => DivClk);
        
        AnodeLoops: AnodeLoop   
            port map(Clk => DivClk, 
                     Reset => Reset, 
                     Anodes(0) => NotAnod(7),
                     Anodes(1) => NotAnod(6),
                     Anodes(2) => NotAnod(5),
                     Anodes(3) => NotAnod(4),
                     Anodes(4) => NotAnod(3),
                     Anodes(5) => NotAnod(2),
                     Anodes(6) => NotAnod(1),
                     Anodes(7) => NotAnod(0),
                     AnodeBCD => Sel);      
SSDPRINT: process(Clock, Reset)
begin
    Anod <= not NotAnod;
    Case Sel is 
        when "000" =>
             SSDOutput <= ssdFirstDigit;
        when "001" => 
             SSDOutput <= ssdSecondDigit;
        when "010" =>
             SSDOutput <= ssdThirdDigit;
        when "011" =>
             SSDOutput <= ssdFourthDigit;
        when "100" =>
             SSDOutput <= ssdFifthDigit;
        when others => SSDOutput <= (others => '1');
    end case;       
end process SSDPRINT;

inputstate: process(CurrentInputStateA, CurrentInputStateB)
begin
    case CurrentInputStateA is
        when hundreds =>
            StateA <= "100";
        when tens =>
            StateA <= "010";
        when others =>
            StateA <= "001";
    end case;
    case CurrentInputStateB is
        when hundreds =>
            StateB <= "100";
        when tens =>
            StateB <= "010";
        when others =>
            StateB <= "001";
   end case;

end process;

end Behavioral;
