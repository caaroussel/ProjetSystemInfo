----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12.05.2023 12:48:51
-- Design Name: 
-- Module Name: BR - Behavioral
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

entity BR is
    Port ( A_address : in STD_LOGIC_VECTOR (3 downto 0);
           B_address : in STD_LOGIC_VECTOR (3 downto 0);
           W_address : in STD_LOGIC_VECTOR (3 downto 0);
           W : in STD_LOGIC;
           DATA : in STD_LOGIC_VECTOR (7 downto 0);
           CLK : in STD_LOGIC;
           RST : in STD_LOGIC;
           QA : out STD_LOGIC_VECTOR (7 downto 0);
           QB : out STD_LOGIC_VECTOR (7 downto 0));
end BR;

architecture Behavioral of BR is
    signal SA: STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
    signal SB: STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
    type donnee_br_t is array (natural range <>) of std_logic_vector(7 downto 0);
    signal mem : donnee_br_t(0 to 15) := (others => (others => '0'));

begin
    process
    begin
        wait until (CLK'Event and CLK = '1');
        if(RST = '0') then
            mem <= (others => x"00");
        else
            if(W = '1') then
                mem(to_integer(unsigned(W_address))) <= DATA;
            else
                SA <= mem(to_integer(unsigned(A_address)));
                SB <= mem(to_integer(unsigned(B_address)));
            end if;
        end if;
      end process;
        QA <= SA;
        QB <= SB;
end Behavioral;
