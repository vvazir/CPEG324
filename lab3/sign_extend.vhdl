library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity sign_extend is 
    port(
        input:        in  std_logic_vector(7 downto 0);
        output:        out std_logic_vector(7 downto 0)
        );
end sign_extend;

architecture behavioral of sign_extend is

signal passThrough: std_logic_vector(3 downto 0);
signal extended: std_logic;


begin
    extended <= input(3);
    passThrough <= input(3 downto 0);
    output(7)<= extended;
    output(6)<= extended;
    output(5)<= extended;
    output(4)<= extended;
    output(3 downto 0) <= passThrough;

end behavioral;