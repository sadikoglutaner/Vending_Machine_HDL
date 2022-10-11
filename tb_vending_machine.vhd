
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_vending_machine is
--  Port ( );
end tb_vending_machine;

architecture Behavioral of tb_vending_machine is
component vending_machine is
	port ( 
			-- Inputs:
			clk			: in std_logic;
			rst			: in std_logic;
			coin_in		: in std_logic_vector(4 downto 0);	-- Sadece 1₺, 5₺ ve 10₺ olabilir
			coin_valid  : in std_logic;						-- Yeni coin instert edildiğini gösterir
			
			-- Outputs:
			product_ready	: out std_logic;
			return_change	: out std_logic            		-- Para üstü sadece 1₺ olabilir.
		  );
end component;

signal clk			    :  std_logic;
signal rst			    :  std_logic;
signal coin_in		    :  std_logic_vector(4 downto 0);	
signal coin_valid       :  std_logic;								
signal product_ready	:  std_logic;
signal return_change	:  std_logic;        		

constant clock_period : time := 20 ns;

begin

 clock_process : process
    begin
        clk <= '0';
        wait for clock_period/2;
        clk <= '1';
        wait for clock_period/2;
    end process;


uut : vending_machine port map
                (
                 clk			=>   clk,
                 rst			=>   rst,
                 coin_in		=>   coin_in,
                 coin_valid     =>   coin_valid,						
                 product_ready	=>   product_ready,
                 return_change	=>   return_change  	
                );
 stim_proc : process
   begin
        rst <= '1';
        coin_valid <= '0';
        coin_in <= (others => '0');
        wait for 100ns;
        rst <= '0';
        wait for clock_period*2;
        
        --1--
        coin_valid <= '1';        
        coin_in <= "00001";
        wait for clock_period;        
        coin_in <= "00101";
        wait for clock_period;        
        coin_in <= "01010";
        wait for clock_period;        
        coin_valid <= '0';
        wait for clock_period*15;
        
        --2--
        coin_valid <= '1';        
        coin_in <= "00001";
        wait for clock_period;        
        coin_in <= "00001";
        wait for clock_period; 
        coin_in <= "00101";
        wait for clock_period;             
        coin_valid <= '0';
        wait for clock_period*15;
        
        --3--
        coin_valid <= '1';    
        coin_in <= "00101";
        wait for clock_period;      
        coin_in <= "00001";
        wait for clock_period;        
        coin_in <= "00001";
        wait for clock_period; 
        coin_in <= "00101";
        wait for clock_period;             
        coin_valid <= '0';
        wait for clock_period*15;
        
        --4--
        coin_valid <= '1';    
        coin_in <= "01010";
        wait for clock_period;      
        coin_in <= "00101";
        wait for clock_period;                   
        coin_valid <= '0';
        wait for clock_period*15;
        
        wait;
        
    end process;

end Behavioral;
