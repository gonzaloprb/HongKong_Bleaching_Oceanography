
%Plots raw JFE ASTD CTD data and saves a csv file for each cast
% Data from Hong Kong Bleaching 2024
% adapted from Dataplotter_ASTDV2_20181202.m and CTD_Reading_Alex.m

% Gonzalo Perez-Roasles, May 2022

clear all
close all


dir_path = '/Users/gonzaloprb/Documents/AAASea_Science/AAA_Post_Doc_Alex_Wyatt/Hong_Kong_2024_Bleaching/Environmental_Data/CTD_transects/May2022/';


%% Define variables

sf=0; %smoothing factor, 2=0.5m for 0.1m data; 0 = no smoothing

% var=[]; varname=[];
% var=[var 2]; varname={varname; ['Temp (' char(176) 'C)']}; %Temp [deg C]
% var=[var 3]; varname=[varname; 'Salinity']; %Salinity
% % var=[var 4]; %Conductivity [mS/cm]
% % var=[var 5]; %EC25 [\mS/cm]
% % var=[var 6]; %Density [kg/m^3]
% var=[var 7]; %\sigmaT
% % var=[var 8]; %Chl-Flu. [ppb]
% var=[var 9]; varname={varname 'Chl-a (\mug L^-^1)'}; %Chl-a [\mug L^-^1]
% % var=[var 10]; %Turbidity [FTU]
% % var=[var 11]; %DO [%]
% var=[var 12]; %DO [mg/l]
% % var=[var 13]; %Battery [V]

% vname{1}=['Temp (' char(176) 'C)'];
% vname{2}='Salinity';
% vname{3}='\sigmaT';
% vname{4}='Chl-a (\mug L^-^1)';
% vname{5}='DO (mg/l)';

var{1}='temperature'; vname{1}=['Temp (' char(176) 'C)'];
var{2}='salinity'; vname{2}='Salinity';
var{3}='chl_a'; vname{3}='Chl-a (\mug L^-^1)';
var{4}='do_mg'; vname{4}='DO (mg/L)';

c=cbrewer('qual','Set1',length(var));

%% Define the data
% Adjust and check parameters

% Folder = ('/Users/gonzaloprb/Documents/AAASea_Science/AAA_Post_Doc_Alex_Wyatt/Hong_Kong_2024_Bleaching/Environmental_Data/CTD_transects/Aug2024/20240809-TPC/');
% FileList = dir([Folder '*.mat']); % Name of files
% N = size(FileList,1); % Number of files
% Depth=[0:-1:-15]'; % Adjust the depth!
% [datumE datumN utmzone]=deg2utm(22.544727,114.431654); % Adjust the time 



% 20220525-Sharp
Folder = ('/Users/gonzaloprb/Documents/AAASea_Science/AAA_Post_Doc_Alex_Wyatt/Hong_Kong_2024_Bleaching/Environmental_Data/CTD_transects/May2022/20220525-Sharp/');


FileList = dir([Folder '*.mat']);
N = size(FileList,1);
Depth=(0:-1:-15)';
[datumE, datumN, utmzone]=deg2utm(22.475140,114.322767);


Latitude=[];Longitude=[];BottomDepth=[]; datainterp=[]; Time=[]; depthlim=[]; Easting=[]; Northing=[];

% Define the folder where you want to save the figures
figureFolder = [Folder,'Figures']; % Folder name


% Check if the folder exists, if not, create it
if ~exist(figureFolder, 'dir')
    mkdir(figureFolder);
end


%% Plot Casts and generate a unique CSV file for each cast across depths.

% Initialize variables to accumulate data for averaging
all_depths = []; % To store all depth values
all_datasmooth = []; % To store all smoothed data

% Define the expected number of columns in datasmooth
expected_columns = 4; % Temp (°C), Salinity, Chl-a (g L-1), DO (mg/L)

