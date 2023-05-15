----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 15.05.2023 13:40:15
-- Design Name: 
-- Module Name: Test_BR - Behavioral
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

entity Test_BR is
--  Port ( );
end Test_BR;

architecture Behavioral of Test_BR is

COMPONENT BR
    Port ( A_address : in STD_LOGIC_VECTOR (3 downto 0);
           B_address : in STD_LOGIC_VECTOR (3 downto 0);
           W_address : in STD_LOGIC_VECTOR (3 downto 0);
           W : in STD_LOGIC;
           DATA : in STD_LOGIC_VECTOR (7 downto 0);
           CLK : in STD_LOGIC;
           RST : in STD_LOGIC;
           QA : out STD_LOGIC_VECTOR (7 downto 0);
           QB : out STD_LOGIC_VECTOR (7 downto 0));
end COMPONENT;


--Inputs
signal S_A_address : STD_LOGIC_VECTOR (3 downto 0);
signal S_B_address : STD_LOGIC_VECTOR (3 downto 0);
signal S_W_address : STD_LOGIC_VECTOR (3 downto 0);
signal S_W : STD_LOGIC;
signal S_DATA : STD_LOGIC_VECTOR (7 downto 0);
signal S_Clock : STD_LOGIC := '0';
signal S_RST : STD_LOGIC;

--Outputs
signal S_QA : STD_LOGIC_VECTOR (7 downto 0);
signal S_QB : STD_LOGIC_VECTOR (7 downto 0);

-- Clock period definitions
-- Si 100 MHz
constant Clock_period : time := 10 ns;


begin

Label_uut: BR PORT MAP(
    A_address => S_A_address,
    B_address => S_B_address,
    W_address => S_W_address,
    W => S_W,
    DATA => S_DATA,
    CLK => S_Clock,
    RST => S_RST,
    QA => S_QA,
    QB => S_QB
);


Clock_process : process
begin
    S_Clock <= not(S_Clock);
    wait for Clock_period/2;
end process;

S_W <= '1' after 4 ns, '0' after 200 ns;
S_RST <= '1' after 4 ns, '0' after 250 ns, '1' after 300 ns;

S_W_address<="0000" after 5 ns;
S_DATA <= "00011000" after 5 ns;
S_A_address <= "0000" after 200 ns;
S_B_address <= "0000" after 300 ns;

end Behavioral;
