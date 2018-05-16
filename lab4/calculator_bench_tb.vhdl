library ieee;
use ieee.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;

--  A testbench has no ports.
entity calculator_bench_tb is
end calculator_bench_tb;

architecture behav of calculator_bench_tb is
--  Declaration of the component that will be instantiated.
component calculator

port (	OpCode:     in      std_logic_vector(7 downto 0);
		DataOut:    out     std_logic_vector(7 downto 0);
		DispEn:     out     std_logic;
		BREN:		out		std_logic;
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
signal bren: std_logic;
begin
--  Component instantiation.
C1 : calculator
	port map(
		op,data,en,bren,bre,nop,clock
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
("00010110", '0'),
("00010110", '1'),-- At 2 ns
("01100001", '0'),
("01100001", '1'),-- At 4 ns
("11100101", '0'),
("11100101", '1'),-- At 6 ns
("11000000", '0'),
("11000000", '1'),-- At 8 ns
("11010000", '0'),
("11010000", '1'),-- At 10 ns
("00000000", '0'),
("00000000", '1'),-- At 12 ns
("00010000", '0'),
("00010000", '1'),-- At 14 ns
("11010000", '0'),
("11010000", '1'),-- At 16 ns
("00100000", '0'),
("00100000", '1'),-- At 18 ns
("11100000", '0'),
("11100000", '1'),-- At 20 ns
("00110000", '0'),
("00110000", '1'),-- At 22 ns
("11110000", '0'),
("11110000", '1'),-- At 24 ns
("00100001", '0'),
("00100001", '1'),-- At 26 ns
("00111111", '0'),
("00111111", '1'),-- At 28 ns
("11000101", '0'),
("11000101", '1'),-- At 30 ns
("11110000", '0'),
("11110000", '1'),-- At 32 ns
("11100000", '0'),
("11100000", '1'),-- At 34 ns
("11000110", '0'),
("11000110", '1'),-- At 36 ns
("11110000", '0'),
("11110000", '1'),-- At 38 ns
("11110000", '0'),
("11110000", '1'),-- At 40 ns
("11100000", '0'),
("11100000", '1'),-- At 42 ns
("11001010", '0'),
("11001010", '1'),-- At 44 ns
("11111110", '0'),
("11111110", '1'),-- At 46 ns
("11100000", '0'),
("11100000", '1'),-- At 48 ns
("11110000", '0'),
("11110000", '1'),-- At 50 ns
("11100000", '0'),
("11100000", '1'),-- At 52 ns
("11001101", '0'),
("11001101", '1'),-- At 54 ns
("11000101", '0'),
("11000101", '1'),-- At 56 ns
("11110000", '0'),
("11110000", '1'),-- At 58 ns
("11100000", '0'),
("11100000", '1'),-- At 60 ns
("11000000", '0'),
("11000000", '1'),-- At 62 ns
("11000000", '0'),
("11000000", '1'),-- At 64 ns
("00000001", '0'),
("00000001", '1'),-- At 66 ns
("11000000", '0'),
("11000000", '1'),-- At 68 ns
("00000010", '0'),
("00000010", '1'),-- At 70 ns
("11000000", '0'),
("11000000", '1'),-- At 72 ns
("00000011", '0'),
("00000011", '1'),-- At 74 ns
("11000000", '0'),
("11000000", '1'),-- At 76 ns
("00000100", '0'),
("00000100", '1'),-- At 78 ns
("11000000", '0'),
("11000000", '1'),-- At 80 ns
("00000101", '0'),
("00000101", '1'),-- At 82 ns
("11000000", '0'),
("11000000", '1'),-- At 84 ns
("00000110", '0'),
("00000110", '1'),-- At 86 ns
("11000000", '0'),
("11000000", '1'),-- At 88 ns
("00000111", '0'),
("00000111", '1'),-- At 90 ns
("11000000", '0'),
("11000000", '1'),-- At 92 ns
("00001111", '0'),
("00001111", '1'),-- At 94 ns
("11000000", '0'),
("11000000", '1'),-- At 96 ns
("00001110", '0'),
("00001110", '1'),-- At 98 ns
("11000000", '0'),
("11000000", '1'),-- At 100 ns
("00001101", '0'),
("00001101", '1'),-- At 102 ns
("11000000", '0'),
("11000000", '1'),-- At 104 ns
("00001100", '0'),
("00001100", '1'),-- At 106 ns
("11000000", '0'),
("11000000", '1'),-- At 108 ns
("00001011", '0'),
("00001011", '1'),-- At 110 ns
("11000000", '0'),
("11000000", '1'),-- At 112 ns
("00001010", '0'),
("00001010", '1'),-- At 114 ns
("11000000", '0'),
("11000000", '1'),-- At 116 ns
("00001001", '0'),
("00001001", '1'),-- At 118 ns
("11000000", '0'),
("11000000", '1'),-- At 120 ns
("00001000", '0'),
("00001000", '1'),-- At 122 ns
("11000000", '0'),
("11000000", '1'),-- At 124 ns
("00010001", '0'),
("00010001", '1'),-- At 126 ns
("11010000", '0'),
("11010000", '1'),-- At 128 ns
("00010010", '0'),
("00010010", '1'),-- At 130 ns
("11010000", '0'),
("11010000", '1'),-- At 132 ns
("00010011", '0'),
("00010011", '1'),-- At 134 ns
("11010000", '0'),
("11010000", '1'),-- At 136 ns
("00010100", '0'),
("00010100", '1'),-- At 138 ns
("11010000", '0'),
("11010000", '1'),-- At 140 ns
("00010101", '0'),
("00010101", '1'),-- At 142 ns
("11010000", '0'),
("11010000", '1'),-- At 144 ns
("00010110", '0'),
("00010110", '1'),-- At 146 ns
("11010000", '0'),
("11010000", '1'),-- At 148 ns
("00010111", '0'),
("00010111", '1'),-- At 150 ns
("11010000", '0'),
("11010000", '1'),-- At 152 ns
("00011111", '0'),
("00011111", '1'),-- At 154 ns
("11010000", '0'),
("11010000", '1'),-- At 156 ns
("00011110", '0'),
("00011110", '1'),-- At 158 ns
("11010000", '0'),
("11010000", '1'),-- At 160 ns
("00011101", '0'),
("00011101", '1'),-- At 162 ns
("11010000", '0'),
("11010000", '1'),-- At 164 ns
("00011100", '0'),
("00011100", '1'),-- At 166 ns
("11010000", '0'),
("11010000", '1'),-- At 168 ns
("00011011", '0'),
("00011011", '1'),-- At 170 ns
("11010000", '0'),
("11010000", '1'),-- At 172 ns
("00011010", '0'),
("00011010", '1'),-- At 174 ns
("11010000", '0'),
("11010000", '1'),-- At 176 ns
("00011001", '0'),
("00011001", '1'),-- At 178 ns
("11010000", '0'),
("11010000", '1'),-- At 180 ns
("00011000", '0'),
("00011000", '1'),-- At 182 ns
("11010000", '0'),
("11010000", '1'),-- At 184 ns
("00100001", '0'),
("00100001", '1'),-- At 186 ns
("11100000", '0'),
("11100000", '1'),-- At 188 ns
("00100010", '0'),
("00100010", '1'),-- At 190 ns
("11100000", '0'),
("11100000", '1'),-- At 192 ns
("00100011", '0'),
("00100011", '1'),-- At 194 ns
("11100000", '0'),
("11100000", '1'),-- At 196 ns
("00100100", '0'),
("00100100", '1'),-- At 198 ns
("11100000", '0'),
("11100000", '1'),-- At 200 ns
("00100101", '0'),
("00100101", '1'),-- At 202 ns
("11100000", '0'),
("11100000", '1'),-- At 204 ns
("00100110", '0'),
("00100110", '1'),-- At 206 ns
("11100000", '0'),
("11100000", '1'),-- At 208 ns
("00100111", '0'),
("00100111", '1'),-- At 210 ns
("11100000", '0'),
("11100000", '1'),-- At 212 ns
("00101111", '0'),
("00101111", '1'),-- At 214 ns
("11100000", '0'),
("11100000", '1'),-- At 216 ns
("00101110", '0'),
("00101110", '1'),-- At 218 ns
("11100000", '0'),
("11100000", '1'),-- At 220 ns
("00101101", '0'),
("00101101", '1'),-- At 222 ns
("11100000", '0'),
("11100000", '1'),-- At 224 ns
("00101100", '0'),
("00101100", '1'),-- At 226 ns
("11100000", '0'),
("11100000", '1'),-- At 228 ns
("00101011", '0'),
("00101011", '1'),-- At 230 ns
("11100000", '0'),
("11100000", '1'),-- At 232 ns
("00101010", '0'),
("00101010", '1'),-- At 234 ns
("11100000", '0'),
("11100000", '1'),-- At 236 ns
("00101001", '0'),
("00101001", '1'),-- At 238 ns
("11100000", '0'),
("11100000", '1'),-- At 240 ns
("00101000", '0'),
("00101000", '1'),-- At 242 ns
("11100000", '0'),
("11100000", '1'),-- At 244 ns
("00110001", '0'),
("00110001", '1'),-- At 246 ns
("11110000", '0'),
("11110000", '1'),-- At 248 ns
("00110010", '0'),
("00110010", '1'),-- At 250 ns
("11110000", '0'),
("11110000", '1'),-- At 252 ns
("00110011", '0'),
("00110011", '1'),-- At 254 ns
("11110000", '0'),
("11110000", '1'),-- At 256 ns
("00110100", '0'),
("00110100", '1'),-- At 258 ns
("11110000", '0'),
("11110000", '1'),-- At 260 ns
("00110101", '0'),
("00110101", '1'),-- At 262 ns
("11110000", '0'),
("11110000", '1'),-- At 264 ns
("00110110", '0'),
("00110110", '1'),-- At 266 ns
("11110000", '0'),
("11110000", '1'),-- At 268 ns
("00110111", '0'),
("00110111", '1'),-- At 270 ns
("11110000", '0'),
("11110000", '1'),-- At 272 ns
("00111111", '0'),
("00111111", '1'),-- At 274 ns
("11110000", '0'),
("11110000", '1'),-- At 276 ns
("00111110", '0'),
("00111110", '1'),-- At 278 ns
("11110000", '0'),
("11110000", '1'),-- At 280 ns
("00111101", '0'),
("00111101", '1'),-- At 282 ns
("11110000", '0'),
("11110000", '1'),-- At 284 ns
("00111100", '0'),
("00111100", '1'),-- At 286 ns
("11110000", '0'),
("11110000", '1'),-- At 288 ns
("00111011", '0'),
("00111011", '1'),-- At 290 ns
("11110000", '0'),
("11110000", '1'),-- At 292 ns
("00111010", '0'),
("00111010", '1'),-- At 294 ns
("11110000", '0'),
("11110000", '1'),-- At 296 ns
("00111001", '0'),
("00111001", '1'),-- At 298 ns
("11110000", '0'),
("11110000", '1'),-- At 300 ns
("00111000", '0'),
("00111000", '1'),-- At 302 ns
("11110000", '0'),
("11110000", '1'),-- At 304 ns
("00100010", '0'),
("00100010", '1'),-- At 306 ns
("00110111", '0'),
("00110111", '1'),-- At 308 ns
("00010011", '0'),
("00010011", '1'),-- At 310 ns
("01000110", '0'),
("01000110", '1'),-- At 312 ns
("11000000", '0'),
("11000000", '1'),-- At 314 ns
("00010011", '0'),
("00010011", '1'),-- At 316 ns
("01000101", '0'),
("01000101", '1'),-- At 318 ns
("11000000", '0'),
("11000000", '1'),-- At 320 ns
("10010100", '0'),
("10010100", '1'),-- At 322 ns
("11010000", '0'),
("11010000", '1'),-- At 324 ns
("10100101", '0'),
("10100101", '1'),-- At 326 ns
("11100000", '0'),
("11100000", '1'),-- At 328 ns
("00010111", '0'),
("00010111", '1'),-- At 330 ns
("00101111", '0'),
("00101111", '1'),-- At 332 ns
("11100000", '0'),
("11100000", '1'),-- At 334 ns
("01000110", '0'),
("01000110", '1'),-- At 336 ns
("01000100", '0'),
("01000100", '1'),-- At 338 ns
("01000100", '0'),
("01000100", '1'),-- At 340 ns
("01000100", '0'),
("01000100", '1'),-- At 342 ns
("01000100", '0'),
("01000100", '1'),-- At 344 ns
("01000100", '0'),
("01000100", '1'),-- At 346 ns
("01000100", '0'),
("01000100", '1'),-- At 348 ns
("01000100", '0'),
("01000100", '1'),-- At 350 ns
("01000100", '0'),
("01000100", '1'),-- At 352 ns
("01000100", '0'),
("01000100", '1'),-- At 354 ns
("01000100", '0'),
("01000100", '1'),-- At 356 ns
("01000100", '0'),
("01000100", '1'),-- At 358 ns
("01000100", '0'),
("01000100", '1'),-- At 360 ns
("01000100", '0'),
("01000100", '1'),-- At 362 ns
("01000100", '0'),
("01000100", '1'),-- At 364 ns
("01000100", '0'),
("01000100", '1'),-- At 366 ns
("01000100", '0'),
("01000100", '1'),-- At 368 ns
("11000000", '0'),
("11000000", '1'),-- At 370 ns
("01000100", '0'),
("01000100", '1'),-- At 372 ns
("11000000", '0'),
("11000000", '1'),
-- At 374 ns
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
						--report "ALU Output -" & integer'image(((-1*to_integer(signed(data))) mod 10000)/1000)&"" & integer'image(((-1*to_integer(signed(data))) mod 1000)/100)&"" & integer'image(((-1*to_integer(signed(data))) mod 100)/10)&"" & integer'image((-1*to_integer(signed(data))) mod 10) severity note;
					else
						--report "ALU Output " & integer'image(((to_integer(signed(data))) mod 10000)/1000)&"" & integer'image(((to_integer(signed(data))) mod 1000)/100)&"" & integer'image(((to_integer(signed(data))) mod 100)/10)&"" & integer'image((to_integer(signed(data))) mod 10)severity note;
					end if;
				else
					if ((to_integer(signed(data)))<0) then
						report "-" & integer'image(((-1*to_integer(signed(data))) mod 10000)/1000)&"" & integer'image(((-1*to_integer(signed(data))) mod 1000)/100)&"" & integer'image(((-1*to_integer(signed(data))) mod 100)/10)&"" & integer'image((-1*to_integer(signed(data))) mod 10) severity note;
					else
						report "" & integer'image(((to_integer(signed(data))) mod 10000)/1000)&"" & integer'image(((to_integer(signed(data))) mod 1000)/100)&"" & integer'image(((to_integer(signed(data))) mod 100)/10)&"" & integer'image((to_integer(signed(data))) mod 10)severity note;
					end if;
				end if;
				if (nop = '0') then 
					if ((bren = '1')) then 
						if (bre='0') then 
							report "Skipping by 1 instruction" severity note;
						else
							report "Skipping by 2 instruction" severity note;
						end if;
					end if;
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
