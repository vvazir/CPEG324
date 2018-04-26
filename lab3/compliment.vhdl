library ieee;
use ieee.std_logic_1164.all;

entity compliment is
port(
    input:      in  std_logic_vector(7 downto 0);
    output:    out  std_logic_vector(7 downto 0)
);
end compliment;

architecture structural of compliment is

component flip is
generic (
	width	: integer := 8
);
port(	
		in1 : in std_logic_vector(width-1 downto 0);
		out1 : out std_logic_vector(width-1 downto 0)
);
end component;

component eightbitadder is
    Port ( 
        A :         in  STD_LOGIC_VECTOR (7 downto 0);
        B :         in  STD_LOGIC_VECTOR (7 downto 0);
        Cin :       in std_logic;
        Sum :       out  STD_LOGIC_VECTOR (7 downto 0);
        CarryOut :  out  STD_LOGIC;
        UnderFlow:  out  STD_LOGIC);
end component;

--signals
signal  flipToAdd:      STD_LOGIC_VECTOR (7 downto 0);
signal  one:            STD_LOGIC_VECTOR (7 downto 0):="00000001";

begin

inst_flip: 
   flip             port map(input,flipToAdd);
inst_adder: 
    eightbitadder   port map(flipToAdd,one,'0',output);

end structural;

