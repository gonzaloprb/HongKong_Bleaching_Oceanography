# This Script reads the Defi mounted loggers and extracts the exact Depths and temperatures of the Bleaching Transects
# The averages measured here were used to generate Excel "DEFI_Average_Transects_202408.csv"


# AAA: Read me (IMPORTANT!)
# One of the main problems is that when I filter to the depths with such a little 
# depth differences are tiny 4-5, 2-3 and 1-2 so some of the TRANSECTS get outside the depth range


# Opening data loggers mounted to the Transect device

# Data recorded continuously Depth, Light and Temperature. 

# Necessary to set the time-periods on which the video transects Sites and depths were done! 

# Read straight from CSV files from loggers. 

# Information loggers: 
# Depth, Light and Temp

#Necessary packages (in any case execute below)
library(ggplot2); library (ggpmisc)
library(RColorBrewer)
library (hms); library (lubridate)
library (dplyr)


# Choose directory where you have CSVs and function reading
setwd("~/Documents/AAASea_Science/AAA_Post_Doc_Alex_Wyatt/Hong_Kong_2024_Bleaching/Environmental_Data/DEFI_loggers/082024/")


#########
# Open CSV files from 2024-08-09 - Tung Ping Chau and Hoi Ha Wan (= Gruff Head)
df_Depth <- read.csv("DEFI2-D20_20240809093000_0ADO005.csv", header = T, dec = ".", sep = ",", skip = 25)
df_Light <- read.csv("DEFI2-L_20240809093000_0AAO032.csv", header = T, dec = ".", sep = ",", skip = 25)
# Problem in light file, it stopped registering light at "2024/08/09 11:19:47"
df_Temp <- read.csv("DEFI2-T_20240809093000_0AAF045.csv", header = T, dec = ".", sep = ",", skip = 24)


df_all <- merge (df_Depth[,c(1,3)], df_Light [,c(1,2)], by = "TimeStamp", all = T)
df_all <- merge (df_all, df_Temp [,c(1,2)], by = "TimeStamp", all = T)

# Set TimeStamp in the right format
df_all$TimeStamp <- ymd_hms (df_all$TimeStamp)

colnames (df_all) <- c ("Date_Time","Depth","PAR","Temp")

# Plot depth for quick visualisation 
ggplot(data = df_all, aes (x = Date_Time, y=Depth)) +
  geom_point(size = 0.2) +  scale_y_reverse() + theme_bw()

# Are there NAs?
colSums(is.na(df_all))

# Even if Light did not work, remove NA rows for Depth
df_all <- df_all[!is.na(df_all$Depth), ]
df_all <- df_all[!is.na(df_all$Temp), ]

# Necessary to correct depth offset
# It looks like of -0.4
df_all$Depth <- df_all$Depth + 0.4
# Make all negative values to 0
df_all$Depth <- ifelse(df_all$Depth < 0.25, 0, df_all$Depth) # I set 0.25 instead of 0 (surface) to avoid swimming surface values

# Make the plot again: 
ggplot(data = df_all, aes (x = Date_Time, y=Depth)) +
  geom_point(size = 0.2) +  scale_y_reverse() + theme_bw()


# You can see the two time periods diving in each site! 


########################################################################
# Parameters of the 1st site 
# TPC First dive at 2024-08-09 11:08 and last dive at 2024-08-09 13:12

# Give some margin
TPC <- df_all %>% filter(Date_Time > ymd_hms("2024-08-09 11:00:00") & Date_Time < ymd_hms("2024-08-09 13:25:00")) 

# Plot
ggplot(data = TPC, aes (x = Date_Time, y=Depth)) +
  geom_point(size = 0.2) +  scale_y_reverse() + theme_bw()

# scatter plot of Depth vs Temp
TPC %>%
  filter(Depth > 0) %>% # Filtering surface data!
  ggplot(aes (x=Depth, y = Temp)) +
  geom_point(size = 0.2)  +  
  stat_poly_line() +
  stat_poly_eq(use_label(c("eq", "R2")), label.y = 33, label.x = 3) +
  xlab("Depth (m)") + ylab("Temperatures (ºC)")+
  theme_bw()
# Necessary to correct the origin, it should not be 34...

TPC %>%
  filter(Depth > 0) %>% # Filtering surface data!
  ggplot(aes (x=Depth, y = PAR)) +
  geom_point(size = 0.2)  +  
  stat_poly_line() +
  stat_poly_eq(use_label(c("eq", "R2")), label.y = 33, label.x = 3) +
  xlab("Depth (m)") + ylab("PAR (umol)")+
  theme_bw()

# Secondary axis plot (better without ggplot), I created the following function
gonzalo_sec_axis_plot <- function(Name, dataset){
  
  # Set names:
  Name = Name  
  df = dataset
  
  par(mfrow=c(1,1))
  ## Plot first set of data and draw its axis
  plot(df$Date_Time, df$Depth, pch=20, cex = 0.5, axes=FALSE, ylim=c(max(df$Depth),min(df$Depth)), xlab="", ylab="", 
       type="b",col="black", main=paste ("Measures over diving time in",Name, sep = " "))
  axis(2, ylim=c(max(df$Depth),min(df$Depth)),col="black",las=1)  ## las=1 makes horizontal labels
  mtext("Depth (m)",side=2,line=2.5)
  box()
  ## Allow a second plot on the same graph
  par(new=TRUE)
  ## Plot the second plot and put axis scale on right
  plot(df$Date_Time, df$Temp, pch=20, cex = 0.5, xlab="", ylab="", ylim=c(min(df$Temp),max(df$Temp)), 
       axes=FALSE, type="b", col="red")
  ## Add the right y-axis
  axis(4, ylim=c(min(df$Temp),max(df$Temp)), las=1)
  ## a little farther out (line=4) to make room for labels
  mtext("Temperature (ºC)",side=4,line=2.5) 
  ## Draw the time axis
  r <- as.POSIXct(round(range(df$Date_Time), "mins"))
  axis.POSIXct(1, at = seq(r[1], r[2], by = "mins"), format = "%H:%M")
  mtext("Time",side=1,col="black",line=2.5)  
  ## Add Legend
  legend("topleft",legend=c("Depth","Temperature"),
         text.col=c("black","red"),pch=c(20,20),col=c("black","red"))
  
  
  return (plot)
}
# this is already a good result to add in the Manuscript!

