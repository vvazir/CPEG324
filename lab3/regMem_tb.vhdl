library ieee;
use ieee.std_logic_1164.all;

--  A testbench has no ports.
entity regMem_tb is
end regMem_tb;

architecture behav of regMem_tb is
--  Declaration of the component that will be instantiated.
component regMem
port (	reg1: 		in std_logic_vector(1 downto 0);
		reg2:       in std_logic_vector(1 downto 0);
		dstReg:		in std_logic_vector(1 downto 0);
		
		writeEn:	in std_logic;
		writeData:	in std_logic_vector(7 downto 0);
		clock:		in std_logic;
		
		reg1Data:	out std_logic_vector(7 downto 0);
		reg2Data:	out std_logic_vector(7 downto 0)		
);
end component;

--  Specifies which entity is bound with the component.
-- for shift_reg_0: shift_reg use entity work.shift_reg(rtl);

signal reg1,reg2,dstReg : std_logic_vector(1 downto 0);
signal writeEn,clock : std_logic;
signal writeData,reg1Data,reg2Data : std_logic_vector(7 downto 0);

begin
--  Component instantiation.
R1 : regMem
	port map(
		reg1=>reg1,
		reg2=>reg2,
		dstReg=>dstReg,
		writeEn=>writeEn,
		writeData=>writeData,
		clock=>clock,
		reg1Data=>reg1Data,
		reg2Data=>reg2Data
	);
	
--  This process does the real job.
process

type pattern_type is record
reg1: std_logic_vector(1 downto 0);
reg2: std_logic_vector(1 downto 0);
dstReg : std_logic_vector(1 downto 0);
writeEn: std_logic;
clock : std_logic;
writeData: std_logic_vector(7 downto 0);
reg1Data: std_logic_vector(7 downto 0);
reg2Data : std_logic_vector(7 downto 0);

end record;
--  The patterns to apply.
type pattern_array is array (natural range <>) of pattern_type;
constant patterns : pattern_array :=
(
("00","01","10",'0','0',"00000000","00000000","00000000"),
("00","01","10",'0','1',"00000000","00000000","00000000"),

("00","01","10",'0','0',"00000000","00000000","00000000"),
("00","01","10",'0','1',"00001000","00000000","00000000"),

("00","01","10",'1','0',"00001000","00000000","00000000"),
("10","01","10",'0','1',"00000000","00001000","00000000")

);
begin
--  Check each pattern.
for n in patterns'range loop
--  Set the inputs.
reg1 <= patterns(n).reg1;
reg2 <= patterns(n).reg2;
dstReg <= patterns(n).dstReg;

clock <= patterns(n).clock;
writeEn <= patterns(n).writeEn;
writeData <= patterns(n).writeData;


--  Wait for the results.
wait for 1 ns;
--  Check the outputs.
assert reg1Data = patterns(n).reg1Data
report "Reg 1 is wrong" severity error;
assert reg2Data = patterns(n).reg2Data
report "Reg 2 is wrong" severity error;

end loop;
assert false report "end of test" severity note;
--  Wait forever; this will finish the simulation.
wait;
end process;
end behav;
