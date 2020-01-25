clear %para limpar as variaveis
clc %limpar tela

load aerogerador.dat; %pegar o arquivo 

x = aerogerador(:,1); %divide em x 
y = aerogerador(:,2); %divide em y

hold on;
plot(x,y,'b*'); %plota os dados da base
grid on;

%polinomio de grau 2
X = [ones(1,length(x))' x x.^2]; %ones(1,length(x))' preenche uma coluna de 1's
vetor_beta = inv(X'*X)*X'*y; %calculo de beta
y_chapeu = X*vetor_beta; %estimativa dos valores
plot(x,y_chapeu,'g-','linewidth',2); %plotando a reta

R2 = 1 - sum((y-y_chapeu).^2)/sum((y-mean(y)).^2);  %calculo do R2
k = 2; %grau do polinomio 
p = k + 1; %p e necessario no calculo do r2 ajustado
[l,c] = size(y_chapeu); %pega o numero de linhas e colunas
n = l; %para o calculo do R2AJ eh necessario o numero de equacoes***************************888
R2AJ = 1 - ((sum((y-y_chapeu).^2))/(n-p))/((sum((y-mean(y)).^2))/(n-1)); %calculo do r2 ajustado

fprintf('Polinomio de Grau 2\n')
fprintf('R2 = %f\n', R2);
fprintf('R2AJ = %f\n', R2AJ);

%polinomio 3
X = [ones(1,length(x))' x x.^2 x.^3]; %para aumentar o grau, aumenta o tamanho de X, com mais uma coluna
vetor_beta = inv(X'*X)*X'*y;
y_chapeu = X*vetor_beta;
plot(x,y_chapeu,'y-','linewidth',2);

R2 = 1 - sum((y-y_chapeu).^2)/sum((y-mean(y)).^2); 
k = 3;
p = k + 1;
[l,c] = size(y_chapeu);
n = l;
R2AJ = 1 - ((sum((y-y_chapeu).^2))/(n-p))/((sum((y-mean(y)).^2))/(n-1));

fprintf('Polinomio de Grau 3\n')
fprintf('R2 = %f\n', R2);
fprintf('R2AJ = %f\n', R2AJ);

%polinomio 4
X = [ones(1,length(x))' x x.^2 x.^3 x.^4];
vetor_beta = inv(X'*X)*X'*y;
y_chapeu = X*vetor_beta;
plot(x,y_chapeu,'k-','linewidth',3);

R2 = 1 - sum((y-y_chapeu).^2)/sum((y-mean(y)).^2); 
k = 4;
p = k + 1;
[l,c] = size(y_chapeu);
n = l;
R2AJ = 1 - ((sum((y-y_chapeu).^2))/(n-p))/((sum((y-mean(y)).^2))/(n-1));

fprintf('Polinomio de Grau 4\n')
fprintf('R2 = %f\n', R2);
fprintf('R2AJ = %f\n', R2AJ);

%polinomio 5
X = [ones(1,length(x))' x x.^2 x.^3 x.^4 x.^5];
vetor_beta = inv(X'*X)*X'*y;
y_chapeu = X*vetor_beta;
plot(x,y_chapeu,'r-');

R2 = 1 - sum((y-y_chapeu).^2)/sum((y-mean(y)).^2); 
k = 5;
p = k + 1;
[l,c] = size(y_chapeu);
n = l;
R2AJ = 1 - ((sum((y-y_chapeu).^2))/(n-p))/((sum((y-mean(y)).^2))/(n-1));

fprintf('Polinomio de Grau 5\n')
fprintf('R2 = %f\n', R2);
fprintf('R2AJ = %f\n', R2AJ);
legend('Base de Dados', 'Grau 2', 'Grau 3', 'Grau 4', 'Grau 5','Location','northwest');
