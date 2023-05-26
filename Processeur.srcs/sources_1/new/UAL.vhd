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
    signal Aux: STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
begin
    Z <= '1' when (Aux = "0000000000000000") else '0';
    N <= Aux(7);
    C <= Aux(8);
    O <= '1'when Aux(15 downto 8) > 0 else '0';
    process (a,b,op, Aux) is
    begin
        case op is
            when "001" =>
                Aux <= (b"00000000" & a) + (b"00000000" & b);
            when "011" =>
                Aux <= (b"00000000" & a) - (b"00000000" & b);
            when "010" =>
                Aux <= a * b;
            when others =>
                Aux<= "1000000000000000";
        end case;
        Result <= Aux(7 downto 0);
    end process;
end Behavioral;
