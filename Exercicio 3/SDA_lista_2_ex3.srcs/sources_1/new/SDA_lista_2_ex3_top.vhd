----------------------------------------------------------------------------------
-- Company: Universidade de Brasília - UnB
-- Engineer: Alceu Bernardes Castanheira de Farias
-- 
-- Create Date: 13.10.2020 14:03:18
-- Design Name: 
-- Module Name: SDA_lista_2_ex3_top - Behavioral
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

-- Top módulo do exercício 3. Saídas state_out, an e dp mapeam estado atual e clock para
-- debug no laboratório remoto
entity SDA_lista_2_ex3_top is
    Port ( clk : in STD_LOGIC;
           dp : out STD_LOGIC;
           an : out STD_LOGIC_VECTOR(3 downto 0);
           state_out: out STD_LOGIC_VECTOR(2 downto 0);
           led : out STD_LOGIC);
end SDA_lista_2_ex3_top;

architecture Behavioral of SDA_lista_2_ex3_top is

    -- Declarando todos os componentes:
    --
    -- FSM que receba a sequência de botões
    component SDA_lista_2_ex3 is
        Port ( clk : in STD_LOGIC;
               rst : in STD_LOGIC;
               s : in STD_LOGIC;
               r : in STD_LOGIC;
               b : in STD_LOGIC;
               g : in STD_LOGIC;
               a : in STD_LOGIC;
               state: out STD_LOGIC_VECTOR(2 downto 0);
               u : out STD_LOGIC);
    end component SDA_lista_2_ex3;

    -- FSM que sincroniza o aperto do botão para um pulso com duração de um ciclo de clock
    component synchro_button_FSM is
        Port ( clk : in STD_LOGIC;
               rst : in STD_LOGIC;
               bi : in STD_LOGIC;
               bo : out STD_LOGIC);
    end component synchro_button_FSM; 
    
    -- Divisor de clock para frequência de 2 Hz
    component clk_div_2Hz is
        Port ( clk : in STD_LOGIC;
               rst : in STD_LOGIC;
               clk_2Hz : out STD_LOGIC);
    end component clk_div_2Hz;
    
    -- VIO CORE para testar no laboratório remoto    
    COMPONENT vio_0
      PORT (
        clk : IN STD_LOGIC;
        probe_out0 : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
        probe_out1 : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
        probe_out2 : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
        probe_out3 : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
        probe_out4 : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
        probe_out5 : OUT STD_LOGIC_VECTOR(0 DOWNTO 0)
      );
    END COMPONENT;  
    
    -- Sinais de conexão entre componentes
    signal s_clk_2Hz : std_logic := '0';
    signal s_rst : std_logic := '0';
    
    signal s_s : std_logic := '0';
    signal s_r : std_logic := '0';
    signal s_b : std_logic := '0';
    signal s_g : std_logic := '0';

    signal s_sync_s : std_logic := '0';
    signal s_sync_r : std_logic := '0';
    signal s_sync_b : std_logic := '0';
    signal s_sync_g : std_logic := '0';

    signal s_a : std_logic := '0';
                 
begin

    -- Mapeando reset e os botões sincronizados para a FSM principal
    COLOR_DETECT: SDA_lista_2_ex3 port map
    (
        clk => s_clk_2Hz,
        rst => s_rst,
        s => s_sync_s,
        r => s_sync_r,
        b => s_sync_b,
        g => s_sync_g,
        a => s_a,
        state => state_out,
        u => led
    );

    -- Sincronizador do botão start (s)        
    SYNC_BUTTON_1: synchro_button_FSM port map
    (
        clk => s_clk_2Hz,
        rst => s_rst,
        bi => s_s,
        bo => s_sync_s
    );
    
    -- Sincronizador do botão r
    SYNC_BUTTON_2: synchro_button_FSM port map
    (
        clk => s_clk_2Hz,
        rst => s_rst,
        bi => s_r,
        bo => s_sync_r
    );

    -- Sincronizador do botão b
    SYNC_BUTTON_3: synchro_button_FSM port map
    (
        clk => s_clk_2Hz,
        rst => s_rst,
        bi => s_b,
        bo => s_sync_b
    );
    
    -- Sincronizador do botão g
    SYNC_BUTTON_4: synchro_button_FSM port map
    (
        clk => s_clk_2Hz,
        rst => s_rst,
        bi => s_g,
        bo => s_sync_g
    );
    
    -- Mapeando sinais do VIO CORE: disponibiliza rst, s, r, g, b e a no laboratório remoto
    VIO_CORE: vio_0 port map
    (
        clk => clk,
        probe_out0(0) => s_rst,
        probe_out1(0) => s_s,
        probe_out2(0) => s_r,
        probe_out3(0) => s_b,
        probe_out4(0) => s_g,
        probe_out5(0) => s_a
    );  
    
    -- Mapeando divisor de clock de 2Hz para os demais circuitos
    CLK_2HZ: clk_div_2Hz port map
    (
        clk => clk,
        rst => s_rst,
        clk_2Hz => s_clk_2Hz
    ); 
    
    -- Saídas de debug, implementam o sinal de clock no dp dos displays da Basys 3
    dp <= s_clk_2Hz;
    an <= (others => '0');
          
end Behavioral;
