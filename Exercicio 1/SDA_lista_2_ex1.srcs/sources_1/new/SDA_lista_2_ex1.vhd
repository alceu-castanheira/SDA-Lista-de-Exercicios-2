----------------------------------------------------------------------------------
-- Company: Universidade de Brasília - UnB
-- Engineer: Alceu Bernardes Castanheira de Farias
-- 
-- Create Date: 13.10.2020 17:21:49
-- Design Name: 
-- Module Name: SDA_lista_2_ex1 - Behavioral
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

-- Exercício 1 da lista 2 de SDA:
--
-- Entradas: clk, rst, x (entrada que introduz a sequência na FSM)
--
-- Saídas: hint (hint = '1' se a entrada x atual corresponde ao bit correto da sequência)
--         ulink (se a sequência foi correta, permanece em '1' por três ciclos de clock
--         para habilitar a FSM que controla a intensidade da lâmpada).
--
entity SDA_lista_2_ex1 is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           x : in STD_LOGIC;
           hint : out STD_LOGIC;
           ulink : out STD_LOGIC);
end SDA_lista_2_ex1;

architecture Behavioral of SDA_lista_2_ex1 is

    -- Criação do tipo que armazena os estados da FSM
    type t_state is (e0, e1, e2, e3, e4, e5, e6, e7, e8);
    
    -- Sinal que armazena o próximo estado da FSM, do tipo t_state, valor inicial: e0
    signal next_state : t_state := e0;
    
    -- Sinal que armazena o estado atual da FSM, do tipo t_state, valor inicial: e0
    signal current_state : t_state := e0;
    
    -- Contador para manter a saída ULINK em '1' por três ciclos de clock, ao final da 
    -- sequência correta 
    signal s_count : std_logic_vector(1 downto 0) := (others => '0');
    
begin

    -- Processo sequencial síncrono para registrar estados
    process(clk,rst)
    begin
        if rst = '1' then
            current_state <= e0;
        elsif rising_edge(clk) then
            current_state <= next_state;
        end if;
    end process;    

    -- Processo combinacional para transição de estados 
    process(current_state, x, s_count)
    begin
    
        -- O circuito vai transitar de e0 a e8 se a sequência correta for introduzida no sistema
        -- pela entrada x: (135)   = "10000111". Se a entrada x for incorreta em algum estado,
        --                      10
        -- o sistema volta para o estado adequado, de acordo com a sequência armazenada até o 
        -- momento do erro (overlap)
        case current_state is
            when e0 =>
                if x = '1' then
                    next_state <= e1;
                else
                    next_state <= e0;
                end if;
                
            when e1 =>
                if x = '0' then
                    next_state <= e2;
                else
                    next_state <= e1;
                end if;
                
            when e2 =>
                if x = '0' then
                    next_state <= e3;
                else
                    next_state <= e1;
                end if;

            when e3 =>
                if x = '0' then
                    next_state <= e4;
                else
                    next_state <= e1;
                end if;
                
            when e4 =>
                if x = '0' then
                    next_state <= e5;
                else
                    next_state <= e1;
                end if;             
                
            when e5 =>
                if x = '1' then
                    next_state <= e6;
                else
                    next_state <= e0;
                end if;

            when e6 =>
                if x = '1' then
                    next_state <= e7;
                else
                    next_state <= e2;
                end if;

            when e7 =>
                if x = '1' then
                    next_state <= e8;
                else
                    next_state <= e2;
                end if;             
            
            -- Em e8, a sequência correta foi inserida. O sistema fica durante três ciclos de clock
            -- em e8, por meio do sinal s_count modificado no próximo processo, para manter ulink = '1' durante 
            -- três ciclos de clock
            when e8 =>
                if s_count = "10" then
                    next_state <= e0;
                else
                    next_state <= e8;
                end if;             
            
            -- Em caso de erro, vá para e0    
            when others =>
                next_state <= e0;
                                                             
        end case;
    end process;

   -- Processo combinacional para transição de saida (Mealy por conta da entrada de rst) 
    process(clk, rst, x)
    begin
        if rst = '1' then
            hint <= '0';
            ulink <= '0';
        
        -- Sempre que o usuário acerta a sequência por meio da entrada x, hint = '1'. Caso
        -- contrário, hint = '0'.    
        elsif rising_edge(clk) then
            case current_state is
             when e0 =>
                if x = '1' then
                    hint <= '1';
                else
                    hint <= '0';
                end if;
                
                ulink <= '0';
                s_count <= (others => '0');
                
            when e1 =>
                if x = '0' then
                    hint <= '1';
                else
                    hint <= '0';
                end if;
                
            when e2 =>
                if x = '0' then
                    hint <= '1';
                else
                    hint <= '0';
                end if;

            when e3 =>
                if x = '0' then
                    hint <= '1';
                else
                    hint <= '0';
                end if;
                
            when e4 =>
                if x = '0' then
                    hint <= '1';
                else
                    hint <= '0';                    
                end if;             
                
            when e5 =>
                if x = '1' then
                    hint <= '1';
                else
                    hint <= '0';
                end if;

            when e6 =>
                if x = '1' then
                    hint <= '1';
                else
                    hint <= '0';                    
                end if;

            when e7 =>
                if x = '1' then
                    hint <= '1';
                else
                    hint <= '0';                    
                end if;             
            
            -- Em e8, a sequência correta foi inserida. Ulink permanece em '1' durante três ciclos de
            -- clock, enquanto o sinal s_count não alcança o valor binário "10". Hint fica em '0'.    
            when e8 =>
            
                    ulink <= '1';
                    s_count <= std_logic_vector(unsigned(s_count) + 1);           
            
                hint <= '0';
            
            -- Em caso de erro, hint e ulink permanecem em '0'.    
            when others =>
                hint <= '0';
                ulink <= '0';
                          
            end case;
        end if;
    end process;
    
end Behavioral;
