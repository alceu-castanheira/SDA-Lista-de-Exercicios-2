----------------------------------------------------------------------------------
-- Company: Universidade de Brasília - UnB
-- Engineer: Alceu Bernardes Castanheira de Farias
-- 
-- Create Date: 13.10.2020 18:23:20
-- Design Name: 
-- Module Name: tb_SDA_lista_2_ex1 - Behavioral
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


entity tb_SDA_lista_2_ex1 is
end tb_SDA_lista_2_ex1;

architecture Behavioral of tb_SDA_lista_2_ex1 is

    -- Componente que implementa a FSM detectora de sequência
    component SDA_lista_2_ex1 is
        Port ( clk : in STD_LOGIC;
               rst : in STD_LOGIC;
               x : in STD_LOGIC;
               hint : out STD_LOGIC;
               ulink : out STD_LOGIC);
    end component SDA_lista_2_ex1;
    
    -- Componente da FSM que controla a intensidade da lâmpada
    component lampada_FSM is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           a : in STD_LOGIC;
           ulink : in STD_LOGIC;
           lamp_PWM : out STD_LOGIC_VECTOR (1 downto 0));
    end component lampada_FSM;
    
    -- Componente que controla o PWM com a intensidade da lâmpada
    component PWM_control is
        Port ( clk : in STD_LOGIC;
               rst : in STD_LOGIC;
               PWM_duty_cycle : in STD_LOGIC_VECTOR(1 downto 0);
               PWM_out : out STD_LOGIC);
    end component PWM_control;  
    
    -- Sinais de teste e de conexão entre os componentes
    signal s_clk : std_logic := '0';
    signal s_rst : std_logic := '0';
    signal s_x : std_logic := '0';
    signal s_hint : std_logic := '0';
    signal s_ulink: std_logic := '0';
    
    signal s_a: std_logic := '0';
    signal s_duty_cycle : std_logic_vector(1 downto 0) := (others => '0');
    
    signal s_PWM_out : std_logic := '0';
      
begin

    -- Mapeando entradas e saídas da FSM detectora de sequência
    DETECT_SEQ: SDA_lista_2_ex1 port map
    (
        clk => s_clk,
        rst => s_rst,
        x => s_x,
        hint => s_hint,
        ulink => s_ulink
    );
    
    -- Mapeando entradas e saídas da FSM que controla a intensidade da lâmpada
    LAMP_CTRL: lampada_FSM port map
    (
        clk => s_clk,
        rst => s_rst,
        a => s_a,
        ulink => s_ulink,
        lamp_PWM => s_duty_cycle
    );
    
    -- Mapeando entradas e saídas do circuto de PWM
    PWM_CTRL: PWM_control port map
    (
        clk => s_clk,
        rst => s_rst,
        PWM_duty_cycle => s_duty_cycle,
        PWM_out => s_PWM_out
    );
    
    -- Na simulação consideramos o clock de todos os módulos igual a 100 MHz, para torná-la mais rápida. 
    -- O circuito implementado possui clock de 1 Hz para as FSMs (para poder testar no laboratório remoto)
    -- e o circuito PWM possui clock de 200Hz, 4x a frequência da onda de PWM propriamente dita, que permite
    -- dividir facilmente o duty cycle em 25%, 50% e 75% de acordo com a intensidade da lâmpada
    s_clk <= not s_clk after 5 ns;
    
    -- Resetando para garantir o sistema no estado inicial
    s_rst <= '1' after 5 ns, '0' after 15 ns;
    
    -- Sequência de x correta para ativar ulink e poder modificar a lâmpada. São inseridas 4 sequências corretas
    -- para modificar o estado da lâmpada:
    --
    -- Sequência 1) Ativa ulink para mudar a lâmpada de off para low
    -- Sequência 2) Ativa ulink para mudar a lâmpada de low para medium
    -- Sequência 3) Ativa ulink para mudar a lâmpada de medium para high
    -- Sequência 4) Ativa ulink para mudar a lâmpada de high para off
    --
    -- OBS: A partir da sequência 2 não é encessário mandar o primeiro x = '1', porque a última entrada de x já 
    -- havia sido '1' na sequência anterior. Isso mostra a detecção de overlap da FSM
    s_x <= '1' after 25 ns, '0' after 35 ns, '0' after 45 ns, '0' after 55 ns, '0' after 65 ns,
           '1' after 75 ns, '1' after 85 ns, '1' after 95 ns, -- Sequência 1)
           
           '0' after 225 ns, '0' after 235 ns, '0' after 245 ns, '0' after 255 ns, 
           '1' after 265 ns, '1' after 275 ns, '1' after 285 ns, -- Sequência 2)
           
           '0' after 395 ns, '0' after 405 ns, '0' after 415 ns, '0' after 425 ns, 
           '1' after 435 ns, '1' after 445 ns, '1' after 455 ns, -- Sequência 3)
           
           '0' after 605 ns, '0' after 615 ns, '0' after 625 ns, '0' after 635 ns, 
           '1' after 645 ns, '1' after 655 ns, '1' after 665 ns; -- Sequência 4)

    
    -- Quando ulink é ativo pela sequência correta de x, aciona-se a por um ciclo de clock para mudar
    -- a intensidade da lâmpada:
    -- Sequência 1) off para low
    -- Sequência 2) low para medium
    -- Sequência 3) medium para high
    -- Sequência 4) high para off                  
    s_a <= '1' after 115 ns, '0' after 125 ns, -- Sequência 1)
           '1' after 305 ns, '0' after 315 ns, -- Sequência 2)
           '1' after 475 ns, '0' after 485 ns, -- Sequência 3)
           '1' after 685 ns, '0' after 695 ns; -- Sequência 4)
               
end Behavioral;
