# Open Jeffery data from 2022 bleaching
# Open Gonzalo data from 2024 bleaching 

#### Read Me ####
# It compares both bleaching events with Bayesian modelling
# It generates Fig 2d and Fig 2e

#### Read Me ####

require(tidyverse); require (plyr); require (reshape); require (ggplot2); require (ggrepel); require (dplyr); require(RColorBrewer); 


rm (list = ls()) 

# Open the data
data_bm_2022 <- read.csv(file = "Bleaching/data_bm_2022.csv", header = T, dec = ".", sep = ",")

data_bm_2024 <- read.csv(file = "Bleaching/data_bm_2024.csv", header = T, dec = ".", sep = ",")

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

# Clean the working environment
rm (data_bm_2022, data_bm_2024, Depth_range, Occurrences, Keep_species)

# Check structure of data_bm_bleachings (2022 and 2024):
str (data_bm_bleachings)
summary (data_bm_bleachings)



### Run the Bayesian model:
library (brms); library(parallel);  library (tidybayes) ;  library (posterior); library (cmdstanr); library (rstan)

# Straight to the Formula of selected model "fit_bayes_5" for 2024 and "fit_bayes_2022" for 2022
# In this case, it is called: "fit_bayes_2022"

# Run the models:
fit_bayes_bleachings <- brms::brm(Status ~ 1 + Depth + Site + (1 + Depth | Species), data = data_bm_bleachings, family = bernoulli(link = "logit"),control = list(max_treedepth = 16, adapt_delta = 0.9), chains = 2, cores = 2, iter = 9000, warmup = 3000, backend = "cmdstanr", threads = 1)
summary (fit_bayes_bleachings)
# Interp:
# It converged without priors and with relatively low adapt delta and max tree depth
# Depth significant decrease (-0.91, l-95% CI = -1.40    u-95% = -0.52) of Status 1 (which is bleaching)
# Sharp and TPC have more bleaching than Bluff
save(fit_bayes_bleachings, file="Bayesian_Outputs/fit_bayes_bleachings.RData")
load("Bayesian_Outputs/fit_bayes_bleachings.RData")

# 2nd model
# Just run an extra line to compare across years. Year as a fixed effect
data_bm_bleachings$Year <- as.character(data_bm_bleachings$Year)

fit_bayes_bleachings2 <- brms::brm(Status ~ 1 + Depth + Site + Year + (1 + Depth | Species), data = data_bm_bleachings, family = bernoulli(link = "logit"),control = list(max_treedepth = 16, adapt_delta = 0.9), chains = 2, cores = 2, iter = 9000, warmup = 3000, backend = "cmdstanr", threads = 1)
summary (fit_bayes_bleachings2)
# Interp:
# Same conclusions and we can also observe how Year 2024 had a higher bleaching than Year 2022
save(fit_bayes_bleachings2, file="Bayesian_Outputs/fit_bayes_bleachings2.RData")
load("Bayesian_Outputs/fit_bayes_bleachings2.RData")

# Compare the two models: 
library(loo)
# Extract Loo for each model and compare: 
# loo1 <- loo(fit_bayes_1)
loo <- loo(fit_bayes_bleachings)
loo2 <- loo(fit_bayes_bleachings2)

comparison <- loo_compare(loo,loo2) # 
print(comparison) # The second model comparing across years is better


# Carry on with second model fit_bayes_bleachings2

# Analyse the model
# Check convergence 
summary(fit_bayes_bleachings2)
coef (fit_bayes_bleachings2) # The random slope with depth does not change across sites or years because the model is set with site and year as fixed effect

# check the plots
plot (fit_bayes_bleachings2)
pp_check(fit_bayes_bleachings2) # The predicted and observed values converged all right!

# Conditional effects: 
conditional_effects(fit_bayes_bleachings2)
# Remember that the depths are 2_4 m and 5_6 m
# We assumed that the depths are: Depth 1 = 1 m; Depth 2 ~ 3 m, Depth 3 ~ 5 m.

# Make a nicer plot
ce <- conditional_effects(fit_bayes_bleachings2,categorical = F, probs = c(0.1, 0.9), method = c("fitted")) # 0.025, 0.975 = 95 % interval
# wider intervals (e.g., c(0.1, 0.9)) to capture more uncertainty
# narrower intervals (e.g., c(0.33, 0.66)) to focus on the central tendency

