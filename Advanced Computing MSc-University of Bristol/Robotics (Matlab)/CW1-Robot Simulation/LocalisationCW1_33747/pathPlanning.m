function [botSim, estimated_bot] =  pathPlanning(botSim, estimated_bot,target,map)
%% This function returns botSim and estimated_bot and accepts botSim, estimated
% bot, a target and a map. First it inflates the borders of the map in
% order walls collisions to be avoided and then plans a path for the bot.
% If the bot is lost then it relocalizes its position until it manages to
% reach the target.

%% Get the initial parameters for the path plan
estimated_pos=estimated_bot.getBotPos(); %start position is the estimated position
inflated=inflate_map(3, map); %inflate the borders of the map to avoid collisions

location_threshold=0.005; %check if you are very close to the target

%% Path plan and get to the target
while estimated_pos(1) > target(1) + location_threshold || estimated_pos(1) < target(1) - location_threshold || estimated_pos(2) > target(2) + location_threshold|| estimated_pos(2) < target(2) - location_threshold
    
    % Find the coordinates of the path. Used already implemented function pathfinder.m due to bad (not working) implementation of mine
    % reference = https://uk.mathworks.com/matlabcentral/fileexchange/37656-pathfinder-v2
     
    path_coords = pathfinder(estimated_pos, target, inflated); %plan the path to the destination
    
    for i=1:size(path_coords,1)-1
        
        x1y1=path_coords(i,:); %go to the target step by step
        x2y2=path_coords(i+1,:);
    
        angle =(atan2d(x2y2(2)-x1y1(2),x2y2(1)-x1y1(1))+180)*pi/180; %find the angle between the two points, atan2 returns the angle in radians between [-pi,pi]
    
        move_distance= distance(x1y1,x2y2); %find the distance between two points
    
        botSim.turn(pi-estimated_bot.getBotAng()+angle); %turn the real bot to the point
        estimated_bot.turn(pi-estimated_bot.getBotAng()+angle); %turn the estimated bot to the point 
    
        botScan=botSim.ultraScan(); %make a scan to check if you are facing a wall
        
        if botScan(1)<move_distance %if there is a wall in front of you relocalise!
            disp('Lost! Wall in front! Relocalise');
            [botSim, estimated_bot] = particle_filter(botSim,map,target);
            estimated_pos=estimated_bot.getBotPos();  
            break; %replan your path with the new estimated position
        else
           if botSim.debug()                
                hold off; %the drawMap() function will clear the drawing when hold is off        
                botSim.drawMap(); %drawMap() turns hold back on again, so you can draw the bots
                botSim.drawBot(30,'g'); %draw robot with line length 30 and green
                estimated_bot.drawMap(); %drawMap() turns hold back on again, so you can draw the bots
                estimated_bot.drawBot(30,'k'); %draw robot with line length 30 and green
                plot(target(1),target(2),'*');
                inflated_plot=inflated;
                inflated_plot(size(inflated,1)+1,:)=inflated(1,:) ;   
                plot(inflated_plot(:,1), inflated_plot(:,2), 'Color', 'magenta');
                plot(path_coords(:,1), path_coords(:,2),'-ko', 'Color', 'blue');   
                disp('Press any key to move');
                pause; 
           end            
            botSim.move(move_distance); %if everything is ok move to the next point
            estimated_bot.move(move_distance); 
            estimated_pos=estimated_bot.getBotPos(); %get the estimated position to check if you reached the target   
        end
    end
end  
%% Drawing
if botSim.debug()
    hold off; %the drawMap() function will clear the drawing when hold is off        
    botSim.drawMap(); %drawMap() turns hold back on again, so you can draw the bots
    botSim.drawBot(30,'g'); %draw robot with line length 30 and green
    estimated_bot.drawMap(); %drawMap() turns hold back on again, so you can draw the bots
    estimated_bot.drawBot(30,'k'); %draw robot with line length 30 and green
    plot(target(1),target(2),'*');
    inflated_plot=inflated;
    inflated_plot(size(inflated,1)+1,:)=inflated(1,:) ;   
    plot(inflated_plot(:,1), inflated_plot(:,2), 'Color', 'magenta');
    plot(path_coords(:,1), path_coords(:,2), '-ko', 'Color', 'blue');
end

 disp('Arrived at the target!'); %Finally!
end

%% Christos Mourouzi
% Canditate number: 33747
% email: cm16663@my.bristol.ac.uk