library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

--=============================================================================
-- Author      : Yunus Emre Selen
-- Module Name : generic_ff_synchronizer
-- Description :
--   Generic flip-flop based single-bit synchronizer.
--
--   This module is used to bring an asynchronous or cross-domain single-bit
--   control signal safely into the destination clock domain.
--
-- Generics:
--   STAGES : Number of synchronizer flip-flops.
--            Recommended minimum for CDC: 2
--
-- Ports:
--   clk_i   : Destination clock domain
--   din_i   : Asynchronous / cross-domain input signal
--   dout_o  : Synchronized output signal in destination domain
--=============================================================================

entity generic_ff_synchronizer is
    generic(
        STAGES : integer := 2
    );
    port(
        clk_i  : in  std_logic;
        din_i  : in  std_logic;
        dout_o : out std_logic
    );
end generic_ff_synchronizer;

architecture rtl of generic_ff_synchronizer is

    -- Shift register used as synchronizer chain
    signal sync_ff : std_logic_vector(STAGES-1 downto 0) := (others => '0');

    -- Tell synthesis / implementation tools that this register chain
    -- is intended for asynchronous signal synchronization.
    attribute ASYNC_REG : string;
    attribute ASYNC_REG of sync_ff : signal is "TRUE";

begin

    process(clk_i)
    begin
        if rising_edge(clk_i) then
            sync_ff(0) <= din_i;

            if STAGES > 1 then
                sync_ff(STAGES-1 downto 1) <= sync_ff(STAGES-2 downto 0);
            end if;
        end if;
    end process;

    -- Final synchronized output
    dout_o <= sync_ff(STAGES-1);

end rtl;