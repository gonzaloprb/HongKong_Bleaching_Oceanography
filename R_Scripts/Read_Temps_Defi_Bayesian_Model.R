
#### Read Me ####
# Bayesian modelling according to the mounted DEFI loggers
# It generates the Bayesian statistical results and generates Fig 5 and Fig 6
# The best models are Bayes0_Depth and Bayes1_Temp; and these are analysed separately

#### Read Me ####

rm (list = ls()) 

require(tidyverse); require (plyr); require (reshape); require (ggplot2); require (ggrepel); require (dplyr); require(RColorBrewer); 

# Open the average Temperatures and depths according to the DEFI loggers

DEFI_Depths_Temps <- read.csv(file = "Data/Environment/DEFI_loggers/082024/DEFI_Average_Transects_202408.csv", header = T, dec = ".", sep = ",")

# Keep the exact depths, you will transform the ones of the transects

# This is only 2024 data. I am opening both data but I will filter it out later!

# Open Jeffery data from 2022 bleaching
# Open Gonzalo data from 2024 bleaching

require(tidyverse); require (plyr); require (reshape); require (ggplot2); require (ggrepel); require (dplyr); require(RColorBrewer); 

# Open the data
data_bm_2022 <- read.csv(file = "Data/Bleaching/data_bm_2022.csv", header = T, dec = ".", sep = ",")

data_bm_2024 <- read.csv(file = "Data/Bleaching/data_bm_2024.csv", header = T, dec = ".", sep = ",")
 
# For 2022, Surveys conducted on August 1, 2 and 4 (Chung et al 2024 Coral Reefs)
# For 2024, Surveys conducted on August 2024

# For 2022, Depth 2 is 2-4 m and Depth 3 is 4-6 m
# For 2024, Depth 1 is 1 m, Depth 2 is 2-3 m and Depth 4 is 4-5 m

# Assumption of depths: Depth 1 = 1 m; Depth 2 ~ 3 m, Depth 3 ~ 5 m.

# Data is binary. Either Pigmented or bleached 



#### Combine the dataframes: 
# Check dataframes: 
names (data_bm_2024)
names (data_bm_2022)
# Remove transect column
data_bm_2024 <- data_bm_2024[,-3]

# Need to solve the species/genus names: 
unique (data_bm_2022$Species)
unique (data_bm_2024$Species)

# In the data_bm_2022
data_bm_2022$Species <- str_replace_all(data_bm_2022$Species, 'Acropora', 'Acropora sp.')

data_bm_2022$Species <- str_replace_all(data_bm_2022$Species, 'Dipsastraea', 'Dipsastraea rotumana / speciosa')
# Also in the data_bm_2024
data_bm_2022$Species <- str_replace_all(data_bm_2022$Species, 'Favites', 'Favites / Goniastrea sp.')
data_bm_2024$Species <- str_replace_all(data_bm_2024$Species, 'Favites chinensis  / Gonia aspera', 'Favites / Goniastrea sp.') # Loss a bit of 2024 taxonomy!
data_bm_2024$Species <- str_replace_all(data_bm_2024$Species, 'Favites pentagona', 'Favites / Goniastrea sp.')
data_bm_2024$Species <- str_replace_all(data_bm_2024$Species, 'Favites abdita or sp.', 'Favites / Goniastrea sp.')

data_bm_2022$Species <- str_replace_all(data_bm_2022$Species, 'Galaxea', 'Galaxea fascicularis / astreata')

data_bm_2022$Species <- str_replace_all(data_bm_2022$Species, 'Goniopora', 'Goniopora columna or sp.')

data_bm_2022$Species <- str_replace_all(data_bm_2022$Species, 'Hydnophora', 'Hydnophora exesa')

# Lithophyllon is missing in 2024

data_bm_2022$Species <- str_replace_all(data_bm_2022$Species, 'Montipora', 'Montipora peltiformis')

data_bm_2022$Species <- str_replace_all(data_bm_2022$Species, 'Pavona', 'Pavona decussata') # Check if need to add sp.

data_bm_2022$Species <- str_replace_all(data_bm_2022$Species, 'Platygyra', 'Platygyra carnosus / acuta') # Check if need to add sp.

data_bm_2022$Species <- str_replace_all(data_bm_2022$Species, 'Porites', 'Porites lutea / sp.') 

data_bm_2024$Species <- str_replace_all(data_bm_2024$Species, 'Porites lutea', 'Porites lutea / sp.') # Loss a bit of 2024 taxonomy

