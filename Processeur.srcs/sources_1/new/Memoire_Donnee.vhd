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
            CLK : in STD_LOGIC;
            Addr : in std_logic_vector(7 downto 0);
            Data_in : in std_logic_vector(7 downto 0);
            Data_out : out std_logic_vector(7 downto 0);
            Write_en : in std_logic;
            RST : in std_logic
         );
            
end Memoire_Donnee;

architecture Behavioral of Memoire_Donnee is
            type donnee_mem_t is array (natural range <>) of std_logic_vector(7 downto 0);
            signal mem : donnee_mem_t(0 to 1023) := (others => (others => '0'));
begin
    process 
    begin
        wait until (CLK'Event and CLK = '0');
        if(RST = '0') then
            mem <= (others => x"00");
        else
            if Write_en = '1' then
                mem(to_integer(unsigned(Addr))) <= Data_in;
            else
                Data_out <= mem(to_integer(unsigned(Addr)));
            end if;
        end if;
    end process;
end Behavioral;