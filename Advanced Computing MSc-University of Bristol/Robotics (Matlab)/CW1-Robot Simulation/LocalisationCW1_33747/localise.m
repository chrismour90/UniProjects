function [botSim, estimated_bot] = localise(botSim, map,target)
%% This function returns botSim and estimated_bot and accepts botSim, a map and a target.
%First the bot finds its location using a particle filter. When it is
%converged a path plan is created and the bot tries to reach the target.

%% Initial localization
[botSim, estimated_bot] = particle_filter(botSim,map,target);

%% Path Planning and go to the target
[botSim, estimated_bot] = pathPlanning(botSim,estimated_bot,target,map);   

end

%% Christos Mourouzi
% Canditate number: 33747
% email: cm16663@my.bristol.ac.uk