data_bm_2024$Species <- str_replace_all(data_bm_2024$Species, 'Porites aranetai / deformis', 'Porites lutea / sp.') 

# Duncanopsammia not present in 2024

data_bm_2022$Species <- str_replace_all(data_bm_2022$Species, 'Leptastrea', 'Leptastrea purpurea / pruinosa / sp.')

# Stylocoeniella not present in 2024

# Combine dataframes
data_bm_bleachings <- rbind (data_bm_2022,data_bm_2024)

# Upon reviewer request, necessary to transform these into genus level. 
data_bm_bleachings$Species <- str_replace_all(data_bm_bleachings$Species, 'Acropora sp.', 'Acropora') 
data_bm_bleachings$Species <- str_replace_all(data_bm_bleachings$Species, 'Dipsastraea rotumana / speciosa', 'Dipsastraea') 
data_bm_bleachings$Species <- str_replace_all(data_bm_bleachings$Species, 'Favites / Goniastrea sp.', 'Favites / Goniastrea') 
data_bm_bleachings$Species <- str_replace_all(data_bm_bleachings$Species, 'Goniopora columna or sp.', 'Goniopora') 
data_bm_bleachings$Species <- str_replace_all(data_bm_bleachings$Species, 'Montipora peltiformis', 'Montipora') 
data_bm_bleachings$Species <- str_replace_all(data_bm_bleachings$Species, 'Pavona decussata', 'Pavona') 
data_bm_bleachings$Species <- str_replace_all(data_bm_bleachings$Species, 'Platygyra carnosus / acuta', 'Platygyra') 
data_bm_bleachings$Species <- str_replace_all(data_bm_bleachings$Species, 'Porites lutea / sp.', 'Porites') 
data_bm_bleachings$Species <- str_replace_all(data_bm_bleachings$Species, 'Leptastrea purpurea / pruinosa / sp.', 'Leptastrea') 
data_bm_bleachings$Species <- str_replace_all(data_bm_bleachings$Species, 'Psammocora superficialis', 'Psammocora') 
data_bm_bleachings$Species <- str_replace_all(data_bm_bleachings$Species, 'Cyphastrea serailia / japonica', 'Cyphastrea') 
data_bm_bleachings$Species <- str_replace_all(data_bm_bleachings$Species, 'Turbinaria peltata', 'Turbinaria') 


# For simplicity drop the species with less than X occurrences or only happening in 2022 or 2024

Depth_range <- ddply(data_bm_bleachings,~ Depth + Species ,function(x){c(Nb_observ_depth=nrow(x))})
Occurrences <- ddply(data_bm_bleachings,~  Species ,function(x){c(Nb_observ=nrow(x))})
# View(Occurrences)
# Less than 5 Observations total, the species are dropped
Keep_species <- Occurrences %>% filter(Nb_observ > 5) %>% pull(Species)
# It also eliminates the majority of the ones just present in one event which are not dominant in HK waters


# Make the filter:
data_bm_bleachings <- data_bm_bleachings %>% filter(Species %in% Keep_species)
unique (data_bm_bleachings$Species)
# We carry on with 12 species/genus

# Clean the working environment
rm (data_bm_2022, data_bm_2024, Depth_range, Occurrences, Keep_species)

# Check structure of data_bm_bleachings (2022 and 2024):
str (data_bm_bleachings)
summary (data_bm_bleachings)


# Before making the Bayesian, filter out the 2022 data
data_bm_bleaching_temp <- subset (data_bm_bleachings, Year == 2024)

# Make it individually, otherwise not working with condition...
TPC <- subset (data_bm_bleaching_temp, Site == "Tung Ping Chau")
TPC <- TPC %>%
  mutate(Depth = case_when(
    Depth == 1 ~ 1.34224,
    Depth == 2 ~ 3.215451,
    Depth == 3 ~ 4.902442,
    TRUE ~ Depth  # Default case: keep the original value
  ))

SI <- subset (data_bm_bleaching_temp, Site == "Sharp Island")
SI <- SI %>%
  mutate(Depth = case_when(
    Depth == 1 ~ 1.404849,
    Depth == 2 ~ 2.709447,
    Depth == 3 ~ 5.062189,
    TRUE ~ Depth  # Default case: keep the original value
  ))

BI <- subset (data_bm_bleaching_temp, Site == "Bluff Island")
BI <- BI %>%
  mutate(Depth = case_when(
    Depth == 1 ~ 1.382806,
    Depth == 2 ~ 2.299278,
    Depth == 3 ~ 5.168503,
    TRUE ~ Depth  # Default case: keep the original value
  ))

