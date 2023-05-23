----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12.05.2023 13:57:26
-- Design Name: 
-- Module Name: CheminDeDonnees - Behavioral
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

entity CheminDeDonnees is
  Port ( 
        RST : in  std_logic;
        CLK : in  std_logic;
        QA : out std_logic_vector(7 downto 0);
        QB : out std_logic_vector(7 downto 0)
  );
end CheminDeDonnees;

architecture Behavioral of CheminDeDonnees is

Component UAL
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
end Component;

Component BR
    Port(
        A_address : in STD_LOGIC_VECTOR (3 downto 0);
        B_address : in STD_LOGIC_VECTOR (3 downto 0);
        W_address : in STD_LOGIC_VECTOR (3 downto 0);
        W : in STD_LOGIC;
        DATA : in STD_LOGIC_VECTOR (7 downto 0);
        CLK : in STD_LOGIC;
        RST : in STD_LOGIC;
        QA : out STD_LOGIC_VECTOR (7 downto 0);
        QB : out STD_LOGIC_VECTOR (7 downto 0)
    );
end Component;

Component Memoire_Donnee
    Port(
        CLK : in STD_LOGIC;
        Addr : in std_logic_vector(7 downto 0);
        Data_in : in std_logic_vector(7 downto 0);
        Data_out : out std_logic_vector(7 downto 0);
        Write_en : in std_logic;
        RST: in std_logic
    );
end Component; 

Component Memoire_Instruction
    Port(
        Sortie : out STD_LOGIC_VECTOR (31 downto 0);
        Addr : in STD_LOGIC_VECTOR (7 downto 0);
        CLK : in STD_LOGIC
    );
end Component;  

Component Pipeline
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
end Component;  

-- Global

signal global_IP : STD_LOGIC_VECTOR (7 downto 0) := (others =>  '0');

-- Signal BR

signal br_A_address : STD_LOGIC_VECTOR (3 downto 0);
signal br_B_address : STD_LOGIC_VECTOR (3 downto 0);
signal br_W_address : STD_LOGIC_VECTOR (3 downto 0);
signal br_W : STD_LOGIC;
signal br_DATA : STD_LOGIC_VECTOR (7 downto 0);
signal br_QA : STD_LOGIC_VECTOR (7 downto 0);
signal br_QB : STD_LOGIC_VECTOR (7 downto 0);

-- Signal EX

signal ex_a : STD_LOGIC_VECTOR (7 downto 0);
signal ex_b : STD_LOGIC_VECTOR (7 downto 0);
signal ex_c : STD_LOGIC_VECTOR (7 downto 0);
signal ex_op : STD_LOGIC_VECTOR (7 downto 0);

-- Signal DI

signal di_a : STD_LOGIC_VECTOR (7 downto 0);
signal di_b : STD_LOGIC_VECTOR (7 downto 0);
signal di_c : STD_LOGIC_VECTOR (7 downto 0);


signal di_op : STD_LOGIC_VECTOR (7 downto 0);

-- Signal Mem

signal mem_a : STD_LOGIC_VECTOR (7 downto 0);
signal mem_b : STD_LOGIC_VECTOR (7 downto 0);
signal mem_c : STD_LOGIC_VECTOR (7 downto 0);
signal mem_op : STD_LOGIC_VECTOR (7 downto 0);

-- Signal LI
signal mi_sortie : STD_LOGIC_VECTOR (31 downto 0);
signal li_a : STD_LOGIC_VECTOR (7 downto 0);
signal li_b : STD_LOGIC_VECTOR (7 downto 0);
signal li_c : STD_LOGIC_VECTOR (7 downto 0);
signal li_op : STD_LOGIC_VECTOR (7 downto 0);

-- Signal RE

signal re_a : STD_LOGIC_VECTOR (7 downto 0);
signal re_b : STD_LOGIC_VECTOR (7 downto 0);
signal re_c : STD_LOGIC_VECTOR (7 downto 0);
signal re_op : STD_LOGIC_VECTOR (7 downto 0);

-- Signal LC

signal lc_re : STD_LOGIC;
signal lc_ex : STD_LOGIC_VECTOR (2 downto 0);

-- Signal MUL

signal mul_di : STD_LOGIC_VECTOR (7 downto 0);
signal mul_ex : STD_LOGIC_VECTOR (7 downto 0);

-- signal ALU

signal sortie_ALU : STD_LOGIC_VECTOR (7 downto 0);

begin

process
begin 
    wait until CLK'Event and CLK='1';
    global_IP <= (global_IP + "00000001");
end process;

pipeline_li_di : Pipeline Port map (
    A_in => li_a,
    B_in => li_b,
    C_in => li_c,
    OP_in => li_op,
    A_out => di_a,
    B_out => di_b,
    C_out => di_c,
    OP_out => di_op,
    CLK => CLK,
    RST => RST
);

pipeline_di_ex : Pipeline Port map (
    A_in => di_a,
    B_in => mul_di,
    C_in => di_c,
    OP_in => di_op,
    A_out => ex_a,
    B_out => ex_b,
    C_out => ex_c,
    OP_out => ex_op,
    CLK => CLK,
    RST => RST
);

pipeline_ex_mem : Pipeline Port map (
    A_in => ex_a,
    B_in => mul_ex,
    C_in => ex_c,
    OP_in => ex_op,
    A_out => mem_a,
    B_out => mem_b,
    C_out => mem_c,
    OP_out => mem_op,
    CLK => CLK,
    RST => RST
);

pipeline_mem_re : Pipeline Port map (
    A_in => mem_a,
    B_in => mem_b,
    C_in => mem_c,
    OP_in => mem_op,
    A_out => re_a,
    B_out => re_b,
    C_out => re_c,
    OP_out => re_op,
    CLK => CLK,
    RST => RST
);

lc_re <= '1' when re_op = "00000110"  else '0';

-- MUX BR 

with di_op select
    mul_di <= di_b when "00000110", -- afc = "0x06"
            br_QA when "00000101", -- cop = "0x05"
            di_b when "00000001", -- add = "0x01"
            di_b when "00000010", -- mul = "0x02"
            di_b when "00000011", -- sou = "0x03"
            "00000000" when others;

br_A_address <= di_b (3 downto 0);
br_W_address <= re_a (3 downto 0);
br_DATA <= re_b;
br_W <= lc_re;


-- MUX ALU
with ex_op select
    mul_ex <= ex_b when "00000110", -- afc = "0x06"
            ex_b when "00000101", -- cop = "0x05"
            sortie_ALU when "00000001", -- add = "0x01"
            sortie_ALU when "00000010", -- mul = "0x02"
            sortie_ALU when "00000011", -- sou = "0x03"
            "00000000" when others;
   
lc_ex <= ex_op (2 downto 0);



alu : UAL Port map(
        a => ex_b,
        b => ex_c,
        op => lc_ex,
        result => sortie_ALU
        --N : out STD_LOGIC;
        --O : out STD_LOGIC;
        --Z : out STD_LOGIC;
        --C : out STD_LOGIC
);


registers : BR Port map (
    A_address => br_A_address,
    B_address => br_B_address,
    W_address => br_W_address,
    W => br_W,
    DATA => br_DATA,
    CLK => CLK,
    RST => RST,
    QA => br_QA,
    QB => br_QB
);

instructions : Memoire_Instruction Port map (
    Addr => global_IP,
    CLK => CLK,
    Sortie => mi_sortie
);

li_op <= mi_sortie(31 downto 24);
li_a <= mi_sortie(23 downto 16);
li_b <= mi_sortie(15 downto 8);
li_c <= mi_sortie(7 downto 0);
		

end Behavioral;
