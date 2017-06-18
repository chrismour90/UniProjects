% Mourouzi Christos
% AEM: 7571

% This is the function responsible coloring the points of each given
% triangle. 

% We transpose V,C matrices and sort them in accordance with Y. The main concept that is accomplished here is that we want to divide each triangle in two
% smaller triangles, by drawing a line from the middle vertex of the first, big triangle.

function Y = ColorTriangle(V,C)

	L = zeros(1,5);

	V = transpose(V);
	C = transpose(C);
	temp = sortrows([V C],2);

	V = temp(:,1:2);
	C = temp(:,3:5);



	flag = 1;
	
	if V(1,:) == V(2,:) 
		
		newV = [ V(1,:); V(3,:) ];
		newC = [ C(1,:); C(3,:) ];
		flag = 0;

	end

	if V(1,:) == V(3,:)

		newV = [ V(1,:); V(2,:) ];
		newC = [ C(1,:); C(2,:) ];
		flag = 0;

	end

	if V(2,:) == V(3,:)
		
		newV = [ V(1,:); V(3,:) ] ;
		newC = [ C(1,:); C(3,:) ];
		flag = 0;

	end

	if flag == 0 
		
		x1 = newV(1,1);
		x2 = newV(2,1);
		y1 = newV(1,2);
		y2 = newV(2,2);
    
    for i = y1:y2
        
        if (y2 - y1) == 0
           
		   x = x1;
			
        else
			
			x = x1 + (i - y1) * (x2 - x1) / (y2 - y1);
			
        end
        
        firstdist = sqrt( (x1 - x)^2 + (y1 - i)^2 ) / sqrt( (x1 - x2)^2 + (y1 - y2)^2 );
        seconddist = sqrt( (x2 - x)^2 + (y2 - i)^2 ) / sqrt( (x1 - x2)^2 + (y1 - y2)^2 );              
        x = round(x);
        vector = newC(2,:) * firstdist + newC(1,:) * seconddist;
        L = [ L; x i vector(1) vector(2) vector(3) ];
        
    end
	
Y = L;

return

