library ieee;
use ieee.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;
--  A testbench has no ports.
entity calculator_cmp_tb is
end calculator_cmp_tb;

architecture behav of calculator_cmp_tb is
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
("00010001", '0'),
("00010001", '1'),-- At 2 ns
("11000101", '0'),
("11000101", '1')
-- At 4 ns
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
