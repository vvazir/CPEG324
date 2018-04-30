library ieee;
use ieee.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;
--  A testbench has no ports.
entity calculator_longcmp_tb is
end calculator_longcmp_tb;

architecture behav of calculator_longcmp_tb is
--  Declaration of the component that will be instantiated.
component calculator
port (	OpCode:     in      std_logic_vector(7 downto 0);
		DataOut:    out     std_logic_vector(7 downto 0);
		DispEn:     out     std_logic;
		clk:		in		std_logic
);
end component;
--  Specifies which entity is bound with the component.
-- for shift_reg_0: shift_reg use entity work.shift_reg(rtl);
signal op, data : std_logic_vector(7 downto 0);
signal en:	std_logic :='0';
signal clock:	std_logic;
begin
--  Component instantiation.
C1 : calculator
	port map(
		op,data,en,clock
	);
--  This process does the real job.
process
	type pattern_type is record
	--  The inputs of the shift_reg.
	op: 	std_logic_vector (7 downto 0);
	clk:	std_logic;
	--  The expected outputs of the shift_reg.
--	data: std_logic_vector (7 downto 0);
--	en:std_logic;
	end record;
	--  The patterns to apply.
	type pattern_array is array (natural range <>) of pattern_type;
	constant patterns : pattern_array :=
		(
("00000000", '0'),
("00000000", '1'),-- At 0 ns
("11000000", '0'),
("11000000", '1'),-- At 2 ns
("00010000", '0'),
("00010000", '1'),-- At 4 ns
("11010000", '0'),
("11010000", '1'),-- At 6 ns
("00100000", '0'),
("00100000", '1'),-- At 8 ns
("11100000", '0'),
("11100000", '1'),-- At 10 ns
("00110000", '0'),
("00110000", '1'),-- At 12 ns
("11110000", '0'),
("11110000", '1'),-- At 14 ns
("00100001", '0'),
("00100001", '1'),-- At 16 ns
("00111111", '0'),
("00111111", '1'),-- At 18 ns
("11000101", '0'),
("11000101", '1'),-- At 20 ns
("11110000", '0'),
("11110000", '1'),-- At 22 ns
("11100000", '0'),
("11100000", '1'),-- At 24 ns
("11000110", '0'),
("11000110", '1'),-- At 26 ns
("11110000", '0'),
("11110000", '1'),-- At 28 ns
("11110000", '0'),
("11110000", '1'),-- At 30 ns
("11100000", '0'),
("11100000", '1'),-- At 32 ns
("11001010", '0'),
("11001010", '1'),-- At 34 ns
("11111110", '0'),
("11111110", '1'),-- At 36 ns
("11100000", '0'),
("11100000", '1'),-- At 38 ns
("11110000", '0'),
("11110000", '1'),-- At 40 ns
("11100000", '0'),
("11100000", '1'),-- At 42 ns
("11001101", '0'),
("11001101", '1'),-- At 44 ns
("11000101", '0'),
("11000101", '1'),-- At 46 ns
("11110000", '0'),
("11110000", '1'),-- At 48 ns
("11100000", '0'),
("11100000", '1'),-- At 50 ns
("11000001", '0'),
("11000001", '1'),-- At 52 ns
("11110000", '0'),
("11110000", '1'),-- At 54 ns
("11100000", '0'),
("11100000", '1'),-- At 56 ns
("11000010", '0'),
("11000010", '1'),-- At 58 ns
("11110000", '0'),
("11110000", '1'),-- At 60 ns
("11000101", '0'),
("11000101", '1'),-- At 62 ns
("11100000", '0'),
("11100000", '1'),-- At 64 ns
("11000000", '0'),
("11000000", '1'),-- At 66 ns
("11000000", '0'),
("11000000", '1')
-- At 68 ns
		);
	begin
		--  Check each pattern.
		for n in patterns'range loop
			--  Set the inputs.
			op <= patterns(n).op;
			clock <= patterns(n).clk;
			--  Wait for the results.
			wait for 1 ns;
			--  Check the outputs.
			--assert en = patterns(n).en report "Display not enabled" severity error;
			if clock='1' then
                assert ((en /= '1')) report "" & integer'image(to_integer(signed(data)));
			end if;
		end loop;
		
		assert false report "end of test" severity note;
		--  Wait forever; this will finish the simulation.
		wait;
	end process;
end behav;
