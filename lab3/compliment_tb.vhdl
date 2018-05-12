library ieee;
use ieee.std_logic_1164.all;

--  A testbench has no ports.
entity compliment_tb is
end compliment_tb;

architecture behav of compliment_tb is
--  Declaration of the component that will be instantiated.
component compliment
port (	input : in std_logic_vector(7 downto 0);
		output : out std_logic_vector(7 downto 0)
);
end component;
--  Specifies which entity is bound with the component.
-- for shift_reg_0: shift_reg use entity work.shift_reg(rtl);
signal i1, o : std_logic_vector(7 downto 0);
begin
--  Component instantiation.
C1 : compliment
	port map(
		input=>i1,
		output=>o
	);
--  This process does the real job.
process
type pattern_type is record
--  The inputs of the shift_reg.
i1: std_logic_vector (7 downto 0);
--  The expected outputs of the shift_reg.
o: std_logic_vector (7 downto 0);
end record;
--  The patterns to apply.
type pattern_array is array (natural range <>) of pattern_type;
constant patterns : pattern_array :=
(
("10010010","01101110"),
("01101101","10010011"),
("10101010","01010110"),
("01010101","10101011")
);
begin
--  Check each pattern.
for n in patterns'range loop
--  Set the inputs.
i1 <= patterns(n).i1;
--  Wait for the results.
wait for 1 ns;
--  Check the outputs.
assert o = patterns(n).o
report "bad output value" severity error;
end loop;
assert false report "end of test" severity note;
--  Wait forever; this will finish the simulation.
wait;
end process;
end behav;
