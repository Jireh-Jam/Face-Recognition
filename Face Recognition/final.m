folderContents = dir ('./database'); % loads the dataset, reads all the faces and store them in a memory. dir is invoked to load the dataset.
numbOfFolders = size(folderContents,1); % there are folders in directory and each folder holds a number of pictures be student
myDatabase = cell(0,0); % first we declare an array of empty cell to store all the information we will process.
studentIndex = 0; % declaring index for each student to zero gives a valid index because some folder names like "." and ".." will be ignored
%% Access folder of each student in database folder individually. first we declare the index to be zero
for student=1:numbOfFolders
    if strcmp(folderContents(student,1).name,'.') % is not a folder -> skip. this refers to the first directory and checks to see if it loops through a valid folder name
        % folder name can be printed by
        % fprintf(folderContents(student,1).name)
        continue;
    end
    if strcmp(folderContents(student,1).name,'..') % is not a folder -> skip. this refers to the second directory
        continue;
    end
    if (folderContents(student,1).isdir == 0) % is a file -> skip
        continue;
    end
    studentIndex = studentIndex+1; % increments student index after finding a new student in the for-loop
    studentName = folderContents(student,1).name;
    myDatabase{1,studentIndex} = studentName;
    fprintf([studentName,' ']);
    studentFolderContents = dir(['./database/',studentName,'/*.jpg']);
    nImageStudentFolder = size(studentFolderContents,1);
    blockCell = cell(0,0);
    if (nImageStudentFolder==10)
        %         ufft = p.used_faces_for_training;
        %     else
        ufft = 1:nImageStudentFolder-9; %ufft is a vector that contains 5 integer values between 1 and 10
    end
    nfacesTotrain = size(ufft,2);
    for faceIndex=1:nfacesTotrain % we want to extract the features for n training faces.
         I = imread(['./database/',studentName,'/',studentFolderContents(ufft(faceIndex),1).name]);
%         for K = 1 : 5
%             I = imread(['./database/',studentName,'/',studentFolderContents(ufft(faceIndex),1).name]);
%             
%             %this_image = imread( sprintf('%d.bmp', K) );
%             ax = subplot(1, 5, faceIndex);
%             imshow(I, 'Parent', ax);
%         end
                figure(faceIndex),imshow(I) ;
    end
 end