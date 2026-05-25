% =========================================================================
% Wind Tunnel Uncertainty Analysis - Individual Shuttlecock Plots (V = 20)
% =========================================================================
clear; clc; close all;
warning('off', 'MATLAB:exportgraphics:ExportedImageDisplaysAxesToolbar');

%% 1. Setup Parameters
shuttle_ids = 1:9;     % Looping from S1 to S9
V = 20.0;              % Velocity (m/s)

% Define absolute output folder path
output_folder = '/Users/oscarregan/Documents/ARP/MATLAB/Shuttlecock_Plots'; 

% Create the folder if it does not already exist
if ~exist(output_folder, 'dir')
    mkdir(output_folder);
end

% Instrument Constants
instrument_U_drag = 0.01;       % +/- 0.01 N accuracy for load cell
fprintf('--- Starting Individual CSV Analysis (Drag Force) ---\n\n');

%% 2. Batch Process and Plot
for s = shuttle_ids
    % Construct the filename
    filename = sprintf('S%d_V20.csv', s);
    
    % Check if the file exists in the current directory before processing
    if isfile(filename)
        
        % Read the CSV directly as a numeric matrix to avoid Table errors
        force_data = readmatrix(filename);
        
        % Extract the 3rd column (Fz axis)
        force_time_series = abs(force_data(:, 1));
        
        %% --- Calculations ---
        % Statistical Analysis (Type A)
        mean_drag = mean(force_time_series);
        std_drag = std(force_time_series);
        N_samples = length(force_time_series);
        
        % Uncertainty of the mean
        sem_drag = std_drag / sqrt(N_samples);
        
        % Total Uncertainty in Raw Measurements (Type A + Type B)
        U_D = sqrt(sem_drag^2 + instrument_U_drag^2);
        
        % --- UPDATED: Print out the Force and its Standard Uncertainty ---
        fprintf('%s: Mean Force = %.4f +/- %.4f N (Standard Uncertainty)\n', filename, mean_drag, U_D);
        
        %% --- Visualisation ---
        % Create a standard figure for the time series plot.
        fig = figure('Name', sprintf('Analysis for S%d', s), 'Position', [100 + (s*30), 100 + (s*30), 800, 500]);
        
        % Plot the raw data in a light blue colour
        plot(force_time_series, 'Color', [0.25 0.41 0.88 0.8], 'LineWidth', 0.5);
        hold on;
        
        % Overlay mean and standard deviation lines
        yline(mean_drag, 'r', 'LineWidth', 2, 'DisplayName', 'Mean Drag');
        yline(mean_drag + std_drag, 'k--', 'LineWidth', 1.5, 'DisplayName', '+1 Std Dev');
        yline(mean_drag - std_drag, 'k--', 'LineWidth', 1.5, 'DisplayName', '-1 Std Dev');
        
        % Formatting
        title(sprintf('S%d V20 Raw Drag Force (Noise Profile)', s));
        xlabel('Sample Number');
        ylabel('Drag Force (N)');
        legend('Location', 'best');
        grid on;
        
        % Disable the axes toolbar to prevent export warnings 
        ax = gca;
        ax.Toolbar.Visible = 'off';
       
        % Save the figure to the specified absolute folder
        base_filename = sprintf('S%d_V20_analysis.png', s);
        output_filename = fullfile(output_folder, base_filename);
        exportgraphics(fig, output_filename, 'Resolution', 150);
        
    else
        fprintf('Warning: %s not found in directory. Skipping...\n', filename);
    end
end
disp('Batch analysis and plot generation complete!');