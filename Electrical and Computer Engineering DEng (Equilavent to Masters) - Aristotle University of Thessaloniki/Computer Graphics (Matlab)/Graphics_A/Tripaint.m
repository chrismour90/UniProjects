% Mourouzi Christos
% AEM: 6978

% Auti i synartisi einai ypeuthyni gia to zwgrafisma twn simeiwn kathe
% trigwnou.

function Y =Tripaint(V,C)

	L = zeros(1,5);

	V = transpose(V);
	C = transpose(C);
	temp = sortrows([V C],2);

	V = temp(:,1:2);
	C = temp(:,3:5);

    % To parakatw loop vriskei me ti methodo tis paremvolis ta katallila
    % xrwmata gia kathe simeio mesa sto trigwno. Kanoume scan to "panw" meros
    % tou trigwnou kanontas scan ston axona y kai x.

    for stepy = V(2,2):V(3,2)

        % Methodos paremvolis gia ta 2 simeia apo ta 3 tou trigwnou. Xeroume
        % to y kai vriskoume to x gia to simeio pou vrisketai sti prwti
        % pleura tou trigwnou.
						
		x1 = V(1,1) + ( stepy - V(1,2) ) * ( V(3,1) - V(1,1) ) / ( V(3,2) - V(1,2) );
		
		if V(3,2) - V(1,2) == 0
			
			x1 = V(1,1);
		
		end
		
		% Methodos paremvolis gia ta alla 2 simeia tou trigwnou kai
        % vriskoume to x gia to simeio pou vrisketai sti deuteri pleura tou
        % trigwnou.
		
		x2 = V(2,1) + ( stepy - V(2,2) ) * ( V(3,1) - V(2,1) ) / ( V(3,2) - V(2,2) );
		
		if V(2,2) - V(3,2) == 0
			
			x2 = V(2,1);

		end
		
		x1 = floor(x1); % stroggylopoiisi x1
		x2 = floor(x2); % stroggylopoiisi x2
		
        % Edw vriskoume ta "vari" sxetika me ti symmetoxi kathe simeiou
        % stin plirwsi twn simeiwn mesa sto trigwno. 2 "vari" gia kathe
        % simeio sxetika me tin apostasi tou prwtou simeiou apo ta akra
        % tou antistoixa. Kanoume to idio kai gia to deutero simeio.
				
		w1 = sqrt( ( x1 - V(1,1) )^2 + ( stepy - V(1,2) )^2 ) / sqrt( ( V(1,1) - V(3,1) )^2 + ( V(1,2) - V(3,2) )^2 );
		w2 = sqrt( ( x1 - V(3,1) )^2 + ( stepy - V(3,2) )^2 ) / sqrt( ( V(1,1) - V(3,1) )^2 + ( V(1,2) - V(3,2) )^2 );  
		w3 = sqrt( ( x2 - V(3,1) )^2 + ( stepy - V(3,2) )^2 ) / sqrt( ( V(3,1) - V(2,1) )^2 + ( V(3,2) - V(2,2) )^2 );
		w4 = sqrt( ( x2 - V(2,1) )^2 + ( stepy - V(2,2) )^2 ) / sqrt( ( V(3,1) - V(2,1) )^2 + ( V(3,2) - V(2,2) )^2 );
		
		colorsy1 = zeros(3,1);
		colorsy2 = zeros(3,1);
		
        % Orismos triwn vasikwn xrwmatwn gia to prwto simeio.
				
		colorsy1(1) = C(1,1) * w2 + C(3,1) * w1;   
		colorsy1(2) = C(1,2) * w2 + C(3,2) * w1;
		colorsy1(3) = C(1,3) * w2 + C(3,3) * w1;
		
		% To kataxwroume mazi me tis syntetagmenes tou ston pinaka L.
		
		L = [ L; x1 stepy colorsy1(1) colorsy1(2) colorsy1(3) ];
		
		% Orismos triwn vasikwn xrwmatwn gia to deutero simeio.
		
		colorsy2(1) = C(2,1) * w3 + C(3,1) * w4;
		colorsy2(2) = C(2,2) * w3 + C(3,2) * w4;
		colorsy2(3) = C(2,3) * w3 + C(3,3) * w4;
		
		% To kataxwroume mazi me tis syntetagmenes tou ston pinaka L.
		
		L = [ L; x2 stepy colorsy2(1) colorsy2(2) colorsy2(3) ];
		
        % Afou kathorisame ta xrwmata stis pleures tou trigwnou,
        % kathorizoume ta xrwmata twn simeiwn pou einai mesa sto trigwno.
				
		if x2 > x1
			
			for stepx = x1:x2
			
				if x1 == x2
				
					break;
				
				end
				
				colorsx1 = zeros(3,1);
				
				% Orismos triwn vasikwn xrwmatwn gia to prwto simeio.
			
				colorsx1(1) = ( ( stepx - x1 ) / ( x2 - x1 ) ) * colorsy2(1) + ( ( x2 - stepx ) / ( x2 - x1 ) ) * colorsy1(1);
				colorsx1(2) = ( ( stepx - x1 ) / ( x2 - x1 ) ) * colorsy2(2) + ( ( x2 - stepx ) / ( x2 - x1 ) ) * colorsy1(2);
				colorsx1(3) = ( ( stepx - x1 ) / ( x2 - x1 ) ) * colorsy2(3) + ( ( x2 - stepx ) / ( x2 - x1 ) ) * colorsy1(3);
				
				% To kataxwroume mazi me tis syntetagmenes tou ston pinaka
				% L.
			
				L = [ L; stepx stepy colorsx1(1) colorsx1(2) colorsx1(3) ];
			
			end
			
		else
			
			for stepx = x2:x1
			
				if x1 == x2
				
					break;
				
				end
				
				colorsx2 = zeros(3,1);
				
				% Orismos triwn vasikwn xrwmatwn gia to deutero simeio.
			
				colorsx2(1) = ( ( stepx - x1 ) / ( x2 - x1 ) ) * colorsy2(1) + ( ( x2 - stepx ) / ( x2 - x1 ) ) * colorsy1(1);
				colorsx2(2) = ( ( stepx - x1 ) / ( x2 - x1 ) ) * colorsy2(2) + ( ( x2 - stepx ) / ( x2 - x1 ) ) * colorsy1(2);
				colorsx2(3) = ( ( stepx - x1 ) / ( x2 - x1 ) ) * colorsy2(3) + ( ( x2 - stepx ) / ( x2 - x1 ) ) * colorsy1(3);
				
				% To kataxwroume mazi me tis syntetagmenes tou ston pinaka
				% L.
			
				L = [ L; stepx stepy colorsx2(1) colorsx2(2) colorsx2(3) ];
			
			end           
		
		end
		
	end

	clear x1
	clear x2
	clear w1
	clear w2
	clear w3
	clear w4
	clear colorsy1
	clear colorsy2
	clear colorsx1
	clear colorsx2
	clear stepy
	clear stepx


	% To idio loop me prin pou vriskei me ti methodo tis paremvolis ta katallila
    % xrwmata gia kathe simeio mesa sto trigwno alla scannarwntas to "katw" meros
    % tou trigwnou kanontas scan ston axona y kai x.


	for stepy = V(1,2):V(2,2)  
	
		% Methodos paremvolis gia ta 2 simeia apo ta 3 tou trigwnou. Xeroume
        % to y kai vriskoume to x gia to simeio pou vrisketai sti prwti
        % pleura tou trigwnou.
		
		x1 = V(1,1) + ( stepy - V(1,2) ) * ( V(3,1) - V(1,1) ) / ( V(3,2) - V(1,2) );
		
		if V(3,2) - V(1,2) == 0
			
			x1 = V(1,1);
		
        end
		
        % Methodos paremvolis gia ta alla 2 simeia tou trigwnou kai
        % vriskoume to x gia to simeio pou vrisketai sti deuteri pleura tou
        % trigwnou.
				
		x2 = V(1,1) + ( stepy - V(1,2) ) * ( V(2,1) - V(1,1) ) / ( V(2,2) - V(1,2) );   
		
		if V(2,2)-V(1,2) == 0
		
			x2 = V(1,1);
		
		end
		   
		x1 = floor(x1);
		x2 = floor(x2);
		
		% Edw vriskoume ta "vari" sxetika me ti symmetoxi kathe simeiou
        % stin plirwsi twn simeiwn mesa sto trigwno. 2 "vari" gia kathe
        % simeio sxetika me tin apostasi tou prwtou simeiou apo ta akra
        % tou antistoixa. Kanoume to idio kai gia to deutero simeio.
		
		w1 = sqrt( ( x1 - V(1,1) )^2 + ( stepy - V(1,2) )^2 ) / sqrt( ( V(1,1) - V(3,1) )^2 + ( V(1,2) - V(3,2) )^2 );
		w2 = sqrt( ( x1 - V(3,1) )^2 + ( stepy - V(3,2) )^2 ) / sqrt( ( V(1,1) - V(3,1) )^2 + ( V(1,2) - V(3,2) )^2 );
		w3 = sqrt( ( x2 - V(1,1) )^2 + ( stepy - V(1,2) )^2 ) / sqrt( ( V(2,1) - V(1,1) )^2 + ( V(2,2) - V(1,2) )^2 );
		w4 = sqrt( ( x2 - V(2,1) )^2 + ( stepy - V(2,2) )^2 ) / sqrt( ( V(2,1) - V(1,1) )^2 + ( V(2,2) - V(1,2) )^2 );
		
		colorsy1 = zeros(3, 1);
		colorsy2 = zeros(3, 1);
		
		% Orismos triwn vasikwn xrwmatwn gia to prwto simeio.
		
		colorsy1(1) = C(1,1) * w2 + C(3,1) * w1;
		colorsy1(2) = C(1,2) * w2 + C(3,2) * w1;
		colorsy1(3) = C(1,3) * w2 + C(3,3) * w1;
		
		% To kataxwroume mazi me tis syntetagmenes tou ston pinaka L.
		
		L = [ L; x1 stepy colorsy1(1) colorsy1(2) colorsy1(3) ];
		
		% Orismos triwn vasikwn xrwmatwn gia to deutero simeio.
		
		colorsy2(1) = C(2,1) * w3 + C(1,1) * w4;
		colorsy2(2) = C(2,2) * w3 + C(1,2) * w4;
		colorsy2(3) = C(2,3) * w3 + C(1,3) * w4;
		
		% To kataxwroume mazi me tis syntetagmenes tou ston pinaka L.
		
		L = [ L; x2 stepy colorsy2(1) colorsy2(2) colorsy2(3) ];
		
        % Afou kathorisame ta xrwmata stis pleures tou trigwnou,
        % kathorizoume ta xrwmata twn simeiwn pou einai mesa sto trigwno.
		
		if x2 > x1
		
			for stepx = x1:x2
			
				if x1 == x2 
					break;
				end
				
				colorsx1 = zeros(3,1);
				
				% Orismos triwn vasikwn xrwmatwn gia to prwto simeio.
			
				colorsx1(1) = ( ( stepx - x1 ) / ( x2 - x1 ) ) * colorsy2(1) + ( ( x2 - stepx ) / ( x2 - x1 ) ) * colorsy1(1);
				colorsx1(2) = ( ( stepx - x1 ) / ( x2 - x1 ) ) * colorsy2(2) + ( ( x2 - stepx ) / ( x2 - x1 ) ) * colorsy1(2);
				colorsx1(3) = ( ( stepx - x1 ) / ( x2 - x1 ) ) * colorsy2(3) + ( ( x2 - stepx ) / ( x2 - x1 ) ) * colorsy1(3);
				
				% To kataxwroume mazi me tis syntetagmenes tou ston pinaka
				% L.
			
				L = [ L; stepx stepy colorsx1(1) colorsx1(2) colorsx1(3) ];
			
			end
			
		else
		
			for stepx = x2:x1
		
				if x1 == x2
					break;
				end
					
				colorsx2 = zeros(3,1);
				
				% Orismos triwn vasikwn xrwmatwn gia to deutero simeio.
			
				colorsx2(1) = ( ( stepx - x1 ) / ( x2 - x1 ) ) * colorsy2(1) + ( ( x2 - stepx ) / ( x2 - x1 ) ) * colorsy1(1);
				colorsx2(2) = ( ( stepx - x1 ) / ( x2 - x1 ) ) * colorsy2(2) + ( ( x2 - stepx ) / ( x2 - x1 ) ) * colorsy1(2);
				colorsx2(3) = ( ( stepx - x1 ) / ( x2 - x1 ) ) * colorsy2(3) + ( ( x2 - stepx ) / ( x2 - x1 ) ) * colorsy1(3);
				
				% To kataxwroume mazi me tis syntetagmenes tou ston pinaka
				% L.
				
				L = [ L; stepx stepy colorsx2(1) colorsx2(2) colorsx2(3) ];
			
			end 
		
		end    

	end

Y = L;