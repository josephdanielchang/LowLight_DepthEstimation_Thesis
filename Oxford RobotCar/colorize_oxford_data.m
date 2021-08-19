% Convert Raw Oxford Image Data into RGB Image Data

%% Load timestamps, LUT, image files, calculate number of image files

clc, clear

timestamps = dlmread('C:\Users\josep\OneDrive\Documents\MS Thesis\[Dataset] Oxford RobotCar\2014-07-14-14-49-50_03\stereo.timestamps');
[ ~, ~, ~, ~, ~, LUT] = ReadCameraModel( ...
'C:\Users\josep\OneDrive\Documents\MS Thesis\[Dataset] Oxford RobotCar\2014-07-14-14-49-50_03\stereo\right', ...
'C:\Users\josep\OneDrive\Documents\MS Thesis\[Dataset] Oxford RobotCar\camera-models');
imageFiles = dir('C:\Users\josep\OneDrive\Documents\MS Thesis\[Dataset] Oxford RobotCar\2014-07-14-14-49-50_03\stereo\right\*.png');
fileCount = length(imageFiles);

%% Find first timestamp index for sub-dataset (i.e 01, 02, 03)

startIndex = find(timestamps(:,1) == str2double(imageFiles(1).name(1:end-4)));
endIndex = startIndex+fileCount;

%% Convert to RGB Images and Save

for i=1:fileCount
    
    trueIndex = i + startIndex;
    
    savepath = strcat(imageFiles(i).folder,'_color\',imageFiles(i).name);
    image = LoadImage(imageFiles(i).folder, timestamps(trueIndex,1), LUT);
%     figure(i)
%     imshow(image)
    imwrite(image, savepath);
    i
end

%% Display Single Input Raw Image
% 
% i=1800;
% 
% path = ['\', imageFiles(i).folder, '\', num2str(timestamps(i,1)), '.png'];
% image = imread(path);
% 
% figure
% imshow(image)

%% Display Single Output RGB Image
% 
% i=1800;
% image = LoadImage(imageFiles(i).folder, timestamps(i,1), LUT);
% figure(i)
% imshow(image)


