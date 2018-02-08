function recRate = testsys(studentDatabase,p)

if (p.trained==0)
    fprintf('System is not trained. Please train your system first.\n');
    return;
end

total = 0;
recRate = 0;
% errorRate = 0;
% number_of_faces_recognized = 0;
% number_of_faces_presented = 0;
% for K = 1 : number_of_face_images
%   face_image = imread() of the K'th face image
%   was_it_recognized = try_to_recognize_face(face_image);
%   number_of_faces_presented = number_of_faces_presented + 1;
%   number_of_faces_recognized = number_of_faces_recognized + was_it_recognized;
% end
% recognition_rate = number_of_faces_recognized / number_of_faces_presented;
fprintf('Please Wait...\n');
folderContents = dir ('./database');
numbOfFoldersInDatabaseFolder = size(folderContents,1);
%inputFace = filename;
studentIndex = 0;
for student=1:numbOfFoldersInDatabaseFolder
    if (strcmp(folderContents(student,1).name,'.') ||... % is not a folder -> skip
        strcmp(folderContents(student,1).name,'..') ||...
        (folderContents(student,1).isdir == 0))
          continue;
    end
    studentIndex = studentIndex+1;
    studentName = folderContents(student,1).name;
    fprintf([studentName,'\n']);
    studentFolderContents = dir(['./database/',studentName,'/*.jpg']);
    numbOfFacesInStudentFolder = size(studentFolderContents,1);
    if (numbOfFacesInStudentFolder==10)
        ufft = p.used_faces_for_testing;
    else
        ufft = 1:numbOfFacesInStudentFolder;
    end
    for faceIndex=1:size(ufft,2)
        total = total + 1;
        filename = ['./database/',studentName,'/',studentFolderContents(ufft(faceIndex),1).name];
        answerStudentIndex = facerec(filename,studentDatabase,p,1);
        if (answerStudentIndex == studentIndex)
            recRate = recRate + 1;
        end
    end
end
%recRate = recRate/total*100;
number_of_faces_recognized = answerStudentIndex;
number_of_faces_presented = total;
for faceIndex = 1 : size(ufft,2)
  filename = ['./database/',studentName,'/',studentFolderContents(ufft(faceIndex),1).name];
  %I = imread(['./database/',studentName,'/',studentFolderContents(ufft(faceIndex),1).name]);
  answerStudentIndex = facerec(filename,studentDatabase,p,1);
  was_it_recognized =answerStudentIndex;
  %if(answerStudentIndex==studentIndex)
  number_of_faces_presented = number_of_faces_presented + 1;
  number_of_faces_recognized = number_of_faces_recognized + was_it_recognized;
 % end
end
recRate = (number_of_faces_recognized / number_of_faces_presented)*100;
fprintf(['\nRecognition Rate is ',num2str(recRate),'%% for a total of ',num2str(total),' unseen faces.\n']);


% function recRate = testsys(studentDatabase,minmax)
% ufft = [2 3 4 7 9];
% total = 0;
% recRate = 0;
% fprintf('Please Wait...\n');
% folderContents = dir ('./database');
% numberOfFolderInDatabaseFolder = size(folderContents,1);
% studentIndex = 0;
% for student=1:numberOfFolderInDatabaseFolder
%     if (strcmp(folderContents(student,1).name,'.') || ...
%         strcmp(folderContents(student,1).name,'..') || ...
%         (folderContents(student,1).isdir == 0))
%         continue;
%     end
%     studentIndex = studentIndex+1;
%     studentName = folderContents(student,1).name;
%     fprintf([studentName,'\n']);
%     studentFolderContents = dir(['./database/',studentName,'/*.jpg']);    
%     for face_index=1:size(ufft,2)
%         total = total + 1;
%         filename = ['./database/',studentName,'/',studentFolderContents(ufft(face_index),1).name];        
%         answerStudentIndex = facerec(filename,studentDatabase,minmax);
%         if (answerStudentIndex == studentIndex)
%             recRate = recRate + 1;
%         end        
%     end
% end
% recRate = recRate/total*100;
% fprintf(['\nRecognition Rate is ',num2str(recRate),'%% for a total of ',num2str(total),' unseen faces.\n']);