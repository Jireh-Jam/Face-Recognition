function [studentDatabase ,p] = trainsys(studentDatabase,p)
%%Parmeters
p.trained = 1;
p.number_of_labels = ...
    p.coeff1_quant* p.coeff2_quant* p.coeff3_quant;
%% trans or TRGUESS is good guess for transmission probabilities and emis or EMITGUESS is good guess for emission probabilities
trans = ones(p.number_of_states,p.number_of_states) * 0.1;% params.eps; returns an n-by-n matrix of ones i.e p.numOfStates-by-p.numOfStates
trans(p.number_of_states,p.number_of_states) = 1;
for r=1:p.number_of_states-1
    for c=2:p.number_of_states
        trans(r,c) = 0.5;
        trans(r,c-1) = 0.5;
    end
end

emis = (1/p.number_of_labels)*ones(p.number_of_states,p.number_of_labels);
% subplot(4,1,1)
% plot(trans);
% disp(trans);
% disp(emis);
fprintf('Training Images, Please wait ...\n');
nStudents = size(studentDatabase,2);
for studentIndex=1:nStudents
    fprintf([studentDatabase{1,studentIndex},' ']);
    seqs = cell2mat(studentDatabase{5,studentIndex})'; % matrix (seq) of all the observation sequence matrix to be used converted to a regular matrix
    [estTR,estEMIT]=hmmtrain(seqs,trans,emis,'Tolerance',.01,'Maxiterations',10,'Algorithm', 'BaumWelch'); % estimates the trans and emis probabilities using BaumWelch algorithm
    estTR = max(estTR,p.eps);
    estEMIT = max(estEMIT,p.eps);
    studentDatabase{6,studentIndex}{1,1} = estTR;
    studentDatabase{6,studentIndex}{1,2} = estEMIT;
    if (mod(studentIndex,10)==0)
        fprintf('\n');
    end
end
fprintf('\n done.\n');
save DATABASE studentDatabase p
% disp(estTR);
% disp(estEMIT);
% [seqs,states] = hmmgenerate(1000,trans,emis);
% %
% % char(seqs+'0')
% % char(states+'0')
%
% figure(1);
% subplot(4,1,2);
% studentIndex = find(states==1);
% nStudents = find(states==2);
% plot(studentIndex, ones(size(studentIndex)), 'b.', nStudents, ones(size(nStudents)), 'r.');
% set(gca, 'box','off');
%
%
% %likelystates is a sequence the same length as seq.
% likelystates = hmmviterbi(seqs, trans, emis);
% subplot(4,1,3);
% studentIndex = find(likelystates==1);
% nStudents = find(likelystates==2);
% plot(studentIndex, ones(size(studentIndex)), 'b.', nStudents, ones(size(nStudents)), 'r.');
% set(gca, 'box','off');
%
%
%
% % To test the accuracy of hmmviterbi, compute the percentage of the
% %actual sequence states that agrees with the sequence likelystates.
% sum(states==likelystates)/1000
%
%
%
% %Estimating Posterior State Probabilities
% [PSTATES,logpseq] = hmmdecode(seqs,trans,emis);
% subplot(4,1,4);
% plot(PSTATES');







