LIBRARY ieee;
USE ieee.std_logic_1164.all;

entity ADDSUB_tb is
end ADDSUB_tb;

architecture behavior of ADDSUB_tb is

component ADDSUB
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
signal Cin:     std_logic;

--outputs
 signal S0:        std_logic;
 signal S1:        std_logic;
 signal S2:        std_logic;
 signal S3:        std_logic;
 signal S4:        std_logic;
 signal S5:        std_logic;
 signal S6:        std_logic;
 signal S7:        std_logic;
 
 signal CarryOut:   std_logic;
 signal UnderFlow:         std_logic;
 
 begin
 
 UUT: ADDSUB port map (A=>A, B=>B, Cin=>Cin, Sum(0)=>S0,Sum(1)=>S1,Sum(2)=>S2,Sum(3)=>S3, Sum(4)=>S4,Sum(5)=>S5,Sum(6)=>S6, Sum(7)=>S7,CarryOut=>CarryOut, UnderFlow=>UnderFlow);

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