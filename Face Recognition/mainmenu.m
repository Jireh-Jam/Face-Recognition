function varargout = mainmenu(varargin)
% MAINMENU MATLAB code for mainmenu.fig
%      MAINMENU, by itself, creates a new MAINMENU or raises the existing
%      singleton*.
%
%      H = MAINMENU returns the handle to a new MAINMENU or the handle to
%      the existing singleton*.
%
%      MAINMENU('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAINMENU.M with the given input arguments.
%
%      MAINMENU('Property','Value',...) creates a new MAINMENU or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before mainmenu_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to mainmenu_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help mainmenu

% Last Modified by GUIDE v2.5 11-Jan-2018 09:05:55

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @mainmenu_OpeningFcn, ...
                   'gui_OutputFcn',  @mainmenu_OutputFcn, ...
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


% --- Executes just before mainmenu is made visible.
function mainmenu_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to mainmenu (see VARARGIN)

% Choose default command line output for mainmenu
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

% UIWAIT makes mainmenu wait for user response (see UIRESUME)
% uiwait(handles.mainmenu);


% --- Outputs from this function are returned to the command line.
function varargout = mainmenu_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function textInfo_Callback(hObject, eventdata, handles)
% hObject    handle to textInfo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of textInfo as text
%        str2double(get(hObject,'String')) returns contents of textInfo as a double


% --- Executes during object creation, after setting all properties.
function textInfo_CreateFcn(hObject, eventdata, handles)
% hObject    handle to textInfo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% textInfo = sprintf('%s\n\n%s',textInfo,fileInfo.date);
% textInfo = sprintf('This is my GUI',textInfo);
% set(handles.textInfo,'String',textInfo);

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in gendat.
function gendat_Callback(hObject, eventdata, handles)
% hObject    handle to gendat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (~exist('DATABASE.mat','file'))
    [myDatabase, p] = gendata();
else
    pause(0.001);
    choice2 = questdlg('Generating a new database will remove any previous trained database. Are you sure?', ...
        'Warning...',...
        'Yes', ...
        'No','No');
    switch choice2
        case 'Yes'
            pause(0.1);
            [myDatabase, p] = gendata();
        case 'No'
    end
end



% --- Executes on button press in Load.
function Load_Callback(hObject, eventdata, handles)
% hObject    handle to Load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (~exist('DATABASE.mat','file'))
    fprintf('Database file does not exist. Please generate it first!\n');
else
    load DATABASE.mat;
    fprintf('Database is now loaded.\n');
    set(handles.textInfo,'String','Database is now loaded.\n');
end
set(handles.textInfo,'String','Database is now loaded.');

% --- Executes on button press in webcam.
function webcam_Callback(hObject, eventdata, handles)
% hObject    handle to webcam (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
I = getcam();
if (~isempty(I))
    filename = ['./',num2str(floor(rand()*10)+1),'.jpg'];
    imwrite(I,filename);
    if (exist('myDatabase','var'))
        facerec (filename,myDatabase,p,0);
    end
end


% --- Executes on button press in Train.
function Train_Callback(hObject, eventdata, handles)
% hObject    handle to Train (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (~exist('myDatabase','var'))
    fprintf('Please generate or load database first!\n');
else
    if (p.trained==0)
        [myDatabase, p] = trainsys(myDatabase,p);
    else
        pause(0.001);
        choice2 = questdlg('Your database is already trained. Do you really want to re-train your data?', ...
            'Warning...',...
            'Yes', ...
            'No','No');
        switch choice2
            case 'Yes'
                pause(0.1);
                [myDatabase, p] = trainsys(myDatabase,p);
                h = waitbar(0,'Please wait...');
                steps = 1000;
                for step = 1:steps
                    % computations take place here
                    waitbar(step / steps)
                end
                close(h)
            case 'No'
        end
    end
end


% --- Executes on button press in RecRate.
function RecRate_Callback(hObject, eventdata, handles)
% hObject    handle to RecRate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (~exist('myDatabase','var'))
    fprintf('Please generate or load database first!\n');
else
    % testsys
    recRate = testsys(myDatabase,p);
    h = waitbar(0,'Please wait...');
    steps = 1000;
    for step = 1:steps
        % computations take place here
        waitbar(step / steps)
    end
    close(h)
end


% --- Executes on button press in recognition.
function recognition_Callback(hObject, eventdata, handles)
% hObject    handle to recognition (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
facerec
% if (~exist('myDatabase','var'))
%     fprintf('Please load database first!\n');
% else
%     pause(0.001);
%     % show file dialog box and get one image from the user
%     [file_name, file_path] = uigetfile ({'*.jpg';'*.bmp';'*.pgm';'*.png'});
% %     if file_path ~= 0
% %         filename = [file_path,file_name];
% % %       subplot(2,2,1);imshow(filename);title('Searching...');
% % %         axes(handles.axes3)
% % % imshow(filename);title('Searching...'); hold on
% %         facerec (filename,myDatabase,p,0)
% %         h = waitbar(0,'Please wait...');
% %         steps = 1000;
% %         for step = 1:steps
% %             % computations take place here
% %             waitbar(step / steps)
% %         end
% %         close(h)
% %     end
% end
% axes(handles.axes3)
% imshow(filename);title('Searching...'); hold on


% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton16.
function pushbutton16_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in Exitbtn.
function Exitbtn_Callback(hObject, eventdata, handles)
% hObject    handle to Exitbtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc;
close All;
% Clear the variables
% clearStr = 'clear all';
clearStr = 'clear All';
evalin('base',clearStr);
% Delete the figure. Use the tag on the main GUI to add to the handle. You
% can rename the tag or use the default name.
delete(handles.mainmenu);
% --- Executes when user attempts to close facedetectorGUI.
% function mainmenu_CloseRequestFcn(hObject, eventdata, handles)
% % hObject    handle to facedetectorGUI (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% % Select between buttons to switch GUI.
% % % switch get(handles.uipanel1,'SelectedObject');
% % %   case handles.radiobutton1
% % %       close(gui1);
% % %       run('gui2');       
% % %   case handles.radiobutton2
% % %       close(gui1);
% % %       run('gui3');      
% % % end
% 
% % Hint: delete(hObject) closes the figure
% delete(hObject);
 
