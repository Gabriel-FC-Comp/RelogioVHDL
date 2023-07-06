-- Copyright (C) 2022  Intel Corporation. All rights reserved.
-- Your use of Intel Corporation's design tools, logic functions 
-- and other software and tools, and any partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Intel Program License 
-- Subscription Agreement, the Intel Quartus Prime License Agreement,
-- the Intel FPGA IP License Agreement, or other applicable license
-- agreement, including, without limitation, that your use is for
-- the sole purpose of programming logic devices manufactured by
-- Intel and sold by Intel or its authorized distributors.  Please
-- refer to the applicable agreement for further details, at
-- https://fpgasoftware.intel.com/eula.

-- *****************************************************************************
-- This file contains a Vhdl test bench with test vectors .The test vectors     
-- are exported from a vector file in the Quartus Waveform Editor and apply to  
-- the top level entity of the current Quartus project .The user can use this   
-- testbench to simulate his design using a third-party simulation tool .       
-- *****************************************************************************
-- Generated on "06/03/2023 17:46:27"
                                                             
-- Vhdl Test Bench(with test vectors) for design  :          relogioVHDL
-- 
-- Simulation tool : 3rd Party
-- 

LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;                                

ENTITY relogioVHDL_vhd_vec_tst IS
END relogioVHDL_vhd_vec_tst;
ARCHITECTURE relogioVHDL_arch OF relogioVHDL_vhd_vec_tst IS
-- constants                                                 
-- signals                                                   
SIGNAL clock : STD_LOGIC;
SIGNAL disp0 : STD_LOGIC_VECTOR(0 TO 7);
SIGNAL disp1 : STD_LOGIC_VECTOR(0 TO 7);
SIGNAL disp2 : STD_LOGIC_VECTOR(0 TO 7);
SIGNAL disp3 : STD_LOGIC_VECTOR(0 TO 7);
SIGNAL disp4 : STD_LOGIC_VECTOR(0 TO 7);
SIGNAL disp5 : STD_LOGIC_VECTOR(0 TO 7);
SIGNAL editaParametro : STD_LOGIC;
SIGNAL enter : STD_LOGIC;
SIGNAL habilitaAlarme : STD_LOGIC;
SIGNAL ledsModulos : STD_LOGIC_VECTOR(0 TO 2);
SIGNAL prox : STD_LOGIC;
SIGNAL reset : STD_LOGIC;
COMPONENT relogioVHDL
	PORT (
	clock : IN STD_LOGIC;
	disp0 : BUFFER STD_LOGIC_VECTOR(0 TO 7);
	disp1 : BUFFER STD_LOGIC_VECTOR(0 TO 7);
	disp2 : BUFFER STD_LOGIC_VECTOR(0 TO 7);
	disp3 : BUFFER STD_LOGIC_VECTOR(0 TO 7);
	disp4 : BUFFER STD_LOGIC_VECTOR(0 TO 7);
	disp5 : BUFFER STD_LOGIC_VECTOR(0 TO 7);
	editaParametro : IN STD_LOGIC;
	enter : IN STD_LOGIC;
	habilitaAlarme : IN STD_LOGIC;
	ledsModulos : BUFFER STD_LOGIC_VECTOR(0 TO 2);
	prox : IN STD_LOGIC;
	reset : IN STD_LOGIC
	);
END COMPONENT;
BEGIN
	i1 : relogioVHDL
	PORT MAP (
-- list connections between master ports and signals
	clock => clock,
	disp0 => disp0,
	disp1 => disp1,
	disp2 => disp2,
	disp3 => disp3,
	disp4 => disp4,
	disp5 => disp5,
	editaParametro => editaParametro,
	enter => enter,
	habilitaAlarme => habilitaAlarme,
	ledsModulos => ledsModulos,
	prox => prox,
	reset => reset
	);

-- clock
t_prcs_clock: PROCESS
BEGIN
LOOP
	clock <= '0';
	WAIT FOR 10000 ps;
	clock <= '1';
	WAIT FOR 10000 ps;
	IF (NOW >= 1000000 ps) THEN WAIT; END IF;
END LOOP;
END PROCESS t_prcs_clock;
END relogioVHDL_arch;
