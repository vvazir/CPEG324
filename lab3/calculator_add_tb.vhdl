library ieee;
use ieee.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;
--  A testbench has no ports.
entity calculator_add_tb is
end calculator_add_tb;

architecture behav of calculator_add_tb is
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
signal en,clock:	std_logic;
begin
--  Component instantiation.
C1 : calculator
	port map(
		OpCode=>op,
		DataOut=>data,
		DispEn=>en,
		clk=>clock
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
("00010111", '0'),
("00010111", '1'),-- At 0 ns
("00101111", '0'),
("00101111", '1'),-- At 1 ns
("11100000", '0'),
("11100000", '1'),-- At 2 ns
("01000110", '0'),
("01000110", '1'),-- At 3 ns
("01000100", '0'),
("01000100", '1'),-- At 4 ns
("01000100", '0'),
("01000100", '1'),-- At 5 ns
("01000100", '0'),
("01000100", '1'),-- At 6 ns
("01000100", '0'),
("01000100", '1'),-- At 7 ns
("01000100", '0'),
("01000100", '1'),-- At 8 ns
("01000100", '0'),
("01000100", '1'),-- At 9 ns
("01000100", '0'),
("01000100", '1'),-- At 10 ns
("01000100", '0'),
("01000100", '1'),-- At 11 ns
("01000100", '0'),
("01000100", '1'),-- At 12 ns
("01000100", '0'),
("01000100", '1'),-- At 13 ns
("01000100", '0'),
("01000100", '1'),-- At 14 ns
("01000100", '0'),
("01000100", '1'),-- At 15 ns
("01000100", '0'),
("01000100", '1'),-- At 16 ns
("01000100", '0'),
("01000100", '1'),-- At 17 ns
("01000100", '0'),
("01000100", '1'),-- At 18 ns
("01000100", '0'),
("01000100", '1'),-- At 19 ns
("11000000", '0'),
("11000000", '1'),-- At 20 ns
("01000100", '0'),
("01000100", '1'),-- At 21 ns
("11000000", '0'),
("11000000", '1'),-- At 22 ns
("11010101", '0'),
("11010101", '1'),-- At 23 ns
("10000101", '0'),
("10000101", '1'),-- At 24 ns
("01000101", '0')
-- At 25 ns
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
			if en='1' then
				--assert data = patterns(n).data report "Incorrect print data" severity error;
				report "" & integer'image(to_integer(signed(data(7 downto 6)))) & "" &integer'image(to_integer(signed(data(5 downto 4))));
			end if;
		end loop;
		
		assert false report "end of test" severity note;
		--  Wait forever; this will finish the simulation.
		wait;
	end process;
end behav;
