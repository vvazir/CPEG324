LIBRARY ieee;
USE ieee.std_logic_1164.all;

entity eightBitAdder_tb2 is
end eightBitAdder_tb2;

architecture behavior of eightbitadder_tb2 is

component eightbitadder
    Port ( 
        A :         in  STD_LOGIC_VECTOR (7 downto 0);
        B :         in  STD_LOGIC_VECTOR (7 downto 0);
        Cin :       in std_logic;
        Sum :       out  STD_LOGIC_VECTOR (7 downto 0);
        CarryOut :  out  STD_LOGIC;
        UnderFlow:  out  STD_LOGIC);
end component;

--inputs
signal A:         std_logic_vector(7 downto 0);
signal B:         std_logic_vector(7 downto 0);
signal Cin:     std_logic:='0';

--outputs
signal Sum: std_logic_vector(7 downto 0);
 
 signal CarryOut:   std_logic;
 signal UnderFlow:         std_logic;
 
 begin
 
 UUT: eightbitadder port map (A=>A, B=>B, Cin=>Cin, Sum=>Sum,CarryOut=>CarryOut, UnderFlow=>UnderFlow);

--stimulus
process
    begin
    wait for 10 ns;
    A<="11111111";
    B<="00000000";
    wait for 100 ns;    

    wait for 10 ns;
    A<="00001111";
    B<="00000000";
    wait for 100 ns;    

    wait for 10 ns;
    A<="00010000";
    B<="00010000";
    wait for 100 ns;    

    wait for 10 ns;
    A<="10000000";
    B<="10000000";
    wait for 100 ns;    


    wait;
    end process;
    
end behavior;