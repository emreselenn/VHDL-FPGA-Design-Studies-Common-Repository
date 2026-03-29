LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY uart_transmit_tb IS
generic(
	c_clkfreq		: integer 	:= 100_000_000;
	c_baudrate		: integer 	:= 10_000_000;
	c_stopbit		: integer 	:= 2
);
END uart_transmit_tb;
 
ARCHITECTURE behavior OF uart_transmit_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT uart_tx is
	 generic(
			c_clkfreq		: integer 	:= 100_000_000;
			c_baudrate		: integer 	:= 10_000_000;
			c_stopbit		: integer 	:= 2
		);
    PORT(
         clk : IN  std_logic;
         din_i : IN  std_logic_vector(7 downto 0);
         tx_start_i : IN  std_logic;
         tx_o : OUT  std_logic;
         tx_done_tick_o : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal din_i : std_logic_vector(7 downto 0) := (others => '0');
   signal tx_start_i : std_logic := '0';

 	--Outputs
   signal tx_o : std_logic;
   signal tx_done_tick_o : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: uart_tx 
	generic map(
		c_clkfreq	=> c_clkfreq	,
		c_baudrate	=> c_baudrate	,
		c_stopbit	=> c_stopbit	
		)
		
	PORT MAP (
          clk => clk,
          din_i => din_i,
          tx_start_i => tx_start_i,
          tx_o => tx_o,
          tx_done_tick_o => tx_done_tick_o
        );

		-- Clock process definitions
	clk_process : process
	begin
		while true loop
			clk <= '0';
			wait for clk_period/2;
			clk <= '1';
			wait for clk_period/2;
		end loop;
	end process;
 

   -- Stimulus process
   stim_proc: process begin
		din_i <= x"00";
		tx_start_i <= '0';
		wait for clk_period*10;
		 
		 
		din_i <= x"51";
		tx_start_i <= '1';
		wait for clk_period;
		tx_start_i <= '0';
	   
		wait for 1.2 us;
		
		
		din_i <= x"A3";
		tx_start_i <= '1';
		wait for clk_period;
		tx_start_i <= '0';
		
		
		wait for 1 us;
		
		assert false
		report "SIM DONE"
		severity failure;
   end process;

END;