# Recombine dataframes:
data_bm_bleaching_temp <- rbind (TPC, SI, BI)
# Check depths:
unique (sort(data_bm_bleaching_temp$Depth))
unique (sort(DEFI_Depths_Temps$Depth))

# Add the 2024 temperature data for each Site and Depth
data_bm_bleaching_temp <- merge (data_bm_bleaching_temp, DEFI_Depths_Temps)

rm (data_bm_bleachings, BI, SI, TPC, DEFI_Depths_Temps)


### Run the Bayesian model according to: 
# temperature
# temperature and depth
# depth

library (brms); library(parallel);  library (tidybayes) ;  library (posterior); library (cmdstanr); library (rstan)

# Straight to the Formula of selected model "fit_bayes_5" for 2024 and "fit_bayes_2022" for 2022
# but adding temperature

# Previous Depth model; First without adding Temperature because Temperature and Depth are highly correlated. This model is more accurate regarding Depth because it uses DEFI depths
Bayes0_Depth <- brms::brm(Status ~ 1 + Depth + Site + (1 + Depth | Species), data = data_bm_bleaching_temp, family = bernoulli(link = "logit"),control = list(max_treedepth = 19, adapt_delta = 0.99), chains = 2, cores = 2, iter = 9000, warmup = 3000, backend = "cmdstanr", threads = 1)
summary (Bayes0_Depth)
# Interp:
# You can decrease adapt Delta and Tree Depth which is a good sign and it already converges
# Kept the same parameters as for the other models
# Increasing Depth decreases bleaching status! 
# Converges super fast, which is a good sign
save(Bayes0_Depth, file="Data/Bayesian_Outputs/Bayes0_Depth.RData")
load("Data/Bayesian_Outputs/Bayes0_Depth.RData")


# 1st just temperatures:
Bayes1_Temp <- brms::brm(Status ~ 1 + Temperature + Site + (1 + Temperature | Species), data = data_bm_bleaching_temp, family = bernoulli(link = "logit"),control = list(max_treedepth = 19, adapt_delta = 0.99), chains = 2, cores = 2, iter = 9000, warmup = 3000, backend = "cmdstanr", threads = 1)
summary (Bayes1_Temp)
# Interp:
# Converged with no divergences
save(Bayes1_Temp, file="Data/Bayesian_Outputs/Bayes1_Temp.RData")
load("Data/Bayesian_Outputs/Bayes1_Temp.RData")

# 2nd model, temperatures and depth together!
Bayes2_Temp_Depth <- brms::brm(Status ~ 1 + Temperature + Site + Depth + (1 + Temperature | Species), data = data_bm_bleaching_temp, family = bernoulli(link = "logit"),control = list(max_treedepth = 19, adapt_delta = 0.99), chains = 2, cores = 2, iter = 9000, warmup = 3000, backend = "cmdstanr", threads = 1)
summary (Bayes2_Temp_Depth)
# Interp:
# Converged but with divergences...
# According to the slope and the Interval confidences, nothing Temperature or Depth are significant
# Increasing temp increases likelihood of bleaching but nos significant CI
# Increasing Depth increases likelihood of bleaching... not significant but this is wrong!! Be careful!
# Likely because they are highly correlated. 
# I don't like that model... Keep in mind!
save(Bayes2_Temp_Depth, file="Data/Bayesian_Outputs/Bayes2_Temp_Depth.RData")
load("Data/Bayesian_Outputs/Bayes2_Temp_Depth.RData")


# 3rd model, trying to keep temperatures and depth together!
# They are highly correlated so we need to account for multicollinearity
Bayes3_Temp_Depth <- brms::brm(Status ~ 1 + Temperature * Depth + Site + (1 + Temperature | Species), data = data_bm_bleaching_temp, family = bernoulli(link = "logit"),control = list(max_treedepth = 19, adapt_delta = 0.99), chains = 2, cores = 2, iter = 9000, warmup = 3000, backend = "cmdstanr", threads = 1)
summary (Bayes3_Temp_Depth)
# Applying an interaction with a hierarchical structure that considers the correlation between Depth and Temp
# It allows the model to capture how the effect of Temperature on Status might depend on Depth (and vice versa), which is useful when the two predictors are correlated.
# Interp:
# It converged without divergent iterations but with longer running time
# It takes a lot of time, which is not necessarily a good thing. 
# The interaction of temperature and Depth are not significant either
# Temp is not significant
# Depth is not significant
# The differences between sites are not significant either
save(Bayes3_Temp_Depth, file="Data/Bayesian_Outputs/Bayes3_Temp_Depth.RData")
load("Data/Bayesian_Outputs/Bayes3_Temp_Depth.RData")


