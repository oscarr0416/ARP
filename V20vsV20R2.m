% MATLAB Script to Plot Hardcoded Data: 10 m/s vs Averaged 20 m/s
% Utilising exact C_D values from the provided V10 output

% 1. Define labels and hardcode the data from the screenshots
xLabels = {'S1', 'S2', 'S3', 'S4', 'S5', 'S6', 'S7', 'S8', 'S9', 'S10UP'};
numShuttles = length(xLabels);
xData = 1:numShuttles;

% --- 10 m/s Data (Exact values from Screenshot 2) ---
meanDrag10 = [0.0096, 0.0139, 0.0163, 0.0634, 0.0145, ...
              0.0757, 0.0159, 0.1160, 0.0173, 0.0120];

Cd10 = [0.0115, 0.0166, 0.0194, 0.0757, 0.0173, ...
        0.0903, 0.0190, 0.1384, 0.0207, 0.0143];

% --- Averaged 20 m/s Data (Exact values from Screenshot 1) ---
meanDrag20_Avg = [0.084163, 0.052893, 0.082016, 0.052795, 0.064943, ...
                  0.080163, 0.046521, 0.120590, 0.066788, 0.063083];
              
Cd20_Avg = [0.10041, 0.063103, 0.097848, 0.062987, 0.077479, ...
            0.095637, 0.055502, 0.143870, 0.079681, 0.075260];

disp('--- Plotting Hardcoded Shuttlecock Data ---');
disp('Note: Utilising exact V10 values provided, with no extra calculations.');

% 2. Plotting the Comparison Results
figure('Name', 'Final Aerodynamics: 10 m/s vs Averaged 20 m/s', 'Position', [100, 100, 800, 600]);

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