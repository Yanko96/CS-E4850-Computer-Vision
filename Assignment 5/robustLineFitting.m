load('points.mat','x','y');
figure;hold on;
plot(x,y,'kx');
axis equal
N=10000;t=3;
[w,b]=RANSAC(x,y,N,t);
plot([0 100],[b 100*w+b])