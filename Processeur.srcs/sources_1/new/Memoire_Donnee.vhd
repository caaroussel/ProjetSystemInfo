----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 21.04.2023 09:22:19
-- Design Name: 
-- Module Name: Memoire_Donnee - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Memoire_Donnee is
    Port ( 
            Clk : in STD_LOGIC;
            Addr : in std_logic_vector(7 downto 0);
            Data_in : in std_logic_vector(7 downto 0);
            Data_out : out std_logic_vector(7 downto 0);
            Write_en : in std_logic
         );
            
end Memoire_Donnee;

architecture Behavioral of Memoire_Donnee is
            type donnee_mem_t is array (natural range <>) of std_logic_vector(7 downto 0);
            signal mem : donnee_mem_t(0 to 1023) := (others => (others => '0'));
begin
    process
    begin
        wait until Clk'Event and Clk='1';
        if Write_en = '1' then
            mem(to_integer(unsigned(Addr))) <= Data_in;
        end if;
        Data_out <= mem(to_integer(unsigned(Addr)));
    end process;

end Behavioral;
