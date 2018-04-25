library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity CONTROL_TB is
end CONTROL_TB;

architecture behavior of CONTROL_TB is

component Control is 
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
end component;

--inputs 
signal OPSIG0:      std_logic;
signal OPSIG1:      std_logic;
signal OPSIG6:      std_logic;
signal OPSIG7:      std_logic;
signal SKIPSIGI:     std_logic;

--outputs
signal WSIG:      std_logic;
signal TWOSIG:      std_logic;
signal IMMSIG:      std_logic;
signal CMPSIG:      std_logic;
signal DISPSIG:      std_logic;
signal SKIPSIGO:     std_logic;
signal LODSIG:      std_logic;

begin

UUT: CONTROL port map(OP_0=>OPSIG0,OP_1=>OPSIG1,OP_6=>OPSIG6,OP_7=>OPSIG7,SKIP=>SKIPSIGI,WRITE_EN=>WSIG,TWO_EN=>TWOSIG,IMM_EN=>IMMSIG,CMP_EN=>CMPSIG,DISP_EN=>DISPSIG,SKP_PASS=>SKIPSIGO,LOD=>LODSIG);

process

type pattern_type is record

--  The inputs: control unit
OPSIG0: std_logic;
OPSIG1: std_logic;
OPSIG6: std_logic;
OPSIG7: std_logic;
SKIPSIGI: std_logic;

--  The expected outputs of the shift_reg.
WSIG:      std_logic;
TWOSIG:      std_logic;
IMMSIG:      std_logic;
CMPSIG:      std_logic;
DISPSIG:      std_logic;
SKIPSIGO:     std_logic;
LODSIG:      std_logic;

end record;

-- the patterns to apply.

type pattern_array is array (natural range <>) of pattern_type;
constant patterns : pattern_array :=

(
('0','0','0','0','0','1','0','1','0','0','0','0'),
('0','0','0','0','1','0','0','1','0','0','1','0'),
('0','0','0','1','0','1','1','0','0','0','0','1'),
('0','0','0','1','1','0','1','0','0','0','1','1'),
('0','0','1','0','0','1','0','0','0','0','0','1'),
('0','0','1','0','1','0','0','0','0','0','1','1'),
('0','0','1','1','0','0','0','0','0','1','0','1'),
('0','0','1','1','1','0','0','0','0','0','1','1'),
('0','1','0','0','0','1','0','1','0','0','0','0'),
('0','1','0','0','1','0','0','1','0','0','1','0'),
('0','1','0','1','0','1','1','0','0','0','0','1'),
('0','1','0','1','1','0','1','0','0','0','1','1'),
('0','1','1','0','0','1','0','0','0','0','0','1'),
('0','1','1','0','1','0','0','0','0','0','1','1'),
('0','1','1','1','0','0','0','0','1','0','0','1'),
('0','1','1','1','1','0','0','0','1','0','1','1'),
('1','0','0','0','0','1','0','1','0','0','0','0'),
('1','0','0','0','1','0','0','1','0','0','1','0'),
('1','0','0','1','0','1','1','0','0','0','0','1'),
('1','0','0','1','1','0','1','0','0','0','1','1'),
('1','0','1','0','0','1','0','0','0','0','0','1'),
('1','0','1','0','1','0','0','0','0','0','1','1'),
('1','0','1','1','0','0','0','0','1','0','0','1'),
('1','0','1','1','1','0','0','0','1','0','1','1'),
('1','1','0','0','0','1','0','1','0','0','0','0'),
('1','1','0','0','1','0','0','1','0','0','1','0'),
('1','1','0','1','0','1','1','0','0','0','0','1'),
('1','1','0','1','1','0','1','0','0','0','1','1'),
('1','1','1','0','0','1','0','0','0','0','0','1'),
('1','1','1','0','1','0','0','0','0','0','1','1'),
('1','1','1','1','0','0','0','0','0','1','0','1'),
('1','1','1','1','1','0','0','0','0','0','1','1')
);
--stimulus

        begin
        for n in patterns'range loop
        --SET THE INPUTS
        OPSIG0 <= patterns(n).OPSIG0;
        OPSIG1 <= patterns(n).OPSIG1;
        OPSIG6 <= patterns(n).OPSIG6;
        OPSIG7 <= patterns(n).OPSIG7;
        SKIPSIGI <= patterns(n).SKIPSIGI;
        
wait for 1 ns;

--check the outputs
assert WSIG = patterns(n).WSIG;
assert TWOSIG = patterns(n).TWOSIG;
assert IMMSIG = patterns(n).IMMSIG;
assert CMPSIG = patterns(n).CMPSIG;
assert DISPSIG = patterns(n).DISPSIG;
assert SKIPSIGO = patterns(n).SKIPSIGO;
assert LODSIG = patterns(n).LODSIG;
report "bad output value" severity error;
end loop;
assert false report "end of test" severity note;

--wait forever        
wait;

    end process;
end behavior;