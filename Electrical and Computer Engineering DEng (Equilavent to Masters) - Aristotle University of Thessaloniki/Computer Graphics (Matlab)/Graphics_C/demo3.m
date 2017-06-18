% Mourouzi Christos
% AEM=7571

% Function demo takes the points that are given as input data  to produce
% the desired outcome
	
	clear all;
	clc;
	
	 disp( 'Please, wait! The image is being processed!' );

	% Load data for showing the vase

	load vase2013.mat;

	% Values for the camera
	
	cv = [-50 -200 -10]';
	cK = [5 20 -20]';
	cu = [0 0 1]';

	bC = [0.5 0.5 0.5]';

	Q = F(:,2:4);
	T = r;
	C = C / 255;

	% Clear F and r because they are no longer going to be used during the process

	clear F;
	clear r;

	% Produce the vase
 
	ka = 0.5 * C;
	kd = 0.7 * C;
	ks = 0.5 * C;
	ncoeff = 3; 
	w = 0.3;
	H = 1 / 2;
	W = 2 / 3;
	M = 400;
	N = 600;
 
	S = [80 -150 150]';
	I0 = [1 1 1]';
	Ia = [1 1 1]'; 

	
	im = PhongPhoto(w, cv, cK, cu, bC, M, N, H, W, T, Q, S, ka, kd, ks, ncoeff, Ia, I0, C);
 
	% Show the image

	imshow(im, 'InitialMagnification', 67);	



