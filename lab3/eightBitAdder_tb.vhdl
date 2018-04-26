LIBRARY ieee;
USE ieee.std_logic_1164.all;

entity eightBitAdder_tb is
end eightBitAdder_tb;

architecture behavior of eightbitadder_tb is

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
    
    wait for 100 ns;
    
    
    A <= "00000000";
    B <= "00000001";
    Cin <= '0';
    wait for 100 ns;
    
    --sum should be 0001
    --carryout/overflow: 0
    --underflow:0
    
    A <= "00000001";
    wait for 100 ns;
    
    --sum should be 0010
    
    B <= "00000010";
    wait for 100 ns;
    
    --sum should be 0011
    
    A <= "00000010";
    wait for 100 ns;
    
    --sum should be 0100
    
    B <= "00000011";
    wait for 100 ns;
    
    --sum should be 0101
    
    A <= "00000011";
    wait for 100 ns;
    
    --sum should be 0110
    
    B <= "00000100";
    wait for 100 ns;
    
    --sum should be 0111
    
    A <= "00000100";
    wait for 100 ns;
    
    --sum should be 1000
    
    B <= "00000101";
    wait for 100 ns;
    
    --sum should be 1001
    
    A <= "00000101";
    wait for 100 ns;
    
    --sum should be 1010
    
    B <= "00000110";
    wait for 100 ns;
    
    --sum should be 1011
    
    A <= "00000110";
    wait for 100 ns;
    
    --sum should be 1100
    
    B <= "00000111";
    wait for 100 ns;
    
    --sum should be 1101
    
    A <= "00000111";
    wait for 100 ns;
    
    --sum should be 1110
    
    B <= "00001000";
    wait for 100 ns;
    
    --sum should be 1111
    
    A <= "00001000";
    wait for 100 ns;
    
    --sum should be 
    
    B <= "00001001";
    wait for 100 ns;
    
    --sum should be 

    A <= "00001001";
    wait for 100 ns;
    
    --sum should be 
    
    B <= "00001010";
    wait for 100 ns;
    
    --sum should be 

    A <= "00001010";
    wait for 100 ns;
    
    --sum should be 
    
    B <= "00001011";
    wait for 100 ns;
    
    --sum should be 

    A <= "00001011";
    wait for 100 ns;
    
    --sum should be 
    
    B <= "00001100";
    wait for 100 ns;
    
    --sum should be 

    A <= "00001100";
    wait for 100 ns;
    
    --sum should be 
    
    B <= "00001101";
    wait for 100 ns;
    
    --sum should be 

    A <= "00001101";
    wait for 100 ns;
    
    --sum should be 
    
    B <= "00001110";
    wait for 100 ns;
    
    --sum should be 

    A <= "00001110";
    wait for 100 ns;
    
    --sum should be 
    
    B <= "00001111";
    wait for 100 ns;
    
    --sum should be 

    A <= "00001111";
    wait for 100 ns;
    
    --sum should be 


    wait;

    
    end process;
    
end behavior;