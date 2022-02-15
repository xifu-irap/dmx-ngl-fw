# dmx-NGL-fw
DRE-DEMUX TDM firmware.

   - FPGA target: NG-LARGE (NanoXplore)
   - Synthesis tool: Nxmap v3.11.1.4
   - Firmware specification:
      + IRAP/XIFU-DRE/FM/SP/0065 - DRE TDM firmware requirements, ed. 0.13
      + IRAP/XIFU-DRE/FM/SP/0069 - DRE Inter-Modules Telemetry And Commands Definition, ed. 0.5

## 1. Directories and files description

   - (dir.) **bitfile**: Bitfile generated by the synthesis tools to load in the FPGA
   - (dir.) **constraints**: Synthesis tool constraints
      + (file) **nx/pads_NG_LARGE.py**: I/O FPGA declaration
      + (file) **nx/project_constraints.py**: constraints project
      + (file) **nx/project_parameters.py**: parameters project
   - (dir.) **ip**: Synthesize source files linked to the FPGA technology
   - (dir.) **simu**: Simulation directory
      + (dir.) **conf**: Unitary test configuration files
      + (dir.) **result**: Unitary test results
      + (dir.) **script**: Modelsim scripts
      + (dir.) **tb**: Test bench and model component files for simulation
      + (dir.) **utest**: Unitary test scripts
   - (dir.) **src**: Synthesize source files independent to FPGA technology
   - (dir.) **synthesis**: Script files used by the synthesis tool
   - (file) **clean.sh**: Clean the project directories
   - (file) **Nxmap_synth.py**: Synthesis tool main script

## 2. Commands

   Modelsim and Nxmap must be previously installed.

   The script simu/script/no_regression.do must indicated the NXMAP3_MODEL_PATH where are located the vhdp files (deliver in Nxmap archive and located in /share/modelsim/).

   - Synthesis tool:
      1. Position to the root path directory
      2. Run command: nxpython Nxmap_synth.py


   - No regression analysis:
      1. Position to the path directory for result simulation storage (choosen by user)
      2. Run command: vsim -do ../../simu/script/run.do -l transcript
      3. The no regression results are stored in directory /simu/result


   - Play a specific unitary test (signal chronograms display)
      1. Position to the path directory for result simulation storage (choosen by user)
      2. Run Modelsim: vsim
      3. Run command: do ../../simu/script/no_regression.do
      4. Run function (XXXX: unitary test number on 4 characters): run_utest DRE_DMX_UT_XXXX_cfg
      5. The unitary test result is stored in directory /simu/result


   - Requirement Traceability Matrix
      1. Open Powershell
      2. Position to the root path directory
      3. Position to the path /simu/script/
      4. Run gen_trace_matrix.ps1
      5. The Requirement Traceability Matrix is stored in directory /simu/result


## 3. New unitary test creation

   For a new unitary test, it is necessary to create the following files, XXXX corresponding to unitary test number on 4 characters:
   - A script file named DRE_DMX_UT_XXXX, located in directory /simu/utest
   - A configuration VHDL file named DRE_DMX_UT_XXXX_cfg.vhd, located in directory /simu/conf.

   The configuration VHDL file can include the non nominal parameter generics of model components used by the unitary test, the generics of parser must be absolutely defined:
   - g_SIM_TIME (time)  : Simulation time
   - g_TST_NUM  (string): Test number, corresponds to the XXXX value

