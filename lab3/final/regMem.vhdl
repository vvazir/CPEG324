library ieee;
use ieee.std_logic_1164.all;

entity regMem is
port(
		reg1: 		in std_logic_vector(1 downto 0);
		reg2:       in std_logic_vector(1 downto 0);
		dstReg:		in std_logic_vector(1 downto 0);
		
		writeEn:	in std_logic;
		writeData:	in std_logic_vector(7 downto 0);
		clock:		in std_logic;
		
		reg1Data:	out std_logic_vector(7 downto 0):= (others =>'0');
		reg2Data:	out std_logic_vector(7 downto 0):= (others =>'0');
        rdData:	    out std_logic_vector(7 downto 0):= (others =>'0')
);
end regMem;

architecture behav of regMem is
	signal r0 : std_logic_vector (7 downto 0) := (others =>'0');
	signal r1 : std_logic_vector (7 downto 0) := (others =>'0');
	signal r2 : std_logic_vector (7 downto 0) := (others =>'0');
	signal r3 : std_logic_vector (7 downto 0) := (others =>'0');

	begin
	process(clock)
	begin
		if (rising_edge(clock)) then
			case reg1 is
				when "00" => 
					reg1Data <= r0;
				when "01" =>
					reg1Data <= r1;
				when "10" => 
					reg1Data <= r2;
				when "11" =>
					reg1Data <= r3;
				when others =>
					reg1Data <= r0;
			end case;
			case reg2 is
				when "00" => 
					reg2Data <= r0;
				when "01" =>
					reg2Data <= r1;
				when "10" => 
					reg2Data <= r2;
				when "11" =>
					reg2Data <= r3;
				when others =>
					reg2Data <= r0;
			end case;
            
		end if;
		if (falling_edge(clock)) then
			
            
            if writeEn = '1' then
				case dstReg is
					when "00" => 
						r0 <= writeData;
					when "01" =>
						r1 <= writeData;
					when "10" => 
						r2 <= writeData;
					when "11" =>
						r3 <= writeData;
					when others =>
						r0 <= writeData;
				end case;
			end if;
            
            
		end if;
	end process;

    rdData <=   r0 when dstReg = "00" else
                r1 when dstReg = "01" else
                r2 when dstReg = "10" else
                r3;
    
    
end behav;