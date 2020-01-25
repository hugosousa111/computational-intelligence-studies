clear; %limpa as variaveis
clc; %limpa a tela

%rng(1); %para fixar a semente, apenas para teste
load twomoons.dat; 

classe_1 = twomoons(1:501,1:2); %divisao da base apenas para plotar
classe_2 = twomoons(502:1001,1:2);

scatter(classe_1(:,1),classe_1(:,2), 'g.');
hold on;
scatter(classe_2(:,1),classe_2(:,2), 'r.');
grid on;

X = twomoons(1:1001, 1:2)'; %parte para treinar
Y = zeros(1000,2) ; 

% criando um y correspondente de mesmo tamanho
for aux = 1:1:501 % classe 1 (vetor coluna 1 0) 
    Y(aux,1) = 1;
end 
for aux = 502:1:1001 % classe -1 (vetor coluna 0 1)
    Y(aux,2) = 1;
end

D = Y';
X = [ones(1,1001);X];
acertou = 0;
p = 2; %mesmo numero de caracteristicas
q = 4;

%Fase 1: Inicializacao Aleatoria dos Pesos dos Neuronios Ocultos
W=normrnd(0,0.1,[q, p+1]); %distribuição normal entre 0 e 0.1 dos pesos //%%%%%%%%%

%Fase 2: Acumulo das Saidas dos Neuronios Ocultos
u = W*X;
Z = 1./(1+exp(-u)); %logistica 

Z = [ones(1,1001);Z];

%Fase 3: Calculo dos Pesos dos Neuronios de Saida
M = D*Z'*(Z*Z')^(-1); %minimos quadrados
    
%Teste e Capacidade de Generalizacao da Rede ELM

%crio uma base de teste que sao varios pontos
[x,y] = meshgrid(-1:0.1:9,-1:0.1:9); %x1 e x2 sao matrizes de valores que vao compor o plano

for a = 1:1:101
	for b = 1:1:101
        X_matriz = [1; x(a,b); y(a,b)];
        
        z = 1./(1+exp(-W*X_matriz)); 
             
        z = [1;z];
    
        classe = M*z; % valor estimado
             
        if classe(1)>classe(2) % faco uma malha com as regioes que seriam cada classe
            classes(a,b) = 1;
        else 
            classes(a,b) = -1;
        end            
	end
end

contour(x,y,classes,1)  %plota um contorno de acordo com a mudanca das classes na malha classes

