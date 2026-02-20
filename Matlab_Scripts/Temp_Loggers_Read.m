%Plots of temp loggers
%Gonzalo 29/05/2024


clear all
close all


% Seabirds first
sb_path = '/Users/gonzaloprb/Documents/AAASea_Science/Publications/HongKong_Bleaching_Oceanography/Data/Environment/Fixed_Temp_Loggers/SBE/';


% Open and extract the data

% Open Tung Ping Chau HKS01 at 3 m
TPC3_sb = load([sb_path,'SBE56_HKS01_BTM_3_20201104_20241106.mat']);

% Display the variables in the .mat file
disp(TPC3_sb);

% Extract the data directly creating a Datatable
% Create a table
TPC3_sb_dataTable = table(TPC3_sb.Time, TPC3_sb.Temp, ...
    'VariableNames', {'Date_Time', 'Temperature'});

% Transform to datetime
TPC3_sb_dataTable.Date_Time = datetime(TPC3_sb_dataTable.Date_Time, 'ConvertFrom', 'datenum');



% Make the plot
figure; hold on;
plot (TPC3_sb_dataTable.Date_Time, TPC3_sb_dataTable.Temperature, 'r')
xlim([datetime('2020-09-01'), datetime('2024-08-10')]);
xlabel ('Time')
ylabel ('Temperatures (ºC)')
title ('Tung Ping Chau (Logger at 3 m)')




% Important! The Extraction for DHDs is below


% Filter a plot just for Summer 2024 and add a line

% Plot
figure (2); hold on;
plot (TPC3_sb_dataTable.Date_Time, TPC3_sb_dataTable.Temperature, 'r')
xlim([datetime('2024-06-01'), datetime('2024-08-10')]);
xlabel ('Time')
ylabel ('Temperatures (ºC)')
title ('Tung Ping Chau (Logger at 3 m), Summer 2024')

