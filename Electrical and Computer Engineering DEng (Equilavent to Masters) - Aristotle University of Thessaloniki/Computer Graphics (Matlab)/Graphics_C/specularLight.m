% Mourouzi Christos
% AEM: 7571

function I = specularLight(V,P,N,ks,ncoeff,S,I0) 

	% This function computes spectular lighting.

	% Initialize and compute N and V.

	[~,l] = size(S);
	I = 0;
	N = N / norm(N);
	V = V - P;
	V = V / norm(V);

	% Repeat for every source.

	for i=1:1:l

		L = S(:,i) - P;
		L = L / norm(L);
		a = dot(N,V) - dot(L,N);
		I = I + I0(:,i).* ks * cos(a)^ncoeff;

	end
