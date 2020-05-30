% C?digo modificado mayo 2017. Yesenia Gonzalez

%% M?todo de la monta?a
function [area,n]=monta(imagen)
%% Generaci?n de nodos. Se propone un rango de 0 a 1 con 
%% incrementos de 0.2
imagen=(double(im2bw(imagen)));
%imshow(imagen);
[a,b]=find(imagen>=1);
length([a,b]);
P=[b,a]';
[x,y]=size(imagen);
F(1,:)=0:10:x;
C(1,:)=0:10:y;
alpha=1.5;%1.5,6
beta=.01;%.05
delta=1;
suma=0;
for x=1:length(F)
    for y=1:length(C)
        for z=1:length(P)
            d=sqrt((P(1,z)-F(1,x))^2+(P(2,z)-C(1,y))^2);
            m=exp(-alpha*d);
            M(x,y)=suma+m;  
            suma=M(x,y);
        end
        suma=0;        
    end     
end

k=1;
mc=0;
while(delta<15)
    %delta
    %encontramos el maximo valor de la malla 
    %delta
    M=max(0,M);
    
    c(k)=max(max(M));
    %length(c)
    for x=1:length(F)
       for y=1:length(C)
            if M(x,y)==c(k)
                pf(k)=x;
                pc(k)=y;
            end
        end
    end
 
    for x=1:length(F)
        for y=1:length(C)
 
            for z=1:k
                dc=sqrt((F(1,pf(k))-F(1,x))^2+(C(1,pc(k))-C(1,y))^2);
                mc=mc+exp(-beta*dc);
            end
 
            M2(x,y)=M(x,y)-M(pf(k),pc(k))*mc;            
            mc=0;
            
        end
    end
    k=k+1;
    c2=max(max(M2));
    delta(k-1)=abs(c(k-1)/c2);
    M=M2;
end
% llamada a la function kmeansS, desarrollada por el autor
u=kmeansS(P,(pf-1)*10,(pc-1)*10);
 

P(2,:)=x-P(2,:);
for k=1:length(pf)
    px(k)=F(1,pf(k));
    py(k)=x-C(1,pc(k));
%se relaciona el ?rea con respecto a la total de la imagen
    area(k)=u(k)/(x*y);
%     area(k)=(1+exp(1.5*(.0326-area(k))))^-1;
% %     area(k)=(1+exp(1.5*(-(area(k)))))^-1;    %Propuesta de cambio por Yesenia
end
n=length(area);
% calculo de la inhibicion lateral local
% covariazanza
% % l=length(px);
% % ppx=sum(px)/l;
% % ppy=sum(py)/l;
% % xy=0;
% % for i=1:l
% %     xy=xy+(px(i)*py(i));
% % end
% % sigma=(xy/l)-ppx*ppy;
% %  
% % for x=1:length(px)
% %     for z=1:length(px)
% %         C(x,z)=exp(-sqrt((px(1,x)-px(1,z))^2+(py(1,x)-py(1,z))^2)^2/(sigma^2));
% %     end
% % end
% %  
% % % suma de todas las inhibiciones
% %  
% % for x=1:length(px)
% %     aux=0;
% %     for y=1:length(px)
% %         if x~=y
% %             aux=aux+C(x,y);
% %         end
% %     end
% %     I(x)=area(x)*1+aux;
% %     
% %     Rk(x)=.6*(1-I(x));
end
%end
