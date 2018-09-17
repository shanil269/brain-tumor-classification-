function im = Thresholding(I,mx,mn)
[r, c] = size(I);

im= zeros(r, c);
for i=1:r
    for j=1:c
        if I(i,j)>mx; %orginal image having more than 105 pixel will be elliminated
            im(i,j)=255;
        end
    end
end
im= bwareaopen(im,0);%elliminating those area whose pixel is less than or equal to 5
im=imfill(im,'holes');%compensating the elliminated area
end
