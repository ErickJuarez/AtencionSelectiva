function al=kmeansS(x,pf,pc)
    v=[pf;pc]';
    lx=size(x);
    lp=length(pf);
    d=zeros(lx(2),lp);
    ld=size(d);
    promedio=0;
    x=x';
    condicion=0;
    while(promedio<1)
        for i=1:ld(1)
            for j=1:ld(2)
                d(i,j)=sqrt((x(i,1)-v(j,1))^2+(x(i,2)-v(j,2))^2);
            end
        end
        u=zeros(ld(2),ld(1));
        for i=1:ld(1)
            m=find(d(i,:)==min(d(i,:)));
            u(m,i)=1;
        end
        if condicion>=1
            promedio=sum(eq(u,U))/ld(1);
            break;
        end
        promedio;
        condicion=condicion+1;
        U=u;
        size(U);
        v=U*x;
        lv=size(v);
        for i=1:lv(1)
            v(i,:)=v(i,:)/sum(U(i,:));
        end
    end
    al=[];
    for i=1:ld(2)
        al=[al,sum(U(i,:))];
    end
end