library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;


entity uart_rx  is

generic(
	c_clkfreq		: integer 	:= 100_000_000;
	c_baudrate		: integer 	:= 115200
);

port(
	clk	: in std_logic;
	rx_i : in std_logic;
	dout_o : out std_logic_vector(7 downto 0);
	rx_done_tick_o : out std_logic
);	
	
end uart_rx ;

architecture uart_rx  of uart_rx  is

type states is (s_idle, s_start, s_data, s_stop);
signal state 		: states := s_idle;

constant c_bittimerlim : integer := c_clkfreq / c_baudrate;

signal bittimer : integer range 0 to c_bittimerlim;

signal bitcntr : integer range 0 to 7 := 0;

signal shreg : std_logic_vector(7 downto 0) := (others => '0');

begin

P_MAIN : process (clk) is begin
	if (rising_edge(clk)) then
		case state is
			when s_idle =>
				rx_done_tick_o <= '0';
				if(rx_i = '0') then
					state <= s_start;
					bittimer <= 0;
				end if;
				
			
			when s_start =>

				if(bittimer = c_bittimerlim/2 -1) then
					state <= s_data;
					bittimer <= 0;
				else
					bittimer <= bittimer +1;
				end if;
                
            
			when s_data =>
				if(bittimer = c_bittimerlim-1) then
					
					if(bitcntr = 7) then
						state <= s_stop;
						bitcntr <= 0;
					else
						bitcntr <= bitcntr +1;
					end if;
					shreg <= rx_i & shreg(7 downto 1);
					bittimer <= 0;
				else 
					bittimer <= bittimer +1;
				end if;

			when s_stop =>
				
				if(bittimer = c_bittimerlim -1) then
					state <= s_idle;
					bittimer <= 0;
					rx_done_tick_o <= '1';
				else
					bittimer <= bittimer +1;
				end if;
				
		end case;
	end if;
end process;

dout_o <= shreg;
end uart_rx ;

