library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity control is 
    port(
        OP_0:       in  std_logic;
        OP_1:       in  std_logic;
        SKIP:       in  std_logic;
        OP_6:       in  std_logic;
        OP_7:       in  std_logic;
		
        WRITE_EN:   out std_logic;
        TWO_EN:     out std_logic;
        IMM_EN:     out std_logic;
        CMP_EN:     out std_logic;
        DISP_EN:    out std_logic;
        SKP_PASS:   out std_logic;
        LOD:        out std_logic);
end control;

architecture behavioral of CONTROL is

	begin	
		WRITE_EN <= (not SKIP) and (not(OP_6 and OP_7));
		TWO_EN <= not(OP_7 and (not(OP_6)));
		IMM_EN <= ((OP_6 or OP_7));
		CMP_EN <= not ((OP_6 and OP_7) and (OP_0 xor OP_1));
		DISP_EN <= ((OP_6 and OP_7) and (not(OP_0 xor OP_1))) and not(SKIP);
		SKP_PASS <= SKIP;
		LOD <= (OP_6 or OP_7);

end behavioral;