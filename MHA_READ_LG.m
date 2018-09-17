clear all;
close all;
clc;

filefolder = fullfile ('high grade');
files = dir (fullfile(filefolder , '*.mha'));
filename= {files.name};
filefolder1 = fullfile ('low grade');
files1 = dir (fullfile(filefolder1 , '*.mha'));
filename1= {files1.name};

filefolder2 = fullfile ('test high');
files2 = dir (fullfile(filefolder2 , '*.mha'));
filename2= {files2.name};


filefolder3 = fullfile ('test low');
files3 = dir (fullfile(filefolder3 , '*.mha'));
filename3= {files3.name};

numImages1 = length(filename2)+length(filename3);
test21 = zeros(numImages1,3);
test1 = zeros(numImages1,3);
test1_class  = zeros(numImages1,1);
test1_sample = [filename2 filename3];


numImages = length(filename)+length(filename1);
test = zeros(numImages,3);
test_class  = zeros(numImages,1);
test_sample = [filename filename1];
variables={'area','perimeter','maximum_intensity'};

for i=length(filename):-1:1
    fname = fullfile(filefolder ,filename{i});
    info = mha_read_header(fname);
    V = mha_read_volume(info);
    
slice_no= input('enter slice no');
 b= squeeze(V(:,:,slice_no));
 figure;
 imshow(b,[]);
    num_iter = 1;
    delta_t = 1/7;
    kappa = 20;
    option = 2;
      
    ad = anisodiff(b,num_iter,delta_t,kappa,option);%ad is the filtered image

[cA,cH,cV,cD] = dwt2(ad,'haar');
max_ad=max(ad(:));
min_ad=min(ad(:));
ad1=im2bw(cA);

I2= Thresholding(cA,max_ad,min_ad);

%find blob
sizeI=size(I2);
L = bwlabeln(I2);
stats = regionprops(L,'area','centroid');

LL= L+1;
cmap = hsv(length(stats));
cmap = [0 0 0;cmap];
LL = cmap(LL, :);
LL = reshape(LL, [sizeI,3]);
% select largest blob
mriAdjust=cA;
A = [stats.Area];


biggest = find(A==max(A));

    for j=1:size(biggest)
    mriAdjust(L ~= biggest(j)) = 0;
    ima = imadjust(mriAdjust);
    end
c1= bwconncomp(ad1, 8);
n1 = c1.NumObjects;
area1=zeros(n1, 1);
k1= regionprops(ad1,'Area');
for y=1:n1
    area1(y)= k1(y).Area;
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

cc= bwconncomp(ima, 8);  %conected component in binary image basically a struct with 4 field
cc1= bwconncomp(mriAdjust, 8);
n = cc.NumObjects;
n1 = cc1.NumObjects;
Area = zeros(n, 1);
Perimeter = zeros(n, 1);
MajorAxis = zeros(n, 1);
minorAxis = zeros(n,1);
MaxIntensity = zeros(n,1);

k= regionprops(ima,'Area','Perimeter','MajorAxisLength','MinorAxisLength','Eccentricity');
k3=regionprops(ima,mriAdjust,'MaxIntensity','MeanIntensity','MinIntensity','WeightedCentroid','PixelValues');
for j=1:n
    Area(j)= k(j).Area;
    Perimeter(j)= k(j).Perimeter;
    MajorAxisLength(j)=k(j).MajorAxisLength;
    MinorAxisLength(j)=k(j).MinorAxisLength;
    Eccentricity(j)=k(j).Eccentricity;
    MaxIntensity(j)=k3(j).MaxIntensity;
end



test(i,1)=mean(Area);
test(i,2)=mean(Perimeter);
test(i,3)=mean(MaxIntensity);
test_class(i,1)=1;
%test_sample(i)=filename{i};
end


for i=length(filename1):-1:1
    fname = fullfile(filefolder1 ,filename1{i});
    info = mha_read_header(fname);
    V = mha_read_volume(info);
    
