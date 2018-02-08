%FYP On Face Detection and Recognition class attendance System
% Jirreh Jam Robert
%k1557901@kingston.ac.uk
% Ref: Matlab Webinar Video
function [studentDatabase,p] = gendata(p) % P is the parameter value which can be in another way params.
% This module reads all the folders inside data folder. Each folder belongs
% to one person and the system assumes that the name of the person is equal
% to the name of its folder.
% In each folder there are 10 images of one person. The system use 5 of
% those images to generate its database. If there are less than 5 images
% inside a folder, the system use all of them for training. Even if there
% is one face photo.

% these parameters can be changed with care
% faceDetector = vision.CascadeObjectDetector;
% resizeHieght = 112;%64
% resizewidth = 92;%64
p.used_faces_for_training= [2 3 4 7 9];
p.used_faces_for_testing =[1 5 6 8 10] ;
p.block_height = 5;%8 n 10
p.block_overlap = 4;
%these numbers are in the third row of myDatabse and must be discrete values between 0 and 17
%for the first value,the second value 0 and 9 and third between 0 and 6
p.coeff1_quant = 18;%18 first parameter value
p.coeff2_quant = 10;%10  second discrete value
p.coeff3_quant = 7;%7 third discrete value
p.number_of_states = 7;
p.face_height = 56;%115
p.face_width = 46;%82

p.eps=.000001;
p.trained = 0;
%
fprintf ('Loading Faces ...\n');
p.number_of_blocks = (p.face_height-p.block_height)/(p.block_height-p.block_overlap)+1;
folderContents = dir ('./database'); % loads the dataset, reads all the faces and store them in a memory. dir is invoked to load the dataset.
numbOfFolders = size(folderContents,1); % there are folders in directory and each folder holds a number of pictures be student
studentDatabase = cell(0,0); % first we declare an array of empty cell to store all the information we will process.
studentIndex = 0; % declaring index for each student to zero gives a valid index because some folder names like "." and ".." will be ignored
%% Access folder of each student in database folder individually. first we declare the index to be zero
for student=1:numbOfFolders
if (strcmp(folderContents(student,1).name,'.') ||...       % is not a folder -> skip. this refers to the first directory % and checks to see if it loops through a valid folder name
            strcmp(folderContents(student,1).name,'..') ||...  % is not a folder -> skip. this refers to the second directory
            (folderContents(student,1).isdir == 0))            % is a file -> skip
       continue;
end
    studentIndex = studentIndex+1; % increments student index after finding a new student in the for-loop
    studentName = folderContents(student,1).name;
    studentDatabase{1,studentIndex} = studentName;
    fprintf([studentName,' ']);
    studentFolderContents = dir(['./database/',studentName,'/*.jpg']);
    nImageStudentFolder = size(studentFolderContents,1);
    blockCell = cell(0,0);
    if (nImageStudentFolder==10)
        ufft = p.used_faces_for_training;
    else
        ufft = 1:nImageStudentFolder; %ufft is a vector that contains 5 integer values between 1 and 10
    end
    nfacesTotrain = size(ufft,2);
    for faceIndex=1:nfacesTotrain % we want to extract the features for n training faces.
        I = imread(['./database/',studentName,'/',studentFolderContents(ufft(faceIndex),1).name]);
        %       I =  imresize(I,[resizewidth,resizeHieght]);
        % figure(faceIndex),imshow(I) ;
        %         img_filtered = I;
        %         for c = 1 : 3
        %             img_filtered(:, :, c) = medfilt2(I(:, :, c), [3, 3]);
        %         end
        %Im = rgb2gray(img_filtered);
        try
            %             I = rgb2gray(img_filtered);
            I = rgb2gray(I);
        catch
            %  warning('Check if everything is Ok !');
        end
       % BB = step(faceDetector,I); % Detect faces
        %          figure(2),imshow(I);
        %         if isempty(BB)
        %             continue;
        %         elseif size(BB,1) > 1
        %[~,idx] = max(BB(:,3));
       % face = I(BB(idx,2):BB(idx,2)+BB(idx,4)-1,BB(idx,1):BB(idx,1)+BB(idx,3)-1);
        %figure, imshow(face);
        %         else
        %            face = I(BB(2):BB(2)+BB(4)-1,BB(1):BB(1)+BB(3)-1);
        % figure, imshow(face);
        %         end
        I = imresize(I,[p.face_height p.face_width]);
        I = ordfilt2(I,1,true(3));
        %       figure(1),imshow(I);
        blockStart = 1;
        blockIndex = 0;
        for blockEnd=p.block_height:p.block_height-p.block_overlap:p.face_height
            block = I(blockStart:blockEnd,:);
            %block_double = double(block);
            [U,S,V] = svd(double(block)); % converts a block matrix into double so it can represent a data matrix
            coeff1 = U(1,1);
            coeff2 = S(1,1);
            coeff3 = S(2,2);
            blockIndex=blockIndex+1;
            blockCell{blockIndex,faceIndex} = [coeff1 coeff2 coeff3];
            blockStart = blockStart + (p.block_height-p.block_overlap);
        end
    end
    studentDatabase{2,studentIndex} = blockCell;
    if (mod(studentIndex,10)==0) %after 10 rows, move to a newline for display
        fprintf('\n');
    end
