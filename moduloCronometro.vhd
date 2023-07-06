-- Bibliotecas
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

-- Descrição da Entidade
ENTITY moduloCronometro IS
	PORT(
		clock : IN std_logic;
		reset : IN std_logic;
		control : IN std_logic;
		moduloAtivo : OUT std_logic;
		segOut,minOut, hourOut : OUT natural
	);
END moduloCronometro;

-- Descrição da Arquitetura
ARCHITECTURE rtc OF moduloCronometro IS
	-- Declaração de sinais
	SIGNAL ticks,segundos,minutos,horas : natural := 0;
	SIGNAL habilitaContagem : std_logic := '0';

BEGIN

	moduloAtivo <= '1';

	PROCESS(clock,control,habilitaContagem)
		VARIABLE resetaTempos : std_logic := '0';
	BEGIN

		-- Verifica se ocorreu uma borda de descida no sinal de controle
		IF(falling_edge(control)) THEN

			-- Verifica se o sinal de reset está ativo para reiniciar o cronômetro
			IF(reset = '1') THEN
				resetaTempos := '1';
			ELSE
				-- Inverte o estado de habilitaContagem para iniciar ou parar o cronômetro
				IF(habilitaContagem = '0') THEN
					habilitaContagem <= '1';
				ELSE
					habilitaContagem <= '0';
				END IF; -- habilitaContagem
			END IF; -- Reset
		END IF; -- falling_edge(control)

		-- Verifica se a contagem está habilitada
		IF(habilitaContagem = '1') THEN

			-- Verifica se ocorreu uma borda de subida no sinal de clock
			IF(rising_edge(clock)) THEN

				-- Incrementa os ticks
				IF(ticks >= 49999999) THEN
					ticks <= 0;
					segundos <= segundos + 1;
				ELSE
					ticks <= ticks+1;
				END IF;

				-- Verifica se os segundos atingiram 60 para incrementar os minutos
				IF(segundos >= 60) THEN
					segundos <= 0;
					minutos <= minutos + 1;
				END IF;

				-- Verifica se os minutos atingiram 60 para incrementar as horas
				IF(minutos >= 60) THEN
					minutos <= 0;
					horas <= horas + 1;
				END IF;

			END IF;

		END IF; -- habilitaContagem

		-- Verifica se ocorreu uma reinicialização dos tempos
		IF(resetaTempos = '1') THEN
			ticks <= 0;
			segundos <= 0;
			minutos <= 0;
			horas <= 0;
		END IF;

		resetaTempos := '0';
	END PROCESS; -- control

	-- Atribui os valores dos tempos às saídas correspondentes
	segOut <= segundos;
	minOut <= minutos;
	hourOut <= horas;

END rtc;
