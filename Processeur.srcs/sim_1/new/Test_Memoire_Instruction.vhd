----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 15.05.2023 13:06:23
-- Design Name: 
-- Module Name: Test_Memoire_Instruction - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Test_Memoire_Instruction is
-- port()
end Test_Memoire_Instruction;

architecture Behavioral of Test_Memoire_Instruction is

COMPONENT Memoire_instruction
    Port ( Addr : in STD_LOGIC_VECTOR (7 downto 0);
           Sortie : out STD_LOGIC_VECTOR (31 downto 0);
           CLK : in STD_LOGIC
           );
end COMPONENT;

--Inputs
signal S_Addr : STD_LOGIC_VECTOR (7 downto 0);
signal S_Clock : STD_LOGIC := '0';
--Outputs
signal S_Sortie : STD_LOGIC_VECTOR (31 downto 0);

-- Clock period definitions
-- Si 100 MHz
constant Clock_period : time := 10 ns;


begin

Label_uut: Memoire_Instruction PORT MAP(
    Addr => S_Addr,
    CLK => S_Clock,
    Sortie => S_Sortie
);


Clock_process : process
begin
    S_Clock <= not(S_Clock);
    wait for Clock_period/2;
end process;

S_Addr<="00000000" after 5 ns, "00000001" after 50 ns, "00000010" after 150 ns, "00000011" after 500 ns;


end Behavioral;
