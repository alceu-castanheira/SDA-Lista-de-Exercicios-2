----------------------------------------------------------------------------------
-- Company: Universidade de Bras�lia - UnB
-- Engineer: Alceu Bernardes Castanheira de Farias
-- 
-- Create Date: 13.10.2020 13:35:54
-- Design Name: 
-- Module Name: SDA_lista_2_ex3 - Behavioral
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

-- Exerc�cio 3 da lista 2 de SDA.
-- Entradas: clk, rst, s (bot�o de start), r (bot�o vermelho), b (bot�o azul),
-- g (bot�o verde), a (sinal do painel que indica que um bot�o foi apertado)
--
-- Sa�das: state (sa�da de debug que armazena o estado atual) e u (ativa quando
-- a sequ�ncia r,b,g,r � informada por meio das entradas)
entity SDA_lista_2_ex3 is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           s : in STD_LOGIC;
           r : in STD_LOGIC;
           b : in STD_LOGIC;
           g : in STD_LOGIC;
           a : in STD_LOGIC;
           state: out STD_LOGIC_VECTOR(2 DOWNTO 0);
           u : out STD_LOGIC);
end SDA_lista_2_ex3;

architecture Behavioral of SDA_lista_2_ex3 is

    -- Cria��o do tipo que armazena os estados da FSM
    type t_state is (idle, start, red1, blue1, green1, red2);
    
    -- Sinal que armazena o pr�ximo estado da FSM, do tipo t_state, valor inicial: idle
    signal next_state : t_state := idle;
    
    -- Sinal que armazena o estado atual da FSM, do tipo t_state, valor inicial: idle
    signal current_state : t_state := idle;
    
begin

    -- Processo sequencial s�ncrono para registrar estados
    process(clk,rst)
    begin
        if rst = '1' then
            current_state <= idle;
        elsif rising_edge(clk) then
            current_state <= next_state;
        end if;
    end process;    

    -- Processo combinacional para transi��o de estados 
    process(current_state, s, r, b, g, a)
    begin
        case current_state is
            when idle =>
            
                -- Se s = '1', prosseguir para o estado start. Caso contr�rio, permanecer em idle.
                if s = '1' then
                    next_state <= start;
                else
                    next_state <= idle;
                end if;
                
            -- Se a = '1' (algum bot�o foi pressionado) e esse bot�o foi r, prosseguir para red1. Se
            -- n�o for r, retornar a idle. Caso contr�rio, ficar em start (transi��es corrigidas de
            -- acordo com os v�deos e exemplo de Vahid.)    
            when start => 
                if a = '1' and r = '1' and b = '0' and g = '0' then
                    next_state <= red1;
                elsif a = '1' and (r = '0' or b = '1' or g = '1') then
                    next_state <= idle;
                else
                    next_state <= start;
                end if;

            -- Se a = '1' (algum bot�o foi pressionado) e esse bot�o foi b, prosseguir para blue1. Se
            -- n�o for b, retornar a idle. Caso contr�rio, ficar em red1 (transi��es corrigidas de
            -- acordo com os v�deos e exemplo de Vahid.)   
            when red1 => 
                if a = '1' and r = '0' and b = '1' and g = '0' then
                    next_state <= blue1;
                elsif a = '1' and (r = '1' or b = '0' or g = '1') then
                    next_state <= idle;
                else
                    next_state <= red1;
                end if;

            -- Se a = '1' (algum bot�o foi pressionado) e esse bot�o foi g, prosseguir para green1. Se
            -- n�o for g, retornar a idle. Caso contr�rio, ficar em blue1 (transi��es corrigidas de
            -- acordo com os v�deos e exemplo de Vahid.)  
            when blue1 => 
                if a = '1' and r = '0' and b = '0' and g = '1' then
                    next_state <= green1;
                elsif a = '1' and (r = '1' or b = '1' or g = '0') then
                    next_state <= idle;
                else
                    next_state <= blue1;
                end if;

            -- Se a = '1' (algum bot�o foi pressionado) e esse bot�o foi r, prosseguir para red2. Se
            -- n�o for r, retornar a idle. Caso contr�rio, ficar em green1 (transi��es corrigidas de
            -- acordo com os v�deos e exemplo de Vahid.)    
             when green1 => 
                if a = '1' and r = '1' and b = '0' and g = '0' then
                    next_state <= red2;
                elsif a = '1' and (r = '0' or b = '1' or g = '1') then
                    next_state <= idle;
                else
                    next_state <= green1;
                end if;

            -- Se o sistema chegou em red2, fim da sequ�ncia de bot�es coloridos. Retornar para idle
            when red2 =>
                next_state <= idle;
            
            -- Em caso de erro, permanecer em idle                                                    
            when others=>
                next_state <= idle;
                
        end case;
    end process;
    
    -- Processo combinacional para transi��o de saida (Mealy por conta da entrada de rst) 
    process(clk, rst)
    begin
    
        -- Reset ass�ncrono reiniciando as sa�das
        if rst = '1' then
            u <= '0';
            state <= "001";
            
        -- Caso contr�rio na borda de subida do clock:
        -- u s� vai para 1 no estado red2(sequ�ncia correta)
        -- state � usado para debug e assume um valor para indicar o estado atual 
        --   
        elsif rising_edge(clk) then
            case current_state is
                when idle =>
                    u <= '0';
                    state <= "001";
                when start =>
                    u <= '0';
                    state <= "010";
                when red1 =>
                    u <= '0';
                     state <= "011";                   
                when blue1 =>
                    u <= '0';
                    state <= "100";                    
                when green1 =>
                    u <= '0';
                     state <= "101";                   
                when red2 =>
                    u <= '1';
                    state <= "110";
                    
                -- Em caso de erro, state recebe "111" (estado n�o mapeado) e u permanece em '0'.                    
                when others =>
                    u <= '0';
                    state <= "111";                    
            end case;
        end if;
    end process;
        
end Behavioral;