% Add a line with HK bleaching threshold
yline(29.7, '--r', 'LineWidth', 2);
text(29.7, 30, 'BT SST', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle','Color', 'red');


% Obtain max temperatures for 2022 and 2024
% Extract year from Date_Time
dates = datetime(TPC3_sb_dataTable.Date_Time, 'InputFormat', 'dd-MMM-yyyy HH:mm:ss');
years = year(dates);

% Find max temperature and corresponding date for 2022
temp2022 = TPC3_sb_dataTable.Temperature(years == 2022);
dates2022 = dates(years == 2022);
[max2022, idx2022] = max(temp2022);
maxDate2022 = dates2022(idx2022);

% Find max temperature and corresponding date for 2024
temp2024 = TPC3_sb_dataTable.Temperature(years == 2024);
dates2024 = dates(years == 2024);
[max2024, idx2024] = max(temp2024);
maxDate2024 = dates2024(idx2024);

% Display results
fprintf('Maximum Temperature:\n');
fprintf('2022: %.2f°C on %s\n', max2022, datestr(maxDate2022, 'dd-mmm-yyyy HH:MM:SS'));
fprintf('2024: %.2f°C on %s\n', max2024, datestr(maxDate2024, 'dd-mmm-yyyy HH:MM:SS'));




% Extract the other Seabirds


% Open Bluf HKS18 at 5 m
BI5_sb = load([sb_path,'SBE56_HKS18_BTM_5_20201118_20241105.mat']);

% Display the variables in the .mat file
disp(BI5_sb);

% Extract the data directly creating a Datatable
% Create a table
BI5_sb_dataTable = table(BI5_sb.Time, BI5_sb.Temp, ...
    'VariableNames', {'Date_Time', 'Temperature'});

% Transform to datetime
BI5_sb_dataTable.Date_Time = datetime(BI5_sb_dataTable.Date_Time, 'ConvertFrom', 'datenum');


% The code and extraction for the DHDs BI 5 m is below

% Obtain max temperatures for 2022 and 2024
% Extract year from Date_Time
dates = datetime(BI5_sb_dataTable.Date_Time, 'InputFormat', 'dd-MMM-yyyy HH:mm:ss');
years = year(dates);

% Find max temperature and corresponding date for 2022
temp2022 = BI5_sb_dataTable.Temperature(years == 2022);
dates2022 = dates(years == 2022);
[max2022, idx2022] = max(temp2022);
maxDate2022 = dates2022(idx2022);

% Find max temperature and corresponding date for 2024
temp2024 = BI5_sb_dataTable.Temperature(years == 2024);
dates2024 = dates(years == 2024);
[max2024, idx2024] = max(temp2024);
maxDate2024 = dates2024(idx2024);

% Display results
fprintf('Maximum Temperature:\n');
fprintf('2022: %.2f°C on %s\n', max2022, datestr(maxDate2022, 'dd-mmm-yyyy HH:MM:SS'));
fprintf('2024: %.2f°C on %s\n', max2024, datestr(maxDate2024, 'dd-mmm-yyyy HH:MM:SS'));



% Open Sharp HKS21 at 3 m
SI3_sb = load([sb_path,'SBE56_HKS21_BTM_3_20201118_20241105.mat']);

% Display the variables in the .mat file
disp(SI3_sb);

% Extract the data directly creating a Datatable
% Create a table
SI3_sb_dataTable = table(SI3_sb.Time, SI3_sb.Temp, ...
    'VariableNames', {'Date_Time', 'Temperature'});

% Transform to datetime
SI3_sb_dataTable.Date_Time = datetime(SI3_sb_dataTable.Date_Time, 'ConvertFrom', 'datenum');


% Obtain max temperatures for 2022 and 2024
% Extract year from Date_Time
dates = datetime(SI3_sb_dataTable.Date_Time, 'InputFormat', 'dd-MMM-yyyy HH:mm:ss');
years = year(dates);

% Find max temperature and corresponding date for 2022
temp2022 = SI3_sb_dataTable.Temperature(years == 2022);
dates2022 = dates(years == 2022);
[max2022, idx2022] = max(temp2022);
maxDate2022 = dates2022(idx2022);

% Find max temperature and corresponding date for 2024
temp2024 = SI3_sb_dataTable.Temperature(years == 2024);
dates2024 = dates(years == 2024);
[max2024, idx2024] = max(temp2024);
maxDate2024 = dates2024(idx2024);

% Display results
fprintf('Maximum Temperature:\n');
fprintf('2022: %.2f°C on %s\n', max2022, datestr(maxDate2022, 'dd-mmm-yyyy HH:MM:SS'));
fprintf('2024: %.2f°C on %s\n', max2024, datestr(maxDate2024, 'dd-mmm-yyyy HH:MM:SS'));



% Open Sharp HKS21 at 4 m
SI4_sb = load([sb_path,'SBE56_HKS21_BTM_4_20210517_20240428.mat']);

% Display the variables in the .mat file
disp(SI4_sb);

% Extract the data directly creating a Datatable
% Create a table
SI4_sb_dataTable = table(SI4_sb.Time, SI4_sb.Temp, ...
    'VariableNames', {'Date_Time', 'Temperature'});

% Transform to datetime
SI4_sb_dataTable.Date_Time = datetime(SI4_sb_dataTable.Date_Time, 'ConvertFrom', 'datenum');

% Obtain max temperatures for 2022 and 2024
% Extract year from Date_Time
dates = datetime(SI4_sb_dataTable.Date_Time, 'InputFormat', 'dd-MMM-yyyy HH:mm:ss');
years = year(dates);

% Find max temperature and corresponding date for 2022
temp2022 = SI4_sb_dataTable.Temperature(years == 2022);
dates2022 = dates(years == 2022);
[max2022, idx2022] = max(temp2022);
maxDate2022 = dates2022(idx2022);

% Find max temperature and corresponding date for 2024
temp2024 = SI4_sb_dataTable.Temperature(years == 2024);
dates2024 = dates(years == 2024);
[max2024, idx2024] = max(temp2024);
maxDate2024 = dates2024(idx2024);

% Display results
fprintf('Maximum Temperature:\n');
fprintf('2022: %.2f°C on %s\n', max2022, datestr(maxDate2022, 'dd-mmm-yyyy HH:MM:SS'));
fprintf('2024: %.2f°C on %s\n', max2024, datestr(maxDate2024, 'dd-mmm-yyyy HH:MM:SS'));



%% Below the data for the miniDOT


% Extract the miniDOT
minidot_path = '/Users/gonzaloprb/Documents/AAASea_Science/Publications/HongKong_Bleaching_Oceanography/Data/Environment/Fixed_Temp_Loggers/miniDOT/';

% open and extract data for Bluff HK S18 at 2 m

BI2_md = load([minidot_path,'PMEmD_HKS18_BTM_2_20240510_20241105.mat']);

disp(BI2_md);

% Create a table
BI2_md_dataTable = table(BI2_md.Time, BI2_md.Temp, ...
    'VariableNames', {'Date_Time', 'Temperature'});

BI2_md_dataTable.Date_Time = datetime(BI2_md_dataTable.Date_Time, 'ConvertFrom', 'datenum');


% Make the plot
figure; hold on;
plot (BI2_md_dataTable.Date_Time, BI2_md_dataTable.Temperature, 'r')
% xlim([datetime('2020-09-01'), datetime('2024-08-10')]);
xlabel ('Time')
ylabel ('Temperatures (ºC)')
title ('Bluff Island (minidot logger at 2 m)')

% The code and extraction for the DHDs Bluff Island 2 m


% Obtain max temperatures for 2022 and 2024
% Extract year from Date_Time
dates = datetime(BI2_md_dataTable.Date_Time, 'InputFormat', 'dd-MMM-yyyy HH:mm:ss');
years = year(dates);
% Find max temperature and corresponding date for 2022
temp2022 = BI2_md_dataTable.Temperature(years == 2022);
dates2022 = dates(years == 2022);
[max2022, idx2022] = max(temp2022);
maxDate2022 = dates2022(idx2022);
% Find max temperature and corresponding date for 2024
temp2024 = BI2_md_dataTable.Temperature(years == 2024);
dates2024 = dates(years == 2024);
[max2024, idx2024] = max(temp2024);
maxDate2024 = dates2024(idx2024);
% Display results
fprintf('Maximum Temperature:\n');
fprintf('2022: %.2f°C on %s\n', max2022, datestr(maxDate2022, 'dd-mmm-yyyy HH:MM:SS'));
fprintf('2024: %.2f°C on %s\n', max2024, datestr(maxDate2024, 'dd-mmm-yyyy HH:MM:SS'));



% open and extract for Bluff HK S18 at 5 m

BI5_md = load([minidot_path,'PMEmD_HKS18_BTM_5_20240510_20241105.mat']);

disp(BI5_md);

% Create a table
BI5_md_dataTable = table(BI5_md.Time, BI5_md.Temp, ...
    'VariableNames', {'Date_Time', 'Temperature'});

BI5_md_dataTable.Date_Time = datetime(BI5_md_dataTable.Date_Time, 'ConvertFrom', 'datenum');

% Obtain max temperatures for 2022 and 2024
% Extract year from Date_Time
dates = datetime(BI5_md_dataTable.Date_Time, 'InputFormat', 'dd-MMM-yyyy HH:mm:ss');
years = year(dates);
% Find max temperature and corresponding date for 2022
temp2022 = BI5_md_dataTable.Temperature(years == 2022);
dates2022 = dates(years == 2022);
[max2022, idx2022] = max(temp2022);
maxDate2022 = dates2022(idx2022);
% Find max temperature and corresponding date for 2024
temp2024 = BI5_md_dataTable.Temperature(years == 2024);
dates2024 = dates(years == 2024);
[max2024, idx2024] = max(temp2024);
maxDate2024 = dates2024(idx2024);
% Display results
fprintf('Maximum Temperature:\n');
fprintf('2022: %.2f°C on %s\n', max2022, datestr(maxDate2022, 'dd-mmm-yyyy HH:MM:SS'));
fprintf('2024: %.2f°C on %s\n', max2024, datestr(maxDate2024, 'dd-mmm-yyyy HH:MM:SS'));



% open and extract for Sharp HK S19 at 2 m

SI2_md = load([minidot_path,'PMEmD_HKS21_BTM_2_20240428_20241105.mat']);

disp(SI2_md);

% Create a table
SI2_md_dataTable = table(SI2_md.Time, SI2_md.Temp, ...
    'VariableNames', {'Date_Time', 'Temperature'});

SI2_md_dataTable.Date_Time = datetime(SI2_md_dataTable.Date_Time, 'ConvertFrom', 'datenum');


% Obtain max temperatures for 2022 and 2024
% Extract year from Date_Time
dates = datetime(SI2_md_dataTable.Date_Time, 'InputFormat', 'dd-MMM-yyyy HH:mm:ss');
years = year(dates);
% Find max temperature and corresponding date for 2022
temp2022 = SI2_md_dataTable.Temperature(years == 2022);
dates2022 = dates(years == 2022);
[max2022, idx2022] = max(temp2022);
maxDate2022 = dates2022(idx2022);
% Find max temperature and corresponding date for 2024
temp2024 = SI2_md_dataTable.Temperature(years == 2024);
dates2024 = dates(years == 2024);
[max2024, idx2024] = max(temp2024);
maxDate2024 = dates2024(idx2024);
% Display results
fprintf('Maximum Temperature:\n');
fprintf('2022: %.2f°C on %s\n', max2022, datestr(maxDate2022, 'dd-mmm-yyyy HH:MM:SS'));
fprintf('2024: %.2f°C on %s\n', max2024, datestr(maxDate2024, 'dd-mmm-yyyy HH:MM:SS'));


% open and extract for Sharp HK S19 at 5 m

SI5_md = load([minidot_path,'PMEmD_HKS21_BTM_5_20240428_20241105.mat']);

disp(SI5_md);

% Create a table
SI5_md_dataTable = table(SI5_md.Time, SI5_md.Temp, ...
    'VariableNames', {'Date_Time', 'Temperature'});

SI5_md_dataTable.Date_Time = datetime(SI5_md_dataTable.Date_Time, 'ConvertFrom', 'datenum');

% Obtain max temperatures for 2022 and 2024
% Extract year from Date_Time
dates = datetime(SI5_md_dataTable.Date_Time, 'InputFormat', 'dd-MMM-yyyy HH:mm:ss');
years = year(dates);
% Find max temperature and corresponding date for 2022
temp2022 = SI5_md_dataTable.Temperature(years == 2022);
dates2022 = dates(years == 2022);
[max2022, idx2022] = max(temp2022);
maxDate2022 = dates2022(idx2022);
% Find max temperature and corresponding date for 2024
temp2024 = SI5_md_dataTable.Temperature(years == 2024);
dates2024 = dates(years == 2024);
[max2024, idx2024] = max(temp2024);
maxDate2024 = dates2024(idx2024);
% Display results
fprintf('Maximum Temperature:\n');
fprintf('2022: %.2f°C on %s\n', max2022, datestr(maxDate2022, 'dd-mmm-yyyy HH:MM:SS'));
fprintf('2024: %.2f°C on %s\n', max2024, datestr(maxDate2024, 'dd-mmm-yyyy HH:MM:SS'));


% open and extract for Sharp HK S19 at 8 m

SI8_md = load([minidot_path,'PMEmD_HKS21_BTM_8_20240428_20241105.mat']);

disp(SI8_md);

% Create a table
SI8_md_dataTable = table(SI8_md.Time, SI8_md.Temp, ...
    'VariableNames', {'Date_Time', 'Temperature'});

SI8_md_dataTable.Date_Time = datetime(SI8_md_dataTable.Date_Time, 'ConvertFrom', 'datenum');

% Obtain max temperatures for 2022 and 2024
% Extract year from Date_Time
dates = datetime(SI8_md_dataTable.Date_Time, 'InputFormat', 'dd-MMM-yyyy HH:mm:ss');
years = year(dates);
% Find max temperature and corresponding date for 2022
temp2022 = SI8_md_dataTable.Temperature(years == 2022);
dates2022 = dates(years == 2022);
[max2022, idx2022] = max(temp2022);
maxDate2022 = dates2022(idx2022);
% Find max temperature and corresponding date for 2024
temp2024 = SI8_md_dataTable.Temperature(years == 2024);
dates2024 = dates(years == 2024);
[max2024, idx2024] = max(temp2024);
maxDate2024 = dates2024(idx2024);
% Display results
fprintf('Maximum Temperature:\n');
fprintf('2022: %.2f°C on %s\n', max2022, datestr(maxDate2022, 'dd-mmm-yyyy HH:MM:SS'));
fprintf('2024: %.2f°C on %s\n', max2024, datestr(maxDate2024, 'dd-mmm-yyyy HH:MM:SS'));




% Plot all the logger temperatures only for 2022 and 2024
figure; hold on;

% === Bluff (Dotted Lines - Cool Colors) ===
plot(BI2_md_dataTable.Date_Time, BI2_md_dataTable.Temperature, ':', 'Color', [0.3 0.75 0.93], 'LineWidth', 0.1); % Light Blue  
plot(BI5_sb_dataTable.Date_Time, BI5_sb_dataTable.Temperature, ':', 'Color', [0 0.45 0.74], 'LineWidth', 0.1); % Deep Blue
plot(BI5_md_dataTable.Date_Time, BI5_md_dataTable.Temperature, ':', 'Color', [0.47 0.67 0.19], 'LineWidth', 0.1); % Green

% === Sharp (Solid Lines - Warm Colors) ===
plot(SI2_md_dataTable.Date_Time, SI2_md_dataTable.Temperature, '-', 'Color', [0.64 0.08 0.18], 'LineWidth', 0.1); % Red  
plot(SI3_sb_dataTable.Date_Time, SI3_sb_dataTable.Temperature, '-', 'Color', [0.49 0.18 0.56], 'LineWidth', 0.1); % Purple 
plot(SI4_sb_dataTable.Date_Time, SI4_sb_dataTable.Temperature, '-', 'Color', [0.77 0.49 0.64], 'LineWidth', 0.1); %  Pink  
plot(SI5_md_dataTable.Date_Time, SI5_md_dataTable.Temperature, '-', 'Color', [0.85 0.33 0.1], 'LineWidth', 0.1); % Orange
plot(SI8_md_dataTable.Date_Time, SI8_md_dataTable.Temperature, '-', 'Color', [0.93 0.69 0.13], 'LineWidth', 0.1); % Gold
% === TPC (Dashed Line - Violet-Red) ===
plot(TPC3_sb_dataTable.Date_Time, TPC3_sb_dataTable.Temperature, '--', 'Color', [0.86 0.12 0.35], 'LineWidth', 0.1); % Violet-Red

% Set axis limits and labels
xlim([datetime('2022-01-01'), datetime('2024-12-31')]);
xlabel('Time (Month Year)');
ylabel('Temperatures (ºC)');

% Legend ordered by plotting sequence
legend(...
    'BI 2 m (MD)','BI 5 m (SB)', 'BI 5 m (MD)', ...  % Bluff first (cool colors)
    'SI 2 m (MD)','SI 3 m (SB)', 'SI 4 m (SB)', 'SI 5 m (MD)', 'SI 8 m (MD)', ...  % Then Sharp (warm colors)
    'TPC 3 m (SB)', ...  % Finally TPC
    'Location', 'southeast', 'FontSize', 8, 'Box', 'on');

% Improve plot appearance
grid on;
box on;
set(gca, 'FontSize', 10, 'LineWidth', 0.5);


% Add horizontal lines (in case it was needed)
% yline(28.6656, '--', 'Color', [0.5 0.5 0.5], 'LineWidth', 1); % Grey dashed line
% yline(28.6656 + 1, '--r', 'LineWidth', 1.5); % Red dashed line
% Add text labels near the lines
% text(min(SSTt), 28.6656, ' Monthly Maximum Mean', 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'left', 'Color', [0.5 0.5 0.5], 'FontWeight', 'bold');
% text(min(SSTt), 28.6656 + 1, ' Bleaching Threshold', ...
%     'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'left', ...
%     'Color', 'r', 'FontWeight', 'bold');
% grid on;

%% % Extractions of the DHDs


% They are arrays with 5 cells. 
% The best cell looks to be cell 3!
% Smaller datafiles than cell 1

% Test to see how it works the cells
DH = TPC3_sb.DH{3}';
DHt = TPC3_sb.DHt{3}; % No need to transpose here

% Test on tables:
DH_dataTable = table(TPC3_sb.DHt{3}, TPC3_sb.DH{3}', ...
    'VariableNames', {'Date_Time', 'DHDs'});

% Transform to datetime
DH_dataTable.Date_Time = datetime(DH_dataTable.Date_Time, 'ConvertFrom', 'datenum');

% Make the plot
figure; hold on;
plot (DH_dataTable.Date_Time, DH_dataTable.DHDs, 'r')
xlim([datetime('2024-06-01'), datetime('2024-11-10')]);
xlabel ('Time')
ylabel ('DHDs (ºC – weeks)')
title ('')
hold off;




% Make the whole extractions of DHDs: 

% Tung Ping Chau 3 m SeaBird

TPC3_sb_DHD_Table = table(TPC3_sb.DHt{3}, TPC3_sb.DH{3}', ...
    'VariableNames', {'Date_Time', 'DHDs'});

% Transform to datetime
TPC3_sb_DHD_Table.Date_Time = datetime(TPC3_sb_DHD_Table.Date_Time, 'ConvertFrom', 'datenum');



% Obtain max DHDs for 2022 and 2024 and display the number of dates above
% DHDs = 8
% Extract date (without time) from Date_Time
dates = datetime(TPC3_sb_DHD_Table.Date_Time, 'InputFormat', 'dd-MMM-yyyy HH:mm:ss');
datesOnly = dates; % Keep full datetime for filtering
years = year(datesOnly);
% Get DHDs for 2022 and 2024
DHD2022 = TPC3_sb_DHD_Table.DHDs(years == 2022);
dates2022 = datesOnly(years == 2022);
DHD2024 = TPC3_sb_DHD_Table.DHDs(years == 2024);
dates2024 = datesOnly(years == 2024);
% Count UNIQUE days where DHDs > 8 (2022)
% Convert dates to day numbers (e.g., day-of-year) and use accumarray
[uniqueDays2022, ~, dayIdx2022] = unique(floor(datenum(dates2022))); % Group by day
daysAbove8_2022 = sum(accumarray(dayIdx2022, DHD2022 > 8, [], @any));
% Count UNIQUE days where DHDs > 8 (2024)
[uniqueDays2024, ~, dayIdx2024] = unique(floor(datenum(dates2024))); % Group by day
daysAbove8_2024 = sum(accumarray(dayIdx2024, DHD2024 > 8, [], @any));
% Display results
fprintf('Number of UNIQUE days with DHDs > 8:\n');
fprintf('2022: %d days\n', daysAbove8_2022);
fprintf('2024: %d days\n', daysAbove8_2024);
% Display max DHDs per year for 2022 and 2024
[max2022, idx2022] = max(DHD2022);
maxDate2022 = dates2022(idx2022);
[max2024, idx2024] = max(DHD2024);
maxDate2024 = dates2024(idx2024);
fprintf('\nMaximum DHDs:\n');
fprintf('2022: %.2f°C-days on %s\n', max2022, datestr(maxDate2022, 'dd-mmm-yyyy HH:MM:SS'));
fprintf('2024: %.2f°C-days on %s\n', max2024, datestr(maxDate2024, 'dd-mmm-yyyy HH:MM:SS'));


% Bluff Island 5 m SB
BI5_sb_DHD_Table = table(BI5_sb.DHt{3}, BI5_sb.DH{3}', ...
    'VariableNames', {'Date_Time', 'DHDs'});

% Transform to datetime
BI5_sb_DHD_Table.Date_Time = datetime(BI5_sb_DHD_Table.Date_Time, 'ConvertFrom', 'datenum');

% Obtain max DHDs for 2022 and 2024 and display the number of dates above
% DHDs = 8
% Extract date (without time) from Date_Time
dates = datetime(BI5_sb_DHD_Table.Date_Time, 'InputFormat', 'dd-MMM-yyyy HH:mm:ss');
datesOnly = dates; % Keep full datetime for filtering
years = year(datesOnly);
% Get DHDs for 2022 and 2024
DHD2022 = BI5_sb_DHD_Table.DHDs(years == 2022);
dates2022 = datesOnly(years == 2022);
DHD2024 = BI5_sb_DHD_Table.DHDs(years == 2024);
dates2024 = datesOnly(years == 2024);
% Count UNIQUE days where DHDs > 8 (2022)
% Convert dates to day numbers (e.g., day-of-year) and use accumarray
[uniqueDays2022, ~, dayIdx2022] = unique(floor(datenum(dates2022))); % Group by day
daysAbove8_2022 = sum(accumarray(dayIdx2022, DHD2022 > 8, [], @any));
% Count UNIQUE days where DHDs > 8 (2024)
[uniqueDays2024, ~, dayIdx2024] = unique(floor(datenum(dates2024))); % Group by day
daysAbove8_2024 = sum(accumarray(dayIdx2024, DHD2024 > 8, [], @any));
% Display results
fprintf('Number of UNIQUE days with DHDs > 8:\n');
fprintf('2022: %d days\n', daysAbove8_2022);
fprintf('2024: %d days\n', daysAbove8_2024);
% Display max DHDs per year for 2022 and 2024
[max2022, idx2022] = max(DHD2022);
maxDate2022 = dates2022(idx2022);
[max2024, idx2024] = max(DHD2024);
maxDate2024 = dates2024(idx2024);
fprintf('\nMaximum DHDs:\n');
fprintf('2022: %.2f°C-days on %s\n', max2022, datestr(maxDate2022, 'dd-mmm-yyyy HH:MM:SS'));
fprintf('2024: %.2f°C-days on %s\n', max2024, datestr(maxDate2024, 'dd-mmm-yyyy HH:MM:SS'));


% Sharp Island 3 m SB
SI3_sb_DHD_Table = table(SI3_sb.DHt{3}, SI3_sb.DH{3}', ...
    'VariableNames', {'Date_Time', 'DHDs'});

% Transform to datetime
SI3_sb_DHD_Table.Date_Time = datetime(SI3_sb_DHD_Table.Date_Time, 'ConvertFrom', 'datenum');

% Obtain max DHDs for 2022 and 2024 and display the number of dates above
% DHDs = 8
% Extract date (without time) from Date_Time
dates = datetime(SI3_sb_DHD_Table.Date_Time, 'InputFormat', 'dd-MMM-yyyy HH:mm:ss');
datesOnly = dates; % Keep full datetime for filtering
years = year(datesOnly);
% Get DHDs for 2022 and 2024
DHD2022 = SI3_sb_DHD_Table.DHDs(years == 2022);
dates2022 = datesOnly(years == 2022);
DHD2024 = SI3_sb_DHD_Table.DHDs(years == 2024);
dates2024 = datesOnly(years == 2024);
% Count UNIQUE days where DHDs > 8 (2022)
% Convert dates to day numbers (e.g., day-of-year) and use accumarray
[uniqueDays2022, ~, dayIdx2022] = unique(floor(datenum(dates2022))); % Group by day
daysAbove8_2022 = sum(accumarray(dayIdx2022, DHD2022 > 8, [], @any));
% Count UNIQUE days where DHDs > 8 (2024)
[uniqueDays2024, ~, dayIdx2024] = unique(floor(datenum(dates2024))); % Group by day
daysAbove8_2024 = sum(accumarray(dayIdx2024, DHD2024 > 8, [], @any));
% Display results
fprintf('Number of UNIQUE days with DHDs > 8:\n');
fprintf('2022: %d days\n', daysAbove8_2022);
fprintf('2024: %d days\n', daysAbove8_2024);
% Display max DHDs per year for 2022 and 2024
[max2022, idx2022] = max(DHD2022);
maxDate2022 = dates2022(idx2022);
[max2024, idx2024] = max(DHD2024);
maxDate2024 = dates2024(idx2024);
fprintf('\nMaximum DHDs:\n');
fprintf('2022: %.2f°C-days on %s\n', max2022, datestr(maxDate2022, 'dd-mmm-yyyy HH:MM:SS'));
fprintf('2024: %.2f°C-days on %s\n', max2024, datestr(maxDate2024, 'dd-mmm-yyyy HH:MM:SS'));


% Sharp Island 4 m SB
SI4_sb_DHD_Table = table(SI4_sb.DHt{3}, SI4_sb.DH{3}', ...
    'VariableNames', {'Date_Time', 'DHDs'});

SI4_sb_DHD_Table.Date_Time = datetime(SI4_sb_DHD_Table.Date_Time, 'ConvertFrom', 'datenum');

% Obtain max DHDs for 2022 and 2024 and display the number of dates above
% DHDs = 8
% Extract date (without time) from Date_Time
dates = datetime(SI4_sb_DHD_Table.Date_Time, 'InputFormat', 'dd-MMM-yyyy HH:mm:ss');
datesOnly = dates; % Keep full datetime for filtering
years = year(datesOnly);
% Get DHDs for 2022 and 2024
DHD2022 = SI4_sb_DHD_Table.DHDs(years == 2022);
dates2022 = datesOnly(years == 2022);
DHD2024 = SI4_sb_DHD_Table.DHDs(years == 2024);
dates2024 = datesOnly(years == 2024);
% Count UNIQUE days where DHDs > 8 (2022)
% Convert dates to day numbers (e.g., day-of-year) and use accumarray
[uniqueDays2022, ~, dayIdx2022] = unique(floor(datenum(dates2022))); % Group by day
daysAbove8_2022 = sum(accumarray(dayIdx2022, DHD2022 > 8, [], @any));
% Count UNIQUE days where DHDs > 8 (2024)
[uniqueDays2024, ~, dayIdx2024] = unique(floor(datenum(dates2024))); % Group by day
daysAbove8_2024 = sum(accumarray(dayIdx2024, DHD2024 > 8, [], @any));
% Display results
fprintf('Number of UNIQUE days with DHDs > 8:\n');
fprintf('2022: %d days\n', daysAbove8_2022);
fprintf('2024: %d days\n', daysAbove8_2024);
% Display max DHDs per year for 2022 and 2024
[max2022, idx2022] = max(DHD2022);
maxDate2022 = dates2022(idx2022);
[max2024, idx2024] = max(DHD2024);
maxDate2024 = dates2024(idx2024);
fprintf('\nMaximum DHDs:\n');
fprintf('2022: %.2f°C-days on %s\n', max2022, datestr(maxDate2022, 'dd-mmm-yyyy HH:MM:SS'));
fprintf('2024: %.2f°C-days on %s\n', max2024, datestr(maxDate2024, 'dd-mmm-yyyy HH:MM:SS'));


% Bluff Island 2 m minidot
BI2_md_DHD_Table = table(BI2_md.DHt{3}, BI2_md.DH{3}', ...
    'VariableNames', {'Date_Time', 'DHDs'});

BI2_md_DHD_Table.Date_Time = datetime(BI2_md_DHD_Table.Date_Time, 'ConvertFrom', 'datenum');

% Obtain max DHDs for 2022 and 2024 and display the number of dates above
% DHDs = 8
% Extract date (without time) from Date_Time
dates = datetime(BI2_md_DHD_Table.Date_Time, 'InputFormat', 'dd-MMM-yyyy HH:mm:ss');
datesOnly = dates; % Keep full datetime for filtering
years = year(datesOnly);
% Get DHDs for 2022 and 2024
DHD2022 = BI2_md_DHD_Table.DHDs(years == 2022);
dates2022 = datesOnly(years == 2022);
DHD2024 = BI2_md_DHD_Table.DHDs(years == 2024);
dates2024 = datesOnly(years == 2024);
% Count UNIQUE days where DHDs > 8 (2022)
% Convert dates to day numbers (e.g., day-of-year) and use accumarray
[uniqueDays2022, ~, dayIdx2022] = unique(floor(datenum(dates2022))); % Group by day
daysAbove8_2022 = sum(accumarray(dayIdx2022, DHD2022 > 8, [], @any));
% Count UNIQUE days where DHDs > 8 (2024)
[uniqueDays2024, ~, dayIdx2024] = unique(floor(datenum(dates2024))); % Group by day
daysAbove8_2024 = sum(accumarray(dayIdx2024, DHD2024 > 8, [], @any));
% Display results
fprintf('Number of UNIQUE days with DHDs > 8:\n');
fprintf('2022: %d days\n', daysAbove8_2022);
fprintf('2024: %d days\n', daysAbove8_2024);
% Display max DHDs per year for 2022 and 2024
[max2022, idx2022] = max(DHD2022);
maxDate2022 = dates2022(idx2022);
[max2024, idx2024] = max(DHD2024);
maxDate2024 = dates2024(idx2024);
fprintf('\nMaximum DHDs:\n');
fprintf('2022: %.2f°C-days on %s\n', max2022, datestr(maxDate2022, 'dd-mmm-yyyy HH:MM:SS'));
fprintf('2024: %.2f°C-days on %s\n', max2024, datestr(maxDate2024, 'dd-mmm-yyyy HH:MM:SS'));


% Bluff Island 5 m minidot
BI5_md_DHD_Table = table(BI5_md.DHt{3}, BI5_md.DH{3}', ...
    'VariableNames', {'Date_Time', 'DHDs'});

BI5_md_DHD_Table.Date_Time = datetime(BI5_md_DHD_Table.Date_Time, 'ConvertFrom', 'datenum');

% Obtain max DHDs for 2022 and 2024 and display the number of dates above
% DHDs = 8
% Extract date (without time) from Date_Time
dates = datetime(BI5_md_DHD_Table.Date_Time, 'InputFormat', 'dd-MMM-yyyy HH:mm:ss');
datesOnly = dates; % Keep full datetime for filtering
years = year(datesOnly);
% Get DHDs for 2022 and 2024
DHD2022 = BI5_md_DHD_Table.DHDs(years == 2022);
dates2022 = datesOnly(years == 2022);
DHD2024 = BI5_md_DHD_Table.DHDs(years == 2024);
dates2024 = datesOnly(years == 2024);
% Count UNIQUE days where DHDs > 8 (2022)
% Convert dates to day numbers (e.g., day-of-year) and use accumarray
[uniqueDays2022, ~, dayIdx2022] = unique(floor(datenum(dates2022))); % Group by day
daysAbove8_2022 = sum(accumarray(dayIdx2022, DHD2022 > 8, [], @any));
% Count UNIQUE days where DHDs > 8 (2024)
[uniqueDays2024, ~, dayIdx2024] = unique(floor(datenum(dates2024))); % Group by day
daysAbove8_2024 = sum(accumarray(dayIdx2024, DHD2024 > 8, [], @any));
% Display results
fprintf('Number of UNIQUE days with DHDs > 8:\n');
fprintf('2022: %d days\n', daysAbove8_2022);
fprintf('2024: %d days\n', daysAbove8_2024);
% Display max DHDs per year for 2022 and 2024
[max2022, idx2022] = max(DHD2022);
maxDate2022 = dates2022(idx2022);
[max2024, idx2024] = max(DHD2024);
maxDate2024 = dates2024(idx2024);
fprintf('\nMaximum DHDs:\n');
fprintf('2022: %.2f°C-days on %s\n', max2022, datestr(maxDate2022, 'dd-mmm-yyyy HH:MM:SS'));
fprintf('2024: %.2f°C-days on %s\n', max2024, datestr(maxDate2024, 'dd-mmm-yyyy HH:MM:SS'));


% Sharp Island 2 m minidot
SI2_md_DHD_Table = table(SI2_md.DHt{3}, SI2_md.DH{3}', ...
    'VariableNames', {'Date_Time', 'DHDs'});

SI2_md_DHD_Table.Date_Time = datetime(SI2_md_DHD_Table.Date_Time, 'ConvertFrom', 'datenum');

% Obtain max DHDs for 2022 and 2024 and display the number of dates above
% DHDs = 8
% Extract date (without time) from Date_Time
dates = datetime(SI2_md_DHD_Table.Date_Time, 'InputFormat', 'dd-MMM-yyyy HH:mm:ss');
datesOnly = dates; % Keep full datetime for filtering
years = year(datesOnly);
% Get DHDs for 2022 and 2024
DHD2022 = SI2_md_DHD_Table.DHDs(years == 2022);
dates2022 = datesOnly(years == 2022);
DHD2024 = SI2_md_DHD_Table.DHDs(years == 2024);
dates2024 = datesOnly(years == 2024);
% Count UNIQUE days where DHDs > 8 (2022)
% Convert dates to day numbers (e.g., day-of-year) and use accumarray
[uniqueDays2022, ~, dayIdx2022] = unique(floor(datenum(dates2022))); % Group by day
daysAbove8_2022 = sum(accumarray(dayIdx2022, DHD2022 > 8, [], @any));
% Count UNIQUE days where DHDs > 8 (2024)
[uniqueDays2024, ~, dayIdx2024] = unique(floor(datenum(dates2024))); % Group by day
daysAbove8_2024 = sum(accumarray(dayIdx2024, DHD2024 > 8, [], @any));
% Display results
fprintf('Number of UNIQUE days with DHDs > 8:\n');
fprintf('2022: %d days\n', daysAbove8_2022);
fprintf('2024: %d days\n', daysAbove8_2024);
% Display max DHDs per year for 2022 and 2024
[max2022, idx2022] = max(DHD2022);
maxDate2022 = dates2022(idx2022);
[max2024, idx2024] = max(DHD2024);
maxDate2024 = dates2024(idx2024);
fprintf('\nMaximum DHDs:\n');
fprintf('2022: %.2f°C-days on %s\n', max2022, datestr(maxDate2022, 'dd-mmm-yyyy HH:MM:SS'));
fprintf('2024: %.2f°C-days on %s\n', max2024, datestr(maxDate2024, 'dd-mmm-yyyy HH:MM:SS'));


% Sharp Island 5 m minidot
SI5_md_DHD_Table = table(SI5_md.DHt{3}, SI5_md.DH{3}', ...
    'VariableNames', {'Date_Time', 'DHDs'});

SI5_md_DHD_Table.Date_Time = datetime(SI5_md_DHD_Table.Date_Time, 'ConvertFrom', 'datenum');

% Obtain max DHDs for 2022 and 2024 and display the number of dates above
% DHDs = 8
% Extract date (without time) from Date_Time
dates = datetime(SI5_md_DHD_Table.Date_Time, 'InputFormat', 'dd-MMM-yyyy HH:mm:ss');
datesOnly = dates; % Keep full datetime for filtering
years = year(datesOnly);
% Get DHDs for 2022 and 2024
DHD2022 = SI5_md_DHD_Table.DHDs(years == 2022);
dates2022 = datesOnly(years == 2022);
DHD2024 = SI5_md_DHD_Table.DHDs(years == 2024);
dates2024 = datesOnly(years == 2024);
% Count UNIQUE days where DHDs > 8 (2022)
% Convert dates to day numbers (e.g., day-of-year) and use accumarray
[uniqueDays2022, ~, dayIdx2022] = unique(floor(datenum(dates2022))); % Group by day
daysAbove8_2022 = sum(accumarray(dayIdx2022, DHD2022 > 8, [], @any));
% Count UNIQUE days where DHDs > 8 (2024)
[uniqueDays2024, ~, dayIdx2024] = unique(floor(datenum(dates2024))); % Group by day
daysAbove8_2024 = sum(accumarray(dayIdx2024, DHD2024 > 8, [], @any));
% Display results
fprintf('Number of UNIQUE days with DHDs > 8:\n');
fprintf('2022: %d days\n', daysAbove8_2022);
fprintf('2024: %d days\n', daysAbove8_2024);
% Display max DHDs per year for 2022 and 2024
[max2022, idx2022] = max(DHD2022);
maxDate2022 = dates2022(idx2022);
[max2024, idx2024] = max(DHD2024);
maxDate2024 = dates2024(idx2024);
fprintf('\nMaximum DHDs:\n');
fprintf('2022: %.2f°C-days on %s\n', max2022, datestr(maxDate2022, 'dd-mmm-yyyy HH:MM:SS'));
fprintf('2024: %.2f°C-days on %s\n', max2024, datestr(maxDate2024, 'dd-mmm-yyyy HH:MM:SS'));


% Sharp Island 8 m minidot
SI8_md_DHD_Table = table(SI8_md.DHt{3}, SI8_md.DH{3}', ...
    'VariableNames', {'Date_Time', 'DHDs'});

SI8_md_DHD_Table.Date_Time = datetime(SI8_md_DHD_Table.Date_Time, 'ConvertFrom', 'datenum');

% Obtain max DHDs for 2022 and 2024 and display the number of dates above
% DHDs = 8
% Extract date (without time) from Date_Time
dates = datetime(SI8_md_DHD_Table.Date_Time, 'InputFormat', 'dd-MMM-yyyy HH:mm:ss');
datesOnly = dates; % Keep full datetime for filtering
years = year(datesOnly);
% Get DHDs for 2022 and 2024
DHD2022 = SI8_md_DHD_Table.DHDs(years == 2022);
dates2022 = datesOnly(years == 2022);
DHD2024 = SI8_md_DHD_Table.DHDs(years == 2024);
dates2024 = datesOnly(years == 2024);
% Count UNIQUE days where DHDs > 8 (2022)
% Convert dates to day numbers (e.g., day-of-year) and use accumarray
[uniqueDays2022, ~, dayIdx2022] = unique(floor(datenum(dates2022))); % Group by day
daysAbove8_2022 = sum(accumarray(dayIdx2022, DHD2022 > 8, [], @any));
% Count UNIQUE days where DHDs > 8 (2024)
[uniqueDays2024, ~, dayIdx2024] = unique(floor(datenum(dates2024))); % Group by day
daysAbove8_2024 = sum(accumarray(dayIdx2024, DHD2024 > 8, [], @any));
% Display results
fprintf('Number of UNIQUE days with DHDs > 8:\n');
fprintf('2022: %d days\n', daysAbove8_2022);
fprintf('2024: %d days\n', daysAbove8_2024);
% Display max DHDs per year for 2022 and 2024
[max2022, idx2022] = max(DHD2022);
maxDate2022 = dates2022(idx2022);
[max2024, idx2024] = max(DHD2024);
maxDate2024 = dates2024(idx2024);
fprintf('\nMaximum DHDs:\n');
fprintf('2022: %.2f°C-days on %s\n', max2022, datestr(maxDate2022, 'dd-mmm-yyyy HH:MM:SS'));
fprintf('2024: %.2f°C-days on %s\n', max2024, datestr(maxDate2024, 'dd-mmm-yyyy HH:MM:SS'));

%% 


% Ready to make the figures:

% Make the plot for 2022
figure; hold on;

% === Bluff (Dotted Lines - Cool Colors) ===
plot(BI2_md_DHD_Table.Date_Time, BI2_md_DHD_Table.DHDs, ':', 'Color', [0.3 0.75 0.93], 'LineWidth', 0.5); % Light Blue  
plot(BI5_sb_DHD_Table.Date_Time, BI5_sb_DHD_Table.DHDs, ':', 'Color', [0 0.45 0.74], 'LineWidth', 0.5); % Deep Blue
plot(BI5_md_DHD_Table.Date_Time, BI5_md_DHD_Table.DHDs, ':', 'Color', [0.47 0.67 0.19], 'LineWidth', 0.5); % Green

% === Sharp (Solid Lines - Warm Colors) ===
plot(SI2_md_DHD_Table.Date_Time, SI2_md_DHD_Table.DHDs, '-', 'Color', [0.64 0.08 0.18], 'LineWidth', 0.5); % Red  
plot(SI3_sb_DHD_Table.Date_Time, SI3_sb_DHD_Table.DHDs, '-', 'Color', [0.49 0.18 0.56], 'LineWidth', 0.5); % Purple 
plot(SI4_sb_DHD_Table.Date_Time, SI4_sb_DHD_Table.DHDs, '-', 'Color', [0.77 0.49 0.64], 'LineWidth', 0.5); % Pink  
plot(SI5_md_DHD_Table.Date_Time, SI5_md_DHD_Table.DHDs, '-', 'Color', [0.85 0.33 0.1], 'LineWidth', 0.5); % Orange
plot(SI8_md_DHD_Table.Date_Time, SI8_md_DHD_Table.DHDs, '-', 'Color', [0.93 0.69 0.13], 'LineWidth', 0.5); % Gold

% === TPC (Dashed Line - Violet-Red) ===
plot(TPC3_sb_DHD_Table.Date_Time, TPC3_sb_DHD_Table.DHDs, '--', 'Color', [0.86 0.12 0.35], 'LineWidth', 0.5); % Violet-Red

% Set axis limits and labels
xlim([datetime('2022-05-01'), datetime('2022-12-31')]);
ylim([0 36]); % Fixed y-axis from 0 to 36
xlabel('Time (Months)');
ylabel('DHDs (ºC–days)');

% Legend ordered by plotting sequence
legend(...
    'BI 2 m (MD)','BI 5 m (SB)', 'BI 5 m (MD)', ...  % Bluff first (cool colors)
    'SI 2 m (MD)','SI 3 m (SB)', 'SI 4 m (SB)', 'SI 5 m (MD)', 'SI 8 m (MD)', ...  % Then Sharp (warm colors)
    'TPC 3 m (SB)', ...  % Finally TPC
    'Location', 'northeast', 'FontSize', 8, 'Box', 'on');

% Improve plot appearance
grid on;
box on;
set(gca, 'FontSize', 10, 'LineWidth', 0.5);
title('Heat accumulation during the 2022 heatwave', 'FontSize', 12);



% Plot for 2024
figure; hold on;

% === Bluff (Dotted Lines - Cool Colors) ===
plot(BI2_md_DHD_Table.Date_Time, BI2_md_DHD_Table.DHDs, ':', 'Color', [0.3 0.75 0.93], 'LineWidth', 0.5); % Light Blue  
plot(BI5_sb_DHD_Table.Date_Time, BI5_sb_DHD_Table.DHDs, ':', 'Color', [0 0.45 0.74], 'LineWidth', 0.5); % Deep Blue
plot(BI5_md_DHD_Table.Date_Time, BI5_md_DHD_Table.DHDs, ':', 'Color', [0.47 0.67 0.19], 'LineWidth', 0.5); % Green

% === Sharp (Solid Lines - Warm Colors) ===
plot(SI2_md_DHD_Table.Date_Time, SI2_md_DHD_Table.DHDs, '-', 'Color', [0.64 0.08 0.18], 'LineWidth', 0.5); % Red  
plot(SI3_sb_DHD_Table.Date_Time, SI3_sb_DHD_Table.DHDs, '-', 'Color', [0.49 0.18 0.56], 'LineWidth', 0.5); % Purple 
plot(SI4_sb_DHD_Table.Date_Time, SI4_sb_DHD_Table.DHDs, '-', 'Color', [0.77 0.49 0.64], 'LineWidth', 0.5); % Pink  
plot(SI5_md_DHD_Table.Date_Time, SI5_md_DHD_Table.DHDs, '-', 'Color', [0.85 0.33 0.1], 'LineWidth', 0.5); % Orange
plot(SI8_md_DHD_Table.Date_Time, SI8_md_DHD_Table.DHDs, '-', 'Color', [0.93 0.69 0.13], 'LineWidth', 0.5); % Gold

% === TPC (Dashed Line - Violet-Red) ===
plot(TPC3_sb_DHD_Table.Date_Time, TPC3_sb_DHD_Table.DHDs, '--', 'Color', [0.86 0.12 0.35], 'LineWidth', 0.5); % Violet-Red

% Set axis limits and labels
xlim([datetime('2024-05-01'), datetime('2024-12-31')]);
ylim([0 36]); % Fixed y-axis from 0 to 36
xlabel('Time (Months)');
ylabel('DHDs (ºC–days)');

% Legend ordered by plotting sequence
legend(...
    'BI 2 m (MD)','BI 5 m (SB)', 'BI 5 m (MD)', ...  % Bluff first (cool colors)
    'SI 2 m (MD)','SI 3 m (SB)', 'SI 4 m (SB)', 'SI 5 m (MD)', 'SI 8 m (MD)', ...  % Then Sharp (warm colors)
    'TPC 3 m (SB)', ...  % Finally TPC
    'Location', 'northeast', 'FontSize', 8, 'Box', 'on');

% Improve plot appearance
grid on;
box on;
set(gca, 'FontSize', 10, 'LineWidth', 0.5);
title('Heat accumulation during the 2024 heatwave', 'FontSize', 12);





%% Print max and min temperatures for July 2024 in Sharp between minidots at 8 and 2 m

% Convert Date_Time to datetime format
dates = datetime(SI2_md_dataTable.Date_Time, 'InputFormat', 'dd-MMM-yyyy HH:mm:ss');

% Extract month and year
monthFilter = month(dates) == 7;       % July is month 7
yearFilter = year(dates) == 2024;

% Combine filters for July 2024
july2024Filter = monthFilter & yearFilter;

% Get temperatures for July 2024
july2024Temps = SI2_md_dataTable.Temperature(july2024Filter);

% Find and display the max temperature
if ~isempty(july2024Temps)
    maxTemp = max(july2024Temps);
    fprintf('Maximum Temperature in July 2024: %.2f\n', maxTemp);
else
    fprintf('No data available for July 2024.\n');
end


% At 8 m, min Temps
% Convert Date_Time to datetime format
dates = datetime(SI8_md_dataTable.Date_Time, 'InputFormat', 'dd-MMM-yyyy HH:mm:ss');

% Extract month and year
monthFilter = month(dates) == 7;       % July is month 7
yearFilter = year(dates) == 2024;

% Combine filters for July 2024
july2024Filter = monthFilter & yearFilter;

% Get temperatures for July 2024
july2024Temps = SI8_md_dataTable.Temperature(july2024Filter);

% Find and display the max temperature
if ~isempty(july2024Temps)
    minTemp = min(july2024Temps);
    fprintf('Minimum Temperature in July 2024: %.2f\n', minTemp);
else
    fprintf('No data available for July 2024.\n');
end


% Code to run for a specific day as above and considering the same exact time (matching timestamps)  

% Convert Date_Time to datetime format for both datasets
dates2m = datetime(SI2_md_dataTable.Date_Time, 'InputFormat', 'dd-MMM-yyyy HH:mm:ss');
dates8m = datetime(SI8_md_dataTable.Date_Time, 'InputFormat', 'dd-MMM-yyyy HH:mm:ss');

% Extract month and year for both datasets
monthFilter2m = month(dates2m) == 7;       % July is month 7
yearFilter2m = year(dates2m) == 2024;
monthFilter8m = month(dates8m) == 7;
yearFilter8m = year(dates8m) == 2024;

% Combine filters for July 2024 for both datasets
july2024Filter2m = monthFilter2m & yearFilter2m;
july2024Filter8m = monthFilter8m & yearFilter8m;

% Get temperatures and dates for July 2024
july2024Temps2m = SI2_md_dataTable.Temperature(july2024Filter2m);
july2024Dates2m = dates2m(july2024Filter2m);
july2024Temps8m = SI8_md_dataTable.Temperature(july2024Filter8m);
july2024Dates8m = dates8m(july2024Filter8m);

% Check if data exists for both datasets
if isempty(july2024Temps2m) || isempty(july2024Temps8m)
    fprintf('No complete data available for July 2024.\n');
else
    % Find common days with data in both datasets
    [commonDates, idx2m, idx8m] = intersect(july2024Dates2m, july2024Dates8m);
    
    % Calculate daily differences (max at 2m - min at 8m for each day)
    dailyMaxDiffs = july2024Temps2m(idx2m) - july2024Temps8m(idx8m);
    
    % Find the maximum difference and its corresponding date
    [maxDiff, maxDiffIdx] = max(dailyMaxDiffs);
    maxDiffDate = commonDates(maxDiffIdx);
    
    % Display results
    fprintf('Maximum Temperature Difference in July 2024:\n');
    fprintf('Date: %s\n', datestr(maxDiffDate, 'dd-mmm-yyyy'));
    fprintf('Difference: %.2f°C (2m: %.2f°C, 8m: %.2f°C)\n', ...
            maxDiff, ...
            july2024Temps2m(idx2m(maxDiffIdx)), ...
            july2024Temps8m(idx8m(maxDiffIdx)));
end


% In April after Winter

% Convert Date_Time to datetime format
dates = datetime(SI2_md_dataTable.Date_Time, 'InputFormat', 'dd-MMM-yyyy HH:mm:ss');

% Extract month and year
monthFilter = month(dates) == 4;       % Apr is month 4
yearFilter = year(dates) == 2024;

% Combine filters for Jan and 2024
apr2024Filter = monthFilter & yearFilter;

% Get temperatures for Jan 2024
apr2024Temps = SI2_md_dataTable.Temperature(apr2024Filter);

% Find and display the max temperature
if ~isempty(apr2024Temps)
    maxTemp = max(apr2024Temps);
    fprintf('Maximum Temperature in Apr 2024: %.2f\n', maxTemp);
else
    fprintf('No data available for Apr 2024.\n');
end


% At 8 m, min Temps
% Convert Date_Time to datetime format
dates = datetime(SI8_md_dataTable.Date_Time, 'InputFormat', 'dd-MMM-yyyy HH:mm:ss');

% Extract month and year
monthFilter = month(dates) == 4;       % Apr is month 4
yearFilter = year(dates) == 2024;

% Combine filters for Jan and 2024
apr2024Filter = monthFilter & yearFilter;

% Get temperatures for Jan 2024
apr2024Temps = SI8_md_dataTable.Temperature(apr2024Filter);

% Find and display the max temperature
if ~isempty(apr2024Temps)
    minTemp = min(apr2024Temps);
    fprintf('Minimum Temperature in Apr 2024: %.2f\n', minTemp);
else
    fprintf('No data available for Apr 2024.\n');
end



% For a specific day as above and considering the same exact time (matching timestamps) 

% Convert Date_Time to datetime format for both datasets
dates2m = datetime(SI2_md_dataTable.Date_Time, 'InputFormat', 'dd-MMM-yyyy HH:mm:ss');
dates8m = datetime(SI8_md_dataTable.Date_Time, 'InputFormat', 'dd-MMM-yyyy HH:mm:ss');

% Extract month and year for both datasets (April is month 4)
monthFilter2m = month(dates2m) == 4;       % April is month 4
yearFilter2m = year(dates2m) == 2024;
monthFilter8m = month(dates8m) == 4;
yearFilter8m = year(dates8m) == 2024;

% Combine filters for April 2024 for both datasets
april2024Filter2m = monthFilter2m & yearFilter2m;
april2024Filter8m = monthFilter8m & yearFilter8m;

% Get temperatures and dates for April 2024
april2024Temps2m = SI2_md_dataTable.Temperature(april2024Filter2m);
april2024Dates2m = dates2m(april2024Filter2m);
april2024Temps8m = SI8_md_dataTable.Temperature(april2024Filter8m);
april2024Dates8m = dates8m(april2024Filter8m);

% Check if data exists for both datasets
if isempty(april2024Temps2m) || isempty(april2024Temps8m)
    fprintf('No complete data available for April 2024.\n');
else
    % Find common days with data in both datasets
    [commonDates, idx2m, idx8m] = intersect(april2024Dates2m, april2024Dates8m);
    
    % Calculate daily differences (max at 2m - min at 8m for each day)
    dailyMaxDiffs = april2024Temps2m(idx2m) - april2024Temps8m(idx8m);
    
    % Find the maximum difference and its corresponding date
    [maxDiff, maxDiffIdx] = max(dailyMaxDiffs);
    maxDiffDate = commonDates(maxDiffIdx);
    
    % Display results
    fprintf('Maximum Temperature Difference in April 2024:\n');
    fprintf('Date: %s\n', datestr(maxDiffDate, 'dd-mmm-yyyy'));
    fprintf('Difference: %.2f°C (2m: %.2f°C, 8m: %.2f°C)\n', ...
            maxDiff, ...
            april2024Temps2m(idx2m(maxDiffIdx)), ...
            april2024Temps8m(idx8m(maxDiffIdx)));
end


%% Open the SST to make Fig 2 shaded area undeneath


% Open the SST
sst_path = '/Users/gonzaloprb/Documents/AAASea_Science/AAA_Post_Doc_Alex_Wyatt/Hong_Kong_2024_Bleaching/Environmental_Data/Satellite_SST/Alex_Code/';

load([sst_path,'HongKong_CoralTemp_0p25deg.mat'])


% SST

SST_Table = table(SSTt, SST, ...
    'VariableNames', {'Date_Time', 'Temperature'});

SST_DHD_Table = table(SST_DHt{1}, SST_DH{1}', ...
    'VariableNames', {'Date_Time', 'DHDs'});

% Transform to datetime
SST_Table.Date_Time = datetime(SST_Table.Date_Time, 'ConvertFrom', 'datenum');

SST_DHD_Table.Date_Time = datetime(SST_DHD_Table.Date_Time, 'ConvertFrom', 'datenum');


%%%%%% DATA TO COMPLETE THE TABLE
% Data to complete the table


% Obtain max temperatures for 2022 and 2024 for SST_Table
% Extract year from Date_Time
dates = datetime(SST_Table.Date_Time, 'InputFormat', 'dd-MMM-yyyy');
years = year(dates);
% Find max temperature and corresponding date for 2022
temp2022 = SST_Table.Temperature(years == 2022);
dates2022 = dates(years == 2022);
[max2022, idx2022] = max(temp2022);
maxDate2022 = dates2022(idx2022);
% Find max temperature and corresponding date for 2024
temp2024 = SST_Table.Temperature(years == 2024);
dates2024 = dates(years == 2024);
[max2024, idx2024] = max(temp2024);
maxDate2024 = dates2024(idx2024);
% Display results
fprintf('Maximum Temperature:\n');
fprintf('2022: %.2f°C on %s\n', max2022, datestr(maxDate2022, 'dd-mmm-yyyy HH:MM:SS'));
fprintf('2024: %.2f°C on %s\n', max2024, datestr(maxDate2024, 'dd-mmm-yyyy HH:MM:SS'));



% Obtain max DHDs for 2022 and 2024 and display the number of dates above
% DHDs = 8
% Extract date (without time) from Date_Time
dates = datetime(SST_DHD_Table.Date_Time, 'InputFormat', 'dd-MMM-yyyy');
datesOnly = dates; % Keep full datetime for filtering
years = year(datesOnly);
% Get DHDs for 2022 and 2024
DHD2022 = SST_DHD_Table.DHDs(years == 2022);
dates2022 = datesOnly(years == 2022);
DHD2024 = SST_DHD_Table.DHDs(years == 2024);
dates2024 = datesOnly(years == 2024);
% Count UNIQUE days where DHDs > 8 (2022)
% Convert dates to day numbers (e.g., day-of-year) and use accumarray
[uniqueDays2022, ~, dayIdx2022] = unique(floor(datenum(dates2022))); % Group by day
daysAbove8_2022 = sum(accumarray(dayIdx2022, DHD2022 > 8, [], @any));
% Count UNIQUE days where DHDs > 8 (2024)
[uniqueDays2024, ~, dayIdx2024] = unique(floor(datenum(dates2024))); % Group by day
daysAbove8_2024 = sum(accumarray(dayIdx2024, DHD2024 > 8, [], @any));
% Display results
fprintf('Number of UNIQUE days with DHDs > 8:\n');
fprintf('2022: %d days\n', daysAbove8_2022);
fprintf('2024: %d days\n', daysAbove8_2024);
% Display max DHDs per year for 2022 and 2024
[max2022, idx2022] = max(DHD2022);
maxDate2022 = dates2022(idx2022);
[max2024, idx2024] = max(DHD2024);
maxDate2024 = dates2024(idx2024);
fprintf('\nMaximum DHDs:\n');
fprintf('2022: %.2f°C-days on %s\n', max2022, datestr(maxDate2022, 'dd-mmm-yyyy HH:MM:SS'));
fprintf('2024: %.2f°C-days on %s\n', max2024, datestr(maxDate2024, 'dd-mmm-yyyy HH:MM:SS'));


%%%%%%%% MAKE THE FIGURES AGAIN


% Make the Figure of all loggers and SST
% Plot all the logger temperatures and SST only for 2022 and 2024
figure; hold on;

% === Plot the SST in black ===
plot(SST_Table.Date_Time, SST_Table.Temperature,  'Color', 'black', 'LineWidth', 1);

% === Colorblind-friendly palette ===
% Bluff Island (Cool colors - dotted lines)
bluff_colors = [
    0 0.45 0.7;    % Dark blue
    0.3 0.7 0.9;   % Light blue
    0.1 0.6 0.3    % Green
];

% Sharp Island (Warm colors - solid lines)
sharp_colors = [
    0.8 0.2 0.2;   % Red
    0.9 0.6 0;     % Orange
    0.6 0.2 0.6;   % Purple
    0.9 0.4 0.6;   % Pink
    0.7 0.7 0      % Yellow-green
];

% TPC (Distinct style - dashed line)
tpc_color = [0.4 0 0.4];  % Dark purple

% === Bluff (Dotted Lines) ===
plot(BI2_md_dataTable.Date_Time, BI2_md_dataTable.Temperature, ':', 'Color', bluff_colors(1,:), 'LineWidth', 1);
plot(BI5_sb_dataTable.Date_Time, BI5_sb_dataTable.Temperature, ':', 'Color', bluff_colors(2,:), 'LineWidth', 1);
plot(BI5_md_dataTable.Date_Time, BI5_md_dataTable.Temperature, ':', 'Color', bluff_colors(3,:), 'LineWidth', 1);

% === Sharp (Solid Lines) ===
plot(SI2_md_dataTable.Date_Time, SI2_md_dataTable.Temperature, '-', 'Color', sharp_colors(1,:), 'LineWidth', 1);
plot(SI3_sb_dataTable.Date_Time, SI3_sb_dataTable.Temperature, '-', 'Color', sharp_colors(2,:), 'LineWidth', 1);
plot(SI4_sb_dataTable.Date_Time, SI4_sb_dataTable.Temperature, '-', 'Color', sharp_colors(3,:), 'LineWidth', 1);
plot(SI5_md_dataTable.Date_Time, SI5_md_dataTable.Temperature, '-', 'Color', sharp_colors(4,:), 'LineWidth', 1);
plot(SI8_md_dataTable.Date_Time, SI8_md_dataTable.Temperature, '-', 'Color', sharp_colors(5,:), 'LineWidth', 1);

% === TPC (Dashed Line) ===
plot(TPC3_sb_dataTable.Date_Time, TPC3_sb_dataTable.Temperature, '--', 'Color', tpc_color, 'LineWidth', 1.5); % Thicker for visibility

% Set axis limits and labels
xlim([datetime('2022-01-01'), datetime('2024-11-05')]);
xlabel('Time (Month Year)');
ylabel('Temperatures (ºC)');

% Legend ordered by plotting sequence
legend(...
    'SST', ...
    'BI 2 m (MD)','BI 5 m (SB)', 'BI 5 m (MD)', ...  % Bluff first (cool colors)
    'SI 2 m (MD)','SI 3 m (SB)', 'SI 4 m (SB)', 'SI 5 m (MD)', 'SI 8 m (MD)', ...  % Then Sharp (warm colors)
    'TPC 3 m (SB)', ...  % Finally TPC
    'Location', 'southeast', 'FontSize', 8, 'Box', 'on');

% Improve plot appearance
grid on;
box on;
set(gca, 'FontSize', 10, 'LineWidth', 0.5);


% Save as FIG
save_path = '/Users/gonzaloprb/Documents/AAASea_Science/AAA_Post_Doc_Alex_Wyatt/Hong_Kong_2024_Bleaching/Environmental_Data/Temp_Loggers/Figure_Outputs/';
% Save as FIG
fig_path = fullfile(save_path, 'Temperatures_2022_2024.fig');
savefig(fig_path);


% Plot all the logger temperatures only for 2022 and 2024




% Make the Figures of DHDs
% Ready to make the figures:

% Make the plot for 2022
figure; hold on;

% === SST as gray shaded area ===
area(SST_DHD_Table.Date_Time, SST_DHD_Table.DHDs, ...
    'FaceColor', [0.8 0.8 0.8], 'EdgeColor', 'none', 'FaceAlpha', 0.5);

% === Colorblind-friendly palette ===
% Bluff Island (Cool colors - dotted lines)
bluff_colors = [
    0 0.45 0.7;    % Dark blue
    0.3 0.7 0.9;   % Light blue
    0.1 0.6 0.3    % Green
];

% Sharp Island (Warm colors - solid lines)
sharp_colors = [
    0.8 0.2 0.2;   % Red
    0.9 0.6 0;     % Orange
    0.6 0.2 0.6;   % Purple
    0.9 0.4 0.6;   % Pink
    0.7 0.7 0      % Yellow-green
];

% TPC (Distinct style - dashed line)
tpc_color = [0.4 0 0.4];  % Dark purple

% === Bluff (Dotted Lines) ===
plot(BI2_md_DHD_Table.Date_Time, BI2_md_DHD_Table.DHDs, ':', 'Color', bluff_colors(1,:), 'LineWidth', 1);
plot(BI5_sb_DHD_Table.Date_Time, BI5_sb_DHD_Table.DHDs, ':', 'Color', bluff_colors(2,:), 'LineWidth', 1);
plot(BI5_md_DHD_Table.Date_Time, BI5_md_DHD_Table.DHDs, ':', 'Color', bluff_colors(3,:), 'LineWidth', 1);

% === Sharp (Solid Lines) ===
plot(SI2_md_DHD_Table.Date_Time, SI2_md_DHD_Table.DHDs, '-', 'Color', sharp_colors(1,:), 'LineWidth', 1);
plot(SI3_sb_DHD_Table.Date_Time, SI3_sb_DHD_Table.DHDs, '-', 'Color', sharp_colors(2,:), 'LineWidth', 1);
plot(SI4_sb_DHD_Table.Date_Time, SI4_sb_DHD_Table.DHDs, '-', 'Color', sharp_colors(3,:), 'LineWidth', 1);
plot(SI5_md_DHD_Table.Date_Time, SI5_md_DHD_Table.DHDs, '-', 'Color', sharp_colors(4,:), 'LineWidth', 1);
plot(SI8_md_DHD_Table.Date_Time, SI8_md_DHD_Table.DHDs, '-', 'Color', sharp_colors(5,:), 'LineWidth', 1);

% === TPC (Dashed Line) ===
plot(TPC3_sb_DHD_Table.Date_Time, TPC3_sb_DHD_Table.DHDs, '--', 'Color', tpc_color, 'LineWidth', 1.5); % Thicker for visibility

% Set axis limits and labels
xlim([datetime('2022-05-01'), datetime('2022-12-31')]);
ylim([0 36]);
xlabel('Time (Months)');
ylabel('DHDs (ºC–days)');

% Legend with improved readability
legend(...
    'SST', ...
    'BI 2 m (MD)','BI 5 m (SB)', 'BI 5 m (MD)', ...
    'SI 2 m (MD)','SI 3 m (SB)', 'SI 4 m (SB)', 'SI 5 m (MD)', 'SI 8 m (MD)', ...
    'TPC 3 m (SB)', ...
    'Location', 'northeast', 'FontSize', 8, 'Box', 'on');

% Improve plot appearance
grid on;
box on;
set(gca, 'FontSize', 10, 'LineWidth', 0.5);
title('Heat accumulation during the 2022 heatwave', 'FontSize', 12);


% Save as FIG
save_path = '/Users/gonzaloprb/Documents/AAASea_Science/AAA_Post_Doc_Alex_Wyatt/Hong_Kong_2024_Bleaching/Environmental_Data/Temp_Loggers/Figure_Outputs/';
% Save as FIG
fig_path = fullfile(save_path, 'Heatwave_2022.fig');
savefig(fig_path);


% Plot for 2024
figure; hold on;

% === SST as gray shaded area ===
area(SST_DHD_Table.Date_Time, SST_DHD_Table.DHDs, ...
    'FaceColor', [0.8 0.8 0.8], 'EdgeColor', 'none', 'FaceAlpha', 0.5);

% === Colorblind-friendly palette ===
% Bluff Island (Cool colors - dotted lines)
bluff_colors = [
    0 0.45 0.7;    % Dark blue
    0.3 0.7 0.9;   % Light blue
    0.1 0.6 0.3    % Green
];

% Sharp Island (Warm colors - solid lines)
sharp_colors = [
    0.8 0.2 0.2;   % Red
    0.9 0.6 0;     % Orange
    0.6 0.2 0.6;   % Purple
    0.9 0.4 0.6;   % Pink
    0.7 0.7 0      % Yellow-green
];

% TPC (Distinct style - dashed line)
tpc_color = [0.4 0 0.4];  % Dark purple

% === Bluff (Dotted Lines) ===
plot(BI2_md_DHD_Table.Date_Time, BI2_md_DHD_Table.DHDs, ':', 'Color', bluff_colors(1,:), 'LineWidth', 1);
plot(BI5_sb_DHD_Table.Date_Time, BI5_sb_DHD_Table.DHDs, ':', 'Color', bluff_colors(2,:), 'LineWidth', 1);
plot(BI5_md_DHD_Table.Date_Time, BI5_md_DHD_Table.DHDs, ':', 'Color', bluff_colors(3,:), 'LineWidth', 1);

% === Sharp (Solid Lines) ===
plot(SI2_md_DHD_Table.Date_Time, SI2_md_DHD_Table.DHDs, '-', 'Color', sharp_colors(1,:), 'LineWidth', 1);
plot(SI3_sb_DHD_Table.Date_Time, SI3_sb_DHD_Table.DHDs, '-', 'Color', sharp_colors(2,:), 'LineWidth', 1);
plot(SI4_sb_DHD_Table.Date_Time, SI4_sb_DHD_Table.DHDs, '-', 'Color', sharp_colors(3,:), 'LineWidth', 1);
plot(SI5_md_DHD_Table.Date_Time, SI5_md_DHD_Table.DHDs, '-', 'Color', sharp_colors(4,:), 'LineWidth', 1);
plot(SI8_md_DHD_Table.Date_Time, SI8_md_DHD_Table.DHDs, '-', 'Color', sharp_colors(5,:), 'LineWidth', 1);

% === TPC (Dashed Line) ===
plot(TPC3_sb_DHD_Table.Date_Time, TPC3_sb_DHD_Table.DHDs, '--', 'Color', tpc_color, 'LineWidth', 1.5); % Thicker for visibility

% Set axis limits and labels
xlim([datetime('2024-05-01'), datetime('2024-12-31')]);
ylim([0 36]); % Fixed y-axis from 0 to 36
xlabel('Time (Months)');
ylabel('DHDs (ºC–days)');

% Legend with improved readability
legend(...
    'SST', ...
    'BI 2 m (MD)','BI 5 m (SB)', 'BI 5 m (MD)', ...
    'SI 2 m (MD)','SI 3 m (SB)', 'SI 4 m (SB)', 'SI 5 m (MD)', 'SI 8 m (MD)', ...
    'TPC 3 m (SB)', ...
    'Location', 'northeast', 'FontSize', 8, 'Box', 'on');

% Improve plot appearance
grid on;
box on;
set(gca, 'FontSize', 10, 'LineWidth', 0.5);
title('Heat accumulation during the 2024 heatwave', 'FontSize', 12);


% Save as FIG
save_path = '/Users/gonzaloprb/Documents/AAASea_Science/AAA_Post_Doc_Alex_Wyatt/Hong_Kong_2024_Bleaching/Environmental_Data/Temp_Loggers/Figure_Outputs/';
% Save as FIG
fig_path = fullfile(save_path, 'Heatwave_2024.fig');
savefig(fig_path);


