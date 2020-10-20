----------------------------------------------------------------------------------
-- Company: Universidade de Brasília - UnB
-- Engineer: Alceu Bernardes Castanheira de Farias
-- 
-- Create Date: 13.10.2020 17:21:49
-- Design Name: 
-- Module Name: PWM_control - Behavioral
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

-- Circuito que controle e implementa PWM da lâmpada
--
-- Entradas: clk, rst, PWM_duty_cycle (entrada proveniente da FSM que controla a 
-- intensidade da lâmpada)
--
-- Saídas: PWM_out (sinal de PWM que se conecta a um LED)
--
entity PWM_control is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           PWM_duty_cycle : in STD_LOGIC_VECTOR(1 downto 0);
           PWM_out : out STD_LOGIC);
end PWM_control;

architecture Behavioral of PWM_control is

    -- Frequência do PWM = 50 Hz. O clock do sistema será de 200 Hz, que é 4x a frequência do
    -- PWM. Assim, cada valor de um contador com frequência 200 Hz, corresponde a 1/4 da 
    -- frequência total, de forma que cada estágio da contagem corresponde a 25% de duty cycle
    -- e, consequentemente a um estado de intensidade da lâmpada:
    --
    -- Valor da constante para intensidade baixa: 1
    constant C_LOW_FREQ: std_logic_vector(1 downto 0) := "01"; 
     
    -- Valor da constante para intensidade média: 2
    constant C_MEDIUM_FREQ: std_logic_vector(1 downto 0) := "10"; -- 25
    
    -- Valor da constante para intensidade alta: 3
    constant C_HIGH_FREQ: std_logic_vector(1 downto 0) := "11"; -- 38
    
    -- Contador utilizado para implementar o sinal de PWM modulado de acordo com a intensidade da lâmpada    
    signal s_count : std_logic_vector(1 downto 0) := (others => '0'); 
    
    -- Sinal que armazena o valor do duty cycle do sinal de PWM de acordo com a intensidade da lâmpada
    signal s_duty_cycle : std_logic_vector(1 downto 0) := (others => '0');
    
    -- Sinal que armazena a onda de PWM gerada pelo circuito
    signal s_PWM_out : std_logic := '0';
    
begin

    -- Processo combinacional que atribui o duty cycle do sinal de PWM de acordo com a intensidade da lãmpada
    DUTY_CYCLE_PROC: process(PWM_duty_cycle)
    begin
        case PWM_duty_cycle is
            when "00" =>
                s_duty_cycle <= (others => '0');
            
            when "01" =>
                s_duty_cycle <= C_LOW_FREQ;
                     
            when "10" =>
                s_duty_cycle <= C_MEDIUM_FREQ;
                            
            when "11" =>
                s_duty_cycle <= C_HIGH_FREQ;
            
            when others =>
                s_duty_cycle <= (others => '0');        
        end case;
    end process;
    
    -- Processo sequencial que realiza a contagem de 0 até 3 (como o valor final de contagem
    -- é 3 e o sinal de contagem tem 2 bits, o sistema reinicia a contagem automaticamente).
    COUNT_PROC: process(clk, rst, s_count)
    begin
        if rst = '1' then
            s_count <= (others => '0');
        elsif rising_edge(clk) then
                s_count <= std_logic_vector(unsigned(s_count) + 1);
         end if;
    end process;

    -- Processo sequencial que cria o sinal PWM com duty cycle determinado pelo sinal s_duty_cycle,
    -- e consequentemente, pela intensidade da lâmpada
    PWM_CONTROLLER: process(clk,rst)
    begin
        if rst = '1' then
            s_PWM_out <= '0';
        elsif rising_edge(clk) then
            if s_count < s_duty_cycle then
                s_PWM_out <= '1';
            else
                s_PWM_out <= '0';
            end if;
        end if;
    end process;    
    
    -- Atribuindo o sinal s_PWM_out à saída PWM_out
    PWM_out <= s_PWM_out;
    
end Behavioral;
