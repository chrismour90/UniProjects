% Mourouzi Christos
% AEM: 7571

function d = systemtrans( L, c0, c )

% Function systemtrans transforms the base of the points.
	
    d = zeros( size( c ) );
   
    for i = 1:size(c,2)

        d( :, i ) = L \ (c( :, i ) - c0);
		
    end
	
end