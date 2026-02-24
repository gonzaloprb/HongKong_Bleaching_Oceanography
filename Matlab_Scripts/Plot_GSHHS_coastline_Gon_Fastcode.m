
% Plot the coastline for HK (very slow code)

% Set the directory path
dir_path = '/Users/gonzaloprb/Documents/AAASea_Science/AAA_Post_Doc_Alex_Wyatt/Hong_Kong_2024_Bleaching/Environmental_Data/Satellite_SST/';



% open the coastline
load([dir_path,'HK_GSHHS_f_1deg.mat'])

% Open the SST
load([dir_path,'HongKong_CoralTemp_0p25deg.mat'])


levels = [HK_coastline.Level];
land = (levels == 1);
lake = (levels == 2);
island = (levels == 3);


% Quick plot for the given xlim and ylim
figure
hold on
coast=HK_coastline(land);
lat = [coast.Lat];
lon = [coast.Lon];
geoshow(lat,lon,"DisplayType","line","Color","black")
axis equal
xlim([113.6892 114.6803])
ylim([21.9101 22.6917])
box on
ylabel(['Latitude (' char(176) 'N)'])
xlabel(['Longitude (' char(176) 'E)'])
 
% Very slow plot with polygons


%% The location of 0.25 deg SST box

slat=21.85+0.5-0.125;
slon=114.95-0.5+0.125;
ndeg=0.125; deglab='0p25';


fprintf('Selected area: %g-%g degN x %g-%g degE \n',(slat-ndeg),(slat+ndeg),(slon-ndeg),(slon+ndeg));