# corresponds to a 95% credible, very high

# plot conditional effects for depth
fig_2_d <- plot(ce, plot = FALSE)[[1]] + 
  scale_x_continuous(name ="Depth (discrete levels)", limits=c(1,3), breaks = c(1,2,3)) +
  labs(x = "Depth discrete levels",  y = "Bleaching probability",  title = "0 = Pigmented, 1 = Bleached") + theme_classic()
fig_2_d 
ggsave("Figure_Outputs/fig_2_d.pdf", fig_2_d, width = 3, height = 2.5)


# plot conditional effects for Site as discrete variable
plot(ce, plot = FALSE)[[2]] + 
  labs(x = "Site",  y = "Predicted status",  title = "0 = Pigmented, 1 = Bleached") + theme_classic()
# Again TPC a bit more bleaching, probably because the site has more corals 

plot(ce, plot = FALSE)[[2]] + 
  labs(x = "Site",  y = "Predicted status",  title = "0 = Pigmented, 1 = Bleached") + theme_classic()
# Again TPC a bit more bleaching, probably because the site has more corals 

# plot conditional effects for Year as discrete variable
plot(ce, plot = FALSE)[[3]] + 
  labs(x = "Year",  y = "Predicted status",  title = "0 = Pigmented, 1 = Bleached") + theme_classic()
# Again 2024 had more bleaching than 2022 

# Prepare fully crossed conditions of the conditional effects
# Working with Site
conditions_site <- make_conditions(fit_bayes_bleachings2, vars = c( "Site"))
ce_Site <- conditional_effects(fit_bayes_bleachings2,  conditions = conditions_site, categorical = F, probs = c(0.33, 0.66), method = c("fitted"), re_formula = NULL) # probs = (0.025, 0.975) # You can decrease them to 0.2
# Wider intervals capture more uncertainty, narrower intervals focus more on the central tendency. Ignoring uncertainty!
# Make the plot
plot (ce_Site) # The second plot is interesting!

# Make the plot for Site in the same graph
ce_Site <- ce_Site$Depth
ggplot(ce_Site, aes(x = Depth, y = estimate__, colour = Site, fill = Site)) +
  geom_line() +
  geom_ribbon(aes(ymin = lower__, ymax = upper__), alpha = 0.3) +
  scale_x_continuous(name = "Depth (m)", limits = c(1, 3), breaks = c(1, 2, 3)) +
  # scale_y_continuous(name = "Probability", limits = c(0.00, 1.00), breaks = c(0.00, 0.25, 0.50, 0.75, 1.00)) +
  labs(x = "Depth (m)", y = "Predicted status", title = "0 = Pigmented; 1 = Bleached") +
  scale_color_manual(values = c("Green", "Orange", "Red")) +
  scale_fill_manual(values = c("Green", "Orange", "Red")) +
  theme_classic() +
  theme(strip.background = element_blank(), legend.position = "bottom", legend.title = element_blank())





# Prepare fully crossed conditions of the conditional effects
# Working with Year
conditions_year <- make_conditions(fit_bayes_bleachings2, vars = c( "Year"))
ce_Year <- conditional_effects(fit_bayes_bleachings2,  conditions = conditions_year, categorical = F, probs = c(0.33, 0.66), method = c("fitted"), re_formula = NULL) # Narrower conditions...
# Make the plot
plot (ce_Year)

# Make the plot for Year and Site in the same graph
ce_Year <- ce_Year$Site
fig_2_e <- ggplot(data = ce_Year, aes(x = Year, y = estimate__)) + # colour = Site
  # geom_boxplot(varwidth = 0.005, linewidth = 0.005) +
  geom_errorbar(data =  ce_Year, ymin = ce_Year$estimate__ - ce_Year$se__, ymax = ce_Year$estimate__ + ce_Year$se__, width = 0.5) +
  facet_wrap(~Site, scales = "free" ) +
  # scale_color_manual(values = c("Bluff Island" = "Green", "Sharp Island" = "Orange", "Tung Ping Chau" = "Red")) +
  scale_y_continuous(name = "Bleaching probability", limits = c(0, 1), breaks = seq(0, 1, by = 0.2)) +
  labs(x = "Bleaching event",y = "Bleaching probability") +
  theme_classic() +
  theme(strip.background = element_blank(),legend.position = "bottom",legend.title = element_blank()) 
