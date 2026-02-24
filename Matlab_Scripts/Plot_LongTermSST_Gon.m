
% Plot the SST temperatures

% Set the directory path
dir_path = '/Users/gonzaloprb/Documents/AAASea_Science/AAA_Post_Doc_Alex_Wyatt/Hong_Kong_2024_Bleaching/Environmental_Data/Satellite_SST/';


% Open the SST
load([dir_path,'HongKong_CoralTemp_0p25deg.mat'])

% Transform to datetime
SSTt = datetime(SSTt, 'ConvertFrom', 'datenum');


figure;
plot(SSTt, SST, 'k', 'LineWidth', 0.8);
xlabel('Time (years)');
ylabel('Temperatures (ºC)');

% Add horizontal lines
% yline(28.6656, '--', 'Color', [0.5 0.5 0.5], 'LineWidth', 1); % Grey dashed line
yline(28.6656 + 1, '--r', 'LineWidth', 1.5); % Red dashed line
% Add text labels near the lines
% text(min(SSTt), 28.6656, ' Monthly Maximum Mean', 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'left', 'Color', [0.5 0.5 0.5], 'FontWeight', 'bold');
text(min(SSTt), 28.6656 + 1, ' Bleaching Threshold', ...
    'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'left', ...
    'Color', 'r', 'FontWeight', 'bold');
grid on;


% Make the figure and save with more aesthetic
figure;
set(gcf, 'Units', 'centimeters', 'Position', [0 0 50 16]);
set(gcf, 'PaperUnits', 'centimeters', 'PaperSize', [50 16]);

plot(SSTt, SST, 'k', 'LineWidth', 0.8);
xlabel('Years');
ylabel('Temperatures (ºC)');

% Add bleaching threshold line
threshold = 28.6656 + 1;
yline(threshold, '--r', 'LineWidth', 1.5); 

% Label the threshold
text(min(SSTt), threshold, ' Bleaching Threshold', ...
    'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'left', ...
    'Color', 'r', 'FontWeight', 'bold');

% Find where SST exceeds the threshold
aboveThreshold = SST > threshold;
crossings = find(diff(aboveThreshold) == 1); % Points where SST crosses above threshold

% Add downward arrows at crossing points
hold on;
for i = 1:length(crossings)
    idx = crossings(i);
    text(SSTt(idx), threshold + 1.7, '↓', ... % Arrow is slightly above threshold
        'Color', 'r', 'FontSize', 12, 'FontWeight', 'bold', ...
        'HorizontalAlignment', 'center');
end
hold off;
grid on;

% Change dir_path
dir_path = '/Users/gonzaloprb/Documents/AAASea_Science/AAA_Post_Doc_Alex_Wyatt/Hong_Kong_2024_Bleaching/Environmental_Data/Satellite_SST/Figure_Outputs_HK/';
% Save as FIG
fig_path = fullfile(dir_path, 'Satellite_SST_plot.fig');
savefig(fig_path);




% Produce Sup Fig 1 with annual duration of SST > BT

% Calculate annual duration where SST > Bleaching Threshold
years = year(SSTt);
unique_years = unique(years);
annual_duration = zeros(size(unique_years));

for i = 1:length(unique_years)
    year_mask = years == unique_years(i);
    annual_duration(i) = sum(SST(year_mask) > threshold);
end

% Create the duration plot figure
figure;
set(gcf, 'Units', 'centimeters', 'Position', [0 0 50 16]);
set(gcf, 'PaperUnits', 'centimeters', 'PaperSize', [50 16]);

bar(unique_years, annual_duration, 'FaceColor', [0.5 0.5 0.5], 'EdgeColor', 'none');
xlabel('Time (Years)');
ylabel('Annual duration SST > BT (Days)');

% Set x-axis ticks to show decades
xticks(1985:5:2025);
xlim([1985 2025]); % Add some padding on both sides

grid on;

% Save this figure
duration_fig_path = fullfile(dir_path, 'S1.Annual_duration_SST_above_BT.fig');
savefig(duration_fig_path);










