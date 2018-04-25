LIBRARY ieee;
USE ieee.std_logic_1164.all;

zeroCheck_tb is
end zeroCheck_tb;

architecture behavioral of zeroCheck is

component zeroCheck

port(
    input:      in std_logic_vector(7 downto 0);
    output:     out std_logic_vector(7 downto 0)
);
end component;

signal inpt: std_logic_vector(7 downto 0);
signal otpt: std_logic_vector(7 downto 0);

begin

z1: zeroCheck port map(input<=inpt,output<=oupt);

process
type pattern_type is record

i1: std_logic_vector (7 downto 0);

o: std_logic_vector (7 downto 0);
end record;

type pattern_array is array (natural range <>) of pattern_type;

constant patterns : pattern_array :=
(


);