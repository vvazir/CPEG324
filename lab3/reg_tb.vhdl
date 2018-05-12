library ieee;
use ieee.std_logic_1164.all;

--  A testbench has no ports.
entity reg_tb is
end reg_tb;

architecture behav of reg_tb is
--  Declaration of the component that will be instantiated.
	component reg
		generic(
			width : integer :=8
		);
		port (	
			din : in std_logic_vector(width-1 downto 0);
			dout : out std_logic_vector(width-1 downto 0):= (others =>'0');
			clock : in std_logic
		);
	end component;
--  Specifies which entity is bound with the component.
-- for shift_reg_0: shift_reg use entity work.shift_reg(rtl);
	signal din,dout: std_logic_vector(1 downto 0);
	signal clock : std_logic;
	begin

	--  Component instantiation.
	R1 : reg
		generic map(width=>2)
		port map(
			din=>din,
			dout=>dout,
			clock=>clock
		);
--  This process does the real job.
	process
	type pattern_type is record
--  The inputs of the shift_reg.
		din: std_logic_vector (1 downto 0);
		clock: std_logic;
-- Output
		dout: std_logic_vector (1 downto 0);
	end record;
--  The patterns to apply.
	type pattern_array is array (natural range <>) of pattern_type;
	constant patterns : pattern_array :=
	(
	("00",'0',"00"),
	("00",'1',"00"),
	("10",'0',"00"),
	("10",'1',"10"),
	("00",'0',"10"),
	("01",'1',"01"),
	("00",'0',"01"),
	("00",'1',"00")
	
	);
	begin
		--  Check each pattern.
		for n in patterns'range loop
			--  Set the inputs.
			din <= patterns(n).din;
			clock <= patterns(n).clock;
			--  Wait for the results.
			wait for 1 ns;
			--  Check the outputs.
			assert dout = patterns(n).dout
			report "bad output value" severity error;
		end loop;
	assert false report "end of test" severity note;
	--  Wait forever; this will finish the simulation.
	wait;
end process;
end behav;
