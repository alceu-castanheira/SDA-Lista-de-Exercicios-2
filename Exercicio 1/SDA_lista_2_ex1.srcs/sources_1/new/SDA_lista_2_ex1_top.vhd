----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 13.10.2020 17:21:49
-- Design Name: 
-- Module Name: SDA_lista_2_ex1_top - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity SDA_lista_2_ex1_top is
  Port (
    clk : in STD_LOGIC;
    dp : out STD_LOGIC;
    an : out STD_LOGIC_VECTOR(3 DOWNTO 0);
    led : out STD_LOGIC_VECTOR(2 DOWNTO 0)
   );
end SDA_lista_2_ex1_top;

architecture Behavioral of SDA_lista_2_ex1_top is

    component SDA_lista_2_ex1 is
        Port ( clk : in STD_LOGIC;
               rst : in STD_LOGIC;
               x : in STD_LOGIC;
               hint : out STD_LOGIC;
               ulink : out STD_LOGIC);
    end component SDA_lista_2_ex1;
    
    component lampada_FSM is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           a : in STD_LOGIC;
           ulink : in STD_LOGIC;
           lamp_PWM : out STD_LOGIC_VECTOR (1 downto 0));
    end component lampada_FSM;
    
    component PWM_control is
        Port ( clk : in STD_LOGIC;
               rst : in STD_LOGIC;
               PWM_duty_cycle : in STD_LOGIC_VECTOR(1 downto 0);
               PWM_out : out STD_LOGIC);
    end component PWM_control; 
    
    COMPONENT vio_0
      PORT (
        clk : IN STD_LOGIC;
        probe_out0 : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
        probe_out1 : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
        probe_out2 : OUT STD_LOGIC_VECTOR(0 DOWNTO 0));
    END COMPONENT;

    component clk_div_1Hz is
        Port ( clk : in STD_LOGIC;
               rst : in STD_LOGIC;
               clk_1Hz : out STD_LOGIC);
    end component clk_div_1Hz;

    component clk_div_200Hz is
        Port ( clk : in STD_LOGIC;
               rst : in STD_LOGIC;
               clk_200Hz : out STD_LOGIC);
    end component clk_div_200Hz;
        
    signal s_rst: STD_LOGIC := '0';
    signal s_x: STD_LOGIC := '0';
    signal s_a: STD_LOGIC := '0';
    signal s_ulink: STD_LOGIC := '0';
    
    signal s_clk_1Hz: STD_LOGIC := '0';
    signal s_clk_200Hz: STD_LOGIC := '0';
    
    signal s_duty_cycle: STD_LOGIC_VECTOR(1 downto 0) := (others => '0');
            
begin

    VIO_CORE: vio_0 port map
    (
        clk => clk,
        probe_out0(0) => s_rst,
        probe_out1(0) => s_x,
        probe_out2(0) => s_a
    );
    
    DETECT_SEQ: SDA_lista_2_ex1 port map
    (
        clk => s_clk_1Hz,
        rst => s_rst,
        x => s_x,
        hint => led(0),
        ulink => s_ulink
    );
    
    led(1) <= s_ulink;
    
    LAMP_CTRL: lampada_FSM port map
    (
        clk => s_clk_1Hz,
        rst => s_rst,
        a => s_a,
        ulink => s_ulink,
        lamp_PWM => s_duty_cycle
    );
    
    PWM_CTRL: PWM_control port map
    (
        clk => s_clk_200Hz,
        rst => s_rst,
        PWM_duty_cycle => s_duty_cycle,
        PWM_out => led(2)
    );

    CLK_1HZ: clk_div_1Hz port map
    (
        clk => clk,
        rst => s_rst,
        clk_1Hz => s_clk_1Hz
    ); 

    CLK_200HZ: clk_div_200Hz port map
    (
        clk => clk,
        rst => s_rst,
        clk_200Hz => s_clk_200Hz
    );   
    
    an <= (others => '0');
    dp <= s_clk_1Hz;
              
end Behavioral;
