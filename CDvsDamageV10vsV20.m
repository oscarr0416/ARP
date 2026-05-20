% MATLAB Script to Analyse and Compare Shuttlecocks at 10 m/s and 20 m/s
% Ensure all 20 CSVs are imported into your Workspace first.

% 1. Define common labels and workspace variables
xLabels = {'S1', 'S2', 'S3', 'S4', 'S5', 'S6', 'S7', 'S8', 'S9', 'S10UP'};

% V10 and V20 variable names aligned to the 10 matching specimens
varNames10 = {'S1_V10', 'S2_V10', 'S3_V10', 'S4_V10', 'S5_V10', ...
              'S6_V10', 'S7_V10', 'S8_V10', 'S9_V10', 'S10MFUP_V10'};
          
varNames20 = {'S1_V20', 'S2_V20', 'S3_V20', 'S4_V20', 'S5_V20', ...
              'S6_V20', 'S7_V20', 'S8_V20', 'S9_V20', 'S10MFUP_V20'};

numShuttles = length(xLabels);

% Pre-allocate arrays with NaN (so missing data doesn't plot as zero)
meanDrag10 = NaN(numShuttles, 1); Cd10 = NaN(numShuttles, 1);
meanDrag20 = NaN(numShuttles, 1); Cd20 = NaN(numShuttles, 1);

% Constants
rho = 1.225; % Standard air density (kg/m^3)
d = 0.066;   % Shuttlecock skirt diameter (m)
A = pi * (d / 2)^2; % Reference Area (m^2)

disp('--- Processing Shuttlecock Batch Data ---');

% 2. Process Data for both velocities
for i = 1:numShuttles
    % --- 10 m/s Batch ---
    try
        data10 = eval(varNames10{i});
        if istable(data10), data10 = table2array(data10); end
        Fx10 = data10(:, 1);
        
        % Calculate Steady-State Mean Drag from the second half
        meanDrag10(i) = abs(mean(Fx10(floor(size(Fx10, 1)/2):end)));
        Cd10(i) = (2 * meanDrag10(i)) / (rho * 10^2 * A); % Corrected to v = 10
    catch
        warning('Variable %s not found in workspace.', varNames10{i});
    end
    
    % --- 20 m/s Batch ---
    try
        data20 = eval(varNames20{i});
        if istable(data20), data20 = table2array(data20); end
        Fx20 = data20(:, 1);
        
        meanDrag20(i) = abs(mean(Fx20(floor(size(Fx20, 1)/2):end)));
        Cd20(i) = (2 * meanDrag20(i)) / (rho * 20^2 * A);
    catch
        warning('Variable %s not found in workspace.', varNames20{i});
    end
end
disp('Processing Complete.');
disp('-----------------------------------------');

% 3. Plotting the Comparison Results
xData = 1:numShuttles;
figure('Name', 'Shuttlecock Aerodynamic Comparison: 10 m/s vs 20 m/s', 'Position', [100, 100, 800, 600]);

% Plot 1: Mean Drag Force Comparison
subplot(2, 1, 1);
hold on; % Retain the current plot so the next line is added to it
plot(xData, meanDrag10, '-o', 'Color', [0 0.4470 0.7410], 'LineWidth', 2, 'MarkerFaceColor', [0 0.4470 0.7410], 'DisplayName', '10 m/s');
plot(xData, meanDrag20, '-s', 'Color', [0.8500 0.3250 0.0980], 'LineWidth', 2, 'MarkerFaceColor', [0.8500 0.3250 0.0980], 'DisplayName', '20 m/s');
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
plot(xData, Cd10, '-o', 'Color', [0 0.4470 0.7410], 'LineWidth', 2, 'MarkerFaceColor', [0 0.4470 0.7410], 'DisplayName', '10 m/s');
plot(xData, Cd20, '-s', 'Color', [0.8500 0.3250 0.0980], 'LineWidth', 2, 'MarkerFaceColor', [0.8500 0.3250 0.0980], 'DisplayName', '20 m/s');
hold off;
xticks(xData);
xticklabels(xLabels);
title('Drag Coefficient (C_D) vs. Shuttlecock Damage');
xlabel('Shuttlecock Specimen (S1 = Least Damage, S10UP = Most Damage)');
ylabel('Drag Coefficient (C_D)');
legend('Location', 'northwest');
grid on;