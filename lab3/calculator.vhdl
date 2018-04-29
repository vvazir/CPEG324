library ieee;
use ieee.std_logic_1164.all;

--entity declaration

entity calculator is
port(
    OpCode:     in      std_logic_vector(7 downto 0);
    DataOut:    out     std_logic_vector(7 downto 0);
    DispEn:     out     std_logic;
    clk:        in      std_logic);
end calculator;

architecture structural of calculator is

--components: control, mux, register, shift register, adder, sign extend, 2s compliment

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

--regmem
component regMem is
port(
		reg1: 		in std_logic_vector(1 downto 0);
		reg2:       in std_logic_vector(1 downto 0);
		dstReg:		in std_logic_vector(1 downto 0);
		
		writeEn:	in std_logic;
		writeData:	in std_logic_vector(7 downto 0);
		clock:		in std_logic;
		
		reg1Data:	out std_logic_vector(7 downto 0):= (others =>'0');
		reg2Data:	out std_logic_vector(7 downto 0):= (others =>'0')		
);
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

--compliment
component compliment is
port(
    input:      in  std_logic_vector(7 downto 0);
    output:    out  std_logic_vector(7 downto 0)
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


--SIGNALS
--clock
signal clkSig:          std_logic;

--control signals

signal  controlSig:     std_logic_vector(6 downto 0);
signal  regDataSigOne:  std_logic_vector(7 downto 0);
signal  regDataSigTwo:  std_logic_vector(7 downto 0);
signal  twosCompSig:    std_logic_vector(7 downto 0);

--mux signals

signal  skipMuxSig:        std_logic;
signal  compMuxSig:        std_logic;
signal  immMuxSig:         std_logic_vector(7 downto 0);
signal  lodMuxSig:         std_logic_vector(7 downto 0);
signal  twosMuxSig:        std_logic_vector(7 downto 0);

--ALU signals

signal  aluSig:         std_logic_vector(7 downto 0);

--skip signal

signal  skipShiftToControlSig:   std_logic;

--zerocheck out signal

signal  zeroSig:            std_logic;

--signExtend

signal  signExtendSig:      std_logic_vector(7 downto 0);

--parsing input
signal  op0:            std_logic := OpCode(0);
signal  op1:            std_logic := OpCode(1);
signal  op6:            std_logic := OpCode(6);
signal  op7:            std_logic := OpCode(7);
signal  r1:             std_logic_vector(1 downto 0) := OpCode(1 downto 0);
signal  r2:             std_logic_vector(1 downto 0) := OpCode(3 downto 2);
signal  rd:             std_logic_vector(1 downto 0) := OpCode(5 downto 4);
signal imm:             std_logic_vector(1 downto 0) := OpCode(3 downto 0);

--output signals
signal  dispEn:         std_logic;
signal  dataOut:        std_logic_vector(7 downto 0);

begin

--instantiation

controlMain:    control         port map();
skipMux:        mux             generic map('1');
                                port map(compMuxSig,'0',skipMuxSig);
compMux:        mux             generic map('1');
                                port map('0',zeroSig,compMuxSig);
immMux:         mux             generic map();
                                port map();
lodMux:         mux             generic map();
                                port map();
twosMux:        mux             generic map();
                                port map();
twosComp:       compliment      port map();
regMem0:        regMem          port map(r1,r2,rd,controlSig(0),aluSig,clkSig,regDataSigOne,regDataSigTwo);
ALU:            eightbitadder   port map(lodMuxSig,immMuxSig,'0',aluSig);
zeroCheck0:     zeroCheck       port map(aluSig,zeroSig);
reg0:           reg             port map();
sreg0           shift_reg       port map();
signExt:        sign_extend     port map();
