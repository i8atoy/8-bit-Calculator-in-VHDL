library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity AnodeLoop is
    Port ( 
        CLK : in std_logic;
        Reset : in std_logic;
        Anodes : out std_logic_vector(0 to 7);
        AnodeBCD : out std_logic_vector(0 to 2)
    );
end AnodeLoop;

architecture Behavioral of AnodeLoop is
    signal js : std_logic_vector(0 to 2);
    signal ks : std_logic_vector(0 to 2);
    signal Os : std_logic_vector(0 to 2);
begin
    JKFF : process(CLK,Reset)
        variable Oin: std_logic_vector(0 to 2) := "000";   
        variable jk : std_logic_vector(0 to 1) := "00";
    begin
        if (Reset='1') then
            Oin := "000";
        else
            if(CLK'event) and (CLK='1') then
                for i in 0 to 2 loop
                    jk := js(i) & ks(i);
                    case jk is
                        when "00" =>
                            Oin(i):= Oin(i);
                        when "01" =>
                            Oin(i):= '0';
                        when "10" =>
                            Oin(i):= '1';
                        when "11" =>
                            Oin(i):= not Oin(i);
                        when others => null;
                    end case;
                end loop;
            end if;
        end if;
        Os <= Oin;
        AnodeBCD <= Oin;
    end process JKFF;
    
    Dec : process(Os)
        variable Ain : std_logic_vector(0 to 7);
    begin
        case Os is
            when "000" => 
                Ain:= "00000001";
            when "001" => 
                Ain:= "00000010";
            when "010" => 
                Ain:= "00000100";    
            when "011" => 
                Ain:= "00001000";
            when "100" => 
                Ain:= "00010000";
            when "101" => 
                Ain:= "00100000";
            when "110" => 
                Ain:= "01000000";
            when "111" => 
                Ain:= "10000000";              
            when others => null;
        end case;
        Anodes <= Ain;
    end process Dec;
    
    js(0) <= '1';
    ks(0) <= '1';
    js(1) <= Os(0);
    ks(1) <= Os(0);
    js(2) <= Os(0) and Os(1);
    ks(2) <= Os(0) and Os(1);

end Behavioral;