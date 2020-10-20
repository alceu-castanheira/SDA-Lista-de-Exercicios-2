----------------------------------------------------------------------------------
-- Company: Universidade de Bras�lia - UnB
-- Engineer: Alceu Bernardes Castanheira de Farias
-- 
-- Create Date: 13.10.2020 00:55:48
-- Design Name: 
-- Module Name: SDA_lista_2_ex4 - Behavioral
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

-- Exerc�cio 4 da Lista 2 de SDA
--
-- Entradas: clk, rst, s (cora��o contraiu = '1', cora��o n�o contraiu = '0'), t (entrada
-- de um timer que conta o intervalo de 1 segundo para contra��o do cora��o)
--
-- Sa�das: sa�da do marcapsso p (p='1' marcapasso mandando um pulso porque o cora��o n�o contraiu,
-- p = '0' indica que o marcapasso n�o precisou atuar).
-- 
entity SDA_lista_2_ex4 is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           s : in STD_LOGIC;
           t : in STD_LOGIC;
           p : out STD_LOGIC);
end SDA_lista_2_ex4;

architecture Behavioral of SDA_lista_2_ex4 is

    -- Tipo dos estados da FSM
    type t_state is (s0, s1, s2, s3);
    
    -- Sinal que armazena o pr�ximo estado da FSM. Valor inicial : s0
    signal next_state : t_state := s0;
    
    -- Sinal que armazena o estado atual da FSM. Valor inicial: s0
    signal current_state : t_state := s0;
    
begin

    --Processo sequencial s�ncrono para registrar estados
    process(clk,rst)
    begin
        if rst = '1' then
            current_state <= s0;
        elsif rising_edge(clk) then
            current_state <= next_state;
        end if;
    end process;    

    -- Processo combinaacional para transi��o de estados 
    process(current_state, s, t)
    begin
    
        -- De acordo com o valor atual do estado (current_state) e das entradas st,
        -- next_state recebe um estado espec�fico:
        case current_state is
        
            -- Em s0, o sistema vai direto para s1
            when s0 =>
                next_state <= s1;
            
            -- Em s1:
            --
            -- Para s='0'(cora��o n�o contraiu) e t='1'(intervalo entre contra��es
            -- atingido pelo timer), o sistema vai para s2
            -- Para s='0'(cora��o n�o contraiu) e t='0'(intervalo entre contra��es
            -- n�o foi atingido pelo timer, o sistema vai para s0)
            -- Caso contr�rio, o cora��o contraiu e o sistema fica agurdando no
            -- estado s1 
            when s1 =>
                if s = '0' and t = '1' then
                    next_state <= s2;
                elsif s = '0' and t = '0' then
                    next_state <= s0;
                else
                    next_state <= s1; 
                end if;
            
            -- No estado s2, o sistema vai direto para s3
            when s2 =>
                next_state <= s3;

            -- No estado de transi��o s3, o sistema retorna diretamente para o
            -- estado s0
            when s3 =>
                next_state <= s0;
                                
            when others =>
                next_state <= s0;    
 
        end case;
    end process;
    
    -- Processo combinacional para transi��o de sa�da (Mealy) 
    process(clk, rst)
    begin
    
        -- Reset = '1' mantem a sa�da em '0'
        if rst = '1' then
           p <= '0';
           
        -- Caso contr�rio, na borda de subida de clock
        elsif rising_edge(clk) then
            case current_state is
                
                -- No estado s0, a sa�da � sempre mantida em '0'
                when s0 =>
                    p <= '0';
                
                -- No estado s1, se a entrada s = '0' (cora��o n�o contrai)
                -- e t = '1' (intervalo entre contra��es foi atingido pelo timer),
                -- a sa�da p = '1'. Caso contr�rio, p = '0'   
                when s1 =>
                    
                    if s = '0' and t = '1' then
                        p <= '1';
                    else
                        p <= '0';
                    end if;
                
                -- No estado s2, p = '0' 
                when s2 => 
                    p <= '0';

                -- No estado s3, p = '0' 
                when s3 => 
                    p <= '0';

                -- Em caso de erro, p = '0'                                     
                when others =>
                    p <= '0';
                    
            end case;
        end if;
    end process;    
    
end Behavioral;
