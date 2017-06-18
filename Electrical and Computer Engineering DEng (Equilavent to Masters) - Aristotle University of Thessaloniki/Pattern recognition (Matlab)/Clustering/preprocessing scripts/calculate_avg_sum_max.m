clear all;
close all;


%source directory
dirs = 'merged_data';
delimiter = ',';

%destination folder
dird = 'avg_sum_max';

if ~isequal(exist(dird, 'dir'),7)
    mkdir(dird);
end

%the user  may select the final dataset's record being
%# 1- sum, avg, max for every attribute of each timezone and season, thus 12
% records ( summer-morning, winter-morning, winter-afternoon, etc. )
%# 2- sum, avg, max for every attribute of each timezone, season and year,
%thus 48 records ( 2007-summer-morning, 2007-winter-morning,
%2008-winter-morning, etc. ) . The data of 2006 are ignored.
%# 3- sum, avg, max for every attribute of each season and year
%thus 16 records ( 2007-summer, 2007-winter, 2008-winter, etc. ) . 
%The data of 2006 are ignored.
selection = 3;

if selection == 1
    
    %% Option 1
    
    %destination files'  names
    name1 = 'sum_timezone_season.csv';
    name2 = 'avg_timezone_season.csv';
    name3 = 'max_timezone_season.csv';
    
    %# for each of the files that contain the data in the dir directory
    files = dir(dirs);
    %   %# exclude folders
    %   files = {files(~[files.isdir])};
    %Find sum, avg, max of all numeric values for the 12 files and then write
    %a record at the corresponding metric's file for each of the input files
    
    %total records in the output file
    total_data = 0;
    for file = files'
        file.name;
        if strcmp(file.name, '.') ~= 1 && strcmp(file.name, '..') ~= 1
            total_data = total_data + 1;
            f = csvread(strcat(dirs, '/', file.name));
            i = 1;
            value = zeros(7, 1);
            sumv = zeros(7, 1);
            avg = zeros(7, 1);
            max = zeros(7,1);
            %# Loop while not at the end of the file
            while i <= length(f);
                %store the numeric attributes
                for j = 6:12
                    value(j-5) = f(i, j);
                    sumv(j-5) = sumv(j-5) + value(j-5);
                    if value(j-5) >= max(j-5)
                        max(j-5) = value(j-5);
                    end
                end
                i = i + 1;
            end
            for j = 1:7
                o1(total_data, j) = sumv(j);
                o2(total_data, j) = sumv(j) / (i-1);
                o3(total_data, j) = max(j);
                endthe input files
            end
        end
    end
    csvwrite(strcat(dird, '/', name1), o1);
    csvwrite(strcat(dird, '/', name2), o2);
    csvwrite(strcat(dird, '/', name3), o3);
    
    
    
