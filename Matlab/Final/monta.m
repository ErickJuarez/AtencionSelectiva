function [area,n]=monta(imagen)
    imagen=(double(im2bw(imagen)));
    [a,b]=find(imagen>=1);
    length([a,b])
    P=[b,a]';
    [x,y]=size(imagen);
    F(1,:)=0:10:x;
    C(1,:)=0:10:y;
    alpha=1.5;
    beta=.01;
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
        M=max(0,M);
        c(k)=max(max(M));
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
    u=kmeansS(P,(pf-1)*10,(pc-1)*10);
    P(2,:)=x-P(2,:);
    for k=1:length(pf)
        px(k)=F(1,pf(k));
        py(k)=x-C(1,pc(k));
        area(k)=u(k)/(x*y);
    end
    n=length(area);
end