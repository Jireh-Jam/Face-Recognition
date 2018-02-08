clc;    % Clear the command window.
close all;  % Close all figures (except those of imtool.)
clear;  % Erase all existing variables. Or clearvars if you want.
workspace;  % Make sure the workspace panel is showing.
format long g;
format compact;
fontSize = 20;
% Plot True Positive against possible classification rate threshold for ROC
% curve. at 75% threshold, TP = 10/110 = 0.090~=0.1 and FP = 0/90 = 0
% At 45% threshodl, TP = 110-25 = 85/110 = 0.7 and FP = 25/90 = 0.2
% At 40% threshold, TP = 105/110 = 0.95 `~=1 and FP 80/90 = 0.88 ~=0.9
% True Positive Rate.
TPR = [0.1 0.7 1]; %
% False Positive Rate.
FPR = [0  0.2 0.9];
plot(FPR, TPR, 'bd-', 'LineWidth', 2);
title('ROC Curve', 'FontSize', fontSize);
xlabel('False Positive Rate', 'FontSize', fontSize);
ylabel('True Positive Rate', 'FontSize', fontSize);
grid on;
line([0,1], [0,1], 'LineWidth', 2, 'Color', 'k');
axis square;