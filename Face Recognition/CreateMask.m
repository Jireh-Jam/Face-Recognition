function [ ObjectMask] = CreateMask( YourImage )

% Written by Amir Pasha M
% 09/30/2014
% University of California, San Francisco

% Comment: You can create a mask from the biggest object of your image.


rgbImg = imread('J.jpg');


%% First, let's segment the object in your image (ROI)

% Create a object mask
ObjectMask = ~im2bw(rgbImg ,graythresh(rgbImg ));

%% Using Regionprops
% ALTERNATIVELY: Clear all but largest objects
% Label the connected regions, then extract size of
% each.  Find the biggest region.  Ignore all others by
% zeroing them out.

cc = bwconncomp(ObjectMask);
stats = regionprops(cc ,ObjectMask,'Area','BoundingBox');
A = [stats.Area];
[~,biggest] = max(A);
ObjectMask(labelmatrix(cc)~=biggest) = 0;
ObjectMask = imfill(ObjectMask,'holes');
figure;imshow(ObjectMask);

end