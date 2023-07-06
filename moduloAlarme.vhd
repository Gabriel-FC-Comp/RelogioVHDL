-- Bibliotecas
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

-- Descrição da Entidade
ENTITY moduloAlarme IS
PORT(
	clock 					: IN std_logic;                  -- Entrada de clock
	habilitaEdicao 		: IN std_logic;                  -- Habilita a edição do alarme
	habilitaAlarme 		: IN std_logic;                  -- Habilita o alarme
	reset 					: IN std_logic;                  -- Sinal de reset
	control 					: IN std_logic;                  -- Sinal de controle
	parametro_a_editar 	: IN std_logic;                  -- Parâmetro a ser editado
	horaAtual,minAtual	: IN natural;                    -- Hora atual e minuto atual
	hourOut,minOut 		: OUT natural;                 	-- Hora e minuto do alarme de saída
	moduloAtivo 			: OUT std_logic;                 -- Sinal indicando que o módulo está ativo
	acionaAlarme 			: OUT std_logic                  -- Sinal que aciona o alarme
);
END moduloAlarme;

-- Descrição da Arquitetura
ARCHITECTURE rtc OF moduloAlarme IS
	-- Declaração de sinais
	SIGNAL horaAlarme, minutoAlarme 	: natural 	:= 0;     -- Sinais para a hora do alarme e minuto do alarme
	SIGNAL estaAcionado 					: std_logic := '0';   -- Sinal indicando se o alarme está acionado ou não
BEGIN
	
	moduloAtivo <= '1';    -- Define o sinal de atividade do módulo como '1'
	
	PROCESS(clock,control)
		VARIABLE ticks : natural := 0;   -- Variável para contar os ticks do clock
	BEGIN
		
		IF(falling_edge(control)) THEN   -- Detecta a borda de descida do sinal de controle
			
			IF(habilitaEdicao = '1') THEN   -- Caso deseje-se editar um parâmetro do alarme
				-- Se estivermos editando as horas
				IF(parametro_a_editar = '0') THEN
					IF(horaAlarme >= 23 OR reset = '1') THEN   -- Caso a hora seja maior ou igual à 24, reseta
						horaAlarme <= 0;
					ELSE
						horaAlarme <= horaAlarme + 1;
					END IF; -- horaAlarme
				ELSE
					IF(minutoAlarme >= 59 OR reset = '1') THEN
						minutoAlarme <= 0;
					ELSE
						minutoAlarme <= minutoAlarme + 1;
					END IF; -- minutoAlarme
							
				END IF; -- parametro_a_editar
					
			END IF; -- editaParametro
		
		END IF; -- falling_edge(control)
		
		IF(habilitaAlarme = '1' AND horaAtual = horaAlarme AND minAtual >= minutoAlarme AND minAtual < (minutoAlarme+5)) THEN
			IF(rising_edge(clock)) THEN
				IF(ticks = 16666666) THEN   -- Aguarda 16666666 ticks do clock (correspondente a cerca de 1 segundo)
					ticks := 0;
					estaAcionado <= NOT estaAcionado;   -- Alterna o estado do sinal de acionamento do alarme
				ELSE
					ticks := ticks + 1;
				END IF;
			END IF;
		ELSE
			estaAcionado <= '0';
		END IF; -- habilitaAlarme
	END PROCESS;
	
	hourOut <= horaAlarme;   -- Atribui a hora do alarme para o sinal de saída
	minOut <= minutoAlarme;   -- Atribui o minuto do alarme para o sinal de saída
	acionaAlarme <= estaAcionado;   -- Atribui o sinal de acionamento do alarme para o sinal de saída
	
END rtc;
