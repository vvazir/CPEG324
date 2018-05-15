library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity control is 
    port(
        OP_0:       in  std_logic;
        OP_1:       in  std_logic;
        OP_2:       in  std_logic;
        OP_3:       in  std_logic;
        OP_4:       in  std_logic;
        OP_5:       in  std_logic;
        OP_6:       in  std_logic;
        OP_7:       in  std_logic;
        SKIP:       in  std_logic;
        
        clk:        in  std_logic;

        --Data forwarding
        INP_1:      out std_logic;
        INP_2:      out std_logic;        

        BRE:        out std_logic;
        --ControlOut  out std_logic_vector(26 downto 0)
        WRITE_EN:   out std_logic;
        TWO_EN:     out std_logic;
        IMM_EN:     out std_logic;
        CMP_EN:     out std_logic;
        DISP_EN:    out std_logic;
        SKP_PASS:   out std_logic;
        LOD:        out std_logic);
end control;

architecture behavioral of CONTROL is
    --reg
    component reg is
    generic (
        width : integer := 8    
    );
    port(
        din : in std_logic_vector(width-1 downto 0);
        dout : out std_logic_vector(width-1 downto 0):= (others =>'0');
        clock : in std_logic
    );
    end component;
    
    signal IDEXEOP:      std_logic_vector(7 downto 0);
    signal IDEXESK:      std_logic;

    signal EXEWBOP:      std_logic_vector(7 downto 0);
    signal EXEWBSK:      std_logic;

    signal notclk:       std_logic;
    
    signal imp:           std_logic_vector(8 downto 0);
    signal inter1:        std_logic_vector(8 downto 0);
    signal inter2:        std_logic_vector(8 downto 0);
    begin	
        notclk  <= clk;
        imp <=OP_7&OP_6&OP_5&OP_4&OP_3&OP_2&OP_1&OP_0&SKIP;
        IDEXEOP<=inter1(8 downto 1);
        IDEXESK<=inter1(0);
        EXEWBOP<=inter2(8 downto 1);
        EXEWBSK<=inter2(0);
        istageIDEXE:    reg     generic map(width => 9)
                                port map(imp,inter1,notclk);
        istageEXEWB:    reg     generic map(width => 9)
                                port map(inter1,inter2,notclk);

		WRITE_EN <= (not EXEWBSK) and (not(EXEWBOP(6) and EXEWBOP(7)));
		TWO_EN <= not(IDEXEOP(7) and (not(IDEXEOP(6)))) and (not ((IDEXEOP(6) and IDEXEOP(7)) and (IDEXEOP(0) xor IDEXEOP(1))));
		IMM_EN <= ((IDEXEOP(6) or IDEXEOP(7)));
		CMP_EN <= not ((IDEXEOP(6) and IDEXEOP(7)) and (IDEXEOP(0) xor IDEXEOP(1)));
		DISP_EN <= ((EXEWBOP(6) and EXEWBOP(7)) and (not(EXEWBOP(0) xor EXEWBOP(1)))) and not(EXEWBSK) and (not(EXEWBOP(0) and EXEWBOP(1)));
		SKP_PASS <= SKIP;
		LOD <= (IDEXEOP(6) or IDEXEOP(7));
        INP_1 <= (EXEWBOP(5) xnor IDEXEOP(3)) and (EXEWBOP(4) xnor IDEXEOP(2)); 
        INP_2 <= (EXEWBOP(5) xnor IDEXEOP(1)) and (EXEWBOP(4) xnor IDEXEOP(0));
        BRE <= EXEWBOP(0); 
end behavioral;
