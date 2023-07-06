-- Bibliotecas
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

-- Descrição da Entidade
ENTITY relogioVHDL IS
PORT(
	enter, prox, clock,reset	: IN  std_logic;
	editaParametro : IN std_logic;
	habilitaAlarme : IN std_logic;
	ledsModulos : OUT std_logic_vector(0 to 2);
	ledAlarme : OUT std_logic;
	disp0,disp1,disp2,disp3,disp4,disp5	: OUT std_logic_vector(0 to 7)
);
END relogioVHDL;

-- Descrição da Arquitetura
ARCHITECTURE rtc OF relogioVHDL IS
	-- Declaração de Tipos de Estados
	TYPE StateType IS (MostraHora,MostraAlarme,MostraCronometro);
	
	-- Declaração de variáveis	
	SIGNAL editaTempo, editaAlarme : std_logic := '0';
	SIGNAL parametro_a_editar : std_logic := '0';
	
	SIGNAL estado : StateType := MostraHora;
	
	SIGNAL horaAtual, minAtual : natural;
	SIGNAL horaAlarme, minAlarme : natural;
	SIGNAL segCrono, minCrono, horaCrono : natural;
	
	SIGNAL alarmeAcionado : std_logic;
	
	SIGNAL controlTempo, controlAlarme, controlCronometro : std_logic := '1';
	
	-- Declaração dos componentes
	COMPONENT moduloTempo IS
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
	END COMPONENT;
	
	COMPONENT moduloCronometro IS
	PORT(
		clock : IN std_logic;
		reset : IN std_logic;
		control : IN std_logic;
		moduloAtivo : OUT std_logic;
		segOut,minOut, hourOut : OUT natural
	);
	END COMPONENT;
	
	COMPONENT moduloAlarme IS
	PORT(
		clock : IN std_logic;
		habilitaEdicao : IN std_logic;
		habilitaAlarme : IN std_logic;
		reset : IN std_logic;
		control : IN std_logic;
		parametro_a_editar : IN std_logic;
		horaAtual,minAtual : IN natural;
		hourOut,minOut : OUT natural;
		moduloAtivo : OUT std_logic;
		acionaAlarme : OUT std_logic
	);
	END COMPONENT;
	
	-- Declaração de Funções
	FUNCTION converteNumDisplay7(var: integer) RETURN std_logic_vector IS
		VARIABLE result : std_logic_vector(0 to 7);
	BEGIN 
		CASE var IS
			WHEN 0 =>
				result := "00000011";
			WHEN 1 =>
				result := "10011111";
			WHEN 2 =>
				result := "00100101";
			WHEN 3 =>
				result := "00001101";
			WHEN 4 =>
				result := "10011001";
			WHEN 5 =>
				result := "01001001";
			WHEN 6 =>
				result := "01000001";
			WHEN 7 =>
				result := "00011111";
			WHEN 8 =>
				result := "00000001";
			WHEN 9 =>
				result := "00011001";
			WHEN -99 => -- Definição do display apagado
				result := "11111111";
			WHEN OTHERS =>
				result := "01100001";
		END CASE;
		RETURN result;
	END FUNCTION;
	
	FUNCTION converteCharDisplay7(var: character) RETURN std_logic_vector IS
		VARIABLE result : std_logic_vector(0 to 7);
	BEGIN 
		CASE var IS
			WHEN 'A' =>
				result := "00010001";
			WHEN 'o' =>
				result := "11000101";
			WHEN 'C' =>
				result := "01100011";
			WHEN 'H' =>
				result := "10010001";
			WHEN OTHERS =>
				result := "01100001";
		END CASE;
		RETURN result;
	END FUNCTION;
	
