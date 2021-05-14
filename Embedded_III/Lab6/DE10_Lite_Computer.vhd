library ieee;
use ieee.std_logic_1164.all;

entity DE10_Lite_Computer is
port (
    --Clock pins
    CLOCK_50, CLOCK2_50, CLOCK_ADC_10 : in std_logic;

    -- ARDUINO
    ARDUINO_IO : inout std_logic_vector(15 downto 0);
    ARDUINO_RESET_N : inout std_logic;
    
    -- SDRAM
    DRAM_ADDR : out std_logic_vector(12 downto 0);
    DRAM_BA : out std_logic_vector(1 downto 0);
    DRAM_CAS_N : out std_logic;
    DRAM_CKE : out std_logic;
    DRAM_CLK : out std_logic;
    DRAM_CS_N : out std_logic;
    DRAM_DQ: inout std_logic_vector(15 downto 0);
    DRAM_LDQM : out std_logic;
    DRAM_RAS_N : out std_logic;
    DRAM_UDQM: out std_logic;
    DRAM_WE_N: out std_logic;

    -- Accelerometer
    G_SENSOR_CS_N : out std_logic;
    G_SENSOR_INT : in std_logic_vector(2 downto 1);
    G_SENSOR_SCLK : out std_logic;
    G_SENSOR_SDI : inout std_logic;
    G_SENSOR_SDO : inout std_logic;
    
    -- forty pin headers
    GPIO : inout std_logic_vector(35 downto 0);

    -- Seven Segment Displays
    HEX0,HEX1,HEX2, HEX3, HEX4, HEX5 : out std_logic_vector(7 downto 0);

    -- Pushbuttons
    KEY : in std_logic_vector(1 downto 0);

    -- LEDs
    LEDR : out std_logic_vector(9 downto 0);

    -- Slider Switches
    SW : in std_logic_vector(9 downto 0);

    -- VGA
    VGA_B, VGA_G, VGA_R : out std_logic_vector(3 downto 0);
    VGA_HS, VGA_VS : out std_logic;
    
    hex_output_export          : out   std_logic_vector(29 downto 0)
    );

end entity DE10_Lite_Computer;


architecture STRUCTURAL of DE10_Lite_Computer is

 component Computer_System is
        port (
            arduino_gpio_export        : inout std_logic_vector(15 downto 0) := (others => 'X'); -- export
            arduino_reset_n_export     : out   std_logic;                                        -- export
            expansion_jp1_export       : inout std_logic_vector(31 downto 0) := (others => 'X'); -- export
--            hex3_hex0_export           : out   std_logic_vector(31 downto 0);                    -- export
--            hex5_hex4_export           : out   std_logic_vector(15 downto 0);                    -- export
            leds_export                : out   std_logic_vector(9 downto 0);                     -- export
            pushbuttons_export         : in    std_logic_vector(1 downto 0)  := (others => 'X'); -- export
            sdram_addr                 : out   std_logic_vector(12 downto 0);                    -- addr
            sdram_ba                   : out   std_logic_vector(1 downto 0);                     -- ba
            sdram_cas_n                : out   std_logic;                                        -- cas_n
            sdram_cke                  : out   std_logic;                                        -- cke
            sdram_cs_n                 : out   std_logic;                                        -- cs_n
            sdram_dq                   : inout std_logic_vector(15 downto 0) := (others => 'X'); -- dq
            sdram_dqm                  : out   std_logic_vector(1 downto 0);                     -- dqm
            sdram_ras_n                : out   std_logic;                                        -- ras_n
            sdram_we_n                 : out   std_logic;                                        -- we_n
            sdram_clk_clk              : out   std_logic;                                        -- clk
            slider_switches_export     : in    std_logic_vector(9 downto 0)  := (others => 'X'); -- export
            system_pll_ref_clk_clk     : in    std_logic                     := 'X';             -- clk
            system_pll_ref_reset_reset : in    std_logic                     := 'X';             -- reset
                
            hex_output_export          : out   std_logic_vector(29 downto 0);
            servo_output_export        : out   std_logic_vector(15 downto 0);
        
            video_lt24_controller_0_lcd_on  : out   std_logic;                                        -- lcd_on
            video_lt24_controller_0_reset_n : out   std_logic;                                        -- reset_n
            video_lt24_controller_0_csx     : out   std_logic;                                        -- csx
            video_lt24_controller_0_data    : out   std_logic_vector(15 downto 0);                    -- data
            video_lt24_controller_0_rdx     : out   std_logic;                                        -- rdx
            video_lt24_controller_0_wrx     : out   std_logic;                                        -- wrx
            video_lt24_controller_0_dcx     : out   std_logic;                                        -- dcx
            video_pll_0_ref_clk_clk         : in    std_logic                     := 'X';             -- clk
            video_pll_0_ref_reset_reset     : in    std_logic                     := 'X';             -- reset
                
            lt24_touch_adc_busy             : in    std_logic                     := 'X';             -- adc_busy
            lt24_touch_adc_cs               : out   std_logic;                                        -- adc_cs
            lt24_touch_adc_dclk             : out   std_logic;                                        -- adc_dclk
            lt24_touch_adc_din              : out   std_logic;                                        -- adc_din
            lt24_touch_adc_dout             : in    std_logic                     := 'X';             -- adc_dout
            lt24_touch_adc_penirq_n         : in    std_logic
        );
    end component Computer_System;
     
    signal hex_export : std_logic_vector(29 downto 0);
     
    signal hex3_hex0 : std_logic_vector(31 downto 0); 
    signal hex5_hex4 : std_logic_vector(15 downto 0);
     
    signal dqm : std_logic_vector(1 downto 0);
    signal jp1 : std_logic_vector(31 downto 0);
     
    signal servo_export: std_logic_vector(15 downto 0);

    signal LT24_data: std_logic_vector(15 downto 0);

