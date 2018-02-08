[FileName,PathName] = uigetfile({'*.jpg;*.tif;*.png;*.gif','All Image Files'},'Please Select an Image');
image = imread([PathName FileName]); 
imshow(image) %needed to use imellipse
user_defined_ellipse = imellipse(gca, []); % creates user defined ellipse object.
wait(user_defined_ellipse);% You need to click twice to continue. 
MASK = double(user_defined_ellipse.createMask());
new_image_name = [PathName 'Cropped_Image_' FileName];
new_image_name = new_image_name(1:strfind(new_image_name,'.')-1); %removing the .jpg, .tiff, etc 
new_image_name = [new_image_name '.png']; % making the image .png so it can be transparent
imwrite(image, new_image_name,'png','Alpha',MASK);
msg = msgbox(['The image was written to ' new_image_name],'New Image Path');
waitfor(msg);