end
%% finds the maximum and minimum of all three coefficients for all coefficients in the entire observation vector.
% so we fine the minimum of U(1,1) and the maximum of Sumation(1,1) and Sumation(2,2) and
% U(1,1).
coeff1 = [];
coeff2 = [];
coeff3 = [];
nStudents = size(studentDatabase,2);
for studentIndex=1:nStudents
    [nBlocks,nImages] = size(studentDatabase{2,studentIndex});
    for imageIndex=1:nImages
        for blockIndex=1:nBlocks
            if (isempty(studentDatabase{2,studentIndex}{blockIndex,imageIndex}))
                continue;
            end
            coeff1(:,end+1) = studentDatabase{2,studentIndex}{blockIndex,imageIndex}(1,1);
            coeff2(:,end+1) = studentDatabase{2,studentIndex}{blockIndex,imageIndex}(1,2);
            coeff3(:,end+1) = studentDatabase{2,studentIndex}{blockIndex,imageIndex}(1,3);
        end
    end
end
CoefMax1 = max(coeff1(:)); %maxCoeff1
CoefMax2 = max(coeff2(:)); %maxCoeff2
CoefMax3 = max(coeff3(:)); %maxCoeff3
CoefMin1 = min(coeff1(:));
CoefMin2 = 0;%min(coeff2(:)); %it works better with zero
CoefMin3 = 0;%min(coeff3(:)); %it works better with zero
%delta is the width of each bin for quantization
deltaCoeff1 = (CoefMax1-CoefMin1)/(p.coeff1_quant-p.eps);
deltaCoeff2 = (CoefMax2-CoefMin2)/(p.coeff2_quant-p.eps);
deltaCoeff3 = (CoefMax3-CoefMin3)/(p.coeff3_quant-p.eps);
%c = [c2 ;c10; c11; c15];
p.coeff_stats = [CoefMin1 CoefMin2 CoefMin3;CoefMax1 CoefMax2 CoefMax3;deltaCoeff1 deltaCoeff2 deltaCoeff3];
minLabel = Inf; %minLabel
maxLabel = -Inf;%maxLabel
for studentIndex=1:nStudents
    for imageIndex=1:nImages
        for blockIndex=1:nBlocks
            if (isempty(studentDatabase{2,studentIndex}{blockIndex,imageIndex}))
                continue;
            end
            blockCoeffs = studentDatabase{2,studentIndex}{blockIndex,imageIndex};
            minCoeffs = p.coeff_stats(1,:);
            deltaCoeffs = p.coeff_stats(3,:);
            quant = floor((blockCoeffs-minCoeffs)./deltaCoeffs); % rounds to the nearest integer.
            studentDatabase{3,studentIndex}{blockIndex,imageIndex} = quant;
            label = quant(1)* p.coeff2_quant*p.coeff3_quant + quant(2) * p.coeff3_quant + quant(3)+1;
            minLabel = min(label, minLabel); % returns smallest element in each row
            maxLabel = max(label, maxLabel); % can be represented as maxLabel = max([label maxLabel]);
            studentDatabase{4,studentIndex}{blockIndex,imageIndex} = label;
        end
        % fifth row cell matrix converted into regular matrix with integer value that holds observation for each image.
        % i.e after computing the labels for each image. this is done using
        % cell2mat. we now have a matix of 5x52
        studentDatabase{5,studentIndex}{1,imageIndex} = cell2mat(studentDatabase{4,studentIndex}(:,imageIndex));
    end
