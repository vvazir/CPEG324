library ieee;
use ieee.std_logic_1164.all;

--entity declaration

entity calculator is
port(
    OpCode:     in      std_logic_vector(7 downto 0);
    DataOut:    out     std_logic_vector(7 downto 0);
    -- Only display when its not a nop signal
    DispEn:     out     std_logic;
    -- On a compare, display how much to skip by
    BREN:       out     std_logic;
    -- How many cycles are skipped, 0 for 1 cycle and 1 for 2 cycles
    Bre:        out     std_logic;
    NOP:        out     std_logic;
    clk:        in      std_logic);
end calculator;

architecture beh of calculator is

--components: control, mux, register, shift register, adder, sign extend, 2s compliment

--control
component control is
 port(
        OP_0:       in  std_logic:='1';
        OP_1:       in  std_logic:='1';
        OP_2:       in  std_logic;
        OP_3:       in  std_logic;
        OP_4:       in  std_logic;
        OP_5:       in  std_logic;
        OP_6:       in  std_logic:='1';
        OP_7:       in  std_logic:='1';
        SKIP:       in  std_logic;
        clk:        in  std_logic;
        -- Data forwarding
        INP_1:      out std_logic;
        INP_2:      out std_logic;
        DSP_F:      out std_logic;
        -- Branch control for display output
        BRE:      out std_logic;
        BREAMT:   out std_logic;
        -- NOP INS
        NOP:      out std_logic;
        -- Control signals
        WRITE_EN:   out std_logic;
        TWO_EN:     out std_logic;
        IMM_EN:     out std_logic;
        CMPB_EN:    out std_logic;
        CMPA_EN:    out std_logic;
        DISP_EN:    out std_logic;
        SKP_PASS:   out std_logic;
        SKP_EN:     out std_logic;
        LOD:        out std_logic;
        RD:         out std_logic_vector(1 downto 0));

end component;

