% Uses Kris Gibson's defogging method

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% 2020 University of California, San Diego
%
% Contributor: 
%  Joseph Chang (jdchang@ucsd.edu)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all
clear, clc

%input = 'C:\Users\josep\OneDrive\Documents\MS Thesis\[Dataset] Oxford RobotCar\2014-12-10-18-10-50_03\stereo\left_color\';
%input = 'C:\Users\josep\OneDrive\Documents\MS Thesis\[Code] YOLOv4\Berkeley_Deep_Drive Data_42\ground_truth\images\';
%input = 'C:\Users\josep\OneDrive\Documents\MS Thesis\[Code] YOLOv4\Berkeley_Deep_Drive Data_8k\ground_truth\images\';
input = 'C:\Users\josep\OneDrive\Documents\MS Thesis\[Code] Gibson_Defogging\Dark Images\';
f = dir([input,'*.png']);
% f = dir([input,'*.jpg']);
f = f(1:end);
N = length(f);
ksc = 0.07;
w = 0.9;

for i = 1:10000
    tic
    % Load nighttime image
    image_night = imread([input, f(i).name]);
    image_night = im2double(image_night);
    
    image_yuv = rgb2ycbcr(image_night);
    
    % Invert image
    lum_invert = 1 - image_yuv(:,:,1);
    image_yuv(:,:,1) = lum_invert;
    image_day = ycbcr2rgb(image_yuv);
%     figure, imshow(image_day), title('image-day')
    
    % Preserves color, can remove
    imr = sqrt(image_day);
    
    % Defogging
    % Estimate the desired kernel size based on selected mean square error in estimating noise
    K = WienerGetKSize(image_day);
    fprintf('Window size is %d x %d\n', K, K);
    % Formulate the choice of kernal size and noise map
    [tw, aw] = drk_prior_wdcp(imr, K, w);
    [xw2, tw2, aw2] = ApplyWDCP2Step(imr, w, K);
    [tm, am] = drk_prior_mdcp(image_day, round(K/2), w);
    
    xm = recover(image_day, tm, am);
    [~, tt] = visibresto(image_day, round(K/2));
    xt = recover(image_day, tt, am);
    xw = recover(imr, tw, aw);
    
%     % Plot in-between steps
%     figure, imshow([image_night xt xw xw2]), title('Orig, Visib., W1, W2')
     
%     % Reduce noise
%     xw2_denoise1 = imguidedfilter(xt);
%     xw2_denoise2 = imguidedfilter(xw);
%     xw2_denoise3 = imguidedfilter(xw2);
%     figure, imshow([image_night,xw2_denoise1,xw2_denoise2,xw2_denoise3]), title('Denoised Orig, Visib., W1, W2')
     
    % Convert back to nighttime image
    xw2_yuv = rgb2ycbcr(xw2);
    xw2_yuv(:,:,1) = 1 - xw2_yuv(:,:,1);
	xw2_night = ycbcr2rgb(xw2_yuv);
    
%     % Plot enhanced image
%     figure, imshow(xw2_night), title('xw2-night');
    
    %output_path = ['C:\Users\josep\OneDrive\Documents\MS Thesis\[Dataset] Oxford RobotCar\2014-12-10-18-10-50_03\stereo\left_enhanced\', f(i).name(1:end-4), '_enhanced.png'];
    %output_path = ['C:\Users\josep\OneDrive\Documents\MS Thesis\[Code] YOLOv4\Berkeley_Deep_Drive Data_42\ground_truth\images_enhanced\', f(i).name(1:end-4), '.jpg'];
    %output_path = ['C:\Users\josep\OneDrive\Documents\MS Thesis\[Code] YOLOv4\Berkeley_Deep_Drive Data_8k\ground_truth\images_enhanced\', f(i).name(1:end-4), '.jpg'];
    output_path = ['C:\Users\josep\OneDrive\Documents\MS Thesis\[Code] Gibson_Defogging\Dark Images Enhanced\', f(i).name(1:end-4), '.png'];
    imwrite(xw2_night, output_path);
    toc
    i
end
