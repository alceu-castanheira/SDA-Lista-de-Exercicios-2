----------------------------------------------------------------------------------
-- Company: Universidade de Brasília - UnB
-- Engineer: Alceu Bernardes Castanheira de Farias
-- 
-- Create Date: 13.10.2020 13:35:54
-- Design Name: 
-- Module Name: synchro_button_FSM - Behavioral
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

entity synchro_button_FSM is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           bi : in STD_LOGIC;
           bo : out STD_LOGIC);
end synchro_button_FSM;

architecture Behavioral of synchro_button_FSM is

    -- Criação do tipo que armazena os estados da FSM
    type t_state is (idle, pressed_button, wait_button);
    
    -- Sinal que armazena o próximo estado da FSM, do tipo t_state, valor inicial: idle
    signal next_state : t_state := idle;
    
    -- Sinal que armazena o estado atual da FSM, do tipo t_state, valor inicial: idle
    signal current_state : t_state := idle;
    
begin

    -- Processo sequencial síncrono para registrar estados
    process(clk,rst)
    begin
        if rst = '1' then
            current_state <= idle;
        elsif rising_edge(clk) then
            current_state <= next_state;
        end if;
    end process;
    
    -- Processo combinacional para transição de estados 
    process(current_state, bi)
    begin
        case current_state is
            when idle =>
                if bi = '1' then
                    next_state <= pressed_button;
                else
                    next_state <= idle;
                end if;
                
            when pressed_button =>
                if bi = '1' then
                    next_state <= wait_button;
                else
                    next_state <= idle;
                end if;
                
            when wait_button =>
                if bi = '0' then
                    next_state <= idle;
                else
                    next_state <= wait_button;
                end if;
            
            when others =>
                next_state <= idle;
                                    
        end case;
    end process;

    -- Processo combinacional para transição de saida (Mealy por conta da entrada de rst) 
    process(clk, rst)
    begin
        if rst = '1' then
            bo <= '0';            
        elsif rising_edge(clk) then
            case current_state is
                when idle =>
                    bo <= '0';
                when pressed_button =>
                    bo <= '1';
                when wait_button =>
                    bo <= '0';
                when others =>
                    bo <= '0';
            end case;
        end if;
    end process;
end Behavioral;