begin 

    
    DRAM_UDQM <= dqm(1);
    DRAM_LDQM <= dqm(0);
    

    u0 : component Computer_System
        port map (
            system_pll_ref_clk_clk          => CLOCK_50,        -- system_pll_ref_clk.clk
            system_pll_ref_reset_reset      => '0',             -- system_pll_ref_reset.reset
    
            arduino_gpio_export             => open,            -- arduino_gpio.export
            arduino_reset_n_export          => ARDUINO_RESET_N, -- arduino_reset_n.export

            slider_switches_export          => SW,              -- slider_switches.export

            pushbuttons_export              => not KEY,         -- pushbuttons.export
                
            expansion_jp1_export            => jp1,             -- expansion_jp1.export
 
            leds_export                     => LEDR,            -- leds.export


            sdram_addr                      => DRAM_ADDR,       -- sdram.addr
            sdram_ba                        => DRAM_BA,         -- .ba
            sdram_cas_n                     => DRAM_CAS_N,      -- .cas_n
            sdram_cke                       => DRAM_CKE,        -- .cke
            sdram_cs_n                      => DRAM_CS_N,       -- .cs_n
            sdram_dq                        => DRAM_DQ,         -- .dq
            sdram_dqm                       => dqm,             -- .dqm
            sdram_ras_n                     => DRAM_RAS_N,      -- .ras_n
            sdram_we_n                      => DRAM_WE_N,       -- .we_n
            sdram_clk_clk                   => DRAM_CLK,        -- sdram_clk.clk
            
            hex_output_export               => hex_export,
            servo_output_export             => servo_export,
            video_lt24_controller_0_lcd_on  => GPIO(35),        -- video_lt24_controller_0.lcd_on
            video_lt24_controller_0_reset_n => GPIO(33),        -- .reset_n
            video_lt24_controller_0_csx     => GPIO(25),        -- .csx
            video_lt24_controller_0_data    => LT24_data,       -- .data
            video_lt24_controller_0_rdx     => GPIO(10),        -- .rdx
            video_lt24_controller_0_wrx     => GPIO(11),        -- .wrx
            video_lt24_controller_0_dcx     => GPIO(12),        -- .dcx
            video_pll_0_ref_clk_clk         => CLOCK_50,        -- video_pll_0_ref_clk.clk
            video_pll_0_ref_reset_reset     => '0',             -- video_pll_0_ref_reset.reset
                
            lt24_touch_adc_busy             => GPIO(2),         -- lt24_touch.adc_busy
            lt24_touch_adc_cs               => GPIO(34),        --           .adc_cs
            lt24_touch_adc_dclk             => GPIO(4),         --           .adc_dclk
            lt24_touch_adc_din              => GPIO(3),         --           .adc_din
            lt24_touch_adc_dout             => GPIO(1),         --           .adc_dout
            lt24_touch_adc_penirq_n         => GPIO(0)          --           .adc_penirq_n
        );
          
    uhex0 : entity work.HexToSeg7Decoder
        port map (
            ENABLE   => hex_export(0),
            HEX_CODE => hex_export(4 downto 1),
            SEG_CODE => hex3_hex0(7 downto 0)
        );

    uhex1 : entity work.HexToSeg7Decoder
        port map (
            ENABLE   => hex_export(5),
            HEX_CODE => hex_export(9 downto 6),
            SEG_CODE => hex3_hex0(15 downto 8)
        );
    
    uhex2 : entity work.HexToSeg7Decoder
        port map (
            ENABLE   => hex_export(10),
            HEX_CODE => hex_export(14 downto 11),
            SEG_CODE => hex3_hex0(23 downto 16)
        );
    
    uhex3 : entity work.HexToSeg7Decoder
        port map (
            ENABLE   => hex_export(15),
            HEX_CODE => hex_export(19 downto 16),
            SEG_CODE => hex3_hex0(31 downto 24)
        );

    uhex4 : entity work.HexToSeg7Decoder
        port map (
            ENABLE   => hex_export(20),
            HEX_CODE => hex_export(24 downto 21),
            SEG_CODE => hex5_hex4(7 downto 0)
        );
    
    uhex5 : entity work.HexToSeg7Decoder
        port map (
            ENABLE   => hex_export(25),
            HEX_CODE => hex_export(29 downto 26),
            SEG_CODE => hex5_hex4(15 downto 8)
        );
        
    uservo0 : entity work.ServoController
        port map (
            clk    => CLOCK_50,
            rst    => '0',
            input  => servo_export(7 downto 0),
            output => ARDUINO_IO(9)
        );
        
    uservo1 : entity work.ServoController
        port map (
            clk    => CLOCK_50,
            rst    => '0',
            input  => servo_export(15 downto 8),
            output => ARDUINO_IO(10)
        );
    
    HEX0 <= hex3_hex0(7 downto 0);
    HEX1 <= hex3_hex0(15 downto 8);
    HEX2 <= hex3_hex0(23 downto 16);
    HEX3 <= hex3_hex0(31 downto 24);
    HEX4 <= hex5_hex4(7 downto 0);
    HEX5 <= hex5_hex4(15 downto 8);
    
    GPIO(24 downto 13) <= LT24_data(15 downto 4);
    GPIO(5) <= LT24_data(3);
    GPIO(6) <= LT24_data(2);
    GPIO(7) <= LT24_data(1);
    GPIO(8) <= LT24_data(0);
    
end architecture STRUCTURAL;