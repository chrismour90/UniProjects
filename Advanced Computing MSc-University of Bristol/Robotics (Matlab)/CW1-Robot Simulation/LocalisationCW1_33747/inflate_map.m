function [ infMap ] = inflate_map( offset_dist, map)
%Inflate the boundaries of the original map to a specific offset

%reference: http://stackoverflow.com/questions/23543212/defining-an-inside-room-point-from-wall-points/23548238#23548238

% Initialise
n = size(map,1); %length of map array
v1 = zeros(n, 2);
v2 = zeros(n, 2);
uv = zeros(n, 2); %unit vectors
edges = zeros(n, 1); 
angle = zeros(n, 1);

% Clockwise or anti-clockwise polygon
for i = 1:n      
    if i == n
        edges(i) = (map(1,1) - map(i,1))*(map(1,2) + map(i,2));
    else
        edges(i) = (map(i+1,1) - map(i,1))*(map(i+1,2) + map(i,2));
    end
end

if sum(edges) > 0 %anti-clockwise
    orienation = -1;
elseif sum(edges) < 0 %clockwise
    orienation = 1;
end

% Angles between neighbour edges
for i = 1:n
    curr = map(i,:); %current point
    if i == 1 %if first point then prev is the end point
        prev = map(n, :);
    else
        prev = map(i-1,:);
    end
    if i == n %if end point next is first point
        next = map(1, :);
    else
        next = map(i+1, :);
    end

    v1(i,:) = next - curr; 
    v2(i,:) = prev - curr;

    uv(i,:) = v1(i,:)/norm(v1(i,:)); %unit vector of v1
    x1 = v1(i,1);
    y1 = v1(i,2);
    x2 = v2(i,1);
    y2 = v2(i,2);
    angle(i) = mod(atan2(x1*y2-x2*y1,x1*x2+y1*y2),2*pi)*180/pi;
end

newAngle = angle./2; %divide angles by 2
newVec = zeros(n, 2);
infMap = zeros(n, 2); %initialize inflated map vertices array
offset = zeros(n, 1); %offset for each vertex

% Find new vertices
for i = 1:n
    if angle(i) <= 180
        offset(i) = orienation*offset_dist/sind(newAngle(i));
        rotation = [cosd(newAngle(i)), sind(newAngle(i)); -sind(newAngle(i)), cosd(newAngle(i))];
        newVec(i,:) = uv(i,:) * rotation * offset(i);
        infMap(i,:) = map(i,:) + newVec(i,:);
    elseif angle(i) > 180 && angle(i) <= 270
        offset(i) = -orienation*offset_dist/sind(newAngle(i)-180);
        rotation = [cosd(newAngle(i)), sind(newAngle(i)); -sind(newAngle(i)), cosd(newAngle(i))];
        newVec(i,:) = uv(i,:) * rotation * offset(i);
        infMap(i,:) = map(i,:) + newVec(i,:);
    elseif angle(i) > 270
        offset(i) = -orienation*offset_dist/sind(newAngle(i)-180);
        rotation = [cosd(newAngle(i)), sind(newAngle(i)); -sind(newAngle(i)), cosd(newAngle(i))];
        newVec(i,:) = uv(i,:) * rotation * offset(i);
        infMap(i,:) = map(i,:) + newVec(i,:);
    end
end
end

%% Christos Mourouzi
% Canditate number: 33747
% email: cm16663@my.bristol.ac.uk

