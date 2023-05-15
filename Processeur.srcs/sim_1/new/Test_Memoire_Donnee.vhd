----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 15.05.2023 14:18:15
-- Design Name: 
-- Module Name: Test_Memoire_Donnee - Behavioral
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

entity Test_Memoire_Donnee is
--  Port ( );
end Test_Memoire_Donnee;

architecture Behavioral of Test_Memoire_Donnee is

COMPONENT Memoire_Donnee
    Port ( 
        CLK : in STD_LOGIC;
        Addr : in std_logic_vector(7 downto 0);
        Data_in : in std_logic_vector(7 downto 0);
        Data_out : out std_logic_vector(7 downto 0);
        Write_en : in std_logic;
        RST : in std_logic
    );
end COMPONENT;

--Inputs
signal S_Addr : std_logic_vector(7 downto 0);
signal S_Data_in : std_logic_vector(7 downto 0);
signal S_Write_en : std_logic;
signal S_Clock : STD_LOGIC := '0';
signal S_RST : STD_LOGIC;

--Outputs
signal S_Data_out : std_logic_vector(7 downto 0);

-- Clock period definitions
-- Si 100 MHz
constant Clock_period : time := 10 ns;


begin

Label_uut: Memoire_Donnee PORT MAP(
    Addr=> S_Addr,
    Data_in => S_Data_in,
    Data_out => S_Data_out,
    Write_en => S_Write_en,
    CLK => S_Clock,
    RST => S_RST
);


Clock_process : process
begin
    S_Clock <= not(S_Clock);
    wait for Clock_period/2;
end process;

S_Write_en <= '1' after 4 ns, '0' after 200 ns;
S_RST <= '1' after 4 ns, '0' after 250 ns, '1' after 300 ns;

S_Addr <= "00000000" after 5 ns;
S_Data_in <= "00011000" after 5 ns;


end Behavioral;
