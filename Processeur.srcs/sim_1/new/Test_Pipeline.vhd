----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 17.05.2023 10:49:13
-- Design Name: 
-- Module Name: Test_Pipeline - Behavioral
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

entity Test_Pipeline is
--  Port ( );
end Test_Pipeline;

architecture Behavioral of Test_Pipeline is

COMPONENT Pipeline
    Port(
        A_in : in STD_LOGIC_VECTOR (7 downto 0);
        B_in : in STD_LOGIC_VECTOR (7 downto 0);
        C_in : in STD_LOGIC_VECTOR (7 downto 0);
        OP_in : in STD_LOGIC_VECTOR (7 downto 0);
        A_out : out STD_LOGIC_VECTOR (7 downto 0);
        B_out : out STD_LOGIC_VECTOR (7 downto 0);
        C_out : out STD_LOGIC_VECTOR (7 downto 0);
        OP_out : out STD_LOGIC_VECTOR (7 downto 0);
        CLK : in STD_LOGIC;
        RST : in STD_LOGIC
    );
end COMPONENT;

--Inputs
signal S_A_in : STD_LOGIC_VECTOR (7 downto 0);
signal S_B_in : STD_LOGIC_VECTOR (7 downto 0);
signal S_C_in : STD_LOGIC_VECTOR (7 downto 0);
signal S_OP_in : STD_LOGIC_VECTOR (7 downto 0);
signal S_Clock : STD_LOGIC := '0';
signal S_RST : STD_LOGIC := '1';

--Outputs
signal S_A_out : STD_LOGIC_VECTOR (7 downto 0);
signal S_B_out : STD_LOGIC_VECTOR (7 downto 0);
signal S_C_out : STD_LOGIC_VECTOR (7 downto 0);
signal S_OP_out : STD_LOGIC_VECTOR (7 downto 0);

-- Clock period definitions
-- Si 100 MHz
constant Clock_period : time := 10 ns;


begin

Label_uut: Pipeline PORT MAP(
    A_in => S_A_in,
    B_in => S_B_in,
    C_in => S_C_in,
    OP_in => S_OP_in,
    A_out => S_A_out,
    B_out => S_B_out,
    C_out => S_C_out,
    OP_out => S_OP_out,
    CLK => S_Clock,
    RST => S_RST
);


Clock_process : process
begin
    S_Clock <= not(S_Clock);
    wait for Clock_period/2;
end process;

S_RST <='1' after 0 ns, '0' after 100 ns , '1' after 150 ns, '0' after 200 ns;
S_A_in <= "00000001" after 0 ns , "00000011" after 150 ns;
S_B_in <= "00000001" after 0 ns , "00000011" after 150 ns;
S_C_in <= "00000001" after 0 ns , "00000011" after 150 ns;
S_OP_in <= "00000001" after 0 ns , "00000011" after 150 ns;

end Behavioral;
