function I = getcam()
%vid = videoinput('macvideo',1);
%%,'YCbCr422_1280x720'
cam = webcam();
preview(cam);
%I = snapshot(cam);
%imshow(I);

%preview(vid);
choice = menu(' Capture Frame  ','  Capture  ','  Exit  ');
I = [];
if (choice == 1)
    %I = getsnapshot(vid);
    %I = snapshot(vid);
    I = snapshot(cam);
    % figure,imshow(I);
    try
        I = rgb2gray(I);
    catch
        warning('Problem using getcam(). Please try again');
    end
    faceDetector = vision.CascadeObjectDetector();
    
    bbox            = step(faceDetector, I);
    
    videoOut = insertObjectAnnotation(I,'rectangle',bbox,'Face');
    figure, imshow(videoOut), title('Detected face');
    
    I = I(8:231,68:251);
    I = imresize(I,[112 92]);
    %     I = I(8:231,68:251);
    %     I = imresize(I,[112 92]);
    % I = I(56,46);
    %I = imcrop(I,[112,92]);
%         FaceDetect = vision.CascadeObjectDetector();
%         %FaceDetect.MergeThreshold = 7;
%         BB = step(FaceDetect,I);
%         Im = insertShape(I,'rectangle',BB,'LineWidth',5);
%         figure; imshow(Im); title('Detected face');
%         I = imcrop(I,[BB(1)-25 BB(2)-25 BB(3)+25 BB(4)+25]);
%         scaleFactor = 100/size(I,1);
%         I = imresize(I,scaleFactor);
%         %I = im2uint8(I);
%        % I = histeq(I);
%         %I = double(I);
%     %figure; imshow(I), title('Cropped Face');
%         for i = 1:size(BB,1)
%             rectangle('Position',BB(i,:),'LineWidth',2,'LineStyle','-','EdgeColor','y');
%         end
%         title ('Detected Face');
%        hold off;
%         for i = 1:size(BB,1)
%             J = imcrop(I,BB(i,:));
%             figure(3); subplot(6,6,i);
%      I = imresize(I,[112 92]);
     %figure(4), imshow(I)
% end
end
closePreview(cam);
clear('cam');
% closepreview(vid);
