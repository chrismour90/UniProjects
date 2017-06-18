% Mourouzi Christos
% AEM: 6978

% Auti i synartisi einai ypeuthyni gia tin plirwsi olwn twn trigwnwn tis
% ergasias se syndyasmo me tin Tripaint. Vriskoume ton arithmo twn trigwnwn
% kai trexoume tin Tripaint oses fores xreiazetai gia na paroume ti swsti
% plirwsi.

function Y = Painter(Q,T,CV,M,N)

	canvas = ones(M,N,3);

	trianglesnumber = size(Q,1); % arithmos trigwnwn

	% Edw ginetai i pliris plirwsi olwn twn trigwnwn.
	
	for j = 1:trianglesnumber
		
		vertices = [Q(1,j) Q(2,j) Q(3,j)]; %grammi pinaka Q
		
		V = [T(1,vertices(1)) T(1,vertices(2)) T(1,vertices(3)); T(2,vertices(1)) T(2,vertices(2)) T(2,vertices(3))];
		
		C = [CV(1,vertices(1)) CV(1,vertices(2)) CV(1,vertices(3)); CV(2,vertices(1)) CV(2,vertices(2)) CV(2,vertices(3)); CV(3,vertices(1)) CV(3,vertices(2)) CV(3,vertices(3))];
		
		% Allazoume tis y syntetagmenes giati i matlab metraei apo panw
		% pros ta katw.
		
		V(2,:) = M - V(2,:);
		
		% Kaloume tin Tripaint gia kathe trigwno.
		
		L = Tripaint(V,C);
		
		% Zwgrafizoume to kavma vasi twn apotelesmatwn tou Tripaint
		
		for i = 2:size(L,1)
		
			canvas(L(i,2),L(i,1),1) = L(i,3);
			canvas(L(i,2),L(i,1),2) = L(i,4);
			canvas(L(i,2),L(i,1),3) = L(i,5);
		
		end

	end
	
	Y = canvas;

