LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY avalon_touch IS
    PORT (
        -- Avalon interface
        clk, reset_n : IN STD_LOGIC;
        irq : OUT STD_LOGIC;
        read, write : IN STD_LOGIC;
        address : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
        byteenable_n : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        writedata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        readdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        -- external singals (conduit)
        adc_dout : IN STD_LOGIC;
        adc_penirq_n : IN STD_LOGIC;
        adc_busy : IN STD_LOGIC;
        adc_din : OUT STD_LOGIC;
        adc_dclk : OUT STD_LOGIC;
        adc_cs : OUT STD_LOGIC
    );
END ENTITY avalon_touch;

ARCHITECTURE structural OF avalon_touch IS

    COMPONENT adc_spi_controller PORT (
        iCLK : IN STD_LOGIC;
        iRST_n : IN STD_LOGIC;
        iADC_DOUT : IN STD_LOGIC;
        iADC_PENIRQ_n : IN STD_LOGIC;
        iADC_BUSY : IN STD_LOGIC;
        oADC_DIN : OUT STD_LOGIC;
        oADC_DCLK : OUT STD_LOGIC;
        oADC_CS : OUT STD_LOGIC;
        oX_COORD : OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
        oY_COORD : OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
        oNEW_COORD : OUT STD_LOGIC;
        oTOUCH_IRQ : OUT STD_LOGIC
        );
    END COMPONENT;

    SIGNAL sigEN, sigNC, sigIE, sigIF : STD_LOGIC;
    SIGNAL sigXCoord, sigYCoord : STD_LOGIC_VECTOR(11 DOWNTO 0);

BEGIN

    spi : adc_spi_controller
    PORT MAP(
        iCLK => (clk AND sigEN),
        iRST_n => reset_n,

        iADC_DOUT => adc_dout,
        iADC_PENIRQ_n => adc_penirq_n,
        iADC_BUSY => adc_busy,
        oADC_DIN => adc_din,
        oADC_DCLK => adc_dclk,
        oADC_CS => adc_cs,

        oX_COORD => sigXCoord,
        oY_COORD => sigYCoord,
        oNEW_COORD => sigNC,
        oTOUCH_IRQ => sigIF
    );

    PROCESS (clk, reset_n)
    BEGIN
        IF (reset_n = '0') THEN

        ELSIF rising_edge(clk) THEN

            IF (read = '1') THEN
                IF (address(0) = '1') THEN
                    readdata <= "0000" & sigYCoord & "0000" & sigXCoord;
                ELSIF (address(0) = '0') THEN
                    readdata <= X"0000000" & sigIF & sigIE & sigNC & sigEN;
                END IF;
            END IF;

            IF (write = '1') THEN
                IF (address(0) = '0') THEN
                    -- if (writedata(3) = '1') then
                    --     sigIF <= '0';
                    -- end if;

                    sigIE <= writedata(2);
                    -- sigNC <= writedata(1);
                    sigEN <= writedata(0);
                END IF;
            END IF;

        END IF;
    END PROCESS;

    irq <= sigIF and sigIE;

END ARCHITECTURE structural;