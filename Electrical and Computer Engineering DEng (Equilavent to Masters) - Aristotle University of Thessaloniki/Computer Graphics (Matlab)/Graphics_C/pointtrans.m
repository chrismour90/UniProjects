% Mourouzi Christos
% AEM: 7571

function [ d ] = pointtrans( L, c0, c )

% Function pointtrans uses the transformation matrix "L" and the affine point transformation "c0" to produce the coordinates
% of the new point(s) "d". 

    d = zeros( size( c ) );
    
	for i = 1:size( c, 2 )

		d( :, i ) = L * c( :, i ) + c0;

	end

end