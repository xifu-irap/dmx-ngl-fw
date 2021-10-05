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
--!   @file                   pkg_project.vhd
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--    Automatic Generation    No
--    Code Rules Reference    SOC of design and VHDL handbook for VLSI development, CNES Edition (v2.1)
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--!   @details                Specific project constants
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
library ieee;
use     ieee.std_logic_1164.all;

library work;
use     work.pkg_func_math.all;
use     work.pkg_fpga_tech.all;

package pkg_project is

   -- ------------------------------------------------------------------------------------------------------
   --    System parameters
   --    @Req : DRE-DMX-FW-REQ-0040
   --    @Req : DRE-DMX-FW-REQ-0120
   --    @Req : DRE-DMX-FW-REQ-0270
   --    @Req : DRE-DMX-FW-REQ-0520
   -- ------------------------------------------------------------------------------------------------------
constant c_FW_VERSION         : integer   :=  1                                                             ; --! Firmware version

constant c_FF_RST_NB          : integer   := 3                                                              ; --! Flip-Flop number used for internal reset: System Clock
constant c_FF_RST_SQ1_DAC_NB  : integer   := 6                                                              ; --! Flip-Flop number used for internal reset: DAC Clock
constant c_FF_RST_SQ1_ADC_NB  : integer   := 6                                                              ; --! Flip-Flop number used for internal reset: ADC Clock
constant c_FF_RSYNC_NB        : integer   := 2                                                              ; --! Flip-Flop number used for FPGA input resynchronization

constant c_CLK_REF_MULT       : integer   := 1                                                              ; --! Reference Clock multiplier frequency factor
constant c_CLK_MULT           : integer   := 1                                                              ; --! System Clock multiplier frequency factor
constant c_CLK_ADC_MULT       : integer   := 2                                                              ; --! ADC Clock multiplier frequency factor
constant c_CLK_DAC_MULT       : integer   := 2                                                              ; --! DAC Clock multiplier frequency factor

   -- ------------------------------------------------------------------------------------------------------
   --  c_PLL_MAIN_VCO_MULT conditions to respect:
   --    - NG-LARGE:
   --       * Must be a common multiplier with c_CLK_REF_MULT, c_CLK_ADC_MULT, c_CLK_DAC_MULT and c_CLK_MULT
   --       * Vco frequency range : 200 MHz <= c_PLL_MAIN_VCO_MULT * c_CLK_COM_FREQ    <= 800 MHz
   --       * WFG pattern size    :            c_PLL_MAIN_VCO_MULT/  c_CLK_REF_MULT    <= 16
   -- ------------------------------------------------------------------------------------------------------
constant c_PLL_MAIN_VCO_MULT  : integer   := 12                                                             ; --! PLL main VCO multiplier frequency factor

constant c_CLK_COM_FREQ       : integer   := 60000000                                                       ; --! Clock frequency common to main clocks (Hz)
constant c_CLK_REF_FREQ       : integer   := c_CLK_REF_MULT      * c_CLK_COM_FREQ                           ; --! Reference Clock frequency (Hz)
constant c_CLK_FREQ           : integer   := c_CLK_MULT          * c_CLK_COM_FREQ                           ; --! System Clock frequency (Hz)
constant c_CLK_ADC_FREQ       : integer   := c_CLK_ADC_MULT      * c_CLK_COM_FREQ                           ; --! ADC Clock frequency (Hz)
constant c_CLK_DAC_FREQ       : integer   := c_CLK_DAC_MULT      * c_CLK_COM_FREQ                           ; --! DAC Clock frequency (Hz)
constant c_PLL_MAIN_VCO_FREQ  : integer   := c_PLL_MAIN_VCO_MULT * c_CLK_COM_FREQ                           ; --! PLL main VCO frequency (Hz)

constant c_CLK_ADC_DEL_STEP   : integer   := div_floor(15*10**5/(c_CLK_ADC_FREQ/10**6) - 4400,c_IO_DEL_STEP); --! ADC Clock propagation delay step number

   -- ------------------------------------------------------------------------------------------------------
   --    Interface parameters
   --    @Req : DRE-DMX-FW-REQ-0340
   --    @Req : DRE-DMX-FW-REQ-0530
   --    @Req : DRE-DMX-FW-REQ-0550
   --    @Req : DRE-DMX-FW-REQ-0560
   -- ------------------------------------------------------------------------------------------------------
constant c_BRD_REF_S          : integer   := 5                                                              ; --! Board reference size bus
constant c_BRD_MODEL_S        : integer   := 2                                                              ; --! Board model size bus

constant c_SQ1_ADC_DATA_S     : integer   := 14                                                             ; --! SQUID1 ADC data size bus
constant c_SQ1_DAC_DATA_S     : integer   := 14                                                             ; --! SQUID1 DAC data size bus

constant c_SQ2_SPI_CPOL       : std_logic := '0'                                                            ; --! SQUID2 DAC SPI: Clock polarity
constant c_SQ2_SPI_CPHA       : std_logic := '0'                                                            ; --! SQUID2 DAC SPI: Clock phase
constant c_SQ2_SPI_SER_WD_S   : integer   := 16                                                             ; --! SQUID2 DAC SPI: Data bus size
constant c_SQ2_SPI_SCLK_L     : integer   := 1                                                              ; --! SQUID2 DAC SPI: Number of clock period for elaborating SPI Serial Clock low level
constant c_SQ2_SPI_SCLK_H     : integer   := 1                                                              ; --! SQUID2 DAC SPI: Number of clock period for elaborating SPI Serial Clock high level
constant c_SQ2_DAC_MUX_S      : integer   := 3                                                              ; --! SQUID2 DAC  Multiplexer size

