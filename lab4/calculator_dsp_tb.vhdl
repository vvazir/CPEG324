library ieee;
use ieee.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;

--  A testbench has no ports.
entity calculator_dsp_tb is
end calculator_dsp_tb;

architecture behav of calculator_dsp_tb is
--  Declaration of the component that will be instantiated.
component calculator

port (	OpCode:     in      std_logic_vector(7 downto 0);
		DataOut:    out     std_logic_vector(7 downto 0);
		DispEn:     out     std_logic;
		BRE:		out		std_logic;
		NOP:		out		std_logic;
		clk:		in		std_logic
);
end component;

--  Specifies which entity is bound with the component.
-- for shift_reg_0: shift_reg use entity work.shift_reg(rtl);
signal op, data : std_logic_vector(7 downto 0);
signal en:	std_logic :='0';
signal clock:	std_logic;
signal bre:	std_logic:='0';
signal nop:	std_logic;
begin
--  Component instantiation.
C1 : calculator
	port map(
		op,data,en,bre,nop,clock
	);
--  This process does the real job.
process
	type pattern_type is record
	op: 	std_logic_vector (7 downto 0);
	clk:	std_logic;
	end record;
	--  The patterns to apply.
	type pattern_array is array (natural range <>) of pattern_type;
	constant patterns : pattern_array :=
		(
("00000111", '0'),
("00000111", '1'),-- At 0 ns
("00100101", '0'),
("00100101", '1'),-- At 2 ns
("00010011", '0'),
("00010011", '1'),-- At 4 ns
("00110110", '0'),
("00110110", '1'),-- At 6 ns
("00000000", '0'),
("00000000", '1'),
-- At 8 ns
-- Add NOP instructions to clear the pipeline
("11000011", '0'),
("11000011", '1'),
("11000011", '0'),
("11000011", '1')
		);
	begin
		--  Check each pattern.
		for n in patterns'range loop
			--  Set the inputs.
			op <= patterns(n).op;
			clock <= patterns(n).clk;
			--  Wait for the results.
			wait for 1 ns;
			--  If disp_en = '1', print out the data in a formated manner.
			if clock='1' then
				if (en = '0') then
					if ((to_integer(signed(data)))<0) then
						report "-" & integer'image(((-1*to_integer(signed(data))) mod 10000)/1000)&"" & integer'image(((-1*to_integer(signed(data))) mod 1000)/100)&"" & integer'image(((-1*to_integer(signed(data))) mod 100)/10)&"" & integer'image((-1*to_integer(signed(data))) mod 10) severity note;
					else
						report "" & integer'image(((to_integer(signed(data))) mod 10000)/1000)&"" & integer'image(((to_integer(signed(data))) mod 1000)/100)&"" & integer'image(((to_integer(signed(data))) mod 100)/10)&"" & integer'image((to_integer(signed(data))) mod 10)severity note;
					end if;
				end if;
				if (nop = '0') then 
					assert ((en /= '1')) report "Skipping by " & std_logic'image(bre) & " instruction" severity note;
				else
					report "NOP INS" severity note;	
				end if;
			end if;
		end loop;
		
		assert false report "end of test" severity note;
		--  Wait forever; this will finish the simulation.
		wait;
	end process;
end behav;
