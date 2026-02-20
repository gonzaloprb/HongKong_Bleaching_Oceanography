# Chung data from 2022 bleaching. 

# Chung TH, Dellisanti W, Lai KP, Wu J, Qiu JW, Chan LL (2024) Local conditions modulated the effects of marine heatwaves on coral bleaching in subtropical Hong Kong waters. Coral Reefs 43(5):1235–1247. https:// doi. org/ 10. 1007/ S00338- 024- 02533-5

# Surveys conducted on August 1, 2 and 4 2022

require(tidyverse); require (plyr); require (reshape); require (ggplot2); require (ggrepel); require (dplyr); require(RColorBrewer); 


rm (list = ls()) 

# Open the data
data_2022 <- read.csv(file = "Data/Bleaching/Chung_data/data_extract.csv", header = T, dec = ".", sep = ",")

data_coverage_2022 <- read.csv(file = "Data/Bleaching/Chung_data/coverage_extract.csv", header = T, dec = ".", sep = ",")

# data_coverage_2022 and data_2022 are the same! 
rm (data_coverage_2022)

str(data_2022)
summary(data_2022)


# Information of the data: NEEDS to be Checked!
# For each site and depth, the sum of % across genera bleached and healthy colonies should be 100%
# 0=no bleaching, 30=1/3 surface bleached, 60=2/3 bleached, 100=more than 2/3 bleached

# You could technically say that 1/3 surface bleached is Pale; and 60=2/3 bleached or 100=more than 2/3 bleached fully bleached
# It doesn't matter because in the end, we transform to binomial

# Filter the data to only the sites we want 
unique (data_2022$site)
data_2022 <- subset(data_2022, site == "TPC" | site == "Sharp" | site == "Bluff")

data_2022$site <- str_replace_all(data_2022$site, 'TPC', 'Tung Ping Chau')
data_2022$site <- str_replace_all(data_2022$site, 'Sharp', 'Sharp Island')
data_2022$site <- str_replace_all(data_2022$site, 'Bluff', 'Bluff Island')

# According to the paper: Shallow is 2-4 m and Deep is 4-6 m
# Forcing transformation: 
unique (data_2022$depth)
data_2022$depth <- str_replace_all(data_2022$depth, 's', '2_3_m')
data_2022$depth <- str_replace_all(data_2022$depth, 'd', '4_5_m')

# Make a loop to confirm if the sum across genera of bleached and healthy % is 100%
# Initialize a list to store the results
results <- list()
# Get unique combinations of site and depth
unique_combinations <- unique(data_2022[, c("site", "depth")])

# Loop through each unique combination of site and depth
for (i in 1:nrow(unique_combinations)) {
  site <- unique_combinations$site[i]
  depth <- unique_combinations$depth[i]
  
  # Subset the data for the current site and depth
  subset_data <- data_2022[data_2022$site == site & data_2022$depth == depth, ]
  
  # Sum the "Healthy" and "Bleached" columns
  sum_healthy <- sum(subset_data$Healthy, na.rm = TRUE)
  sum_bleached <- sum(subset_data$Bleached, na.rm = TRUE)
  
  # Store the results in the list
  results[[paste(site, depth, sep = "_")]] <- c(Healthy = sum_healthy, Bleached = sum_bleached)
}

# Convert results to a data frame for easier viewing
results_df <- do.call(rbind, results)
results_df <- as.data.frame(results_df)
results_df$Total <- rowSums(results_df[, c("Healthy", "Bleached")], na.rm = TRUE)

# Print the results
print(results_df)

# These are the percentages of Healthy and bleached covers

# Make a ggplot
ggplot(data_2022, aes(x = genus, y = Healthy)) +
  geom_bar(stat = "identity",position = "dodge", colour = "black") + 
  facet_grid(site ~ depth, switch = "y") +  scale_y_continuous(position = "right",breaks = c(0,25,50,75,100)) +
  ylab ("Percentatge (%)") + xlab ("") + scale_fill_manual(values = colours) + ggtitle("2022 Bleaching: Tzu Hao Chung et al 2024")+
  theme_classic() +
  theme(legend.position="bottom", axis.text.x = element_text(angle = 90)) 


