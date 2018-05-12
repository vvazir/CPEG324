library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity CONTROL_TB is
end CONTROL_TB;

architecture behavior of CONTROL_TB is

component Control is 
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
    INP_1:       out std_logic;
    INP_2:       out std_logic;        

    --ControlOut  out std_logic_vector(26 downto 0)
    WRITE_EN:   out std_logic;
    TWO_EN:     out std_logic;
    IMM_EN:     out std_logic;
    CMP_EN:     out std_logic;
    DISP_EN:    out std_logic;
    SKP_PASS:   out std_logic;
    LOD:        out std_logic);
end component;

--inputs 
signal op:           std_logic_vector(7 downto 0);
signal SKIPSIGI:     std_logic;
signal clk:         std_logic;
--outputs
signal inp1:        std_logic;
signal inp2:        std_logic;
signal WSIG:      std_logic;
signal TWOSIG:      std_logic;
signal IMMSIG:      std_logic;
signal CMPSIG:      std_logic;
signal DISPSIG:      std_logic;
signal SKIPSIGO:     std_logic;
signal LODSIG:      std_logic;

begin

UUT: CONTROL port map(OP_0=>OP(0),OP_1=>OP(1),OP_2=>OP(2),OP_3=>OP(3),OP_4=>OP(4),OP_5=>OP(5),OP_6=>OP(6),OP_7=>OP(7),SKIP=>SKIPSIGI,
                    clk=>clk,
                    INP_1=>inp1,INP_2=>inp2,
                    WRITE_EN=>WSIG,TWO_EN=>TWOSIG,IMM_EN=>IMMSIG,CMP_EN=>CMPSIG,DISP_EN=>DISPSIG,SKP_PASS=>SKIPSIGO,LOD=>LODSIG);

process

type pattern_type is record
	op: 	std_logic_vector (7 downto 0);
	SKIPSIGI:     std_logic;
    clk:         std_logic;
--outputs
    inp1:        std_logic;
    inp2:        std_logic;
--signal WSIG:      std_logic;
--signal TWOSIG:      std_logic;
--signal IMMSIG:      std_logic;
--signal CMPSIG:      std_logic;
--signal DISPSIG:      std_logic;
--signal SKIPSIGO:     std_logic;
--signal LODSIG:      std_logic;

end record;

-- the patterns to apply.

type pattern_array is array (natural range <>) of pattern_type;
constant patterns : pattern_array :=

(
("01000101",'0','0','0','0'),
("01000101",'0','1','0','0'),
("01000000",'0','0','1','1'),
("01000000",'0','1','1','1'),
("01010101",'0','0','1','1'),
("01010101",'0','1','1','0'),
("01011111",'0','0','1','1'),
("01011111",'0','1','1','1')
);
--stimulus

        begin
        for n in patterns'range loop
            --SET THE INPUTS
            op<=patterns(n).op;
            SKIPSIGI<=patterns(n).SKIPSIGI;
            clk<=patterns(n).clk;
            wait for 1 ns;

--check the outputs
--assert WSIG = patterns(n).WSIG report "WSIG" severity error;
--assert TWOSIG = patterns(n).TWOSIG report "TWOSIG" severity error;
--assert IMMSIG = patterns(n).IMMSIG report "IMMSIG" severity error;
--assert CMPSIG = patterns(n).CMPSIG report "CMPSIG" severity error;
--assert DISPSIG = patterns(n).DISPSIG report "DISPSIG" severity error;
--assert SKIPSIGO = patterns(n).SKIPSIGO report "SKIPSIGO" severity error;
--assert LODSIG = patterns(n).LODSIG report "LODSIG" severity error;
end loop;
assert false report "end of test" severity note;

--wait forever        
wait;

    end process;
end behavior;