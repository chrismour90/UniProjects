%Mourouzi Christos
%AEM:7571

function [ d ] = axistrans( L, c )

% I sygkekrimeni synartisi metasximatizei ti vasi twn dianysmatwn.
% Xrisimopoiei ton antistrofo pinaka metasximatismou L kai tis syntetagmenes tou
% dianysmatos tis arxikis vasis kai paragei tis kainouries syntetagmenes
% tou dianysmatos gia tin kainouriga vasi.

    d = zeros( size( c ) );

    for i = 1:size( c, 2 )
        d( :, i ) = L \ c( :, i ); %i stili tou d=L \ i stili tou c
    end

end