% Main loop to process files and generate figures
for i = 1:N
    % Load data from CSV file
    csv_file = [Folder FileList(i).name];
    load(csv_file);
    
    % Extract time and depth data
    TimeIn = datenum(metadata.Measurement.StartTime);
    depth = -1 * data.physical.pressure;
    maxdepth = min(depth);
    
    % Convert latitude and longitude to UTM coordinates
    [East, North, utmzone] = deg2utm(Lat, Lon);
    
    % Append data to arrays
    Latitude = [Latitude; Lat];
    Longitude = [Longitude; Lon];
    Time = [Time; TimeIn];
    BottomDepth = [BottomDepth; maxdepth];
    Easting = [Easting; East];
    Northing = [Northing; North];
    
    % Prepare data for plotting
    data2 = [];
    for j = 1:length(var)
        data2 = [data2 data.physical.(var{j})];
        label{j} = vname{j};
    end
    labels = strjust(strvcat('Depth (m)', char(label)), 'center');
    
    % Smooth data if required
    if sf > 0
        datasmooth = nanmoving_average(data2, sf);
    else
        datasmooth = data2;
    end
    
    % Ensure datasmooth has the expected number of columns
    if size(datasmooth, 2) < expected_columns
        % Pad datasmooth with NaN values to match the expected number of columns
        datasmooth = [datasmooth, NaN(size(datasmooth, 1), expected_columns - size(datasmooth, 2))];
    end
    
    % Accumulate depth and smoothed data for averaging
    all_depths = [all_depths; depth]; % Append depth values
    all_datasmooth = [all_datasmooth; datasmooth]; % Append smoothed data
    
    % Interpolate data to a common depth grid
    depthlim = [depthlim maxdepth];
    inds = find(Depth < maxdepth);
    datainterpdum = interp1(depth, datasmooth, Depth, 'PCHIP');
    datainterpdum(inds, :) = NaN;
    datainterp = [datainterp datainterpdum];
    
    % Create a new figure
    figure;
    
    % Plot the data
    [h, ax] = plots(depth, datasmooth, 'bottom', labels, 15);
    grid on;
    box on;
    
    % Customize plot colors
    for k = 1:length(h)
        set(h(k), 'Color', c(k, :));
        set(ax(k), 'xColor', c(k, :));
    end
    
    % Add a title to the plot
    t = title(['Cast on ' datestr(TimeIn, 'dd-mmm-yy HH:MM') ' at ' Station ', bottom depth ' num2str(floor(maxdepth)) 'm']);
    tP = get(t, 'Position');
    set(t, 'Position', [tP(1) tP(2) + 0 tP(3)]);
    
    % Save the figure as a .fig file
    fig_filename = fullfile(figureFolder, ['Figure_Cast_', num2str(i), '.fig']);
    saveas(gcf, fig_filename); % Save the current figure as a .fig file
    
    % Save the figure as a .pdf file
    pdf_filename = fullfile(figureFolder, ['Figure_Cast_', num2str(i), '.pdf']);
    saveas(gcf, pdf_filename); % Save the current figure as a .pdf file
    
    % Close the figure (optional)
    close(gcf);
    
    % Create a table for the CSV file
    csv_data = table(depth, datasmooth(:, 1), datasmooth(:, 2), datasmooth(:, 3), datasmooth(:, 4), ...
        'VariableNames', {'Depth', 'Temp (°C)', 'Salinity', 'Chl-a (g L-1)', 'DO (mg/L)'});
    
    % Save the table to a CSV file
    csv_filename = fullfile(figureFolder, ['Cast_', num2str(i), '.csv']);
    writetable(csv_data, csv_filename);
end

% Display a confirmation message
disp(['Figures and individual CSV files saved successfully in the folder: ' figureFolder]);


%% Contour plot
% Initialize variables
Dx = 50;
De = diff(Easting);
Dn = diff(Northing);

% Calculate distances
distdum = [];
for i = 1:length(Easting)
    distdum = [distdum; sqrt(((Easting(i) - datumE).^2) + ((Northing(i) - datumN).^2))];
end
Distance = distdum;
[Distance, sortind] = sort(Distance, 'ascend');

% Sort data
datadum2 = [];
for i = 1:length(sortind)
    datadum2 = [datadum2 datainterp(:, (sortind(i) * length(var) - length(var) + 1):sortind(i) * length(var))];
end

% Ensure Depth is sorted in descending order
Depth = sort(Depth, 'descend');

% Create grid for interpolation
dist = min(Distance) - 1:Dx:max(Distance);
[XI, YI] = meshgrid(dist, Depth);

% Interpolate and plot for each variable
for i = 1:length(var)
    datadum = [];
    k = 0;
    for j = 1:N
        datadum = [datadum, datadum2(:, i + k * length(var))];
        k = k + 1;
    end

    % Ensure X, Y, and Z have compatible dimensions
    X = Distance; % X coordinates
    Y = Depth; % Y coordinates
    Z = datadum; % Z values

    % Perform griddata interpolation using 'linear' method
    Z_interp = griddata(X, Y, Z, XI, YI, 'linear');

    % Plot the interpolated data
    figure;
    P{i} = pcolor(XI, YI, Z_interp);
    shading interp;
    xlabel('Distance (m)');
    ylabel('Depth (m)');
    ylim([min(Depth), max(Depth)]); % Ensure ylim is set correctly for descending order

    % Add contour for dissolved oxygen (do_mg)
    if strcmp(var{i}, 'do_mg') == 1
        hold on;
        [C{i}, CH{i}] = contour(XI, YI, Z_interp, [2 2], 'Color', 'k', 'LineStyle', '-', 'LineWidth', 1);
    end

    % Add colorbar and customize
    c = colorbar;
    cdum = jet;
    colormap(gca, cdum);
    if strcmp(var{i}, 'do_mg') == 1
        clim([0 12]);
        % Use a built-in colormap or manually define one
        cmap = parula(64); % Example: Use the 'parula' colormap
        colormap(gca, cmap);
    end
    ylabel(c, [vname{i}]);
    axis('tight');
    set(gca, 'Layer', 'top');

    % Save the figure in the folder
    filename = fullfile(figureFolder, ['Figure_Contour_', num2str(i), '.fig']);
    saveas(gcf, filename); % Save the current figure as a fig file

    filename = fullfile(figureFolder, ['Figure_Contour_', num2str(i), '.pdf']);
    saveas(gcf, filename); % Save the current figure as a pdf file

    % Close the figure (optional)
    close(gcf);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% THE END ! %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 