# 4th model, very similar to 3 but the other way around 
Bayes4_Depth_Temp <- brms::brm(Status ~ 1 + Depth * Temperature + Site + (1 + Depth | Species), data = data_bm_bleaching_temp, family = bernoulli(link = "logit"),control = list(max_treedepth = 19, adapt_delta = 0.99), chains = 2, cores = 2, iter = 9000, warmup = 3000, backend = "cmdstanr", threads = 1)
summary (Bayes4_Depth_Temp)
# 
# Interp:
# Same problems as above! 
# Don't like that model
save(Bayes4_Depth_Temp, file="Data/Bayesian_Outputs/Bayes4_Depth_Temp.RData")
load("Data/Bayesian_Outputs/Bayes4_Depth_Temp.RData")


# the best models are: Bayes0_Depth and Bayes1_Temp



# Compare the models: 
library(loo)
# Extract Loo for each model and compare: 
looDepth <- loo(Bayes0_Depth)
looTemp <- loo(Bayes1_Temp)
looDepthTemp2 <- loo(Bayes2_Temp_Depth)
looDepthTemp3 <- loo(Bayes3_Temp_Depth)
looDepthTemp4 <- loo(Bayes4_Depth_Temp)

loo_compare(looDepth,looTemp, looDepthTemp2, looDepthTemp3, looDepthTemp4) # 
# The best model according to temperature only "Bayes1_Temp" (no depth model) is the best!

# Compared the models with waic (Watanabe-Akaike Information Criterion) or loo (Leave-One-Out Cross-Validation) give the same results

# Extract loo_R2, these values are quite low, poor predictive power. Mention in discussion!
loo_R2(Bayes0_Depth)
loo_R2(Bayes1_Temp)
loo_R2(Bayes2_Temp_Depth)
loo_R2(Bayes3_Temp_Depth)
loo_R2(Bayes4_Depth_Temp)

# Such low values mean a weak predictive power but not necessarily useless.
bayes_R2(Bayes0_Depth)
bayes_R2(Bayes1_Temp) 
bayes_R2(Bayes2_Temp_Depth)
bayes_R2(Bayes3_Temp_Depth)
bayes_R2(Bayes4_Depth_Temp)



# We cannot compare with just depths like "fit_bayes_5" because different number of data points. 

# Final decision is to provide the results with Temp alone and with Depth alone!
# The models are: Bayes1_Temp and Bayes0_Temp

# Carry on with the best fitted model: Bayes1_Temp

# Analyse the model
# Check convergence 
summary(Bayes1_Temp)
coef (Bayes1_Temp) # 

# check the plots (Could go as supplementary figure)
plot (Bayes1_Temp)
pp_check(Bayes1_Temp) # The predicted and observed values converged all right

# Conditional effects: 
conditional_effects(Bayes1_Temp)
# Increase of temp. increases the likelihood of bleaching
# No assumptions of depths, it is real values of Temperatures that change with depths

# Make a nicer plot
ce <- conditional_effects(Bayes1_Temp,categorical = F, probs = c(0.1, 0.9), method = c("fitted")) # 0.025, 0.975 = 95 % interval
# wider intervals (e.g., c(0.1, 0.9)) to capture more uncertainty
# narrower intervals (e.g., c(0.33, 0.66)) to focus on the central tendency

# (0.025, 0.975) corresponds to a 95% credible, very high
# In our case probs = c(0.1, 0.9) it is a 80%

# plot conditional effects for depth
min(ce$Temperature$Temperature)
max(ce$Temperature$Temperature)

fig_5_a <- plot(ce, plot = FALSE)[[1]] + 
  scale_x_continuous(name ="Temperature (ºC)", breaks = seq(24.4, 31.6, by = 0.6)) +
  labs(x = "Temperature (ºC)",  y = "Bleaching probability",  title = "0 = Pigmented, 1 = Bleached") + theme_classic()
fig_5_a
ggsave("Data/Figure_Outputs/fig_5_a.pdf", fig_5_a, width = 5, height = 4)


# plot conditional effects for Site as discrete variable
fig_5_e <- plot(ce, plot = FALSE)[[2]] + 
  labs(x = "Site",  y = "Bleaching probability") + theme_classic() 
fig_5_e
ggsave("Data/Figure_Outputs/fig_4_e.pdf", fig_5_e, width = 5, height = 3.5)

# Again TPC a bit more bleaching, probably because the site has more corals 
# If you use narrower intervals, these differentiate!

