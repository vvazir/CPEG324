LIBRARY ieee;
USE ieee.std_logic_1164.all;

entity sign_extend_tb is
end sign_extend_tb;

architecture behavior of sign_extend_tb is

component sign_extend
    port(
        input:        in  std_logic_vector(3 downto 0);
        output:        out std_logic_vector(7 downto 0)
        );
end component;

--inputs & outputs


signal inp:  std_logic_vector(3 downto 0);
signal outp: std_logic_vector(7 downto 0);


 begin
 
 UUT: sign_extend port map (input(3 downto 0)=>inp(3 downto 0),output(7 downto 0)=>outp(7 downto 0));

--stimulus
process
    begin
    
    wait for 100 ns;
    
    inp<="0000";
    wait for 100 ns;
    
    inp <= "0001";
    wait for 100 ns;

    inp <= "0010";
    wait for 100 ns;
    
    inp <= "0011";
    wait for 100 ns;
    
    
    inp <= "0100";
    wait for 100 ns;

    inp <= "0101";
    wait for 100 ns;
    
    inp <= "0110";
    wait for 100 ns;
    
    inp <= "0111";
    wait for 100 ns;
    
    inp <= "1000";
    wait for 100 ns;
    
    inp <= "1001";
    wait for 100 ns;
    
    inp <= "1010";
    wait for 100 ns;

    inp <= "1011";
    wait for 100 ns;
    
    inp <= "1100";
    wait for 100 ns;
    
    inp <= "1101";
    wait for 100 ns;

    inp <= "1110";
    wait for 100 ns;

    inp <= "1111";
    wait for 100 ns;

    wait;
    end process;
    
end behavior;