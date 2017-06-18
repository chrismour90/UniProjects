clear all;
close all;

dirc = 'epochs_timezones';
delimiter = ',';

dir_d = 'epochs_timezones_nozeros';
if isequal(exist(dir_d, 'dir'),7)
    rmdir(dir_d, 's');
end
mkdir(dir_d);
lineArrayWinterMorning_nozeros = fopen('epochs_timezones_nozeros/lineArrayWinterMorning_nozeros.csv','w');
lineArrayWinterAfternoon_nozeros = fopen('epochs_timezones_nozeros/lineArrayWinterAfternoon_nozeros.csv','w');
lineArrayWinterNight_nozeros = fopen('epochs_timezones_nozeros/lineArrayWinterNight_nozeros.csv','w');
lineArraySpringMorning_nozeros = fopen('epochs_timezones_nozeros/lineArraySpringMorning_nozeros.csv','w');
lineArraySpringAfternoon_nozeros = fopen('epochs_timezones_nozeros/lineArraySpringAfternoon_nozeros.csv','w');
lineArraySpringNight_nozeros = fopen('epochs_timezones_nozeros/lineArraySpringNight_nozeros.csv','w');
lineArraySummerMorning_nozeros = fopen('epochs_timezones_nozeros/lineArraySummerMorning_nozeros.csv','w');
lineArraySummerAfternoon_nozeros = fopen('epochs_timezones_nozeros/lineArraySummerAfternoon_nozeros.csv','w');
lineArraySummerNight_nozeros = fopen('epochs_timezones_nozeros/lineArraySummerNight_nozeros.csv','w');
lineArrayAutumnMorning_nozeros = fopen('epochs_timezones_nozeros/lineArrayAutumnMorning_nozeros.csv','w');
lineArrayAutumnAfternoon_nozeros = fopen('epochs_timezones_nozeros/lineArrayAutumnAfternoon_nozeros.csv','w');
lineArrayAutumnNight_nozeros = fopen('epochs_timezones_nozeros/lineArrayAutumnNight_nozeros.csv','w');
%# for each of the files that contain the data in the dir directory
files = dir(dirc);
%   %# exclude folders
%   files = {files(~[files.isdir])};
%% Find unusual zero or negatively valued records, corresponding to global_active_power, global_reactive_power, voltage, global_intensity etc.

for file = files'
    file.name;
    if strcmp(file.name, '.') ~= 1 && strcmp(file.name, '..') ~= 1
        %# Open the file
        fileID = fopen(strcat(dirc, '/', file.name),'r');
        %# Read the first line from the file
        nextLine = fgets(fileID);
        %# Loop while not at the end of the file
        while ~isequal(nextLine,-1)
            %# Read multiple types of data inside each line
            lineData = textscan(nextLine,'%s %s %s %s %s %s %s %s %s',...
                'Delimiter',delimiter);
            global_active_power = lineData{3}{1};
            global_reactive_power = lineData{4}{1};
            voltage = lineData{5}{1};
            global_intensity = lineData{6}{1};
            sub_metering_1 = lineData{7}{1};
            sub_metering_2 = lineData{8}{1};
            sub_metering_3 = lineData{9}{1};
            global_active_power = str2num(global_active_power);
            global_reactive_power = str2num(global_reactive_power);
            voltage = str2num(voltage);
            global_intensity = str2num(global_intensity);
            sub_metering_1 = str2num(sub_metering_1);
            sub_metering_2 = str2num(sub_metering_2);
            sub_metering_3 = str2num(sub_metering_3);
            %# Remove cell encapsulation
            %lineData = lineData{1}
            lineData = [lineData{:}];
            
            if global_active_power > 0 & global_reactive_power > 0 & voltage > 0 & global_intensity > 0 & sub_metering_1 >= 0 & sub_metering_2 >= 0 & sub_metering_3 >= 0
                if strcmp(file.name, 'lineArrayWinterMorning.csv')
                    fprintf(lineArrayWinterMorning_nozeros, '%s' ,nextLine);
                elseif strcmp(file.name, 'lineArrayWinterAfternoon.csv')
                    fprintf(lineArrayWinterAfternoon_nozeros, '%s' ,nextLine);
                elseif strcmp(file.name, 'lineArrayWinterNight.csv')
                    fprintf(lineArrayWinterNight_nozeros, '%s' ,nextLine);
                elseif strcmp(file.name, 'lineArraySpringMorning.csv')
                    fprintf(lineArraySpringMorning_nozeros, '%s' ,nextLine);  
                elseif strcmp(file.name, 'lineArraySpringAfternoon.csv')
                    fprintf(lineArraySpringAfternoon_nozeros, '%s' ,nextLine);   
                elseif strcmp(file.name, 'lineArraySpringNight.csv')
                    fprintf(lineArraySpringNight_nozeros, '%s' ,nextLine); 
                elseif strcmp(file.name, 'lineArraySummerMorning.csv')
                    fprintf(lineArraySummerMorning_nozeros, '%s' ,nextLine);    
                elseif strcmp(file.name, 'lineArraySummerAfternoon.csv')
                    fprintf(lineArraySummerAfternoon_nozeros, '%s' ,nextLine);  
                elseif strcmp(file.name, 'lineArraySummerNight.csv')
                    fprintf(lineArraySummerNight_nozeros, '%s' ,nextLine);   
                elseif strcmp(file.name, 'lineArrayAutumnMorning.csv')
                    fprintf(lineArrayAutumnMorning_nozeros, '%s' ,nextLine); 
                elseif strcmp(file.name, 'lineArrayAutumnAfternoon.csv')
                    fprintf(lineArrayAutumnAfternoon_nozeros, '%s' ,nextLine);   
                else
                    fprintf(lineArrayAutumnNight_nozeros, '%s' ,nextLine);    
                end
            end
            
            %# Read the next line from the file
            nextLine = fgets(fileID);
        end
        %# Close the file
        fclose(fileID);
    end
end
fclose(lineArrayWinterMorning_nozeros);
fclose(lineArrayWinterAfternoon_nozeros);
fclose(lineArrayWinterNight_nozeros);
fclose(lineArraySpringMorning_nozeros);
fclose(lineArraySpringAfternoon_nozeros);
fclose(lineArraySpringNight_nozeros);
fclose(lineArraySummerMorning_nozeros);
fclose(lineArraySummerAfternoon_nozeros);
fclose(lineArraySummerNight_nozeros);
fclose(lineArrayAutumnMorning_nozeros);
fclose(lineArrayAutumnAfternoon_nozeros);
fclose(lineArrayAutumnNight_nozeros);