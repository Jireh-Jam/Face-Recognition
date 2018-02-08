% Start with a folder and get a list of all subfolders.
% Finds and prints names of all PNG, JPG, and TIF images in 
% that folder and all of its subfolders.
clc;    % Clear the command window.
workspace;  % Make sure the workspace panel is showing.
format longg;
format compact;

% Define a starting folder.
start_path = fullfile(matlabroot, '/Users/macbookair/Desktop/FYP MATLAB/Face Recognition/database');
% Ask user to confirm or change.
topLevelFolder = uigetdir(start_path);
if topLevelFolder == 0
	return;
end
% Get list of all subfolders.
allSubFolders = genpath(topLevelFolder);
% Parse into a cell array.
remain = allSubFolders;
listOfFolderNames = {};
while true
	[singleSubFolder, remain] = strtok(remain, ';');
	if isempty(singleSubFolder)
		break;
	end
	listOfFolderNames = [listOfFolderNames singleSubFolder];
end
numberOfFolders = length(listOfFolderNames)
% file = listOfFolderNames;
% [filepath,name,ext] = fileparts(file)
% parts = strsplit(thisFolder , '/');
% DirPart = parts{end-1};
% Process all image files in those folders.
for k = 1 : numberOfFolders
	% Get this folder and print it out.
	thisFolder = listOfFolderNames{k};
    parts = strsplit(thisFolder , '/');
DirPart = parts{end};
	fprintf('Processing folder %s\n', DirPart);
    
    
    
    
   % image_folder = './database/David_Beckham'; %  Enter name of folder from which you want to upload pictures with full path

filenames = dir(fullfile(start_path, '*.jpg'));  % read all images with specified extention, its jpg in our case
total_images = numel(filenames);    % count total number of photos present in that folder

for n = 1:total_images
    full_name= fullfile(image_folder, filenames(n).name);         % it will specify images names with full path and extension
    our_images = imread(full_name);                 % Read images
    figure (n)                           % used tat index n so old figures are not over written by new new figures
    imshow(our_images)                  % Show all images
end
	
% 	% Get PNG files.
% 	filePattern = sprintf('%s/*.png', thisFolder);
% 	baseFileNames = dir(filePattern);
% 	% Add on TIF files.
% 	filePattern = sprintf('%s/*.tif', thisFolder);
% 	baseFileNames = [baseFileNames; dir(filePattern)];
% 	% Add on JPG files.
% 	filePattern = sprintf('%s/*.jpg', thisFolder);
% 	baseFileNames = [baseFileNames; dir(filePattern)];
 	numberOfImageFiles = length(filenames);
% 	% Now we have a list of all files in this folder.
	
	if numberOfImageFiles >= 1
		% Go through all those image files.
		for f = 1 : numberOfImageFiles
			full_name = fullfile(thisFolder,filenames(f).name);
			fprintf('     Processing image file %s\n', full_name);
		end
	else
		fprintf('     Folder %s has no image files in it.\n', DirPart);
	end
end