BEGIN
	
	tempModule : moduloTempo port map(clock,editaTempo,reset,parametro_a_editar,controlTempo,ledsModulos(0),minAtual,horaAtual);
	alarmModule : moduloAlarme port map(clock,editaAlarme,habilitaAlarme,reset,controlAlarme,parametro_a_editar,horaAtual,minAtual,horaAlarme,minAlarme,ledsModulos(1),alarmeAcionado);
	cronoModule : moduloCronometro port map(clock,reset,controlCronometro,ledsModulos(2), segCrono, minCrono, horaCrono);
	
	PROCESS(clock,enter, prox)
		VARIABLE auxDisp2, auxDisp3, auxDisp4, auxDisp5 : natural := 0;
	BEGIN
	
		IF(rising_edge(prox)) THEN -- Quando se aperta o botão de proximo
			IF(editaParametro = '0') THEN -- Quando nenhum parametro está sendo editado
				CASE estado IS
					WHEN MostraHora =>
						estado <= MostraCronometro;
					WHEN MostraCronometro =>
						estado <= MostraAlarme;
					WHEN MostraAlarme =>
						estado <= MostraHora;
					WHEN OTHERS =>
						estado <= MostraHora;
				END CASE;
			ELSE -- Caso deseje-se editar um parâmetro
				-- Troca-se o parametro que está sendo modificado
				IF(parametro_a_editar = '0') THEN
					parametro_a_editar <= '1';
				ELSE
					parametro_a_editar <= '0';
				END IF; -- parametro_a_editar
				
			END IF; -- editaParametro = '0'
			
		END IF; -- rising_edge(prox)
		
		CASE estado IS
			
			WHEN MostraHora =>
				editaTempo <= editaParametro;
				editaAlarme <= '0';
				controlTempo <= enter;
				controlAlarme <= '1';
				controlCronometro <= '1';
				
				disp0 <= converteCharDisplay7('H');
				disp1 <= converteNumDisplay7(-99);
				
				auxDisp2 := horaAtual/10;
				auxDisp3 := horaAtual-(10*auxDisp2);
				auxDisp4 := minAtual/10;
				auxDisp5 := minAtual-(10*auxDisp4);
				
				
				
			WHEN MostraCronometro =>
				editaTempo <= '0';
				editaAlarme <= '0';
				controlTempo <= '1';
				controlAlarme <= '1';
				controlCronometro <= enter;
				
				disp0 <= converteCharDisplay7('C');
				disp1 <= converteNumDisplay7(-99);
				IF(horaCrono > 0) THEN 
					auxDisp2 := (horaCrono/10);
					auxDisp3 := horaCrono-(10*auxDisp2);
					auxDisp4 := (minCrono/10);
					auxDisp5 := minCrono-(10*auxDisp4);
				ELSE
					auxDisp2 := (minCrono/10);
					auxDisp3 := minCrono-(10*auxDisp2);
					auxDisp4 := (segCrono/10);
					auxDisp5 := segCrono-(10*auxDisp4);
				END IF;
				
			WHEN MostraAlarme =>
				editaTempo <= '0';
				editaAlarme <= editaParametro;
				controlTempo <= '1';
				controlAlarme <= enter;
				controlCronometro <= '1';
				
				disp0 <= converteCharDisplay7('A');
				IF(habilitaAlarme = '1') THEN
					disp1 <= converteCharDisplay7('o');
				ELSE
					disp1 <= converteNumDisplay7(-99);
				END IF;
				
				auxDisp2 := horaAlarme/10;
				auxDisp3 := horaAlarme - (10*auxDisp2);
				
				auxDisp4 := minAlarme/10;
				auxDisp5 := minAlarme-(auxDisp4*10);
				
		END CASE;
		
		IF(auxDisp3 < 0) THEN
			auxDisp3 := 0;
		END IF;
		IF(auxDisp5 < 0) THEN
			auxDisp5 := 0;
		END IF;
		
		disp2 <= converteNumDisplay7(auxDisp2);
		disp3 <= converteNumDisplay7(auxDisp3);
		disp4 <= converteNumDisplay7(auxDisp4);
		disp5 <= converteNumDisplay7(auxDisp5);
		
	END PROCESS;
	
	ledAlarme <= alarmeAcionado;
	
END rtc;
