% MATLAB Script to Analyse and Compare Shuttlecocks: 10 m/s vs Averaged 20 m/s
% Ensure all 30 CSVs (V10, V20 Run 1, and V20 Run 2) are in your Workspace.

% 1. Define common labels and workspace variables
xLabels = {'S1', 'S2', 'S3', 'S4', 'S5', 'S6', 'S7', 'S8', 'S9', 'S10UP'};

% V10 Variables
varNames10 = {'S1_V10', 'S2_V10', 'S3_V10', 'S4_V10', 'S5_V10', ...
              'S6_V10', 'S7_V10', 'S8_V10', 'S9_V10', 'S10MFUP_V10'};

% V20 Run 1 Variables
varNames20_R1 = {'S1_V20', 'S2_V20', 'S3_V20', 'S4_V20', 'S5_V20', ...
                 'S6_V20', 'S7_V20', 'S8_V20', 'S9_V20', 'S10MFUP_V20'};
             
% V20 Run 2 Variables
varNames20_R2 = {'S1_V20R2', 'S2_V20R2', 'S3_V20R2', 'S4_V20R2', 'S5_V20R2', ...
                 'S6_V20R2', 'S7_V20R2', 'S8_V20R2', 'S9_V20R2', 'S10MFUP_V20R2'};

numShuttles = length(xLabels);

% Pre-allocate arrays with NaN (handles missing data gracefully)
meanDrag10 = NaN(numShuttles, 1); Cd10 = NaN(numShuttles, 1);
meanDrag20_R1 = NaN(numShuttles, 1); Cd20_R1 = NaN(numShuttles, 1);
meanDrag20_R2 = NaN(numShuttles, 1); Cd20_R2 = NaN(numShuttles, 1);

% Constants
rho = 1.225; % Standard air density (kg/m^3)
d = 0.066;   % Shuttlecock skirt diameter (m)
A = pi * (d / 2)^2; % Reference Area (m^2)

disp('--- Processing Shuttlecock Data: 10 m/s vs Averaged 20 m/s ---');

% 2. Process Data for all batches
for i = 1:numShuttles
    % --- Process 10 m/s Batch ---
    try
        data10 = eval(varNames10{i});
        if istable(data10), data10 = table2array(data10); end
        Fx10 = data10(:, 1);
        
        meanDrag10(i) = abs(mean(Fx10(floor(size(Fx10, 1)/2):end)));
        % Calculate Cd using v = 10 m/s (corrected from original file)
        Cd10(i) = (2 * meanDrag10(i)) / (rho * 10^2 * A); 
    catch
        warning('Variable %s not found in workspace.', varNames10{i});
    end
    
    % --- Process 20 m/s Batch (Run 1) ---
    try
        data20_R1 = eval(varNames20_R1{i});
        if istable(data20_R1), data20_R1 = table2array(data20_R1); end
        Fx20_R1 = data20_R1(:, 1);
        
        meanDrag20_R1(i) = abs(mean(Fx20_R1(floor(size(Fx20_R1, 1)/2):end)));
        Cd20_R1(i) = (2 * meanDrag20_R1(i)) / (rho * 20^2 * A); 
    catch
        warning('Variable %s not found in workspace.', varNames20_R1{i});
    end
    
    % --- Process 20 m/s Batch (Run 2) ---
    try
        data20_R2 = eval(varNames20_R2{i});
        if istable(data20_R2), data20_R2 = table2array(data20_R2); end
        Fx20_R2 = data20_R2(:, 1);
        
        meanDrag20_R2(i) = abs(mean(Fx20_R2(floor(size(Fx20_R2, 1)/2):end)));
        Cd20_R2(i) = (2 * meanDrag20_R2(i)) / (rho * 20^2 * A); 
    catch
        warning('Variable %s not found in workspace.', varNames20_R2{i});
    end
end

% 3. Calculate Averages for the 20 m/s runs (ignoring any NaNs)
meanDrag20_Avg = mean([meanDrag20_R1, meanDrag20_R2], 2, 'omitnan');
Cd20_Avg = mean([Cd20_R1, Cd20_R2], 2, 'omitnan');

disp('Processing Complete. Plotting Results...');
disp('---------------------------------------------------------');

% 4. Plotting the Comparison Results
xData = 1:numShuttles;
figure('Name', 'Shuttlecock Aerodynamics: 10 m/s vs Averaged 20 m/s', 'Position', [100, 100, 800, 600]);

% Plot 1: Mean Drag Force Comparison
subplot(2, 1, 1);
hold on;
plot(xData, meanDrag10, '-o', 'Color', [0 0.4470 0.7410], 'LineWidth', 2, ...
    'MarkerFaceColor', [0 0.4470 0.7410], 'DisplayName', '10 m/s');
plot(xData, meanDrag20_Avg, '-d', 'Color', [0.4940 0.1840 0.5560], 'LineWidth', 2, ...
    'MarkerFaceColor', [0.4940 0.1840 0.5560], 'DisplayName', '20 m/s (Averaged)');
hold off;
xticks(xData);
xticklabels(xLabels);
title('Mean Drag Force vs. Shuttlecock Damage');
ylabel('Mean Drag Force (N)');
legend('Location', 'northwest');
grid on;

% Plot 2: Drag Coefficient Comparison
subplot(2, 1, 2);
hold on;
plot(xData, Cd10, '-o', 'Color', [0 0.4470 0.7410], 'LineWidth', 2, ...
    'MarkerFaceColor', [0 0.4470 0.7410], 'DisplayName', '10 m/s');
plot(xData, Cd20_Avg, '-d', 'Color', [0.4940 0.1840 0.5560], 'LineWidth', 2, ...
    'MarkerFaceColor', [0.4940 0.1840 0.5560], 'DisplayName', '20 m/s (Averaged)');
hold off;
xticks(xData);
xticklabels(xLabels);
title('Drag Coefficient (C_D) vs. Shuttlecock Damage');
xlabel('Shuttlecock Specimen (S1 = Least Damage, S10UP = Most Damage)');
ylabel('Drag Coefficient (C_D)');
legend('Location', 'northwest');
grid on;