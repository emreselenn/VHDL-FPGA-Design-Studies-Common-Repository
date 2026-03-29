
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity debouncer is
port(
   CLK : in std_logic;
	EN5ms : in std_logic;
	Kin : in std_logic;
	Kout : out std_logic
);
end debouncer;

rchitecture debouncer of debouncer is
   signal SR : std_logic_vector(2 downto 0);
begin 
    process(EN5ms) is begin
	    if(rising_edge(EN5ms)) then 
		  
			  SR <= SR(1 downto 0) & Kin;
			  if(SR="000") then Kout <= '0';
           elsif(SR="111") then Kout <= '1'; end if;
			
		end if;
	end process;
end debouncer;

