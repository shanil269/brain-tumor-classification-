clear;
close all;
cla;
clc;
%----------importing dataset--------%
info = mha_read_header('VSD.Brain.XX.O.MR_T1c.686.mha');
 V = mha_read_volume(info);
 b= squeeze(V(:,:,90));

imshow(b,[]);figure;

num_iter = 1;
    delta_t = 1/7;
    kappa = 15;
    option = 2;
    disp('Preprocessing image please wait . . .');
    ad = anisodiff(b,num_iter,delta_t,kappa,option);%ad is the filtered image
    imshow(ad);figure;
%max_ad= max(b(:));
%min_ad= min(b(:));
[cA,cH,cV,cD] = dwt2(ad,'haar');
subplot(2,2,1);
imagesc(cV);
title('Vertical Detail Image');
colormap gray; 
subplot(2,2,2);
imagesc(cA);
title('Lowpass Approximation');
subplot(2,2,3);
imagesc(cH);
title('horizontal detail image');
subplot(2,2,4);
imagesc(cD);
title('Diagonal detail image');
max_ad= max(ad(:));
min_ad= min(ad(:));
ad1=im2bw(cA);

I2= Thresholding(cA,max_ad,min_ad);
figure,imshow(I2);

%find blob
sizeI=size(I2);
L = bwlabeln(I2);
stats = regionprops(L,'area');

LL= L+1;
cmap = hsv(length(stats));
cmap = [0 0 0;cmap];
LL = cmap(LL, :);
LL = reshape(LL, [sizeI,3]);
% select largest blob
mriAdjust=cA;
A = [stats.Area];


biggest = find(A==max(A));

    for i=1:size(biggest)
    mriAdjust(L ~= biggest(i)) = 0;
    ima = imadjust(mriAdjust);
    end
c1= bwconncomp(ad1, 8);
n1 = c1.NumObjects;
area1=zeros(n1, 1);
k1= regionprops(ad1,'Area');
for i=1:n1
    area1(i)= k1(i).Area;
end
A1=max(area1);
k2= regionprops(ima,'Area');
A2=k2(1).Area;
if(A2>(A1/2))
    mriAdjust(L== biggest) = 0;
    ima = imadjust(mriAdjust);
else
    d1=1;
end
 figure;
 imshow(ima);
 
 figure;
 colormap gray;
 imagesc(mriAdjust);
 
 
 

cc= bwconncomp(I2, 8);  %conected component in binary image basically a struct with n field


n = cc.NumObjects;

Area = zeros(n, 1);
Perimeter = zeros(n, 1);
MajorAxis = zeros(n, 1);
minorAxis = zeros(n,1);
%Centroid = zeros(n,2);
Eccentricity=zeros(n,1);
EquivDiameter=zeros(n,1);
EulerNumber=zeros(n,1);
Extent=zeros(n,1);
FilledArea=zeros(n,1);
Solidity=zeros(n,1);

k= regionprops(I2,'Area','Perimeter','MajorAxisLength','MinorAxisLength','Centroid','Eccentricity','EquivDiameter','EulerNumber','Extent','FilledArea','Solidity');
k3=regionprops(I2,mriAdjust,'MaxIntensity','MeanIntensity','MinIntensity','WeightedCentroid','PixelValues');
%for i=1:n
    %for j=1:2
        %Centroid(i,j)=k(i,j).Centroid;
    %end
%end
for i=1:n
    Area(i)= k(i).Area;
    Perimeter(i)= k(i).Perimeter;
    MajorAxisLength(i)=k(i).MajorAxisLength;
    MinorAxisLength(i)=k(i).MinorAxisLength;
    Eccentricity(i)=k(i).Eccentricity;
    EquivDiameter(i)=k(i).EquivDiameter;
    EulerNumber(i)=k(i).EulerNumber;
    Extent(i)=k(i).Extent;
    FilledArea(i)=k(i).FilledArea;
    Solidity(i)=k(i).Solidity;
end

%Marea= max(Area);


%graindata(1, 1)= (Area);
    