elseif selection == 2
    
    %% Option 2
    
    %destination files'  names
    name1 = 'sum_timezone_season_year.csv';
    name2 = 'avg_timezone_season_year.csv';
    name3 = 'max_timezone_season_year.csv';
    
    o1 = zeros(48, 7);
    o2 = zeros(48, 7);
    o3 = zeros(48, 7);
    
    %# for each of the files that contain the data in the dir directory
    files = dir(dirs);
    %   %# exclude folders
    %   files = {files(~[files.isdir])};
    %Find sum, avg, max of all numeric values for the 48 combinations and then write
    %a record at the corresponding metric's file for each of combinations
    
    %total records in the output file
    total_data = 0;
    for file = files'
        file.name;
        if strcmp(file.name, '.') ~= 1 && strcmp(file.name, '..') ~= 1
            total_data = total_data + 4;
            f = csvread(strcat(dirs, '/', file.name));
            i = 1;
            %each file will be split in 4 years
            value = zeros(7, 1);
            sumv = zeros(7, 4);
            avg = zeros(7, 4);
            max = zeros(7,4);
            % total records for each year in the current file
            total = zeros(4,1);
            %# Loop while not at the end of the file
            while i <= length(f);
                %store the numeric attributes
                if f(i, 3) == 2007
                    total(1) = total(1) + 1;
                    for j = 6:12
                        
                        value(j-5) = f(i, j);
                        sumv(j-5, 1) = sumv(j-5, 1) + value(j-5);
                        if value(j-5) >= max(j-5, 1)
                            max(j-5, 1) = value(j-5);
                        end
                        
                    end
                elseif f(i, 3) == 2008
                    total(2) = total(2) + 1;
                    for j = 6:12
                        
                        value(j-5) = f(i, j);
                        sumv(j-5, 2) = sumv(j-5, 2) + value(j-5);
                        if value(j-5) >= max(j-5, 2)
                            max(j-5, 2) = value(j-5);
                        end
                        
                    end
                elseif f(i, 3) == 2009
                    total(3) = total(3) + 1;
                    for j = 6:12
                        
                        value(j-5) = f(i, j);
                        sumv(j-5, 3) = sumv(j-5, 3) + value(j-5);
                        if value(j-5) >= max(j-5, 3)
                            max(j-5, 3) = value(j-5);
                        end
                        
                    end
                elseif f(i,3) == 2010
                    total(4) = total(4) + 1;
                    for j = 6:12
                        
                        value(j-5) = f(i, j);
                        sumv(j-5, 4) = sumv(j-5, 4) + value(j-5);
                        if value(j-5) >= max(j-5, 4)
                            max(j-5, 4) = value(j-5);
                        end
                        
                    end
                end
                i = i + 1;
            end
            for i = (total_data-3):total_data
                for j = 1:7
                    o1(i, j) = sumv(j, i - total_data + 4);
                    o2(i, j) = sumv(j, i - total_data + 4) / total(i - total_data + 4);
                    o3(i, j) = max(j, i - total_data + 4);
                end
            end
        end
    end
    csvwrite(strcat(dird, '/', name1), o1);
    csvwrite(strcat(dird, '/', name2), o2);
    csvwrite(strcat(dird, '/', name3), o3);
else
    %% Option 3
    
    %destination files'  names
    name1 = 'sum_season_year.csv';
    name2 = 'avg_season_year.csv';
    name3 = 'max_season_year.csv';
    
    o1 = zeros(16, 7);
    o2 = zeros(16, 7);
    o3 = zeros(16, 7);
    
    %# for each of the files that contain the data in the dir directory
    files = dir(dirs);
    %   %# exclude folders
    %   files = {files(~[files.isdir])};
    %Find sum, avg, max of all numeric values for the 48 combinations and then write
    %a record at the corresponding metric's file for each of combinations
    
    %total records in the output file
    total_data = 0;
    sumv = zeros(7, 16);
    avg = zeros(7, 16);
    max = zeros(7,16);
    % total records for each year in the current file
    total = zeros(16,1);
    % compose an id for each combination to eliminate ifs
    k = 0;
    season_month_map = [1 1 2 2 2 3 3 3 4 4 4 1];
    combin = zeros(4, 4);
    for i = 2007:2010
        for j = 1:12
            combin(i - 2006, season_month_map(j)) = k + season_month_map(j);
        end
        k = k + 4;
    end
    for file = files'
        file.name;
        if strcmp(file.name, '.') ~= 1 && strcmp(file.name, '..') ~= 1
            total_data = total_data + 4;
            f = csvread(strcat(dirs, '/', file.name));
            i = 1;
            value = zeros(7, 1);
            %# Loop while not at the end of the file
            while i <= length(f);
                %store the numeric attributes
                if f(i,3) ~= 2006
                    for j = 6:12
                        value(j-5) = f(i, j);
                        sumv(j-5, combin(f(i, 3) - 2006, season_month_map(f(i,2)))) = sumv(j-5, combin(f(i, 3) - 2006, season_month_map(f(i,2)))) + value(j-5);
                        if value(j-5) >= max(j-5, combin(f(i, 3) - 2006, season_month_map(f(i,2))))
                            max(j-5, combin(f(i, 3) - 2006, season_month_map(f(i,2)))) = value(j-5);
                        end
                    end
                    total(combin(f(i, 3) - 2006, season_month_map(f(i,2)))) = total(combin(f(i, 3) - 2006, season_month_map(f(i,2)))) + 1;
                end
                i = i + 1;
            end
        end
    end
    for i = 1:16
        for j = 1:7
            o1(i, j) = sumv(j, i);
            o2(i, j) = sumv(j, i) / total(i);
            o3(i, j) = max(j, i);
        end
    end
    csvwrite(strcat(dird, '/', name1), o1);
    csvwrite(strcat(dird, '/', name2), o2);
    csvwrite(strcat(dird, '/', name3), o3);
end









