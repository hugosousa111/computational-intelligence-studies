clear;
clc;

D = [122 139 0.115; %base de dados, sendo as duas primeiras colunas,
 114 126 0.120;     %as variaveis regressoras
 086 090 0.105;     %e a ultima a variavel depedente
 134 144 0.090;
 146 163 0.100;  107 136 0.120;
 068 061 0.105;  117 062 0.080;
 071 041 0.100;  098 120 0.115]; 
                 
%plot3(D(:,1),D(:,2),D(:,3),'k*'); %plotando os dados da base

%x  = [ones(10,1),D(:,1),D(:,1).^2,D(:,1).^3,D(:,1).^4,D(:,2),D(:,2).^2,D(:,2).^3,D(:,2).^4]; 
x  = [ones(10,1),D(:,1),D(:,2)]; 
      %divisao da base, sendo uma matriz x
y = [D(:,3)]; %e y so a parte das variaveis depedentes

vetor_beta = inv(x'*x)*x'*y;
%lambda = 0.0; %escolhi uma lambda de valor minimo 
%vetor_beta = inv(x'*x+lambda*ones(9))*x'*y; %Regularizacao de thikonov
                            %no caso a matriz identidade é 9x9 pq ela precisa ser 
                            % (k+1)*(k+1), sendo k o numero de
                            % coeficientes de regressao, que no vetor X, k = 8

[x1,x2] = meshgrid(40:1:170,40:1:170); %x1 e x2 sao matrizes de valores que vao compor o plano

X_matriz = [1, x1(1,1), x2(1,1)];
%X_matriz = [1, x1(1,1), x1(1,1)^2, x1(1,1)^3, x1(1,1)^4, x2(1,1), x2(1,1)^2, x2(1,1)^3, x2(1,1)^4];
%a primeira linha da matriz X, composta por 1 e os primeiros numeros de x1 e x2

[l,c] = size(x1); %para pegar o numero de linhas de x1 (tambem poderia ser x2)

%eh necessario combinar todos os pontos de x1 e x2, 
%pois eles serao usados para estimar um y, formando um plano
%pra isso esse looping passa pelas posições das matrizes, 
%as combinando e adicionando como uma nova linha na matriz X
for a=1:1:l
      for b=2:1:l
          %X_matriz = [X_matriz;[1, x1(b,a), x1(b,a)^2, x1(b,a)^3, x1(b,a)^4, x2(b,a), x2(b,a)^2, x2(b,a)^3, x2(b,a)^4]];
          X_matriz = [X_matriz;[1, x1(b,a), x2(b,a)]];
      end
end

y_chapeu = X_matriz*vetor_beta; %calculo do y_chapeu 

%plot3(D(:,1),D(:,2),D(:,3),'k*',X_matriz(:,2),X_matriz(:,6),y_chapeu,'r*');
plot3(D(:,1),D(:,2),D(:,3),'k*',X_matriz(:,2),X_matriz(:,3),y_chapeu,'r*');
%plotando os dados, sendo os * pretos os reais tirados da base, 
% e os * vermelhos os estimados pelos calculos
grid on;

%para o calculo do R2, eh necessario os valores de y e y chapeu para os
% mesmos valores de x

y_c = x*vetor_beta; %estimativa apenas para os valores de x da base de dados

R2 = 1 - sum((y-y_c).^2)/sum((y-mean(y)).^2);  %calculo do R2
fprintf('R2 = %f\n', R2);
