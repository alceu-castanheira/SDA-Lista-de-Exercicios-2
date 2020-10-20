----------------------------------------------------------------------------------
-- Company: Universidade de Bras�lia - UnB
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

    -- Componente que implementa a FSM detectora de sequ�ncia
    component SDA_lista_2_ex1 is
        Port ( clk : in STD_LOGIC;
               rst : in STD_LOGIC;
               x : in STD_LOGIC;
               hint : out STD_LOGIC;
               ulink : out STD_LOGIC);
    end component SDA_lista_2_ex1;
    
    -- Componente da FSM que controla a intensidade da l�mpada
    component lampada_FSM is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           a : in STD_LOGIC;
           ulink : in STD_LOGIC;
           lamp_PWM : out STD_LOGIC_VECTOR (1 downto 0));
    end component lampada_FSM;
    
    -- Componente que controla o PWM com a intensidade da l�mpada
    component PWM_control is
        Port ( clk : in STD_LOGIC;
               rst : in STD_LOGIC;
               PWM_duty_cycle : in STD_LOGIC_VECTOR(1 downto 0);
               PWM_out : out STD_LOGIC);
    end component PWM_control;  
    
    -- Sinais de teste e de conex�o entre os componentes
    signal s_clk : std_logic := '0';
    signal s_rst : std_logic := '0';
    signal s_x : std_logic := '0';
    signal s_hint : std_logic := '0';
    signal s_ulink: std_logic := '0';
    
    signal s_a: std_logic := '0';
    signal s_duty_cycle : std_logic_vector(1 downto 0) := (others => '0');
    
    signal s_PWM_out : std_logic := '0';
      
begin

    -- Mapeando entradas e sa�das da FSM detectora de sequ�ncia
    DETECT_SEQ: SDA_lista_2_ex1 port map
    (
        clk => s_clk,
        rst => s_rst,
        x => s_x,
        hint => s_hint,
        ulink => s_ulink
    );
    
    -- Mapeando entradas e sa�das da FSM que controla a intensidade da l�mpada
    LAMP_CTRL: lampada_FSM port map
    (
        clk => s_clk,
        rst => s_rst,
        a => s_a,
        ulink => s_ulink,
        lamp_PWM => s_duty_cycle
    );
    
    -- Mapeando entradas e sa�das do circuto de PWM
    PWM_CTRL: PWM_control port map
    (
        clk => s_clk,
        rst => s_rst,
        PWM_duty_cycle => s_duty_cycle,
        PWM_out => s_PWM_out
    );
    
    -- Na simula��o consideramos o clock de todos os m�dulos igual a 100 MHz, para torn�-la mais r�pida. 
    -- O circuito implementado possui clock de 1 Hz para as FSMs (para poder testar no laborat�rio remoto)
    -- e o circuito PWM possui clock de 200Hz, 4x a frequ�ncia da onda de PWM propriamente dita, que permite
    -- dividir facilmente o duty cycle em 25%, 50% e 75% de acordo com a intensidade da l�mpada
    s_clk <= not s_clk after 5 ns;
    
    -- Resetando para garantir o sistema no estado inicial
    s_rst <= '1' after 5 ns, '0' after 15 ns;
    
    -- Sequ�ncia de x correta para ativar ulink e poder modificar a l�mpada. S�o inseridas 4 sequ�ncias corretas
    -- para modificar o estado da l�mpada:
    --
    -- Sequ�ncia 1) Ativa ulink para mudar a l�mpada de off para low
    -- Sequ�ncia 2) Ativa ulink para mudar a l�mpada de low para medium
    -- Sequ�ncia 3) Ativa ulink para mudar a l�mpada de medium para high
    -- Sequ�ncia 4) Ativa ulink para mudar a l�mpada de high para off
    --
    -- OBS: A partir da sequ�ncia 2 n�o � encess�rio mandar o primeiro x = '1', porque a �ltima entrada de x j� 
    -- havia sido '1' na sequ�ncia anterior. Isso mostra a detec��o de overlap da FSM
    s_x <= '1' after 25 ns, '0' after 35 ns, '0' after 45 ns, '0' after 55 ns, '0' after 65 ns,
           '1' after 75 ns, '1' after 85 ns, '1' after 95 ns, -- Sequ�ncia 1)
           
           '0' after 225 ns, '0' after 235 ns, '0' after 245 ns, '0' after 255 ns, 
           '1' after 265 ns, '1' after 275 ns, '1' after 285 ns, -- Sequ�ncia 2)
           
           '0' after 395 ns, '0' after 405 ns, '0' after 415 ns, '0' after 425 ns, 
           '1' after 435 ns, '1' after 445 ns, '1' after 455 ns, -- Sequ�ncia 3)
           
           '0' after 605 ns, '0' after 615 ns, '0' after 625 ns, '0' after 635 ns, 
           '1' after 645 ns, '1' after 655 ns, '1' after 665 ns; -- Sequ�ncia 4)

    
    -- Quando ulink � ativo pela sequ�ncia correta de x, aciona-se a por um ciclo de clock para mudar
    -- a intensidade da l�mpada:
    -- Sequ�ncia 1) off para low
    -- Sequ�ncia 2) low para medium
    -- Sequ�ncia 3) medium para high
    -- Sequ�ncia 4) high para off                  
    s_a <= '1' after 115 ns, '0' after 125 ns, -- Sequ�ncia 1)
           '1' after 305 ns, '0' after 315 ns, -- Sequ�ncia 2)
           '1' after 475 ns, '0' after 485 ns, -- Sequ�ncia 3)
           '1' after 685 ns, '0' after 695 ns; -- Sequ�ncia 4)
               
end Behavioral;
