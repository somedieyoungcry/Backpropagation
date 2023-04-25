clear all; clc;
figure
disp('--------------------------------------------')
disp('        Redes Neuronales Supervisadas       ')
disp('--------------------------------------------')
disp('          Fuentes Saldaña Juan              ')
disp('--------------------------------------------')
disp('         Neurona tipo Backpropagation       ')
disp('--------------------------------------------')
%Patrones de entrada
[num,txt,raw] = xlsread('Base_Datos_FallasElectricas.xlsx', 'Hoja1');
p = [num(:,:)];
%Patrones de salida
[num1,txt1,raw1] = xlsread('Base_Datos_sinFallasElectricas.xlsx', 'Base_Datos_sinFallasElectricas');
t=[num1(:,:)];

fAlfa = 0.1;
ws = [0.1 0.3];     
bs = 0.8; 
%Neurona 1
wn1 = [-0.2 0.5];
bn1 = [0.7 -0.2];

%Neurona 2
wn2 = [-0.2 0.5];
bn2 = [0.7 -0.2];

%Nota: Los valores de graficacion los estoy cerrando a 100 (Cuando 
%normalmente en el for se tiene "for i = 1 : 3001"), para que el
%programa no se tarde mucho en graficar todos los datos, esto lo hago para
%las graficas 1 y 2, pero en cuanto al codigo, este si valida todos los
%datos que se ingresan por medio del XLSX y termina de iterar como es que 
%se le pide.

%Grafica #1
for i = 1 : 100
    subplot(2,2,1);
    title('Patrones');
    hold on; 
        grid on; 
        scatter(p(i), t(i), "or"); 
		%Obtiene posicion donde se ubicara el grafico
        axis([-4 4 -4 4])
end
% subplot(2,2,1);
% title('Patrones');
% hold on;
%     grid on;
%     plot(p(1), t(1), 'or');
%     plot(p(2), t(2), 'or');
%     plot(p(3), t(3), 'or');
%     plot(p(4), t(4), 'ob');
%     plot(p(5), t(5), 'ob');
%     plot(p(6), t(6), 'ob');
%     axis([-4 4 -4 4])
E = 0;
aciertos = 0;
iteracion = 0;
EAnt = 0;
Paro = .01;
deltaE = 1;
disp('Ingrese la opcion deseada')
disp('1.-Tansig|Tansig / 2.-Logsig|Losgig / 3.-Tansig|Logsig ')
prompt ='1 2 3'
dato = input(prompt) 
while aciertos < size(p,2) 
    disp('------------------------Inicio del Algoritmo-----------------------------');
    iteracion = iteracion + 1
    for i = 1 : size(p,2)
        
        % Neurona 1
        a = wn1 * p (i) + bn1;
        aN1 = [(exp(a(1)) - exp(-a(1))) / (exp(a(1)) + exp(-a(1))) (exp(a(2)) - exp(-a(2))) / (exp(a(2)) + exp(-a(2)))]
        
        % Neurona 2
        a = (wn2 * p(i) + bn2);
        aN2 = [1/(1 + exp(-a(1))) 1/(1+exp(-a(2)))]
        
        % Neurona de salida
        as = (ws * (aN1' + aN2') + bs);
        
        % Error
        e = t(i) - as
        E(end + 1) = e
        
        % Pureline
        fs = 1;
        
        switch(dato) 
            case 1
            %tansig
                fn1 = [(1 - aN1(1)^2)  (1 - aN1(2)^2)]
            %tansig
                fn2 = [(1 - aN2(1)^2)  (1 - aN2(2)^2)]
            
            case 2
                %logsig
                fn1 = [(aN1(1) * (1 - aN1(1)))  (aN1(2) * ( 1 - aN1(2)))]
                %logsig
                fn2 = [(aN2(1) * (1 - aN2(1)))  (aN2(2) * ( 1 - aN2(2)))]

            case 3
                %tansig
                fn1 = [(1 - aN1(1)^2)  (1 - aN1(2)^2)]
                %logsig
                fn2 = [(aN2(1) * (1 - aN2(1)))  (aN2(2) * ( 1 - aN2(2)))]

        end
        %Sensitividad
        ss = -2 * fs * e
        sN1 = [fn1(1) * ws(1) * ss  fn1(2) * ws(2) * ss]
        sN2 = [fn2(1) * ws(1) * ss  fn2(2) * ws(2) * ss]
        
        %Ajustes
        ws = ws - fAlfa * (ss * aN1 + ss * aN2)
        bs = bs - fAlfa * ss
                
        wn1 = wn1 - fAlfa * sN1 * p(i)
        bn1 = bn1 - fAlfa * sN1
        
        wn2 = wn2 - fAlfa * sN2 * p(i)
        bn2 = bn2 - fAlfa * sN2
        
    end   
    if iteracion == 1
        EAnt = E(end)  
    else
        deltaE= E(end) - EAnt;
        deltaE = abs(deltaE)
        EAnt = E(end);
    end
    
    aciertos = sum(deltaE == 0);
    if deltaE < Paro
        break,
    end
    
    %Grafica #2
    subplot(2,2,2);
    title('Errores de la funcion');
    plot(iteracion,deltaE, '*b')
    hold on
	%Obtiene posicion donde se ubicara el grafico
    axis([-0.3 (iteracion+1) -0.5 3])
    
end

x1 = -bs / ws(1)
    y1 = -bs / ws(2) 

%Revisar la nota para poder entener como es que funciona el for para esta grafica 
%Grafica #3
for j = 1: 100
subplot(2,2,3);
title('Separabilidad');
    scatter(p(j), t(j), 'ob');
    hold on;
    grid on; 
    x = linspace(-3,3,100); 
    y = sin(x * pi / 4);
    plot(x,y);
end
% subplot(2,2,3);
% title('Separabilidad');
%     
%     plot(p(1), t(1), 'or');
%     hold on;
%     grid on;
%     plot(p(2), t(2), 'or');
%     plot(p(3), t(3), 'or');
%     plot(p(4), t(4), 'ob');
%     plot(p(5), t(5), 'ob');
%     plot(p(6), t(6), 'ob');
%     plot([x1,0],[0,y1])
%     axis([-4 4 -4 4])
%         
%     x = linspace(-3,3,50); 
%     y = sin(x * pi / 4);
%     plot(x,y);