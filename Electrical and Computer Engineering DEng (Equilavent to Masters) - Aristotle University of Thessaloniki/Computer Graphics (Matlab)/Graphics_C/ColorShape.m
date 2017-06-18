% Mourouzi Christos
% AEM: 7571

function Y = ColorShape(Q,T,C1,M,N,ks,kd,ka,bC,r,Ia,S,I0,ncoeff,cv)

	% This function is responsible for filling all the given triangles in the project.
	% First we find the number of triangles and then we "run" the ColorTriangle as many times as necessary, in order to get the proper filling.

	canvas = zeros(N,M,3);

	for i = 1:3
		canvas(:,:,i) = canvas(:,:,i) + bC(i);
	end

	canvas2 = zeros(N,M,3);
	sizeQ = size(Q);
	trianglenumber = sizeQ(2);

	transpose(C1);
	T = round(T);

	% Filling procedure for ALL the triangles. 
	
	for j = 1:trianglenumber    
    
    % Get each triangle's vertices.
    
	vertices = Q(:, j);
        
	V = [ T(1,vertices(1)) T(1,vertices(2)) T(1,vertices(3)); T(2,vertices(1)) T(2,vertices(2)) T(2,vertices(3)) ];
    C = [ C1(1,vertices(1)) C1(1,vertices(2)) C1(1,vertices(3)); C1(2,vertices(1)) C1(2,vertices(2)) C1(2,vertices(3)); C1(3,vertices(1)) C1(3,vertices(2)) C1(3,vertices(3)) ]; 
   
    % Call function with V, C arguments.

    V = round(V);

    P = [ ( r(1,Q(1,j)) + r(1,Q(2,j)) + r(1,Q(3,j)) ) / 3; ( r(2,Q(1,j)) + r(2,Q(2,j)) + r(2,Q(3,j)) ) / 3; ( r(3,Q(1,j)) + r(3,Q(2,j)) + r(3,Q(3,j)) ) / 3; ];
    
    size(r);    
    
    P = P / norm(P);
    
 	% Change the y coordinates because matlab counts from up to down.
	
	V(2,:) = M - V(2,:);
	
	% Call the ColorTriangle for each triangle to do the filling part.
	
    L = ColorTriangle(V,C);
    newL = [];
	
	% Paint the canvas with the colors acquired from L.
	
    for k = 1:size(L,1)
       
        Tl = L(k,3:5);
        Tl = Tl / norm(Tl);
        newL = [ newL; L(k,1) L(k,2) Tl(1) Tl(2) Tl(3) ];
    
	end
 
	L = newL;
 
    sizeL = size(L);   
    
    for i = 1:sizeL(1)
     
        Nvector = L(i,3:5);
 
		if ( isnan(Nvector(1)) || isnan(Nvector(3)) || isnan(Nvector(2)) ) 
           
		   Nvector;
		   
        else   
            
			Iambient = ambientLight(P,ka(:,j),Ia);
            Idiffuse = diffuseLight(P,Nvector,kd(:,j),S,I0);
            Ispecula = specularLight(cv,P,Nvector,ks(:,j),ncoeff,S,I0);

            Clight = Iambient + Idiffuse + Ispecula;
            canvas(L(i,2),L(i,1),:) = Clight;
			
        end
    
	end 
 
 end


% Returning canvas to demo function.
        
Y = canvas;