## 4. Discrete inputs description (seen from simulation pilot side)

   Discrete inputs are grouped together in a 64 bits field (bit position 63 is the MSB, bit position 0 is the LSB):
   - Position 0: **rst**, Internal DRE-DEMUX: Reset asynchronous assertion, synchronous de-assertion on System Clock
   - Position 1: **clk_ref**, DRE-DEMUX input, Reference Clock
   - Position 2: **clk**, Internal DRE-DEMUX: System Clock
   - Position 3: **clk_sq1_adc_acq**, Internal DRE-DEMUX: SQUID1 ADC Clock
   - Position 4: **clk_sq1_pls_shape**, Internal DRE-DEMUX: SQUID1 pulse shaping Clock
   - Position 5: **ep_cmd_busy_n**, EP SPI model output, EP - Command transmit busy ('0' = Busy, '1' = Not Busy)
   - Position 6: **ep_data_rx_rdy**, EP SPI model output, EP - Receipted data ready ('0' = Not ready, '1' = Ready)
   - Position 7+x:  **rst_sq1_adc(x)**, Internal DRE-DEMUX: Local reset asynchronous assertion, synchronous de-assertion on SQUID1 ADC column 'x' (0->3)
   - Position 11+x: **rst_sq1_dac(x)**, Internal DRE-DEMUX: Local reset asynchronous assertion, synchronous de-assertion on SQUID1 DAC column 'x' (0->3)
   - Position 15+x: **rst_sq2_mux(x)**, Internal DRE-DEMUX: Local reset asynchronous assertion, synchronous de-assertion on SQUID2 MUX column 'x' (0->3)
   - Position 19: **sync**, Pixel sequence synchronization (R.E. detected = position sequence to the first pixel)
   - Position 20+x: **sq1_adc_pwdn(x)**, SQUID1 ADC column 'x' (0->3) – ADC Power Down ('0' = Inactive, '1' = Active)
   - Position 24+x: **sq1_dac_sleep(x)**, SQUID1 DAC column 'x' (0->3) – DAC Sleep ('0' = Inactive, '1' = Active)
   - Position 28+x: **clk_sq1_adc(x)**, SQUID1 ADC column 'x' (0->3) - Clock
   - Position 32+x: **clk_sq1_dac(x)**, SQUID1 DAC column 'x' (0->3) - Clock
   - Position 63-36: Not Used

## 5. Discrete outputs description (seen from simulation pilot side)

   Discrete outputs are grouped together in a 64 bits field (bit position 63 is the MSB, bit position 0 is the LSB):
  - Position 0: **arst_n**, DRE-DEMUX input, Asynchronous reset ('0' = Active, '1' = Inactive)
  - Position 1: **brd_model(0)**, DRE-DEMUX input, Board model bit 0
  - Position 2: **brd_model(1)**, DRE-DEMUX input, Board model bit 1

## 6. Check clock parameters enable (seen from simulation pilot side)

   Enable the display in result file of the report about the check clock parameters.
   Enables are grouped together in a 64 bits field (bit position 63 is the MSB, bit position 0 is the LSB):
   - Position 0: **clk**, Internal DRE-DEMUX: System Clock
   - Position 1: **clk_sq1_adc**, Internal DRE-DEMUX: SQUID1 ADC Clock
   - Position 2: **clk_sq1_pls_shape**, Internal DRE-DEMUX: SQUID1 pulse shaping Clock
   - Position 3+x: **clk_sq1_adc(x)**, Clock SQUID1 ADC column 'x' (0->3)
   - Position 7+x: **clk_sq1_dac(x)**, Clock SQUID1 DAC column 'x' (0->3)
   - Position 11: **clk_science_01**, Science Data - Clock channel 0/1
   - Position 12: **clk_science_23**, Science Data - Clock channel 2/3

   - Position 14: **pulse_shaping**, SQUID1 DAC pulse shaping

## 7. Science packet type

   Select the science packet type
   - **science_data**
   - **test_pattern**
   - **adc_dump(0)**
   - **adc_dump(1)**
   - **adc_dump(2)**
   - **adc_dump(3)**


