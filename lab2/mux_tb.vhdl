library ieee;
use ieee.std_logic_1164.all;

--  A testbench has no ports.
entity mux_tb is
end mux_tb;

architecture behav of mux_tb is
--  Declaration of the component that will be instantiated.
component mux
generic(
	width : integer
);
port (	in1 : in std_logic_vector(width-1 downto 0);
		in2 : in std_logic_vector(width-1 downto 0);
		in3 : in std_logic_vector(width-1 downto 0);
		in4 : in std_logic_vector(width-1 downto 0);
		out1 : out std_logic_vector(width-1 downto 0);
		sel : in std_logic_vector(1 downto 0)
);
end component;
--  Specifies which entity is bound with the component.
-- for shift_reg_0: shift_reg use entity work.shift_reg(rtl);
signal i1,i2,i3,i4, o : std_logic_vector(3 downto 0);
signal sel : std_logic_vector(1 downto 0);
begin
--  Component instantiation.
M1 : mux
	generic map(width=>4)
	port map(
		in1=>i1,
		in2=>i2,
		in3=>i3,
		in4=>i4,
		out1=>o,
		sel=>sel
	);
--  This process does the real job.
process
type pattern_type is record
--  The inputs of the shift_reg.
i1: std_logic_vector (3 downto 0);
i2: std_logic_vector (3 downto 0);
i3: std_logic_vector (3 downto 0);
i4: std_logic_vector (3 downto 0);
sel: std_logic_vector(1 downto 0);
--  The expected outputs of the shift_reg.
o: std_logic_vector (3 downto 0);
end record;
--  The patterns to apply.
type pattern_array is array (natural range <>) of pattern_type;
constant patterns : pattern_array :=
(
("0001","0010","0011","0100", "00","1001"),
("0001","0010","0011","0100", "01","0010")
);
begin
--  Check each pattern.
for n in patterns'range loop
--  Set the inputs.
i1 <= patterns(n).i1;
i2 <= patterns(n).i2;
i3 <= patterns(n).i3;
i4 <= patterns(n).i4;
sel <= patterns(n).sel;
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
