library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

--=============================================================================
-- Author      : Yunus Emre Selen
-- Module Name : edge_detector
-- Description :
--   Detects rising and/or falling edges of a synchronous input signal.
--
--   If the input signal stays high for many clock cycles, rise_o is asserted
--   only for one clock cycle at the moment of the 0->1 transition.
--
--   Similarly, fall_o is asserted only for one clock cycle at the moment of
--   the 1->0 transition.
--
--   This module is useful when a LEVEL signal must be converted into a
--   SINGLE-CYCLE EVENT.
--
--   Example:
--     sig_i = 0 0 0 1 1 1 1 0 0
--     rise  = 0 0 0 1 0 0 0 0 0
--     fall  = 0 0 0 0 0 0 0 1 0
--
--=============================================================================

entity edge_detector is
    port(
        clk_i  : in  std_logic;
        sig_i  : in  std_logic;
        rise_o : out std_logic;
        fall_o : out std_logic
    );
end edge_detector;

architecture rtl of edge_detector is

    -- Delayed version of the input signal
    signal sig_d : std_logic := '0';

begin

    -- Save previous value of the input signal
    process(clk_i)
    begin
        if rising_edge(clk_i) then
            sig_d <= sig_i;
        end if;
    end process;

    -- Rising edge detection:
    -- Current is '1', previous was '0'
    rise_o <= sig_i and (not sig_d);

    -- Falling edge detection:
    -- Current is '0', previous was '1'
    fall_o <= (not sig_i) and sig_d;

end rtl;