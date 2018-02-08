%FYP On Face Detection and Recognition class attendance System
% Jirreh Jam Robert
% Demo December 2017
%clear all;
diary('mycommand.txt');
close all;
clc;
diary('off')

if (exist('DATABASE.mat','file'))
    load DATABASE.mat;
end
while (1==1)
    choice=menu('Face Recognition',...
        'Generate Database',...
        'Load Database',...
        'Train System',...
        'Recognize from Webcam',....
        'Recognize a Student',...
        'Calculate Recognition Rate',...
        'Exit');
    if (choice ==1)
        if (~exist('DATABASE.mat','file'))
            [studentDatabase, p] = gendata();
        else
            pause(0.001);
            choice2 = questdlg('Generating a new database will remove any previous trained database. Are you sure?', ...
                'Warning...',...
                'Yes', ...
                'No','No');
            switch choice2
                case 'Yes'
                    pause(0.1);
                    [studentDatabase, p] = gendata();
                case 'No'
            end
        end
    end
    if (choice == 2)
        if (~exist('DATABASE.mat','file'))
            fprintf('Database file does not exist. Please generate it first!\n');
        else
            load DATABASE.mat;
            fprintf('Database is now loaded.\n');
        end
    end
    if (choice == 3)
        if (~exist('studentDatabase','var'))
            fprintf('Please generate or load database first!\n');
        else
            if (p.trained==0)
                [studentDatabase, p] = trainsys(studentDatabase,p);
            else
                pause(0.001);
                choice2 = questdlg('Your database is already trained. Do you really want to re-train your data?', ...
                    'Warning...',...
                    'Yes', ...
                    'No','No');
                switch choice2
                    case 'Yes'
                        pause(0.1);
                        [studentDatabase, p] = trainsys(studentDatabase,p);
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
    end
    if (choice == 4)
        %for i = 1:10
        % I = getcam()
        I = getcam();
        if (~isempty(I))
            filename = ['./',num2str(floor(rand()*10)+1),'.jpg'];
            imwrite(I,filename);
            if (exist('studentDatabase','var'))
                facerec (filename,studentDatabase,p,0);
            end
        end
    end
    if (choice == 5)
        if (~exist('studentDatabase','var'))
            fprintf('Please load database first!\n');
        else
            pause(0.001);
            % show file dialog box and get one image from the user
            [file_name, file_path] = uigetfile ({'*.jpg';'*.bmp';'*.pgm';'*.png'});
            if file_path ~= 0
                filename = [file_path,file_name];
                subplot(2,2,1);imshow(filename);title('Searching...');
                facerec (filename,studentDatabase,p,0)
                h = waitbar(0,'Please wait...');
                steps = 1000;
                for step = 1:steps
                    % computations take place here
                    waitbar(step / steps)
                end
                close(h)
            end
        end
    end
    if (choice == 6)
        if (~exist('studentDatabase','var'))
            fprintf('Please generate or load database first!\n');
        else
            % testsys
            recRate = testsys(studentDatabase,p);
            h = waitbar(0,'Please wait...');
            steps = 1000;
            for step = 1:steps
                % computations take place here
                waitbar(step / steps)
            end
            close(h)
        end
    end
    if (choice == 7)
        clear choice choice2
        return;
    end
end
