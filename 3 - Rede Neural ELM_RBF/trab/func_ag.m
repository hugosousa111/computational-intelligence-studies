function y = func_ag(x) %funcao que eu desejo maximizar
    y = 1 + abs(  (x(1)*sin((x(2)*pi)/4))  + (x(2)*sin((x(1)*pi)/4))   ); 
    %somamos 1 pois a funcao original pode retornar 0, 
    %e todos os individuos devem ter oportunidade de participar da roleta
end