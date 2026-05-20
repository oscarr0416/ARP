
clear; clc; close all;

% ==========================================
% [PART 1] THEORETICAL MODELLING
% ==========================================

DamageIndex = 1:10; % Range of damage

BaseRadius = 0.12; % Intact turnover radius (metres)
TurnoverRadius_Theory = BaseRadius + 0.008 * (DamageIndex.^2);

Cd_Theory = BaseCd - 0.025 * DamageIndex - 0.001 * (DamageIndex.^2);

% 3. Velocity / Deceleration Profile (Simulated Flight)
% Simulating how 3 different shuttles decelerate over 1 second.
t = linspace(0, 1, 100);
v0 = 40; % Initial velocity (m/s)
mass = 0.0052; % kg
rho = 1.225; % Air density (kg/m^3)
Area = pi * (0.065/2)^2; % Reference area of skirt

% Function to calculate velocity over time given a Cd
% v(t) = v0 / (1 + (rho * A * Cd * v0 / 2m) * t)
calc_v = @(cd_val) v0 ./ (1 + (rho * Area * cd_val * v0 / (2 * mass)) * t);

v_intact = calc_v(Cd_Theory(1));  % DI 1
v_med    = calc_v(Cd_Theory(5));  % DI 5
v_broken = calc_v(Cd_Theory(10)); % DI 10

% Calculate Drag Force (Fd = 0.5 * rho * v^2 * Cd * A)
fd_intact = 0.5 * rho * (v_intact.^2) * Cd_Theory(1) * Area;
fd_broken = 0.5 * rho * (v_broken.^2) * Cd_Theory(10) * Area;


% ==========================================
% [PART 2] PLOTTING THE PREDICTIONS
% ==========================================
colours = lines(3); % Standard MATLAB colours

figure('Name', 'Theoretical Predictions', 'Color', 'w', 'Position', [100, 100, 900, 700]);

% --- GRAPH 1: Turnover Radius Degradation ---
subplot(2, 2, 1); hold on;
plot(DamageIndex, TurnoverRadius_Theory, 'k-o', 'LineWidth', 2, 'MarkerFaceColor', 'k');
title('Predicted Turnover Radius Degradation');
xlabel('Damage Index');
ylabel('Turnover Radius (m)');
grid on;

% --- GRAPH 2: Drag Coefficient vs Damage ---
subplot(2, 2, 2); hold on;
plot(DamageIndex, Cd_Theory, 'b-o', 'LineWidth', 2, 'MarkerFaceColor', 'b');
title('Predicted Drag Coefficient (C_D) Drop');
xlabel('Damage Index');
ylabel('Drag Coefficient (C_D)');
grid on;

% --- GRAPH 3: Velocity Profile (Deceleration) ---
subplot(2, 2, 3); hold on;
plot(t, v_intact, 'LineWidth', 2, 'Color', colours(1,:), 'DisplayName', 'DI 1 (Intact)');
plot(t, v_med, 'LineWidth', 2, 'Color', colours(2,:), 'DisplayName', 'DI 5 (Moderate)');
plot(t, v_broken, 'LineWidth', 2, 'Color', colours(3,:), 'DisplayName', 'DI 9 (Broken)');
title('Predicted Flight Deceleration');
xlabel('Time (s)');
ylabel('Velocity (m/s)');
legend('Location', 'northeast');
grid on;

% --- GRAPH 4: Drag Force over Time ---
subplot(2, 2, 4); hold on;
plot(t, fd_intact, 'LineWidth', 2, 'Color', colours(1,:), 'DisplayName', 'DI 1 (High Drag)');
plot(t, fd_broken, 'LineWidth', 2, 'Color', colours(3,:), 'DisplayName', 'DI 9 (Low Drag)');
title('Aerodynamic Braking Force');
xlabel('Time (s)');
ylabel('Drag Force (Newtons)');
legend('Location', 'northeast');
grid on;

% Add a super title to the figure
sgtitle('Hypothesis Models: Aerodynamic Degradation of Shuttlecocks', 'FontSize', 14, 'FontWeight', 'bold');