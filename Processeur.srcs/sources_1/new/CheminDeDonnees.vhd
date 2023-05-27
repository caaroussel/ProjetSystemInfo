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
        Disable : in STD_LOGIC;
        CLK : in STD_LOGIC;
        RST : in STD_LOGIC
    );
end Component;  

-- Global

signal global_IP : STD_LOGIC_VECTOR (7 downto 0);

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
signal lc_mem : STD_LOGIC;
-- Signal MUL

signal mul_di : STD_LOGIC_VECTOR (7 downto 0);
signal mul_ex : STD_LOGIC_VECTOR (7 downto 0);
signal mul_mem2 : STD_LOGIC_VECTor (7 downto 0);
signal mul_mem1 : STD_LOGIC_VECTor (7 downto 0);

-- signal ALU

signal sortie_ALU : STD_LOGIC_VECTOR (7 downto 0);
signal flag_N : STD_LOGIC;
signal flag_Z : STD_LOGIC;

-- signal data

signal sortie_DATA : STD_LOGIC_VECTOR (7 downto 0);

-- signal aléa

signal read_li : STD_LOGIC :='0';
signal write_di : STD_LOGIC;
signal write_ex : STD_LOGIC;
signal alea_di : STD_LOGIC :='0';
signal alea_ex : STD_LOGIC :='0';
signal ALEA : STD_LOGIC :='0';

signal Gestion_ALEA : STD_LOGIC := '0';
signal count_CLK : STD_LOGIC_VECTOR (1 downto 0):="00";


-- signal jump 

signal cond : STD_LOGIC;
signal cond_remplie : STD_LOGIC;

begin

process
begin 
    wait until CLK'Event and CLK='1';
    if rst = '0' then
            global_IP <= "00000000";
    elsif Gestion_ALEA ='0' then
            global_IP <= (global_IP + "00000001");
    elsif Gestion_ALEA='1' then 
        if (li_op="00001010") then
            global_IP <= li_a;
        elsif (cond_remplie = '0' and li_op="00001011" and cond='0')then
            global_IP<=li_a;
        end if;
    end if;
end process;

process
begin 
    wait until CLK'Event and CLK='1';
    if (ALEA = '1' and alea_di='1')  then
        count_CLK<="10";
    elsif (ALEA = '1' and alea_ex='1') or cond='1' then
        count_CLK<="01";

    end if;
    if count_CLK/="00" then
        count_CLK <= (count_CLK - "01");
    end if;
end process;
     
cond<= '1' when di_op(7) = '1'  else '0';   
   
Gestion_ALEA <= '1' when ALEA = '1' or count_CLK/="00" or cond='1' or li_op="00001010" else '0';  


-- détection aléa

read_li <= '1' when li_op="00000101" or li_op="00001000" or li_op="00000001" or li_op="00000010" or li_op="00000011" or li_op="10000011" or li_op="10010011" or li_op="10100011" or li_op="10110011" or li_op="11000011" or li_op="11010011" else '0';
write_di <= '0' when di_op="00001000" else '1';
write_ex <= '0' when ex_op="00001000" else '1';

alea_di <= '1' when ((read_li='1' and write_di='1') and (li_b = di_a or li_c=di_a)) else '0';
alea_ex <= '1' when ((read_li='1' and write_ex='1') and (li_b = ex_a or li_c=ex_a)) else '0';

ALEA <= '1' when alea_di='1' or alea_ex='1' else '0';

--cond_remplie <= '1' when (mem_op="10000011" and flag_Z ='1'); --EQ
--cond_remplie <= '1' when (mem_op="10010011" and flag_Z ='0'); --NE
--cond_remplie <= '1' when (mem_op="10100011" and flag_N ='1'); --LT
--cond_remplie <= '1' when (mem_op="10110011" and flag_N ='0'); --GT
--cond_remplie <= '1' when (mem_op="11000011" and (flag_N ='1' or flag_Z='0')); --LE
--cond_remplie <= '1' when (mem_op="11010011" and (flag_N ='0' or flag_Z='0')); --GE