# Introduce Name " " and dataset name

# For example
gonzalo_sec_axis_plot("TPC",TPC)

# 4-5 m: According to Go Pro Videos between 2024-08-09 11:02:00 and 2024-08-09 11:38:00
TPC_4_5m <- TPC %>% filter(Date_Time > ymd_hms("2024-08-09 11:02:00") & Date_Time < ymd_hms("2024-08-09 11:38:00")) 

ggplot(data = TPC_4_5m, aes ( x = Date_Time, y=Depth)) +
  geom_point(size = 0.2) +  scale_y_reverse() + theme_bw()
# It looks good enough!

# Filter measures outside this depth range
TPC_4_5m <- TPC_4_5m %>% filter(Depth > 4.5 & Depth < 5.5) 

# Exact average depth of transect: 
Depth_TPC_4_5m <- mean (TPC_4_5m$Depth)
Depth_sd_TPC_4_5m <- sd (TPC_4_5m$Depth)


ggplot(data = TPC_4_5m, aes (x = Date_Time, y = Depth)) +
  geom_point(size = 0.2) +  scale_y_reverse() + theme_bw()

ggplot(data = TPC_4_5m, aes (y=Temp, x = Date_Time)) +
  geom_point(size = 0.2) +  theme_bw()

# Exact average temp of transect: 
Temp_TPC_4_5m <- mean (TPC_4_5m$Temp)
Temp_sd_TPC_4_5m <- sd (TPC_4_5m$Temp)


# Use gonzalo_sec_axis_plot function
gonzalo_sec_axis_plot("TPC_4_5m",TPC_4_5m)


# 2-3 m: According to Go Pro Videos between 2024-08-09 12:06:00 and 2024-08-09 12:31:00
TPC_2_3m <- TPC %>% filter(Date_Time > ymd_hms("2024-08-09 12:06:00") & Date_Time < ymd_hms("2024-08-09 12:31:00")) 

ggplot(data = TPC_2_3m, aes (y=Depth, x = Date_Time)) +
  geom_point(size = 0.2)  + scale_y_reverse() + theme_bw()


TPC_2_3m <- TPC_2_3m %>% filter(Depth > 2.5 & Depth < 3.5) 

# Exact average depth of transect: 
Depth_TPC_2_3m <- mean (TPC_2_3m$Depth)
Depth_sd_TPC_2_3m <- sd (TPC_2_3m$Depth)


# A lot of data gets lost
ggplot(data = TPC_2_3m, aes (y=Depth, x = Date_Time)) +
  geom_point(size = 0.2) +  scale_y_reverse() + theme_bw()

ggplot(data = TPC_2_3m, aes (y=Temp, x = Date_Time)) +
  geom_point(size = 0.2) +   theme_bw()

# Exact average Temp of transect: 
Temp_TPC_2_3m <- mean (TPC_2_3m$Temp)
Temp_sd_TPC_2_3m <- sd (TPC_2_3m$Temp)


# Use gonzalo_sec_axis_plot function
gonzalo_sec_axis_plot("TPC_2_3m",TPC_2_3m)



# 1-2 m: According to Go Pro Videos between 2024-08-09 13:07:00 and 2024-08-09 13:25:00 (re-adjusted starting time)
TPC_1_2m <- TPC %>% filter(Date_Time > ymd_hms("2024-08-09 13:07:00") & Date_Time < ymd_hms("2024-08-09 13:23:00")) 

ggplot(data = TPC_1_2m, aes (y=Depth, x = Date_Time)) +
  geom_point(size = 0.2)  + scale_y_reverse() + theme_bw()

TPC_1_2m <- TPC_1_2m %>% filter(Depth > 0.5 & Depth < 2) # Necessary to expand from 1.5 to 2 to cover more data

# Exact average depth of transect: 
Depth_TPC_1_2m <- mean (TPC_1_2m$Depth)
Depth_sd_TPC_1_2m <- sd (TPC_1_2m$Depth)


ggplot(data = TPC_1_2m, aes (y=Depth, x = Date_Time)) +
  geom_point(size = 0.2) +  scale_y_reverse() + theme_bw()

ggplot(data = TPC_1_2m, aes (y=Temp, x = Date_Time)) +
  geom_point(size = 0.2) + theme_bw() # A little offside because it went deeeper (These values are filtered!)

# Exact average Temp of transect: 
Temp_TPC_1_2m <- mean (TPC_1_2m$Temp)
Temp_sd_TPC_1_2m <- sd (TPC_1_2m$Temp)


Light_TPC_1_2m <- mean (TPC_1_2m$PAR)
Light_TPC_4_5m <- mean (TPC_4_5m$PAR)

# Use gonzalo_sec_axis_plot function
gonzalo_sec_axis_plot("TPC_1_2m",TPC_1_2m)

# Manually added to the csv: "DEFI_Average_Transects_202408.csv"


########################################################################
# Parameters of the 2nd site (not included in the study)
# Ko Lo Wen First dive at 2024-08-09 14:50 and last dive at 2024-08-09 16:57


