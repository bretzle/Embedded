-- John Bretz
-- CE2820
-- 3/23/21
-- ServoController.vhd

-- period of 20ms
-- input -> period
--     0 -> 1ms
--   100 -> 1.5ms
--   200 -> 2ms
--  >200 -> no output

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY ServoController IS
    PORT (
        input : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC;
        output : OUT STD_LOGIC
    );
END ENTITY ServoController;

ARCHITECTURE dataflow OF ServoController IS

    TYPE state IS (ONN, OFF);

    SIGNAL count : unsigned(19 DOWNTO 0);
    SIGNAL CS, NS : state := ONN;

BEGIN

    counter : PROCESS (clk, rst)
    BEGIN
        IF rst = '1' THEN
            count <= (OTHERS => '0');
        ELSIF rising_edge(clk) THEN
            IF count = 1000000 THEN
                count <= (OTHERS => '0');
            ELSE
                count <= count + 1;
            END IF;
        END IF;
        CS <= NS;
    END PROCESS counter;

    next_state : PROCESS (count)
    BEGIN

        CASE(CS) IS

            WHEN ONN =>
            IF unsigned(input) > 200 THEN -- turn off if > 200
                NS <= OFF;
            ELSIF count = (to_integer(unsigned(input) * 255) + 50000) THEN -- drive low for remainder of time
                NS <= OFF;
            ELSE -- still needs to be high
                NS <= ONN;
            END IF;

            WHEN OFF =>
            IF (unsigned(input) > 200) THEN -- stay off if > 200
                NS <= OFF;
            ELSIF (COUNT = 1000000) THEN -- 20ms has elapsed turn back on
                NS <= ONN;
            ELSE -- remain off for remainder of period
                NS <= OFF;
            END IF;

            WHEN OTHERS => NS <= OFF;

        END CASE;

    END PROCESS next_state;

    output <= '1' WHEN CS = ONN ELSE
        '0';

END ARCHITECTURE dataflow;