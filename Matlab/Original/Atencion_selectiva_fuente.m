%% Codigo modificado mayo 2017. Yesenia Gonzalez

%% Archivo Principal Atenci?n Selectiva
clc; clear all; close all;
tic
% longitud de onda, ayuda con la sensibilidad de los bordes, con
% longitudes peque?as, se obtienen mayores contornos finos incluso obtiene 
% texturas, por el contrario con longitudes grandes se marcan los mas gruesos
lambda=6;
% angulo respecto x & y, se cambia el angulo, debido a que la posicion de
% las formas en la imagen no siempre son las mismas, entonces se requiere
% un barrido en todos los posibles angulos de giro.
theta=0:pi/8:pi-pi/8;
% desfase: recorre el coseno 
psi=0;
% gamma controla el largo de los lobulos
gamma=.4:.2:1;
% ancho de banda
b=4;
% desviacion,referencia al ancho del lobulo
sigma=(1/pi)*sqrt((log(2)/2))*((2^b + 1) / (2^b - 1))*lambda;
% sigma=6;
l=12/2;
gt=0;
imagenSalida1=0;
imagenSalida2=0;
imagenSalida3=0;
imagenSalida4=0;
imagenO=double(imread('NegroyYo4.jpg'));
%h  % imagenO=double(imread('fig009.jpeg'));
imagenO=imresize(imagenO,[240,320]); %Alto y ancho
%preparacion de los datos
tic

imagen1=(imagenO-128)/127; %normalizacion de los datos

imagen(:,:,1)=(imagen1(:,:,1)-imagen1(:,:,2))/2;%% RG
imagen(:,:,2)=(imagen1(:,:,1)+imagen1(:,:,2)-2*imagen1(:,:,3))/4;%% BY
imagen(:,:,3)=(imagen1(:,:,1)+imagen1(:,:,2)+imagen1(:,:,3))/3;%% I

s=size(imagenO);
for i=1:s(1)
    for j=1:s(2)
        imagen(i,j,4)=(max(imagen1(i,j,:))-min(imagen1(i,j,:)))/2; %% S
    end
end

contador=1;
for i=1:length(theta)
    for f=1:length(gamma)
        for j=-l:l
            for k=-l:l
                x=j*cos(theta(i))+k*sin(theta(i));
                y=k*cos(theta(i))-j*sin(theta(i));
                g(j+l+1,k+l+1)=exp(-(x^2 + (gamma(f)^2)*(y^2))/(2*sigma^2))*cos((2*pi*x/lambda)+psi);
            end
        end
        
        imagenSalida(:,:,1,contador)=filter2(g,imagen(:,:,1));
        imagenSalida(:,:,2,contador)=filter2(g,imagen(:,:,2));
        imagenSalida(:,:,3,contador)=filter2(g,imagen(:,:,3));
        imagenSalida(:,:,4,contador)=filter2(g,imagen(:,:,4));
        contador=contador+1;
        
        
    end
end
%% prototipo de objeto %% Aqui nos quedamos del c?digo Python
s=size(imagenSalida);
FM=zeros(s);
area=[];
for k=1:s(4)
    alpha=.6;
    m1=alpha*max(max(imagenSalida(:,:,1,k)));
    m2=alpha*max(max(imagenSalida(:,:,2,k)));
    m3=alpha*max(max(imagenSalida(:,:,3,k)));
    m4=alpha*max(max(imagenSalida(:,:,4,k)));
    
    for i=1:s(1)
        for j=1:s(2)
            if imagenSalida(i,j,1,k)>m1
                FM(i,j,1,k)=1;
            end
            if imagenSalida(i,j,2,k)>m2
                FM(i,j,2,k)=1;
            end
            if imagenSalida(i,j,3,k)>m3
                FM(i,j,3,k)=1;
            end
            if imagenSalida(i,j,4,k)>m4
                FM(i,j,4,k)=1;
            end
        end
    end
    %% monta, es una funci?n dise?ada por el autor, la cual recibe un 
    %% mapa de caracter?stica
    %FM(:,:,1,k)
    [area,num]=monta(FM(:,:,1,k));
    area(1)=sum(area);
    area(1)=(1+exp(-1.5*(area(1))))^-1;    %YESENIA, se modific? ecuaci?n para generalizar
    FCM(:,:,1,k)=imagenSalida(:,:,1,k)/(area(1)*num);
   
    [area,num]=monta(FM(:,:,2,k));
    area(1)=sum(area);
    area(1)=(1+exp(-1.5*(area(1))))^-1;     %YESENIA, se modific? ecuaci?n para generalizar
    FCM(:,:,2,k)=imagenSalida(:,:,2,k)/(area(1)*num);
    
    [area,num]=monta(FM(:,:,3,k));
    area(1)=sum(area);
    area(1)=(1+exp(-1.5*(area(1))))^-1;     %YESENIA, se modific? ecuaci?n para generalizar
    FCM(:,:,3,k)=imagenSalida(:,:,3,k)/(area(1)*num);
       
    [area,num]=monta(FM(:,:,4,k));
    area(1)=sum(area);
%     area(1)=(1+exp(1.5*(.0326-area(1))))^-1;
    area(1)=(1+exp(-1.5*(area(1))))^-1;     %YESENIA, se modific? ecuaci?n para generalizar
    FCM(:,:,4,k)=imagenSalida(:,:,4,k)/(area(1)*num); 
 end
%% competencia completa
 
s=size(FCM);
SM=zeros(s(1),s(2));
for x=1:s(1)
    for y=1:s(2)
        SM(x,y)=(max(max(FCM(x,y,:,:)))-1)*-1;
    end 
end
tiempo=toc;
figure(1)
subplot 121
imshow(SM)
title('Saliency Map')
subplot 122
imshow(uint8(imagenO))
title('Original');
figure, imshow(SM)
