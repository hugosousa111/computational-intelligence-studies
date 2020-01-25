clear % limpar tela
clc % limpar variaveis

%rng(1) 
% rng serve para deixar a semente fixa da funcao randperm 
% e poder comparar os resultados de com normalizacao e sem normalizacao

load database_pap.dat; % carregando a base de dados

% normalizacao media 0 e desvio padrao unitario
X_nao_normalizado = database_pap; 
X_media = mean(X_nao_normalizado); %media de cada caracteristica 
X_var = var(X_nao_normalizado); % variancia 
X_des_pad = sqrt(X_var); % desvio padrao 
X_normalizado = zeros(917,8); % criacao da matriz que vai ter media 0 e desvio padrao unitario

for aux = 1:1:917
    for col = 1:1:8
        X_normalizado(aux,col) = (X_nao_normalizado(aux,col) - X_media(col))/(X_des_pad(col));
        % formula para normalizar para os paramentos de media 0 e desvio padrao unitario
    end
end

X_base_nao_permutado = X_normalizado';
% colocando a base ja normalizada dentro de X_base_nao_permutado, e deixa tranposta

Y_base_nao_permutado = zeros(2,917);
% criando um y correspondente de mesmo tamanho
for aux = 1:1:242 % classe 0 (vetor coluna 1 0) 
    Y_base_nao_permutado(1,aux) = 1;
end 
for aux = 243:1:917 % classe 1 (vetor coluna 0 1)
    Y_base_nao_permutado(2,aux) = 1;
end

media_das_taxas_de_acerto = 0; % variavel vai guardar a taxa media de acertos
media_das_taxas_de_erro = 0; % variavel vai guardar a taxa media de erros

% serao realizadas 10 rodadas
for rodada = 1:1:10
    % permutacao da base
    numero_rand = randperm(917)'; 
    
    % vetor coluna de numero randomicos de 1 - 917 (distribuicao uniforme de numeros aleatorios)
    
    X_base = X_base_nao_permutado(:,numero_rand); 
    Y_base = Y_base_nao_permutado(:,numero_rand);
    % são multiplicados pelo mesmo vetor de numeros randomicos, entao nao a 
    % confusao na equivalencia das colunas dos vetores X_base e Y_base,
    % se por exemplo a primeira coluna do vetor X_base_nao_permutado 
    % for para a coluna 600 do vetor X_base, primeira coluna do vetor 
    % Y_base_nao_permutado vai para a coluna 600 do vetor Y_base, 
    % pois elas sao correpondentes

    %metodo Hold-out
    % 70% de 917 eh 641.9 arredondei pra 642
    X_treino = X_base(1:8,1:642); 
    Y_treino = Y_base(1:2,1:642); 
    % 30% de 917 eh 245.1 arredondei pra 245
    X_teste = X_base(1:8,643:917); 
    Y_teste = zeros(2,275);
    Y_teste_correto = Y_base(1:2,643:917); % valores de Y corretos
    
    for aux = 1:1:275 
    % percorrer todos os valores de teste, para poder calcular as distancia para todos os elementos da base
        Distancias = (sqrt( (X_treino(1,1)-X_teste(1,aux))^2 + (X_treino(2,1)-X_teste(2,aux))^2 + (X_treino(3,1)-X_teste(3,aux))^2 + (X_treino(4,1)-X_teste(4,aux))^2 + (X_treino(5,1)-X_teste(5,aux))^2 + (X_treino(6,1)-X_teste(6,aux))^2 + (X_treino(7,1)-X_teste(7,aux))^2 + (X_treino(8,1)-X_teste(8,aux))^2   )  ); % primeiro caso
        % vetor coluna que guarda as distancias 
        for b = 2:1:642 % percorre todos os elementos da base
            Distancias = [Distancias ;(sqrt( (X_treino(1,b)-X_teste(1,aux))^2 + (X_treino(2,b)-X_teste(2,aux))^2 + (X_treino(3,b)-X_teste(3,aux))^2 + (X_treino(4,b)-X_teste(4,aux))^2 + (X_treino(5,b)-X_teste(5,aux))^2 + (X_treino(6,b)-X_teste(6,aux))^2 + (X_treino(7,b)-X_teste(7,aux))^2 + (X_treino(8,b)-X_teste(8,aux))^2   )  )];
        end 
        [M,indice_menor_distancia] = min(Distancias); 
        % como k=1, o que tiver menor distancia define a classe do X testado
        Y_teste(:,aux) = Y_treino(:,indice_menor_distancia);
    end
    
    acertos = 0; 
    erros = 0;
    
    %variaveis auxiliareis nas taxas de acerto e erro
    for aux = 1:1:275 %verificar se Y calculados sao os corretos
        if(Y_teste(:,aux) == Y_teste_correto(:,aux))
            acertos = acertos + 1;
        else
            erros = erros + 1;
        end
    end
    media_das_taxas_de_acerto = media_das_taxas_de_acerto + (acertos/275);
    media_das_taxas_de_erro = media_das_taxas_de_erro + (erros/275);
    
end

media_das_taxas_de_acerto = media_das_taxas_de_acerto/10
media_das_taxas_de_erro = media_das_taxas_de_erro/10
