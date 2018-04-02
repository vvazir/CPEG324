library ieee;
use ieee.std_logic_1164.all;

entity shift_reg_8 is
port(	I:	in std_logic_vector (7 downto 0);
		I_SHIFT_IN: in std_logic;
		sel:        in std_logic_vector(1 downto 0); -- 00:hold; 01: shift left; 10: shift right; 11: load
		clock:		in std_logic; -- positive level triggering in problem 3
		enable:		in std_logic; -- 0: don't do anything; 1: shift_reg is enabled
		O:	out std_logic_vector(7 downto 0) := (others =>'0')
);
end shift_reg_8;

architecture structural of shift_reg_8 is
component shift_reg
port (	I:	in std_logic_vector (3 downto 0);
		I_SHIFT_IN: in std_logic;
		sel:        in std_logic_vector(1 downto 0); -- 00:hold; 01: shift left; 10: shift right; 11: load
		clock:		in std_logic; 
		enable:		in std_logic;
		O:	out std_logic_vector(3 downto 0)
);
end component;

-- Intermediate signals
signal sr0_shift_in : std_logic;
signal sr1_shift_in : std_logic;
signal o1 : std_logic_vector(3 downto 0);
signal o2 : std_logic_vector(3 downto 0);
begin
	-- Simple Multiplexer to shift bits across the two shift registers
	sr0_shift_in <=  (I_SHIFT_IN and (sel(0) and not sel(1))) or (o2(0) and  (sel(1) and not sel(0)));
	sr1_shift_in <= (I_SHIFT_IN and (sel(1) and not sel(0))) or (o1(3) and  (sel(0) and not sel(1)));
	-- Two shift registers
	shift_reg_0: shift_reg port map (I => I(3 downto 0), I_SHIFT_IN => sr0_shift_in, sel => sel, clock => clock, enable => enable, O => o1);
	shift_reg_1: shift_reg port map (I => I(7 downto 4), I_SHIFT_IN => sr1_shift_in, sel => sel, clock => clock, enable => enable, O => o2);
	-- Take the output of the 4-bit shift registers and put them in the 8-bit shift register 
	O(3 downto 0) <= o1;
	O(7 downto 4) <= o2;
end structural;

