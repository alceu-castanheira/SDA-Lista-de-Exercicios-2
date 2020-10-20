----------------------------------------------------------------------------------
-- Company: Universidade de Brasília - UnB
-- Engineer: Alceu Bernardes Castanheira de Farias
-- 
-- Create Date: 13.10.2020 14:13:09
-- Design Name: 
-- Module Name: clk_div_2Hz - Behavioral
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

-- Circuito divisdor de frequência. Saída: sinal de clock de frequência 2 Hz
entity clk_div_2Hz is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           clk_2Hz : out STD_LOGIC);
end clk_div_2Hz;

architecture Behavioral of clk_div_2Hz is

    -- Constante de PRESET para implementar um clock de saída de 2Hz
    constant C_PRESET : std_logic_vector (26 downto 0) := "101111101011110000100000000"; -- 100000000
    
    -- Sinal que armazena a contagem do divisor de frequência
    signal s_count : std_logic_vector (26 downto 0) := (others => '0');
    
    -- Sinal de clock dividido, com frequência de 2Hz
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
    
    clk_2Hz <= s_clk_div;
    
end Behavioral;