fig_2_e
ggsave("Figure_Outputs/fig_2_e.pdf", fig_2_e, width = 6, height = 5)




# Conditional effects per genera/species
conditions <- make_conditions(fit_bayes_bleachings2, vars = c( "Species"))
ce_Species <- conditional_effects(fit_bayes_bleachings2,  conditions = conditions, categorical = F, probs = c(0.33, 0.66), method = c("fitted"), re_formula = NULL) # This one has a narrower interval to focus on general tendency
plot (ce_Species)




# Make the plot with filtered species
ce_Species <- ce_Species$Depth
# Make the plot:
ggplot(ce_Species, aes(x = Depth, y = estimate__)) +
  geom_line() +
  geom_ribbon(aes(ymin = lower__, ymax = upper__), alpha = 0.2) +
  facet_wrap(~Species, scales = "free", ncol = 6) +
  scale_x_continuous(name = "Depth (m)", limits = c(1, 3), breaks = c(1, 2, 3)) +
  scale_y_continuous(name = "Probability", limits = c(0.00, 1.00), breaks = c(0.00, 0.25, 0.50, 0.75, 1.00)) +
  labs(x = "Depth (m)", y = "Probability", title = "0 = Pigmented; 1 = Bleaching") +
  theme_classic() +
  theme(strip.background = element_blank())


ggplot(ce_Species, aes(x = Depth, y = estimate__,colour = Species,fill = Species)) +
  geom_line() +
  geom_ribbon(aes(ymin = lower__, ymax = upper__),alpha = 0.2) +
  scale_x_continuous(name = "Depth (m)", limits = c(1, 3), breaks = c(1, 2, 3)) +
  # scale_y_continuous(name = "Probability", limits = c(0.00, 1.00), breaks = c(0.00, 0.25, 0.50, 0.75, 1.00)) +
  labs(x = "Depth (m)", y = "Predicted status", title = "0 = Pigmented; 1 = Bleaching") +
  theme_classic() +
  theme(strip.background = element_blank(), legend.position = "left")




# Check the posterior distribution
# Create a crossing dataframe
Depth <- unique (fit_bayes_bleachings2$data$Depth)
Species <- unique (fit_bayes_bleachings2$data$Species)
Site <- unique (fit_bayes_bleachings2$data$Site)
Year <- unique (fit_bayes_bleachings2$data$Year)
ref_data <- crossing(Site, Year, Depth, Species)

fitted_values <- posterior_epred(fit_bayes_bleachings2, newdata = ref_data, re_formula = 'Status ~ 1 + Depth + Site + Year + (1 + Depth | Species)')

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

ref_data_fitted <- melt (ref_data_fitted, id.vars = c ("Site", "Year","Depth", "Species"), na.rm = F, measure.vars = c(5:216), value.name = c("Prob")) # Adjust measure.vars

# Make a plot: 
library (ggridges)
# Set the order you want:
ref_data_fitted$Species <- factor(ref_data_fitted$Species, levels = rev(sort(unique(ref_data_fitted$Species))))
# Make the ggplot
ggplot(ref_data_fitted, aes(x = Prob, y = Species)) + # fill = Species
  geom_density_ridges(scale = 1, rel_min_height = 0.2) +  
  facet_wrap(~Depth, nrow = 3) +  xlab ("Likelihood Status, 0 = Pigmented & 1 = Bleached") + ylab ("")+
  theme_bw() +  theme(legend.position="none")
# Depth 1 is 1 m (no 2022 data); 2 is 3 m and 3 is 5 m.

# Without considering depths
ggplot(ref_data_fitted, aes(x = Prob, y = Species)) + # fill = Species
  geom_density_ridges(scale = 1, rel_min_height = 0.1 ) +  
  xlab ("Likelihood Status, 0 = Pigmented & 1 = Bleached") + ylab ("")+
  theme_bw() +  theme(legend.position="none")





