# RelogioVHDL
###### Projeto final desenvolvido para a disciplina de Lógica Reconfigurável. Trata-se de uma descrição em VHDL que descreve o comportamento de um relógio comum.

Como proposta para o projeto final da disciplina de Lógica Reconfigurável, propôs-se e desenvolveu-se a descrição em VHDL de um relógio digital simples. Tal projeto foi pensado, de modo a aplicar os conceitos vistos na disciplina. Tais como máquinas de estados, funções e a lógica da linguagem de descrição de hardware, entre outros. Para tanto, o mesmo foi projetado e testado com a plataforma Quartus Prime 22.1std, estando presente neste repositório os arquivos do projeto desenvolvidos na plataforma.

O projeto resultante demonstrou o comportamento esperado, sendo aplicado para a FPGA DE10-LITE da Altera, mais especificamente o modelo MAX 10 - 10M50DAF484C7G. Apresentando uma lógica modular, apresenta o corpo principal "Relógio" que controla a lógica geral das entradas e saídas, bem como o estado atual que determina o módulo que esta sendo vizualizado no momento.

O módulo padrão é o módulo Temporal, onde mantém-se o controle do horário marcado pelo relógio. Sendo mantido com o auxílio do clock de 50 MHz interno da placa. Além de contar com um módulo adicional para auxiliar a armazenar o horário. Tal módulo de memória temporal foi implementado para tornar possível a modificação das horas e dos minutos, de modo a adequar a lógica para evitar os loops lógicos que estavam ocorrendo antes da modularização.

O segundo módulo desenvolvido foi o de Alarme. O qual fornece uma central de controle para um único alarme, o qual pode ser ativado ou desativado através de um switch. Manténdo e podendo alterar a hora e o minuto do alarme, o mesmo aciona um LED que ira piscar durante um intervalo de 5 minutos contando com o horário definido para o alarme. Caso o mesmo seja ou esteja desativado, o LED não piscará. Além disso, caso o alarme esteja ativo, no segundo display de 7 segmentos estará apresentando um quadrado, indicando que o mesmo está ativo.

Por fim, o último módulo trata de um Cronômetro simples, que ao ser acionado irá começar a marcar o tempo, também com o auxílio do clock interno. Serão mostrados inicialmente os minutos e segundos, conforme o tempo passa. Mas caso atinja-se o marco de uma hora, o display passará a mostrar somente as horas e os minutos, devido a limitação de displays da placa.

Vale resaltar que o estado atual do relógio é indicado pelo primeiro display de 7 segmentos da placa, o qual apresentará uma letra indicando o módulo em exibição:
* H - Módulo temporal;
* A - Módulo de alarme;
* C - Módulo de cronômetro.
