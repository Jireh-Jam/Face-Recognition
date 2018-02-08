function varargout = facedetectorGUI(varargin)
% FACEDETECTORGUI MATLAB code for facedetectorGUI.fig
%      FACEDETECTORGUI, by itself, creates a new FACEDETECTORGUI or raises the existing
%      singleton*.
%
%      H = FACEDETECTORGUI returns the handle to a new FACEDETECTORGUI or the handle to
%      the existing singleton*.
%
%      FACEDETECTORGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FACEDETECTORGUI.M with the given input arguments.
%
%      FACEDETECTORGUI('Property','Value',...) creates a new FACEDETECTORGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before facedetectorGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to facedetectorGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help facedetectorGUI

% Last Modified by GUIDE v2.5 04-Feb-2018 01:39:11

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @facedetectorGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @facedetectorGUI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

%===================================================================================================================

% --- Executes just before facedetectorGUI is made visible.
function facedetectorGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to facedetectorGUI (see VARARGIN)

% Choose default command line output for facedetectorGUI
handles.output = hObject;

myImage = imread('king.png');
set(handles.axes2,'Units','pixels');
resizePos = get(handles.axes2,'Position');
myImage= imresize(myImage, [resizePos(3) resizePos(3)]);
axes(handles.axes2);
imshow(myImage);
set(handles.axes2,'Units','normalized');
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes facedetectorGUI wait for user response (see UIRESUME)
% uiwait(handles.facedetectorGUI);
%===================================================================================================================

% --- Outputs from this function are returned to the command line.
function varargout = facedetectorGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global WarnUser 
% try
% 	% Print informational message so you can look in the command window and see the order of program flow.
% 	fprintf(1, 'Just entered FaceDetector-GUI_OutputFcn...\n');
% 	% Get default command line output from handles structure
% 	varargout{1} = handles.output;
% 	
% 	% Maximize the window via undocumented Java call.
% 	% Reference: http://undocumentedmatlab.com/blog/minimize-maximize-figure-window
% 	MaximizeFigureWindow;
% 	
% 	% Print informational message so you can look in the command window and see the order of program flow.
% %	fprintf(1, 'Now leaving FaceDetector-GUI_OutputFcn.\n');
% catch ME
% 	% Some error happened if you get here.
% 	callStackString = GetCallStack(ME);
% 	errorMessage = sprintf('Error in program %s.\nTraceback (most recent at top):\n%s\nError Message:\n%s', ...
% 		mfilename, callStackString, ME.message);
% 	WarnUser(errorMessage);
% end


% Get default command line output from handles structure
varargout{1} = handles.output;

%===================================================================================================================


% --- Executes on button press in LoadBtn.
function LoadBtn_Callback(hObject, eventdata, handles)
% hObject    handle to LoadBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.output = hObject;
% close
% read
global image im2 %variable image
if true
[filename,pathname]=uigetfile({'*.jpeg;*.jpg;*.gif;*.tif;*.tiff;*.bmp;*.png',... 
    'all  image file';'*.jpg;*.jpeg','JPEG Files(*.jpg,*.jpeg)';...   % Select the correct color for test 
    '*.gif','GIF Files(*.gif)';'*.tif;*.tiff','TIFF Files(*.tif,*.tiff)';... 
   '*.bmp','Bitmap Files(*.bmp)';'*.png','PNG Files(*.png)';'MultiSelect', 'on'});  
end
ab =strcat(pathname, filename); %Adds path to filename and reads the image using Imread function below.
image =imread(ab); %Imread function reads the image (ab) extracted from the path declared above.
axes(handles.axes1) % Handles the pictures in the axis1.
imshow(image)  % this function shows the image in the axis declared above.

% % guidata(hObject, handles);
%===================================================================================================================

% --- Executes on button press in DetectBtn.
function DetectBtn_Callback(hObject, eventdata, handles)
% hObject    handle to DetectBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% close
% count
%To detect Face
global image im2 % Gloabal variable of the image, used in all sections of this code.
h = rgb2gray(image);  % converts the image to gray to output a gray image "h"
axes(handles.axes1) % image outputs in axis1
imshow(image) 
im2=image;
FaceDtect = vision.CascadeObjectDetector('FrontalFaceCART','MergeThreshold',1); %algorithm that is used to detect the faces in the image. the visionCasdeObjectDetector based on the Viola-Jones

% FaceDtect.MinSize = [20,20];
FaceDtect.ScaleFactor = 1.05;
images = rgb2gray(image);

% Returns Bounding Box values based on number of objects

