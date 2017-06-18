%Mourouzi Christos
%AEM:7571

function [ R ] = rotmat( u, a )

% I synartisi rotmat is ypologizei ton pinaka peristrofis R.

    ux = u( 1 );
    uy = u( 2 );
    uz = u( 3 );
    ca = cos( a );
    ca2 = 1 - cos( a );
    sa = sin( a );
	
	% Pinakas R opws orizetai stis simeiwseis tou mathimatos.
	
    R = [ ca2 * ux * ux + ca, ca2 * ux * uy - sa * uz, ca2 * ux * uz + sa * uy;
          ca2 * uy * ux + sa * uz, ca2 * uy * uy + ca, ca2 * uy * uz - sa * ux;
          ca2 * uz * ux - sa * uy, ca2 * uz * uy + sa * ux, ca2 * uz * uz + ca ];

end