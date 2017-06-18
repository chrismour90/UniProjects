        function [distances, crossingPoints] = ultraScan(bot)
            %ultraScan simulates the ultrasound scan.  Returns a vector of
            %distances to the walls with the respective crossing points
            distances = zeros(size(bot.scanLines,1),1);
            cps = zeros(length(bot.mapLines),2,length(bot.scanLines)); %crossingPoints
            crossingPoints = zeros(size(bot.scanLines,1),2);
            botpos = repmat(bot.pos,length(bot.mapLines),1); %preallocate for speed
            for i =1:size(bot.scanLines)
                cps(:,:,i) = intersection(bot.scanLines(i,:),bot.mapLines)+randn(length(bot.mapLines),2)*bot.sensorNoise;
                distSQ =sum((cps(:,:,i) - botpos).^2,2);
                [distances(i,:), indices] = min(distSQ);
                tmp = sqrt(distances(i,:)); % only do sqrt once instead of on the entire vector
                
                nearestLine = bot.mapLines(indices, :, :, :);        
                bsLine = bot.scanLines(i,:);
                v1 = [nearestLine(1,3) - nearestLine(1,1) nearestLine(1,4) - nearestLine(1,2) 0]; 
                v2 = [bsLine(1,3) - bsLine(1,1) bsLine(1,4) - bsLine(1,2) 0];                 
                angle = rad2deg(atan2(norm(cross(v1, v2)), dot(v1, v2)));
                
                if isnan(tmp) %check for nan's as they will propigate through the filter and ruin things.
                    distances(i,:) = inf;
                else
                    if angle < 50 
                        distances(i,:) = 255;
                    else
                        distances(i,:) = tmp; %orig
                    end
                end
                crossingPoints(i,:) = cps(indices,:,i);
            end
            if bot.adminKey ~= 0
                crossingPoints =[];
            end
            
%             %%Written using inbuilt functions, 2x as slow
%             [crossX crossY] = polyxpoly(bot.sl(:,1),bot.sl(:,2),bot.inpolygonMapformatX,bot.inpolygonMapformatY);
%             crossingPoints = cat(2,crossX,crossY);
%             for i =1:length(crossX)
%                 distSQ =sum((crossingPoints(i,:) - bot.pos).^2,2);
%                 distances(i,:) = min(distSQ);
%                 distances(i,:) = sqrt(distances(i,:)); % only do sqrt once instead of on the entire vector
%             end
        end
