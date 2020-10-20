----------------------------------------------------------------------------------
-- Company: Universidade de Bras�lai - UnB
-- Engineer: Alceu Bernardes Castanheira de Farias
-- 
-- Create Date: 13.10.2020 17:21:49
-- Design Name: 
-- Module Name: lampada_FSM - Behavioral
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

-- FSM que controla a intensidada da l�mpada: Exerc�cio 1 da Lista 2 de SDA
--
-- Entradas: clk, rst, a (entrada que modifica a intensidade quando '1' e ulink = '1'),
-- ulink (entrada proveniente da FSM detectora de sequ�ncia, permanece em '1' durante
-- 3 ciclos de clock quando a sequ�ncia correta foi inserida na FSM anterior)
--
-- Sa�das: lamp_PWM: codifica o PWM da l�mpada de acordo com o estado atual da FSM:
--
-- "00" = > L�mpada desligada
-- "01" => Intensidade baixa
-- "10" => Intensidade m�dia
-- "11" = > Intensidade alta
entity lampada_FSM is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           a : in STD_LOGIC;
           ulink : in STD_LOGIC;
           lamp_PWM : out STD_LOGIC_VECTOR (1 downto 0));
end lampada_FSM;

architecture Behavioral of lampada_FSM is

    -- Cria��o do tipo que armazena os estados da FSM
    type t_state is (off, low, medium, high);
    
    -- Sinal que armazena o pr�ximo estado da FSM, do tipo t_state, valor inicial: off
    signal next_state : t_state := off;
    
    -- Sinal que armazena o estado atual da FSM, do tipo t_state, valor inicial: off
    signal current_state : t_state := off;
        
begin

    -- Processo sequencial s�ncrono para registrar estados
    process(clk,rst)
    begin
        if rst = '1' then
            current_state <= off;
        elsif rising_edge(clk) then
            current_state <= next_state;
        end if;
    end process;    

    -- Processo combinacional para transi��o de estados 
    process(current_state, a, ulink)
    begin
    
        -- Se ulink = '1' e a='1' a l�mpada muda de intensidade. 
        -- Se isso ocorro no estado high, a l�mpada desliga.
        -- Caso contr�rio, permanece no estado atual.
        case current_state is
            when off =>
                if a = '1' and ulink = '1' then
                    next_state <= low;
                else
                    next_state <= off;
                end if;
                
            when low =>
                if a = '1' and ulink = '1' then
                    next_state <= medium;
                else
                    next_state <= low;
                end if;            
            
            when medium =>
                if a = '1' and ulink = '1' then
                    next_state <= high;
                else
                    next_state <= medium;
                end if;
                            
            when high =>
                if a = '1' then
                    next_state <= off;
                else
                    next_state <= high;
                end if;            
        end case;
    end process;
    
   -- Processo combinacional para transi��o de saida (Mealy por conta da entrada de rst) 
    process(clk, rst)
    begin
    
        -- Reset ass�ncrono, zera a sa�da
        if rst = '1' then
            lamp_PWM <= (others => '0');
            
        elsif rising_edge(clk) then
        
            -- De acordo com o estado, a sa�da recebe o valor bin�rio correspondente.
            -- Esse valor � utilizado pelo m�dulo PWM para implementar o duty cycle do
            -- LED, que se reflete na intensidade da l�mpada:
            --
            -- "00" => l�mpada desligada
            -- "01" => intensidade baixa (duty cycle = 25%)
            -- "10" => intensidade m�dia (duty cycle = 50%)
            -- "11" => intensidade alta (duty cycle = 75%)
            --
            case current_state is
            when off =>
                lamp_PWM <= "00";
                
            when low =>
                lamp_PWM <= "01";
                
            when medium =>
                lamp_PWM <= "10";

            when high =>
                lamp_PWM <= "11";
            
            -- Em caso de erro, sa�da permanece em zero.    
            when others =>
                lamp_PWM <= "00";
                
            end case;
        end if;
    end process;
        
end Behavioral;
