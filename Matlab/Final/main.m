clc; clear all; close all;
lambda=6;
theta=0:pi/8:pi-pi/8;
psi=0;
gamma=.4:.2:1;
b=4;
sigma=(1/pi)*sqrt((log(2)/2))*((2^b + 1) / (2^b - 1))*lambda;
l=12/2;
gt=0;
imagen0=double(imread('NegroyYo4.jpg'));
imagen0=imresize(imagen0,[240,320]);
imagen1=(imagen0-128)/127;
imagen(:,:,1)=(imagen1(:,:,1)-imagen1(:,:,2))/2;
imagen(:,:,2)=(imagen1(:,:,1)+imagen1(:,:,2)-2*imagen1(:,:,3))/4;
imagen(:,:,3)=(imagen1(:,:,1)+imagen1(:,:,2)+imagen1(:,:,3))/3;
s=size(imagen0);
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
s=size(imagenSalida);
FM=zeros(s);
area=[];
for k=1:s(4)
    alpha= .6;
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
    [area,num]=monta(FM(:,:,1,k));
    area(1)=sum(area);
    area(1)=(1+exp(-1.5*(area(1))))^-1;
    FCM(:,:,1,k)=imagenSalida(:,:,1,k)/(area(1)*num);
    
    [area,num]=monta(FM(:,:,2,k));
    area(1)=sum(area);
    area(1)=(1+exp(-1.5*(area(1))))^-1;
    FCM(:,:,2,k)=imagenSalida(:,:,2,k)/(area(1)*num);
    
    [area,num]=monta(FM(:,:,3,k));
    area(1)=sum(area);
    area(1)=(1+exp(-1.5*(area(1))))^-1;
    FCM(:,:,3,k)=imagenSalida(:,:,3,k)/(area(1)*num);
    
    [area,num]=monta(FM(:,:,4,k));
    area(1)=sum(area);
    area(1)=(1+exp(-1.5*(area(1))))^-1;
    FCM(:,:,4,k)=imagenSalida(:,:,4,k)/(area(1)*num); 
end
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
imshow(uint8(imagen0))
title('Original');
figure, imshow(SM)%imshow(imagen);