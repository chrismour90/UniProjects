function lineArray = read_mixed_file(dirc,delimiter)
   %# Preallocate a cell array for each season/timezone(ideally slightly larger than is needed)
   lineArrayWinterMorning = fopen('lineArrayWinterMorning.csv','w');    
   lineArrayWinterAfternoon = fopen('lineArrayWinterAfternoon.csv','w');
   lineArrayWinterNight = fopen('lineArrayWinterNight.csv','w');
   lineArraySpringMorning = fopen('lineArraySpringMorning.csv','w');
   lineArraySpringAfternoon = fopen('lineArraySpringAfternoon.csv','w');
   lineArraySpringNight = fopen('lineArraySpringNight.csv','w');
   lineArraySummerMorning = fopen('lineArraySummerMorning.csv','w');  
   lineArraySummerAfternoon = fopen('lineArraySummerAfternoon.csv','w');
   lineArraySummerNight = fopen('lineArraySummerNight.csv','w');
   lineArrayAutumnMorning = fopen('lineArrayAutumnMorning.csv','w');    
   lineArrayAutumnAfternoon = fopen('lineArrayAutumnAfternoon.csv','w');
   lineArrayAutumnNight = fopen('lineArrayAutumnNight.csv','w');
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
        %# Loop while not at the end of the file
        while ~isequal(nextLine,-1)
            %# Read multiple types of data inside each line
            lineData = textscan(nextLine,'%s %s %s %s %s %s %s %s %s',...
                'Delimiter',delimiter);        
            %# Discover in which cell array this record has to go
            date = textscan(lineData{1}{1},'%s','delimiter','/');
            hour = textscan(lineData{2}{1},'%s','delimiter',':');
            dt = str2num(date{1}{2});
            hr = str2num(hour{1}{1});
            %# Remove cell encapsulation
            %lineData = lineData{1}     
            lineData = [lineData{:}];
            if length( lineData ) == 9
                if dt == 12 || dt == 1 || dt == 2
                    if hr == 23 || hr <= 6
                        %lineArrayWinterNight(lineIndexWinterNight,:) = lineData(1, :);
                        %lineArrayWinterNight(lineIndexWinterNight,1)
                        %lineArrayWinterNight(lineIndexWinterNight,2)
                        fprintf(lineArrayWinterNight, '%s' ,nextLine);
                        %lineIndexWinterNight = lineIndexWinterNight+1;
                    elseif hr <= 15
                        %lineArrayWinterMorning(lineIndexWinterMorning,:) = lineData(1, :);
                        fprintf(lineArrayWinterMorning, '%s' ,nextLine);
                        
                        %lineIndexWinterMorning = lineIndexWinterMorning+1;
                    else
                        %lineArrayWinterAfternoon(lineIndexWinterAfternoon,:) = lineData(1, :);
                        fprintf(lineArrayWinterAfternoon, '%s' ,nextLine);
                        
                        %lineIndexWinterAfternoon = lineIndexWinterAfternoon+1;
                    end
                    
                elseif any(dt == 3:5)
                    if hr == 23 || hr <= 7
                        %lineArraySpringNight(lineIndexSpringNight,:) = lineData(1, :);
                        fprintf(lineArraySpringNight, '%s' ,nextLine);
                        
                        %lineIndexSpringNight = lineIndexSpringNight+1;
                    elseif hr <= 15
                        %lineArraySpringMorning(lineIndexSpringMorning,:) = lineData(1, :);
                        fprintf(lineArraySpringMorning, '%s' ,nextLine);
                        
                        %lineIndexSpringMorning = lineIndexSpringMorning+1;
                    else
                        %lineArraySpringAfternoon(lineIndexSpringAfternoon,:) = lineData(1, :);
                        fprintf(lineArraySpringAfternoon, '%s' ,nextLine);
                        
                        %lineIndexSpringAfternoon = lineIndexSpringAfternoon+1;
                    end
                elseif any(dt == 6:8)
                    if hr == 23 || hr <= 7
                        %lineArraySummerNight(lineIndexSummerNight,:) = lineData(1, :);
                        fprintf(lineArraySummerNight, '%s' ,nextLine);
                        
                        %lineIndexSummerNight = lineIndexSummerNight+1;
                    elseif hr <= 15
                        %lineArraySummerMorning(lineIndexSummerMorning,:) = lineData(1, :);
                        fprintf(lineArraySummerMorning, '%s' ,nextLine);
                        
                        %lineIndexSummerMorning = lineIndexSummerMorning+1;
                    else
                        %lineArraySummerAfternoon(lineIndexSummerAfternoon,:) = lineData(1, :);
                        fprintf(lineArraySummerAfternoon, '%s' ,nextLine);
                        
                        %lineIndexSummerAfternoon = lineIndexSummerAfternoon+1;
                    end
                else
                    if hr == 23 || hr <= 7
                        %lineArrayAutumnNight(lineIndexAutumnNight,:) = lineData(1, :);
                        fprintf(lineArrayAutumnNight, '%s' ,nextLine);
                        
                        %lineIndexAutumnNight = lineIndexAutumnNight+1;
                    elseif hr <= 15
                        %lineArrayAutumnMorning(lineIndexAutumnMorning,:) = lineData(1, :);
                        fprintf(lineArrayAutumnMorning, '%s' ,nextLine);
                        
                        %lineIndexAutumnMorning = lineIndexAutumnMorning+1;
                    else
                        %lineArrayAutumnAfternoon(lineIndexAutumnMorning,:) = lineData(1, :);
                        fprintf(lineArrayAutumnAfternoon, '%s' ,nextLine);
                        
                        %lineIndexAutumnAfternoon = lineIndexAutumnAfternoon+1;
                    end
                end
            end
            %# Read the next line from the file
            nextLine = fgets(fileID);
        end
        %# Close the file
        fclose(fileID);
    end
  end
   fclose(lineArrayWinterMorning);   
   fclose(lineArrayWinterAfternoon);   
   fclose(lineArrayWinterNight);   
   fclose(lineArraySpringMorning);   
   fclose(lineArraySpringAfternoon);   
   fclose(lineArraySpringNight);   
   fclose(lineArraySummerMorning);   
   fclose(lineArraySummerAfternoon);   
   fclose(lineArraySummerNight);   
   fclose(lineArrayAutumnMorning);   
   fclose(lineArrayAutumnAfternoon);
   fclose(lineArrayAutumnNight);
   
  %# Remove empty cells, if needed
 % lineArrayWinterMorning = lineArrayWinterMorning(1:lineIndexWinterMorning-1);
  %# Write each cell array to separate csv files
%   fileID = fopen('test.csv', 'w') ;
%   fprintf(fileID, '%s,', lineArrayWinterMorning{1,1:end-1}) ;
%   fprintf(fileID, '%s\n', lineArrayWinterMorning{1,end}) ;
%   fclose(fileID) ;
%   for i=1:length(lineArrayWinterMorning)
%     fprintf(fileID, '%s\n', lineArrayWinterMorning(i, :));
%   end
%   fclose(fileID) ;
 % dlmwrite('test.csv', lineArrayWinterMorning,'delimiter',',') ;
end
  

