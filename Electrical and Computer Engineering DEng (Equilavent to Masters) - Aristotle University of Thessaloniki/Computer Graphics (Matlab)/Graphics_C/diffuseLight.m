% Mourouzi Christos
% AEM: 7571

% This function computes diffusion lighting.

function I = diffuseLight(P,N,kd,S,I0)

	% Initialize.

	[~,l] = size(S);
	N = N / norm(N); 
	I = 0;

	% Do this for every single source.

	for i=1:l

		L = S(:,i) - P;
		L = L / norm(L);
		I = I + I0(:,i).* kd * dot(N,L);

end