cond_remplie <= '1' when ((ex_op="10000011" and flag_Z ='1') or (ex_op="10010011" and flag_Z ='0') or (ex_op="10100011" and flag_N ='1') or (ex_op="10110011" and flag_N ='0') or (ex_op="11000011" and (flag_N ='1' or flag_Z='0')) or (ex_op="11010011" and (flag_N ='0' or flag_Z='0'))) else '0'; 

pipeline_li_di : Pipeline Port map (
    A_in => li_a,
    B_in => li_b,
    C_in => li_c,
    OP_in => li_op,
    A_out => di_a,
    B_out => di_b,
    C_out => di_c,
    OP_out => di_op,
    Disable => Gestion_ALEA,
    CLK => CLK,
    RST => RST
);

pipeline_di_ex : Pipeline Port map (
    A_in => di_a,
    B_in => mul_di,
    C_in => br_Qb,
    OP_in => di_op,
    A_out => ex_a,
    B_out => ex_b,
    C_out => ex_c,
    OP_out => ex_op,
    Disable => '0',
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
    Disable => '0',
    CLK => CLK,
    RST => RST
);

pipeline_mem_re : Pipeline Port map (
    A_in => mem_a,
    B_in => mul_mem2,
    C_in => mem_c,
    OP_in => mem_op,
    A_out => re_a,
    B_out => re_b,
    C_out => re_c,
    OP_out => re_op,
    Disable => '0',
    CLK => CLK,
    RST => RST
);

lc_re <= '1' when re_op = "00000110" or re_op = "00000101" or re_op = "00000111" or re_op = "00000001" or re_op = "00000010" or re_op = "00000011" else '0';

-- MUX BR 

with di_op select
    mul_di <= di_b when "00000110", -- afc = "0x06"
            br_QA when "00000101", -- cop = "0x05"
            br_QA when "00000001", -- add = "0x01"
            br_QA when "00000010", -- mul = "0x02"
            br_QA when "00000011", -- sou = "0x03"
            di_b when "00000111", -- LOAD = "0x07"
            br_QA when "00001000", -- STORE = "0x08"
            br_QA when "10000011", -- EQ
            br_QA when "10010011", -- NE
            br_QA when "10100011", -- LT
            br_QA when "10110011", -- GT
            br_QA when "11000011", -- LE
            br_QA when "11010011", -- GE
            "00000000" when others;

br_A_address <= di_b (3 downto 0);
br_B_address <= di_c (3 downto 0);
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
            ex_b when "00000111", -- LOAD = "0x07"
            ex_b when "00001000", -- STORE = "0x08"
            sortie_ALU when "10000011", -- EQ
            sortie_ALU when "10010011", -- NE
            sortie_ALU when "10100011", -- LT
            sortie_ALU when "10110011", -- GT
            sortie_ALU when "11000011", -- LE
            sortie_ALU when "11010011", -- GE
            "00000000" when others;
   
lc_ex <= ex_op (2 downto 0);


-- MUX DATA

with mem_op select
    mul_mem2 <= mem_b when "00000110", -- afc = "0x06"
            mem_b when "00000101", -- cop = "0x05"
            mem_b when "00000001", -- add = "0x01"
            mem_b when "00000010", -- mul = "0x02"
            mem_b when "00000011", -- sou = "0x03"
            sortie_DATA when "00000111", -- LOAD = "0x07"
            mem_b when "00001000", -- STORE = "0x08"
            "00000000" when others;
            

with mem_op select
    mul_mem1 <= mem_b when "00000110", -- afc = "0x06"
            mem_b when "00000101", -- cop = "0x05"
            mem_b when "00000001", -- add = "0x01"
            mem_b when "00000010", -- mul = "0x02"
            mem_b when "00000011", -- sou = "0x03"
            mem_b when "00000111", -- LOAD = "0x07"
            mem_a when "00001000", -- STORE = "0x08"
            "00000000" when others;

lc_mem <= '1' when mem_op = "00001000"  else '0';

alu : UAL Port map(
        a => ex_b,
        b => ex_c,
        op => lc_ex,
        result => sortie_ALU,
        N => flag_N,
        Z=> flag_Z
        --O : out STD_LOGIC;
        --C : out STD_LOGIC
);

data : Memoire_Donnee Port map (
        CLK => CLK,
        Addr => mul_mem1,
        Data_in => mem_b,
        Data_out => sortie_DATA,
        Write_en => lc_mem,
        RST => RST
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
