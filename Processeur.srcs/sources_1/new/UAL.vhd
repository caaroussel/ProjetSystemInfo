----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 21.04.2023 09:46:53
-- Design Name: 
-- Module Name: UAL - Behavioral
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity UAL is
    Port ( a : in STD_LOGIC_VECTOR (7 downto 0);
           b : in STD_LOGIC_VECTOR (7 downto 0);
           op : in STD_LOGIC_VECTOR (2 downto 0);
           result : out STD_LOGIC_VECTOR (7 downto 0);
           N : out STD_LOGIC;
           O : out STD_LOGIC;
           Z : out STD_LOGIC;
           C : out STD_LOGIC
           );
end UAL;

architecture Behavioral of UAL is
    signal Aux: STD_LOGIC_VECTOR (9 downto 0) := (others => '0');
begin
    process
    begin
        case op is
            when "000" =>
                Aux <= a + b;
            when "001" =>
                Aux <= a - b;
            when "010" =>
                Aux <= a * b;
            when others =>
                Aux <= (others => '0');
        end case;
        if (Aux < x"00000000") then N<='1'; else N<='0'; end if;
        if (Aux = x"00000000") then Z<='1'; else Z<='0'; end if;
        if (Aux > x"111111111") then O<='1'; else O<='0'; end if;
        if (Aux > x"11111111") then C<='1'; else C<='0'; end if;
        Result <= Aux(7 downto 0);
    end process;
end Behavioral;
