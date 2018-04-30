library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity sign_extend is 
    port(
        input:        in  std_logic_vector(3 downto 0);
        output:        out std_logic_vector(7 downto 0)
        );
end sign_extend;

architecture behavioral of sign_extend is

begin
    output(7)<= input(3);
    output(6)<= input(3);
    output(5)<= input(3);
    output(4)<= input(3);
    output(3 downto 0) <= input(3 downto 0);

end behavioral;