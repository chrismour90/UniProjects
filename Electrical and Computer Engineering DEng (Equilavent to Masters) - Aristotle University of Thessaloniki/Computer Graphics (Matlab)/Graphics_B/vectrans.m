%Mourouzi Christos
%AEM:7571

function [ d ] = vectrans( L, c )

% I sygkekrimeni synartisi metasximatizei tis arxikes syntetagmenes tou
% dianysmatos c stis kainouries vasi tou metasximatismou L.

    d = zeros( size( c ) );

    for i = 1:size( c, 2 )
        d( :, i ) = L * c( :, i ); %i stili tou d=L * i stili tou c
    end

end