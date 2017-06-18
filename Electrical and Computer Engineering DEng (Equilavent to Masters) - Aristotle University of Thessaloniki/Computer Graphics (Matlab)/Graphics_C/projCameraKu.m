% Mourouzi Christos
% AEM: 7571

function P = projCameraKu(w,cv,cK,cu,p)

	% Create cx, cy and cz from ck and cu.

	cz = (cK-cv) / norm(cK - cv);

	t = cu - dot(cu,cz) * cz;
	cy = t / norm(t);

	cx = cross(cy,cz);

	% Call camera to compute projection.
	
	P = projCamera(w,cv,cx,cy,p);