# We cannot plot for years, because 2022 data is not included

# Prepare fully crossed conditions of the conditional effects
# Working with Site
conditions_site <- make_conditions(Bayes1_Temp, vars = c( "Site"))
ce_Site <- conditional_effects(Bayes1_Temp,  conditions = conditions_site, categorical = F, probs = c(0.33, 0.66), method = c("fitted"), re_formula = NULL) # probs = (0.025, 0.975) # You can decrease them to 0.2
# Wider intervals capture more uncertainty, narrower intervals focus more on the central tendency. Ignoring uncertainty!
# Make the plot
plot (ce_Site) # The second plot is interesting!

# Make the plot for Site in the same graph
ce_Site <- ce_Site$Temperature
ggplot(ce_Site, aes(x = Temperature, y = estimate__, colour = Site, fill = Site)) +
  geom_line() +
  geom_ribbon(aes(ymin = lower__, ymax = upper__), alpha = 0.3) +
  scale_x_continuous(name ="Temperature (ºC)", breaks = seq(24.4, 31.6, by = 0.6)) +
  # scale_y_continuous(name = "Probability", limits = c(0.00, 1.00), breaks = c(0.00, 0.25, 0.50, 0.75, 1.00)) +
  labs(x = "Temperature (ºC)", y = "Bleaching probability", title = "0 = Pigmented; 1 = Bleaching") +
  scale_color_manual(values = c("Green", "Orange", "Red")) +
  scale_fill_manual(values = c("Green", "Orange", "Red")) +
  theme_classic() +
  theme(strip.background = element_blank(), legend.position = "bottom", legend.title = element_blank())


fig_5_c <- ggplot(ce_Site, aes(x = Temperature, y = estimate__, colour = Site, fill = Site)) +
  geom_line() +
  geom_ribbon(aes(ymin = lower__, ymax = upper__), alpha = 0.3) +
  facet_wrap(~Site)+
  scale_x_continuous(name ="Temperature (ºC)", breaks = seq(24.4, 31.6, by = 2)) +
  # scale_y_continuous(name = "Probability", limits = c(0.00, 1.00), breaks = c(0.00, 0.25, 0.50, 0.75, 1.00)) +
  labs(x = "Temperature (ºC)", y = "Bleaching probability") +
  scale_color_manual(values = c("Green", "Orange", "Red")) +
  scale_fill_manual(values = c("Green", "Orange", "Red")) +
  theme_classic() +
  theme(strip.background = element_blank(), legend.position = "none", legend.title = element_blank())
fig_5_c
ggsave("Data/Figure_Outputs/fig_5_c.pdf", fig_5_c, width = 5, height = 2)



# We cannot plot by Year because only considering 2024
# Otherwise, go to script: "Bayesianmodel_Bleaching_Events.R"




# Conditional effects per genera/species
conditions <- make_conditions(Bayes1_Temp, vars = c( "Species"))
ce_Species <- conditional_effects(Bayes1_Temp,  conditions = conditions, categorical = F, probs = c(0.33, 0.66), method = c("fitted"), re_formula = NULL) # This one has a narrower interval to focus on general tendency
plot (ce_Species)




# Make the plot for kept Species
ce_Species <- ce_Species$Temperature

# Reorder Species factor levels by the maximum estimate__ value
ce_Species <- ce_Species %>%
  mutate(Species = fct_reorder(Species, estimate__, .fun = max, .desc = TRUE))

# Predefine the colours from red to green showing susceptibility
colours_sp = c(brewer.pal(11, "RdYlGn"),"#001000")
# Make the plot:
# Used figure below
ggplot(ce_Species, aes(x = Temperature, y = estimate__, fill = Species)) +
  geom_line() +
  geom_ribbon(aes(ymin = lower__, ymax = upper__), alpha = 0.9) +
  facet_wrap(~Species, scales = "free", ncol = 6) +
  scale_fill_manual(values = colours_sp) +
  scale_x_continuous(name = "Temperatures (ºC)", breaks = seq(24.4, 31.6, by = 3)) +
  scale_y_continuous(name = "Bleaching probability", limits = c(0.00, 1.00), 
                     breaks = c(0.00, 0.25, 0.50, 0.75, 1.00)) +
  labs(x = "Temperatures (ºC)", y = "Bleaching probability") +
  theme_classic() +
  theme(strip.background = element_blank(), 
        legend.position = "none")


# Improve the plot
# Calculate maximum species name length and wrap if over 10
ce_Species <- ce_Species %>%
  mutate(Species_wrapped = stringr::str_wrap(Species, width = 10))

