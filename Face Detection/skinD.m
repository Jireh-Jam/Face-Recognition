clear all;
close all;
clc;

%% HSV segmentation
img = imread('faces2.jpg');
I = img;
hsv = rgb2hsv(I);
h = hsv(:,:,1);
s = hsv(:,:,2);

[r c v] = find(h>0.25 | s<=0.15 | s>0.9); % non skin
numid = size(r,1);
for i = 1:numid
    I(r(i),c(i),:) = 0;
end
figure(1), imshow(I);
%% yCbcR segmmentation
Iycbr = I; % image from previos segmentation
ycbcr = rgb2ycbcr(Iycbr);
cb = ycbcr(:,:,2);
cr = ycbcr(:,:,3);

%% Detect Skin

% [ r,c,v] = find(cb>=77 & cb<=127 & cr>=133 & cr<=173);

[r c v] = find(cb<=77 | cb>=127 | cr<=133 | cr>=173);
numid = size(r,1);

% Mark Skin Pixels
for i = 1:numid
    Iycbr(r(i),c(i),:) = 0;
    % bin(r(i),c(i)) = 1;
end
figure(2),title (' ycbcr segmentation');
imshow(Iycbr);

%% RGB segmentation
Irgb = Iycbr;
r = Irgb(:,:,1);
g = Irgb(:,:,2);
b = Irgb(:,:,3);

[row col v] = find(b>0.79*g-67 & b<0.78*g+42 & b>0.836*g-14 & b<0.836*g+44); % non skin pixels
numid = size(row,1);
for i = 1:numid
    Irgb(row(i),col(i),:) = 0;
 end
% figure
% imshow(Iycbr);
figure(3), title('Image');
imshow(Irgb);