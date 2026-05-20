% MATLAB Script to Analyse Shuttlecock Wind Tunnel Data
% Data Source: S1_V20 workspace variable

% 1. Assign columns to variables from the imported workspace matrix.
% IMPORTANT: Verify which axis aligns with your freestream flow (Drag)
% Assuming: Col 1-3 = Fx, Fy, Fz (N) and Col 4-6 = Mx, My, Mz (Nm)
Fx = S1_V20(:, 1); 
Fy = S1_V20(:, 2); 
Fz = S1_V20(:, 3); 
Mx = S1_V20(:, 4); 
My = S1_V20(:, 5); 
Mz = S1_V20(:, 6);

% Create a time vector based on the 10,000 Hz sampling rate
fs = 10000; % Sampling frequency in Hz
t = (0:length(Fx)-1)' / fs;

% 2. Filter the Data
% Utilise a convolution to smooth the 10kHz mechanical noise safely
% A window of 1000 points equates to 0.1 seconds of data averaging
windowSize = 1000; 
Fx_filtered = conv(Fx, ones(windowSize,1)/windowSize, 'same');

% 3. Calculate Time-Averaged Forces
% Taking the mean of the latter half of the data to ensure steady-state 
% readings, avoiding any initial startup transients in the tunnel.
halfIdx = floor(length(Fx) / 2);
meanDrag = mean(Fx(halfIdx:end)); % Assuming Fx is the drag axis

% 4. Calculate Drag Coefficient (C_D)
rho = 1.225; % Standard air density in kg/m^3 (update with your lab conditions)
v = 20;      % Velocity in m/s (from V20)

% Typical shuttlecock skirt diameter is ~66mm
d = 0.066; 
A = pi * (d / 2)^2; % Reference area in m^2

% Compute Cd (using absolute value in case the drag axis reads negatively)
Cd = (2 * abs(meanDrag)) / (rho * v^2 * A);

% Output results to the command window
fprintf('Steady-State Mean Drag Force: %.4f N\n', abs(meanDrag));
fprintf('Calculated Drag Coefficient (Cd): %.4f\n', Cd);

% 5. Visualise the Results
figure;
plot(t, Fx, 'Color', [0.7 0.7 0.7]); % Plot raw noise in light grey
hold on;
plot(t, Fx_filtered, 'b', 'LineWidth', 1.5); % Plot smoothed data in blue
yline(meanDrag, 'r--', 'LineWidth', 1.5); % Plot the mean steady-state line
hold off;

title('Shuttlecock Drag Force over Time (S1 at 20 m/s)');
xlabel('Time (s)');
ylabel('Drag Force (N)');
legend('Raw 10kHz Data', 'Filtered Data (Convolution)', 'Steady-State Mean');
grid on;