ce_Species <- ce_Species %>%
  mutate(Species_wrapped = fct_reorder(Species_wrapped, estimate__, .fun = max, .desc = TRUE))

ggplot(ce_Species, aes(x = Temperature, y = estimate__, fill = Species)) +
  geom_line() +
  geom_ribbon(aes(ymin = lower__, ymax = upper__), alpha = 0.9) +
  facet_wrap(~Species_wrapped, scales = "fixed", ncol = 6) +
  scale_fill_manual(values = colours_sp) +
  scale_x_continuous(name = "Temperatures (ºC)", breaks = seq(24.4, 31.6, by = 3)) +
  scale_y_continuous(name = "Bleaching probability", limits = c(0.00, 1.00), 
                     breaks = c(0.00, 0.25, 0.50, 0.75, 1.00)) +
  labs(x = "Temperatures (ºC)", y = "Bleaching probability") +
  theme_classic() +
  theme(strip.background = element_blank(), 
        legend.position = "none", strip.text = element_text(size = 6), axis.text = element_text(size = 7))




# Other kind of plot:

ggplot(ce_Species, aes(x = Temperature, y = estimate__,colour = Species,fill = Species)) +
  geom_line() +
  geom_ribbon(aes(ymin = lower__, ymax = upper__),alpha = 0.2) +
  scale_x_continuous(name ="Temperature (ºC)", breaks = seq(24.4, 31.6, by = 1)) +
  # scale_y_continuous(name = "Probability", limits = c(0.00, 1.00), breaks = c(0.00, 0.25, 0.50, 0.75, 1.00)) +
  labs(x = "Temperature (ºC)", y = "Bleaching probability", title = "0 = Pigmented; 1 = Bleaching") +
  theme_classic() +
  theme(strip.background = element_blank(), legend.position = "left")


# Check the posterior distribution
# Create a crossing dataframe
Temperature <- unique (Bayes1_Temp$data$Temperature)
Species <- unique (Bayes1_Temp$data$Species)
Site <- unique (Bayes1_Temp$data$Site)
ref_data <- crossing(Site, Temperature, Species)

fitted_values <- posterior_epred(Bayes1_Temp, newdata = ref_data, re_formula = 'Status ~ 1 + Temperature + Site + (1 + Temperature | Species)')

str (fitted_values)
dim (fitted_values)

# Take all conditions: 
Posterior <- as.data.frame (fitted_values [c(1:12000),]) # Taking all conditions because it is binary 
# 1 is bleaching
# 0 is pigmented

# Necessary to transpose
Posterior <- t(Posterior)
ref_data_fitted <- cbind (ref_data,Posterior)
# View(ref_data_fitted)

ref_data_fitted <- melt (ref_data_fitted, id.vars = c ("Site", "Temperature", "Species"), na.rm = F, measure.vars = c(4:12003), value.name = c("Prob")) # Adjust measure.vars

# Make a plot: 
library (ggridges)
# Set the order you want:
ref_data_fitted$Species <- factor(ref_data_fitted$Species, levels = rev(sort(unique(ref_data_fitted$Species))))
# Make the ggplot
ggplot(ref_data_fitted, aes(x = Prob, y = Species)) + # fill = Species
  geom_density_ridges(scale = 1, rel_min_height = 0.2) +  
  facet_wrap(~Temperature) +  xlab ("Likelihood Status, 0 = Pigmented & 1 = Bleached") + ylab ("")+
  theme_bw() +  theme(legend.position="none")
# Each Temperature is specific of Site and Depth, so you can add the information if needed :) 

# Without displaying temp.
# Reorder Species factor levels by the maximum value
ref_data_fitted <- ref_data_fitted %>%
  mutate(Species = fct_reorder(Species, Prob, .fun = max, .desc = F))

# Used fig below
ggplot(ref_data_fitted, aes(x = Prob, y = Species, fill = Species)) + # fill = Species
  geom_density_ridges(scale = 1, rel_min_height = 0.1) +  
  scale_fill_manual(values = rev(colours_sp)) +
  xlab ("Bleaching probability") + ylab ("")+
  theme_bw() +  theme(legend.position="none")

# mean Values for MS
aggregate (Prob ~ Species, data = ref_data_fitted, mean)


# Make the figures with Depth
# Model Bayes0_Depth


summary(Bayes0_Depth)

plot (Bayes0_Depth)
pp_check(Bayes0_Depth) 

# Conditional effects: 
conditional_effects(Bayes0_Depth)

