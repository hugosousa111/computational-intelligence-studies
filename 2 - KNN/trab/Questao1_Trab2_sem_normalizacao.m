clear %limpar tela
clc %limpar variaveis

load database_pap.dat; %carregando a base de dados
% normalizacao media 0 e desvio padrao unitario   %%%%%%%%%%%%%%%% nao estou melhorando

X_base = database_pap'; 
%colocando a base dentro de X_base, e deixando tranposta por causa da formula dos minimos quadrados
Y_base = zeros(2,917) ; 
%criando um y correspondente de mesmo tamanho
for t = 1:1:242 %classe 0 (vetor coluna 1 0) 
    Y_base(1,t) = 1;
end 
for t = 243:1:917 %classe 1 (vetor coluna 0 1) 
    Y_base(2,t) = 1;
end

acertos = 0; 
erros = 0;
%variaveis auxiliareis nas taxas de acerto e erro

% pro primeiro caso
X_treino = X_base(1:8,2:917); 
Y_treino = Y_base(1:2,2:917); 
%separo dados de treino e deixo um dado para teste (leave-one-out)

X_teste = X_base(1:8,1); %dado de teste
Y_correto = Y_base(1:2,1);
%Y_correto eh a "resposta certa" para a classificacao 

A = Y_treino * X_treino'*(X_treino*X_treino')^(-1); %metodo dos minimos quadrados

Y_teste = A*X_teste; %calculo do Y teste
matriz_Y_teste = Y_teste; %matriz que vai guardar todos os testes

%arredondamento para facilitar a comparacao
if(Y_teste(1,1)>Y_teste(2,1))
    Y_teste_arredondado = [1;0];
elseif (Y_teste(2,1)>Y_teste(1,1))
    Y_teste_arredondado = [0;1];
end
matriz_Y_teste_arredondado = Y_teste_arredondado; 
%matriz que vai guardar todos os testes ja arredondados

if(Y_teste_arredondado == Y_correto)
    acertos = acertos + 1;
else
    erros = erros + 1;
end

N = 917; %numero de amostras

for t = 2:1:N
    X_treino = X_base(1:8,[1:(t-1),(t+1):917]); 
    Y_treino = Y_base(1:2,[1:(t-1),(t+1):917]); 
    %separo mesmo dados de treino e deixo um dado para teste (leave-one-out)

    X_teste = X_base(1:8,t) ; %dado de teste
    Y_correto = Y_base(1:2,t) ; %dado de teste

    A = Y_treino * X_treino'*(X_treino*X_treino')^(-1); %metodo dos minimos quadrados

    Y_teste = A*X_teste; %calculo do Y teste
    matriz_Y_teste = [matriz_Y_teste Y_teste]; %matriz que vai guardar todos os testes
    
    if(Y_teste(1,1)>Y_teste(2,1))
        Y_teste_arredondado = [1;0];
    elseif (Y_teste(2,1)>Y_teste(1,1))
        Y_teste_arredondado = [0;1];
    end %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% precisa fazer o teste do igual
    matriz_Y_teste_arredondado = [matriz_Y_teste_arredondado Y_teste_arredondado]; 
    %matriz que vai guardar todos os testes ja arredondados
    
    if(Y_teste_arredondado == Y_correto)
        acertos = acertos + 1;
    else
        erros = erros + 1;
    end
end

taxa_de_erro = erros/N;
taxa_de_acerto = acertos/N;

disp('A taxa de acerto eh ');
disp(taxa_de_acerto);
disp('A taxa de erro eh ');
disp(taxa_de_erro);
