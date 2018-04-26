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
type pattern_type is record

--inputs
A:          std_logic_vector(7 downto 0);
B:          std_logic_vector(7 downto 0);

--outputs
Sum: std_logic_vector(7 downto 0); 
    
end record;
    
type pattern_array is array (natural range <>) of pattern_type;
constant patterns : pattern_array :=
(
("11111110","11111110","11111100"),
("11111110","11111110","11111100")
);

    begin
    for n in patterns'range loop
    
    A<=patterns(n).A;
    B<=patterns(n).B;
    wait for 1 ns;
    
    assert Sum = patterns(n).Sum report "Invalid sum" severity error;
    end loop;
    assert false report "end of test" severity note;
    
    wait;
    
    
    end process;
    
end behavior;