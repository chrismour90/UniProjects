%Mourouzi Christos
%AEM:7571

function demo2a()
    
	% Arxikopoiisi twn syntetagmenwn gia ta dianysmata p1, p2, p3, p4
	
    p1 = [ 2; -3; 5; 1];
    p2 = [ 1; 2; 0;  1];
    p3 = [ 1; 1; 0;  1];
	p4 = [ 0; 1; -5; 1];
    disp( 'Ta simeia se omogeneis syntetagmenes:' );
    p = [ p1 p2 p3 p4 ]

    % Metatopisi simeiwn kata t
    
	disp( 'Metatopisi simeiwn kata [ 3; -2; 4 ]:' );
    t = [ 3; -2; 4 ];
    L = eye( 3 ); %L=monadiaios 3x3
    
    p = pointtrans( L, t, p )

    % Metasximatismos vasis kata K
    
	K = [ 2; -1; 2 ];
    L = eye( 3 ); %L=monadiaios 3x3
    
    p = systemtrans( L, K, p );
	
    % Afou metasximatisame ti vasi, peristrefoume ta simeia gyrw apo to
    % dianysma g me gwnia a=pi/2.
	
    g = [ 2; 5; 3 ];
    g = g / norm( g ); %g=monadiaio dianysma tou g.
    a = pi / 2;
	disp( 'Pinakas Peristrofis R:' );
    R = rotmat( g, a )
    c=zeros(3,1);	
    % Afou vrikame ton pinaka peristrofis R, xrisimopoioume tin pointtrans
    % gia na vroume tis syntetagmenews twn newn, peristrefomenwn simeiwn. Ws
    % pinakas metasximatismou twra einai o R kai to dianysma c einai ena
    % mideniko dianysma afou den efarmozetai kapoios affine
    % metasximatismos.
	    
	disp( 'Ta peristrefomena simeia stin kainouria vasi:' );
    p = pointtrans( R, c, p )
	
    % Afou ginei i peristrofi twn simeiwn epistrefoume stin arxiki vasi
    % xrisimopoiwntas ti synartisi systemtrans xrisimopoiwntas to
    % antistrofo dianysma -K.
		
	disp( 'Ta peristrefomena simeia stin arxiki vasi:');
    p = systemtrans( L, -K, p )

    % Sto telos metatopizoume ta simeia kata t.
	
    disp( 'Metatopisi simeiwn kata [ -3, 2, -4 ]:' );
    t = [ -3; 2; -4 ];
    L = eye( 3 );
    
    p = pointtrans( L, t, p )
	
end