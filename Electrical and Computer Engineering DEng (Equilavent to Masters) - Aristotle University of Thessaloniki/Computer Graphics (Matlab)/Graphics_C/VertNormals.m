% Mourouzi Christos
% AEM=7571

function Normals = VertNormals(r,F)

	n = size(r,2);
	k = size(F,1);
	F = F';
	Y = [];

	for i = 1:n
		
		N = 0;
		Ns = 0;

		for j = 1:k
		
		% If a triangle has a common point, take its surface N vector into account.
				
				if ( F(1,j)==i || F(2,j)==i || F(3,j)==i )
				
					lclP = r(:,F(:,j));
					lclN = cross( lclP(:,2) - lclP(:,1),lclP(:,3) - lclP(:,1) );
					lclN = lclN / norm(lclN);
					N = N + lclN;
					Ns = Ns + 1;
				
				end
			
		end
		 
			N = N / Ns;

			N = N / norm(N);

			N = N';
			
			Y = [ Y; N ];
	   
	end

	Normals = Y;