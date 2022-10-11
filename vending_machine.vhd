
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

entity vending_machine is
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
end vending_machine;

architecture arch of vending_machine is

TYPE state_type IS (IDLE, COIN_COLLECT, GIVE_PRODUCT, GIVE_CHANGE);
signal state 	  : state_type;

-- Internal Signals:
signal coin_reg			: std_logic_vector(4 downto 0); -- Input coin'i registerlar
signal error_flag		: std_logic;	-- Bu error flag, COIN_COLLECT state'inde 10₺ toplanamamışsa, tüm paranın iadesi ve IDLE'a geri dönülmesi içindir.
constant price : std_logic_vector(4 downto 0) := "01010";	-- Ürünün fiyatı sabit ve 10₺ dir.

begin

-- Current State Logic
process(clk,rst)
begin
	if (rst = '1') then
		state <= IDLE;
		coin_reg <= (others => '0');
		product_ready <= '0';
		return_change <= '0';	
		error_flag <= '0';			
	elsif(rising_edge(clk)) then
		case state is
			when IDLE =>
				-- Reset Pameters:
				coin_reg <= (others => '0');
				product_ready <= '0';
				return_change <= '0';	
				error_flag <= '0';			
				if(coin_valid = '1') then
					state <= COIN_COLLECT;				
					coin_reg <= coin_in;	-- İlk para alındı
				else
					state <= IDLE;
				end if;
				
			when COIN_COLLECT =>
				if(coin_valid = '1') then
					state <= COIN_COLLECT;				
					coin_reg <= coin_reg + coin_in;	-- İlk para alındı
				else
					if(coin_reg >= price) then	-- Coin valid kesildiginde, toplam para 10tl�� veya �zeri olmalidir
						state <= GIVE_PRODUCT;
					else 	-- total amount is less than 10t
						state <= GIVE_CHANGE;
						error_flag <= '1';
					end if;
				end if;
				
			when GIVE_PRODUCT =>
				coin_reg <= coin_reg - price;
				product_ready <= '1';
				state <= GIVE_CHANGE;				
				
			when GIVE_CHANGE =>	
				product_ready <= '0';
				error_flag <= '0';
				if(coin_reg /= "00000") then
					coin_reg <= coin_reg - "00001";
					return_change <= '1';
					state <= GIVE_CHANGE;
				else	-- coin reg is zero
					return_change <= '0';
					state <= IDLE;	
				end if;
			
			when others =>
				coin_reg <= (others => '0');
				product_ready <= '0';
				return_change <= '0';
				state <= IDLE;
		end case;
	end if;
end process;


end architecture;