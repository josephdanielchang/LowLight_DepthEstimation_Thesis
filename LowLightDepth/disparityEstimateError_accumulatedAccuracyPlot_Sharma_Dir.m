% This code contains two parts
% 1. Calculate Error Between Estimated Disparity and Disparity to Sparse Ground Truth Disparity
% 2. Plot accuracy given disparity estimate errors compared to ground truth

% Requires RobotCar Dataset SDK: https://github.com/ori-mrg/robotcar-dataset-sdk

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% 2021 University of California, San Diego
%
% Authors: 
%  Joseph Chang (jdchang@ucsd.edu)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc, clear

%% Disparity Error Calculation

N = 6000;                            % CHANGE: number of images to run on starting at index 0 ie. 6000
hood_size = 140;                     % rows containing hood in 960x1280
disparity_oldsize = [960,1280];      % output disparity resolution
disparity_newsize = [256,512];       % resized disparity resolution to match ground truth
errorK_normal_accum = zeros(20,1);   % accumulate sum of error at each iteration of N here
errorK_enhanced_accum = zeros(20,1); % accumulate sum of error at each iteration of N here
errorK_normal_avg = zeros(20,1);     % accumulate avg error at each iteration of N here
errorK_enhanced_avg = zeros(20,1);   % accumulate avg error at each iteration of N here
correctK_normal_accum   = 0;        % accumulate sum of correct estimates at each iteration of N here
correctK_enhanced_accum = 0;        % accumulate sum of correct estimates at each iteration of N here
correctK_normal_avg     = 0;        % accumulate avg correct estimates at each iteration of N here
correctK_enhanced_avg   = 0;        % accumulate avg correct estimates at each iteration of N here
nonzero_gt_total_accum = 0;

fileID_n = fopen('C:\Users\josep\OneDrive\Documents\MS Thesis\[Code] Sharma_Low-Light Depth\results\before_modified_net\01_nightdepth_testdata_2\normal_depth_dir_order.txt','r');
fileID_e = fopen('C:\Users\josep\OneDrive\Documents\MS Thesis\[Code] Sharma_Low-Light Depth\results\before_modified_net\01_nightdepth_testdata_2\enhanced_depth_dir_order.txt','r');

