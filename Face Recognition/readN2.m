close all
clear

%% read and crop image
I = imread('J.jpg');
I = rgb2gray(I); %convert to grayscale

% Left-click and drag to make bounding box, right-click to crop
% I = imcrop(I); % currently you crop by hand but can be set to specific values, look at doc for 'imcrop'

figure
subplot(2,2,1)
title('Original Image')
imshow(I); %show cropped image

%% create binary image and remove noise/fill holes
% BW = imbinarize(I); %convert to binary image
BW = imbinarize(I,'adaptive','ForegroundPolarity','dark','Sensitivity',0.4);

se = strel('disk',3);
BW = imclose(BW,se); %fill small holes
se = strel('disk',75);
BW = imopen(BW,se); %remove noise
se = strel('disk',100);
BW = imclose(BW,se); %fill big holes

subplot(2,2,2)
title('Regions')
imshow(BW)

%% find white regions in BW image
cc = bwconncomp(BW)

%% find 2nd largest region
numPixels = cellfun(@numel,cc.PixelIdxList);
[biggest,idx] = max(numPixels); 
[secondBiggest] = max(numPixels(numPixels~=biggest));
idx2 = find(numPixels==secondBiggest);

%% find corresponding data in the original image
mask = uint8(zeros(size(I)));
mask(cc.PixelIdxList{idx2}) = 1; %create mask from largest region
maskedI = I.*mask; % convert anything not in the area to black

subplot(2,2,3)
title('Masked Image (black)')
imshow(maskedI)

maskedI2 =maskedI;
maskedI2(mask == 0) = 255;

subplot(2,2,4)
title('Masked Image (white)')
imshow(maskedI2)