# Give some margin
KLW <- df_all %>% filter(Date_Time > ymd_hms("2024-08-09 14:50:00") & Date_Time < ymd_hms("2024-08-09 16:58:00")) 

# Plot
ggplot(data = KLW, aes (x = Date_Time, y=Depth)) +
  geom_point(size = 0.2) +  scale_y_reverse() + theme_bw()

# scatter plot of Depth vs Temp
KLW %>%
  filter(Depth > 0.4) %>% # Filtering surface data!
  ggplot(aes (x=Depth, y = Temp)) +
  geom_point(size = 0.2)  +  
  stat_poly_line() +
  stat_poly_eq(use_label(c("eq", "R2")) ) +
  theme_bw()
# Very nice regression


# Secondary axis plot (better without ggplot)
gonzalo_sec_axis_plot("KLW",KLW)


# 4-5 m: According to Go Pro Videos between 2024-08-09 16:12:00 and 2024-08-09 16:28:00
KLW_4_5m <- KLW %>% filter(Date_Time > ymd_hms("2024-08-09 16:12:00") & Date_Time < ymd_hms("2024-08-09 16:28:00")) 

ggplot(data = KLW_4_5m, aes ( x = Date_Time, y=Depth)) +
  geom_point(size = 0.2) +  scale_y_reverse() + theme_bw()
# It looks good enough!

# Filter measures outside this depth range
KLW_4_5m <- KLW_4_5m %>% filter(Depth > 4 & Depth < 5) 

ggplot(data = KLW_4_5m, aes (x = Date_Time, y = Depth)) +
  geom_point(size = 0.2) +  scale_y_reverse() + theme_bw()

ggplot(data = KLW_4_5m, aes (y=Temp, x = Date_Time)) +
  geom_point(size = 0.2) +  theme_bw()

# Use gonzalo_sec_axis_plot function
gonzalo_sec_axis_plot("KLW_4_5m",KLW_4_5m)


# 2-3 m: According to Go Pro Videos between 2024-08-09 16:40:00 and 2024-08-09 16:57:00
KLW_2_3m <- KLW %>% filter(Date_Time > ymd_hms("2024-08-09 16:40:00") & Date_Time < ymd_hms("2024-08-09 16:57:00")) 

ggplot(data = KLW_2_3m, aes (y=Depth, x = Date_Time)) +
  geom_point(size = 0.2)  + scale_y_reverse() + theme_bw()

KLW_2_3m <- KLW_2_3m %>% filter(Depth > 2 & Depth < 3) 

# A lot of data gets lost
ggplot(data = KLW_2_3m, aes (y=Depth, x = Date_Time)) +
  geom_point(size = 0.2) +  scale_y_reverse() + theme_bw()

ggplot(data = KLW_2_3m, aes (y=Temp, x = Date_Time)) +
  geom_point(size = 0.2) +   theme_bw()

# Use gonzalo_sec_axis_plot function
gonzalo_sec_axis_plot("KLW_2_3m",KLW_2_3m)



# 1-2 m: According to Go Pro Videos between 2024-08-09 14:50:00 and 2024-08-09 15:25:00
KLW_1_2m <- KLW %>% filter(Date_Time > ymd_hms("2024-08-09 14:50:00") & Date_Time < ymd_hms("2024-08-09 15:25:00")) 

ggplot(data = KLW_1_2m, aes (y=Depth, x = Date_Time)) +
  geom_point(size = 0.2)  + scale_y_reverse() + theme_bw()

KLW_1_2m <- KLW_1_2m %>% filter(Depth > 1 & Depth < 2) 

ggplot(data = KLW_1_2m, aes (y=Depth, x = Date_Time)) +
  geom_point(size = 0.2) +  scale_y_reverse() + theme_bw()

ggplot(data = KLW_1_2m, aes (y=Temp, x = Date_Time)) +
  geom_point(size = 0.2) + theme_bw()

# Use gonzalo_sec_axis_plot function
gonzalo_sec_axis_plot("KLW_1_2m",KLW_1_2m)


##### Finish 2024-08-09, change of day
########################################################################




# rm (list = ls ())

# Open CSV files for 2024-08-05, for Long Ke Wan, Bluff and Sharp
df_Depth <- read.csv("DEFI2-D20_20240805093000_0ADO005.csv", header = T, dec = ".", sep = ",", skip = 25)
df_Light <- read.csv("DEFI2-L_20240805093000_0AAO032.csv", header = T, dec = ".", sep = ",", skip = 25)
df_Temp <- read.csv("DEFI2-T_20240805093000_0AAF045.csv", header = T, dec = ".", sep = ",", skip = 24)



df_all <- merge (df_Depth[,c(1,3)], df_Light [,c(1,2)], by = "TimeStamp", all = T)
df_all <- merge (df_all, df_Temp [,c(1,2)], by = "TimeStamp", all = T)

# Set TimeStamp in the right format
df_all$TimeStamp <- ymd_hms (df_all$TimeStamp)

colnames (df_all) <- c ("Date_Time","Depth","PAR","Temp")

# Plot depth for quick visualisation 
ggplot(data = df_all, aes (x = Date_Time, y=Depth)) +
  geom_point(size = 0.2) +  scale_y_reverse() + theme_bw()

# Are there NAs?
colSums(is.na(df_all))

# Even if Light did not work, remove NA rows for Depth
df_all <- df_all[!is.na(df_all$Depth), ]
df_all <- df_all[!is.na(df_all$Temp), ]

# Necessary to correct depth offset
# It looks like of -0.4
df_all$Depth <- df_all$Depth + 0.4
# Make all negative values to 0
df_all$Depth <- ifelse(df_all$Depth < 0.25, 0, df_all$Depth) # I set 0.25 instead of 0 (surface) to avoid swimming surface values

