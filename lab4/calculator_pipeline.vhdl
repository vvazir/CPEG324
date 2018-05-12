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

architecture beh of calculator is

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
		reg2Data:	out std_logic_vector(7 downto 0):= (others =>'0');
        rdData:	    out std_logic_vector(7 downto 0):= (others =>'0')
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
    output:     out std_logic_vector(0 downto 0)
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
		I_SHIFT_IN: in std_logic; -- "opone"
		sel:        in std_logic_vector(0 downto 0); -- 0:Shift right; 1: "load"
		clock:		in std_logic; -- positive level triggering in problem 3
		O:			out std_logic --"skip"
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
--clk

--control signals

signal  controlSig:     std_logic_vector(6 downto 0);
signal 	cregmem:		std_logic;
signal 	ctwosum:		std_logic;
signal 	cimmmux:		std_logic;
signal 	ccompmux:		std_logic;
signal 	cDispEn:		std_logic;
signal 	cskipmux:		std_logic;
signal 	clodmux:		std_logic;

--0 controller,regmem
--1 controller, twosmux
--2 controller, immmux
--3 controller, compmux
--4 controller, DispEn
--5 controller, skipMux
--6 controller, lodmux

signal  regDataSigOne:  std_logic_vector(7 downto 0);
-- regmem, lodmux
signal  regDataSigTwo:  std_logic_vector(7 downto 0);
-- regmem, [twoscomp,twosmux]
signal  twosCompSig:    std_logic_vector(7 downto 0);
--twoscompliment,twosmux


--mux signals
signal  regSelMuxSig:        std_logic_vector(7 downto 0);
--
signal  skipMuxSig:        std_logic_vector(0 downto 0);
--skipmux,shiftreg
signal  compMuxSig:        std_logic_vector(0 downto 0);
--compmux,skipmux
signal  immMuxSig:         std_logic_vector(7 downto 0);
--immmux,alu
signal  lodMuxSig:         std_logic_vector(7 downto 0);
--lodMux,alu
signal  twosMuxSig:        std_logic_vector(7 downto 0);
--twosmux,immmux



--ALU signals

signal  aluSig:         std_logic_vector(7 downto 0);
--alu,[regmem/zerocheck]


--skip signal

signal  skipShiftToControlSig:   std_logic;
--shiftreg, controller


--zerocheck out signal

signal  zeroSig:            std_logic_vector(0 downto 0);
--alu,zeroCheck


--signExtend

signal  signExtendSig:      std_logic_vector(7 downto 0);
--signext,immmux


--parsing input
signal  op0:            std_logic := OpCode(0);
signal  op1:            std_logic := OpCode(1);
signal  op6:            std_logic := OpCode(6);
signal  op7:            std_logic := OpCode(7);
signal  r1:             std_logic_vector(1 downto 0) := OpCode(1 downto 0);
signal  r2:             std_logic_vector(1 downto 0) := OpCode(3 downto 2);
signal  rd:             std_logic_vector(1 downto 0) := OpCode(5 downto 4);
signal imm:             std_logic_vector(3 downto 0) := OpCode(3 downto 0);

--output signals
signal dOutSig:         std_logic_vector(7 downto 0);


begin

process(clk)
    begin
    if (rising_edge(clk)) then

        op0 <= OpCode(0);
        op1 <= OpCode(1);
        op6 <= OpCode(6);
        op7 <= OpCode(7);
        r2 	<= OpCode(1 downto 0);
        r1 	<= OpCode(3 downto 2);
        rd 	<= OpCode(5 downto 4);
        imm <= OpCode(3 downto 0);
        
    end if;
end process;


--instantiation

--0 controller,regmem
--1 controller, twosmux
--2 controller, immmux
--3 controller, compmux
--4 controller, DispEn
--5 controller, skipMux
--6 controller, lodmux
-- 0/1
controlMain:    control         port map(op0,op1,skipShiftToControlSig,op6,op7,
cregmem,ctwosum,cimmmux,ccompmux,cdispen,cskipmux,clodmux);
regSelMux:      mux             generic map(width => 8)
                                port map(dOutSig,regDataSigTwo,regSelMuxSig,ccompmux);
skipMux:        mux             generic map(width => 1)
                                port map(compMuxSig,"0",skipMuxSig,cskipmux);
compMux:        mux             generic map(width => 1)
                                port map(zeroSig,"0",compMuxSig,ccompmux);
immMux:         mux             generic map(width => 8)
                                port map(signExtendSig,twosMuxSig,immMuxSig,cimmmux);
lodMux:         mux             generic map(width => 8)
                                port map("00000000",regDataSigOne,lodMuxSig,clodmux);
twosMux:        mux             generic map(width => 8)
                                port map(twosCompSig,regDataSigTwo,twosMuxSig,ctwosum);
twosComp:       compliment      port map(regSelMuxSig,twosCompSig);
regMem0:        regMem          port map(r1,r2,rd,cregmem,aluSig,clkSig,regDataSigOne,regDataSigTwo,dOutSig);
ALU:            eightbitadder   port map(lodMuxSig,immMuxSig,'0',aluSig);
zeroCheck0:     zeroCheck       port map(aluSig,zeroSig);
sreg0:          shift_reg       port map(op1,skipMuxSig,clkSig,skipShiftToControlSig);
signExt:        sign_extend     port map(imm,signExtendSig);
istageEXEWB:    reg             generic map(width => 24)
                                port map();
istageIDEXE:    reg             generic map(width => 24)
                                port map();


DispEn <= cdispen;
clkSig <= clk;
DataOut <= dOutSig;

end beh;