# Create the plot
ggplot(data_2022) +
  # Bar plot for Bleached (scaled to match the secondary y-axis)
  geom_bar(aes(x = genus, y = Bleached * 2, fill = "Bleached"), # Here you multiply and later you divide /2
           stat = "identity", position = "dodge", colour = "black", fill = "white") +
  # Bar plot for Healthy
  geom_bar(aes(x = genus, y = Healthy, fill = "Healthy"), 
           stat = "identity", position = "dodge", colour = "black", fill = "coral4") +
  # Facet by site and depth
  facet_grid(site ~ depth, switch = "y") +
  # Primary y-axis (for Healthy)
  scale_y_continuous(name = "Percentage (%)",breaks = c(0, 25, 50, 75, 100),
                     sec.axis = sec_axis(~ . / 2, name = "Bleached (%)")) + # Secondary y-axis (for Bleached)
  # Labels and titles
  ylab("Percentage (%)") + xlab("") + scale_fill_manual(values = colours) + ggtitle("2022 Bleaching: Tzu Hao Chung et al 2024") +
  # Theme
  theme_classic() +
  theme(legend.position = "bottom", axis.text.x = element_text(angle = 90))



# Plot side by side
# Reshape data to long format for ggplot
data_long <- data_2022 %>% pivot_longer(cols = c(Healthy, Bleached), names_to = "Status", values_to = "Percentage")
# Put in the right order: 
data_long$Status = factor(data_long$Status,levels = c ("Healthy", "Bleached"))

# Define colours (replace with your actual colours)
colours <- c("Healthy" = "coral4", "Bleached" = "white")
# Create the plot
ggplot(data_long, aes(x = genus, y = Percentage, fill = Status)) +
  # Bar plot with bars side by side
  geom_bar(stat = "identity", position = position_dodge(width = 0.9), colour = "black") +
  # Facet by site and depth
  facet_grid(site ~ depth, switch = "y") +
  scale_y_continuous(position = "right",breaks = c(0,25,50,75,100)) +
  ylab ("Percentatge (%)") + xlab ("") + scale_fill_manual(values = colours) + ggtitle("2022 Bleaching: Tzu Hao Chung et al 2024")+
  theme_classic() +
  theme(legend.position="top", axis.text.x = element_text(angle = 90)) 

# Clean unnecessary databases
rm (results,sum_bleached,sum_healthy,subset_data,unique_combinations)


#### Create the dataframes

# Make the binary counting colonies based on the % Xo, X30, X60, X100
# 0=no bleaching, 30=1/3 surface bleached, 60=2/3 bleached, 100=more than 2/3 bleached

data_2022_Binary <- data_2022
  
colnames(data_2022_Binary) <- c("Zone","Site", "Depth", "Genus","Pigmented","Bleached","NObs_Pigmented","NObs Bleached 30","NObs Bleached 60","NObs Bleached 100")

#### Pivot to have Status column with Percentages ######
data_2022_Binary_Perc <- data_2022_Binary %>% pivot_longer(cols = c(Pigmented, Bleached), names_to = "Status_Perc", values_to = "Percentage")
data_2022_Binary_Perc <- subset(data_2022_Binary_Perc, select = c(Site, Depth, Genus,Status_Perc, Percentage))

data_2022_Binary_Perc$Status_Perc <- str_replace_all(data_2022_Binary_Perc$Status_Perc, 'Bleached', 'Bleached or partial bleached')
#### Pivot to have Status column with Percentages ######

# Create the necessary dataframe to combine with the 2024 data
# Sum the bleached colonies because we want 
data_2022_Binary$NObs_Bleached <- rowSums(data_2022_Binary[, c("NObs Bleached 30", "NObs Bleached 60","NObs Bleached 100")], na.rm = TRUE)


# Pivot to have Status column with counting colonies!
data_2022_Binary <- data_2022_Binary %>% pivot_longer(cols = c(NObs_Pigmented, NObs_Bleached), names_to = "Status", values_to = "Number.Observations")

# Select only the columns we want:
data_2022_Binary <- subset(data_2022_Binary, select = c(Site, Depth, Genus,Status, Number.Observations))

data_2022_Binary$Status <- str_replace_all(data_2022_Binary$Status, 'NObs_Pigmented', 'Pigmented')
data_2022_Binary$Status <- str_replace_all(data_2022_Binary$Status, 'NObs_Bleached', 'Bleached or partial bleached')



# Adapt to have the same formatting, variable names etc as "data_bm2"

colnames (data_2022_Binary) <- c ("Site", "Depth", "Species", "Status", "Number.Observations")
# Even if they are "Genus"

