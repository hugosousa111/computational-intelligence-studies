clear; %limpa as variaveis
clc; %limpa a tela

rng(1); %para fixar a semente, apenas para teste

load iris_log.dat; %carregando a base
base = iris_log;

min_acerto = 50; %valor apenas para iniciar a variavel
max_acerto = -50;%valor apenas para iniciar a variavel
md_acertos = 0;
md_erros = 0;

for aux = 1:1:50
    acertos = 0;
    erros = 0;
    
    % permutacao da base
    numero_rand = randperm(150)'; 
    base = base(numero_rand,:); %permuta as linhas

    %divisao da base
    %80% de 150 = 120    
    x_base_treino = base(1:120,1:4)'; 
    y_base_treino = base(1:120,5:7)'; 
    %20% de 150 = 30
    x_base_teste = base(121:150,1:4)'; 
    y_base_teste_correto = base(121:150,5:7)'; 

    net = newrb(x_base_treino, y_base_treino,0.1); 
    %uso da funcao newrb que implementa uma rede neural de base radial
    % sendo o primeiro parametro a base de treino, 
    % o segundo parametro as classes da base e
    % o terceiro eh a meta de erro quadrático médio
    % e retorna a rede neural
    y_calculado = sim(net,x_base_teste); 
    % o sim vai simular os valores da base de teste na rede neural
    % e retornar suas classes estimadas
    
    y_teste_arredondado = [zeros(1,30);zeros(1,30);zeros(1,30)];
    for aux2 = 1:1:30 %arredondar os valores obtidos para facilitar na comparacao 
        if((y_calculado(1,aux2)>y_calculado(2,aux2)) && (y_calculado(1,aux2)>y_calculado(3,aux2)))
            y_teste_arredondado(:,aux2) = [1;0;0];
        elseif ((y_calculado(2,aux2)>y_calculado(1,aux2)) && (y_calculado(2,aux2)>y_calculado(3,aux2)))
            y_teste_arredondado(:,aux2) = [0;1;0];
        else
            y_teste_arredondado(:,aux2) = [0;0;1];
        end
    end
    
    for aux2 = 1:1:30 %comparar se o estimado eh igual ao correto das classes de teste
        if(y_teste_arredondado(:,aux2) == y_base_teste_correto(:,aux2))
            acertos = acertos + 1;            
        else
            erros = erros + 1;
        end
    end
    
    %ac(aux) = acertos/30 %igual ao taxa_media_acertos
    
    if(acertos>max_acerto)
       max_acerto = acertos; %guarda o max
    end
    if(acertos<min_acerto)
       min_acerto = acertos; %guarda o min
    end
    md_acertos = md_acertos + acertos; %vai acumulando os acertos
    md_erros = md_erros + erros;
end

md_acertos = md_acertos/50; % da a media dos acertos
taxa_media_acertos = md_acertos/30; % da a taxa media dos acertos

md_acertos
taxa_media_acertos

min_acerto
taxa_min_acerto = min_acerto/30

max_acerto
taxa_max_acerto = max_acerto/30

%mean(ac) %igual ao taxa_media_acertos