slice_no= input('enter slice no');
 b= squeeze(V(:,:,slice_no));
 figure;
 imshow(b,[]);
    num_iter = 1;
    delta_t = 1/7;
    kappa = 20;
    option = 2;
    
    ad = anisodiff(b,num_iter,delta_t,kappa,option);%ad is the filtered image

[cA,cH,cV,cD] = dwt2(ad,'haar');
max_ad=max(ad(:));
min_ad=min(ad(:));
ad1=im2bw(cA);

I2= Thresholding(cA,max_ad,min_ad);

%find blob
sizeI=size(I2);
L = bwlabeln(I2);
stats = regionprops(L,'area','centroid');

LL= L+1;
cmap = hsv(length(stats));
cmap = [0 0 0;cmap];
LL = cmap(LL, :);
LL = reshape(LL, [sizeI,3]);
% select largest blob
mriAdjust=cA;
A = [stats.Area];


biggest = find(A==max(A));

    for j=1:size(biggest)
    mriAdjust(L ~= biggest(j)) = 0;
    ima = imadjust(mriAdjust);
    end
c1= bwconncomp(ad1, 8);
n1 = c1.NumObjects;
area1=zeros(n1, 1);
k1= regionprops(ad1,'Area');
for y=1:n1
    area1(y)= k1(y).Area;
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

cc= bwconncomp(ima, 8);  %conected component in binary image basically a struct with 4 field

n = cc.NumObjects;

Area = zeros(n, 1);
Perimeter = zeros(n, 1);
MajorAxis = zeros(n, 1);
minorAxis = zeros(n,1);
MaxIntensity = zeros(n,1);

k= regionprops(ima,'Area','Perimeter','MajorAxisLength','MinorAxisLength','Eccentricity');
k3=regionprops(ima,mriAdjust,'MaxIntensity','MeanIntensity','MinIntensity','WeightedCentroid','PixelValues');
for j=1:n
    Area(j)= k(j).Area;
    Perimeter(j)= k(j).Perimeter;
    MajorAxisLength(j)=k(j).MajorAxisLength;
    MinorAxisLength(j)=k(j).MinorAxisLength;
    Eccentricity(j)=k(j).Eccentricity;
    MaxIntensity(j)=k3(j).MaxIntensity;
end

test(length(filename)+i,1)=mean(Area);
test(length(filename)+i,2)=mean(Perimeter);
test(length(filename)+i,3)=mean(MaxIntensity);
test_class(length(filename)+i,1)=2;
%test_sample(i)=filename{i};


end



for i=length(filename2):-1:1
    fname = fullfile(filefolder2 ,filename2{i});
    info = mha_read_header(fname);
    V = mha_read_volume(info);
    
slice_no= input('enter high slice no');
 b= squeeze(V(:,:,slice_no));
 figure;
 imshow(b,[]);
    num_iter = 1;
    delta_t = 1/7;
    kappa = 20;
    option = 2;
      
    ad = anisodiff(b,num_iter,delta_t,kappa,option);%ad is the filtered image

[cA,cH,cV,cD] = dwt2(ad,'haar');
max_ad=max(ad(:));
min_ad=min(ad(:));
ad1=im2bw(cA);

I2= Thresholding(cA,max_ad,min_ad);

%find blob
sizeI=size(I2);
L = bwlabeln(I2);
stats = regionprops(L,'area','centroid');

LL= L+1;
cmap = hsv(length(stats));
cmap = [0 0 0;cmap];
LL = cmap(LL, :);
LL = reshape(LL, [sizeI,3]);
% select largest blob
mriAdjust=cA;
A = [stats.Area];


biggest = find(A==max(A));

    for j=1:size(biggest)
    mriAdjust(L ~= biggest(j)) = 0;
    ima = imadjust(mriAdjust);
    end
c1= bwconncomp(ad1, 8);
n1 = c1.NumObjects;
area1=zeros(n1, 1);
k1= regionprops(ad1,'Area');
for y=1:n1
    area1(y)= k1(y).Area;
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