BBox = step(FaceDtect,images);
detectedImg = insertObjectAnnotation(images,'rectangle',BBox,1:size(BBox,1));
%BBox_face = zeros(size(BBox));
% for i = 1:length(BBox)
%     Icrop = imcrop(image,BBox(i,2,:));
%     BBox = step(FaceDtect,Icrop);
%     if ~isempty(BBox)
%         BBox_face(i,:) = BBox +[BBox(i,1:2)-1 0 0];
%     end
% end
% I_faces = insertObjectAnnotation(image,'rectangle',BBox,1:size(BBox,1));
axes(handles.axes1)
imshow(detectedImg); hold on
%imshow(detectedImg,I_faces); hold on

for i = 1:size(BBox,1)

    rectangle('Position',BBox(i,:),'LineWidth',2,'LineStyle','-','EdgeColor','y');
end

numberOfBBs = size(BBox,1);  %length(BBox);

message = sprintf('Attendance.\nThe number of students in lecture today = %d', numberOfBBs);

uiwait(helpdlg(message));

%===================================================================================================================

% --- Executes on button press in Exitbtn.
function Exitbtn_Callback(hObject, eventdata, handles)
% hObject    handle to Exitbtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%clear command Window
% % try
% % 	Print informational message so you can look in the command window and see the order of program flow.
% % 	fprintf(1, 'Just entered exitbtn_Callback...\n');
% % 	
% % 	Save the current settings out to the .mat file.
% % 	SaveUserSettings(handles);
% % 	
% % 	Cause it to shutdown.
% % 	delete(handles.facedetectorGUI);
% % 	
% % 	Print informational message so you can look in the command window and see the order of program flow.
% % 	fprintf(1, 'Now leaving btnExit_Callback.\n');
% % catch ME
% % 	Some error happened if you get here.
% % 	callStackString = GetCallStack(ME);
% % 	errorMessage = sprintf('Error in program %s.\nTraceback (most recent at top):\n%s\nError Message:\n%s', ...
% % 		mfilename, callStackString, ME.message);
% % 	WarnUser(errorMessage);
% % end
% % % Clear the command window and close the GUI.
clc;
close All;
% Clear the variables
% clearStr = 'clear all';
clearStr = 'clear All';
evalin('base',clearStr);
% Delete the figure. Use the tag on the main GUI to add to the handle. You
% can rename the tag or use the default name.
delete(handles.facedetectorGUI);

%===================================================================================================================

% --- Executes when user attempts to close facedetectorGUI.
function facedetectorGUI_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to facedetectorGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Select between buttons to switch GUI.
% % switch get(handles.uipanel1,'SelectedObject');
% %   case handles.radiobutton1
% %       close(gui1);
% %       run('gui2');       
% %   case handles.radiobutton2
% %       close(gui1);
% %       run('gui3');      
% % end

% Hint: delete(hObject) closes the figure
delete(hObject);


% --------------------------------------------------------------------
function TOOLS_Callback(hObject, eventdata, handles)
% hObject    handle to TOOLS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%===================================================================================================================
% Pops up a message box and waits for the user to click OK.
function msgboxw(in_strMessage)
uiwait(msgbox(in_strMessage));
return;


%===================================================================================================================
% Pops up a help/information box and waits for the user to click OK.
function msgboxh(in_strMessage)
uiwait(helpdlg(in_strMessage));
return;


%==========================================================================================================================
% Warn user via the command window and a popup message.
function WarnUser(warningMessage)
fprintf(1, '%s\n', warningMessage);
uiwait(warndlg(warningMessage));
return; % from WarnUser()


% --- Executes during object deletion, before destroying properties.
function facedetectorGUI_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to facedetectorGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
function text2_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to text2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
function facedetectorGUI_CreateFcn(hObject, eventdata, handles)
% hObject    handle to facedetectorGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in CropBtn.
function CropBtn_Callback(hObject, eventdata, handles)
% hObject    handle to CropBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global image im2
%h = rgb2gray(image);
axes(handles.axes1)
imshow(image)
im2=image;
FaceDtect = vision.CascadeObjectDetector();
%Automatically crop detected faces within bounding box
BBox = step(FaceDtect,image);% Fix this problem.
for i = 1:size(BBox,1)
 image= imcrop(im2,BBox(i,:));
 % J = imresize(image,[112 92]);
 % imresize(im2,1.25,'bilinear'); %Bilinear interpolation; the output pixel value is a weighted average of pixels in the nearest 2-by-2 neighborhood
 %I = rgb2gray(J);
 figure(3),subplot(6,10,i);imshow(image);
 %figure(3),subplot(size(bbox,1),1,mod(size(bbox,1),i)+1);
 %imshow(image);
end
 %%
 basepath = '/Users/macbookair/Desktop/FYP MATLAB/Face Detection/Image/' % folder in which i want to save images

for i = 1:size(BBox,1) %number of faces in bounding boxes

face=cell(1,size(BBox,1));

face{i}=imcrop(im2,BBox(i,:));
faceImage = imresize(face{i},[112 92]);
faces = rgb2gray(faceImage);
imwrite(faces, strcat(basepath, sprintf('%d.bmp',i)),'bmp');
end
