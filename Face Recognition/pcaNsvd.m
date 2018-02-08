sclear all; close all; clc
A1 = imresize(double(rgb2gray(imread('./daniel','jpg'))),[96,112]);
A2 = imresize(double(rgb2gray(imread('./daniel','jpg'))),[96,112]);
A3 = imresize(double(rgb2gray(imread('./daniel','jpg'))),[96,112]);
A4 = imresize(double(rgb2gray(imread('./daniel','jpg'))),[96,112]);
A5 = imresize(double(rgb2gray(imread('./daniel','jpg'))),[96,112]); 
% width is the horizontal direction which is 96 and hieght is vertical which is 112
subplot(2,5,1),pcolor(flipud(A1)),shading interp, colormap(gray), set(gca,'Xtick',[],'Ytick',[]);
subplot(2,5,2),pcolor(flipud(A2)),shading interp, colormap(gray), set(gca,'Xtick',[],'Ytick',[]);
subplot(2,5,3),pcolor(flipud(A3)),shading interp, colormap(gray), set(gca,'Xtick',[],'Ytick',[]);
subplot(2,5,4),pcolor(flipud(A4)),shading interp, colormap(gray), set(gca,'Xtick',[],'Ytick',[]);
subplot(2,5,5),pcolor(flipud(A5)),shading interp, colormap(gray), set(gca,'Xtick',[],'Ytick',[]);
% the double command turns it into a data matrix
B1 = imresize(double(rgb2gray(imread('./jirreh','bmp'))),[96,112]);
B2 = imresize(double(rgb2gray(imread('./jirreh','bmp'))),[96,112]);
B3 = imresize(double(rgb2gray(imread('./jirreh','bmp'))),[96,112]);
B4 = imresize(double(rgb2gray(imread('./jirreh','bmp'))),[96,112]);
B5 = imresize(double(rgb2gray(imread('./jirreh','bmp'))),[96,112]);
subplot(2,5,6),pcolor(flipud(B1)),shading interp, colormap(gray), set(gca,'Xtick',[],'Ytick',[]);
subplot(2,5,7),pcolor(flipud(B2)),shading interp, colormap(gray), set(gca,'Xtick',[],'Ytick',[]);
subplot(2,5,8),pcolor(flipud(B3)),shading interp, colormap(gray), set(gca,'Xtick',[],'Ytick',[]);
subplot(2,5,9),pcolor(flipud(B4)),shading interp, colormap(gray), set(gca,'Xtick',[],'Ytick',[]);
subplot(2,5,10),pcolor(flipud(B5)),shading interp, colormap(gray), set(gca,'Xtick',[],'Ytick',[]);

AveD = (A1+A2+A3+A4+A5)/5;
AveJ = (B1+B2+B3+B4+B5)/5;
figure(2),
subplot(1,2,1),pcolor(flipud(AveD)),shading interp, colormap(gray), set(gca,'Xtick',[],'Ytick',[]);
subplot(1,2,2),pcolor(flipud(AveJ)),shading interp, colormap(gray), set(gca,'Xtick',[],'Ytick',[]);

%data Matrix
D = [reshape(A1,1,96*112)
    reshape(A2,1,96*112)
    reshape(A3,1,96*112)
    reshape(A4,1,96*112)
    reshape(A5,1,96*112)
    reshape(B1,1,96*112)
    reshape(B2,1,96*112)
    reshape(B3,1,96*112)
    reshape(B4,1,96*112)
    reshape(B5,1,96*112)];
A = (D')*(D);
size(A)
[V,D] = eigs(A,20,'lm');
figure(3)
subplot(2,2,1), face1 = reshape(V(:,1),96,112);pcolor(flipud(AveD)),shading interp, colormap(gray), set(gca,'Xtick',[],'Ytick',[]);
subplot(2,2,2), face1 = reshape(V(:,2),96,112);pcolor(flipud(AveD)),shading interp, colormap(gray), set(gca,'Xtick',[],'Ytick',[]);
subplot(2,2,3), semilogy(diag(D),'ko','LineWidth',[2]) 
set(gca,'Fontsize',[14]);

figure (4)
vecD = reshape(AveD,1,96*112);
vecJ = reshape(AveJ,1,96*112);
projD = vecD*V;
projJ = vecJ*V;
subplot(2,2,1),bar(projD(2:20)),set(gca,'Xlim',[0 20],'Ylim',[-2000 2000],'Xtick',[],'Ytick',[]);
text(12,-1700,'Daniel','Fontsize',15)
subplot(2,2,2),bar(projJ(2:20)),set(gca,'Xlim',[0 20],'Ylim',[-2000 2000],'Xtick',[],'Ytick',[]);
text(12,-1700,'Jirreh','Fontsize',15)

% testing
T1 = imresize( double(rgb2gray(imread('./D','jpg'))),[96 112]);
T2 = imresize( double(rgb2gray(imread('./J','jpg'))),[96 112]);

vec1 = reshape(T1,1,96*112);
vec2 = reshape(T2,1,96*112);
proj1 = vec1*V;
proj2 = vec2*V;

recon1 = V*proj1'; rec1 = reshape(recon1,96,112);
recon2 = V*proj2'; rec2 = reshape(recon2,96,112);
    
