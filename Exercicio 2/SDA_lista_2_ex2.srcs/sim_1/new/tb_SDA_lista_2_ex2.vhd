----------------------------------------------------------------------------------
-- Company: Universidade de Brasília - UnB
-- Engineer: Alceu Bernardes Castanheira de Farias
-- 
-- Create Date: 12.10.2020 23:31:51
-- Design Name: 
-- Module Name: tb_SDA_lista_2_ex2 - Behavioral
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

entity tb_SDA_lista_2_ex2 is
end tb_SDA_lista_2_ex2;

architecture Behavioral of tb_SDA_lista_2_ex2 is

component SDA_lista_2_ex2 is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           left : in STD_LOGIC;
           right : in STD_LOGIC;
           haz : in STD_LOGIC;
           lights : out STD_LOGIC_VECTOR (7 downto 0));
end component SDA_lista_2_ex2;

    signal s_clk : std_logic := '0';
    signal s_rst : std_logic := '0';
    signal s_left : std_logic := '0';
    signal s_right : std_logic := '0';
    signal s_haz : std_logic := '0';
    signal s_lights : std_logic_vector(7 downto 0) := (others => '0');
    
begin

    uut: SDA_lista_2_ex2 port map
    (
        clk => s_clk,
        rst => s_rst,
        left => s_left,
        right => s_right,
        haz => s_haz,
        lights => s_lights
        
    );
    
    -- Testando com um clock de período 10 ns (f = 100 MHz)
    s_clk <= not s_clk after 5 ns;
    
    s_rst <= '1' after 10 ns, '0' after 20 ns;
    
    s_left <= '1' after 10 ns, '0' after 60 ns, '1' after 120 ns, '0' after 130 ns, '1' after 150 ns;
    
    s_right <= '1' after 60 ns, '0' after 110 ns, '1' after 130 ns, '0' after 140 ns, '1' after 150 ns, '0' after 170 ns;
    
    s_haz <= '1' after 110 ns, '0' after 150 ns;
    
end Behavioral;
