im = imread('D.jpg');
gray = rgb2gray(im);
SE = strel('Disk',1,4);
morphologicalGradient = imsubtract(imdilate(gray,SE),imerode(gray,SE));
%mask = im2bw(morphologicalGradient,0.03);
mask = imbinarize(morphologicalGradient,0.03);
SE = strel('Disk',3,4);
mask = imclose(mask,SE);
mask = imfill(mask,'holes');
mask = bwareafilt(mask,1);
notMask = ~mask;
mask = mask | bwpropfilt(notMask,'Area',[-Inf,5000 - eps(5000)]);
figure(1),imshow(gray)
showMaskAsOverlay(0.5,mask,'r');
h = impoly(imgca,'closed',false);
% fnc = makeConstrainToRecFcn('impoly',get(imgca,'XLim'),get(imgca,'YLim'));
% setPositionContraintFcn(h,fcn);
gray = rgb2gray(im);
gray(~mask) = 255;
figure(2),imshow(gray) % This image is of clas uinet8;255 is the vlaue of "white" for uint8 images
%Break down and mask the planes
r = im(:,:,1);
g = im(:,:,2);
b = im(:,:,3);
r(~mask) = 255;
g(~mask) = 255;
b(~mask) = 255;
% Reconstruct the image
im = cat(3,r,g,b);
figure(3),imshow(im);
%fixing the interface
shellMask = createShellMask(h,'thickness',3);
figure(4),imshow(shellMask);
% use regionfill function of the image processing toolboox
r = regionfill(r,shellMask);
g = regionfill(g,shellMask);
b = regionfill(b,shellMask);
im = cat(3,r,g,b);
figure(5),imshow(im);
imgout = planewise(fnchandle,rgbimg,varargin)


