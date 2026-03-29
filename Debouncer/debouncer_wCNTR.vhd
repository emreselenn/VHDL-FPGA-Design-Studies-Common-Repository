
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity debouncer_wCNTR is
generic(
	CLK_FREQ    : integer := 50_000_000; -- Hz
   DEBOUNCE_MS : integer := 20          -- debounce süresi
);
port(
	clk : in std_logic;
	btn_i : in std_logic;
	btn_o : out std_logic
);
end debouncer_wCNTR;

architecture Behavioral of debouncer_wCNTR is

signal btn_sync : std_logic_vector(1 downto 0) := (others => '0');
constant cntr_lim : integer := (CLK_FREQ/1000)*DEBOUNCE_MS;
signal cntr : integer range 0 to cntr_lim := 0;

signal tmp_o : std_logic := '0';


begin
	process (clk) is begin
		if (rising_edge(clk)) then 
			
			btn_sync(0) <= btn_i;
			btn_sync(1) <= btn_sync(0);
			
			if(tmp_o = btn_sync(1)) then -- btn deðiþmiþmemiþse
				cntr <= 0;
			else
				if(cntr = cntr_lim -1) then
					tmp_o <= btn_sync(1);
					cntr <= 0;
				else
					cntr <= cntr +1;
				end if;
			end if;	
		end if;
	end process;
	
	btn_o <= tmp_o;

end Behavioral;