# Make the plot again: 
ggplot(data = df_all, aes (x = Date_Time, y=Depth)) +
  geom_point(size = 0.2) +  scale_y_reverse() + theme_bw()



# 2024-08-05

# Parameters of the 1st site (not used in the study!)
# Long Ke Wan between 2024-08-05 10:35 until 12:17 


# First 2 and 3 m

# LKW_2_3_m between 2024-08-05 10:40:00 and 2024-08-05 11:12:00

# LKW_4_5_m between 2024-08-05 11:31:00 and 2024-08-05 12:17:00

# No transect at 1-2 m 



# Bluff Island between 2024-08-05 13:57 until 15:15
# First day no transect at 1-2 m
# BI_4_5_m between 2024-08-05 13:47:00 and 2024-08-05 14:35:00

# BI_2_3_m between 2024-08-05 14:58:00 and 2024-08-05 15:15:00


# BI
# Give some margin 
BI <- df_all %>% filter(Date_Time > ymd_hms("2024-08-05 13:47:30") & Date_Time < ymd_hms("2024-08-05 15:27:15")) 
# I added some extra time to be able to use the Scatter plot, and compare the 1-2 m temp with the day after

# Plot
ggplot(data = BI, aes (x = Date_Time, y=Depth)) +
  geom_point(size = 0.2) +  scale_y_reverse() + theme_bw()

# scatter plot of Depth vs Temp
BI %>%
  filter(Depth > 0) %>% # Filtering surface data!
  ggplot(aes (x=Depth, y = Temp)) +
  geom_point(size = 0.2)  +  
  stat_poly_line() +
  stat_poly_eq(use_label(c("eq", "R2")), label.y = 33, label.x = 3) +
  xlab("Depth (m)") + ylab("Temperatures (ºC)")+
  theme_bw()
# Necessary to correct the origin, it should not be 34...


# Secondary axis plot (better without ggplot), I created the following function
gonzalo_sec_axis_plot <- function(Name, dataset){
  
  # Set names:
  Name = Name  
  df = dataset
  
  par(mfrow=c(1,1))
  ## Plot first set of data and draw its axis
  plot(df$Date_Time, df$Depth, pch=20, cex = 0.5, axes=FALSE, ylim=c(max(df$Depth),min(df$Depth)), xlab="", ylab="", 
       type="b",col="black", main=paste ("Measures over diving time in",Name, sep = " "))
  axis(2, ylim=c(max(df$Depth),min(df$Depth)),col="black",las=1)  ## las=1 makes horizontal labels
  mtext("Depth (m)",side=2,line=2.5)
  box()
  ## Allow a second plot on the same graph
  par(new=TRUE)
  ## Plot the second plot and put axis scale on right
  plot(df$Date_Time, df$Temp, pch=20, cex = 0.5, xlab="", ylab="", ylim=c(min(df$Temp),max(df$Temp)), 
       axes=FALSE, type="b", col="red")
  ## Add the right y-axis
  axis(4, ylim=c(min(df$Temp),max(df$Temp)), las=1)
  ## a little farther out (line=4) to make room for labels
  mtext("Temperature (ºC)",side=4,line=2.5) 
  ## Draw the time axis
  r <- as.POSIXct(round(range(df$Date_Time), "mins"))
  axis.POSIXct(1, at = seq(r[1], r[2], by = "mins"), format = "%H:%M")
  mtext("Time",side=1,col="black",line=2.5)  
  ## Add Legend
  legend("topleft",legend=c("Depth","Temperature"),
         text.col=c("black","red"),pch=c(20,20),col=c("black","red"))
  
  
  return (plot)
}
# this is already a good result to add!

# Introduce Name " " and dataset name

# For example
gonzalo_sec_axis_plot("BI",BI)

# 4-5 m: According to Go Pro Videos and adjustements:
BI_4_5m <- BI %>% filter(Date_Time > ymd_hms("2024-08-05 13:47:30") & Date_Time < ymd_hms("2024-08-05 14:35:00")) 

ggplot(data = BI_4_5m, aes ( x = Date_Time, y=Depth)) +
  geom_point(size = 0.2) +  scale_y_reverse() + theme_bw()
# It looks good enough!

# Filter measures outside this depth range
BI_4_5m <- BI_4_5m %>% filter(Depth > 4.5 & Depth < 5.5) 

# Exact average depth of transect: 
Depth_BI_4_5m <- mean (BI_4_5m$Depth)
Depth_sd_BI_4_5m <- sd (BI_4_5m$Depth)


ggplot(data = BI_4_5m, aes (x = Date_Time, y = Depth)) +
  geom_point(size = 0.2) +  scale_y_reverse() + theme_bw()

ggplot(data = BI_4_5m, aes (y=Temp, x = Date_Time)) +
  geom_point(size = 0.2) +  theme_bw()

# Exact average temp of transect: 
Temp_BI_4_5m <- mean (BI_4_5m$Temp)
Temp_sd_BI_4_5m <- sd (BI_4_5m$Temp)


# Extract average light of transect
PAR_BI_4_5m <- mean (BI_4_5m$PAR)
PAR_sd_BI_4_5m <- sd (BI_4_5m$PAR)

# Use gonzalo_sec_axis_plot function
gonzalo_sec_axis_plot("BI_4_5m",BI_4_5m)


# 2-3 m: According to Go Pro Videos and ajustements:
BI_2_3m <- BI %>% filter(Date_Time > ymd_hms("2024-08-05 14:48:00") & Date_Time < ymd_hms("2024-08-05 15:15:15")) 

