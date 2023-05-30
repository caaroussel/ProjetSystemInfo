----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 17.05.2023 09:18:13
-- Design Name: 
-- Module Name: Test_donnee_AFC - Behavioral
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

entity Test_donnee_AFC is
--  Port ( );
end Test_donnee_AFC;

architecture Behavioral of Test_donnee_AFC is
COMPONENT CheminDeDonnees
    Port ( 
        RST : in  std_logic;
        CLK : in  std_logic;
        QA : out std_logic_vector(7 downto 0);
        QB : out std_logic_vector(7 downto 0)
    );
end COMPONENT;

--Inputs
signal S_Clock : STD_LOGIC := '0';
signal S_RST : STD_LOGIC;

--Outputs
signal S_QA : std_logic_vector(7 downto 0);
signal S_QB : std_logic_vector(7 downto 0);

-- Clock period definitions
-- Si 100 MHz
constant Clock_period : time := 10 ns;


begin

Label_uut: CheminDeDonnees PORT MAP(
    QA => S_QA,
    QB => S_QB,
    CLK => S_Clock,
    RST => S_RST
);


Clock_process : process
begin
    S_Clock <= not(S_Clock);
    wait for Clock_period/2;
end process;

S_RST <='0' after 0 ns, '1' after 50 ns;


end Behavioral;