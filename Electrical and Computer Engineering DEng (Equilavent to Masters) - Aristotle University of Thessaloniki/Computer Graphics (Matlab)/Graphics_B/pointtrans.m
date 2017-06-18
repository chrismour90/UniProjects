%Mourouzi Christos
%AEM:7571

function [ d ] = pointtrans( L, c0, c )

% I synartisi pointtrans xrisimopoiei to pinaka metasximatismou L, tis
% arxikes syntetagmenes tou pinaka c kai ton stathero dianysma c0 gia na
% ypologisei to dianysmatiko metasximatismo affine(d) se omogeneis
% syntetagmenes.

    v=vectrans(L,c(1:3,:)); %metasximatismos mi omogenwn syntetagmenwn tou c (3xn dianysmata)
   	
    for i = 1:size( c, 2 )
        d( :, i ) = v(:,i)+c0; %prosthese ka8e metasximatismeno diaynsma 3x1 mazi me affine simeiako metasxmimatismo c0
    end
	d(4, :)=1; %omogeneis syntetagmenes (teleutaia grammi tou d ola 1)
end