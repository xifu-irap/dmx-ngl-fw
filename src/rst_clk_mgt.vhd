-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--                            Copyright (C) 2021-2030 Sylvain LAURENT, IRAP Toulouse.
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--                            This file is part of the ATHENA X-IFU DRE Time Domain Multiplexing Firmware.
--
--                            dmx-ngl-fw is free software: you can redistribute it and/or modify
--                            it under the terms of the GNU General Public License as published by
--                            the Free Software Foundation, either version 3 of the License, or
--                            (at your option) any later version.
--
--                            This program is distributed in the hope that it will be useful,
--                            but WITHOUT ANY WARRANTY; without even the implied warranty of
--                            MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--                            GNU General Public License for more details.
--
--                            You should have received a copy of the GNU General Public License
--                            along with this program.  If not, see <https://www.gnu.org/licenses/>.
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--    email                   slaurent@nanoxplore.com
--!   @file                   rst_clk_mgt.vhd
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--    Automatic Generation    No
--    Code Rules Reference    SOC of design and VHDL handbook for VLSI development, CNES Edition (v2.1)
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--!   @details                Manage the internal reset and generate the clocks
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
library ieee;
use     ieee.std_logic_1164.all;

library work;
use     work.pkg_project.all;

entity rst_clk_mgt is port
   (     i_arst_n             : in     std_logic                                                            ; --! Asynchronous reset ('0' = Active, '1' = Inactive)
         i_clk_ref            : in     std_logic                                                            ; --! Reference Clock

         i_cmd_ck_sq1_adc     : in     std_logic_vector(c_NB_COL-1 downto 0)                                ; --! SQUID1 ADC Clocks switch commands, synchronized on SQUID1 ADC Clock
         i_cmd_ck_sq1_dac     : in     std_logic_vector(c_NB_COL-1 downto 0)                                ; --! SQUID1 DAC Clocks switch commands, synchronized on pulse shaping Clock

         o_rst                : out    std_logic                                                            ; --! Reset asynchronous assertion, synchronous de-assertion ('0' = Inactive, '1' = Active)
         o_rst_sq1_pls_shape  : out    std_logic                                                            ; --! Reset asynchronous assertion, synchronous de-assertion ('0' = Inactive, '1' = Active)
         o_rst_sq1_adc        : out    std_logic                                                            ; --! Reset asynchronous assertion, synchronous de-assertion ('0' = Inactive, '1' = Active)

         o_clk                : out    std_logic                                                            ; --! System Clock
         o_clk_sq1_adc_acq    : out    std_logic                                                            ; --! SQUID1 ADC acquisition Clock
         o_clk_sq1_pls_shape  : out    std_logic                                                            ; --! SQUID1 pulse shaping Clock
         o_clk_sq1_adc        : out    std_logic_vector(c_NB_COL-1 downto 0)                                ; --! SQUID1 ADC Clocks
         o_clk_sq1_dac        : out    std_logic_vector(c_NB_COL-1 downto 0)                                ; --! SQUID1 DAC Clocks
         o_clk_science        : out    std_logic                                                              --! Science Data Clock
   );
end entity rst_clk_mgt;

architecture RTL of rst_clk_mgt is
signal   clk                  : std_logic                                                                   ; --! System Clock (internal)
signal   clk_sq1_adc_acq      : std_logic                                                                   ; --! SQUID1 ADC acquisition Clock (internal)
signal   clk_sq1_pls_shape    : std_logic                                                                   ; --! SQUID1 pulse shaping Clock (internal)

signal   arst_n               : std_logic                                                                   ; --! Asynchronous reset internal ('0' = Active, '1' = Inactive)
signal   pll_main_lock        : std_logic                                                                   ; --! Main Pll Status ('0' = Pll not locked, '1' = Pll locked)

signal   rst                  : std_logic_vector(        c_FF_RST_NB-1 downto 0)                            ; --! Reset asynchronous assertion, synchronous de-assertion ('0' = Inactive, '1' = Active)
signal   rst_sq1_pls_shape    : std_logic_vector(c_FF_RST_SQ1_DAC_NB-1 downto 0)                            ; --! Reset asynchronous assertion, synchronous de-assertion ('0' = Inactive, '1' = Active)
signal   rst_sq1_adc          : std_logic_vector(c_FF_RST_SQ1_ADC_NB-1 downto 0)                            ; --! Reset asynchronous assertion, synchronous de-assertion ('0' = Inactive, '1' = Active)

