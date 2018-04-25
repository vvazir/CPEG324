LIBRARY ieee;
USE ieee.std_logic_1164.all;

entity zeroCheck is

port(
    input:      in std_logic_vector(7 downto 0);
    output:     out std_logic_vector(7 downto 0)
);
end zeroCheck;

architecture behavioral of zeroCheck is
    begin
        output<=not(input or "00000000");
end behavioral;
        