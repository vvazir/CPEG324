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
		out1 : out std_logic_vector(width-1 downto 0);
		sel : in std_logic
);
end component;
--  Specifies which entity is bound with the component.
-- for shift_reg_0: shift_reg use entity work.shift_reg(rtl);
signal i1,i2, o : std_logic_vector(7 downto 0);
signal sel : std_logic;
begin
--  Component instantiation.
M1 : mux
	generic map(width=>8)
	port map(
		in1=>i1,
		in2=>i2,
		out1=>o,
		sel=>sel
	);
--  This process does the real job.
process
type pattern_type is record
--  The inputs of the shift_reg.
i1: std_logic_vector (7 downto 0);
i2: std_logic_vector (7 downto 0);
sel: std_logic;
--  The expected outputs of the shift_reg.
o: std_logic_vector (7 downto 0);
end record;
--  The patterns to apply.
type pattern_array is array (natural range <>) of pattern_type;
constant patterns : pattern_array :=
(
("00010010","00110100", '0',"00010010"),
("00010010","00110100", '0',"00010010"),
("00010010","00110100", '1',"00110100"),
("00010010","00110100", '1',"00110100")
);
begin
--  Check each pattern.
for n in patterns'range loop
--  Set the inputs.
i1 <= patterns(n).i1;
i2 <= patterns(n).i2;
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
