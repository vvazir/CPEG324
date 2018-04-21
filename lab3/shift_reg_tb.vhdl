library ieee;
use ieee.std_logic_1164.all;

--  A testbench has no ports.
entity shift_reg_tb is
end shift_reg_tb;

architecture behav of shift_reg_tb is
--  Declaration of the component that will be instantiated.
component shift_reg
port (	
		I_SHIFT_IN: in std_logic;
		sel:        in std_logic; -- 0:Shift right; 1: load
		clock:		in std_logic; -- positive level triggering in problem 3
		O:			out std_logic
);
end component;
--  Specifies which entity is bound with the component.
-- for shift_reg_0: shift_reg use entity work.shift_reg(rtl);
signal i1, o : std_logic;
signal sel : std_logic;
signal clock : std_logic;
begin
--  Component instantiation.
M1 : shift_reg
	port map(
		I_SHIFT_IN=>i1,
		sel=>sel,
		clock=>clock,
		o=>o
	);
--  This process does the real job.
process
type pattern_type is record
--  The inputs of the shift_reg.
i1: std_logic;
sel: std_logic;
clock: std_logic;
--  The expected outputs of the shift_reg.
o: std_logic;
end record;
--  The patterns to apply.
type pattern_array is array (natural range <>) of pattern_type;
constant patterns : pattern_array :=
(
('0','0','0','0'),	--0
('0','0','1','0'),	--1
('0','0','0','0'),	--2
('1','0','1','0'),	--3
('0','0','0','0'),	--4
-- Skip 1
('0','1','1','1'),	--5
('0','1','0','1'),	--6
-- Actually skip now 
('0','0','1','1'),	--7
('0','0','0','1'),	--8
-- Done skipping
('0','0','1','0')	--9

);
begin
--  Check each pattern.
for n in patterns'range loop
--  Set the inputs.
i1 <= patterns(n).i1;
sel <= patterns(n).sel;
clock<= patterns(n).clock;
--  Wait for the results.
wait for 1 ns;
--  Check the outputs.
assert o = patterns(n).o
report "bad output value on step n = " & integer'image(n)  severity error;
end loop;
assert false report "end of test" severity note;
--  Wait forever; this will finish the simulation.
wait;
end process;
end behav;
