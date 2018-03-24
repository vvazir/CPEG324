library ieee;
use ieee.std_logic_1164.all;

--  A testbench has no ports.
entity shift_reg_8_tb is
end shift_reg_8_tb;

architecture behav of shift_reg_8_tb is
--  Declaration of the component that will be instantiated.
component shift_reg_8
port (	I:	in std_logic_vector (7 downto 0);
		I_SHIFT_IN: in std_logic;
		sel:        in std_logic_vector(1 downto 0); -- 00:hold; 01: shift left; 10: shift right; 11: load
		clock:		in std_logic; 
		enable:		in std_logic;
		O:	out std_logic_vector(7 downto 0)
);
end component;
--  Specifies which entity is bound with the component.
-- for shift_reg_0: shift_reg use entity work.shift_reg(rtl);
signal i, o : std_logic_vector(7 downto 0);
signal i_shift_in, clk, enable : std_logic;
signal sel : std_logic_vector(1 downto 0);
begin
--  Component instantiation.
shift_reg_0: shift_reg_8 port map (I => i, I_SHIFT_IN => i_shift_in, sel => sel, clock => clk, enable => enable, O => o);

--  This process does the real job.
process
type pattern_type is record
--  The inputs of the shift_reg.
i: std_logic_vector (7 downto 0);
i_shift_in, clock, enable: std_logic;
sel: std_logic_vector(1 downto 0);
--  The expected outputs of the shift_reg.
o: std_logic_vector (7 downto 0);
end record;
--  The patterns to apply.
type pattern_array is array (natural range <>) of pattern_type;
constant patterns : pattern_array :=
(
--Input, ISH, CLK, EN,  SEL,  Out
-- Left Shift Tests
-- Test Load Functionality
("01010101", '0', '0', '1', "00", "00000000"),	-- 0 ns
("01010101", '0', '1', '1', "11", "01010101"),	-- 1
-- Test Hold Functionality
("01010101", '1', '0', '1', "00", "01010101"),	-- 2
("01010101", '1', '1', '1', "00", "01010101"),	-- 3
-- Test Shift Left with I_SHIFT_IN = 0
("01010101", '0', '0', '1', "01", "01010101"),	-- 4
("01010101", '0', '1', '1', "01", "10101010"),	-- 5
-- Test Shift Left with I_SHIFT_IN = 1
("01010101", '1', '0', '1', "01", "10101010"),	-- 6
("01010101", '1', '1', '1', "01", "01010101"),	-- 7 ns

-- Right Shift Tests
-- Test Load Functionality
("10101010", '0', '0', '1', "00", "01010101"),	-- 10 ns
("10101010", '0', '1', '1', "11", "10101010"),	-- 11
-- Test Hold Functionality
("10101010", '1', '0', '1', "00", "10101010"),	-- 12
("10101010", '1', '1', '1', "00", "10101010"),	-- 13
-- Test Shift Right with I_SHIFT_IN = 0
("10101010", '0', '0', '1', "10", "10101010"),	-- 14
("10101010", '0', '1', '1', "10", "01010101"),	-- 15
-- Test Shift Right with I_SHIFT_IN = 1
("10101010", '1', '0', '1', "10", "01010101"),	-- 16
("10101010", '1', '1', '1', "10", "10101010"),	-- 17

("10111010", '0', '0', '1', "00", "10101010"),	-- 18 ns
("10111010", '0', '1', '1', "11", "10111010"),	-- 19
-- Test Shift Right with I_SHIFT_IN = 1
("10111010", '1', '0', '1', "10", "10111010"),	-- 20
("10111010", '1', '1', '1', "10", "11011101")	-- 21 ns

);
begin
--  Check each pattern.
for n in patterns'range loop
--  Set the inputs.
i <= patterns(n).i;
i_shift_in <= patterns(n).i_shift_in;
sel <= patterns(n).sel;
clk <= patterns(n).clock;
enable <= patterns(n).enable;
--  Wait for the results.
wait for 1 ns;
--  Check the outputs.
assert o = patterns(n).o
report "bad output value" severity error;
end loop;
assert false report "end of test" severity note;	-- 18 ns
--  Wait forever; this will finish the simulation.
wait;
end process;
end behav;
