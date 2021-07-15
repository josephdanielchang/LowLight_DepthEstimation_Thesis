% Generate txt file listing train and val files

% cd 'D:\dataset\train\daytime\left' %add right right after in txt file

% ./dataset/daytime/left/00010.png
% ./dataset/daytime/right/00010.png     
% ./dataset/daytime/left/00050.png
% ./dataset/daytime/right/00050.png

% cd 'D:\dataset\train\nighttime\left' %add right right after in txt file

% ./dataset/nighttime/left/00701.png
% ./dataset/nighttime/right/00701.png
% ./dataset/nighttime/left/00094.png
% ./dataset/nighttime/right/00094.png

% cd 'D:\dataset\val\nighttime\left' %add right, disp_GT right after in txt file

% ./dataset/nighttime/left/00001.png
% ./dataset/nighttime/right/00001.png
% ./dataset/nighttime/disp_GT/00001.png 

clear,clc

% %% Kubernetes version
% 
% %% Train Daytime Data
% 
% cd 'D:\Joseph_Chang\dataset\train\daytime\left' %add right right after in txt file
% 
% data = dir('*.png');
% file = fopen('D:\Joseph_Chang\datafiles\Oxford_DayTime_Data.txt', 'wt');
% N = length(data);
% 
% for image = 1:N
%     
%   text = strcat('./../../media/joseph/''WD Passport''/''Joseph_Chang''/dataset/train/daytime/left/', data(image).name, '\n');
%   fprintf(file, text);
%   text = strcat('./../../media/joseph/''WD Passport''/''Joseph_Chang''/dataset/train/daytime/right/', data(image).name);
%   fprintf(file, text);
%   
%   if image ~= N
%      fprintf(file,'\n');
%   end
%   
% end
% fclose(file);
% 
% %% Train Nighttime Data
% 
% cd 'D:\Joseph_Chang\dataset\train\nighttime\left' %add right right after in txt file
% 
% data = dir('*.png');
% file = fopen('D:\Joseph_Chang\datafiles\Oxford_NightTime_Data.txt', 'wt');
% N = length(data);
% 
% for image = 1:N
%     
%   text = strcat('./../../media/joseph/''WD Passport''/''Joseph_Chang''/dataset/train/nighttime/left/', data(image).name, '\n');
%   fprintf(file, text);
%   text = strcat('./../../media/joseph/''WD Passport''/''Joseph_Chang''/dataset/train/nighttime/right/', data(image).name);
%   fprintf(file, text);
%   
%   if image ~= N
%      fprintf(file,'\n');
%   end
%   
% end
% fclose(file);
% 
% %% Val Nighttime Data
% 
% cd 'D:\Joseph_Chang\dataset\val\nighttime\left' %add right right after in txt file
% 
% data = dir('*.png');
% file = fopen('D:\Joseph_Chang\datafiles\Oxford_NightTime_Data_withGT.txt', 'wt');
% 
% cd 'D:\Joseph_Chang\dataset\val\nighttime\disp_GT'
% dataDisp = dir('*.png');
% 
% N = length(data);
% 
% for image = 1:N
%     
%   text = strcat('./../../media/joseph/''WD Passport''/''Joseph_Chang''/dataset/val/nighttime/left/', data(image).name, '\n');
%   fprintf(file, text);
%   text = strcat('./../../media/joseph/''WD Passport''/''Joseph_Chang''/dataset/val/nighttime/right/', data(image).name, '\n');
%   fprintf(file, text);
%   text = strcat('./../../media/joseph/''WD Passport''/''Joseph_Chang''/dataset/val/nighttime/disp_GT/', dataDisp(image).name);
%   fprintf(file, text);
%   
%   if image ~= N
%      fprintf(file,'\n');
%   end
%   
% end
% fclose(file);























%% SSH Server Version

%% Train Daytime Data

cd 'E:\nightdepth_data\nightdepth\dataset\train\daytime\left' %add right right after in txt file

data = dir('*.png');
file = fopen('E:\nightdepth_data\nightdepth\datafiles\Oxford_DayTime_Data.txt', 'wt');
N = length(data);

for image = 1:N
   
  text = strcat('/mnt/earth/joseph/dataset/train/daytime/left/', data(image).name, '\n');
  fprintf(file, text);
  text = strcat('/mnt/earth/joseph/dataset/train/daytime/right/', data(image).name);
  fprintf(file, text);
  
  if image ~= N
     fprintf(file,'\n');
  end
  
end
fclose(file);

%% Train Nighttime Data

cd 'E:\nightdepth_data\nightdepth\dataset_nonenhanced\train\nighttime\left_nonenhanced' %add right right after in txt file

data = dir('*.png');
file = fopen('E:\nightdepth_data\nightdepth\datafiles\Oxford_NightTime_Data.txt', 'wt');
N = length(data);

for image = 1:N
    
  text = strcat('/mnt/earth/joseph/dataset/train/nighttime/left/', data(image).name, '\n');
  fprintf(file, text);
  text = strcat('/mnt/earth/joseph/dataset/train/nighttime/right/', data(image).name);
  fprintf(file, text);
  
  if image ~= N
     fprintf(file,'\n');
  end
  
end
fclose(file);

%% Val Nighttime Data

cd 'E:\nightdepth_data\nightdepth\dataset_nonenhanced\val\nighttime\left_nonenhanced' %add right right after in txt file

data = dir('*.png');
file = fopen('E:\nightdepth_data\nightdepth\datafiles\Oxford_NightTime_Data_withGT.txt', 'wt');

cd 'E:\nightdepth_data\nightdepth\dataset\val\nighttime\disp_GT'
dataDisp = dir('*.png');

N = length(data);

for image = 1:N
    
  text = strcat('/mnt/earth/joseph/dataset/val/nighttime/left/', data(image).name, '\n');
  fprintf(file, text);
  text = strcat('/mnt/earth/joseph/dataset/val/nighttime/right/', data(image).name, '\n');
  fprintf(file, text);
  text = strcat('/mnt/earth/joseph/dataset/val/nighttime/disp_GT/', dataDisp(image).name);
  fprintf(file, text);
  
  if image ~= N
     fprintf(file,'\n');
  end
  
end
fclose(file);









