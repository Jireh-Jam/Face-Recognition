
%FYP On Face Detection and Recognition class attendance System
% Jirreh Jam Robert
%Demo December 2017
% After training, each face is associated with the HMM and in testing, each
% test image of size 112 by 92 goes through the same block extraction,
% feature extraction and quantization process.
% Each image after the training and testing stage is now represented by its
% own observation sequence ( A vector of 52 Integerswhich each has a value
% between 1 and 1260 as per the label in the generate data phase.
function [studentIndex,maxlogpseq] = facerec(filename,studentDatabase,p,displayFilename)
if (p.trained==0)
    fprintf('System is not trained. Please train your system first.\n');
    return;
end
I = imread(filename);
try
    I = rgb2gray(I);
catch
end
% params.x1 = 92;
% params.x2 = 112;
% params.y1 = 92;
% params.y2 = 112;
% % [file_name, file_path] = uigetfile ({'*.jpg';'*.bmp';'*.pgm';'*.png'});
% % filename = [file_path,file_name];
% I=imread(filename);
% % I=imread('/Users/macbookair/Downloads/D.jpeg');% To read image
% %figure,imshow(I)
% pic=rgb2gray(I);% To convert RGB image to gray image(normalised image)
% % Resize to 11*92 or 112*92 (whatever is wanted), if necessary.
% gI = imresize(pic, [112, 92]);
% % Convert to pgm format disk file
% imwrite(gI, 'myFile.jpg');
% x=0:255;
% % breaking points from gui
% x1 = params.x1;
% x2 = params.x1;
% y1 = params.x1;
% y2 = params.x1;
% % x1 =input('Enter any value for 1st break point(X1):');
% % x2 =input('Enter any value for 2nd break point(X2):');
% % y1 =input('Enter any value for 2nd break point(Y1):');
% % y2 =input('Enter any value for 2nd break point(Y2):');
%
% % range definitions
% x_r1 = 0:x1;
% x_r2 = x1+1:x2;
% x_r3 = x2+1:255;
%
% % line gradients
% a1 = y1/x1;
% a2 = (y2-y1)/(x2-x1);
% a3 = (255-y2)/(255-x2);
%
% % line functions
% yo_1 = a1*x_r1;
% yo_2 = y1 + (a2*(x_r2-x1));
% yo_3 = y2 + (a3*(x_r3-x2));
%
% % line concatance
% y = [yo_1 yo_2 yo_3];
%
% % plot line
% % plot(x,y),grid on;
% % xlim([0 255]);
% % ylim([0 255]);
%
% % Implementing contrast stretching using piece wise linear transform.
% [rowi coli]=size(gI);
% out=zeros(rowi,coli);
%
% for k=1:256
%     for i=1:rowi
%         for j=1:coli
% if gI(i,j)==x(k)
%     out(i,j)=y(k);
% end
%         end
%     end
% end
% % figure(1),imshow(uint8(out))
% % figure(2),imshow(pic)
% % figure(3),imshow(gI)
I = imresize(I,[p.face_height p.face_width]); % resizes to 50% of its size to get more speed in the training and testing
%I = ordfilt2(I,25,true(5));
I = ordfilt2(I,1,true(3)); % applies a minimum order static filter to the gray level image. this may improve recognition accuracy.
% taken from paper referenced in lit review
blockBegin = 1;
blockIndex = 0;
nBlocks = 0;
blockCell = cell((p.face_height-p.block_height)/(p.block_height-p.block_overlap)+1,1);
% generate features from image blocks
for blockEnd=p.block_height:p.block_height-p.block_overlap:p.face_height
    nBlocks = nBlocks + 1;
    block = I(blockBegin:blockEnd,:);
    %blockDouble = double(block);
    [U,S,V] = svd(double(block));
    coeff1 = U(1,1);
    coeff2 = S(1,1);
    coeff3 = S(2,2);
    blockIndex=blockIndex+1;
    blockCell{blockIndex,1} = [coeff1 coeff2 coeff3]; % fills in the empty blockcell
    blockBegin = blockBegin + (p.block_height-p.block_overlap);
end

%quantize features of each block, assign label to each and generate sequence
seq = zeros(1,nBlocks);
for blockIndex=1:nBlocks
    blockCoeffs = blockCell{blockIndex,1};
    minCoeffs = p.coeff_stats(1,:);
    max_coeffs = p.coeff_stats(2,:);
    blockCoeffs = max([blockCoeffs;minCoeffs]);
    blockCoeffs = min([blockCoeffs;max_coeffs]);
    deltaCoeffs = p.coeff_stats(3,:);
    quant = floor((blockCoeffs-minCoeffs)./deltaCoeffs);
    label = quant(1)* p.coeff2_quant*p.coeff3_quant + quant(2) * p.coeff3_quant + quant(3)+1;
    seq(1,blockIndex) = label;
end

%calculate sequence probability for each face model in the database
number_of_student_in_database = size(studentDatabase,2);
results = zeros(1,number_of_student_in_database);
for faceIndex=1:number_of_student_in_database
    TRANS = studentDatabase{6,faceIndex}{1,1}; %transition probabilities of the trained model
    EMIS = studentDatabase{6,faceIndex}{1,2}; %emission probabilities of the trained model
    [~,logpseq] = hmmdecode(seq,TRANS,EMIS);
%     [seq,states] = hmmgenerate(1000,TRANS,EMIS);
%     likelystates = hmmviterbi(seq, TRANS, EMIS);
    P=exp(logpseq);
    results(1,faceIndex) = P;
end
[maxlogpseq,studentIndex] = max(results);
%disp(logpseq);
% TRANS = studentDatabase{6,faceIndex}{1,1};% disp(TRANS);
% EMIS = studentDatabase{6,faceIndex}{1,2}; %disp(EMIS);
% [seq,states] = hmmgenerate(200,TRANS,EMIS);
% likelystates = hmmviterbi(seq,TRANS,EMIS);
% index = find(states == studentIndex);
% student_index = find(states==1);
%disp(sum(faceIndex)/sum(p.trained)*100);
if (displayFilename)
    fprintf(['The student ',filename,' whom you are looking for is ',studentDatabase{1,studentIndex},'.\n']);
    
else
    fprintf(['Your Search for',filename,' found "',studentDatabase{1,studentIndex},'".It has been displayed on the Window','.\n']) ;
    folderContents = dir(['./database/',studentDatabase{1,studentIndex},'/*.jpg']);
    numbOfFolders = size(folderContents,1);
    for student=1:numbOfFolders
        studentName = folderContents(student,1).name;
        I = imread(['./database/',studentDatabase{1,studentIndex},'/', studentName ]);
        %figure(2),imshow(I);
    end
    if(displayFilename~=displayFilename)
        fprintf(['Not a Face ',displayFilename,'.\n']);
    else
        subplot(2,2,3);imshow(I);title(['Found ',studentDatabase{1,studentIndex}]);
    end
end
%if(max(results))
%     disp(sum(states==likelystates)/100)
%end
%%





%%
%% Some inspiration of how i came about the code for percentage of probability.
%%
% I = rand(10,6); % make 72 variable to plot
% for i=1:4
%     figure
%     for j=1:3
%         subplot(1,3,j)
%         plot(I(:,i:4:6))
%     end
% end
[seq,states] = hmmgenerate(100,TRANS,EMIS);
% figure(4),
% plot(seq,states);
%
%
% char(seq+'0')
% char(states+'0')

% [estimateTR ,estimateE] = hmmestimate(seq,states);
%  csvwrite('trains2.txt',estimateTR);
%  csvwrite('trains.txt',estimateE);
% figure(1);
% subplot(3,1,1);
% studentIndex = find(states==1);
% studentIndex = find(states==2);
%studentIndex= find(states==1);
% figure(2),
% plot (student_index, ones(size(student_index)), 'b.', student_index, ones(size(student_index)), 'r.');
% set(gca, 'box','off');

%% likelystates of a sequence of probability
%likelystates is a sequence the same length as seq.
likelystates = hmmviterbi(seq, TRANS,EMIS);
% disp(likelystates);
%subplot(3,1,2);
%studentIndex = find(likelystates==1);
%student_index = find(likelystates==1);
% plot(index1, ones(size(index1)), 'b.', index2, ones(size(index2)), 'r.');
% set(gca, 'box','off');

%%

% To test the accuracy of hmmviterbi, compute the percentage of the
%actual sequence states that agrees with the sequence likelystates.
disp(sum(states==likelystates)/100);


% %[seq,states] = hmmgenerate(1000,trans,emis);
% [estimateTR,estimateE] = hmmestimate(seq,states);

%Estimating Posterior State Probabilities
% [PSTATES,logpseq] = hmmdecode(seq,TRANS,EMIS);
% subplot(3,1,3);
% plot(PSTATES');
%[TRANS_EST, EMIS_EST] = hmmestimate(seq, states)

% TRANS_GUESS = [.1 .9; .9 .1];
% EMIS_GUESS = [.17 .16 .17 .16 .17 .17;.6 .08 .08 .08 .08 08];

%[TRANS_EST2, EMIS_EST2] = hmmtrain(seq, TRANS_GUESS, EMIS_GUESS)
%% Using Singular Value Decomposition and Eigenspace
% I = imresize(double(rgb2gray(imread(filename))),[96,112]);
% AveFace = I/student_index;
% D = reshape(I,[p.face_height p.face_width]);
% A = (D')* D;
% size(A)
% [V,D] = eigs(A,20,'lm');
% figure(3)
% subplot(2,2,1), face1 = reshape(V(:,1),96,112);pcolor(flipud(AveFace)),shading interp, colormap(gray), set(gca,'Xtick',[],'Ytick',[]);
% subplot(1,2,3), semilogy(diag(D),'ko','LineWidth',[2])
% set(gca,'Fontsize',[14]);
% figure (4)
% vecFace = reshape(AveFace,1,96*112);
% projFace = vecFace*V;
% subplot(2,2,1),bar(projFace(2:20)),set(gca,'Xlim',[0 20],'Ylim',[-2000 2000],'Xtick',[],'Ytick',[]);
% text(12,-1700,'Daniel','Fontsize',15)


% for i=1:student_index,
%      for j=1:4,
%       stri = num2str(i);
%       strj = num2str(j);
%       cmd = [?logProb(?,stri,?,?,strj,?) = loglik_ghmm(X?,stri,?,hmm?,strj,?);?]
%       eval(cmd);
% end; end;
%%