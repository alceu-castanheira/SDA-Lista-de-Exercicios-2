----------------------------------------------------------------------------------
-- Company: Universidade de Brasília - UnB
-- Engineer: Alceu Bernardes Castanheira de Farias
-- 
-- Create Date: 13.10.2020 00:00:48
-- Design Name: 
-- Module Name: clk_div_1Hz - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity clk_div_1Hz is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           clk_1Hz : out STD_LOGIC);
end clk_div_1Hz;

architecture Behavioral of clk_div_1Hz is

    -- 50 000 000 em binário (frequência de 1Hz com base em clock master de 100 MHz)
    constant C_PRESET : std_logic_vector (25 downto 0) := "10111110101111000010000000";
    signal s_count : std_logic_vector (25 downto 0) := (others => '0');
    
    signal s_clk_div : std_logic := '0';
    
begin

    process(clk, rst)
    begin
        if rst = '1' then
            s_count <= (others => '0');
            s_clk_div <= '0';
        
        elsif rising_edge(clk) then
            if s_count = C_PRESET then
                s_count <= (others => '0');
                s_clk_div <= not s_clk_div;
            else
                s_count <= std_logic_vector(unsigned(s_count) + 1);
            end if;
        end if;
    end process;
    
    clk_1Hz <= s_clk_div;
    
end Behavioral;
