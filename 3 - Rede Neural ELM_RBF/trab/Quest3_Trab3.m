clear; %limpa as variaveis
clc; %limpa a tela

rng(1); % apenas para teste % deixa fixo a semente das funcoes rand

notas_geracoes = []; % nota de todas as geracoes

matriz_individuos = randi(0:1,100,20);
%matriz onde estao os 100 individuos
%os individuos sao as linhas e as colunas os 20 bits de cada
% randi sao numeros inteiros pseudo-aleatorios distribuídos uniformemente

cont_geracoes = 1;
melhores = []; 
% vai guardar o melhor individuo de cada geracao
% coluna 1, sua nota, 
% coluna 2, seu valor de x 
% coluna 3, seu valor de y

for cont_geracoes = 1:1:50 % numero de geracoes
    individuos_x = matriz_individuos(:, 1:10); %separo a parte que eh x
    individuos_y = matriz_individuos(:, 11:20); %separo a parte que eh y
    
    individuos_x_decimal_correspondente = zeros(100,1);
    individuos_y_decimal_correspondente = zeros(100,1);
    %serao numeros entre 0 a 1023 que irao auxiliar no calculo de transformacao
    %de binario pra decimal do intervalo 0 a 20
    
    for aux=1:1:100 %transformacao do numero binario em decimal no intervalo de 0 a 1023
        individuos_x_decimal_correspondente(aux) = individuos_x(aux,1)*(2^9) + individuos_x(aux,2)*(2^8)+ individuos_x(aux,3)*(2^7)+ individuos_x(aux,4)*(2^6)+ individuos_x(aux,5)*(2^5)+ individuos_x(aux,6)*(2^4)+ individuos_x(aux,7)*(2^3)+ individuos_x(aux,8)*(2^2)+ individuos_x(aux,9)*(2^1)+ individuos_x(aux,10)*(2^0);
        individuos_y_decimal_correspondente(aux) = individuos_y(aux,1)*(2^9) + individuos_y(aux,2)*(2^8)+ individuos_y(aux,3)*(2^7)+ individuos_y(aux,4)*(2^6)+ individuos_y(aux,5)*(2^5)+ individuos_y(aux,6)*(2^4)+ individuos_y(aux,7)*(2^3)+ individuos_y(aux,8)*(2^2)+ individuos_y(aux,9)*(2^1)+ individuos_y(aux,10)*(2^0);
    end
    
    individuos_x_decimal_real = zeros(100,1);
    individuos_y_decimal_real = zeros(100,1);
    %numeros entre 0 a 20
    
    % transformacao usa a formula:
    % real = limite_inferior + correspondente_decimal*((limite_superior - limite_inferior)/((2^(numero_de_bits)) - 1))
    % nesse caso:
    % limite_inferior = 0
    % limite_seperior = 20
    % correspondente_decimal = numeros dentro dos vetores individuos_x_decimal_correspondente e individuos_y_decimal_correspondente
    % numero_de_bits = 10 bits
    
    for aux=1:1:100 %transformacao do numero decimal de 0 a 1023 em decimal no intervalo de 0 a 20
        individuos_x_decimal_real(aux) = 0 + individuos_x_decimal_correspondente(aux)* ((20 - 0)/((2^(10)) - 1));
        individuos_y_decimal_real(aux) = 0 + individuos_y_decimal_correspondente(aux)* ((20 - 0)/((2^(10)) - 1));
    end
    
    f_eq = @func_ag; % funcao q desejo maximizar, quanto maior seu valor, maior a nota do individuo
    notas = zeros(100,1); % vetor com as todas as notas dos individuos
    
    for aux=1:1:100
        individuo = [individuos_x_decimal_real(aux) individuos_y_decimal_real(aux)]; %pegando um individuo
        notas(aux) = f_eq(individuo); % calc da nota do individuo
    end
    
    notas_geracoes = [notas_geracoes; sum(notas)];% guarda o somatorio das notas de cada geracao
    
    % Agora sera a selecao dos pais
    pais_selecionados = zeros(100,20);% vai guardar os pais que foram selecionados para crossover
    
    for aux = 1:1:100 % cada 2 pais geram 2 filhos % looping selecionador de pais
        numero_sort = (notas_geracoes(cont_geracoes)-0).*rand(1,1) + 0 ; %gera um numero aleatorio entre 0 e maximo da nota
        
        somador = notas(1); %somador eh uma variavel auxiliar que guardas o somatorio das notas
        i = 1; % para no indice sorteado
        while somador < numero_sort % mesma logica do pseudocodigo do slide 20 de Algoritmos Geneticos - Capitulo 4
            i = i+1;
            somador = somador + notas(i);
        end
        
        pais_selecionados(aux,:) = matriz_individuos(i,:);
    end
    
    %Agora o Crossover
    
    % o crossover sera selecionar dois pais, na ordem do sorteio, e dividi-los
    % ao meio, metade do primeiro pai e metade do segundo pai sera o primeiro
    % filho e as outras metades serao o outro filho
    
    filhos = zeros(100, 20); % matriz onde fica os filhos criados
    
    for aux = 1:2:100 % vai fazer isso 50 vezes, pois seleciona de 2 em 2 pais
        filhos(aux, :) = [pais_selecionados(aux, 1:10), pais_selecionados(aux+1, 11:20)]; %filho 1
        filhos(aux+1, :) = [pais_selecionados(aux+1, 1:10), pais_selecionados(aux, 11:20)]; %filho 2
    end
    
    % Mutacao
    % sorteia um numero entre 1 e 1000, para cada bit de todos os individuos
    % se for entre 1 e 5 ocorre a mutacao
    for row = 1:1:100
        for col = 1:1:20
            num = (1000-1).*rand(1,1) + 0; % numero entre 1 e 1000
            if num <= 5
                filhos(row, col) = not(filhos(row, col)); % not inverte o valor da posicao
            end % se nao estiver entre 0 e 5 nao faz nada
        end
    end
    
    matriz_individuos = filhos; % os filhos substituem todos os pais
    
    [nota_melhor_ind, posicao_melhor_ind] = max(notas); % seleciona o melhor dessa geracao
    melhores = [melhores; nota_melhor_ind, individuos_x_decimal_real(posicao_melhor_ind), individuos_y_decimal_real(posicao_melhor_ind)];
    
end

% depois de todas essas geracoes eu seleciono o 
% individuo com melhor nota da ultima geracao,
% que eh a ultima posicao da matriz melhores

disp('Numero de geracoes: ')
disp(cont_geracoes)

disp('Melhor individuo: ')
disp('X: ')
disp(melhores(cont_geracoes,2))
disp('Y: ')
disp(melhores(cont_geracoes,3))
disp('Nota: ')
disp(melhores(cont_geracoes,1))
disp('Valor real da funcao nesse ponto: ')
disp(melhores(cont_geracoes,1) - 1) % subtraimos 1 pois tinhamos adicionado 1 no calculo da avaliacao do individuo

