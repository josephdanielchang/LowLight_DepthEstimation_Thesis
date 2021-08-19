%% Calculate Sparse Ground Truth Disparity Map using Sparse LIDAR onto Left Stereo Image

% Requires RobotCar Dataset SDK: https://github.com/ori-mrg/robotcar-dataset-sdk
% Place this file in matlab directory

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% 2020 University of California, San Diego
%
% Authors: 
%  Joseph Chang (jdchang@ucsd.edu)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% LIDAR-based Sparse Depth Map onto Left Stereo Image

clc, clear

root_path = 'C:\Users\josep\OneDrive\Documents\MS Thesis\[Dataset] Oxford RobotCar\';

image_dir      = fullfile(root_path, '2014-11-14-16-34-33_01\stereo\left');
laser_dir      = fullfile(root_path, '2014-11-14-16-34-33_01\lms_front');
ins_file       = fullfile(root_path, '2014-11-14-16-34-33_01\gps\ins.csv');
models_dir     = fullfile(root_path, 'robotcar-dataset-sdk-master\models');
extrinsics_dir = fullfile(root_path, 'robotcar-dataset-sdk-master\extrinsics');
timestamp_file = fullfile(root_path, '2014-11-14-16-34-33_01\stereo.timestamps');

imageFiles = dir('C:\Users\josep\OneDrive\Documents\MS Thesis\[Dataset] Oxford RobotCar\2014-11-14-16-34-33_01\stereo\left\*.png');
imageCount = length(imageFiles);

%%%%%%%%%%%%%%%%%%%%%%%%%%% OPTIONS TO CHANGE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
indices_to_run = 1:imageCount;       % to run all images    - 1:imageCount
                                     % to run one image     - 2500
                                     
timestamp_run    = false;            % toggle to run one timestamp
timestamp_to_run = 1415985267561730; % to run one timestamp - 1415985129080465

baseline = 0.24;                     % baseline in meters for Bumblebee BBX3

remove_hood = true;                  % toggle to remove hood
hood_size = 140;                     % rows containing hood

disparity_resize = true;             % toggle to resize disparity
disparity_newsize = [256,512];       % new disparity resolution

plot_lidar_on_rgb    = false;        % toggle to plot lidar overlayed on rgb
plot_disparity       = false;        % toggle to plot disparity          
save_disparity_var   = true;         % toggle to save as var
save_disparity_image = false;        % toggle to save as image
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if timestamp_run
    indices_to_run = 1;
end

for timestamp_index = indices_to_run 

    timestamps = dlmread(timestamp_file);
    
    image_timestamp = timestamps(timestamp_index,1);
    if timestamp_run
        image_timestamp = timestamp_to_run;
    end
    
    % 1) Retrieve depth map coordinates and values, ‘uv’ stores the coordinates, ‘colours’ stores ground truth depth values
    [image,fx,uv,colours] = ProjectLaserIntoCamera(image_dir, laser_dir, ins_file, models_dir, extrinsics_dir, image_timestamp, plot_lidar_on_rgb);

    % 2) Retrieve horizontal (x-axis) focal length of left/right stereo camera 
    [fx, fy, cx, cy, G_camera_image, LUT] = ReadCameraModel(image_dir, models_dir);

    % 3) Convert depth to disparity
    disparity = (fx * baseline)./colours; % d(in pxs) = f(in pxs) * b(in meters) / z(in meters)

    % Generate disparity map
    imageOrigL = image; 
    disparityMapOrigL = zeros(size(imageOrigL,1), size(imageOrigL,2));
    for n=1:numel(disparity)
        disparityMapOrigL(round(uv(n,2)), round(uv(n,1))) = disparity(n);
    end

    % 4) Post-processing
    % Cropping: manually remove "hood" area (~140 rows from the end)
    disparityMapL = disparityMapOrigL(1:end-hood_size, :, :);
    if remove_hood == false
        disparityMapL = disparityMapOrigL;
    end
        
    % Resizing
    disparity_presize = size(disparityMapL);
    if disparity_resize
        % Create new disparity map with new size
        disparityMapL = imresize(disparityMapL, disparity_newsize, 'nearest');
        % Adjust disparity as per the new width
        disparityMapL = disparityMapL ./ (disparity_presize(2)/disparity_newsize(2));
    end

    %% Display disparity output

    if plot_disparity
        figure, imshow(disparityMapL,[]);
    end
   
    %% Save disparity output as variable
    
    if save_disparity_var
        filename = imageFiles(timestamp_index).name;
        savepath = strcat(root_path,'2014-11-14-16-34-33_01\stereo\left_disparity_var\',filename(1:end-4),'.mat');
        save(savepath, 'disparityMapL');
    end
        
    %% Save disparity output as image
    
    if save_disparity_image
        savepath = strcat(root_path,'2014-11-14-16-34-33_01\stereo\left_disparity_img\',imageFiles(timestamp_index).name);
        imwrite(disparityMapL, savepath);
    end
    
end
