close all;
%clear all;
clc
params.x1 = 92;
params.x2 = 112;
params.y1 = 92;
params.y2 = 112;
[file_name, file_path] = uigetfile ({'*.jpg';'*.bmp';'*.pgm';'*.png'});
filename = [file_path,file_name];
I=imread(filename);
% I=imread('/Users/macbookair/Downloads/D.jpeg');% To read image
figure,imshow(I)
p=rgb2gray(I);% To convert RGB image to gray image(normalised image)
% Resize to 11*92 or 112*92 (whatever is wanted), if necessary.
gI = imresize(p, [112, 92]);
% Convert to pgm format disk file
imwrite(gI, 'myFile.pgm');
x=0:255;
% breaking points from gui
x1 = params.x1;
x2 = params.x1;
y1 = params.x1;
y2 = params.x1;
% x1 =input('Enter any value for 1st break point(X1):');
% x2 =input('Enter any value for 2nd break point(X2):');
% y1 =input('Enter any value for 2nd break point(Y1):');
% y2 =input('Enter any value for 2nd break point(Y2):');

% range definitions
x_r1 = 0:x1;
x_r2 = x1+1:x2;
x_r3 = x2+1:255;

% line gradients
a1 = y1/x1;
a2 = (y2-y1)/(x2-x1);
a3 = (255-y2)/(255-x2);

% line functions
yo_1 = a1*x_r1;
yo_2 = y1 + (a2*(x_r2-x1));
yo_3 = y2 + (a3*(x_r3-x2));

% line concatance
y = [yo_1 yo_2 yo_3];

% plot line
plot(x,y),grid on;
xlim([0 255]);
ylim([0 255]);

% Implementing contrast stretching using piece wise linear transform.
[rowi, coli]=size(gI);
out=zeros(rowi,coli);

for k=1:256
    for i=1:rowi
        for j=1:coli
            if gI(i,j)==x(k)
                out(i,j)=y(k);
            end
        end
    end
end
figure(1),imshow(uint8(out))
figure(2),imshow(p)
figure(3),imshow(gI)
