----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/11/2022 06:53:55 PM
-- Design Name: 
-- Module Name: bram - Behavioral
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
use ieee.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity bram is
  Port (
    clka : IN STD_LOGIC;
    ena : IN STD_LOGIC;
    wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    addra : IN STD_LOGIC_VECTOR(12 DOWNTO 0);
    dina : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    clkb : IN STD_LOGIC;
    enb : IN STD_LOGIC;
    web : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    addrb : IN STD_LOGIC_VECTOR(12 DOWNTO 0);
    dinb : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    doutb : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
   );
end bram;

architecture Behavioral of bram is
    type ram_type is array (8192 downto 0) of std_logic_vector(31 downto 0);
    shared variable RAM: ram_type;
begin
    process(clka)
    begin
        if(rising_edge(clka)) then
            if(ena='1') then
                douta<=RAM(to_integer(unsigned(addra)));
                if wea(0) = '1' then
                    RAM(to_integer(unsigned(addra))):=dina;
                end if;
            end if;
        end if;
    end process;
    process(clkb)
    begin
        if(rising_edge(clkb)) then
            if(enb='1') then
                doutb<=RAM(to_integer(unsigned(addrb)));
                if web(0) = '1' then
                    RAM(to_integer(unsigned(addrb))):=dinb;
                end if;
            end if;
        end if;
    end process;

end Behavioral;
