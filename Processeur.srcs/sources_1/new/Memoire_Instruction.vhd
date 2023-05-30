----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 21.04.2023 08:50:37
-- Design Name: 
-- Module Name: Memoire_Instruction - Behavioral
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

entity Memoire_Instruction is
    Port ( Sortie : out STD_LOGIC_VECTOR (31 downto 0);
           Addr : in STD_LOGIC_VECTOR (7 downto 0));
end Memoire_Instruction;

architecture Behavioral of Memoire_Instruction is
    type instruction_mem_t is array (natural range <>) of std_logic_vector(31 downto 0);
    signal mem : instruction_mem_t(0 to 1023) := (x"0A0100FF", x"06010aFF", x"080101FF", x"070101FF", x"080201FF", x"060100FF", x"080301FF", x"070102FF", x"070203FF", x"B3010102", x"0B1900FF", x"070101FF", x"080201FF", x"070d02FF", x"070101FF", x"080201FF", x"060101FF", x"080301FF", x"070102FF", x"070203FF", x"03010102", x"080201FF", x"070102FF", x"080101FF", x"0A0300FF", x"06014eFF", x"080201FF", x"070d02FF",others => (others => '0'));
    
begin

   Sortie <=  mem(to_integer(unsigned(Addr)));

end Behavioral;