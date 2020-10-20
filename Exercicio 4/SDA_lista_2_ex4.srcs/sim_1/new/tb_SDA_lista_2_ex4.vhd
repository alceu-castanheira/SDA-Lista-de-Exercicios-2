----------------------------------------------------------------------------------
-- Company: Universidade de Brasília - UnB
-- Engineer: Alceu Bernardes Castanheira de Farias
-- 
-- Create Date: 13.10.2020 01:06:00
-- Design Name: 
-- Module Name: tb_SDA_lista_2_ex4 - Behavioral
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

entity tb_SDA_lista_2_ex4 is
end tb_SDA_lista_2_ex4;

architecture Behavioral of tb_SDA_lista_2_ex4 is

    -- Declarando o componente a ser testado
    component SDA_lista_2_ex4 is
        Port ( clk : in STD_LOGIC;
               rst : in STD_LOGIC;
               s : in STD_LOGIC;
               t : in STD_LOGIC;
               p : out STD_LOGIC);
    end component SDA_lista_2_ex4;

    -- Sinais de teste a serem conectados em cada pino do componente a ser testado
    signal s_clk : std_logic := '0';
    signal s_rst : std_logic := '0';
    signal s_s : std_logic := '0';
    signal s_t : std_logic := '0';
    signal s_p : std_logic := '0';
    
begin

    -- Mapeamente dos pinos de entradas e saída do Unit Under Test (uut) a seus
    -- respectivos sinais
    uut: SDA_lista_2_ex4 port map
    (
        clk => s_clk,
        rst => s_rst,
        s => s_s,
        t => s_t,
        p => s_p
    );
    
    -- Vamos considerar o clock da simulação de 100 MHz (período de 10 ns)
    s_clk <= not s_clk after 5 ns;
    
    -- Acionando reset no início da simulação
    s_rst <= '1' after 5 ns, '0' after 15 ns;
    
    -- Estímulo para o sinal de teste da entrada s
    s_s <= '1' after 65 ns, '0' after 105 ns;
    
    -- Estímulo para o sinal de teste da entrada t
    s_t <= '1' after 35 ns, '0' after 85 ns;
    
end Behavioral;