ggplot(data = BI_2_3m, aes (y=Depth, x = Date_Time)) +
  geom_point(size = 0.2)  + scale_y_reverse() + theme_bw()


BI_2_3m <- BI_2_3m %>% filter(Depth > 2 & Depth < 3) # Forced to change to 2 and 3 instead of 2.5-3.5. This transect was done a bit shallower

# Exact average depth of transect: 
Depth_BI_2_3m <- mean (BI_2_3m$Depth)
Depth_sd_BI_2_3m <- sd (BI_2_3m$Depth)

# A lot of data gets lost
ggplot(data = BI_2_3m, aes (y=Depth, x = Date_Time)) +
  geom_point(size = 0.2) +  scale_y_reverse() + theme_bw()

ggplot(data = BI_2_3m, aes (y=Temp, x = Date_Time)) +
  geom_point(size = 0.2) +   theme_bw()

# Exact average Temp of transect: 
Temp_BI_2_3m <- mean (BI_2_3m$Temp)
Temp_sd_BI_2_3m <- sd (BI_2_3m$Temp)

PAR_BI_2_3m <- mean (BI_2_3m$PAR)


# Use gonzalo_sec_axis_plot function
gonzalo_sec_axis_plot("BI_2_3m",BI_2_3m)

# 1-2 m transects in Bluff were done the day after: 2024-08-06
# however, measure the temperatures to compare with the day after
BI_1_2m <- BI %>% filter(Depth > 0.5 & Depth < 1.75) 

# Exact average temp for 1_2 m to compare with the day after
Temp_BI_1_2m <- mean (BI_1_2m$Temp)
Temp_sd_BI_1_2m <- sd (BI_1_2m$Temp)

PAR_BI_1_2m <- mean (BI_1_2m$PAR)
PAR_sd_BI_1_2m <- sd (BI_1_2m$PAR)


# Extract the Depth
Depth_BI_1_2m <- mean (BI_1_2m$Depth)
Depth_sd_BI_1_2m <- sd (BI_1_2m$Depth)



##### For the same day, change of Site, Sharp Island

# Sharp Island between  2024-08-05 16:15:00 until 2024-08-05 17:32:00

# SI_4_5_m between 2024-08-05 16:19:00 and 2024-08-05 16:33:00

# SI_2_3_m between 2024-08-05 16:46:00 and 2024-08-05 17:04:00

# SI_1_2_m between 2024-08-05 17:12:00 and 2024-08-05 17:29:00


# Sharp Island
# Give some margin
SI <- df_all %>% filter(Date_Time > ymd_hms("2024-08-05 16:15:00") & Date_Time < ymd_hms("2024-08-05 17:32:00")) 

# Plot
ggplot(data = SI, aes (x = Date_Time, y=Depth)) +
  geom_point(size = 0.2) +  scale_y_reverse() + theme_bw()

# scatter plot of Depth vs Temp
SI %>%
  filter(Depth > 0) %>% # Filtering surface data!
  ggplot(aes (x=Depth, y = Temp)) +
  geom_point(size = 0.2)  +  
  stat_poly_line() +
  stat_poly_eq(use_label(c("eq", "R2")), label.y = 33, label.x = 3) +
  xlab("Depth (m)") + ylab("Temperatures (ºC)")+
  theme_bw()
# Necessary to correct the origin, it should not be 34...


# Secondary axis plot (better without ggplot), I created the following function
gonzalo_sec_axis_plot <- function(Name, dataset){
  
  # Set names:
  Name = Name  
  df = dataset
  
  par(mfrow=c(1,1))
  ## Plot first set of data and draw its axis
  plot(df$Date_Time, df$Depth, pch=20, cex = 0.5, axes=FALSE, ylim=c(max(df$Depth),min(df$Depth)), xlab="", ylab="", 
       type="b",col="black", main=paste ("Measures over diving time in",Name, sep = " "))
  axis(2, ylim=c(max(df$Depth),min(df$Depth)),col="black",las=1)  ## las=1 makes horizontal labels
  mtext("Depth (m)",side=2,line=2.5)
  box()
  ## Allow a second plot on the same graph
  par(new=TRUE)
  ## Plot the second plot and put axis scale on right
  plot(df$Date_Time, df$Temp, pch=20, cex = 0.5, xlab="", ylab="", ylim=c(min(df$Temp),max(df$Temp)), 
       axes=FALSE, type="b", col="red")
  ## Add the right y-axis
  axis(4, ylim=c(min(df$Temp),max(df$Temp)), las=1)
  ## a little farther out (line=4) to make room for labels
  mtext("Temperature (ºC)",side=4,line=2.5) 
  ## Draw the time axis
  r <- as.POSIXct(round(range(df$Date_Time), "mins"))
  axis.POSIXct(1, at = seq(r[1], r[2], by = "mins"), format = "%H:%M")
  mtext("Time",side=1,col="black",line=2.5)  
  ## Add Legend
  legend("topleft",legend=c("Depth","Temperature"),
         text.col=c("black","red"),pch=c(20,20),col=c("black","red"))
  
  
  return (plot)
}
# this is already a good result to add!

# Introduce Name " " and dataset name

# For example
gonzalo_sec_axis_plot("SI",SI)

# 4-5 m: According to Go Pro Videos and adjusting loggers
SI_4_5m <- SI %>% filter(Date_Time > ymd_hms("2024-08-05 16:17:40") & Date_Time < ymd_hms("2024-08-05 16:39:30")) 

ggplot(data = SI_4_5m, aes ( x = Date_Time, y=Depth)) +
  geom_point(size = 0.2) +  scale_y_reverse() + theme_bw()
# It looks good enough!

