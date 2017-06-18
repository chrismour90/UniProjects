
% Mourouzi Christos
% AEM: 6978


% Edw orizoume tous pinakes vasi twn dedomenwn tis askisis kai meta kaloume
% ti synartisi Painter wste na paroume to sxima pou theloume.

clear all
clc

M = 300;
N = 450;

T = [10 290 10 130 440; 30 10 190 290 190]; % orismos pinakas T (koryfes trigwnwn)
Q = [1 2 3; 2 3 4; 3 5 5]; % orismos pinakas Q (trigwna)

CV = [0.9 1 0.5 0 0.3; 0.9 0 0.9 0 0.3; 0.1 0 1 1 0.6]; %orismos pinaka CV (xrwmata koryfwn)

canvas = Painter(Q,T,CV,M,N);

imshow(canvas) %emfanisi tou kamva (argei ligo sto pc mou alla douleuei mia xara)