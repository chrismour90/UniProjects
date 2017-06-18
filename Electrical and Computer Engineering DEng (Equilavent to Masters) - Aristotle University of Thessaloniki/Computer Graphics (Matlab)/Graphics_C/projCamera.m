% Mourouzi Christos
% AEM: 7571

function P = projCamera(w, cv, cx, cy, p)

	% Rotation matrix is simply formed.

	cz = cross(cx,cy);
	cx;
	r = [cx cy cz];

	% Change all p points coordinates.
	% Rotate basis by r.
	% Then, move by cv.

	p = systemtrans (r,cv,p);

	% For each point, apply the same transformation discribed as above.

	P = [ w*p(1,:) ./ p(3,:) ; w * p(2,:) ./ p(3,:) ];