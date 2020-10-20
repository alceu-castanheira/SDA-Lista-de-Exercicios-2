----------------------------------------------------------------------------------
-- Company: Universidade de Brasília - UnB
-- Engineer: Alceu Bernardes Castanheira de Farias
-- 
-- Create Date: 12.10.2020 23:06:16
-- Design Name: 
-- Module Name: SDA_lista_2_ex2 - Behavioral
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

entity SDA_lista_2_ex2 is
    Port ( 
           -- Entrada de clock
           clk : in STD_LOGIC;
           
           -- Entrada de reset
           rst : in STD_LOGIC;
           
           -- Entrada que indica a intenção de realizar uma curva à esquerda
           left : in STD_LOGIC;
           
           -- Entrada que indica a intenção de realizar uma curva à direita
           right : in STD_LOGIC;
           
           -- Entrada de psica-alerta
           haz : in STD_LOGIC;
           
           -- Vetor de saída de 8 bits com as 4 luzes de cada lado:
           -- (4 bits mais significativos = luzes da esquerda, 4 bits menos significativos = luzes da direita)
           lights : out STD_LOGIC_VECTOR (7 downto 0));
end SDA_lista_2_ex2;

architecture Behavioral of SDA_lista_2_ex2 is

    -- Criação do tipo que armazena os estados da FSM
    type t_state is (idle, l1, l2, l3, l4, r1, r2, r3, r4, lr4);
    
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

    -- Processo combinacional para transicao de estados 
    process(current_state, left, right, haz)
    begin
        case current_state is
        
            -- No estado inicial, verificam-se as entradas left, right e haz:
            --
            -- Haz tem prioridade sobre as demais. Se left e right forem acionadas
            -- ao mesmo tempo, o pisca-alerta também é acionado (next_state <= lr4).
            -- Se haz não está ativado, left = '1' e right = '0', inicia-se o
            -- ciclo de luzes da esquerda (l1, l2, l3, l4)
            -- Se haz não está ativado, left = '0' e right = '1', inicia-se o
            -- ciclo de luzes da direita (r1, r2, r3, r4)
            when idle =>
                
                if haz = '1' or (left = '1' and right = '1') then
                    next_state <= lr4;
                elsif haz = '0' and left = '1' and right = '0' then
                    next_state <= l1;
                elsif haz = '0' and left = '0' and right = '1' then
                    next_state <= r1;
                else
                    next_state <= idle;
                end if;
            
            -- A sequência de luzes à esquerda segue a sequência l1 -> l2 -> l3 -> l4 -> idle,
            -- a não ser que haz seja ativada no meio do processo, levando o sistema ao estado
            -- lr4.  
            when l1 => 
            
                if haz = '1' then
                    next_state <= lr4;
                else
                    next_state <= l2;
                end if;
                
            when l2 => 
                
                if haz = '1' then
                    next_state <= lr4;
                else
                    next_state <= l3;
                end if;
                           
            when l3 => 

                if haz = '1' then
                    next_state <= lr4;
                else
                    next_state <= l4;
                end if;
            
            -- l4 vai direto para idle. Se haz for ativado, a condição é julgada no estado idle.                
            when l4 => 
                next_state <= idle;

            -- A sequência de luzes à direita segue a sequência r1 -> r2 -> r3 -> r4 -> idle,
            -- a não ser que haz seja ativada no meio do processo, levando o sistema ao estado
            -- lr4.                             
            when r1 => 

                if haz = '1' then
                    next_state <= lr4;
                else
                    next_state <= r2;
                end if;
                            
            when r2 => 

                if haz = '1' then
                    next_state <= lr4;
                else
                    next_state <= r3;
                end if;
                            
            when r3 => 
         
                if haz = '1' then
                    next_state <= lr4;
                else
                    next_state <= r4;
                end if;

            -- l4 vai direto para idle. Se haz for ativado, a condição é julgada no estado idle.                            
            when r4 => 
                next_state <= idle;
            
            -- No estado lr4, o sistema volta para idle, onde verifica se o pisca-alerta ainda
            -- está ativado (haz = '1')  
            when lr4 =>
                next_state <= idle;
            
            -- Em caso de erro, permaneça em idle     
            when others=>
                next_state <= idle;
                
        end case;
    end process;
    
    -- Processo combinacional para transicao de saida (Mealy por conta da entrada de rst) 
    process(clk, rst)
    begin
    
        -- Se rst = '1', manter as luzes desligadas
        if rst = '1' then
            lights <= (others => '0');
            
        elsif rising_edge(clk) then
            case current_state is
            
                -- No estado inicial, as luzes estão desligadas
                when idle =>
                    lights <= (others => '0');
                
                -- Em l1, a primeira luz da esquerda é ligada    
                when l1 =>
                    lights <= "00010000";
                
                -- Em l2, as duas primeiras luzes da esquerda são ligadas     
                when l2 => 
                    lights <= "00110000";
                
                -- Em l3, as três primeiras luzes da esquerda são ligadas
                when l3 => 
                    lights <= "01110000";
                
                -- Em l4, todas as luzes da esquerda são ligadas
                when l4 => 
                    lights <= "11110000";
                
                -- Em r1, a primeira luz da direita é ligada
                when r1 => 
                    lights <= "00001000";
                
                -- Em r2, as duas primeiras luzes da direita são ligadas
                when r2 => 
                    lights <= "00001100";
                
                -- Em r3, as três primeira luz da direita são ligadas
                when r3 => 
                    lights <= "00001110";
                
                -- Em r4, todas as luzes da direita são ligadas    
                when r4 =>
                    lights <= "00001111";
                
                -- Em lr4, todas as luzes (da esquerda e da direita) são ligadas    
                when lr4 => 
                    lights <= (others => '1');
                
                -- Em caso de erro, mantenha as luzes desligadas
                when others =>
                    lights <= (others => '0');
                    
            end case;
        end if;
    end process;
    
end Behavioral;