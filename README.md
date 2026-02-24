# HongKong_Bleaching_Oceanography 

Data and codes for Pérez-Rosales et al., 2026 (Coral Reefs)

Article title: Shallow seasonal stratification ameliorates coral bleaching during record-breaking marine heatwaves in a marginal subtropical system 

Citation: Pérez-Rosales G., Pei, Y.-D., Bennet-Williams J., King T.B., Rummel M., Chung T.H., Wyatt A.S.J.W. (2026) Shallow seasonal stratification ameliorates coral bleaching during record‑breaking marine heatwaves in a marginal subtropical system. Coral Reefs. https://doi.org/10.1007/s00338-026-02835-w 

## Description of the data 

Because of the file size, some data are not updated on GitHub, but can be accessed at: (https://doi.org/10.5061/dryad.ht76hdrxc)
 
### Data/Bleaching Folder:
* File: Bleaching_Survey_05022025.csv
** Raw data from the bleaching surveys during August 2024, at the peak of the bleaching, and November 2024 post bleaching.
** Please note that the transect surveys were conducted at multi-species-genus levels initially, but that later analysis and results were transformed at genus level only. 

* File: data_bm_2022.csv
** Bleaching data from 2022 (Chung et al 2024 Coral Reefs https:// doi. org/ 10. 1007/ S00338- 024- 02533-5). Processed with "Data_Viz_Chung_Data_2022.R" from original data files inside Bleaching/Chung_data/.  

* File: data_bm_2024.csv
** Bleaching data from 2024. Created from the original Bleaching_Survey_05022025.csv and the Script "Data_Viz_Preliminary.R"



### Data/Environment Folder:
Quick info
S1 = Tung Ping Chau,  S18 = Bluff Island, S21 = Sharp Island


### CTD_Transects: 
** Pending to be uploaded (file size problems)
** Folders per Month/Year Cast "Oct2022", "May2022", "Aug2024", "Nov2024"
** Each site Folder contains the 11 cast stations in a mat file (.mat)

### DEFI_loggers
** These are mounted loggers to the bleaching transect pole that monitored exact Depth, Temperature and Light at the actual coral levels
** Two folders "082024" and "112024"
** File of "DEFI_Average_Transects_202408.xlsx" contains the post-processed data
** The raw data are in the form of DEFI2-L, DEFI-D20 and DEFI-T csv files
** The November "112024" data was not used for the Bayesian model or the analysis

### Fixed_Temp_Loggers
* miniDOT
** Pending to be uploaded (file size problems)
** These data contain temperatures and oxygen from fixed loggers (PME) at different sites and depths
** They contain data from 20240428 to post bleaching surveys at 20241105
** Data is in a Matlab file format (.mat)
** S21 is Sharp Island, S18 is Bluff Island
** miniDOT loggers were not deployed at S1 Tung Ping Chau


* SBE
** Pending to be uploaded (file size problems)
** These data contain temperatures from fixed loggers (Seabirds) at different sites and depths
** They contain data from 20201104 to post bleaching surveys at 20241106
** Data is in a Matlab file format (.mat)
** S21 is Sharp Island, S18 is Bluff Island and S1 is Tung Ping Chau

### Satellite
** Available at https://doi.org/10.5061/dryad.ht76hdrxc
** Sea Surface Satellite Data from the Coral Temp: https://coralreefwatch.noaa.gov/product/5km/index_5km_sst.php
** Data file is "HongKong_CoralTemp_0p25deg.mat" in a Matlab format (.mat)

## The R_Scripts are:
* File: Data_Viz_Preliminary.R
** This is a massive script mainly for Data exploration and Visualisations
** This script includes frequentist statistics as well as the Hurdle models
** It generates Fig. 4 and Fig. S3 and Fig. S4
** It generates the "data_bm_2024.csv" later used in the Bayesian model
** For the Bayesian models better to use Scripts: "Read_Temps_Defi_Bayesian_Model.R" and "Bayesianmodel_Bleaching_Events.R"

* File: Data_Viz_Chung_Data_2022.R
** Analyses and extract data from Chung TH, et al (2024) Local conditions modulated the effects of marine heatwaves on coral bleaching in subtropical Hong Kong waters. Coral Reefs 43(5):1235–1247. https://doi.org/10.1007/S00338-024-02533-5
** It generates the "data_bm_2022.csv" later used in the Bayesian model

* File: Bayesianmodel_Bleaching_Events.R
** Contains the Bayesian Models for the 2022 and 2024 Bleaching Events comparison. 
** It generates Fig 2d and Fig 2e

* File: Read_Temps_Defi_Bayesian_Model.R
** Bayesian modelling of bleaching data according to the mounted DEFI loggers
** It generates the Bayesian statistical results
** It generates Fig 5 and Fig 6
** The best models are Bayes0_Depth and Bayes1_Temp. These are analysed separately.

## The Matlab scripts are: 
(To be completed)
* File: CTD_Reading_Plots_CSV_Casts_Gon.m
** It generates the Contour plots of the 11 CTD stations
** It generates Fig 3



If you have any requests, do not hesitate to contact: 
gonzalo.prb[@]gmail.com 
or 
wyatt[@]ust.hk 


