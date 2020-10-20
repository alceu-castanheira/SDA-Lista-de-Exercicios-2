----------------------------------------------------------------------------------
-- Company: Universidade de Brasília - UnB
-- Engineer: Alceu Bernardes Castanheira de Farias
-- 
-- Create Date: 13.10.2020 14:38:02
-- Design Name: 
-- Module Name: tb_SDA_lista_2_ex3 - Behavioral
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

entity tb_SDA_lista_2_ex3 is
end tb_SDA_lista_2_ex3;

architecture Behavioral of tb_SDA_lista_2_ex3 is

    component SDA_lista_2_ex3 is
        Port ( clk : in STD_LOGIC;
               rst : in STD_LOGIC;
               s : in STD_LOGIC;
               r : in STD_LOGIC;
               b : in STD_LOGIC;
               g : in STD_LOGIC;
               a : in STD_LOGIC;
               state: out STD_LOGIC_VECTOR(2 DOWNTO 0);
               u : out STD_LOGIC);
    end component SDA_lista_2_ex3;
 
     component synchro_button_FSM is
        Port ( clk : in STD_LOGIC;
               rst : in STD_LOGIC;
               bi : in STD_LOGIC;
               bo : out STD_LOGIC);
    end component synchro_button_FSM; 
       
    -- Sinais de teste para cada entrada e saída do sistema
    signal s_clk: std_logic := '0';
    signal s_rst: std_logic := '0';
    signal s_s: std_logic := '0';
    signal s_r: std_logic := '0';
    signal s_b: std_logic := '0';
    signal s_g: std_logic := '0';
    signal s_a: std_logic := '0';
    signal s_u: std_logic := '0';
    
    signal s_sync_s: std_logic := '0';
    signal s_sync_r: std_logic := '0';
    signal s_sync_b: std_logic := '0';
    signal s_sync_g: std_logic := '0';
    
begin

    -- Conectando Unit Under Test (uut) aos sinais de teste
    uut: SDA_lista_2_ex3 port map
    (
        clk => s_clk,
        rst => s_rst,
        s => s_sync_s,
        r => s_sync_r,
        b => s_sync_b,
        g => s_sync_g,
        a => s_a,
        state => open,
        u => s_u
    );
    
    sync1: synchro_button_FSM port map
    (
        clk => s_clk,
        rst => s_rst,
        bi => s_s,
        bo => s_sync_s
    );

    sync2: synchro_button_FSM port map
    (
        clk => s_clk,
        rst => s_rst,
        bi => s_r,
        bo => s_sync_r
    );
    
    sync3: synchro_button_FSM port map
    (
        clk => s_clk,
        rst => s_rst,
        bi => s_b,
        bo => s_sync_b
    );
    
    sync4: synchro_button_FSM port map
    (
        clk => s_clk,
        rst => s_rst,
        bi => s_g,
        bo => s_sync_g
    );
                
    -- Realizando a simulação com um sinal de clk de 100 MHz (período de 10 ns)
    s_clk <= not s_clk after 5 ns;
    
    -- Reset no início da simulação para garantir estado inicial
    s_rst <= '1' after 5 ns, '0' after 25 ns;
    
    -- Sequência de entradas ativadas para testes:
    --
    -- 1) start, red, blue, green, red : aciona a saída u=1
    -- 2) start, blue = sequência incorreta, devemos recomeçar
    -- 3) start, red, green = sequência incorreta, devemos recomeçar
    -- 4) start, red, blue, red = sequência incorreta, devemos recomeçar
    -- 5) start, red, blue, green, blue = sequência incorreta, devemos recomeçar 
    --
    -- Start
    s_s <= '1' after 25 ns, '0' after 35 ns, --  Sequência 1) 
           '1' after 85 ns, '0' after 95 ns, -- Sequência 2)
           '1' after 105 ns, '0' after 115 ns, -- Sequência 3)
           '1' after 135 ns, '0' after 145 ns, -- Sequência 4)
           '1' after 175 ns, '0' after 185 ns; -- Sequência 5)
           
    -- Red
    s_r <= '1' after 35 ns, '0' after 45 ns, '1' after 65 ns, '0' after 75 ns, -- Sequência 1)
           '1' after 115 ns, '0' after 125 ns, -- Sequência 3) 
           '1' after 145 ns, '0' after 155 ns, '1' after 165 ns, '0' after 175 ns, -- Sequência 4) 
           '1' after 185 ns, '0' after 195 ns; -- Sequência 5) 
            
    -- Blue
    s_b <= '1' after 45 ns, '0' after 55 ns, -- Sequência 1)
           '1' after 95 ns, '0' after 105 ns, -- Sequência 2)
           '1' after 155 ns, '0' after 165 ns, -- Sequência 4)
           '1' after 195 ns, '0' after 205 ns, '1' after 215 ns, '0' after 225 ns; -- Sequência 5)
    
    -- Green
    s_g <= '1' after 55 ns, '0' after 65 ns, -- Sequência 1)
           '1' after 125 ns, '0' after 135 ns, -- Sequência 3)
           '1' after 205 ns, '0' after 215 ns; -- Sequência 5)
    
    -- O sinal a viria do painel quando um botão foi apertado. Vamos considerar que 
    -- ele sempre está em '1' nos testes, ou seja a confirmação de botão pressionado
    -- está sempre ativa.
    s_a <= '1' after 5 ns;
    
end Behavioral;
