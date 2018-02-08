clc;
clear all;
close all;
% Load Image Information from ATT Face Database Directory
% Start with a folder and get a list of all subfolders.
% Finds and prints names of all PNG, JPG, and TIF images in 
% that folder and all of its subfolders.
% Similar to imageSet() function in the Computer Vision System Toolbox
% Define a starting folder.
start_path = fullfile(matlabroot, '\toolbox\images\imdemos');

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

% Process all image files in those folders.
for k = 1 : numberOfFolders
	
    % Get this folder and print it out.
	thisFolder = listOfFolderNames{k};
	fprintf('Processing folder %s\n', thisFolder);
	
	% Get Pgm files.
	filePattern = sprintf('%s/*.pgm', thisFolder);
	baseFileNames = dir(filePattern);
	numberOfImageFiles = length(baseFileNames);
	
    % Now we have a list of all files in this folder.
	
	if numberOfImageFiles >= 1
		
        % Go through all those image files.
		for f = 1 : numberOfImageFiles
			fullFileName = fullfile(thisFolder, baseFileNames(f).name);
           faceDatabase =imread(fullFileName);
           
           imshow(faceDatabase);
            
			fprintf('     Processing image file %s\n', fullFileName);
		end
	else
		fprintf('     Folder %s has no image files in it.\n', thisFolder);
	end
end


%% Display Montage of First Face
figure;
montage(faceDatabase(1).ImageLocation);
title('Images of Single Face');

%%  Display Query Image and Database Side-Side
personToQuery = 1;
galleryImage = read(faceDatabase(personToQuery),1);
figure;
for i=1:size(faceDatabase,2)
imageList(i) = faceDatabase(i).ImageLocation(5);
end
subplot(1,2,1);
imshow(galleryImage);
subplot(1,2,2);
montage(imageList);
diff = zeros(1,9);

%% Split Database into Training & Test Sets
[training,test] = partition(faceDatabase,[0.8 0.2]);


%% Extract and display Histogram of Oriented Gradient Features for single face 
person = 5;
[hogFeature, visualization]= ...
    extractHOGFeatures(read(training(person),1));
figure;
subplot(2,1,1);
imshow(read(training(person),1));
title('Input Face');
subplot(2,1,2);
plot(visualization);
title('HoG Feature');

%% Extract HOG Features for training set 
trainingFeatures = zeros(size(training,2)*training(1).Count,4680);
featureCount = 1;
for i=1:size(training,2)
    for j = 1:training(i).Count
        trainingFeatures(featureCount,:) = extractHOGFeatures(read(training(i),j));
        trainingLabel{featureCount} = training(i).Description;    
        featureCount = featureCount + 1;
    end
    personIndex{i} = training(i).Description;
end

%% Create 40 class classifier using fitcecoc 
faceClassifier = fitcecoc(trainingFeatures,trainingLabel);


%% Test Images from Test Set 
person = 1;
queryImage = read(test(person),1);
queryFeatures = extractHOGFeatures(queryImage);
personLabel = predict(faceClassifier,queryFeatures);

% Map back to training set to find identity 
booleanIndex = strcmp(personLabel, personIndex);
integerIndex = find(booleanIndex);
subplot(1,2,1);
imshow(queryImage);
title('Query Face');
subplot(1,2,2);
imshow(read(training(integerIndex),1));
title('Matched Class');

%% Test First 5 People from Test Set
figure;
figureNum = 1;
for person=1:5
    for j = 1:test(person).Count
        queryImage = read(test(person),j);
        queryFeatures = extractHOGFeatures(queryImage);
        personLabel = predict(faceClassifier,queryFeatures);
       
        % Map back to training set to find identity
        booleanIndex = strcmp(personLabel, personIndex);
        integerIndex = find(booleanIndex);
        subplot(2,2,figureNum);
        imshow(imresize(queryImage,3));
        title('Query Face');
        subplot(2,2,figureNum+1);
        imshow(imresize(read(training(integerIndex),1),3));
        title('Matched Class');
        figureNum = figureNum+2;
        
    end
    figure;
    figureNum = 1;

end