# Filter measures outside this depth range
SI_4_5m <- SI_4_5m %>% filter(Depth > 4.5 & Depth < 5.5) 

# Exact average depth of transect: 
Depth_SI_4_5m <- mean (SI_4_5m$Depth)
Depth_sd_SI_4_5m <- sd (SI_4_5m$Depth)


ggplot(data = SI_4_5m, aes (x = Date_Time, y = Depth)) +
  geom_point(size = 0.2) +  scale_y_reverse() + theme_bw()

ggplot(data = SI_4_5m, aes (y=Temp, x = Date_Time)) +
  geom_point(size = 0.2) +  theme_bw()

# Exact average temp of transect: 
Temp_SI_4_5m <- mean (SI_4_5m$Temp)
Temp_sd_SI_4_5m <- sd (SI_4_5m$Temp)

PAR_SI_4_5m <- mean (SI_4_5m$PAR)


# Use gonzalo_sec_axis_plot function
gonzalo_sec_axis_plot("SI_4_5m",SI_4_5m)


# 2-3 m: According to Go Pro Videos and ajusting loggers
SI_2_3m <- SI %>% filter(Date_Time > ymd_hms("2024-08-05 16:44:30") & Date_Time < ymd_hms("2024-08-05 17:04:30")) 

ggplot(data = SI_2_3m, aes (y=Depth, x = Date_Time)) +
  geom_point(size = 0.2)  + scale_y_reverse() + theme_bw()


SI_2_3m <- SI_2_3m %>% filter(Depth > 2.2 & Depth < 3.5) # The transect was slighly shallower than 3 m

# Exact average depth of transect: 
Depth_SI_2_3m <- mean (SI_2_3m$Depth)
Depth_sd_SI_2_3m <- sd (SI_2_3m$Depth)


# A lot of data gets lost
ggplot(data = SI_2_3m, aes (y=Depth, x = Date_Time)) +
  geom_point(size = 0.2) +  scale_y_reverse() + theme_bw()

ggplot(data = SI_2_3m, aes (y=Temp, x = Date_Time)) +
  geom_point(size = 0.2) +   theme_bw()

# Exact average Temp of transect: 
Temp_SI_2_3m <- mean (SI_2_3m$Temp)
Temp_sd_SI_2_3m <- sd (SI_2_3m$Temp)

PAR_SI_2_3m <- mean (SI_2_3m$PAR)
PAR_sd_SI_2_3m <- sd (SI_2_3m$PAR)


# Use gonzalo_sec_axis_plot function
gonzalo_sec_axis_plot("SI_2_3m",SI_2_3m)


# 1-2 m: According to Go Pro Videos and loggers
SI_1_2m <- SI %>% filter(Date_Time > ymd_hms("2024-08-05 17:04:30") & Date_Time < ymd_hms("2024-08-05 17:31:30")) 

ggplot(data = SI_1_2m, aes (y=Depth, x = Date_Time)) +
  geom_point(size = 0.2)  + scale_y_reverse() + theme_bw()

SI_1_2m <- SI_1_2m %>% filter(Depth > 0.5 & Depth < 2) # Necessary to expand from 1.5 to 2 to cover more data at the depth of the transect

# Exact average depth of transect: 
Depth_SI_1_2m <- mean (SI_1_2m$Depth)
Depth_sd_SI_1_2m <- sd (SI_1_2m$Depth)

ggplot(data = SI_1_2m, aes (y=Depth, x = Date_Time)) +
  geom_point(size = 0.2) +  scale_y_reverse() + theme_bw()

ggplot(data = SI_1_2m, aes (y=Temp, x = Date_Time)) +
  geom_point(size = 0.2) + theme_bw() # A little offside because it went deeeper (These values are filtered!)

# Exact average Temp of transect: 
Temp_SI_1_2m <- mean (SI_1_2m$Temp)
Temp_sd_SI_1_2m <- sd (SI_1_2m$Temp)

PAR_SI_1_2m <- mean (SI_1_2m$PAR)
PAR_sd_SI_1_2m <- sd (SI_1_2m$PAR)


# Use gonzalo_sec_axis_plot function
gonzalo_sec_axis_plot("SI_1_2m",SI_1_2m)

# Add manually the information to the csv "DEFI_Average_Transects_202408.csv"

##### Change of date


# rm (list = ls ())

# Open CSV files for 2024-08-06
df_Depth <- read.csv("DEFI2-D20_20240806093000_0ADO005.csv", header = T, dec = ".", sep = ",", skip = 25)
df_Light <- read.csv("DEFI2-L_20240806093000_0AAO032.csv", header = T, dec = ".", sep = ",", skip = 25)
df_Temp <- read.csv("DEFI2-T_20240806093000_0AAF045.csv", header = T, dec = ".", sep = ",", skip = 24)



df_all <- merge (df_Depth[,c(1,3)], df_Light [,c(1,2)], by = "TimeStamp", all = T)
df_all <- merge (df_all, df_Temp [,c(1,2)], by = "TimeStamp", all = T)

# Set TimeStamp in the right format
df_all$TimeStamp <- ymd_hms (df_all$TimeStamp)

colnames (df_all) <- c ("Date_Time","Depth","PAR","Temp")

# Plot depth for quick visualisation 
ggplot(data = df_all, aes (x = Date_Time, y=Depth)) +
  geom_point(size = 0.2) +  scale_y_reverse() + theme_bw()

# Are there NAs?
colSums(is.na(df_all))

# Even if Light did not work, remove NA rows for Depth
df_all <- df_all[!is.na(df_all$Depth), ]
df_all <- df_all[!is.na(df_all$Temp), ]