for i=0:N
    
    i
    
    timestamp_to_run_n = fgetl(fileID_n);  % changes every run
    index_to_run_n = string(i);            % changes every run
    
    frewind(fileID_e)                      % reset so fgetl reads from first line again
    for j=0:N
        temp_timestamp_to_run_e = fgetl(fileID_e);
        if temp_timestamp_to_run_e == timestamp_to_run_n
            index_to_run_e = string(j);                    % changes every run
            break;
        end
    end
    
    %%Load Disparity and Convert Format
    
    %paths to sparse ground truth, 16-bit disparity estimate, 16-bit enhanced, disparity estimate
    path_gt           = strcat('E:\MSI Backup (121820)\MS Thesis\[Dataset] Oxford RobotCar\2014-11-14-16-34-33_01\stereo\left_disparity_var\',timestamp_to_run_n,'.mat');
    path_est          = strcat('C:\Users\josep\OneDrive\Documents\MS Thesis\[Code] Sharma_Low-Light Depth\results\before_modified_net\01_nightdepth_testdata_2\normal\',index_to_run_n,'\disp_tst.png');
    path_est_enhanced = strcat('C:\Users\josep\OneDrive\Documents\MS Thesis\[Code] Sharma_Low-Light Depth\results\before_modified_net\01_nightdepth_testdata_2\enhanced\',index_to_run_e,'\disp_tst.png'); 

    %load sparse ground truth, 16-bit disparity estimate, 16-bit enhanced, disparity estimate
    D_gt              = load(path_gt);
    D_gt              = D_gt.disparityMapL;
    D_est_16          = imread(path_est);
    D_est_enhanced_16 = imread(path_est_enhanced);
    
    %convert 16-bit to 8-bit
    D_est_8          = D_est_16 / disparity_newsize(1);
    D_est_enhanced_8 = D_est_enhanced_16 / disparity_newsize(1);

    %remove hood area
    D_est_8          = D_est_8(1:end-((hood_size/disparity_oldsize(1))*disparity_newsize(1)), :, :);
    D_est_enhanced_8 = D_est_enhanced_8(1:end-((hood_size/disparity_oldsize(1))*disparity_newsize(1)), :, :);
    D_gt             = D_gt(1:end-((hood_size/disparity_oldsize(1))*disparity_newsize(1)), :, :);

    %resize
    disparityMapL          = imresize(D_est_8, disparity_newsize, 'nearest');
    disparityMapL_enhanced = imresize(D_est_enhanced_8, disparity_newsize, 'nearest');
    D_gt                   = imresize(D_gt, disparity_newsize, 'nearest');

    %round to integers
    disparityGT            = uint16(round(D_gt));
    disparityMapL          = round(disparityMapL);
    disparityMapL_enhanced = round(disparityMapL_enhanced);

    %if sparse ground truth all zeros then skip
    if all(disparityGT == 0)
        continue
    else
        nonzero_gt_total_accum = nonzero_gt_total_accum + 1;
    
        %%Disparity Error Calculation --- calculates average errors at each iteration i

        %calculate error for N
        errorK_estNormal_groundTruth   = nguyen_error(disparityGT, disparityMapL, 20, 0);
        errorK_estEnhanced_groundTruth = nguyen_error(disparityGT, disparityMapL_enhanced, 20, 0);

        %add to accumulated error
        errorK_normal_accum   = errorK_normal_accum + errorK_estNormal_groundTruth;
        errorK_enhanced_accum = errorK_enhanced_accum + errorK_estEnhanced_groundTruth;

        %calculate avg error as error accumulates
        errorK_normal_avg   = (errorK_normal_accum) / nonzero_gt_total_accum;
        errorK_enhanced_avg = (errorK_enhanced_accum) / nonzero_gt_total_accum;

        
        %Correct Estimates Calculation --- calculates average correct at each iteration i
        correctK_estNormal_groundTruth   = nguyen_correct_0(disparityGT, disparityMapL, 0);
        correctK_estEnhanced_groundTruth = nguyen_correct_0(disparityGT, disparityMapL_enhanced, 0);
        
        %add to accumulated correct estimates
        correctK_normal_accum   = correctK_normal_accum + correctK_estNormal_groundTruth;
        correctK_enhanced_accum = correctK_enhanced_accum + correctK_estEnhanced_groundTruth;

        %calculate avg error as error accumulates
        correctK_normal_avg   = (correctK_normal_accum) / nonzero_gt_total_accum;
        correctK_enhanced_avg = (correctK_enhanced_accum) / nonzero_gt_total_accum;
    end
    
end

% save errors in .mat files
save('errorK_normal_avg.mat','errorK_normal_avg')
save('errorK_enhanced_avg.mat','errorK_enhanced_avg')

errorK_normal_avg
errorK_enhanced_avg

fclose(fileID_n);
fclose(fileID_e);

%% Accumulated Accuracy Plots

maxKtoPlot = 11; % plot accumulated accuracy from K=0:maxKtoPlot
x = 1:maxKtoPlot;

% error
error_cumsum_normal   = cumsum(errorK_normal_avg * 100);
error_cumsum_enhanced = cumsum(errorK_enhanced_avg * 100);

% initial accuracy
accuracy_init_normal   = 100 - error_cumsum_normal(end);
accuracy_init_enhanced = 100 - error_cumsum_enhanced(end);

% accuracy
accum_accuracy_normal   = accuracy_init_normal + zeros(1,maxKtoPlot);
accum_accuracy_enhanced = accuracy_init_enhanced + zeros(1,maxKtoPlot);

for i=1:maxKtoPlot-1
    accum_accuracy_normal(i+1) = accum_accuracy_normal(i+1) + error_cumsum_normal(i);
    accum_accuracy_enhanced(i+1) = accum_accuracy_enhanced(i+1) + error_cumsum_enhanced(i);
end

close
figure(1)
plot(x,accum_accuracy_normal,'color','blue','linewidth',1.5); hold on
plot(x,accum_accuracy_enhanced,'color','green','linewidth',1.5); hold on
% ylim([80,100])
title('Disparity Pixel Accumulated Accuracy')
xlabel('K')
ylabel('Percentage Accuracy')
legend('Regular Images', 'Enhanced Images','Location','southeast');

%% Functions

% Returns "bad pixel" error
function disparity_error = bad_pixel_error (D_gt,D_est,tau) % tau: count errors if disparity exceeds [3 pixels, and within 5% of true value]
    E = abs(D_gt-D_est);
    error_count   = length(find(D_gt>tau(1) & E./abs(D_gt)>tau(2)));
    total_count = length(find(D_gt>tau(1)));
    disparity_error = error_count/total_count;
end

% Returns percent pixels that are erroneous from K=0:20
function errorK = nguyen_error (D_gt,D_est,maxK,tau) % lower K has less error

    errorK = zeros(maxK,1);
    for K=1:maxK
        E = abs(D_gt-D_est);
        error_count = length(find(D_gt>tau & E==K));
        total_count = length(find(D_gt>tau));
        error = error_count/total_count;
        
        errorK(K,1) = error;
    end

end

% Returns percent pixels that are 100% correct with K=0
function correctK0 = nguyen_correct_0 (D_gt,D_est,tau) % lower K has less error

    for K=0
        E = abs(D_gt-D_est);
        correct_count = length(find(D_gt>tau & E==K));
        total_count = length(find(D_gt>tau));
        correct = correct_count/total_count;
        
        correctK0 = correct;
    end

end
