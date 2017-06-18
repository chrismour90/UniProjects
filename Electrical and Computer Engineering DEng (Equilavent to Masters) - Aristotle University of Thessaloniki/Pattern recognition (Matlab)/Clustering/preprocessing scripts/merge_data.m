% Merge data. For every particle calculate avgs and replace the records that reside into it with these values

particle = 5;

%data will not always be in increasing one minute interval, so define a
%threshold for the time difference between records inside a particle
mn_threshold = 15;
% Folder to store new files
dir_d = 'merged_data';
if isequal(exist(dir_d, 'dir'),7)
    rmdir(dir_d, 's');
end
mkdir(dir_d);

% Folder of preprocessed data
dirc = 'epochs_timezones_nozeros_negatives';

delimiter = ',';
%# for each of the files that contain the data in the dir directory
files = dir(dirc);
%   %# exclude folders
%   files = {files(~[files.isdir])};
for file = files'
    file.name
    if strcmp(file.name, '.') ~= 1 && strcmp(file.name, '..') ~= 1
        %# Open the file
        fileID = fopen(strcat(dirc, '/', file.name),'r');
        %# Read the first line from the file
        nextLine = fgets(fileID);
        %  counter to count when particle size reached
        counter = 0;
        temp_counter_flag = 0;
        % Stores the data to write. Store dd, mm, yy, h, m in different columns
        N = zeros(200000, 12);
        sum = zeros(7, 1);
        avg = zeros(7, 1);
        val = zeros(7, 1);
        rec_no = 1;
        %# Loop while not at the end of the file
        while ~isequal(nextLine,-1)
            %# Read multiple types of data inside each line
            lineData = textscan(nextLine,'%s %s %s %s %s %s %s %s %s',...
                'Delimiter',delimiter);
            
            %% Find mean
            % store datetime info only for 1st record of each particle
            date = textscan(lineData{1}{1},'%s','delimiter','/');
            hour = textscan(lineData{2}{1},'%s','delimiter',':');
            % make sure to avoid header and incorrect values
            sz = cellfun(@size, date, 'uni', false);
            sz_t = sz{:};
            if sz_t(1) > 1 && (~strcmp(lineData{3}{1}, '?') && ~strcmp(lineData{4}{1}, '?') && ~strcmp(lineData{5}{1}, '?') && ~strcmp(lineData{6}{1}, '?') && ~strcmp(lineData{7}{1}, '?'))
                if counter == 0
                    dd = str2num(date{1}{1});
                    mm = str2num(date{1}{2});
                    yy = str2num(date{1}{3});
                    hr = str2num(hour{1}{1});
                    mn = str2num(hour{1}{2});
                end
                for si = 1:7
                    val(si) = str2num(lineData{2 + si:2 + si}{1});
                    sum(si) = sum(si) + val(si);
                end
                % check that the current record is close enough to the first record of this particle
                if str2num(date{1}{1}) ~= dd || str2num(date{1}{2}) ~= mm || str2num(date{1}{3}) ~= yy || abs(str2num(hour{1}{1}) - hr) > 1 || (abs(str2num(hour{1}{1}) - hr) == 0 && abs(str2num(hour{1}{2}) - mn) > mn_threshold) || (abs(str2num(hour{1}{1}) - hr) == 1 && abs(str2num(hour{1}{2}) + 60 - mn) > mn_threshold)
                    temp_counter_flag = 1;
                    counter = counter - 1;
                    sum(si) = sum(si) - val(si);
                end
                %# Read the next line from the file
                nextLine = fgets(fileID);
                counter = counter + 1;
                if counter >= particle || isequal(nextLine,-1) || temp_counter_flag == 1
                    N(rec_no, 1) = dd;
                    N(rec_no, 2) = mm;
                    N(rec_no, 3) = yy;
                    N(rec_no, 4) = hr;
                    N(rec_no, 5) = mn;
                    for si = 1:7
                        N(rec_no, 5 + si) = sum(si) / counter;
                        sum(si) = 0;
                    end
                    rec_no = rec_no + 1;
                    counter = 0;
                    temp_counter_flag = 0;
                end
            else
                nextLine = fgets(fileID);
            end
            
            
        end
        %# Close the file
        fclose(fileID);
        
        
        N = N(1:rec_no-1, :);
        %# Write new data
        
        % it does not really matter if files have _nozeros or something else at the
        % end, only 20 first characters are compared
        if strncmp(file.name, 'lineArrayWinterMorning_nozeros.csv', 20)
            csvwrite(strcat(dir_d, '/', 'lineArrayWinterMorning.csv'), N);
        elseif strncmp(file.name, 'lineArrayWinterAfternoon_nozeros.csv', 20)
            csvwrite(strcat(dir_d, '/', 'lineArrayWinterAfternoon.csv'), N);
        elseif strncmp(file.name, 'lineArrayWinterNight_nozeros.csv', 20)
            csvwrite(strcat(dir_d, '/', 'lineArrayWinterNight.csv'), N);
        elseif strncmp(file.name, 'lineArraySpringMorning_nozeros.csv', 20)
            csvwrite(strcat(dir_d, '/', 'lineArraySpringMorning.csv'), N);
        elseif strncmp(file.name, 'lineArraySpringAfternoon_nozeros.csv', 20)
            csvwrite(strcat(dir_d, '/', 'lineArraySpringAfternoon.csv'), N);
        elseif strncmp(file.name, 'lineArraySpringNight_nozeros.csv', 20)
            csvwrite(strcat(dir_d, '/', 'lineArraySpringNight.csv'), N);
        elseif strncmp(file.name, 'lineArraySummerMorning_nozeros.csv', 20)
            csvwrite(strcat(dir_d, '/', 'lineArraySummerMorning.csv'), N);
        elseif strncmp(file.name, 'lineArraySummerAfternoon_nozeros.csv', 20)
            csvwrite(strcat(dir_d, '/', 'lineArraySummerAfternoon.csv'), N);
        elseif strncmp(file.name, 'lineArraySummerNight_nozeros.csv', 20)
            csvwrite(strcat(dir_d, '/', 'lineArraySummerNight.csv'), N);
        elseif strncmp(file.name, 'lineArrayAutumnMorning_nozeros.csv', 20)
            csvwrite(strcat(dir_d, '/', 'lineArrayAutumnMorning.csv'), N);
        elseif strncmp(file.name, 'lineArrayAutumnAfternoon_nozeros.csv', 20)
            csvwrite(strcat(dir_d, '/', 'lineArrayAutumnAfternoon.csv'), N);
        else
            csvwrite(strcat(dir_d, '/', 'lineArrayAutumnNight.csv'), N);
        end
    end
end
