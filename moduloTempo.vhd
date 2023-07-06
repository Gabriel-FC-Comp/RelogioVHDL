-- Bibliotecas
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

-- Descrição da Entidade
ENTITY moduloTempo IS
PORT(
	clock : IN std_logic;
	habilitaEdicao : IN std_logic;
	reset : IN std_logic;
	parametro_a_editar : IN std_logic;
	control : IN std_logic;
	moduloAtivo : OUT std_logic;
	minOut : OUT natural;
	hourOut : OUT natural
);
END moduloTempo;

-- Descrição da Arquitetura
ARCHITECTURE rtc OF moduloTempo IS
	-- Declaração de sinais
	SIGNAL ticks,segundos : natural := 0;
	SIGNAL minClk, hourClk, rstMin, rstHour : std_logic := '1';
	
	-- Declaração de componentes
	COMPONENT timeMemory IS
	PORT(
		clock : IN std_logic;
		clkHour : IN std_logic;
		clkMin : IN std_logic;
		rstHour : IN std_logic;
		rstMin : IN std_logic;
		hourOut : OUT natural;
		minOut : OUT natural
	);
	END COMPONENT;
	
BEGIN
	
	moduloAtivo <= '1';
	
	tempMemo : timeMemory port map(clock,hourClk,minClk,rstHour,rstMin,hourOut,minOut);
	
	PROCESS(clock,control)
	
		VARIABLE hourCtrl,minCtrl,rstHourCtrl,rstMinCtrl : std_logic := '0';
		VARIABLE minTick : std_logic := '0';
		
	BEGIN
		
		IF(habilitaEdicao = '1') THEN
			IF(falling_edge(control)) THEN
			
				IF(parametro_a_editar = '0' AND reset = '0') THEN
					hourCtrl := '1';
				ELSIF(parametro_a_editar = '0' AND reset = '1') THEN
					rstHourCtrl := '1';
				ELSIF(parametro_a_editar = '1' AND reset = '0') THEN
					minCtrl := '1';
				ELSE
					rstMinCtrl := '1';
				END IF; -- parametro/reset
				
			END IF; -- control
		END IF;-- habilitaEdicao
		
		IF(rising_edge(clock)) THEN
			IF(ticks = 49999999) THEN
				ticks <= 0;
				segundos <= segundos + 1;
			ELSE
				ticks <= ticks + 1;
			END IF; -- ticks
			
			IF(segundos = 60) THEN
				segundos <= 0;
				minTick := '1';
			END IF;
			
			hourClk 	<= '1';
			minClk 	<= '1';
			rstHour 	<= '1';
			rstMin 	<= '1';
		END IF; -- clock		
		
		IF(minTick = '1' OR minCtrl = '1') THEN
			minClk 	<= '0';
			minTick 	:= '0';
			minCtrl 	:= '0';
		END IF;
		
		IF(hourCtrl = '1') THEN
			hourCtrl := '0';
			hourClk <= '0';
		END IF;
		
		IF(rstHourCtrl = '1') THEN
			rstHourCtrl := '0';
			rstHour <= '0';
		END IF;
		
		IF(rstMinCtrl = '1') THEN
			rstMinCtrl := '0';
			rstMin <= '0';
		END IF;
		
	END PROCESS;
	
	
END rtc;