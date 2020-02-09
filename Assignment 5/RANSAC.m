function [w,b]=RANSAC(x,y,N,t)
[~,n]=size(x);
inlier_index_max=[];
for i=1:N
R = randi(n,1,2);
x_sampled=[x(R(1)) x(R(2))];
y_sampled=[y(R(1)) y(R(2))];
p = polyfit(x_sampled,y_sampled,1);
distance=abs((1/sqrt(p(1)^2+1))*y+(1/sqrt(p(1)^2+1))*x*(-p(1))-p(2)*(1/sqrt(p(1)^2+1)));
inlier_index=find(distance<t);
if (length(inlier_index)+2>length(inlier_index_max))
    inlier_index_max=[inlier_index,R];
end
end
x_resampled=[];
y_resampled=[];
for i=1:length(inlier_index_max)
    x_resampled=[x_resampled x(inlier_index_max(i))];
    y_resampled=[y_resampled y(inlier_index_max(i))];
end
p = polyfit(x_resampled,y_resampled,1);
w=p(1);b=p(2);
end