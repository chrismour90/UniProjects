%Mourouzi Christos
%AEM:7571

function [ d ] = systemtrans( L, c0, c )

% I synartisi systemtrans metasximatizei ti vasi twn simeiwn efarmozontas
% ton antistrofo pinaka metasximatismou L stis arxikes syntetagmenes tou c
% kai tis metatopizei kata -c0.

    a=axistrans(L,c(1:3,:)); %paragwgi kainouriwn syntetagmenwn twn dianymsatwn tou c(3x1) stin kainouria vasi
   	    
    for i = 1:size( c, 2 )
        d( :, i ) = a(:,i)-c0; %metatopisi twn kainouriwn syntetagmenwn kata -c0
    end
    
    d(4, :)=1; %omogeneis syntetagmenes

end