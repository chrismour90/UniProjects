clear all;
close all;


dirc = 'NoZerosGlobalReactiveOnlyNegative';
delimiter = ',';

% the number of already calculated records in sums before we may ignore
% extreme values in its calculation
threshold_in_sum = 100;
% the percentage of the current attribute sum over which we ignore this
% value in avg calculation
threshold_to_sum = 0.1;
% the percentage of the avg value over which we consider this value extreme
threshold_percentage = 5 ;
% each can have a different threshold, e.g. a value 2*240 in 3rd attribute
% is extreme against a value 20*0.3 in first attribute. Will be multiplied
% by th percentage
threshold_distribution = [3 3 2 3 3 3 3];
% the percentage of the dif between this value and avg to add/ subtract to/ from this extreme value
threshold_normalization = 0.8;
dir_save = 'epochs_timezones_noextremes';
dir_save = strcat(dir_save, 'TIS_', num2str(threshold_in_sum));
dir_save = strcat(dir_save, 'TTS_', num2str(threshold_to_sum * 100));
dir_save = strcat(dir_save, 'T1_', num2str(threshold_percentage * 100), 'TDi');
for j = 1:7
    dir_save = strcat(dir_save, '_', num2str(threshold_distribution(j)));
end
dir_save = strcat(dir_save, 'T2_', num2str(threshold_normalization * 100));
if isequal(exist(dir_save, 'dir'),7)
    rmdir(dir_save, 's');
end
mkdir(dir_save);
%# for each of the files that contain the data in the dir directory
files = dir(dirc);
%   %# exclude folders
%   files = {files(~[files.isdir])};
%% Find avg of all numeric values and then reopen the files to spot and eliminate the extreme records
value = zeros(7, 1);
avg = zeros(7, 1);
for file = files'
    file.name;
    if strcmp(file.name, '.') ~= 1 && strcmp(file.name, '..') ~= 1
        %# Open the file
        f = csvread(strcat(dirc, '/', file.name));
        %         sum_global_active_power = 0;
        %         sum_global_reactive_power = 0;
        %         sum_voltage = 0;
        %         sum_global_intensity = 0;
        %         sum_sub_metering_1 = 0;
        %         sum_sub_metering_2 = 0;
        %         sum_sub_metering_3 = 0;
        total_data = 0;
        sumv = zeros(7, 1);
        i = 1;
        %# Loop while not at the end of the file
        while i <= length(f);
            total_data = total_data + 1;
            %# Read multiple types of data inside each line
            %             global_active_power = f(i, 1);
            %             global_reactive_power = f(i, 2);
            %             voltage = f(i, 3);
            %             global_intensity = f(i, 4);
            %             sub_metering_1 = f(i, 5);
            %             sub_metering_2 = f(i, 6);
            %             sub_metering_3 = f(i, 7);
            for j = 1:7
                value(j) = f(i, j);
            end
            for j = 1:7
                % do not include extreme values
                if i <= threshold_in_sum || (value(j) / sumv(j)) <= threshold_to_sum || sumv(j) == 0
                    %                     sum_global_active_power = sum_global_active_power + global_active_power;
                    %                     sum_global_reactive_power = sum_global_reactive_power + global_reactive_power;
                    %                     sum_voltage = sum_voltage + voltage;
                    %                     sum_global_intensity = sum_global_intensity + global_intensity;
                    %                     sum_sub_metering_1 = sum_sub_metering_1 + sub_metering_1;
                    %                     sum_sub_metering_2 = sum_sub_metering_2 + sub_metering_2;
                    %                     sum_sub_metering_3 = sum_sub_metering_3 + sub_metering_3;
                    sumv(j) = sumv(j) + value(j); 
                    total_data = total_data + 1;
                end
            end
            i = i + 1;
        end
        for j = 1:7
            avg(j) = sumv(j) / total_data;
        end
        %# Reopen to spot the extreme values
        f = csvread(strcat(dirc, '/', file.name));
        i = 1;
        %# Loop while not at the end of the file
        while i <= length(f);
            %             global_active_power = f(i, 1);
            %             global_reactive_power = f(i, 2);
            %             voltage = f(i, 3);
            %             global_intensity = f(i, 4);
            %             sub_metering_1 = f(i, 5);
            %             sub_metering_2 = f(i, 6);
            %             sub_metering_3 = f(i, 7);
            for j = 1:7
                % extreme values set to avg
                if abs(f(i, j) - avg(j)) > (threshold_percentage * threshold_distribution(j) * avg(j))
                    if f(i, j) > avg(j) + threshold_percentage * avg(j)
                        f(i, j) = f(i, j) - (f(i, j) - (avg(j) + threshold_percentage * threshold_distribution(j) * avg(j))) * threshold_normalization;
                    else
                        f(i, j) = f(i, j) + ((avg(j) - threshold_percentage * threshold_distribution(j) * avg(j)) - f(i, j)) * threshold_normalization;
                    end
                end
            end
            i = i + 1;
        end
        
        if strcmp(file.name, 'lineArrayWinterMorning_nozeros.csv')
            csvwrite(strcat(dir_save, '/lineArrayWinterMorning_noextremes.csv'), f);
        elseif strcmp(file.name, 'lineArrayWinterAfternoon_nozeros.csv')
            csvwrite(strcat(dir_save, '/lineArrayWinterAfternoon_noextremes.csv'), f);
        elseif strcmp(file.name, 'lineArrayWinterNight_nozeros.csv')
            csvwrite(strcat(dir_save, '/lineArrayWinterNight_noextremes.csv'), f);
        elseif strcmp(file.name, 'lineArraySpringMorning_nozeros.csv')
            csvwrite(strcat(dir_save, '/lineArraySpringMorning_noextremes.csv'), f);
        elseif strcmp(file.name, 'lineArraySpringAfternoon_nozeros.csv')
            csvwrite(strcat(dir_save, '/lineArraySpringAfternoon_noextremes.csv'), f);
        elseif strcmp(file.name, 'lineArraySpringNight_nozeros.csv')
            csvwrite(strcat(dir_save, '/lineArraySpringNight_noextremes.csv'), f);
        elseif strcmp(file.name, 'lineArraySummerMorning_nozeros.csv')
            csvwrite(strcat(dir_save, '/lineArraySummerMorning_noextremes.csv'), f);
        elseif strcmp(file.name, 'lineArraySummerAfternoon_nozeros.csv')
            csvwrite(strcat(dir_save, '/lineArraySummerAfternoon_noextremes.csv'), f);
        elseif strcmp(file.name, 'lineArraySummerNight_nozeros.csv')
            csvwrite(strcat(dir_save, '/lineArraySummerNight_noextremes.csv'), f);
        elseif strcmp(file.name, 'lineArrayAutumnMorning_nozeros.csv')
            csvwrite(strcat(dir_save, '/lineArrayAutumnMorning_noextremes.csv'), f);
        elseif strcmp(file.name, 'lineArrayAutumnAfternoon_nozeros.csv')
            csvwrite(strcat(dir_save, '/lineArrayAutumnAfternoon_noextremes.csv'), f);
        else
            csvwrite(strcat(dir_save, '/lineArrayAutumnNight_noextremes.csv'), f);
        end
    end
end