constant c_SC_DATA_SER_W_S    : integer   := 8                                                              ; --! Science data serial word size
constant c_SC_DATA_SER_NB     : integer   := 2                                                              ; --! Science data serial link number by DEMUX column

constant c_HK_SPI_CPOL        : std_logic := '1'                                                            ; --! HK SPI: Clock polarity
constant c_HK_SPI_CPHA        : std_logic := '1'                                                            ; --! HK SPI: Clock phase
constant c_HK_SPI_SER_WD_S    : integer   := 16                                                             ; --! HK SPI: Data bus size
constant c_HK_SPI_SCLK_L      : integer   := 2                                                              ; --! HK SPI: Number of clock period for elaborating SPI Serial Clock low level
constant c_HK_SPI_SCLK_H      : integer   := 2                                                              ; --! HK SPI: Number of clock period for elaborating SPI Serial Clock high level
constant c_HK_MUX_S           : integer   := 3                                                              ; --! HK Multiplexer size

constant c_EP_CMD_S           : integer   := 32                                                             ; --! EP command bus size
constant c_EP_SPI_CPOL        : std_logic := '0'                                                            ; --! EP SPI Clock polarity
constant c_EP_SPI_CPHA        : std_logic := '0'                                                            ; --! EP SPI Clock phase
constant c_EP_SPI_WD_S        : integer   := c_EP_CMD_S/2                                                   ; --! EP SPI Data word size (receipt/transmit)
constant c_EP_SPI_TX_WD_NB_S  : integer   := 1                                                              ; --! EP SPI Data word to transmit number size
constant c_EP_SPI_RX_WD_NB_S  : integer   := 2                                                              ; --! EP SPI Receipted data word number size (more than expected, command length control)

   -- ------------------------------------------------------------------------------------------------------
   --    Inputs default value at reset
   -- ------------------------------------------------------------------------------------------------------
constant c_I_SPI_DATA_DEF     : std_logic := '0'                                                            ; --! SPI data input default value at reset
constant c_I_SPI_SCLK_DEF     : std_logic := c_EP_SPI_CPOL                                                  ; --! SPI Serial Clock input default value at reset
constant c_I_SPI_CS_N_DEF     : std_logic := '1'                                                            ; --! SPI Chip Select input default value at reset
constant c_I_SQ1_ADC_DATA_DEF : std_logic_vector(c_SQ1_ADC_DATA_S-1 downto 0):= (others =>'0')              ; --! SQUID1 ADC data input default value at reset
constant c_I_SQ1_ADC_OOR_DEF  : std_logic := '0'                                                            ; --! SQUID1 ADC out of range input default value at reset
constant c_I_SYNC_DEF         : std_logic := '1'                                                            ; --! Pixel sequence synchronization default value at reset

   -- ------------------------------------------------------------------------------------------------------
   --    Project parameters
   --    @Req : DRE-DMX-FW-REQ-0070
   --    @Req : DRE-DMX-FW-REQ-0080
   -- ------------------------------------------------------------------------------------------------------
constant c_MUX_FACT           : integer   := 34                                                             ; --! DEMUX: multiplexing factor
constant c_NB_COL             : integer   := 4                                                              ; --! DEMUX: column number

constant c_SQ1_DATA_ERR_S     : integer   := 18                                                             ; --! SQUID1 Data error bus size
constant c_SQ1_DATA_FBK_S     : integer   := 16                                                             ; --! SQUID1 Data feedback bus size (<= c_MULT_ALU_PORTB_S-1)
constant c_SQ1_PLS_SHP_A_EXP  : integer   := 16                                                             ; --! Pulse shaping: Filter exponent parameter (<=c_MULT_ALU_PORTC_S-c_SQ1_PLS_SHP_X_K_S-1)

constant c_PIX_POS_SW_ON      : integer   := 2                                                              ; --! Pixel position for command switch clocks on
constant c_PIX_POS_SW_ADC_OFF : integer   := c_MUX_FACT - 1                                                 ; --! Pixel position for command ADC switch clocks off

   -- ------------------------------------------------------------------------------------------------------
   --    SQUID1 ADC parameters
   --    @Req : DRE-DMX-FW-REQ-0130
   -- ------------------------------------------------------------------------------------------------------
constant c_PIXEL_ADC_NB_CYC   : integer   := 22                                                             ; --! ADC clock period number allocated to one pixel acquisition
constant c_ADC_DATA_NPER      : integer   := 13                                                             ; --! ADC clock period number between the acquisition start and data output by the ADC

   -- ------------------------------------------------------------------------------------------------------
   --    SQUID1 DAC parameters
   -- ------------------------------------------------------------------------------------------------------
constant c_PIXEL_DAC_NB_CYC   : integer   := c_PIXEL_ADC_NB_CYC                                             ; --! DAC clock period number allocated to one pixel acquisition

   -- ------------------------------------------------------------------------------------------------------
   --    Global types
   -- ------------------------------------------------------------------------------------------------------
type     t_sq1_adc_data_v      is array (natural range <>) of std_logic_vector(c_SQ1_ADC_DATA_S-1  downto 0); --! SQUID1 ADC data vector type
type     t_sq1_data_err_v      is array (natural range <>) of std_logic_vector(c_SQ1_DATA_ERR_S-1  downto 0); --! SQUID1 Data error vector type
type     t_sq1_data_fbk_v      is array (natural range <>) of std_logic_vector(c_SQ1_DATA_FBK_S-1  downto 0); --! SQUID1 Data feedback vector type
type     t_sc_data_w           is array (natural range <>) of std_logic_vector(c_SC_DATA_SER_W_S-1 downto 0); --! Science data word type

end pkg_project;
