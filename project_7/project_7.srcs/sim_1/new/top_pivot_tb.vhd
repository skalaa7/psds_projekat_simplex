----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/09/2022 10:03:30 AM
-- Design Name: 
-- Module Name: top_pivot_tb - Behavioral
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
use ieee.std_logic_arith.all;
--use ieee.fixed_pkg.all;
--use ieee.std_logic_texio.all;
use ieee.std_logic_textio.all;
--use ieee.numeric_std.all;
use std.textio.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top_pivot_tb is
--  Port ( );
end top_pivot_tb;

architecture Behavioral of top_pivot_tb is
component top_pivot
      Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           start : in STD_LOGIC;
           ready : out STD_LOGIC;
           --software to memory
           en_s : IN STD_LOGIC;
           we_s : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
           addr_s : IN STD_LOGIC_VECTOR(12 DOWNTO 0);
           data_in_s : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
           data_out_s : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) );
  end component;
 
  
signal clk,reset, start_tb, ready_tb, en_s_tb, we_s_tb: std_logic;
signal  addr_s_tb: STD_LOGIC_VECTOR(12 DOWNTO 0);
signal data_in_s_tb, data_out_s_tb : STD_LOGIC_VECTOR(31 DOWNTO 0);

begin

duv: top_pivot
 Port map( clk => clk,
        reset =>reset,
        start =>start_tb,
        ready =>ready_tb,
        en_s =>en_s_tb,
        we_s(0) =>we_s_tb,
        addr_s =>addr_s_tb,
        data_in_s =>data_in_s_tb,
        data_out_s =>data_out_s_tb);

clk_gen: process
    begin
        clk <= '0', '1' after 10ns;
        wait for 20ns;
    end process;



stim_gen: process
   file in_buffer: text;
   variable v_ILINE: line ;
   --for every casez
    variable val_int: integer := 0;
    variable val_std: std_logic_vector(31 downto 0) := (others => '0');
    variable tmp: integer := 0;
    
   variable cnt: integer; 
   
   file out_buff: text open write_mode is "C:\Users\Andrej\Desktop\GithubProjekat\data_for_tb\rez.txt";
   variable v_OLINE: line;
    begin
 
       reset <= '0';
       start_tb <= '0';
       en_s_tb <= '0';
       we_s_tb <= '0';
       addr_s_tb <= (others => '0');
       data_in_s_tb <= (others => '0');
       
       reset <= '1';  
       wait for 50 ns;
       reset <= '0';
       
       wait for 10 ns;     
       wait until falling_edge(clk);
       
       
       --INPUT SELO
       file_open(in_buffer, "C:\Users\Andrej\Desktop\GithubProjekat\data_for_tb\ulazhex.txt");
       
       en_s_tb <= '1';
       we_s_tb <= '1';
       cnt := -2;   --CNT!!!!!!!!!!!
       l1: for i in 0 to 5151 loop
        readline(in_buffer, v_ILINE);
        report "pre citanja cnt; " & integer'image(i);
        hread(v_ILINE, val_std);
        addr_s_tb <= conv_std_logic_vector(i, addr_s_tb'length);
        data_in_s_tb <= val_std;
        report "after writing in bram, cnt: " & integer'image(i);
        wait until falling_edge(clk);
       end loop L1;
      
       --l1:  while not endfile(in_buffer) loop
       --     readline(in_buffer, v_ILINE);
       --     report "pre citanja cnt; " & integer'image(cnt);
       --     hread(v_ILINE, val_std);
       -- 
       --     addr_s_tb <= conv_std_logic_vector(cnt, addr_s_tb'length);
       --     data_in_s_tb <= val_std;
       -- 
       --     cnt := cnt + 1;
       -- 
       --    report "after writing in bram, cnt: " & integer'image(cnt);
       --  wait until falling_edge(clk);
       -- end loop l1;
        
        en_s_tb <= '0'; 
        
        report "first loop end";
        file_close(in_buffer);
        report "second loop end";
        
        cnt := 0;
        -- IP CORE IS WORKING      
        start_tb <= '1';
        wait for 20 ns;
        wait until falling_edge(clk);
        start_tb <= '0';
        wait until ready_tb = '1';
        --IP CORE ENDED OPERATION
        
        
        writing:for i in 0 to 5153 loop
           en_s_tb <= '1';
           we_s_tb <= '0';
           addr_s_tb <= conv_std_logic_vector(i,  addr_s_tb'length);
           wait until rising_edge(clk);
           if(i > 1) then
              hwrite(v_OLINE, data_out_s_tb);
              writeline(out_buff, v_OLINE); 
           end if;
           wait until falling_edge(clk);
        end loop writing;    
   file_close(out_buff); 
    report "STOP!!!!!!";
    addr_s_tb <= (others => '0');
    wait until rising_edge(clk);
    wait until rising_edge(clk);
    wait until rising_edge(clk);
    addr_s_tb <= "0000000000001";
   wait;
 end process;
end Behavioral;
 --reset <= '1', '0' after 20ns;
        
        --addr_s_tb <= "0000000000000" , "0000000000001" after 40ns, "0000000000010" after 60ns, 
       --              "0000000000000" after 80ns, "0000000000001" after 100ns, "0000000000010" after 120ns;
        --data_in_s_tb <= "00000000000000000000000000001111",
       --                 "00000000000000000000000011110000" after 20ns,
       --                 "00000000000000000000111100000000" after 40ns;  
        --en_s_tb <= '1';
        --we_s_tb <= '1', '0' after 80ns;
        --start_tb <= '0';