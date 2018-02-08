I = imread('J.jpg');
figure;
imshow(I);
title('Step-1: Load input image');


img_filtered = I;
for c = 1 : 3
    img_filtered(:, :, c) = medfilt2(I(:, :, c), [3, 3]);
end
Im = rgb2gray(img_filtered);
figure; 
imshow(Im);
title('Step-3:Noise Removal');

H = fspecial('gaussian'); % Create the filter kernel.
img_filtered = imfilter(img_filtered,H); % Blur the image.
Mask = im2bw(img_filtered, 0.9); % Now we are generating the binary mask.
img_filtered([Mask, Mask, Mask]) = 0; % Now we have the image.
figure;
imshow(img_filtered);
title('Step-5:Segmented Image');