# Necessary to correct depth offset
# It looks like of -0.4
df_all$Depth <- df_all$Depth + 0.4
# Make all negative values to 0
df_all$Depth <- ifelse(df_all$Depth < 0.25, 0, df_all$Depth) # I set 0.25 instead of 0 (surface) to avoid swimming surface values

# Make the plot again: 
ggplot(data = df_all, aes (x = Date_Time, y=Depth)) +
  geom_point(size = 0.2) +  scale_y_reverse() + theme_bw()




# 2024-08-06
########################################################################
# Parameters of the 1st site (we considered the transects of 2024-08-05)
# Sharp Island 2 2024-08-06 10:28:00 until 11:21:00

# Only 4-5 m and 2-3 m (No transect at 1-2 m )

# SI2_4_5_m between 2024-08-06 10:28:00 and 2024-08-06 10:48:00 

# SI2_2_3_m between 2024-08-06 11:04:00 and 2024-08-06 11:21:00


# Give some margin
SI_2 <- df_all %>% filter(Date_Time > ymd_hms("2024-08-06 10:28:00") & Date_Time < ymd_hms("2024-08-06 11:21:00")) 

# Plot
ggplot(data = SI_2, aes (x = Date_Time, y=Depth)) +
  geom_point(size = 0.2) +  scale_y_reverse() + theme_bw()

# scatter plot of Depth vs Temp
SI_2 %>%
  filter(Depth > 0) %>% # Filtering surface data!
  ggplot(aes (x=Depth, y = Temp)) +
  geom_point(size = 0.2)  +  
  stat_poly_line() +
  stat_poly_eq(use_label(c("eq", "R2")), label.y = 33, label.x = 3) +
  xlab("Depth (m)") + ylab("Temperatures (ºC)")+
  theme_bw()
# Necessary to correct the origin, it should not be 34...


# Secondary axis plot 

# Introduce Name " " and dataset name
gonzalo_sec_axis_plot("SI",SI_2)


# Bluff Island, for the 1-2m transect
# Parameters of the 2nd site 
# Bluff Island 2 
# BI2_1_2_m between 2024-08-06 13:01:30 and 2024-08-06 13:31:00

# BI for the second day 2024-08-06, just depths 1-2 m 
# Give some margin 
BI_2 <- df_all %>% filter(Date_Time > ymd_hms("2024-08-06 13:01:30") & Date_Time < ymd_hms("2024-08-06 13:39:00")) # Adjusted a bit!

# Plot
ggplot(data = BI_2, aes (x = Date_Time, y=Depth)) +
  geom_point(size = 0.2) +  scale_y_reverse() + theme_bw()

# scatter plot of Depth vs Temp
# Unnecessary because only one depth


# Secondary axis plot (better without ggplot), I created the following function
gonzalo_sec_axis_plot <- function(Name, dataset){
  
  # Set names:
  Name = Name  
  df = dataset
  
  par(mfrow=c(1,1))
  ## Plot first set of data and draw its axis
  plot(df$Date_Time, df$Depth, pch=20, cex = 0.5, axes=FALSE, ylim=c(max(df$Depth),min(df$Depth)), xlab="", ylab="", 
       type="b",col="black", main=paste ("Measures over diving time in",Name, sep = " "))
  axis(2, ylim=c(max(df$Depth),min(df$Depth)),col="black",las=1)  ## las=1 makes horizontal labels
  mtext("Depth (m)",side=2,line=2.5)
  box()
  ## Allow a second plot on the same graph
  par(new=TRUE)
  ## Plot the second plot and put axis scale on right
  plot(df$Date_Time, df$Temp, pch=20, cex = 0.5, xlab="", ylab="", ylim=c(min(df$Temp),max(df$Temp)), 
       axes=FALSE, type="b", col="red")
  ## Add the right y-axis
  axis(4, ylim=c(min(df$Temp),max(df$Temp)), las=1)
  ## a little farther out (line=4) to make room for labels
  mtext("Temperature (ºC)",side=4,line=2.5) 
  ## Draw the time axis
  r <- as.POSIXct(round(range(df$Date_Time), "mins"))
  axis.POSIXct(1, at = seq(r[1], r[2], by = "mins"), format = "%H:%M")
  mtext("Time",side=1,col="black",line=2.5)  
  ## Add Legend
  legend("topleft",legend=c("Depth","Temperature"),
         text.col=c("black","red"),pch=c(20,20),col=c("black","red"))
  
  
  return (plot)
}
# this is already a good result to add!

# Introduce Name " " and dataset name

# For example
gonzalo_sec_axis_plot("BI",BI_2)

# 1-2 m: According to Go Pro Videos and adjustments:
BI_1_2m <- BI_2 %>% filter(Date_Time > ymd_hms("2024-08-06 13:01:45") & Date_Time < ymd_hms("2024-08-06 13:38:00")) 

ggplot(data = BI_1_2m, aes ( x = Date_Time, y=Depth)) +
  geom_point(size = 0.2) +  scale_y_reverse() + theme_bw()
# It looks good enough!

# Filter measures outside this depth range
BI_1_2m <- BI_1_2m %>% filter(Depth > 0.5 & Depth < 1.75) 

# Exact average depth of transect: 
Depth_BI_1_2m <- mean (BI_1_2m$Depth)
Depth_sd_BI_1_2m <- sd (BI_1_2m$Depth)


ggplot(data = BI_1_2m, aes (x = Date_Time, y = Depth)) +
  geom_point(size = 0.2) +  scale_y_reverse() + theme_bw()

ggplot(data = BI_1_2m, aes (y=Temp, x = Date_Time)) +
  geom_point(size = 0.2) +  theme_bw()

# Exact average temp of transect: 
Temp_BI_1_2m <- mean (BI_1_2m$Temp)
Temp_sd_BI_1_2m <- sd (BI_1_2m$Temp)