--regmem
component regMem is
port(
		reg1: 		in std_logic_vector(1 downto 0);
		reg2:       in std_logic_vector(1 downto 0);
		dstReg:		in std_logic_vector(1 downto 0);
        writeBack:	in std_logic_vector(1 downto 0);
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

signal  signExtendSig:      std_logic_vector(7 downto 0):= (others =>'0');
--signext,immmux

--interstage register ins
signal ISRegIDEXEin:    std_logic_vector(27 downto 0):= (others =>'0');
signal ISRegEXEWBin:    std_logic_vector(16 downto 0):= (others =>'0');

signal  ISRegIDEXESigOut:    std_logic_vector(27 downto 0):= (others =>'0');
signal  ISRegEXEWBSigOut:    std_logic_vector(16 downto 0):= (others =>'0');

--interstage register outs
--idexe
signal  ISRegIDEXESigDOut:   std_logic_vector(7 downto 0):= (others =>'0');
signal  ISRegIDEXESigOne:    std_logic_vector(7 downto 0):= (others =>'0');
signal  ISRegIDEXESigTwo:    std_logic_vector(7 downto 0):= (others =>'0');
signal  ISRegIDEXESigImm:    std_logic_vector(3 downto 0):= (others =>'0');



--exeWb
signal  ISRegEXEWBSigALU:     std_logic_vector(7 downto 0):= (others =>'0');
signal  ISRegEXEWBSigDOut:    std_logic_vector(7 downto 0):= (others =>'0');
signal  ISRegEXEWBSigDZero:   std_logic_vector(0 downto 0):= (others =>'0');

--not clk
signal  notclk:         std_logic:='0';


--parsing input
signal  op0:            std_logic := OpCode(0);
signal  op1:            std_logic := OpCode(1);
signal  op2:            std_logic := OpCode(2);
signal  op3:            std_logic := OpCode(3);
signal  op4:            std_logic := OpCode(4);
signal  op5:            std_logic := OpCode(5);
signal  op6:            std_logic := OpCode(6);
signal  op7:            std_logic := OpCode(7);
signal  r1:             std_logic_vector(1 downto 0) := OpCode(1 downto 0);
signal  r2:             std_logic_vector(1 downto 0) := OpCode(3 downto 2);
signal  rd:             std_logic_vector(1 downto 0) := OpCode(5 downto 4);
signal imm:             std_logic_vector(3 downto 0) := OpCode(3 downto 0);

--output signals
signal dOutSig:         std_logic_vector(7 downto 0):= (others =>'0');

--alu select signalas
signal cAluSelAsig:      std_logic :='0';
signal cAluSelBsig:      std_logic :='0';

signal skp_sel:          std_logic :='0';
--
signal cBranchDisp:                    std_logic;

signal a:                             std_logic_vector(7 downto 0):= (others =>'0');
signal b:                             std_logic_vector(7 downto 0):= (others =>'0');

signal RDEXEWB:                       std_logic_vector(1 downto 0):= (others =>'0');
signal cNopEn:                         std_logic;
signal dsp:                           std_logic_vector(7 downto 0):= (others =>'0');
signal EXEWBRD:                       std_logic_vector(7 downto 0):= (others =>'0');
signal branchEN:                      std_logic;
signal dsp_for:                       std_logic;
signal cA:                            std_logic;
signal cBranchAmt:                          std_logic;
begin

process(clk)
    begin
    if (rising_edge(clk)) then

        op0 <= OpCode(0);
        op1 <= OpCode(1);
        op2 <= OpCode(2);
        op3 <= OpCode(3);
        op4 <= OpCode(4);
        op5 <= OpCode(5);
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


controlMain:    control         port map(op0,op1,op2,op3,op4,op5,op6,op7,skipShiftToControlSig,clksig,cAluSelAsig,
cAluSelBsig,dsp_for,cBranchDisp,cBranchAmt,cNopEn,cregmem,ctwosum,cimmmux,ccompmux,cA,cdispen,cskipmux,clodmux,RDEXEWB);

ALU_selMuxA:   mux              generic map(width => 8)
                                port map(lodMuxSig,ISRegEXEWBSigALU,a,cAluSelAsig);
                                
ALU_selMuxB:   mux              generic map(width => 8)
                                port map(immMuxSig,ISRegEXEWBSigALU,b,cAluSelBsig);

regSelMux:      mux             generic map(width => 8)
                                port map(ISRegIDEXESigDOut,ISRegIDEXESigTwo,regSelMuxSig,ccompmux);
skipMux:        mux             generic map(width => 1)
                                port map(compMuxSig,"0",skipMuxSig,cskipmux);
compMux:        mux             generic map(width => 1)
                                port map(ISRegEXEWBSigDZero,"0",compMuxSig,cA);
immMux:         mux             generic map(width => 8)
                                port map(signExtendSig,twosMuxSig,immMuxSig,cimmmux);
lodMux:         mux             generic map(width => 8)
                                port map("00000000",ISRegIDEXESigOne,lodMuxSig,clodmux);
twosMux:        mux             generic map(width => 8)
                                port map(twosCompSig,ISRegIDEXESigTwo,twosMuxSig,ctwosum);
dispMux:        mux             generic map(width => 8)
                                port map(ISRegEXEWBSigALU,ISRegEXEWBSigDOut,dsp,cdispen);
dispForwardMux: mux             generic map(width => 8)
                                port map(ISRegIDEXESigDOut,ISRegEXEWBSigALU,EXEWBRD,dsp_for);

twosComp:       compliment      port map(regSelMuxSig,twosCompSig);

regMem0:        regMem          port map(r1,r2,rd,RDEXEWB,cregmem,ISRegEXEWBSigALU,clkSig,regDataSigOne,regDataSigTwo,dOutSig);

ALU:            eightbitadder   port map(a,b,'0',aluSig);

zeroCheck0:     zeroCheck       port map(aluSig,zeroSig);

sreg0:          shift_reg       port map(skp_sel,skipMuxSig,clkSig,skipShiftToControlSig);

signExt:        sign_extend     port map(ISRegIDEXESigImm,signExtendSig);

istageIDEXE:    reg             generic map(width => 28)
                                port map(ISRegIDEXEin,ISRegIDEXESigOut,clk);
                                
istageEXEWB:    reg             generic map(width => 17)
                                port map(ISRegEXEWBin,ISRegEXEWBSigOut,notclk);
                                

ISRegIDEXEin <= regDataSigOne&regDataSigTwo&dOutSig&imm;
ISRegEXEWBin <= aluSig&zeroSig&EXEWBRD;

ISRegIDEXESigOne <= ISRegIDEXESigOut(27 downto 20); 
ISRegIDEXESigTwo <= ISRegIDEXESigOut(19 downto 12);
ISRegIDEXESigDOut<= ISRegIDEXESigOut(11 downto 4);
ISRegIDEXESigImm <= ISRegIDEXESigOut(3 downto 0);

ISRegEXEWBSigALU <= ISRegEXEWBSigOut(16 downto 9);
ISRegEXEWBSigDZero <=ISRegEXEWBSigOut(8 downto 8);
ISRegEXEWBSigDOut <=ISRegEXEWBSigOut(7 downto 0);

notclk <= not (clk);
DispEn <= cdispen;
clkSig <= clk;
DataOut <= dsp;

bre <= cBranchAmt;
NOP <= cNopEn;
BREN <= cBranchDisp and ISRegEXEWBSigDZero(0);;

end beh;