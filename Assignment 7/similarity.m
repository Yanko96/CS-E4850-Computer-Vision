%%
x=doc_fre.*q;
y=doc_fre.*d3;
[dim_x,dim_y]=size(x);
sim=0;
den_x=0;
den_y=0;
%%
for i=1:dim_y
    sim=sim+x(i)*y(i);
    den_x=x(i)^2+den_x;
    den_y=y(i)^2+den_y;
end
%%
result=sim/(sqrt(den_x)*sqrt(den_y))
