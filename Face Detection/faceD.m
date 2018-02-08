

faceDetector=vision.CascadeObjectDetector('FrontalFaceCART','MergeThreshold',1); %Create a detector object

% faceDetector.MinSize = [20,20];
% faceDetector.ScaleFactor = 1.25;
% shapeInserter = vision.ShapeInserter('BorderColor','Custom','CustomBorderColor',[0 255 255]);
[filename, folder] = uigetfile({'*.jpg';'*.png';'*.bmp'},'File Selector');
fullFileName = fullfile(folder,filename);

% % 
% % params.x1 = 570;
% % params.x2 = 850;
% % params.y1 = 570;
% % params.y2 = 850;
% % % [file_name, file_path] = uigetfile ({'*.jpg';'*.bmp';'*.pgm';'*.png'});
% % % filename = [file_path,file_name];
% % I=imread(fullFileName);
% % % I=imread('/Users/macbookair/Downloads/D.jpeg');% To read image
% % %figure,imshow(I)
% % pic=rgb2gray(I);% To convert RGB image to gray image(normalised image)
% % % Resize to 11*92 or 112*92 (whatever is wanted), if necessary.
% % gI = pic %imresize(pic, [112, 92]);
% % % Convert to pgm format disk file
% % imwrite(gI, 'myFile.jpg');
% % x=0:255;
% % % breaking points from gui
% % x1 = params.x1;
% % x2 = params.x1;
% % y1 = params.x1;
% % y2 = params.x1;
% % % x1 =input('Enter any value for 1st break point(X1):');
% % % x2 =input('Enter any value for 2nd break point(X2):');
% % % y1 =input('Enter any value for 2nd break point(Y1):');
% % % y2 =input('Enter any value for 2nd break point(Y2):');
% % 
% % % range definitions
% % x_r1 = 0:x1;
% % x_r2 = x1+1:x2;
% % x_r3 = x2+1:255;
% % 
% % % line gradients
% % a1 = y1/x1;
% % a2 = (y2-y1)/(x2-x1);
% % a3 = (255-y2)/(255-x2);
% % 
% % % line functions
% % yo_1 = a1*x_r1;
% % yo_2 = y1 + (a2*(x_r2-x1));
% % yo_3 = y2 + (a3*(x_r3-x2));
% % 
% % % line concatance
% % y = [yo_1 yo_2 yo_3];
% % 
% % % plot line
% % % plot(x,y),grid on;
% % % xlim([0 255]);
% % % ylim([0 255]);
% % 
% % % Implementing contrast stretching using piece wise linear transform.
% % [rowi coli]=size(gI);
% % out=zeros(rowi,coli);
% % 
% % for k=1:256
% %     for i=1:rowi
% %         for j=1:coli
% % if gI(i,j)==x(k)
% %     out(i,j)=y(k);
% % end
% %         end
% %     end
% % end
% % 
% % figure(1),imshow(uint8(out))
% % figure(2),imshow(pic)
% % figure(3),imshow(gI)

I = imread(fullFileName);
% %I = imresize(I,0.75);
faceDetector.MinSize = [20,20];
faceDetector.ScaleFactor = 1.05;
%faceDetector.MaxSize = [112 92];
% figure,imshow(I);
% I = I;
% hsv = rgb2hsv(I);
% h = hsv(:,:,1);
% s = hsv(:,:,2);
% 
% [r c v] = find(h>0.25 | s<=0.15 | s>0.9); % non skin
% numid = size(r,1);
% for i = 1:numid
%     I(r(i),c(i),:) = 0;
% end
% Irgb = I;
% r = Irgb(:,:,1);
% g = Irgb(:,:,2);
% b = Irgb(:,:,3);
% 
% [row col v] = find(b>0.79*g-67 & b<0.78*g+42 & b>0.836*g-14 & b<0.836*g+44); % non skin pixels
% numid = size(row,1);
% for i = 1:numid
%     Irgb(row(i),col(i),:) = 0;
%  end
I=rgb2gray(I); % convert to gray
BB=step(faceDetector,I); % Detect faces

iimg = insertObjectAnnotation(I, 'rectangle', BB, 'Face'); %Annotate detected faces.

figure(1);
imshow(iimg); 
title('Detected face');
%%
% BBFace= zeros(size(BB));
% for i =1:length(BB)
%     Icrop = imcrop(img,BB(i,:));
%     BB = step(faceDetector,Icrop);
%     if ~ isempty(BB)
%         BBFace(i,:) = BB +[BB{i,:}-1 0 0];
%     end
% end


% htextinsface = TextInserter('Text', 'face   : %2d', 'Location',  [5 2],'Font', 'Courier New','FontSize', 14);


%imshow(img);
hold on
BBFace= zeros(size(BB));
for i=1:size(BB,1)
    rectangle('position',BB(i,:),'Linewidth',2,'Linestyle','-','Edgecolor','y');
end
hold on
numberOfBBs = size(BB,1); %length(BB)

message = sprintf('Attendance.\nThe number of students in lecture today = %d', numberOfBBs);

uiwait(helpdlg(message));






for i = 1:size(BB,1)
 image= imcrop(I,BB(i,:));
 % J = imresize(image,[112 92]);
 % imresize(im2,1.25,'bilinear'); %Bilinear interpolation; the output pixel value is a weighted average of pixels in the nearest 2-by-2 neighborhood
 %I = rgb2gray(J);
 figure(3),subplot(6,10,i);imshow(image);
 %figure(3),subplot(size(bbox,1),1,mod(size(bbox,1),i)+1);
 %imshow(image);
end
 %%
 basepath = '/Users/macbookair/Desktop/FYP MATLAB/Face Detection/Image/' % folder in which i want to save images

for i = 1:size(BB,1) %number of faces in bounding boxes

face=cell(1,size(BB,1));

face{i}=imcrop(I,BB(i,:));
faceImage = imresize(face{i},[112 92]);
%faces = rgb2gray(faceImage);
imwrite(faceImage, strcat(basepath, sprintf('%d.bmp',i)),'bmp');
figure(2);
imshow(faceImage); 
title('crop pic');
   
    pause(.5);

end


% N=size(BB,1);
% handles.N=N;
% counter=1;
% for i=1:N
%     if ~ isempty(BB)
%     BBFace=imcrop(I,BB(i,:));
%     savenam = strcat('/Users/macbookair/Desktop/FYP MATLAB/Face Detection' ,num2str(counter), '.jpg'); %this is where and what your image will be saved
%     baseDir  = '/Users/macbookair/Desktop/FYP MATLAB/Face Detection/Image/';
%     %     baseName = 'image_';
%     newName  = [baseDir num2str(counter) '.jpg'];
%     handles.face=BBFace;
%     end
%     while exist(newName,'file')
%         counter = counter + 1;
%         newName = [baseDir num2str(counter) '.jpg'];
%     end
%     %fac=imresize(BBFace,[112,92]);
%     imwrite(BBFace,newName);

% figure(2);
% imshow(BBFace); 
% title('crop pic');
%    
%     pause(.5);
% 
% end