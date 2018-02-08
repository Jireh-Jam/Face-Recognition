% path='./database';
% jpeg_files = dir(fullfile(path,'*.jpg'));
% for cnt = 1 :5
%     I{cnt} = imread(fullfile(path,jpeg_files(cnt).name));     
%     figure,imshow(I{cnt});
% end

% images ='./database';
% jpgfiles=dir(fullfile(images,'*.jpg*'))
% n=numel(jpgfiles);
% idx=randi(n);
% im=jpgfiles(idx).name
% im1=imread(fullfile(images,im))
% imshow(im1)
fileNames = dir(fullfile('./database/David_Beckham','*.jpg'));
N = length(fileNames);
for k = 1:N
    filename = fileNames(k).name;
    C{k} = imread(filename);
    figure,imshow(C{k});
end