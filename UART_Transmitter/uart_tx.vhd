library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;


entity uart_tx is

generic(
	c_clkfreq		: integer 	:= 100_000_000;
	c_baudrate		: integer 	:= 115200;
	c_stopbit		: integer 	:= 2
);

port(
	clk	: in std_logic;
	din_i : in std_logic_vector(7 downto 0);
	tx_start_i : in std_logic;
	tx_o : out std_logic;
	tx_done_tick_o : out std_logic
);	
	
end uart_tx;

architecture uart_tx of uart_tx is

type states is (s_idle, s_start, s_data, s_stop);
signal state 		: states := s_idle;

constant c_bittimerlim : integer := c_clkfreq / c_baudrate;
constant c_stopbitlim  : integer := (c_clkfreq / c_baudrate)*c_stopbit;

signal bittimer : integer range 0 to c_stopbitlim;

signal bitcntr : integer range 0 to 7 := 0;

signal shreg : std_logic_vector(7 downto 0) := (others => '0');

begin

P_MAIN : process (clk) is begin
	if (rising_edge(clk)) then
		case state is
			when s_idle =>
				tx_o <= '1';
				bittimer <= 0;
				tx_done_tick_o <= '0';
				
				if(tx_start_i = '1') then
					state <= s_start;
					tx_o <= '0';
					shreg <= din_i;
				end if;
			
			when s_start =>
                if(bittimer = c_bittimerlim-1) then
                    state <= s_data;
                    tx_o <= shreg(0);
					shreg(7) <= shreg(0);
					shreg(6 downto 0) <= shreg(7 downto 1);
					bittimer <= 0;
				else
					bittimer <= bittimer +1;
                end if;
            
			when s_data =>
				--tx_o <= shreg(0);
				if(bitcntr = 7) then 
					if(bittimer = c_bittimerlim-1) then
						state <= s_stop;
						bitcntr <= 0;
						tx_o <= '1';
						bittimer <= 0;
					else
						bittimer <= bittimer +1;
                	end if;
					
				else
					if(bittimer = c_bittimerlim-1) then
						shreg(7) <= shreg(0);
						shreg(6 downto 0) <= shreg(7 downto 1);
						tx_o <= shreg(0);
						bitcntr <= bitcntr +1;
						bittimer <= 0;
					else
						bittimer <= bittimer +1;
                	end if;
				end if;


			when s_stop =>
				if(bittimer = c_stopbitlim-1) then
					state <= s_idle;
					tx_done_tick_o <= '1';	
					bittimer <= 0;
				else
						bittimer <= bittimer +1;
            end if;
		end case;
	end if;
end process;


end uart_tx;