# Get rid of the 0s, you can also run the hurdle model
data_2022_Binary <- data_2022_Binary[data_2022_Binary$Number.Observations >0,] 

# Transform the Status bleaching into : 
# 0 = Pigmented; 1 = Bleaching
data_2022_Binary$Status <- str_replace_all(data_2022_Binary$Status, 'Pigmented', '0')
data_2022_Binary$Status <- str_replace_all(data_2022_Binary$Status, 'Bleached or partial bleached', '1')

# Transform the depths: 
data_2022_Binary$Depth <- str_replace_all(data_2022_Binary$Depth, '2_3_m', '2')
data_2022_Binary$Depth <- str_replace_all(data_2022_Binary$Depth, '4_5_m', '3')
data_2022_Binary$Depth <- as.integer(data_2022_Binary$Depth)

data_2022_Binary$Number.Observations <- as.integer(data_2022_Binary$Number.Observations)
# See above the equivalent of these depths

# No unidentified so we are all good!
unique (data_2022_Binary$Species)

str (data_2022_Binary)
summary (data_2022_Binary)

### Run the Bayesian model tested and selected with the 2024 data: 
library (brms); library(parallel);  library (tidybayes) ;  library (posterior); library (cmdstanr); library (rstan)

# Straight to the selected model "fit_bayes_5"
# In this case, it is called: "fit_bayes_2022"

# Need to increase adapt delta and max_treedepth, and transitions. 
# My data converged better
fit_bayes_2022 <- brms::brm(Status ~ 1 + Depth + Site + (1 + Depth | Species), data = data_2022_Binary, family = bernoulli(link = "logit"),control = list(max_treedepth = 18, adapt_delta = 0.99), chains = 2, cores = 2, iter = 9000, warmup = 3000, backend = "cmdstanr", threads = 1)
summary (fit_bayes_2022)
# Interp:
# It converged without priors but with higher, tree depth or delta!
# Sometimes it does not converge so becareful! Just run the above code several times
# Depth significant decrease (-2.93, l-95% CI = -5.07    u-95% = -1.27) of Status 1 (which is bleaching), way more marked than with my 2024 data
# Sharp and TPC don't necessarily have more bleaching than Bluff
# No need to run extra models because this formula is the one we keep for the 2024 data. 
save(fit_bayes_2022, file="Data/Bayesian_Outputs/fit_bayes_2022.RData")
load("Data/Bayesian_Outputs/fit_bayes_2022.RData")

# Analyse the model
# Check convergence 
summary(fit_bayes_2022)
coef (fit_bayes_2022) # The random slope with depth does not change across sites because the model is set like this!
fit_bayes_2022
# check the plots
plot (fit_bayes_2022)
pp_check(fit_bayes_2022) # The predicted and observed values do not converge as good as with my model

# Conditional effects: 
conditional_effects(fit_bayes_2022)
# Remember that the depths are 2_4 m and 5_6 m

# Make a nicer plot
ce <- conditional_effects(fit_bayes_2022,categorical = F, probs = c(0.33, 0.66), method = c("fitted"))
# Probs  # 0.025, 0.975 had to be changed to 0.33 to 0.66, you can change to prob = c (0.2)

# plot conditional effects for depth
plot(ce, plot = FALSE)[[1]] + 
  scale_x_continuous(name ="Depth (m)", limits=c(1,3), breaks = c(1,2,3)) +
  labs(x = "Depth (m)",  y = "Predicted status",  title = "0 = Pigmented, 1 = Bleaching") + theme_classic()

# plot conditional effects for Site as discrete variable
plot(ce, plot = FALSE)[[2]] + 
  labs(x = "Site",  y = "Predicted status",  title = "0 = Pigmented, 1 = Bleaching") + theme_classic()
# Again TPC a bit more bleaching, probably because the site has more corals 

# Prepare fully crossed conditions of the conditional effects
# Working with Site
conditions_site <- make_conditions(fit_bayes_2022, vars = c( "Site"))
ce_Site <- conditional_effects(fit_bayes_2022,  conditions = conditions_site, categorical = F, prob = c(0.2), method = c("fitted"), re_formula = NULL) # Instead of probs = c(0.33, 0.66)
# Make the plot
plot (ce_Site)

