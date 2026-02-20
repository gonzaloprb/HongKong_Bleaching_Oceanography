
# AAA: Read me (IMPORTANT!)
# One of the main problems is that when I filter to the depths with such a little 
# depth difference 4-5, 2-3 and 1-2 a lot of the TRANSECTS get outside the depth range!!!!


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
setwd("~/Documents/AAASea_Science/AAA_Post_Doc_Alex_Wyatt/Hong_Kong_2024_Bleaching/Environmental_Data/DEFI_loggers")


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
TPC <- df_all %>% filter(Date_Time > ymd_hms("2024-08-09 11:00:00") & Date_Time < ymd_hms("2024-08-09 13:30:00")) 

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


# Secondary axis plot (better without ggplot), I created the following function
gonzalo_sec_axis_plot <- function(Name, dataset){
  
  # Set names:
  Name = Name  
  df = dataset
  
  par(mar = c(5, 4, 4, 5)) 
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

# Introduce Name " " and dataset name

# For example
gonzalo_sec_axis_plot("TPC",TPC)

# 4-5 m: According to Go Pro Videos between 2024-08-09 11:02:00 and 2024-08-09 11:38:00
TPC_4_5m <- TPC %>% filter(Date_Time > ymd_hms("2024-08-09 11:02:00") & Date_Time < ymd_hms("2024-08-09 11:38:00")) 

ggplot(data = TPC_4_5m, aes ( x = Date_Time, y=Depth)) +
  geom_point(size = 0.2) +  scale_y_reverse() + theme_bw()
# It looks good enough!

# Filter measures outside this depth range
TPC_4_5m <- TPC_4_5m %>% filter(Depth > 4 & Depth < 5) 

ggplot(data = TPC_4_5m, aes (x = Date_Time, y = Depth)) +
  geom_point(size = 0.2) +  scale_y_reverse() + theme_bw()

ggplot(data = TPC_4_5m, aes (y=Temp, x = Date_Time)) +
  geom_point(size = 0.2) +  theme_bw()

# Use gonzalo_sec_axis_plot function
gonzalo_sec_axis_plot("TPC_4_5m",TPC_4_5m)


# 2-3 m: According to Go Pro Videos between 2024-08-09 12:06:00 and 2024-08-09 12:31:00
TPC_2_3m <- TPC %>% filter(Date_Time > ymd_hms("2024-08-09 12:06:00") & Date_Time < ymd_hms("2024-08-09 12:31:00")) 

ggplot(data = TPC_2_3m, aes (y=Depth, x = Date_Time)) +
  geom_point(size = 0.2)  + scale_y_reverse() + theme_bw()

TPC_2_3m <- TPC_2_3m %>% filter(Depth > 2 & Depth < 3) 

# A lot of data gets lost
ggplot(data = TPC_2_3m, aes (y=Depth, x = Date_Time)) +
  geom_point(size = 0.2) +  scale_y_reverse() + theme_bw()

ggplot(data = TPC_2_3m, aes (y=Temp, x = Date_Time)) +
  geom_point(size = 0.2) +   theme_bw()

# Use gonzalo_sec_axis_plot function
gonzalo_sec_axis_plot("TPC_2_3m",TPC_2_3m)



# 1-2 m: According to Go Pro Videos between 2024-08-09 12:59:00 and 2024-08-09 13:12:00
TPC_1_2m <- TPC %>% filter(Date_Time > ymd_hms("2024-08-09 12:59:00") & Date_Time < ymd_hms("2024-08-09 13:12:00")) 

ggplot(data = TPC_1_2m, aes (y=Depth, x = Date_Time)) +
  geom_point(size = 0.2)  + scale_y_reverse() + theme_bw()

TPC_1_2m <- TPC_1_2m %>% filter(Depth > 1 & Depth < 2) 

ggplot(data = TPC_1_2m, aes (y=Depth, x = Date_Time)) +
  geom_point(size = 0.2) +  scale_y_reverse() + theme_bw()

ggplot(data = TPC_1_2m, aes (y=Temp, x = Date_Time)) +
  geom_point(size = 0.2) + theme_bw()

# Use gonzalo_sec_axis_plot function
gonzalo_sec_axis_plot("TPC_1_2m",TPC_1_2m)

# It is necessary to save dataframes:


########################################################################
# Parameters of the 2nd site 
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




rm (list = ls ())

# Open CSV files for 2024-08-05
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
########################################################################
# Parameters of the 1st site 
# Long Ke Wan between 2024-08-05 10:35 until 12:17

# First 2 and 3 m

# LKW_2_3_m between 2024-08-05 10:40:00 and 2024-08-05 11:12:00

# LKW_4_5_m between 2024-08-05 11:31:00 and 2024-08-05 12:17:00

# No transect at 1-2 m 



# Bluff Island between 2024-08-05 13:57 until 15:15
# First day no transect at 1-2 m
# BI_4_5_m between 2024-08-05 13:57:00 and 2024-08-05 14:27:00

# BI_2_3_m between 2024-08-05 14:58:00 and 2024-08-05 15:15:00


# Sharp Island between  2024-08-05 16:00:00 until 2024-08-05 17:30:00

# SI_4_5_m between 2024-08-05 16:19:00 and 2024-08-05 16:33:00

# SI_2_3_m between 2024-08-05 16:46:00 and 2024-08-05 17:04:00

# SI_1_2_m between 2024-08-05 17:12:00 and 2024-08-05 17:29:00


rm (list = ls ())

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
# Parameters of the 1st site 
# Sharp Island 2 2024-08-06 10:28:00 until 11:21:00

# Only 4-5 m and 2-3 m (No transect at 1-2 m )

# SI2_4_5_m between 2024-08-06 10:28:00 and 2024-08-06 10:48:00 

# SI2_2_3_m between 2024-08-06 11:04:00 and 2024-08-06 11:21:00



# Give some margin
SI <- df_all %>% filter(Date_Time > ymd_hms("2024-08-06 10:28:00 ") & Date_Time < ymd_hms("2024-08-06 11:21:00")) 

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


# Secondary axis plot 

# Introduce Name " " and dataset name
gonzalo_sec_axis_plot("SI",SI)



# Parameters of the 2nd site 
# Bluff Island 2 2024-08-06 13:08:00 until 13:31:00

# BI2_1_2_m between 2024-08-06 13:08:00 and 2024-08-06 13:31:00








# Secondary axis plot: 

# Calculate the range of Depth and Temp
depth_range <- max(TPC$Depth) - min(TPC$Depth)
temp_range <- max(TPC$Temp) - min(TPC$Temp)

# Calculate the scale factor
scale_factor <- depth_range / temp_range
print(scale_factor)


ggplot(TPC, aes(x = Date_Time)) +
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




ggplot(TPC, aes(x = Date_Time)) +
  geom_point(aes(y = -Depth), color = "blue", size = 0.2) +  # Primary y-axis
  geom_point(aes(y = -(Temp - 24) * (6 / 8)), color = "red", size = 0.2) +  # Secondary y-axis
  scale_y_continuous(name = "Depth (Blue)", sec.axis = sec_axis( ~ . * (8 / 6) + 24, name = "Temperature (red)")) +  # Secondary axis transformation
  theme_bw() 

ymax <- 0
scaleRight <- max(TPC$Temp)/ymax


ggplot(TPC, aes(x = Date_Time)) +
  geom_point(aes(y = -Depth), color = "blue", size = 0.2) +  # Primary y-axis
  geom_point(aes(y = -(Temp - 24) * (6 / 8)), color = "red", size = 0.2) +  # Secondary y-axis
  scale_y_continuous(name = "Depth (Blue)", sec.axis = sec_axis( (-1) ~ . * (8 / 6) + 24, name = "Temperature (red)")) +  # Secondary axis transformation
  theme_bw() 


ggplot(TPC, aes(x = Date_Time)) +
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



ggplot(TPC, aes(x = Date_Time)) +
  geom_point(aes(y = Depth), color = "blue") +  # Primary y-axis
  geom_point(aes(y = (Temp - 24) * (6 / 8)), color = "red") +  # Secondary y-axis
  scale_y_reverse(name = "Depth (blue)",
                     sec.axis = sec_axis(~ . * (8 / 6) + 24, name = "Temperature (red)")) +  # Secondary axis transformation
  scale_y_reverse() + theme_bw()




# For loop
depths <- c(-4.5, -3.5, -1.5)
PAR_final_six <- data.frame ()
for (k in unique (depths)) {
  p <-  normalize_PAR_six [which(abs(normalize_PAR_six$Pressure_DBar - k) == min(abs(normalize_PAR_six$Pressure_DBar - k))), "PAR"]
  q <- cbind (k, p)
  PAR_final_six <- rbind (q, PAR_final_six)
}
colnames (PAR_final_six) <- c("Depth", "PAR_rel_six")

# KLW first dive at 2024-08-09 14:45:00 and last dive 2024-08-09 16:57:00




















