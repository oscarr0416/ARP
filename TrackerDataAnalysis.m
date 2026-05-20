% ==========================================
% [STEP 1] IMPORT DATA & DEFINE FUNCTIONS
% ==========================================
filename = 'Tracker Data.csv'; 

% Make sure the file exists
if ~isfile(filename)
    error('File not found. Ensure the CSV is in the current folder.');
end

data = readmatrix(filename, 'NumHeaderLines', 2);
extract_data = @(cols) data(~any(isnan(data(:, cols)), 2), cols);


net_start_cols = [29, 33, 38, 43, 48, 53, 58, 63, 68, 73]; 
di_results = zeros(10, 1);

figure('Name', 'Net Shot Trajectories', 'Color', 'w', 'Position', [150, 150, 800, 500]); 
hold on;

colours = turbo(10); 
fprintf('--- NET SHOT TURNOVER RADII ---\n');

for i = 1:10
    start_col = net_start_cols(i);
    net_data = extract_data([start_col, start_col+1, start_col+2]);
    
    if isempty(net_data) || size(net_data, 1) < 5
        fprintf('S%d: Insufficient Data\n', i);
        continue;
    end
    
    t = net_data(:,1); 
    x = net_data(:,2); 
    y = net_data(:,3);
    
    % Normalise trajectories to start at (0,0) and move left-to-right
    if x(end) < x(1)
        x = -x; 
    end
    x = x - x(1); 
    y = y - y(1);
    
    % 2. Smooth the Tracker noise to reveal the true ballistic arc
    x_smooth = smoothdata(x, 'gaussian', 3);
    y_smooth = smoothdata(y, 'gaussian', 3);
    
    % Find Apex and Calculate Turnover Radius
    [max_y, apex_idx] = max(y_smooth);
    apex_x = x_smooth(apex_idx);
    
    % Turnover Radius defined as horizontal distance from apex to end of flight path
    turnover_radius = abs(x_smooth(end) - apex_x); 
    di_results(i) = turnover_radius;
    
    fprintf('S%d: %.3f units\n', i, turnover_radius);
    
    % Legend Annotation
    if i == 1 || i == 3
        display_name = sprintf('S%d (Hit Net)', i);
    else
        display_name = sprintf('S%d', i);
    end
    
    % Plot Smoothed Trajectory
    plot(x_smooth, y_smooth, 'Color', colours(i,:), 'LineWidth', 1.5, 'DisplayName', display_name);
    
    % Mark the Apex with a triangle
    plot(apex_x, max_y, 'v', 'Color', colours(i,:), 'MarkerFaceColor', colours(i,:), 'HandleVisibility', 'off');
    
    % 3. Visualise the metric: Draw a line showing the turnover radius for S1 and S8
    if i == 1 || i == 8
        plot([apex_x, x_smooth(end)], [max_y, max_y], '--', 'Color', [colours(i,:) 0.6], 'HandleVisibility', 'off');
        plot([x_smooth(end), x_smooth(end)], [max_y, y_smooth(end)], ':', 'Color', [colours(i,:) 0.6], 'HandleVisibility', 'off');
    end
end

title('Net Shot Trajectories (Smoothed & Normalised)');
xlabel('Horizontal Distance (m)'); ylabel('Vertical Height (m)');
legend('Location', 'eastoutside'); grid on; axis equal;

% --- PLOT DEGRADATION CURVE ---
figure('Name', 'Performance Degradation', 'Color', 'w', 'Position', [200, 200, 700, 400]);
hold on;

%  Anomoly
b = bar(1:10, di_results, 'FaceColor', 'flat');
b.CData = repmat([0.6 0.7 0.8], 10, 1); % Muted slate blue for all bars
b.CData(8, :) = [0.8 0.2 0.2];          % Distinct red for the S8 Anomaly

% Add a non-linear trendline
valid_idx = find(di_results > 0);
plot(valid_idx, di_results(valid_idx), 'k--o', 'LineWidth', 1.5, 'DisplayName', 'Degradation Trend');

title('Impact of Structural Damage on Turnover Radius');
xlabel('Shuttlecock Specimen');
ylabel('Turnover Radius (m)');
xticks(1:10);
xticklabels({'S1', 'S2', 'S3 (Net)', 'S4', 'S5', 'S6', 'S7', 'S8', 'S9', 'S10'});
%legend('Location', 'northwest');
grid on;