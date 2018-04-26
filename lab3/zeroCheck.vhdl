LIBRARY ieee;
USE ieee.std_logic_1164.all;

entity zeroCheck is

port(
    input:      in std_logic_vector(7 downto 0);
    output:     out std_logic
);
end zeroCheck;

architecture behavioral of zeroCheck is
    begin
        output <= not (input(0) or input(1) or input(2) or input(3) or input(4) or input(5) or input(6) or input(7));
end behavioral;
        