ce_depth <- conditional_effects(Bayes0_Depth,categorical = F, probs = c(0.1, 0.9), method = c("fitted")) # 0.025, 0.975 = 95 % interval
# wider intervals (e.g., c(0.1, 0.9)) to capture more uncertainty
# narrower intervals (e.g., c(0.33, 0.66)) to focus on the central tendency

# (0.025, 0.975) corresponds to a 95% credible, very high
# In our case probs = c(0.1, 0.9) it is a 80%

# plot conditional effects for depth
# Fig used below
fig_5_b <- plot(ce_depth, plot = FALSE)[[1]] + 
  scale_x_continuous(name ="Depth (m)", limits = c(1,5.5),breaks = seq(0, 6, by = 0.5)) +
  labs(x = "Depth (m)",  y = "Bleaching probability",  title = "") + theme_classic()
fig_5_b
ggsave("Data/Figure_Outputs/fig_5_b.pdf", fig_5_b, width = 5, height = 4)


# Prepare fully crossed conditions of the conditional effects
# Working with Site
conditions_site_depth <- make_conditions(Bayes0_Depth, vars = c( "Site"))
ce_Site_Depth <- conditional_effects(Bayes0_Depth,  conditions = conditions_site_depth, categorical = F, probs = c(0.33, 0.66), method = c("fitted"), re_formula = NULL) # probs = (0.025, 0.975) # You can decrease them to 0.2
# Wider intervals capture more uncertainty, narrower intervals focus more on the central tendency. Ignoring uncertainty!
# Make the plot

# Make the plot for Site in the same graph
ce_Site_Depth <- ce_Site_Depth$Depth
# Fig used below
fig_5_d <- ggplot(ce_Site_Depth, aes(x = Depth, y = estimate__, colour = Site, fill = Site)) +
  geom_line() +
  geom_ribbon(aes(ymin = lower__, ymax = upper__), alpha = 0.3) +
  facet_wrap(~Site)+
  scale_x_continuous(name ="Depth (m)", limits = c(1,5.5),breaks = seq(1, 5, by = 1)) +
  scale_y_continuous(name = "Bleaching probability", limits = c(0.4, 0.95), breaks = c(0.5, 0.6, 0.7, 0.8, 0.9)) +
  labs(x = "Depth (m)", y = "Bleaching probability", title = "") +
  scale_color_manual(values = c("Green", "Orange", "Red")) +
  scale_fill_manual(values = c("Green", "Orange", "Red")) +
  theme_classic() +
  theme(strip.background = element_blank(), strip.text = element_blank(), legend.position = "none", legend.title = element_blank())
fig_5_d
ggsave("Data/Figure_Outputs/fig_5_d.pdf", fig_5_d, width = 5, height = 2)



# Check the posterior distribution with depth
# Create a crossing dataframe
Depth <- unique (Bayes0_Depth$data$Depth)
Species <- unique (Bayes0_Depth$data$Species)
Site <- unique (Bayes0_Depth$data$Site)
ref_data_Depth <- crossing(Site, Depth, Species)

fitted_values_Depth <- posterior_epred(Bayes0_Depth, newdata = ref_data_Depth, re_formula = 'Status ~ 1 + Depth + Site + (1 + Depth | Species)')

str (fitted_values_Depth)
dim (fitted_values_Depth)

# Take all conditions: 
Posterior_Depth <- as.data.frame (fitted_values_Depth [c(1:12000),]) # Taking all conditions because it is binary 
# 1 is bleaching
# 0 is pigmented

# Necessary to transpose
Posterior_Depth <- t(Posterior_Depth)
ref_data_fitted_Depth <- cbind (ref_data_Depth,Posterior_Depth)
# View(ref_data_fitted_Depth)

ref_data_fitted_Depth <- melt (ref_data_fitted_Depth, id.vars = c ("Site", "Depth", "Species"), na.rm = F, measure.vars = c(4:12003), value.name = c("Prob")) # Adjust measure.vars

# Make a plot: 
library (ggridges)
# Set the order you want:
ref_data_fitted_Depth$Species <- factor(ref_data_fitted_Depth$Species, levels = rev(sort(unique(ref_data_fitted_Depth$Species))))
# Make the ggplot
ggplot(ref_data_fitted_Depth, aes(x = Prob, y = Species)) + # fill = Species
  geom_density_ridges(scale = 1, rel_min_height = 0.2) +  
  facet_wrap(~Site + Depth) +  xlab ("Likelihood Status, 0 = Pigmented & 1 = Bleached") + ylab ("")+
  theme_bw() +  theme(legend.position="none")
