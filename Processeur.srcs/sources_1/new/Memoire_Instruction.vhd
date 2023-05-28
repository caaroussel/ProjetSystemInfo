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
    signal mem : instruction_mem_t(0 to 1023) := (x"060102FF", x"080001FF", x"070100FF", x"080101FF", x"060103FF", x"080201FF", x"070101FF", x"070202FF", x"83010102", x"0B1300FF", x"060103FF", x"080201FF", x"060105FF", x"080301FF", x"070102FF", x"070203FF", x"01010102", x"080201FF", x"0A1f00FF", x"060106FF", x"080201FF", x"070100FF", x"080301FF", x"060102FF", x"080401FF", x"070103FF", x"070204FF", x"01010102", x"080301FF", x"070103FF", x"080001FF",others => (others => '0'));
    
begin

   Sortie <=  mem(to_integer(unsigned(Addr)));

end Behavioral;