## 8. Unitary test script commands description

   The /simu/tb/parser.vhd file interprets the 4 characters commands located in the unitary test script.

   The commands are as follows:
   - Command CCMD **cmd** **end**: check the EP command return
      + Parameter **cmd** : EP command return value expected, constituted by the following fields, separated by delimiter "-" (Ex: R-Status-XXXX, R-Version-FW_VERSION-00):
         * *access* :
            * Value *R*: Mode read
            * Value *W*: Mode write
         * *address*: EP command name. Two manners to declare:
            * Either 16 bits hexa (underscore can be inserted), take back the register address specified in IRAP/XIFU-DRE/FM/SP/0069
            * Or take back the register name specified in IRAP/XIFU-DRE/FM/SP/0069 (case sensitive). Index between parenthesis can be informed for tables.
         * *data*: 16 bits hexa (underscore can be inserted), EP command return data. For the "Version" command, data can be dispatched by the field FW_VERSION, followed by 8 bits hexa
      + Parameter **end**:
         * Value *W*: wait the end of EP command transmit before handle a new command script
         * Value *N*: no wait time


   - Command CCPE **clock_report** : Enable the display in result file of the report about the check clock parameters
      + Parameter **clock_report** : clock parameters report select (see 6 on check clock parameters enable description)


   - Command CDIS **discrete_r** **value**: check discrete input
      + Parameter **discrete_r** : discrete input select (see 4 on discrete inputs description)
      + Parameter **value** : (1 bit U/X/0/1/Z/W/L/H/-) discrete input value expected


   - Command CLDC **channel** **value**: check level SQUID1 DAC output
      + Parameter **channel**: decimal range 0 to c_NB_COL-1, channel number
      + Parameter **value** : SQUID1 DAC output value expected in real


   - Command CSCP **science_packet** : check the science packet type
      + Parameter **science_packet** : science packet type select (see 7 on science packet type description)


   - Command CTDC **channel** **ope** **time**: check time between the current time and last event SQUID1 DAC output
      + Parameter **channel**: decimal range 0 to c_NB_COL-1, channel number
      + Parameter **ope** : ( ==, /=, <<, <=, >>, >= ), comparison operation
      + Parameter **time**: (decimal with unit ps, ns, us, ms, sec), comparison time


   - Command CTLE **discrete_r** **ope** **time**: check time between the current time and discrete input(s) last event
      + Parameter **discrete_r** : discrete input select (see 4 on discrete inputs description)
      + Parameter **ope** : ( ==, /=, <<, <=, >>, >= ), comparison operation
      + Parameter **time**: (decimal with unit ps, ns, us, ms, sec), comparison time


   - Command CTLR **ope** **time**: check time from the last record time
      + Parameter **ope** : ( ==, /=, <<, <=, >>, >= ), comparison operation
      + Parameter **time**: (decimal with unit ps, ns, us, ms, sec), comparison time


   - Command COMM: add comment in result file


   - Command RTIM: record current time


   - Command WAIT **time**: wait for time
      + Parameter **time**: (decimal with unit ps, ns, us, ms, sec), time to wait


   - Command WCMD **cmd** **end**: transmit EP command
      + Parameter **cmd** : EP command, constituted by the following fields, separated by delimiter "-" (Ex: R-Status-XXXX):
         * *access* :
            * Value *R*: Mode read
            * Value *W*: Mode write
         * *address*: EP command name. Two manners to declare:
            * Either 16 bits hexa (underscore can be inserted), take back the register address specified in IRAP/XIFU-DRE/FM/SP/0069
            * Or take back the register name specified in IRAP/XIFU-DRE/FM/SP/0069 (case sensitive). Index between parenthesis can be informed for tables.
         * *data*: 16 bits hexa (underscore can be inserted), EP command data
      + Parameter **end**:
         * Value *W*: wait the end of EP command transmit before handle a new command script
         * Value *R*: wait the end of EP command return (last command before) before handle a new command script
         * Value *N*: no wait time


   - Command WCMS **size**: write EP command word size (error case test)
      + Parameter **size** : decimal range 1 to 63, EP command word size


   - Command WDIS **discrete_w** **value**: write discrete output
      + Parameter **discrete_w** : discrete output select (see 5 on discrete outputs description)
      + Parameter **value** : (1 bit U/X/0/1/Z/W/L/H/-) discrete output value


   - Command WNBD **number**: write board reference number
      + Parameter **number**: decimal range 0 to 31, board reference number


   - Command WPFC **channel** **frequency**: write pulse shaping cut frequency for verification
      + Parameter **channel**: decimal range 0 to c_NB_COL-1, channel number
      + Parameter **frequency**: cut frequency in decimal (Hz)


   - Command WUDI **discrete_r** **value** or WUDI **mask** **data**: wait until event on discrete input(s)
      + Parameter **discrete_r** : discrete input select (see 4 on discrete inputs description)
      + Parameter **value** : (1 bit U/X/0/1/Z/W/L/H/-) discrete input value expected
      + Parameter **mask** : 64 bits hexa (underscore can be inserted), selection mask on discrete inputs (see 4 on discrete inputs description)
      + Parameter **data** : 64 bits hexa (underscore can be inserted), discrete inputs value expected

## 9. Unitary test result

   The unitary test result file is considered as pass when the last line mention "Simulation status: PASS" (FAIL otherwise).

   The dated warnings and errors are mentioned in the result file. The following global errors are indicated:
   - Error simulation time: The simulation time is not enough for handling all unitary test script commands => necessity to modify generic parameter g_SIM_TIME in the configuration VHDL file.
   - Error check discrete level: one or more discrete inputs level do not correspond to the expected value.
   - Error check command return: one or more EP command returns do not correspond to the expected value.
   - Error check time: one or more check times do not correspond to the expected comparison time.
   - Error check clocks parameters: clocks parameters error(s).
   - Error check science packets: science packets error(s) (see scd result file for description).
   - Error check pulse shaping: SQUID1 DAC pulse shaping error.


   The file transcript generated by Modelsim must equally analyzed in order to detect eventual errors and warnings.