# Each Depth is specific of Site and Depth, so you can add the information if needed :) 

# mean Values for MS
mean_values <- aggregate (Prob ~ Species, data = ref_data_fitted_Depth, mean)
# Order them to set the order to be displayed
mean_values[order(mean_values$Prob), ]

# Manual order to fit the plot a)
ref_data_fitted_Depth$Species <- factor (ref_data_fitted_Depth$Species, levels = c("Porites",
                                                                                   "Pavona",
                                                                                   "Leptastrea",
                                                                                   "Cyphastrea",
                                                                                   "Acropora",
                                                                                   "Favites / Goniastrea",
                                                                                   "Montipora",
                                                                                   "Turbinaria",
                                                                                   "Dipsastraea",
                                                                                   "Platygyra",
                                                                                   "Psammocora",
                                                                                   "Goniopora"))


# Used fig below
fig_6_a <- ggplot(ref_data_fitted_Depth, aes(x = Prob, y = Species, fill = Species)) + # fill = Species
  geom_density_ridges(scale = 1, rel_min_height = 0.1) +  
  scale_fill_manual(values = rev(colours_sp)) +
  xlab ("Bleaching probability") + ylab ("")+
  theme_bw() +  theme(legend.position="none")
fig_6_a
ggsave("Data/Figure_Outputs/fig_6_a.pdf", fig_6_a, width = 4, height = 4)


# Make the figure of Prob vs Depth (instead of Temperatures) by Species with Depth 

# Conditional effects per genera/species
conditions_Depth <- make_conditions(Bayes0_Depth, vars = c( "Species"))
ce_depth_Species <- conditional_effects(Bayes0_Depth,  conditions = conditions_Depth, categorical = F, probs = c(0.33, 0.66), method = c("fitted"), re_formula = NULL) # This one has a narrower interval to focus on general tendency
plot (ce_depth_Species)




# Make the plot for kept Species
ce_depth_Species <- ce_depth_Species$Depth

# Reorder Species factor levels by the maximum estimate__ value
ce_depth_Species <- ce_depth_Species %>%
  mutate(Species = fct_reorder(Species, estimate__, .fun = max, .desc = TRUE))

# Predefine the colours from red to green showing susceptibility
colours_sp = c(brewer.pal(11, "RdYlGn"),"#001000")
# Make the plot:

# Manual order to fit the plot like fig 6a)
ce_depth_Species$Species <- factor (ce_depth_Species$Species, levels = c("Goniopora","Psammocora","Platygyra",
                                                                         "Dipsastraea","Turbinaria","Montipora","Favites /\nGoniastrea",
                                                                         "Acropora","Cyphastrea",
                                                                         "Leptastrea", 
                                                                         "Pavona","Porites"))


# Calculate maximum species name length and wrap if over 10

ce_depth_Species <- ce_depth_Species %>%
  mutate(Species_wrapped = stringr::str_wrap(Species, width = 10))

# Keep the same order as before
ce_depth_Species$Species_wrapped <- factor (ce_depth_Species$Species_wrapped, levels = c("Goniopora","Psammocora","Platygyra",
                                                                                         "Dipsastraea","Turbinaria","Montipora",
                                                                                         "Favites /\nGoniastrea","Acropora",
                                                                                         "Cyphastrea","Leptastrea",
                                                                                         "Pavona","Porites"))


fig_6_b <- ggplot(ce_depth_Species, aes(x = Depth, y = estimate__, fill = Species)) +
  geom_line() +
  geom_ribbon(aes(ymin = lower__, ymax = upper__), alpha = 0.9) +
  facet_wrap(~Species_wrapped, scales = "fixed", ncol = 6) +
  scale_fill_manual(values = colours_sp) +
  scale_x_continuous(name = "Depth (m)", breaks = seq(1, 5, by = 1), limits = c(1,5)) +
  scale_y_continuous(name = "Bleaching probability", limits = c(0.00, 1.00), 
                     breaks = c(0.00, 0.25, 0.50, 0.75, 1.00)) +
  labs(x = "Depth (m)", y = "Bleaching probability") +
  theme_classic() +
  theme(strip.background = element_blank(), 
        legend.position = "none", strip.text = element_text(size = 6), axis.text = element_text(size = 7))
fig_6_b
ggsave("Data/Figure_Outputs/fig_6_b.pdf", fig_6_b, width = 5.5, height = 4)

# mean Values for MS
mean_values2 <- aggregate (estimate__ ~ Species, data = ce_depth_Species, mean)

mean_values2[order(mean_values2$estimate__), ]