end

	% This for loop is used to find, using the interpolation method, the colors that are suitable for each single point inside the triangle.
	% First we scan the "upper" part of the triangle by scanning the y-axis	and x-axis as well and then we fill its points (of the "upper"
	% triangle).

	for stepy = V(2,2):V(3,2)

		% The interpolation method used for the first two of the three points of the triangle. 
		
		x1 = V(1,1) + ( stepy - V(1,2) ) * ( V(3,1) - V(1,1) ) / ( V(3,2) - V(1,2) );
		
		if V(3,2) - V(1,2) == 0
			
			x1 = V(1,1);
		
		end
		
		% The interpolation method used for the other two points of the triangle.
		
		x2 = V(2,1) + ( stepy - V(2,2) ) * ( V(3,1) - V(2,1) ) / ( V(3,2) - V(2,2) );
		
		if V(2,2) - V(3,2) == 0
			
			x2 = V(2,1);

		end
		
        x1 = round(x1);
        x2 = round(x2);
    
		% These are the weights regarding the participation of each color in the filling of the points inside the triangle. We assign two weights
		% for each point. W1 and w2 are for the first point and w3 and w4 are for the second point.
		
		w1 = sqrt( ( x1 - V(1,1) )^2 + ( stepy - V(1,2) )^2 ) / sqrt( ( V(1,1) - V(3,1) )^2 + ( V(1,2) - V(3,2) )^2 );
		w2 = sqrt( ( x1 - V(3,1) )^2 + ( stepy - V(3,2) )^2 ) / sqrt( ( V(1,1) - V(3,1) )^2 + ( V(1,2) - V(3,2) )^2 );  
		w3 = sqrt( ( x2 - V(3,1) )^2 + ( stepy - V(3,2) )^2 ) / sqrt( ( V(3,1) - V(2,1) )^2 + ( V(3,2) - V(2,2) )^2 );
		w4 = sqrt( ( x2 - V(2,1) )^2 + ( stepy - V(2,2) )^2 ) / sqrt( ( V(3,1) - V(2,1) )^2 + ( V(3,2) - V(2,2) )^2 );
		
		colorsy1 = zeros(3,1);
		colorsy2 = zeros(3,1);

    
		% Three basic colors for the first point.
		
		colorsy1(1) = C(1,1) * w2 + C(3,1) * w1;   
		colorsy1(2) = C(1,2) * w2 + C(3,2) * w1;
		colorsy1(3) = C(1,3) * w2 + C(3,3) * w1;
		
		% We add the colors of the first point, including its coordinates, in the L matrix.
		
		L = [ L; x1 stepy colorsy1(1) colorsy1(2) colorsy1(3) ];
   
		% Three basic colors for the second point.
		
		colorsy2(1) = C(2,1) * w3 + C(3,1) * w4;
		colorsy2(2) = C(2,2) * w3 + C(3,2) * w4;
		colorsy2(3) = C(2,3) * w3 + C(3,3) * w4;
		
		% We add the colors of the second point, including its coordinates, in the L matrix.
		
		L = [ L; x2 stepy colorsy2(1) colorsy2(2) colorsy2(3) ];
		
		% Since we have determined the interpolated colors that are upon the sides of the triangle, we are able now to determine the colors of 
		% the points that lie inside the triangle as well. We now take all the pairs of points that lie on the sides and define a segment.
		% By doing that, we can now find the colors of each point of these segments, using the interpolation method.
		
		if x2 > x1
			
			for stepx = x1:x2
			
				if x1 == x2
				
					break;
				
				end
				
				colorsx1 = zeros(3,1);
				
				% Three basic colors for the first point.
			
				colorsx1(1) = ( ( stepx - x1 ) / ( x2 - x1 ) ) * colorsy2(1) + ( ( x2 - stepx ) / ( x2 - x1 ) ) * colorsy1(1);
				colorsx1(2) = ( ( stepx - x1 ) / ( x2 - x1 ) ) * colorsy2(2) + ( ( x2 - stepx ) / ( x2 - x1 ) ) * colorsy1(2);
				colorsx1(3) = ( ( stepx - x1 ) / ( x2 - x1 ) ) * colorsy2(3) + ( ( x2 - stepx ) / ( x2 - x1 ) ) * colorsy1(3);
				
				% We add the colors of the first point, including its coordinates, in the L matrix.
			
				L = [ L; stepx stepy colorsx1(1) colorsx1(2) colorsx1(3) ];
			
			end
			
		else
			
			for stepx = x2:x1
			
				if x1 == x2
				
					break;
				
				end
				
				colorsx2 = zeros(3,1);
				
				% Three basic colors for the second point.
			
				colorsx2(1) = ( ( stepx - x1 ) / ( x2 - x1 ) ) * colorsy2(1) + ( ( x2 - stepx ) / ( x2 - x1 ) ) * colorsy1(1);
				colorsx2(2) = ( ( stepx - x1 ) / ( x2 - x1 ) ) * colorsy2(2) + ( ( x2 - stepx ) / ( x2 - x1 ) ) * colorsy1(2);
				colorsx2(3) = ( ( stepx - x1 ) / ( x2 - x1 ) ) * colorsy2(3) + ( ( x2 - stepx ) / ( x2 - x1 ) ) * colorsy1(3);
				
				% We add the colors of the second point, including its coordinates, in the L matrix.
			
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

	% This for loop is used to find, using the interpolation method, the colors that are suitable for each single point inside the triangle.
	% First we scan the "nether" part of the triangle by scanning the y-axis and x-axis as well and then we fill its points (of the "nether"
	% triangle).

	for stepy = V(1,2):V(2,2)  
	
		% The interpolation method used for the first two of the three
		% points of the triangle. 
		
		x1 = V(1,1) + ( stepy - V(1,2) ) * ( V(3,1) - V(1,1) ) / ( V(3,2) - V(1,2) );
		
		if V(3,2) - V(1,2) == 0
			
			x1 = V(1,1);
		
		end
		
		% The interpolation method used for the other two of the three
		% points of the triangle. 
		
		x2 = V(1,1) + ( stepy - V(1,2) ) * ( V(2,1) - V(1,1) ) / ( V(2,2) - V(1,2) );   
		
		if V(2,2)-V(1,2) == 0
		
			x2 = V(1,1);
		
		end
		   
		x1 = round(x1);
		x2 = round(x2);
		
		% These are the weights regarding the participation of each color in the filling of the points inside the triangle. We assign two weights
		% for each point. W1 and w2 are for the first point and w3 and w4 are for the second point.	
		
		w1 = sqrt( ( x1 - V(1,1) )^2 + ( stepy - V(1,2) )^2 ) / sqrt( ( V(1,1) - V(3,1) )^2 + ( V(1,2) - V(3,2) )^2 );
		w2 = sqrt( ( x1 - V(3,1) )^2 + ( stepy - V(3,2) )^2 ) / sqrt( ( V(1,1) - V(3,1) )^2 + ( V(1,2) - V(3,2) )^2 );
		w3 = sqrt( ( x2 - V(1,1) )^2 + ( stepy - V(1,2) )^2 ) / sqrt( ( V(2,1) - V(1,1) )^2 + ( V(2,2) - V(1,2) )^2 );
		w4 = sqrt( ( x2 - V(2,1) )^2 + ( stepy - V(2,2) )^2 ) / sqrt( ( V(2,1) - V(1,1) )^2 + ( V(2,2) - V(1,2) )^2 );
		
		colorsy1 = zeros(3, 1);
		colorsy2 = zeros(3, 1);
		
		% Three basic colors for the first point.
		
		colorsy1(1) = C(1,1) * w2 + C(3,1) * w1;
		colorsy1(2) = C(1,2) * w2 + C(3,2) * w1;
		colorsy1(3) = C(1,3) * w2 + C(3,3) * w1;
		
		% We add the colors of the first point, including its coordinates,
		% in the L matrix.
		
		L = [ L; x1 stepy colorsy1(1) colorsy1(2) colorsy1(3) ];
		
		% Three basic colors for the second point.
		
		colorsy2(1) = C(2,1) * w3 + C(1,1) * w4;
		colorsy2(2) = C(2,2) * w3 + C(1,2) * w4;
		colorsy2(3) = C(2,3) * w3 + C(1,3) * w4;
		
		% We add the colors of the second point, including its coordinates,
		% in the L matrix.
		
		L = [ L; x2 stepy colorsy2(1) colorsy2(2) colorsy2(3) ];
		
		% Since we have determined the interpolated colors that are upon the sides of the triangle, we are able now to determine the colors of 
		% the points that lie inside the triangle as well. We now take all the pairs of points that lie on the sides and define a segment.
		% By doing that, we can now find the colors of each point of these segments, using the interpolation method.
		
		if x2 > x1
		
			for stepx = x1:x2
			
				if x1 == x2 
					break;
				end
				
				colorsx1 = zeros(3,1);
				
				% Three basic colors for the first point.
			
				colorsx1(1) = ( ( stepx - x1 ) / ( x2 - x1 ) ) * colorsy2(1) + ( ( x2 - stepx ) / ( x2 - x1 ) ) * colorsy1(1);
				colorsx1(2) = ( ( stepx - x1 ) / ( x2 - x1 ) ) * colorsy2(2) + ( ( x2 - stepx ) / ( x2 - x1 ) ) * colorsy1(2);
				colorsx1(3) = ( ( stepx - x1 ) / ( x2 - x1 ) ) * colorsy2(3) + ( ( x2 - stepx ) / ( x2 - x1 ) ) * colorsy1(3);
				
				% We add the colors of the first point, including its coordinates, in the L matrix.
			
				L = [ L; stepx stepy colorsx1(1) colorsx1(2) colorsx1(3) ];
			
			end
			
		else
		
			for stepx = x2:x1
		
				if x1 == x2
					break;
				end
					
				colorsx2 = zeros(3,1);
				
				% Three basic colors for the second point.
			
				colorsx2(1) = ( ( stepx - x1 ) / ( x2 - x1 ) ) * colorsy2(1) + ( ( x2 - stepx ) / ( x2 - x1 ) ) * colorsy1(1);
				colorsx2(2) = ( ( stepx - x1 ) / ( x2 - x1 ) ) * colorsy2(2) + ( ( x2 - stepx ) / ( x2 - x1 ) ) * colorsy1(2);
				colorsx2(3) = ( ( stepx - x1 ) / ( x2 - x1 ) ) * colorsy2(3) + ( ( x2 - stepx ) / ( x2 - x1 ) ) * colorsy1(3);
				
				% We add the colors of the second point, including its coordinates, in the L matrix.
				
				L = [ L; stepx stepy colorsx2(1) colorsx2(2) colorsx2(3) ];
			
			end 
		
		end    

	end


Y = L; 