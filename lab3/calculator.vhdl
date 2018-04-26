library ieee;
use ieee.std_logic_1164.all;

--entity declaration

entity calculator is
port(
    OpCode:     in      std_logic_vector(7 downto 0);
    DataOut:    out     std_logic_vector(7 downto 0);
    DispEn:     out     std_logic
);
end calculator;

architecture structural of calculator is

--components: control, mux, register, shift register, adder, sign extend, 2s compliment, flip.

--control
component control is
 port(
        OP_0:       in  std_logic;
        OP_1:       in  std_logic;
        SKIP:       in  std_logic;
        OP_6:       in  std_logic;
        OP_7:       in  std_logic;
		
        WRITE_EN:   out std_logic;
        TWO_EN:     out std_logic;
        IMM_EN:     out std_logic;
        CMP_EN:     out std_logic;
        DISP_EN:    out std_logic;
        SKP_PASS:   out std_logic;
        LOD:        out std_logic);

end component;

--mux
component mux is
generic (
	width	: integer := 8
);
port(	
		in1 : in std_logic_vector(width-1 downto 0);
		in2 : in std_logic_vector(width-1 downto 0);
		out1 : out std_logic_vector(width-1 downto 0);
		sel : in std_logic
);
end component;

--flip
component flip is
generic (
	width	: integer := 8
);
port(	
		in1 : in std_logic_vector(width-1 downto 0);
		out1 : out std_logic_vector(width-1 downto 0)
);
end component;

--adder
component eightbitadder is
    Port ( 
        A :         in  STD_LOGIC_VECTOR (7 downto 0);
        B :         in  STD_LOGIC_VECTOR (7 downto 0);
        Cin :       in std_logic;
        Sum :       out  STD_LOGIC_VECTOR (7 downto 0);
        CarryOut :  out  STD_LOGIC;
        UnderFlow:  out  STD_LOGIC);
end component;

--zeroCheck
component zeroCheck is
port(
    input:      in std_logic_vector(7 downto 0);
    output:     out std_logic
);
end component;

--sign extend
component sign_extend is 
    port(
        input:        in  std_logic_vector(3 downto 0);
        output:       out std_logic_vector(7 downto 0)
        );
end component;

--shift reg
component shift_reg is
port(
		I_SHIFT_IN: in std_logic;
		sel:        in std_logic; -- 0:Shift right; 1: load
		clock:		in std_logic; -- positive level triggering in problem 3
		O:			out std_logic
);
end component;

--reg
component reg is
generic (
	width : integer := 8
);
port(
	din : in std_logic_vector(width-1 downto 0);
	dout : out std_logic_vector(width-1 downto 0):= (others =>'0');
	clock : in std_logic
);
end component;


-SIGNAL

-control signals

signal  writeEnSig          :
signal  twosComplimentSig   :
signal  immEnSig            :
signal  compSig             :
signal  dispSig             :
signal  skipPassSig         :
signal  lodEnSig            :

signal 