end
p.min_label = minLabel; %for information only. We don't use it later
p.max_label = maxLabel; %for information only. We don't use it later
fprintf('\n Database generated done.\n');
save DATABASE studentDatabase p;
%%

% params.trained = 1;
% params.number_of_labels = ...
%     params.coeff1_quant* params.coeff2_quant* params.coeff3_quant;
% TRGUESS = ones(params.number_of_states,params.number_of_states) * 0.1;% params.eps;
% TRGUESS(params.number_of_states,params.number_of_states) = 1;
% for r=1:params.number_of_states-1
%     for c=2:params.number_of_states
%         TRGUESS(r,c) = 0.5;
%         TRGUESS(r,c-1) = 0.5;
%     end
% end
%
% EMITGUESS = (1/params.number_of_labels)*ones(params.number_of_states,params.number_of_labels);
%
% fprintf('Training ...\n');
% nStudents = size(myDatabase,2);
% for studentIndex=1:nStudents
%     fprintf([myDatabase{1,studentIndex},' ']);
%     seqmat = cell2mat(myDatabase{5,studentIndex})';
%     [ESTTR,ESTEMIT]=hmmtrain(seqmat,TRGUESS,EMITGUESS,'Tolerance',.01,'Maxiterations',10,'Algorithm', 'BaumWelch');
%     ESTTR = max(ESTTR,params.eps);
%     ESTEMIT = max(ESTEMIT,params.eps);
%     myDatabase{6,studentIndex}{1,1} = ESTTR;
%     myDatabase{6,studentIndex}{1,2} = ESTEMIT;
%     if (mod(studentIndex,10)==0)
%         fprintf('\n');
%     end
% end
% fprintf('done.\n');
% save DATABASE myDatabase params

%%
% if (params.trained==0)
%     fprintf('System is not trained. Please train your system first.\n');
%     return;
% end
%
% total = 0;
% recRate = 0;
% fprintf('Please Wait...\n');
% folderContents = dir ('./Database');
% numbOfFoldersInDatabaseFolder = size(folderContents,1);
% studentIndex = 0;
% for student=1:numbOfFoldersInDatabaseFolder
%     if strcmp(folderContents(student,1).name,'.') % is not a folder -> skip
%         continue;
%     end
%     if strcmp(folderContents(student,1).name,'..') % is not a folder -> skip
%         continue;
%     end
%     if (folderContents(student,1).isdir == 0) % is a file -> skip
%         continue;
%     end
%     studentIndex = studentIndex+1;
%     studentName = folderContents(student,1).name;
%     fprintf([studentName,'\n']);
%     studentFolderContents = dir(['./Database/',studentName,'/*.bmp']);
%     numbOfFacesInStudentFolder = size(studentFolderContents,1);
%     if (numbOfFacesInStudentFolder==10)
%         ufft = params.used_faces_for_testing;
%     else
%         ufft = 1:numbOfFacesInStudentFolder;
%     end
%     for faceIndex=1:size(ufft,2)
%         total = total + 1;
%         filename = ['./Database/',studentName,'/',studentFolderContents(ufft(faceIndex),1).name];
%         answerStudentIndex = facerec(filename,myDatabase,params,1);
%         if (answerStudentIndex == studentIndex)
%             recRate = recRate + 1;
%         end
%     end
% end
% recRate = recRate/total*100;
% fprintf(['\nRecognition Rate is ',num2str(recRate),'%% for a total of ',num2str(total),' unseen faces.\n']);
