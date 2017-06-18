function [ botSim, estimated_bot ] = particle_filter(botSim,map,target)
%This function implements the particle filter for the localisation of the
%robot - each step is described below

modifiedMap = map; %you need to do this modification yourself
botSim.setMap(modifiedMap);

scans=30; %number of scans
botSim.setScanConfig(botSim.generateScanConfig(scans)); %set number of scans to the bot class

%Particles noise 
motion_noise = 0.01; 
turn_noise = 0.005; 

%generate some random particles inside the map
num =500; % number of particles
particles(num,1) = BotSim; %how to set up a vector of objects
weights=zeros(num,1); %initialize weights array
norms=zeros(scans,1); %initialize norms array

for i = 1:num
    particles(i) = BotSim(modifiedMap);  %each particle should use the same map as the botSim object
    particles(i).setScanConfig(botSim.generateScanConfig(scans));
    particles(i).randomPose(0); %spawn the particles in random locations
    particles(i).setMotionNoise(motion_noise); %some motion noise to all particles
    particles(i).setTurningNoise(turn_noise); %some turn noise to all particles
end

%% Localisation code
maxNumOfIterations = 30;
n = 0;
%converged =0; %The filter has not converged yet
while(n < maxNumOfIterations) %%particle filter loop
    n = n+1; %increment the current number of iterations
    botScan = botSim.ultraScan(); %get a scan from the real robot.
    
    %% Write code for updating and scoring your particles scans   
    for i=1:num         
        particleScan=particles(i).ultraScan();        
        for j=1:scans 
            norms(j)=norm(botScan-particleScan); %euclidean distance between particle vector and bot vector
            particleScan = circshift(particleScan, -1); %do this for all scans
        end
        
        [min_dis, min_pos]=min(norms); %find minimum distance and its index
        weights(i)= 1/ min_dis;  %the one which is closer gets higher score      
        particle_turn=((min_pos-1)*2*pi)/scans; %calculate best orientation particles(i).getBotAng()+ 
        particles(i).turn(particle_turn); %give each particle the best orientation
    end    
    
    weights =  weights/sum(weights); %normalize
        
    %% Write code for resampling your particles
    % Resampling wheel http://calebmadrigal.com/resampling-wheel-algorithm/
    index=randi([1,num-1]); %random initial index on the resampling wheel
    b=0;
    max_w=max(weights);
    particle_pos=zeros(num,2);
    particle_ang=zeros(num,1);

    %resample
    for i=1:num
        b=b+rand*2*max_w; %random number between 0 and max_w
        while b>weights(index)
            b=b-weights(index); %update b
            index=mod((index+1),num)+1; %if its the last one point to the 1st
            weights(i)=weights(index); %update weights
            particles(i).setBotPos(particles(index).getBotPos()); %set particle position
            particles(i).setBotAng(particles(index).getBotAng()); %set particle angle
        end
    end
    
    for i=1:num
        particle_pos(i,:) = particles(i).getBotPos();
        particle_ang(i) = particles(i).getBotAng();
    end   
    
    %get the estimated position of the bot
    estimated_bot = BotSim(modifiedMap);
    estimated_bot.setScanConfig(estimated_bot.generateScanConfig(scans));
    estimated_bot.setBotPos(mean(particle_pos));
    estimated_bot.setBotAng(mean(particle_ang));
    
    
    %% Write code to check for convergence   
	conv_threshold=2; 
    dev=std(particle_pos); %standard deviation of the positions of the particles
    
    if dev <conv_threshold %if the particles are closed enough then converge
        disp('Particle Filter Converged! Lets find our path to the target');
        break;
    end

    %% Write code to take a percentage of your particles and respawn in randomised locations (important for robustness)	
    percentage=0.01; %percent of the particles to be randomely rellocated
    
    for i=1:percentage*num
       particles(randi(num)).randomPose(0);
    end
    
    %% Write code to decide how to move next
    
    %move randomly for a little
    if rand >0.7
        ind=randi(scans); %randomly choose a scan
        move= botScan(ind)*0.6; %move an amount of a random distance in order to avoid noise and get out of the map
        turn = 2*pi*(ind-1)/scans;  %turn to that distance
    %move to the max distance for most of the time
    else 
        [max_dis, max_dis_ind] = max(botScan); %maximum distance of the botScan and its index
        move = rand*max_dis*0.6; %move an amount of the max distance in order to avoid noise and get out of the map
        turn = 2*pi*(max_dis_ind-1)/scans; %turn to the max distance    
    end
    
    %move the real robot
    botSim.turn(turn);        
    botSim.move(move); 

    %move the particles
    for i =1:num 
          particles(i).turn(turn);
          particles(i).move(move);
          if particles(i).insideMap == 0 %if the particles are not in the map, relocate them randomly
              particles(i).randomPose(0);
          end
    end
    
    %% Drawing
    %only draw if you are in debug mode or it will be slow during marking
    if botSim.debug()
        hold off; %the drawMap() function will clear the drawing when hold is off        
        botSim.drawMap(); %drawMap() turns hold back on again, so you can draw the bots
        botSim.drawBot(30,'g'); %draw robot with line length 30 and green
        for i =1:num
            particles(i).drawBot(3); %draw particle with line length 3 and default color
        end
        drawnow;
    end
end

%% Get the best orientation. Check all possible degrees
botScan=botSim.ultraScan();
v_norms=zeros(360,1); %scan for 360 degrees
for i=1:360
    estimated_scan=estimated_bot.ultraScan(); 
    v_norms(i)=norm(estimated_scan-botScan);
    estimated_bot.setBotAng(i*pi/180); %turn the bot
end

[~, min_pos]=min(v_norms);
estimated_bot.setBotAng(min_pos*pi/180); %turn the estimated_bot to the best orientation

end

%% Christos Mourouzi
% Canditate number: 33747
% email: cm16663@my.bristol.ac.uk
