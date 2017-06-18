% Mourouzi Christos
% AEM: 7571

function im = PhongPhoto(w, cv, cK, cu, bC, M, N, H, W, r, F, S, ka, kd, ks, ncoeff, Ia, I0,C)

	Normals = VertNormals(r,F);
	T = r;
	Q = F;

	j = 1;

	for i=1:length(Q)
		
		p1 = T(:,Q(i,1));
		p2 = T(:,Q(i,2));
		p3 = T(:,Q(i,3));

		n = cross(p2 - p1,p3 - p1);
		V = cv - ( p1 + p2 + p3 ) / 3;
		if dot(n,V) > 0
		
		q(j,:) = [ Q(i,:) dot(p1 + p2 + p3,cv) ka(i,:) kd(i,:) ks(i,:) ];
			j = j + 1;
		
		end

	end


	q = sortrows(q,4);
	Q = q(:,1:3);
	ka = q(:, 5:7);
	kd = q(:, 8:10);
	ks = q(:, 11:13);

	clear q;

	% Project to two dimensions.

	Projected_T = projCameraKu(w,cv,cK,cu,T);

	% Converting to pixels.

	Projected_T = [ Projected_T(1,:) * M / H; Projected_T(2,:) * N / W ];

	% Bringing the center of the image. (I2x2 * Projected_T + [ M/2 N/2]'

	Projected_T = pointtrans(eye(2),[ M / 2 N / 2 ]',Projected_T);
	Projected_T = Projected_T';

	% Making discrete.

	Projected_T = round(Projected_T);

	Projected_T = Projected_T';
	Q = Q';
	Normals = Normals';

	ks = ks';
	kd = kd';
	ka = ka';

	canvas = ColorShape(Q,Projected_T,Normals,M,N,ks,kd,ka,bC,r,Ia,S,I0,ncoeff,cv);

	im = canvas;

end