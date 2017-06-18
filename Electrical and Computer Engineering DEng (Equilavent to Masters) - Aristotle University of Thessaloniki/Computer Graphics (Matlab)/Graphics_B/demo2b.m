%Mourouzi Christos
%AEM:7571

function demo2b()

[p,f]=readplg('stanford_bunny.plg'); %read bunny

figure(2); title('original bunny'); 
plotplg(p,f); %show original bunny
figure(1); plotplg(p,f); 

p(4,:)=1; %omogeneis syntetagmenes ston pinaka p.
 
 % Metatopisi simeiwn kata t
    
	t = [ 3; -2; 4;  ];
    L = eye( 3 ); %L=monadiaios 3x3
    
    p = pointtrans( L, t, p );
    
    figure(3); title('Metatopisi simeiwn kata [ 3; -2; 4 ]:') 
    plotplg(p,f);
    figure(1); plotplg(p,f); %sto idio systima axonwn
    
    % Metasximatismos vasis kata K
    
	K = [ 2; -1; 2; ];
    L = eye( 3 ); %L=monadiaios 3x3
    
    p = systemtrans( L, K, p );
    
    figure(4); title('Allagi vasis kata [ 2; -1; 2 ]:')
	plotplg(p,f);
    figure(1); plotplg(p,f);
    
    % Afou metasximatisame ti vasi, peristrefoume ta simeia gyrw apo to
    % dianysma g me gwnia a=pi/2.
	
    g = [ 2; 5; 3 ];
    g = g / norm( g ); %g=monadiaio dianysma tou g.
    a = pi / 2;
	R = rotmat( g, a );
    c=zeros(3,1);	
    
    % Afou vrikame ton pinaka peristrofis R, xrisimopoioume tin pointtrans
    % gia na vroume tis syntetagmenews twn newn, peristrefomenwn simeiwn. Ws
    % pinakas metasximatismou twra einai o R kai to dianysma c einai ena
    % mideniko dianysma afou den efarmozetai kapoios affine
    % metasximatismos.
	    
	p = pointtrans( R, c, p );
    
    figure(5); title('Peristrofi stin kainouria vasi')
	plotplg(p,f);
    figure(1); plotplg(p,f);
    
    % Afou ginei i peristrofi twn simeiwn epistrefoume stin arxiki vasi
    % xrisimopoiwntas ti synartisi systemtrans xrisimopoiwntas to
    % antistrofo dianysma -K.
		
	p = systemtrans( L, -K, p );
    
    figure(6); title('Peristrofi stin arxiki vasi')
    plotplg(p,f);
    figure(1); plotplg(p,f);
    % Sto telos metatopizoume ta simeia kata t.
	
    t = [ -3; 2; -4; ];
    L = eye( 3 );
    
    p = pointtrans( L, t, p );
    
    figure(7); title('Metatopisi simeiwn kata [ -3; 2; -4 ]:')
    plotplg(p,f); 
    figure(1); title('total'); plotplg(p,f); 
    
end

