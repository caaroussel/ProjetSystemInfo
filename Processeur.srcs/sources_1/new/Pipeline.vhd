----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12.05.2023 13:19:23
-- Design Name: 
-- Module Name: Pipeline - Behavioral
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

entity Pipeline is
      Port ( 
        A_in : in STD_LOGIC_VECTOR (7 downto 0);
        B_in : in STD_LOGIC_VECTOR (7 downto 0);
        C_in : in STD_LOGIC_VECTOR (7 downto 0);
        OP_in : in STD_LOGIC_VECTOR (7 downto 0);
        A_out : out STD_LOGIC_VECTOR (7 downto 0);
        B_out : out STD_LOGIC_VECTOR (7 downto 0);
        C_out : out STD_LOGIC_VECTOR (7 downto 0);
        OP_out : out STD_LOGIC_VECTOR (7 downto 0);
        CLK : in STD_LOGIC;
        RST : in STD_LOGIC);
end Pipeline;

architecture Behavioral of Pipeline is
signal S_A_out : STD_LOGIC_VECTOR (7 downto 0);
signal S_B_out : STD_LOGIC_VECTOR (7 downto 0);
signal S_C_out : STD_LOGIC_VECTOR (7 downto 0);
signal S_OP_out : STD_LOGIC_VECTOR (7 downto 0);

begin
    process
    begin
        wait until CLK'Event and CLK='1';
        if(RST = '0') then
            S_A_out <= "00000000";
            S_B_out <= "00000000";
            S_C_out <= "00000000";
            S_OP_out <= "00000000";
        else
            S_A_out <= A_in;
            S_B_out <= B_in;
            S_C_out <= C_in;
            S_OP_out <= OP_in;
        end if;
      end process;
      A_out <= S_A_out;
      B_out <= S_B_out;
      C_out <= S_C_out;
      OP_out <= S_OP_out;
end Behavioral;

