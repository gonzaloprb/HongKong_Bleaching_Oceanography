# HongKong_Bleaching_Oceanography 

Data and codes for Pérez-Rosales et al., 2026 (Coral Reefs)

Article title: Shallow seasonal stratification ameliorates coral bleaching during record-breaking marine heatwaves in a marginal subtropical system 

Citation: Pérez-Rosales G., Pei, Y.-D., Bennet-Williams J., King T.B., Rummel M., Chung T.H., Wyatt A.S.J.W. (2026) Shallow seasonal stratification ameliorates coral bleaching during record‑breaking marine heatwaves in a marginal subtropical system. Coral Reefs. https://doi.org/10.1007/s00338-026-02835-w 

## Description of the data 

Because of some file sizes, some data are not updated on GitHub, but can be accessed at: (https://doi.org/10.5061/dryad.ht76hdrxc)
 
### Data/Bleaching Folder:
* File: Bleaching_Survey_05022025.csv

Info
	Column Site – study site (Sharp Island, Bluff Island, Tung Ping Chau)
	Column Date – date of survey
	Column Depth - categorical across three depth ranges (1_2m, 2_3m, 4_5m)
	Column Transect – categorical three transects (T1, T2, T3)
	Column Species – categorical species ID taxa, please note that later they were transformed into Genus levels
	Column Size – categorical three sizes (Large, Medium, Small). These were later dropped and not considered in the analysis
	Column Status – multicategory bleaching status (Pigmented, Partial Bleached, Bleached, Dead)
	Column Number Observations – Counting of colonies across each species, size and status
	
Raw data from the bleaching surveys during August 2024, at the peak of the bleaching, and November 2024 post bleaching.
Please note that the transect surveys were conducted at multi-species-genus levels initially, but that later analysis and results were transformed at genus level only. 

* File: data_bm_2022.csv

Info
	Column Site – three study sites (Sharp Island, Bluff Island, Tung Ping Chau)
	Column Depth - categorical across two depths (2 and 3)
	Column Species – categorical species ID taxa, directly at genus levels
	Column Status – Binomial (1 = bleached, and 0 = pigmented)
	Column Number Observations – Counting of colonies across each species, size and status
	Column Year – Categorical (2022)

Bleaching data from 2022 (Chung et al 2024 Coral Reefs https:// doi. org/ 10. 1007/ S00338- 024- 02533-5). Processed with "Data_Viz_Chung_Data_2022.R" from original data files inside Bleaching/Chung_data/.  

* File: data_bm_2024.csv

Info
	Column Site – study site (Sharp Island, Bluff Island, Tung Ping Chau)
	Column Depth - categorical across three depth ranges (1, 2 and 3); equivalent to 1_2m, 2_3m and 4_5m
	Column Transect – categorical three transects (T1, T2, T3)
	Column Species – categorical species ID taxa, please note that later they were transformed into Genus levels
	Column Status – Binomial (1 = bleached, and 0 = pigmented)
	Column Number Observations – Counting of colonies across each species, size and status
	Column Year – Categorical (2024)
	
Bleaching data from 2024. Created from the original Bleaching_Survey_05022025.csv and the Script "Data_Viz_Preliminary.R"



### Data/Environment Folder:
Environmental monitoring data from three study sites in Hong Kong:

S1 – Tung Ping Chau  
S18 – Bluff Island  
S21 – Sharp Island

### Data/Environment/CTD_Transects: 
Folders per Month/Year Cast "Oct2022", "May2022", "Aug2024", "Nov2024"

Each Folder contains the Date-Site and the 11 cast stations in a mat file (.mat)

	Lat – Latitude (decimal)
	Lon – Longitude (decimal)
	Station (Cast number)
	Transect (Site name code)
	data (see below)
	metadata (see below)    
	
And inside data, data.physical. there are the following variables:
  
	pressure (dbar) – pressure measured by the sensor, approximately equivalent to water depth
	temperature (°C) – seawater temperature
	salinity (PSU) – practical salinity derived from conductivity measurements
	conductivity1 (mS cm⁻¹) – electrical conductivity measured by the sensor
	ec25 (µS cm⁻¹) – electrical conductivity corrected to 25 °C
	density (kg m⁻³) – seawater density calculated from temperature and salinity
	sigma_t (kg m⁻³) – density anomaly (σt) referenced to atmospheric pressure
	chl_flu (ppb) – chlorophyll fluorescence
	chl_a (µg L⁻¹) – chlorophyll a concentration
	turbidity (FTU) – turbidity measured in formazin turbidity units
	do (%) – dissolved oxygen saturation
	do_mg (mg L⁻¹) – dissolved oxygen concentration
	do_umol (µmol L⁻¹) – dissolved oxygen concentration
	battery (V) – logger battery voltage

Inside metadata there are: 

	SondeName – name of the sonde instrument model
	SondeNo – sonde number (instrument identifier - serial number)
	Device – device information stored in the instrument metadata
	Measurement – measurement information stored in the instrument metadata

### Data/Environment/DEFI_loggers
These are mounted loggers to the bleaching transect pole that monitored exact Depth, Temperature and Light at the actual coral levels

One folder "082024" 

File of "DEFI_Average_Transects_202408.xlsx" contains the post-processed data

	Column Site – three study sites (Sharp Island, Bluff Island, Tung Ping Chau)
	Column Depth (m) - numerical average depths according to mounted loggers
	Column Depth (m) – depth standard deviation 
	Column Temperature (°C) – numerical average temperatures for each depth according to mounted loggers
	Column Temperature_sd (°C) – temperature standard deviation 
	
** The raw data are in the form of DEFI2-L, DEFI-D20 and DEFI-T csv files

For DEFI-D20
	Column TimeStamp – time in format YYYY/mm/dd hh:mm:ss
	Column Pressure (MPa)
	Column Depth (m)
	Column Batt – battery (Volts) 
	
For DEFI-T
	Column TimeStamp – time in format YYYY/mm/dd hh:mm:ss
	Column Temp – temperature (°C)
	Column Batt – battery (Volts) 
	
For DEFI2-L
	Column TimeStamp – time in format YYYY/mm/dd hh:mm:ss
	Column PAR – photosynthesis Active Radiation, light (umol/(m^2s)
	Column Batt – battery (Volts) 
	
	
### Data/Environment/Fixed_Loggers
* miniDOT
Available at https://doi.org/10.5061/dryad.ht76hdrxc

These data contain temperatures and oxygen from fixed loggers (PME) at different sites and depths

They contain data from 20240428 to post bleaching surveys at 20241105

Data is in a Matlab file format (.mat)

Info
	BV (Volts) - battery voltage
  	DH – MATLAB cell array containing cumulative Degree Heating metrics calculated from temperature anomaly above the bleaching threshold at multiple temporal scales:
		DH{1} (°C minutes) – Degree heating minutes 
		DH{2} (°C hours) – Degree heating hours 
		DH{3} (°C days) – Degree heating days 
		DH{4} (°C weeks) – Degree heating weeks 
		DH{5} (°C months) – Degree heating months  
	DHfilt - MATLAB cell array containing cumulative Degree Heating metrics calculated from a filtered temperature time series in which the semi-diurnal signal has been removed (same units as DH)
	DHt – timestamps associated with the Degree Heating metrics (DH), stored as MATLAB serial time (datenum).
	DO (mg L⁻¹) – dissolved oxygen concentration 
	DOsat (%) – dissolved oxygen saturation
	DeploymentType – logger deployment type (BTM = bottom-mounted)                                   
  	Depth (m) – depth of the logger deployment
	HH – cumulative hypoxic exposure (hours where dissolved oxygen falls below 2 mg L⁻¹). This metric was calculated during exploratory analyses and was not used in the bleaching models presented in the manuscript.
	HHt – timestamps associated with the HH metric (MATLAB serial date number).
  	Model – logger model
  	Q – logger data quality flag indicating measurement reliability (unitless).
  	SampleInt – logger sampling interval stored in MATLAB serial time units (fraction of a day; e.g., 10 min = 10/1440)
  	Serial – logger serial number
  	Site –  study site (Sharp Island, Bluff Island, Tung Ping Chau)
  	Temp (°C)  – seawater temperature
  	TempFilt (°C) – seawater temperature time series after filtering to remove the semi-diurnal variability
	Time – timestamp of measurement, stored as MATLAB serial time (datenum).
	TimeIn – timestamp when the logger was deployed, stored as MATLAB serial time (datenum).
	TimeOut – timestamp when the logger was recovered, stored as MATLAB serial time (datenum).


miniDOT loggers were not deployed at S1 Tung Ping Chau

* SBE
Available at https://doi.org/10.5061/dryad.ht76hdrxc

These data contain temperatures from fixed loggers (Seabirds) at different sites and depths

They contain data from 20201104 to post bleaching surveys at 20241106

Data is in a Matlab file format (.mat)

Info
	DH – MATLAB cell array containing cumulative Degree Heating metrics calculated from temperature anomaly above the bleaching threshold at multiple temporal scales:
		DH{1} (°C minutes) – Degree heating minutes 
		DH{2} (°C hours) – Degree heating hours 
		DH{3} (°C days) – Degree heating days 
		DH{4} (°C weeks) – Degree heating weeks 
		DH{5} (°C months) – Degree heating months  
	DHfilt - MATLAB cell array containing cumulative Degree Heating metrics calculated from a filtered temperature time series in which the semi-diurnal signal has been removed (same units as DH)
  	DHt – timestamps associated with the Degree Heating metrics (DH), stored as MATLAB serial time (datenum).
	DeploymentType – logger deployment type (BTM = bottom-mounted)                      
  	Depth (m) – depth of the logger deployment                 
  	Model – logger model                     
  	SampleInt – logger sampling interval stored in MATLAB serial time units (fraction of a day; e.g., 10 min = 10/1440)                  
  	Serial – logger serial number                                
  	Site –  study site                                 
  	Temp (°C)  – seawater temperature                          
  	TempFilt (°C) – seawater temperature time series after filtering to remove the semi-diurnal variability 	            
	Time – timestamp of measurement, stored as MATLAB serial time (datenum).
	TimeIn – timestamp when the logger was deployed, stored as MATLAB serial time (datenum).
	TimeOut – timestamp when the logger was recovered, stored as MATLAB serial time (datenum).
	d24hrTmax (°C) – maximum seawater temperature within a rolling 24-hour window.
	d24hrTmin (°C) – minimum seawater temperature within a rolling 24-hour window.
	d24hrTrange (°C) – temperature range within a rolling 24-hour window (d24hrTmax − d24hrTmin).
	d24hrTvar (°C²) – temperature variance within a rolling 24-hour window.
	d24hrt – timestamps associated with the rolling 24-hour temperature statistics, stored as MATLAB serial time (datenum).                               
	dailyTavg (°C) – mean seawater temperature calculated for each day.
	dailyTmax (°C) – maximum seawater temperature recorded within each day.
	dailyTmin (°C) – minimum seawater temperature recorded within each day.
	dailyTrange (°C) – daily temperature range calculated as dailyTmax − dailyTmin.
	dailyTvar (°C²) – variance of seawater temperature within each day.
	dailyt – timestamps associated with the daily temperature statistics, stored as MATLAB serial time (datenum).                

### Data/Environment/Satellite
Available at https://doi.org/10.5061/dryad.ht76hdrxc

Data file is "HongKong_CoralTemp_0p25deg.mat" and contains the following variables: 

Info
	SST – Sea surface temperature (°C).
	SST_DH – MATLAB cell array containing cumulative Degree Heating metrics calculated from sea surface temperature anomalies above the bleaching threshold at different temporal scales:
		SST_DH{1} (°C days) – Degree heating days 
		SST_DH{2} (°C weeks) – Degree heating weeks 
		SST_DH{3} (°C months) – Degree heating months 
	SST_DHt – timestamps associated with the SST_DH metrics, stored as MATLAB serial time (datenum).
	SSTt – timestamps associated with the SST time series, stored as MATLAB serial time (datenum).
  	Temp_avg_day (°C) – daily average satellite temperature                              
  	Temp_avg_day_std (°C) – daily average satellite temperature standard deviation                 
  	Temp_avg_month (°C) – monthly average satellite temperature                          
  	Temp_avg_month_std (°C) – monthly average satellite temperature standard deviation                      
  	Temp_daily (°C) – satellite daily temperature                               
  	Temp_monthly (°C) – satellite monthly temperature                          
  	YEAR                       

Sea Surface Satellite Data from the Coral Temp: https://coralreefwatch.noaa.gov/product/5km/index_5km_sst.php


## The R_Scripts are:
* File: Data_Viz_Preliminary.R

This is a massive script mainly for Data exploration and Visualisations

This script includes frequentist statistics as well as the Hurdle models

It generates Fig. 4 and Fig. S3 and Fig. S4

It generates the "data_bm_2024.csv" later used in the Bayesian model

For the Bayesian models better to use Scripts: "Read_Temps_Defi_Bayesian_Model.R" and "Bayesianmodel_Bleaching_Events.R"

* File: Data_Viz_Chung_Data_2022.R

Analyses and extract data from Chung TH, et al (2024) Local conditions modulated the effects of marine heatwaves on coral bleaching in subtropical Hong Kong waters. Coral Reefs 43(5):1235–1247. https://doi.org/10.1007/S00338-024-02533-5

It generates the "data_bm_2022.csv" later used in the Bayesian model

* File: Bayesianmodel_Bleaching_Events.R

Contains the Bayesian Models for the 2022 and 2024 Bleaching Events comparison. 

It generates Fig 2d and Fig 2e

* File: Read_Temps_Defi_Bayesian_Model.R

Bayesian modelling of bleaching data according to the mounted DEFI loggers

It generates the Bayesian statistical results

It generates Fig 5 and Fig 6

The best models are Bayes0_Depth and Bayes1_Temp. These are analysed separately.

## The Matlab scripts are: 
* File: CTD_Reading_Plots_CSV_Casts_Gon.m

It generates the Contour plots of the 11 CTD stations

It generates Fig 3

It runs on the Data/Environment/CTD_Transects

* File: Temp_Loggers_Read.m

It analyses the miniDOT and Seabird fixed logger temperatures

It generates Fig 2 b and c

It generates data for Table 1

The data can be accessed at https://doi.org/10.5061/dryad.ht76hdrxc

* File: Plot_GSHHS_coastline_Gon_Fastcode.m

It plots the SST map

It generates Fig 1

The data can be accessed at https://doi.org/10.5061/dryad.ht76hdrxc

* File: Plot_LongTermSST_Gon.m

It analyses the Satellite data from https://coralreefwatch.noaa.gov/product/5km/index_5km_sst.php

It generates Fig 2 a

The data can be accessed at https://doi.org/10.5061/dryad.ht76hdrxc




## Final comment: 
If you have any requests, do not hesitate to contact: 
gonzalo.prb[@]gmail.com 
or 
wyatt[@]ust.hk 