cc= bwconncomp(ima, 8);  %conected component in binary image basically a struct with 4 field
cc1= bwconncomp(mriAdjust, 8);
n = cc.NumObjects;
n1 = cc1.NumObjects;
Area = zeros(n, 1);
Perimeter = zeros(n, 1);
MajorAxis = zeros(n, 1);
minorAxis = zeros(n,1);
MaxIntensity = zeros(n,1);

k= regionprops(ima,'Area','Perimeter','MajorAxisLength','MinorAxisLength','Eccentricity');
k3=regionprops(ima,mriAdjust,'MaxIntensity','MeanIntensity','MinIntensity','WeightedCentroid','PixelValues');
for j=1:n
    Area(j)= k(j).Area;
    Perimeter(j)= k(j).Perimeter;
    MajorAxisLength(j)=k(j).MajorAxisLength;
    MinorAxisLength(j)=k(j).MinorAxisLength;
    Eccentricity(j)=k(j).Eccentricity;
    MaxIntensity(j)=k3(j).MaxIntensity;
end



test1(i,1)=mean(Area);
test1(i,2)=mean(Perimeter);
test1(i,3)=mean(MaxIntensity);
test1_class(i,1)=1;

end



for i=length(filename3):-1:1
    fname = fullfile(filefolder3 ,filename3{i});
    info = mha_read_header(fname);
    V = mha_read_volume(info);
    
slice_no= input('enter slice no');
 b= squeeze(V(:,:,slice_no));
 figure;
 imshow(b,[]);
    num_iter = 1;
    delta_t = 1/7;
    kappa = 20;
    option = 2;
    
    ad = anisodiff(b,num_iter,delta_t,kappa,option);%ad is the filtered image

[cA,cH,cV,cD] = dwt2(ad,'haar');
max_ad=max(ad(:));
min_ad=min(ad(:));
ad1=im2bw(cA);

I2= Thresholding(cA,max_ad,min_ad);

%find blob
sizeI=size(I2);
L = bwlabeln(I2);
stats = regionprops(L,'area','centroid');

LL= L+1;
cmap = hsv(length(stats));
cmap = [0 0 0;cmap];
LL = cmap(LL, :);
LL = reshape(LL, [sizeI,3]);
% select largest blob
mriAdjust=cA;
A = [stats.Area];


biggest = find(A==max(A));

    for j=1:size(biggest)
    mriAdjust(L ~= biggest(j)) = 0;
    ima = imadjust(mriAdjust);
    end
c1= bwconncomp(ad1, 8);
n1 = c1.NumObjects;
area1=zeros(n1, 1);
k1= regionprops(ad1,'Area');
for y=1:n1
    area1(y)= k1(y).Area;
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

cc= bwconncomp(ima, 8);  %conected component in binary image basically a struct with 4 field

n = cc.NumObjects;

Area = zeros(n, 1);
Perimeter = zeros(n, 1);
MajorAxis = zeros(n, 1);
minorAxis = zeros(n,1);
MaxIntensity = zeros(n,1);

k= regionprops(ima,'Area','Perimeter','MajorAxisLength','MinorAxisLength','Eccentricity');
k3=regionprops(ima,mriAdjust,'MaxIntensity','MeanIntensity','MinIntensity','WeightedCentroid','PixelValues');
for j=1:n
    Area(j)= k(j).Area;
    Perimeter(j)= k(j).Perimeter;
    MajorAxisLength(j)=k(j).MajorAxisLength;
    MinorAxisLength(j)=k(j).MinorAxisLength;
    Eccentricity(j)=k(j).Eccentricity;
    MaxIntensity(j)=k3(j).MaxIntensity;
end

test1(length(filename2)+i,1)=mean(Area);
test1(length(filename2)+i,2)=mean(Perimeter);
test1(length(filename2)+i,3)=mean(MaxIntensity);
test1_class(length(filename2)+i,1)=2;
%test_sample(i)=filename{i};


end  