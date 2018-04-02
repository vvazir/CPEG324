LIBRARY ieee;
USE ieee.std_logic_1164.all;

entity ADDSUB_tb is
end ADDSUB_tb;

architecture behavior of ADDSUB_tb is

component ADDSUB
    Port ( 
        A :         in  STD_LOGIC_VECTOR (3 downto 0);
        B :         in  STD_LOGIC_VECTOR (3 downto 0);
        Cin :       in std_logic;
        Sum :       out  STD_LOGIC_VECTOR (3 downto 0);
        CarryOut :  out  STD_LOGIC;
        UnderFlow:  out  STD_LOGIC);
end component;

--inputs
signal A:         std_logic_vector(3 downto 0);
signal B:         std_logic_vector(3 downto 0);
signal Cin:     std_logic;

--outputs
 signal S0:        std_logic;
 signal S1:        std_logic;
 signal S2:        std_logic;
 signal S3:        std_logic;
 signal CarryOut:   std_logic;
 signal UnderFlow:         std_logic;
 
 begin
 
 UUT: ADDSUB port map (A=>A, B=>B, Cin=>Cin, Sum(0)=>S0,Sum(1)=>S1,Sum(2)=>S2,Sum(3)=>S3, CarryOut=>CarryOut, UnderFlow=>UnderFlow);

--stimulus
process
    begin
    
    wait for 100 ns;
    
    
    A <= "0000";
    B <= "0001";
    Cin <= '0';
    wait for 100 ns;
    
    --sum should be 0001
    --carryout/overflow: 0
    --underflow:0
    
    A <= "0001";
    wait for 100 ns;
    
    --sum should be 0010
    
    B <= "0010";
    wait for 100 ns;
    
    --sum should be 0011
    
    A <= "0010";
    wait for 100 ns;
    
    --sum should be 0100
    
    B <= "0011";
    wait for 100 ns;
    
    --sum should be 0101
    
    A <= "0011";
    wait for 100 ns;
    
    --sum should be 0110
    
    B <= "0100";
    wait for 100 ns;
    
    --sum should be 0111
    
    A <= "0100";
    wait for 100 ns;
    
    --sum should be 1000
    
    B <= "0101";
    wait for 100 ns;
    
    --sum should be 1001
    
    A <= "0101";
    wait for 100 ns;
    
    --sum should be 1010
    
    B <= "0110";
    wait for 100 ns;
    
    --sum should be 1011
    
    A <= "0110";
    wait for 100 ns;
    
    --sum should be 1100
    
    B <= "0111";
    wait for 100 ns;
    
    --sum should be 1101
    
    A <= "0111";
    wait for 100 ns;
    
    --sum should be 1110
    
    B <= "1000";
    wait for 100 ns;
    
    --sum should be 1111
    
    A <= "1000";
    wait for 100 ns;
    
    --sum should be 
    
    B <= "1001";
    wait for 100 ns;
    
    --sum should be 

    A <= "1001";
    wait for 100 ns;
    
    --sum should be 
    
    B <= "1010";
    wait for 100 ns;
    
    --sum should be 

    A <= "1010";
    wait for 100 ns;
    
    --sum should be 
    
    B <= "1011";
    wait for 100 ns;
    
    --sum should be 

    A <= "1011";
    wait for 100 ns;
    
    --sum should be 
    
    B <= "1100";
    wait for 100 ns;
    
    --sum should be 

    A <= "1100";
    wait for 100 ns;
    
    --sum should be 
    
    B <= "1101";
    wait for 100 ns;
    
    --sum should be 

    A <= "1101";
    wait for 100 ns;
    
    --sum should be 
    
    B <= "1110";
    wait for 100 ns;
    
    --sum should be 

    A <= "1110";
    wait for 100 ns;
    
    --sum should be 
    
    B <= "1111";
    wait for 100 ns;
    
    --sum should be 

    A <= "1111";
    wait for 100 ns;
    
    --sum should be 


    wait;
    end process;
    
end behavior;