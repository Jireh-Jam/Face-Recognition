% Thilina S. Ambagahawaththa
% 2011-03-23
% breaking points from gui
% I = getcam();
% if (~isempty(I))
%             filename = ['./',num2str(floor(rand()*10)+1),'.jpg'];
%             imwrite(I,filename);
% %             if (exist('myDatabase','var'))
% %                 facerec (filename,myDatabase,p,0);
% %             end
% end
[file_name, file_path] = uigetfile ({'*.jpg';'*.bmp';'*.pgm';'*.png'});
filename = [file_path,file_name];
I=imread(filename);% To read image
figure,imshow(I)
p=rgb2gray(I);% To convert RGB image to gray image(normalised image)
% Resize to 11*92 or 112*92 (whatever is wanted), if necessary.
gI = imresize(p, [112, 92]);
% Convert to pgm format disk file
imwrite(gI, 'myFile.pgm');
params.x1 = 0.01;
params.x2 = 0.09;
params.y1 = 0.01;
params.y2 = 0.09;
x_1=params.x1;
x_2=params.x2;
y_1=params.y1 ;
y_2=params.y2;
x1 = floor(get (x_1,'Value'));
x2 = floor(get (x_2,'Value'));
y1 = floor(get (y_1,'Value'));
y2 = floor(get (y_2,'Value'));

% range definitions
x_r1 = 0:x1;
x_r2 = x1:x2;
x_r3 = x2:255;

% line gradients
a1 = y1/x1;
a2 = (y2-y1)/(x2-x1);
a3 = (255-y2)/(255-x2);

% line functions
yo_1 = floor(a1*x_r1);
yo_2 = floor(y1 + (a2*(x_r2-x1)));
yo_3 = floor(y2 + (a3*(x_r3-x2)));

% line concatance
y = [yo_1 yo_2 yo_3];

% plot line
subplot(1,1,1,'Parent',fg);
plot(y);
xlim([0 255]);
ylim([0 255]);

try % if image is loaded
    
    % mask images for colour intensity regions
    mask_1 = double(imageIn<=x1);
    mask_2 = double((imageIn>x1)&(imageIn<x2));
    mask_3 = double(imageIn>=x2);
    
    % contrast stretching in regions
    im1 = mask_1.*floor(a1*imageIn);
    im2 = mask_2.*floor(y1 + (a2*(imageIn-x1)));
    im3 = mask_3.*floor(y2 + (a3*(imageIn-x2)));
    
    % concatance of output image
    imageOut = cast(im1+im2+im3,'uint8');
    
    % show output image
    subplot(1,1,1,'Parent',ck);
    imshow(imageOut);
    
    % image histogram generation
    histo1 = log10(imhist(imageOut));
    histo2 = log10(imhist(cast(imageIn,'uint8')));
    subplot(1,1,1,'Parent',bg);
    hgrm = [histo1,histo2];
    plot(hgrm);
    xlim([0 255]);
    
catch e %image not loaded
    
end