# Use gonzalo_sec_axis_plot function
gonzalo_sec_axis_plot("BI_1_2m",BI_1_2m)

# The other depths were done the day before...

# Manually added the averages to csv "DEFI_Average_Transects_202408.csv"
# To keep in mind: if I extract temperatures from 2024-08-05 for 1_2m, I get: 
# Temp = 30.41804; Depth = 1.036302
# We carry on with the temperatures the day of the transect! 


# Combine all dataframes for all sites to make a correlation plot

BI$Site <- "Bluff Island"
BI_2$Site <- "Bluff Island"

SI$Site <- "Sharp Island"
SI_2$Site <- "Sharp Island"

TPC$Site <- "Tung Ping Chau"

# merge dataframes: 

all_sites_data <- rbind (BI,BI_2,SI,SI_2,TPC)

all_sites_data <- all_sites_data %>% filter(Depth > 0) # Filtering surface data!
  
# scatter plot of Depth vs Temp
fig_4_f <- ggplot(data = all_sites_data, aes (x=Depth, y = Temp)) +
  stat_poly_line() +
  stat_poly_eq(use_label(c("eq", "R2")), label.y = 33, label.x = 3) +
  geom_point(aes (x=Depth, y = Temp, colour = Site),size = 0.1, alpha = 0.3)  +  
  scale_color_manual(values = c("Green", "Orange", "Red")) +
  xlab("Depth (m)") + ylab("Temperatures (ºC)")+ 
  theme_bw() + theme(legend.position = "none")
fig_4_f
ggsave("~/Documents/AAASea_Science/AAA_Post_Doc_Alex_Wyatt/Hong_Kong_2024_Bleaching/Figure_Outputs/fig_4_f.pdf", fig_4_f, width = 3, height = 3)
ggsave("~/Documents/AAASea_Science/AAA_Post_Doc_Alex_Wyatt/Hong_Kong_2024_Bleaching/Figure_Outputs/fig_4_f.png", fig_4_f, width = 3, height = 3)


# Pearson correlation: 
cor.test (all_sites_data$Depth, all_sites_data$Temp)


# Parson correlations per Site
BIsland <- all_sites_data %>% filter(Site == "Bluff Island")
cor.test (BIsland$Depth, BIsland$Temp)

SIsland <- all_sites_data %>% filter(Site == "Sharp Island")
cor.test (SIsland$Depth, SIsland$Temp)

TPCIsland <- all_sites_data %>% filter(Site == "Tung Ping Chau")
cor.test (TPCIsland$Depth, TPCIsland$Temp)

##### THE END 


####################################### 





# Some extra unnecessary graphs!

# Secondary axis plot: 

# Calculate the range of Depth and Temp
depth_range <- max(BI$Depth) - min(BI$Depth)
temp_range <- max(BI$Temp) - min(BI$Temp)

# Calculate the scale factor
scale_factor <- depth_range / temp_range
print(scale_factor)


ggplot(BI, aes(x = Date_Time)) +
  geom_line(aes(y = Depth, color = "Depth")) +
  geom_line(aes(y = Temp, color = "Temp")) +
  # Invert the y-axis for Depth
  scale_y_reverse(name = "Depth (m)", sec.axis = sec_axis(~ . / scale_factor, name = "Temp (°C)")) +
  # Customize colors
  scale_color_manual(values = c("blue", "red")) +
  # Labels and title
  labs(x = "Date_Time", y = "Depth (m)", title = "Depth and Temperature Over Time", color = "Legend") +
  # Theme adjustments
  theme_bw() 




ggplot(BI, aes(x = Date_Time)) +
  geom_point(aes(y = -Depth), color = "blue", size = 0.2) +  # Primary y-axis
  geom_point(aes(y = -(Temp - 24) * (6 / 8)), color = "red", size = 0.2) +  # Secondary y-axis
  scale_y_continuous(name = "Depth (Blue)", sec.axis = sec_axis( ~ . * (8 / 6) + 24, name = "Temperature (red)")) +  # Secondary axis transformation
  theme_bw() 

ymax <- 0
scaleRight <- max(BI$Temp)/ymax


ggplot(BI, aes(x = Date_Time)) +
  geom_point(aes(y = -Depth), color = "blue", size = 0.2) +  # Primary y-axis
  geom_point(aes(y = -(Temp - 24) * (6 / 8)), color = "red", size = 0.2) +  # Secondary y-axis
  scale_y_continuous(name = "Depth (Blue)", sec.axis = sec_axis( (-1) ~ . * (8 / 6) + 24, name = "Temperature (red)")) +  # Secondary axis transformation
  theme_bw() 


ggplot(BI, aes(x = Date_Time)) +
  geom_point(aes(y = Depth), color = "blue", size = 0.2) +
  geom_point(aes(y = (Temp - 24) * (6 / 8)), color = "red", size = 0.2) +
  scale_y_continuous(
    name = "Depth (blue)",
    sec.axis = sec_axis(
      ~ (. - 2.768) * (5.960 - 1.460) / (32.04 - 24.27) + 1.460,
      name = "Temperature (red)"
    )
  ) +
  theme_bw() 



ggplot(BI, aes(x = Date_Time)) +
  geom_point(aes(y = Depth), color = "blue", size = 0.2) +  # Primary y-axis
  geom_point(aes(y = (Temp - 24) * (6 / 8)), color = "red", size = 0.2) +  # Secondary y-axis
  scale_y_reverse(name = "Depth (blue)",
                     sec.axis = sec_axis(~ . * (8 / 6) + 24, name = "Temperature (red)")) +  # Secondary axis transformation
  scale_y_reverse() + theme_bw()

























