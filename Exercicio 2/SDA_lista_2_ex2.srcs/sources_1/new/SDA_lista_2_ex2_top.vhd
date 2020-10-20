----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 13.10.2020 00:14:38
-- Design Name: 
-- Module Name: SDA_lista_2_ex2_top - Behavioral
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

-- Top módulo do exercício 2 da lista 2 de SDA
--
-- Entradas: clk
--
-- Saídas: lights (8 LEDs que compõem 4 luzes da esquerda (bits mais significativos) e 4 luzes
-- da direita (bits menos significativos))
--
entity SDA_lista_2_ex2_top is
    Port ( clk : in STD_LOGIC;
           lights : out STD_LOGIC_VECTOR (7 downto 0));
end SDA_lista_2_ex2_top;

architecture Behavioral of SDA_lista_2_ex2_top is

    -- FSM do exercício 2
    component SDA_lista_2_ex2 is
        Port ( clk : in STD_LOGIC;
               rst : in STD_LOGIC;
               left : in STD_LOGIC;
               right : in STD_LOGIC;
               haz : in STD_LOGIC;
               lights : out STD_LOGIC_VECTOR (7 downto 0));
    end component SDA_lista_2_ex2;
    
    -- Divisor de clock de 1Hz para testar no laboratório remoto
    component clk_div_1Hz is
        Port ( clk : in STD_LOGIC;
               rst : in STD_LOGIC;
               clk_1Hz : out STD_LOGIC);
    end component clk_div_1Hz;
    
    -- VIO CORE para testar no laboratório remoto
    COMPONENT vio_0
      PORT (
        clk : IN STD_LOGIC;
        probe_out0 : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
        probe_out1 : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
        probe_out2 : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
        probe_out3 : OUT STD_LOGIC_VECTOR(0 DOWNTO 0)
      );
    END COMPONENT;

    -- Sinais de conexão do sistema
    signal s_clk_1Hz : std_logic := '0';
    signal s_rst : std_logic := '0';
    signal s_left : std_logic := '0';
    signal s_right : std_logic := '0';
    signal s_haz : std_logic := '0';
    
begin

    -- Mapeando VIO CORE
    VIO_CORE: vio_0 port map
    (
        clk => clk,
        probe_out0(0) => s_rst,
        probe_out1(0) => s_left,
        probe_out2(0) => s_right,
        probe_out3(0) => s_haz
    );
    
    -- Mapeando divisor de frequência de 1Hz
    CLK_1HZ: clk_div_1Hz port map
    (
        clk => clk,
        rst => s_rst,
        clk_1Hz => s_clk_1Hz
    );    
    
    -- Mapeando FSM que controla o painel de luzes de um Thunderbird modificado
    THUNDERBIRD_LIGHTS: SDA_lista_2_ex2 port map
    (
        clk => s_clk_1Hz,
        rst => s_rst,
        left => s_left,
        right => s_right,
        haz => s_haz,
        lights => lights
    );
    
end Behavioral;