begin

   -- ------------------------------------------------------------------------------------------------------
   --!   Clocks generation
   -- ------------------------------------------------------------------------------------------------------
   I_pll: entity work.pll port map
   (     i_arst_n             => i_arst_n             , -- in     std_logic                                 ; --! Asynchronous reset ('0' = Active, '1' = Inactive)
         i_clk_ref            => i_clk_ref            , -- in     std_logic                                 ; --! Reference Clock
         i_cmd_ck_sq1_adc     => i_cmd_ck_sq1_adc     , -- in     std_logic_vector(c_NB_COL-1 downto 0)     ; --! SQUID1 ADC Clocks switch commands (for each column: '0' = Inactive, '1' = Active)
         i_cmd_ck_sq1_dac     => i_cmd_ck_sq1_dac     , -- in     std_logic_vector(c_NB_COL-1 downto 0)     ; --! SQUID1 DAC Clocks switch commands (for each column: '0' = Inactive, '1' = Active)
         o_clk                => clk                  , -- out    std_logic                                 ; --! System Clock
         o_clk_sq1_adc_acq    => clk_sq1_adc_acq      , -- out    std_logic                                 ; --! SQUID1 ADC acquisition Clock
         o_clk_sq1_pls_shape  => clk_sq1_pls_shape    , -- out    std_logic                                 ; --! SQUID1 pulse shaping Clock
         o_clk_sq1_adc        => o_clk_sq1_adc        , -- out    std_logic_vector(c_NB_COL-1 downto 0)     ; --! SQUID1 ADC Clocks
         o_clk_sq1_dac        => o_clk_sq1_dac        , -- out    std_logic_vector(c_NB_COL-1 downto 0)     ; --! SQUID1 DAC Clocks
         o_clk_science        => o_clk_science        , -- out    std_logic                                 ; --! Science Data Clock
         o_pll_main_lock      => pll_main_lock          -- out    std_logic                                   --! Main Pll Status ('0' = Pll not locked, '1' = Pll locked)
   );

   o_clk               <= clk;
   o_clk_sq1_pls_shape <= clk_sq1_pls_shape;
   o_clk_sq1_adc_acq   <= clk_sq1_adc_acq;

   -- ------------------------------------------------------------------------------------------------------
   --!   Asynchronous reset internal
   --    @Req : DRE-DMX-FW-REQ-0050
   -- ------------------------------------------------------------------------------------------------------
   arst_n <= i_arst_n and pll_main_lock;

   -- ------------------------------------------------------------------------------------------------------
   --!   Reset on system clock generation
   --    @Req : DRE-DMX-FW-REQ-0050
   -- ------------------------------------------------------------------------------------------------------
   P_rst : process (arst_n, clk)
   begin

      if arst_n = '0' then
         rst   <= (others => '1');

      elsif rising_edge(clk) then
         rst   <= rst(rst'high-1 downto 0) & '0';

      end if;

   end process P_rst;

   o_rst <= rst(rst'high);

   -- ------------------------------------------------------------------------------------------------------
   --!   Reset on SQUID1 pulse shaping Clock generation
   --    @Req : DRE-DMX-FW-REQ-0050
   -- ------------------------------------------------------------------------------------------------------
   P_rst_sq1_pls_shape : process (arst_n, clk_sq1_pls_shape)
   begin

      if arst_n = '0' then
         rst_sq1_pls_shape <= (others => '1');

      elsif rising_edge(clk_sq1_pls_shape) then
         rst_sq1_pls_shape <= rst_sq1_pls_shape(rst_sq1_pls_shape'high-1 downto 0) & '0';

      end if;

   end process P_rst_sq1_pls_shape;

   o_rst_sq1_pls_shape  <= rst_sq1_pls_shape(rst_sq1_pls_shape'high);

   -- ------------------------------------------------------------------------------------------------------
   --!   Reset on SQUID1 pulse shaping Clock generation
   --    @Req : DRE-DMX-FW-REQ-0050
   -- ------------------------------------------------------------------------------------------------------
   P_rst_sq1_adc : process (arst_n, clk_sq1_adc_acq)
   begin

      if arst_n = '0' then
         rst_sq1_adc <= (others => '1');

      elsif rising_edge(clk_sq1_adc_acq) then
         rst_sq1_adc <= rst_sq1_adc(rst_sq1_adc'high-1 downto 0) & '0';

      end if;

   end process P_rst_sq1_adc;

   o_rst_sq1_adc  <= rst_sq1_adc(rst_sq1_adc'high);

end architecture rtl;