# Make the plot for Site in the same graph
ce_Site <- ce_Site$Depth
ggplot(ce_Site, aes(x = Depth, y = estimate__, colour = Site)) +
  geom_line() +
  geom_ribbon(aes(ymin = lower__, ymax = upper__), alpha = 0.2) +
  scale_x_continuous(name = "Depth (m)", limits = c(1, 3), breaks = c(1, 2, 3)) +
  # scale_y_continuous(name = "Probability", limits = c(0.00, 1.00), breaks = c(0.00, 0.25, 0.50, 0.75, 1.00)) +
  labs(x = "Depth (m)", y = "Predicted status", title = "0 = Pigmented; 1 = Bleaching") +
  theme_classic() +
  theme(strip.background = element_blank(), legend.position = "bottom", legend.title = element_blank())


# Conditional effects per genera/species
conditions <- make_conditions(fit_bayes_2022, vars = c( "Species"))
ce_Species <- conditional_effects(fit_bayes_2022,  conditions = conditions, categorical = F, prob = c(0.2), method = c("fitted"), re_formula = NULL) # Instead of probs = c(0.33, 0.66)
plot (ce_Species)


# # Filter to certain species with higher occurrences: 
# In Jeffery's data, these are: 
unique (data_2022_Binary$Species)
Depth_range <- ddply(data_2022_Binary,~ Depth + Species ,function(x){c(Nb_observ_depth=nrow(x))})
Occurrences <- ddply(data_2022_Binary,~  Species ,function(x){c(Nb_observ=nrow(x))})
# View(Occurrences)
# The 2022 data is poorer so we consider a drop if less than 1 Observations total, we keep all species
Keep_species <- Occurrences %>% filter(Nb_observ > 1) %>% pull(Species)


# Make the plot with filtered species
ce_Species <- ce_Species$Depth
# Make the filtering to only the species we want to display
ce_Species <- ce_Species %>% filter(Species %in% Keep_species)


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
Depth <- unique (fit_bayes_2022$data$Depth)
Species <- unique (fit_bayes_2022$data$Species)
Site <- unique (fit_bayes_2022$data$Site)
ref_data <- crossing(Site, Depth, Species)

fitted_values <- posterior_epred(fit_bayes_2022, newdata = ref_data, re_formula = 'Status ~ 1 + Depth + Site + (1 + Depth | Species)')

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

ref_data_fitted <- melt (ref_data_fitted, id.vars = c ("Site", "Depth", "Species"), na.rm = F, measure.vars = c(4:84), value.name = c("Prob"))

# check the depth ranges of the species
# # Filter to certain species with higher occurrences: 
Depth_range <- ddply(data_2022_Binary,~ Depth + Species ,function(x){c(Nb_observ_depth=nrow(x))})
Occurrences <- ddply(data_2022_Binary,~  Species ,function(x){c(Nb_observ=nrow(x))})
# View(Occurrences)
# Less than 8 Observations total, the species are dropped
Keep_species <- Occurrences %>% filter(Nb_observ > 1) %>% pull(Species)

# Filter the ref_data_fitted
ref_data_fitted2 <- ref_data_fitted %>% filter(Species %in% Keep_species)

# Make a plot: 
library (ggridges)
# Set the order you want:
ref_data_fitted2$Species <- factor(ref_data_fitted2$Species, levels = rev(sort(unique(ref_data_fitted2$Species))))
# Make the ggplot
ggplot(ref_data_fitted2, aes(x = value, y = Species)) + # fill = Species
  geom_density_ridges(scale = 1, rel_min_height = 0.1 ) +  
  facet_wrap(~Depth, nrow = 3) +  xlab ("Likelihood Status, 0 = Pigmented & 1 = Bleached") + ylab ("")+
  theme_bw() +  theme(legend.position="none")
# Depth 1 is 1 m; 2 is 2-3 m and 3 is 4-5 m.

# Without considering depths
ggplot(ref_data_fitted2, aes(x = value, y = Species)) + # fill = Species
  geom_density_ridges(scale = 1, rel_min_height = 0.1 ) +  
  xlab ("Likelihood Status, 0 = Pigmented & 1 = Bleached") + ylab ("")+
  theme_bw() +  theme(legend.position="none")


# Write csv for data_2022_Binary to run a Bayesian model with the 2024 data

# Add a column to add 2022 bleaching data

# Add a column with Year
data_bm_2022 <- data_2022_Binary
data_bm_2022$Year <- 2022

write_csv(data_bm_2022, "Data/Bleaching/data_bm_2022.csv")




