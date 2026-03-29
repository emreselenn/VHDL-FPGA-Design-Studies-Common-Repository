library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

--=============================================================================
-- Author      : Yunus Emre Selen
-- Module Name : reset_synchronizer
-- Description :
--   Asynchronous-assert, synchronous-deassert reset synchronizer.
--
--   External or global reset signals may not be aligned to the local clock.
--   Asserting reset asynchronously is usually safe and desired, because the
--   system should reset immediately.
--
--   However, DEASSERTING reset asynchronously can cause timing issues or
--   metastability-like startup problems in synchronous logic.
--
--   Therefore, a common good practice is:
--     - reset assertion  : asynchronous
--     - reset deassertion: synchronous to local clock
--
--=============================================================================

entity reset_synchronizer is
    generic(
        STAGES : integer := 2
    );
    port(
        clk_i    : in  std_logic;
        arst_n_i : in  std_logic;
        srst_n_o : out std_logic
    );
end reset_synchronizer;

architecture rtl of reset_synchronizer is

    signal reset_ff : std_logic_vector(STAGES-1 downto 0) := (others => '0');

    attribute ASYNC_REG : string;
    attribute ASYNC_REG of reset_ff : signal is "TRUE";

begin

    process(clk_i, arst_n_i)
    begin
        -- Asynchronous assertion:
        -- if reset becomes active, force all stages low immediately
        if arst_n_i = '0' then
            reset_ff <= (others => '0');

        -- Synchronous deassertion:
        -- once arst_n_i returns high, shift in '1'
        elsif rising_edge(clk_i) then
            reset_ff(0) <= '1';

            if STAGES > 1 then
                reset_ff(STAGES-1 downto 1) <= reset_ff(STAGES-2 downto 0);
            end if;
        end if;
    end process;

    -- Active-low synchronized reset output
    srst_n_o <= reset_ff(STAGES-1);

end rtl;