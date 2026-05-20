% MATLAB Script to Analyse Multiple Shuttlecocks (S1 to S10) at 20 m/s
% Note: Ensure all 10 CSVs are imported into your Workspace first.

% 1. Define the names of the workspace variables exactly as imported
varNames = {'S1_V20R2', 'S2_V20R2', 'S3_V20R2', 'S4_V20R2', 'S5_V20R2', ...
            'S6_V20R2', 'S7_V20R2', 'S8_V20R2', 'S9_V20R2','S10MFUP_V20R2'};

numShuttles = length(varNames);

% Pre-allocate arrays to store our results
meanDragArray = zeros(numShuttles, 1);
CdArray = zeros(numShuttles, 1);

% Constants for Cd Calculation
rho = 1.225; % Standard air density (kg/m^3)
v = 20;      % Velocity (m/s)
d = 0.066;   % Shuttlecock skirt diameter (m)
A = pi * (d / 2)^2; % Reference Area (m^2)

disp('--- Processing Shuttlecock Batch Data (20 m/s) ---');

% 2. Loop through each shuttlecock dataset
for i = 1:numShuttles
    % Safely retrieve the variable from the workspace
    try
        currentData = eval(varNames{i});
    catch
        warning('Variable %s not found in workspace. Please check your imported names.', varNames{i});
        continue;
    end
    
    % Convert to numeric matrix if it imported as a Table
    if istable(currentData)
        currentData = table2array(currentData);
    end
    
    % Extract Drag Data (Assuming Column 1 is Fx)
    Fx = currentData(:, 1); 
    
    % Calculate Steady-State Mean Drag from the second half of the data
    numPoints = size(Fx, 1);
    halfIdx = floor(numPoints / 2);
    meanDrag = mean(Fx(halfIdx:end));
    
    % Store the absolute mean drag and calculate Cd
    meanDragArray(i) = abs(meanDrag);
    CdArray(i) = (2 * meanDragArray(i)) / (rho * v^2 * A);
    
    % Print individual results to the Command Window
    fprintf('Processed %-15s | Mean Drag: %.4f N | Cd: %.4f\n', varNames{i}, meanDragArray(i), CdArray(i));
end
disp('----------------------------------------------------');

% 3. Plotting the Comparison Results
% Create clean labels for the x-axis
xLabels = {'S1', 'S2', 'S3', 'S4', 'S5', 'S6', 'S7', 'S8', 'S9','S10UP'};
xData = 1:numShuttles;

figure('Name', 'Shuttlecock Aerodynamic Degradation at 20 m/s Run 2', 'Position', [100, 100, 800, 600]);

% Plot 1: Mean Drag Force Comparison
subplot(2, 1, 1);
plot(xData, meanDragArray, '-o', 'Color', [0 0.4470 0.7410], 'LineWidth', 2, 'MarkerFaceColor', [0 0.4470 0.7410]);
xticks(xData);
xticklabels(xLabels);
title('Mean Drag Force vs. Shuttlecock Damage (20 m/s)');
ylabel('Mean Drag Force (N)');
grid on;

% Plot 2: Drag Coefficient Comparison
subplot(2, 1, 2);
plot(xData, CdArray, '-s', 'Color', [0.8500 0.3250 0.0980], 'LineWidth', 2, 'MarkerFaceColor', [0.8500 0.3250 0.0980]);
xticks(xData);
xticklabels(xLabels);
title('Drag Coefficient (C_D) vs. Shuttlecock Damage (20 m/s)');
xlabel('Shuttlecock Specimen (S1 = Least Damage, S10 = Most Damage)');
ylabel('Drag Coefficient (C_D)');
grid on;