%% The first part uses Matlab's Computer Vision System Toolbox
% SURF regions are extracted and matched and a similarity transformation 
% (i.e. rotation, translation and scale) between the views is estimated
I1 = (imread('boat1.png'));
I2 = (imread('boat6.png'));

points1 = detectSURFFeatures(I1);
points2 = detectSURFFeatures(I2);

% The SURF descriptor vectors for the detected features are stored in f1, f2 
[f1, vpts1] = extractFeatures(I1, points1);
[f2, vpts2] = extractFeatures(I2, points2);

indexPairs = matchFeatures(f1, f2) ;
matchedPoints1 = vpts1(indexPairs(:, 1));
matchedPoints2 = vpts2(indexPairs(:, 2));

% The estimation of geometric transformations is covered later in lectures
% but it can be done as follows using Matlab built-in functionality:
[tform,inlierPoints2,inlierPoints1] = ...
    estimateGeometricTransform(matchedPoints2,matchedPoints1,'similarity','MaxDistance',10);
H1to2p=inv(tform.T');
D=visualizedifferenceimageH(I1,I2,H1to2p);
figure;imagesc(D);axis image;colormap('gray');
title('Difference image after geometric registration');

%% The candidate point matches are visualized as follows:
figure; ax = axes;
showMatchedFeatures(I1,I2,matchedPoints1,matchedPoints2,'montage','Parent',ax);
title(ax, 'Candidate point matches');
legend(ax, 'Matched points 1','Matched points 2');

%% The correct matches can be now visualised 
%  since the transformation is estimated successfully
figure; ax=axes;
showMatchedFeatures(I1,I2,inlierPoints1,inlierPoints2,'montage','Parent',ax);
title('Matched inlier points');


%% The previous part illustrated Matlab's built-in capabilities.
% Let's do the nearest neighbor matching for feature vectors in f1 and f2
% by using our own implementation.

% We compute the pairwise distances of feature vectors to matrix 'distmat'
distmat=zeros(size(f1,1),size(f2,1));
for i=1:size(f1,1)
    for j=1:size(f2,1)
        distmat(i,j)=norm(f1(i,:)-f2(j,:));
    end
end

% We determine the mutually nearest neighbors
[dist2,ids2]=min(distmat,[],2);
[dist1,ids1]=min(distmat,[],1);
pairs=[];
for k=1:length(ids2)
    if k==ids1(ids2(k))
        pairs=[pairs;k ids2(k) dist2(k)];
    end
end

% We sort the mutually nearest neighbors based on the distance 
nnd=pairs(:,3);
for k=1:size(pairs,1)
    sd=sort(distmat(pairs(k,1),:),2,'ascend');
end
[snnd,id_nnd]=sort(nnd,1,'ascend');

% We visualize the 5 best matches 
Nvis=5;

fig1=figure;
imshow([I1  I2]);hold on;
title('The top 5 mutual nearest neighbors of SURF features');
    
t=[0:1:360]/180*pi;
idlist=id_nnd;
for k=1:Nvis
    pid1=pairs(idlist(k),1);
    pid2=pairs(idlist(k),2);
    loc1=vpts1(pid1).Location;
    r1=6*vpts1(pid1).Scale;
    loc2=vpts2(pid2).Location;
    r2=6*vpts2(pid2).Scale;
    figure(fig1);
    plot(loc1(1)+r1*cos(t),loc1(2)+r1*sin(t),'m-','LineWidth',3);
    plot(loc2(1)+r2*cos(t)+size(I1,2),loc2(2)+r2*sin(t),'m-','LineWidth',3);
    plot([loc1(1);loc2(1)+size(I1,2)],[loc1(2); loc2(2)],'c-');
end

% How many of the top 5 matches appear to be correct correspondences?

%% TASK:
% Now, your task is to compute and visualize the top 5 matches based on 
% the nearest neighbor distance ratio defined in Equation (4.18) in the course book.
[dist2,ids2]=min(distmat,[],2);
[dist1,ids1]=min(distmat,[],1);
[dim1,dim2]=size(distmat);
distmat1=sort(distmat,2);
distmat2=sort(distmat,1);
pairs=[];

% We compute the pairwise distances of feature vectors to matrix 'distmat'
distmat=zeros(size(f1,1),size(f2,1));
for i=1:size(f1,1)
    for j=1:size(f2,1)
        distmat(i,j)=norm(f1(i,:)-f2(j,:));
    end
end

% We determine the mutually nearest neighbors
[dist2,ids2]=min(distmat,[],2);
[dist1,ids1]=min(distmat,[],1);
pairs=[];
for k=1:length(ids2)
    if k==ids1(ids2(k))
        pairs=[pairs;k ids2(k) dist2(k)];
    end
end
% We sort the mutually nearest neighbors based on the distance 
nndr=pairs(:,3);
for k=1:size(pairs,1)
    sd=sort(distmat(pairs(k,1),:),2,'ascend');
    nndr(k)=sd(1)/sd(2);
end
[snnd,id_nnd]=sort(nndr,1,'ascend');

% We visualize the 5 best matches 
Nvis=5;

fig1=figure;
imshow([I1  I2]);hold on;
title('The top 5 mutual nearest neighbors of SURF features');
    
t=[0:1:360]/180*pi;
idlist=id_nnd;
for k=1:Nvis
    pid1=pairs(idlist(k),1);
    pid2=pairs(idlist(k),2);
    loc1=vpts1(pid1).Location;
    r1=6*vpts1(pid1).Scale;
    loc2=vpts2(pid2).Location;
    r2=6*vpts2(pid2).Scale;
    figure(fig1);
    plot(loc1(1)+r1*cos(t),loc1(2)+r1*sin(t),'m-','LineWidth',3);
    plot(loc2(1)+r2*cos(t)+size(I1,2),loc2(2)+r2*sin(t),'m-','LineWidth',3);
    plot([loc1(1);loc2(1)+size(I1,2)],[loc1(2); loc2(2)],'c-');
end
% How many of those are correct correspondences?
% all of them!