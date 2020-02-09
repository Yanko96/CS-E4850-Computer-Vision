function blobsN=scaleSpaceBlobs(img,N)

sigma0=0.5;
%k=2^(1/4);
k=1.19;

Nscales=16+2;
scalespace=zeros(size(img,1),size(img,2),Nscales);
sigmas=zeros(1,Nscales);

tmpxx=zeros(size(img));
tmpyy=zeros(size(img));

for i=1:Nscales
    %fprintf('%d/%d\n',i,Nscales);
    sigmas(i)=k^(i-1)*sigma0;
    
    [g,gx,gy,gxx,gyy,gxy]=gaussian2(sigmas(i)^2);
    scaleNormalizedLaplacian=sigmas(i)^2*(gxx+gyy);
    
    % filter the image with the scale-normalized Laplacian of Gaussian 
    % for each scale i and store the result to the variable scalespace(:,:,i)
    
    %%-your-code-starts-here-%%
        
    %tmpxx=conv2(scaleNormalizedLaplacian{i},img,'same');
        
        
    %%-your-code-ends-here-%%
    %tmpyy=conv2(scaleNormalizedLaplacian{i},img,'same');
    filterd_img=imfilter(img,scaleNormalizedLaplacian,'same','symmetric');
    filterd_img=filterd_img.^2;
    scalespace(:,:,i)=filterd_img;
        
    
    
        
        
    %%-your-code-ends-here-%%
        
end

% Selection of local maxima, each maxima defines a circular region. 
%
% In the end each row in 'blobs' encodes one circular region as follows:  
% [x y r filter_response]
% where x and y are the column and row coordinates of the circle center,
% r is the radius of the circle, r=sqrt(2)*sigma (see slide 77 of Lecture 3)
% last column indicates the response of the Laplacian of Gaussian filter

localmaxima=zeros(size(scalespace));
for i=1:Nscales
    maxi=colfilt(scalespace(:,:,i),[3 3],'sliding','max([x(1:4,:);x(6:9,:)])');
    localmaxima(:,:,i)=scalespace(:,:,i)>maxi;
end

scaleA=zeros(size(img,1),size(img,2));
scaleB=zeros(size(img,1),size(img,2));
scaleC=zeros(size(img,1),size(img,2));
blobs=[];
for i=2:(Nscales-1)
    scaleA=scalespace(:,:,i-1);
    scaleB=scalespace(:,:,i);
    scaleC=scalespace(:,:,i+1);
    [ri,ci]=find(localmaxima(:,:,i));
    idi=(ci-1)*size(img,1)+ri;
    [idmax]=find(scaleA(idi)<scaleB(idi) & scaleC(idi)<scaleB(idi));
    [rlmax,clmax]=ind2sub(size(img),idi(idmax));
    blobs=[blobs;clmax rlmax sqrt(2)*sigmas(i)*ones(length(rlmax),1) scaleB((clmax-1)*size(img,1)+rlmax)];
end


%NVIS=25;
[~,ids]=sort(blobs(:,4),'descend');
sblobs=blobs(ids,:);

blobsN=sblobs(1:min(N,size(sblobs,1)),:);
%visualization
%show_all_circles(img, sblobs(1:NVIS,1), sblobs(1:NVIS,2), 6*sqrt(2)*sblobs(1:NVIS,3), 'y', 3);
%keyboard
end
