----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 15.05.2023 14:41:35
-- Design Name: 
-- Module Name: Test_UAL - Behavioral
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

entity Test_UAL is
--  Port ( );
end Test_UAL;

architecture Behavioral of Test_UAL is

COMPONENT UAL
    Port(
        a : in STD_LOGIC_VECTOR (7 downto 0);
        b : in STD_LOGIC_VECTOR (7 downto 0);
        op : in STD_LOGIC_VECTOR (2 downto 0);
        result : out STD_LOGIC_VECTOR (7 downto 0);
        N : out STD_LOGIC;
        O : out STD_LOGIC;
        Z : out STD_LOGIC;
        C : out STD_LOGIC
        );
end COMPONENT;
--Inputs
signal S_a : std_logic_vector(7 downto 0);
signal S_b : std_logic_vector(7 downto 0);
signal S_op : std_logic_vector(2 downto 0);
signal S_Clock : STD_LOGIC := '0';


--Outputs
signal S_result : std_logic_vector(7 downto 0);
signal S_N : STD_LOGIC;
signal S_Z : STD_LOGIC;
signal S_O : STD_LOGIC;
signal S_C : STD_LOGIC;


-- Clock period definitions
-- Si 100 MHz
constant Clock_period : time := 10 ns;

begin

Label_uut: UAL PORT MAP(
    a=> S_a,
    b => S_b,
    op => S_op,
    N => S_N,
    O => S_O,
    Z => S_Z,
    C => S_C,
    result=>S_result
);

Clock_process : process
begin
    S_Clock <= not(S_Clock);
    wait for Clock_period/2;
end process;

S_a <= "00000100" after 0 ns, "11111111" after 500 ns;
S_b <= "00000100" after 0 ns, "00000001" after 500 ns;
S_op <= "010" after 0 ns, "001" after 500 ns;



end Behavioral;
