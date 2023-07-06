-- Bibliotecas
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

-- Declaração da Entidade
ENTITY timeMemory IS
PORT(
	clock : IN std_logic;                    -- Entrada do sinal de clock
	clkHour : IN std_logic;                -- Entrada do sinal de clock para as horas
	clkMin : IN std_logic;                  -- Entrada do sinal de clock para os minutos
	rstHour : IN std_logic;                -- Sinal de reset para as horas
	rstMin : IN std_logic;                  -- Sinal de reset para os minutos
	hourOut : OUT natural;                -- Saída para as horas
	minOut : OUT natural                   -- Saída para os minutos
);
END timeMemory;

-- Declaração da Arquitetura
ARCHITECTURE rtc OF timeMemory IS
	SIGNAL hora, min : natural := 0;          -- Sinais para armazenar as horas e minutos
	SIGNAL internalClockHour : std_logic := '1';    -- Sinal de clock interno para as horas
BEGIN
	
	PROCESS(clock,clkHour,clkMin,rstHour,rstMin)
		VARIABLE clkHourCtrl, hourTick : std_logic := '0';    -- Variáveis de controle para o clock das horas
	BEGIN
		
		IF(falling_edge(clkHour)) THEN
			clkHourCtrl := '1';    -- Ativa o sinal de controle do clock das horas
		END IF;
		
		IF(falling_edge(clkMin)) THEN
			min <= min + 1;    -- Incrementa o valor dos minutos a cada borda de descida do sinal de clock dos minutos
		END IF;
		
		IF(rising_edge(clock)) THEN
			internalClockHour <= '1';    -- Ativa o sinal de clock interno para as horas a cada borda de subida do sinal de clock geral
		END IF;		
		
		IF(rstMin = '0') THEN
			min <= 0;    -- Reseta o valor dos minutos quando o sinal de reset dos minutos está ativo
		END IF;
		
		IF(min = 60) THEN
			min <= 0;    -- Reinicia os minutos quando atingem 60
			hourTick := '1'; 
		END IF;
		
		IF(clkHourCtrl = '1' OR hourTick = '1') THEN
			clkHourCtrl := '0';    -- Desativa o sinal de controle do clock das horas e o sinal de incremento das horas
			hourTick := '0';
			internalClockHour <= '0';    -- Desativa o sinal de clock interno para as horas
		END IF;
		
		IF(falling_edge(internalClockHour)) THEN
			hora <= hora + 1;    -- Incrementa o valor das horas a cada borda de descida do sinal de clock interno das horas
		END IF;
		
		IF(rstHour = '0' OR hora = 24) THEN
			hora <= 0;    -- Reseta o valor das horas quando o sinal de reset das horas está ativo ou quando atingem 24
		END IF;
		
	END PROCESS;
	
	hourOut <= hora;    -- Atribui o valor das horas para o sinal de saída
	minOut <= min;    -- Atribui o valor dos minutos para o sinal de saída
	
END rtc;
