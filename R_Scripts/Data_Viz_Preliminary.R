
#### Read ME #####
# Visualizations for Bleaching surveys HK 2024

# 1st surveys in August during peak of the bleaching
# 2nd surveys in November post bleaching 

# The data comes from counting colonies along 30 m transects * 3
# There are 5 sites: Sharp Island, Tung Ping Chau, Gruff Head, Long Ke Wan, Bluff Island, 
# 3 Depths: Deep 4-5 m; Intermediate 2-3 m; Shallow 1 m


# Departing questions: 

### Biological data
# 1st.  Are there any spatial differences across the 3 sites?

# 2nd. Are there any Depth differences?

# 3rd. Did all sites recovered equally?

# 4th. Are there any genus/species driven effects?

# 5h. What environmental history gives corals such a bleaching resilience and wide thermal tolerance?

### Environmental data
# CTD
# Temperature logger data
# Oxygen logger data
# Not sure: Eddy covariance? Gradient Flux Systems?

# Final question: Can environmental data predict/explain the bleaching recover response?



#### Read ME #####

#### Read Me - Extra information

# This is a massive script mainly for Data exploration and Visualisations
# For the Bayesian models better to use Scripts: "Read_Temps_Defi_Bayesian_Model.R" and "Bayesianmodel_Bleaching_Events.R"
# This script includes frequentist statistics as well as the Hurdle models
# It generates Fig. 4 and Fig. S3 and Fig. S4
# It generates the "data_bm_2024.csv" later used in the Bayesian model


# Download the necessary packages
require(tidyverse); require (plyr); require (reshape); require (ggplot2); require (ggrepel); require (dplyr); require(RColorBrewer); library (reshape2)


rm (list = ls())

# Open the data
data_survey <- read.csv(file = "Data/Bleaching/Bleaching_Survey_final.csv", header = T, dec = ".", sep = ",")

str(data_survey)
summary(data_survey)

# Delete rows where they are all NA
data_survey <- na.omit (data_survey)


# Set Number.Observations as numeric and transect as character
data_survey$Number.Observations <- as.numeric (data_survey$Number.Observations)



# Create new column Bleaching.Time
# unique (data_survey$Date)
data_survey$Bleaching.Time <- data_survey$Date

data_survey$Bleaching.Time <- str_replace_all(data_survey$Bleaching.Time, c("2024-08-05" = "During","2024-08-06" = "During", "2024-08-09" = "During", "2024-11-05" = "After","2024-11-06" = "After"))
unique (data_survey$Bleaching.Time)


# Filter to only the columns we want 
# select dplyr giving problems
data_survey <-  subset (data_survey, select = c(Site, Bleaching.Time, Depth, Transect, Species, Size, Status, Number.Observations))

# Species for which there are no observations at all
aggregate(Number.Observations ~ Species, data = data_survey, FUN = sum)




# Necessary to apply the few corrections decided during the analyses of the unique Species
unique (sort(data_survey$Species))

# Combine the two Acroporas. They are different enough to differentiate in the field but with juveniles, I got very confused so I am not sure the binary 
# classification was done right. The best solution is to pool them together
data_survey$Species <- str_replace_all(data_survey$Species, 'Acropora digitifera / tumida', 'Acropora sp.')
data_survey$Species <- str_replace_all(data_survey$Species, 'Acropora pruniosa / solitiariensis', 'Acropora sp.')
data_survey$Species <- str_replace_all(data_survey$Species, 'Acropora sp.', 'Acropora')

# Replace "Unknown" with "unidentified"
data_survey$Species <- str_replace_all(data_survey$Species, 'Unknown', 'Unidentified')
data_survey$Species <- str_replace_all(data_survey$Species, 'Dead unknown', 'Unidentified')

# Check the Status:
unique (sort(data_survey$Status))

# Get rid of the "Uncategorised" rows because they do not provide anything to this study
data_survey <- data_survey %>% filter(Status != "Uncategorised")


# Make sure you consider aggregations in case there is multiple rows imputing the same information
# duplicated(data_survey[,1:7])
library (hablar)
data_survey %>% 
  find_duplicates(Site,Bleaching.Time,Depth,Transect,Species,Size,Status)
# All the Acropora and changed names

data_survey <- aggregate (Number.Observations ~ Site + Bleaching.Time + Depth + Transect + Species + Size + Status, data_survey, sum)
# No more duplicates now: 
data_survey %>% find_duplicates(Site,Bleaching.Time,Depth,Transect,Species,Size,Status)

# We are good to go! 

# Very important command: 
# need to complete the whole database because only information when there are observations in the Excel
# Some entries for Site, Depth, Species, Size, Status will display 0 colonies!
data_survey <- data_survey %>% complete(Site, Bleaching.Time, Depth, Transect, Species, Size, Status,fill = list(Number.Observations = 0))



# Quick visualisations:

# Check the number of coral colonies per Transect at each site per survey date
nb_colonies <- ddply(data_survey, ~ Site + Bleaching.Time  + Depth + Transect ,function(x){
  c(nb_colonies=sum(x$Number.Observations)) }) 

# Nb of coral colonies per species/genus
nb_colonies_species <- ddply(data_survey, ~ Site + Bleaching.Time  + Depth + Transect + Species ,function(x){
  c(nb_colonies_species=sum(x$Number.Observations)) }) 

# alpha diversity of unique species/genus per site + Bleaching.Time + Depth + Transect
nb_diversity <- ddply(data_survey, ~ Site + Bleaching.Time  + Depth + Transect ,function(x){
  x <- x[x$Number.Observations > 0, ]
  c(nb_diversity=length(unique(x$Species))) }) 

# alpha diversity of unique species/genus per site
nb_diversity_site <- ddply(data_survey, ~ Site,function(x){
  x <- x[x$Number.Observations > 0, ]
  c(nb_diversity_site=length(unique(x$Species))) }) 

# Make a plot of diversity and colonies count
nb_diversity$Bleaching.Time <- factor(nb_diversity$Bleaching.Time, levels = c("During","After")) 

ggplot(nb_diversity, aes(x = Bleaching.Time, y = nb_diversity, fill = Transect)) +
  geom_bar(stat = "identity",position = "dodge") +
  facet_wrap(~ Site +  Depth, ncol = 3) +
  scale_y_continuous(breaks = scales::pretty_breaks())+
  labs(title = "Alpha diversity",
       x = "Depths",
       y = "Richness (n)") +
  theme_minimal() +
  theme(legend.position="bottom") 


# Prepare plot as Supplementary Figure S3


nb_colonies$Site = factor(nb_colonies$Site,levels = c ("Bluff Island","Sharp Island", "Tung Ping Chau"))
nb_colonies$Depth <- str_replace_all(nb_colonies$Depth, '1_m', '~ 1 m')
nb_colonies$Depth <- str_replace_all(nb_colonies$Depth, '2_3_m', '~ 2-3 m')
nb_colonies$Depth <- str_replace_all(nb_colonies$Depth, '4_5_m', '~ 4-5 m')
nb_colonies$Depth = factor(nb_colonies$Depth,levels = c ("~ 1 m","~ 2-3 m","~ 4-5 m"))

nb_colonies$Bleaching.Time <- factor(nb_colonies$Bleaching.Time, levels = c("During","After")) 



ggplot(nb_colonies, aes(x = Bleaching.Time, y = nb_colonies, fill = Transect)) +
  geom_bar(stat = "identity",position = "dodge") +
  facet_grid(Depth ~ Site) +  scale_y_continuous(position = "left",breaks = c(0,25,50,75,100)) +
  scale_y_continuous(breaks = scales::pretty_breaks())+
  labs(x = "", 
       y = "Number of colonies (n)") +
  theme_minimal() +
  theme(legend.position="bottom",
        strip.background = element_rect(fill = "white", color = "black"), # Add boxes
        strip.text = element_text(color = "black")) # Customize text if needed


## Extra graph 
nb_colonies_species$Site = factor(nb_colonies_species$Site,levels = c ("Bluff Island","Sharp Island", "Tung Ping Chau"))
nb_colonies_species$Depth <- str_replace_all(nb_colonies_species$Depth, '1_m', '~ 1 m')
nb_colonies_species$Depth <- str_replace_all(nb_colonies_species$Depth, '2_3_m', '~ 2-3 m')
nb_colonies_species$Depth <- str_replace_all(nb_colonies_species$Depth, '4_5_m', '~ 4-5 m')
nb_colonies_species$Depth = factor(nb_colonies_species$Depth,levels = c ("~ 1 m","~ 2-3 m","~ 4-5 m"))
nb_colonies_species$Bleaching.Time <- factor(nb_colonies_species$Bleaching.Time, levels = c("During","After")) 
# Group the species / taxa

ggplot(nb_colonies_species, aes(x = Site, y = nb_colonies_species, fill = Species)) +
  geom_bar(stat = "identity", position = "dodge") +
  facet_wrap(~ Depth, ncol = 1,strip.position = "right") +  # Move facet labels to the right
  scale_y_continuous(position = "left", breaks = c(0, 25, 50, 75, 100)) +
  labs(x = "",
       y = "Number of colonies (n)") +
  theme_minimal() +
  theme(
    legend.position = "bottom",
    legend.title = element_blank(),
    legend.key.size = unit(0.5, "lines"),  # Smaller legend keys
    legend.text = element_text(size = 8),  # Smaller legend text
    legend.spacing.y = unit(0.1, "cm"), 
    legend.margin = margin(0, 0, 0, 0),
    strip.background = element_rect(fill = "white", color = "black"), 
    strip.text = element_text(color = "black"),
    strip.placement = "outside"  # Ensures strips are placed outside the plot area
  )


# In the nb_colonies_species
unique (nb_colonies_species$Species)
# Also in the nb_colonies_species
nb_colonies_species$Species <- str_replace_all(nb_colonies_species$Species, 'Favites chinensis  / Gonia aspera', 'Favites / Goniastrea sp.') # Loss a bit of taxonomy!
nb_colonies_species$Species <- str_replace_all(nb_colonies_species$Species, 'Favites pentagona', 'Favites / Goniastrea sp.')
nb_colonies_species$Species <- str_replace_all(nb_colonies_species$Species, 'Favites abdita or sp.', 'Favites / Goniastrea sp.')
nb_colonies_species$Species <- str_replace_all(nb_colonies_species$Species, 'Porites lutea', 'Porites lutea / sp.') 
nb_colonies_species$Species <- str_replace_all(nb_colonies_species$Species, 'Porites aranetai / deformis', 'Porites lutea / sp.') 
nb_colonies_species$Species <- str_replace_all(nb_colonies_species$Species, 'Montipora peltiformis','Montipora sp')

# Genus level
unique (nb_colonies_species$Species)
nb_colonies_species$Species <- str_replace_all(nb_colonies_species$Species, 'Acanthastrea hempirichii','Acanthastrea')
# nb_colonies_species$Species <- str_replace_all(nb_colonies_species$Species, 'Acropora','Acropora')
nb_colonies_species$Species <- str_replace_all(nb_colonies_species$Species, 'Cyphastrea serailia / japonica','Cyphastrea')
nb_colonies_species$Species <- str_replace_all(nb_colonies_species$Species, 'Dipsastraea rotumana / speciosa','Dipsastraea')
nb_colonies_species$Species <- str_replace_all(nb_colonies_species$Species, 'Echinophillia aspera','Echinophillia')
nb_colonies_species$Species <- str_replace_all(nb_colonies_species$Species, 'Favites / Goniastrea sp.','Favites / Goniastrea')
nb_colonies_species$Species <- str_replace_all(nb_colonies_species$Species, 'Galaxea fascicularis / astreata','Galaxea')
nb_colonies_species$Species <- str_replace_all(nb_colonies_species$Species, 'Goniopora columna or sp.','Goniopora')
nb_colonies_species$Species <- str_replace_all(nb_colonies_species$Species, 'Hydnophora exesa','Hydnophora')
nb_colonies_species$Species <- str_replace_all(nb_colonies_species$Species, 'Leptastrea purpurea / pruinosa / sp.','Leptastrea')
nb_colonies_species$Species <- str_replace_all(nb_colonies_species$Species, 'Lithophyllon undulatum','Lithophyllon')
nb_colonies_species$Species <- str_replace_all(nb_colonies_species$Species, 'Montipora sp','Montipora')
nb_colonies_species$Species <- str_replace_all(nb_colonies_species$Species, 'Oulastrea crispata','Oulastrea')
nb_colonies_species$Species <- str_replace_all(nb_colonies_species$Species, 'Pavona decussata','Pavona')
nb_colonies_species$Species <- str_replace_all(nb_colonies_species$Species, 'Platygyra carnosus / acuta','Platygyra')
nb_colonies_species$Species <- str_replace_all(nb_colonies_species$Species, 'Porites lutea / sp.','Porites')
nb_colonies_species$Species <- str_replace_all(nb_colonies_species$Species, 'Psammocora superficialis','Psammocora')
nb_colonies_species$Species <- str_replace_all(nb_colonies_species$Species, 'Styloconiella guentheri','Styloconiella')
nb_colonies_species$Species <- str_replace_all(nb_colonies_species$Species, 'Turbinaria peltata','Turbinaria')



# Aggregate with sum Bleaching.Time and Transect 
nb_colonies_species_sum <- aggregate (nb_colonies_species ~Site + Depth + Species, nb_colonies_species, sum)

# Remove the taxa where there are 0 observations
nb_colonies_species_sum <- subset(nb_colonies_species_sum, nb_colonies_species != 0)




Fig_S4 <- ggplot(nb_colonies_species_sum, aes(x = Site, y = nb_colonies_species, fill = Species)) +
  geom_bar(stat = "identity", position = "dodge", width = 0.8) +  # Adjust bar width for better separation
  facet_wrap(~ Depth, ncol = 1, strip.position = "right", scales = "free_x") +       # Vertical facets
  scale_y_continuous(position = "left") +
  scale_x_discrete(position = "bottom", expand = expansion(0)) +                            # Move x-axis to top
  labs(x = "", y = "Number of colonies (n)") +
  theme_classic() +
  theme(# Legend adjustments
    legend.position = "bottom",legend.title = element_blank(),
    legend.key.size = unit(0.5, "lines"),
    legend.text = element_text(size = 8),
    legend.spacing.y = unit(0.1, "cm"),
    legend.margin = margin(0, 0, 0, 0),
    # Facet adjustments
    strip.background = element_rect(fill = "white", color = "black"),
    strip.text = element_text(color = "black", margin = margin(0, 5, 0, 5)),  # Add margin to strip text
    strip.placement = "outside",
    # Axis/plot adjustments
    axis.text.x.top = element_text(angle = 0),         
    panel.spacing = unit(1, "lines"),                              
    plot.margin = margin(10, 10, 10, 10))                          
Fig_S4

ggsave("Data/Figure_Outputs/Supplementary/Fig_S4.pdf", Fig_S4)

aggregate (nb_diversity ~  Site, nb_diversity, max)
aggregate (nb_colonies ~  Site, nb_colonies, max)
# Total number of colonies
aggregate (nb_colonies_species ~  Site, nb_colonies_species_sum, sum)
nb_diversity_site 




# Interpretation: 
# 1. The effect of Transects is minimal! You can pool them together in the future. 
# 2. TPC has the highest diversity
# 3. We can see that TPC has the highest amount of coral colonies! This site is a good start for preliminary tests. See stats later
# at 1 m in TPC, there were a lot of really small colonies from Dipsastreas or so. 
# 4. You don't necessarily see the bleaching effect: during/after  in the number of coral colonies or diversity! 

# We need to consider the number of pigmented coral colonies or the proportions / or viceversa the number of bleached + Partial bleached colonies

# Generate a new database if the Number.Observations for Site + Bleaching.Time + Depth + Transect is 0 
# Display all combinations where nb_diversity is equal to 0
nb_diversity_zero <- nb_diversity[nb_diversity$nb_diversity == 0, ]
# nb_colonies_zero <- nb_colonies[nb_colonies$nb_colonies == 0, ]

# This is just to display the Sites which are not yet analysed but necessary to do so! 

# Filter out these combinations of not yet analysed data from the original dataframe
data_analysed <- data_survey %>%
  anti_join(nb_diversity_zero, by = c("Site", "Bleaching.Time", "Depth", "Transect"))
# It should create the same dataframe as data_survey, because now it is all analysed


# Clear the Global Environment space
rm (nb_colonies, nb_diversity, nb_colonies_species,  nb_diversity_zero) # nb_colonies_zero,

# Let's carry on with data_analysed


# There are 3 transects per site - we need to confirm that there is not a transect effect
summary (as.factor (data_analysed$Transect))
# Anova or a multivariate test of transect effect per site and depth
hist (data_analysed$Number.Observations) # Poisson distribution or even a zero inflated Poisson distribution

test_transect_1 <- aov(Number.Observations ~ Transect , data = data_analysed) # THIS TEST SEEMS UNNECESSARY
summary (test_transect_1)
# print(shapiro.test(residuals(test_transect_1))) # Needs to be fixed. Shapiro sample size must be between 3 and 5000
# Necessary to consider a subset
set.seed(123)
sample_resids <- sample(residuals(test_transect_1), 5000)
shapiro.test(sample_resids)

test_transect_2 <- aov(Number.Observations ~ Transect+Site, data = data_analysed)
summary (test_transect_2)
# print(shapiro.test(residuals(test_transect_2)))

# Transect does not have a significant effect. They go as replicates then!
# There are a lot of 0s and this is why normality is violated.



# Make an NMDS to check the dissimilarity across Sites-Depths

# First, necessary to run the species name changes
# In the nb_colonies_species
unique (data_survey$Species)
# Also in the nb_colonies_species
data_survey$Species <- str_replace_all(data_survey$Species, 'Favites chinensis  / Gonia aspera', 'Favites / Goniastrea sp.') # Loss a bit of taxonomy!
data_survey$Species <- str_replace_all(data_survey$Species, 'Favites pentagona', 'Favites / Goniastrea sp.')
data_survey$Species <- str_replace_all(data_survey$Species, 'Favites abdita or sp.', 'Favites / Goniastrea sp.')
data_survey$Species <- str_replace_all(data_survey$Species, 'Porites lutea', 'Porites lutea / sp.') 
data_survey$Species <- str_replace_all(data_survey$Species, 'Porites aranetai / deformis', 'Porites lutea / sp.') 

# Genus level transformation
unique (data_survey$Species)
data_survey$Species <- str_replace_all(data_survey$Species, 'Acanthastrea hempirichii','Acanthastrea')
# data_survey$Species <- str_replace_all(data_survey$Species, 'Acropora','Acropora')
data_survey$Species <- str_replace_all(data_survey$Species, 'Cyphastrea serailia / japonica','Cyphastrea')
data_survey$Species <- str_replace_all(data_survey$Species, 'Dipsastraea rotumana / speciosa','Dipsastraea')
data_survey$Species <- str_replace_all(data_survey$Species, 'Echinophillia aspera','Echinophillia')
data_survey$Species <- str_replace_all(data_survey$Species, 'Favites / Goniastrea sp.','Favites / Goniastrea')
data_survey$Species <- str_replace_all(data_survey$Species, 'Galaxea fascicularis / astreata','Galaxea')
data_survey$Species <- str_replace_all(data_survey$Species, 'Goniopora columna or sp.','Goniopora')
data_survey$Species <- str_replace_all(data_survey$Species, 'Hydnophora exesa','Hydnophora')
data_survey$Species <- str_replace_all(data_survey$Species, 'Leptastrea purpurea / pruinosa / sp.','Leptastrea')
data_survey$Species <- str_replace_all(data_survey$Species, 'Lithophyllon undulatum','Lithophyllon')
data_survey$Species <- str_replace_all(data_survey$Species, 'Montipora peltiformis','Montipora')
data_survey$Species <- str_replace_all(data_survey$Species, 'Oulastrea crispata','Oulastrea')
data_survey$Species <- str_replace_all(data_survey$Species, 'Pavona decussata','Pavona')
data_survey$Species <- str_replace_all(data_survey$Species, 'Platygyra carnosus / acuta','Platygyra')
data_survey$Species <- str_replace_all(data_survey$Species, 'Porites lutea / sp.','Porites')
data_survey$Species <- str_replace_all(data_survey$Species, 'Psammocora superficialis','Psammocora')
data_survey$Species <- str_replace_all(data_survey$Species, 'Styloconiella guentheri','Styloconiella')
data_survey$Species <- str_replace_all(data_survey$Species, 'Turbinaria peltata','Turbinaria')


# Aggregate with sum Bleaching.Time and Transect 
data_survey <- aggregate (Number.Observations ~ Site + Depth + Species, data_survey, sum)

# Second need: Delete all rows if Number.Obervations for Species are all 0
# In other words, filter non-appearing Species 
data_survey <- data_survey %>%
  group_by(Species) %>%
  filter(!all(Number.Observations == 0)) %>%
  ungroup()


# Different than for the Bayesian, we decided to also keep the Species when Number.Observations are below than 5. 
# Less than 5 Observations total, the species are kept

# Prepare the data
melt_data = melt(data_survey, id=c("Site", "Depth","Species"), measure.vars="Number.Observations", na.rm=T)
cast_data = dcast(melt_data, Site + Depth  ~ Species, fun.aggregate = sum, add.missing = F)


# Site as factors to choose the order
cast_data$Site <- factor(cast_data$Site, levels = c("Bluff Island",   "Sharp Island",   "Tung Ping Chau"))

# Generation of new database for adonis stats
cast_database <- cast_data
# Preparing unique rownames for format matrix
cast_data$ID<- with(cast_data, paste0(Site, sep = "_",Depth))
rownames (cast_data) <- cast_data$ID

# Delete the unidentified because it us unnecessary
# cast_data <- subset (cast_data, select = - c(Unidentified))
# Otherwise the size matrix changes

# Delete unnecessary columns
cast_data <- cast_data %>% 
  select_if(is.numeric) %>% 
  select_if(~ sum(.x) > 0)


# As I am working with Abundance, colony counts
# Compute distances - Bray-curtis
library (vegan)
dis <- vegdist (cast_data)
total_NMDS <- metaMDS(cast_data, k=2, trymax = 1000, distance = "bray")     # With two dimensions we are already below 0.2  

# Prepare for ggplot 
CC_NMDS_Species <- total_NMDS[['species']]
CC_NMDS_Species <- as.data.frame(CC_NMDS_Species)
CC_NMDS_Species$Species <- rownames (CC_NMDS_Species)

CC_NMDS_coordinates <- total_NMDS[['points']]
CC_NMDS_coordinates <- as.data.frame(CC_NMDS_coordinates)
CC_NMDS_coordinates$ID <- rownames (CC_NMDS_coordinates)
# Extract Sites
CC_NMDS_coordinates$Site <- sub("\\_.*", "", CC_NMDS_coordinates$ID)
# Extract Depths
CC_NMDS_coordinates$Depth <- sub("^[^_]*_", "", CC_NMDS_coordinates$ID)
# Remove ID column 
CC_NMDS_coordinates <- subset(CC_NMDS_coordinates, select=-c(ID))


#### Necessary theme for NMDS ####
theme_blank = function(base_size = 12, base_family = "") { 
  theme_grey(base_size = base_size, base_family = base_family) %+replace%
    
    theme(
      # Specify axis options
      axis.line = element_blank(), 
      axis.text.x = element_text(size = base_size*0.7, color = "black", lineheight = 0.9),  
      axis.text.y = element_text(size = base_size*0.7, color = "black", lineheight = 0.9),  
      axis.ticks = NULL,  
      axis.title.x = element_text(size = base_size*0.9, color = "black", margin = margin(0, 10, 0, 0)),  
      axis.title.y = element_text(size = base_size*0.9, color = "black", angle = 90, margin = margin(0, 10, 0, 0)),  
      axis.ticks.length = unit(0.3, "lines"),   
      # Specify legend options
      legend.key.height = NULL,  
      legend.key.width = NULL,      
      legend.text = element_text(size = base_size*0.8, color = "black"),  
      legend.title = element_text(size = base_size*0.8, face = "bold", hjust = 0, color = "black"),  
      legend.text.align = NULL,  
      legend.title.align = NULL,  
      legend.direction = "vertical",  
      legend.box = NULL, 
      # Specify panel options
      panel.background = element_rect(fill = "white", color  =  NA),  
      panel.border = element_rect(fill = NA, color = "black"),  
      panel.grid.major = element_line(color = "white"),  
      panel.grid.minor = element_line(color = "white"),  
      # Specify facetting options
      strip.background = NULL,  
      strip.text.x = element_text(size = base_size*0.7, color = "black"),  
      strip.text.y = element_text(size = base_size*0.7, color = "black",angle = -90),  
      # Specify plot options
      plot.title = element_text(size = base_size*1.2, color = "black"),  
      plot.margin = unit(rep(1, 4), "lines")
      
    )
}
#### Necessary theme for NMDS ####

# Plot NMDS
CC_NMDS_coordinates = CC_NMDS_coordinates %>% mutate(Depth = factor(Depth, levels = c("1_m",   "2_3_m", "4_5_m")))
hull_CC_NMDS <- CC_NMDS_coordinates %>% group_by(Depth) %>% slice(chull(MDS1,MDS2))

# We decided to keep all species that occur at least 1 time
# keep_species <-  c ("Acropora sp.","Cyphastrea serailia / japonica","Dipsastraea rotumana / speciosa","Favites / Goniastrea sp.",            
#                      "Galaxea fascicularis / astreata","Goniopora columna or sp.","Montipora sp",                        
#                       "Pavona decussata","Platygyra carnosus / acuta","Porites lutea / sp.","Psammocora superficialis","Turbinaria peltata","Unidentified")
# CC_NMDS_Species <- CC_NMDS_Species[CC_NMDS_Species$Species %in% keep_species, ]

CC_NMDS_coordinates %>% ggplot() + theme_blank() + 
  geom_polygon(data = hull_CC_NMDS, aes(x = MDS1, y = MDS2, fill = Site), alpha = 0.75, color = "black", show.legend = T) +
  geom_label(aes(x = MDS1, y = MDS2, label = Depth, fill = Site), show.legend = FALSE, alpha = 0.75, size = 3) +
  #geom_text(data = CC_NMDS_Species, aes(x = MDS1, y = MDS2, label = Species), size = 2) +
  geom_label(data = CC_NMDS_Species, aes(x = MDS1, y = MDS2, label = Species), size = 2, alpha = .75) +
  scale_x_continuous(name ="NMDS 1") + scale_y_continuous(name ="NMDS 2") + ggtitle("Bray-Curtis - Colony counts") +
  theme(axis.text = element_text(size=10), axis.title = element_text(size=11, face="bold")) +
  annotate(geom = 'text', label = round(total_NMDS$stress,3), 
           x = range(CC_NMDS_coordinates$MDS1)[1], y = range(CC_NMDS_Species$MDS2)[1], hjust = 0, vjust = 6)


# With species vectors overlaid
# Calculate scaling factor for species vectors (adjust as needed)
scaling_factor <- 0.7

Fig_S3 <- CC_NMDS_coordinates %>% ggplot() + theme_blank() +
  geom_polygon(data = hull_CC_NMDS, 
               aes(x = MDS1, y = MDS2, fill = Site), 
               alpha = 0.75, color = "black", show.legend = TRUE) +
  geom_segment(data = CC_NMDS_Species,
               aes(x = 0, y = 0, xend = MDS1*scaling_factor, yend = MDS2*scaling_factor),
               arrow = arrow(length = unit(0.2, "cm")),
               color = "gray40", alpha = 0.6) +
  geom_label_repel(data = CC_NMDS_Species,
                   aes(x = MDS1*scaling_factor, y = MDS2*scaling_factor, label = Species),
                   size = 2.5, alpha = 0.85, 
                   box.padding = 0.5, min.segment.length = 0.2) +
  geom_label_repel(aes(x = MDS1, y = MDS2, label = Depth, fill = Site), 
                   show.legend = FALSE, alpha = 0.75, size = 3) +
  scale_color_manual(values = c("Green", "Orange", "Red")) +
  scale_fill_manual(values = c("Green", "Orange", "Red")) +
  scale_x_continuous(name = "NMDS 1") + scale_y_continuous(name = "NMDS 2") + 
  ggtitle("Bray-Curtis Dissimilarity") +
  theme(legend.position = "bottom",legend.direction = "horizontal",
    axis.text = element_text(size = 10),
    axis.title = element_text(size = 11, face = "bold"),
    panel.grid.major = element_line(color = "gray90", linewidth = 0.2),
    panel.background = element_rect(fill = "white")) +
    annotate(geom = 'text', label = paste("Stress =", round(total_NMDS$stress, 3)), x = -0.8, y = -0.35, hjust = 0, vjust = 0)
Fig_S3

ggsave("Data/Figure_Outputs/Supplementary/Fig_S3.pdf", Fig_S3,width = 8, height = 6)
# width = 8.5, height = 6

# Permanova adonis
vegan::adonis2(dis ~ Site + Depth, data = cast_database, permutations = 999)
# There is a Site effect



# Check the number of bleached colonies per sites 

# Filter the data for bleached status: either "Bleached","Partial bleached"           
data_bleached <- subset(data_analysed, Status == "Bleached" | Status == "Partial bleached")
# Summarize the number of colonies
nb_colonies_bleached <- ddply(data_bleached, ~ Site + Bleaching.Time + Depth + Transect, function(x) {
  c(nb_colonies_bleached = sum(x$Number.Observations))
})
# View the result
print(nb_colonies_bleached)
# To have the right order:
nb_colonies_bleached$Bleaching.Time <- factor(nb_colonies_bleached$Bleaching.Time, levels = c("During","After")) 

# plot the result
# We are missing the sites that are not yet analysed
ggplot(nb_colonies_bleached, aes(x = Bleaching.Time, y = nb_colonies_bleached, fill = Transect)) +
  geom_bar(stat = "identity",position = "dodge") +
  facet_wrap(~ Site +  Depth, ncol = 3) +
  scale_y_continuous(breaks = scales::pretty_breaks())+
  labs(title = "Bleached colonies count",
       x = "Depths",
       y = "Number of colonies") +
  theme_minimal() +
  theme(legend.position="bottom") 
# We can see the decrease in the number of bleached colonies


# Test the effects of Transects and Sizes to discard for future modelling consideration


# First transform names from "Partial bleached" to "Bleached"

data_analysed_2 <- data_analysed

data_analysed_2$Status <- str_replace_all(data_analysed_2$Status, 'Partial bleached', 'Bleached')
data_analysed_2$Status <- str_replace_all(data_analysed_2$Status, 'Bleached', 'Bleached or partially bleached')
data_analysed_2$Status <- str_replace_all(data_analysed_2$Status, 'Dead', 'Dead')


# Test the effect of transects

test_transect1 <- aov(nb_colonies_bleached ~ Transect , data = nb_colonies_bleached)
summary (test_transect1) # No significant effect although...
print(shapiro.test(residuals(test_transect1))) # Normality rejected

test_transect2 <- aov(nb_colonies_bleached ~ Transect +Site+Bleaching.Time+Depth, data = nb_colonies_bleached)
summary (test_transect2)
print(shapiro.test(residuals(test_transect2)))

# WE CONFIRM THAT when considering Site, bleaching, Time and Depth, TRANSECT DOES NOT HAVE A SIGNIFICANT EFFECT ON THE NUMBER OF COLONIES, OR THE NUMBER OF COLONIES BLEACHED. 
# we can use the 3 transects as replicates!

# Extra test for Transect to be consistent with Size
resume_transect_status <- aggregate (Number.Observations ~ Bleaching.Time + Transect + Status, data_analysed_2, sum)

test_transect3 <- aov(Number.Observations ~ Transect:Status, data = resume_transect_status)
summary (test_transect3)
print(shapiro.test(residuals(test_transect3)))

# BOTH Tests confirm the no effect of Transect in bleaching statuses


### Test the effect of Size

# Plot and test the effect of size 

resume_size_status <- aggregate (Number.Observations ~ Bleaching.Time + Size + Status, data_analysed_2, sum)

# Statistical test
size_model1 <- aov(Number.Observations ~ Size , data = resume_size_status)
summary (size_model1)
print(shapiro.test(residuals(size_model1))) # Normality is rejected by very little
# Size did have any effect on the Number.Observations but normality is rejected. 
# Of course there are more smaller than larger colonies (irrelevant)
# Run non-parametric test
kruskal.test(Number.Observations ~ Size, data = resume_size_status)



size_model2 <- aov(Number.Observations ~ Size : Status, data = resume_size_status)
summary (size_model2)
print(shapiro.test(residuals(size_model2))) # Normality is not rejected
# Size did not have any effect interacting with Status on the Number.Observations


###################
# Generate proportional data with standard errors

total <- aggregate (Number.Observations ~ Bleaching.Time + Size, data_analysed_2, sum)

resume_size_status <- merge (resume_size_status, total, by = c("Bleaching.Time","Size"))
colnames (resume_size_status)<- c("Bleaching.Time","Size","Status","Number.Observations","Total")

resume_size_status$Proportion <- (resume_size_status$Number.Observations / resume_size_status$Total) 


# standard error/deviation of a sample proportion 1.96 to use 95% CI
resume_size_status$Standard_Error <- (1.96) * sqrt ( resume_size_status$Proportion * (1 - resume_size_status$Proportion ) / resume_size_status$Total)

# In percentages
resume_size_status$Proportion <- resume_size_status$Proportion*100
resume_size_status$Standard_Error <- resume_size_status$Standard_Error*100


# Plot the size effect
resume_size_status$Status = factor(resume_size_status$Status,levels = c ("Pigmented",  "Bleached or partially bleached","Dead"))
colours <- c("coral4","white", "black")

resume_size_status$Bleaching.Time = factor(resume_size_status$Bleaching.Time,levels = c ("During","After"))
resume_size_status$Size = factor(resume_size_status$Size,levels = c ("Small","Medium","Large"))


ggplot(resume_size_status, aes(x = factor(Status), y = Proportion, fill = Status)) +
  geom_bar(stat = "identity", colour = "black") + 
  geom_errorbar(aes(ymin=Proportion-Standard_Error, ymax=Proportion+Standard_Error), width = 0.2, color = "black") + 
  facet_grid(Size ~ Bleaching.Time, switch = "y") +  scale_y_continuous(position = "right",breaks = c(0,25,50,75,100)) +
  ylab ("Percentatge (%)") + xlab ("") + scale_fill_manual(values = colours) + ggtitle("Size effects on status")+
  theme_classic() +
  theme(legend.position="bottom", axis.text.x=element_blank()) 
# Size does not seem to be having an effect, on Number.Observations or Status!





# Check the number of pigmented colonies in the same way you checked the number of bleached colonies above
# although much better to work with percentage/proportion values
# Filter the data for "Pigmented)         
data_pigmented <- subset(data_analysed, Status == "Pigmented")
# Summarize the number of colonies
nb_colonies_pigmented <- ddply(data_pigmented, ~ Site + Bleaching.Time + Depth + Transect, function(x) {
  c(nb_colonies_pigmented = sum(x$Number.Observations))
})
# View the result
print(nb_colonies_pigmented)
# To have the right order:
nb_colonies_pigmented$Bleaching.Time <- factor(nb_colonies_pigmented$Bleaching.Time, levels = c("During","After")) 

# plot the result
# We are missing the sites that are not yet analysed
ggplot(nb_colonies_pigmented, aes(x = Bleaching.Time, y = nb_colonies_pigmented, fill = Transect)) +
  geom_bar(stat = "identity",position = "dodge") +
  facet_wrap(~ Site +  Depth, ncol = 3) +
  scale_y_continuous(breaks = scales::pretty_breaks())+
  labs(title = "Pigmented colonies count",
       x = "Depths",
       y = "Number of colonies") +
  theme_minimal() +
  theme(legend.position="bottom") 

# We confirm that we need to work with percentages; the transects are not stationary! 


#### Visualise TPC individually #####
# One extra graph to visualize individually: some plot visualisations per status for TPC

TPC <- data_analysed [data_analysed$Site == "Tung Ping Chau",]
# Necessary to ignore the Number.Observations = 0s of non-present corals
TPC <- TPC [TPC$Number.Observations > 0,]

# Make the plot
TPC$Status <- factor(TPC$Status, levels = c("Pigmented","Partial bleached","Bleached","Dead" )) 

TPC$Bleaching.Time <- factor(TPC$Bleaching.Time, levels = c("During","After")) 

ggplot(TPC, aes(x = Status, y = Number.Observations)) +
  geom_boxplot() +
  facet_wrap(Depth ~ Site + Bleaching.Time, ncol = 2) +
  labs(title = "Boxplot of Number of Observations by Status for TPC",
       x = "Status",
       y = "Number of Observations") +
  theme_minimal()
# again, visualisation is not so great... Too many 0 observations.
#### Visualise TPC individually #####

# We need to display the results with proportions
# To deal with the 0 Observation, we will use a Zero-Inflated Poisson distribution



# Let's clear the Global.Environment 
rm (data_bleached, data_pigmented, nb_colonies_bleached, nb_colonies_pigmented, TPC)



######################################################

# WORKING with PROPORTIONS 

# Per Site, Bleaching.Time, (Depth) only (you could also consider Species, Size)

resume_site_status <- data.frame()
for(i in unique(data_analysed$Site)){
  new0 <-subset (data_analysed, Site == i)
  for(j in unique(new0$Bleaching.Time)){
    new <-subset (new0, Bleaching.Time == j)
    for (k in unique (new$Status)){
      new2 <- subset (new, Status == k)
      new3 <- aggregate(Number.Observations ~ Site + Bleaching.Time + Status, new2, sum)
      resume_site_status = rbind (resume_site_status, new3)
    }
  }
}

total <- aggregate (Number.Observations ~ Site + Bleaching.Time, resume_site_status, sum)

resume_site_status <- merge (resume_site_status, total, by = c("Site","Bleaching.Time"))
colnames (resume_site_status)<- c("Site","Bleaching.Time","Status","Number.Observations","Total")

resume_site_status$Proportion <- (resume_site_status$Number.Observations / resume_site_status$Total) 

# standard error/deviation of a sample proportion 1.96 to use 95% CI
resume_site_status$Standard_Error <- (1.96) * sqrt ( resume_site_status$Proportion * (1 - resume_site_status$Proportion ) / resume_site_status$Total)
# In percentages
resume_site_status$Proportion <- resume_site_status$Proportion*100
resume_site_status$Standard_Error <- resume_site_status$Standard_Error*100


# # Plot the proportions instead of the number of observations

resume_site_status$Status = factor(resume_site_status$Status,levels = c ("Pigmented",  "Partial bleached","Bleached","Dead"))
colours <- c( "forestgreen","orange","red", "black")

resume_site_status$Site = factor(resume_site_status$Site,levels = c ("Bluff Island","Sharp Island", "Tung Ping Chau"))
resume_site_status$Bleaching.Time = factor(resume_site_status$Bleaching.Time,levels = c ("During","After"))


ggplot(resume_site_status, aes(x = factor(Status), y = Proportion, fill = Status)) +
  geom_bar(stat = "identity", colour = "black") + 
  geom_errorbar(aes(ymin=Proportion-Standard_Error, ymax=Proportion+Standard_Error), width = 0.2, color = "black") + 
  facet_grid(Site ~ Bleaching.Time, switch = "y") +  scale_y_continuous(position = "right",breaks = c(0,25,50,75,100)) +
  ylab ("Percentatge (%)") + xlab ("Status") + scale_fill_manual(values = colours) + ggtitle("During-After bleaching (all depths)")+
  theme_classic() +
  theme(legend.position="bottom") 

# Clean the Global Environment before going on
rm (new0, new,new2,new3, total)

# DEPTHS
# Here, you could include the different per depths
# Per Site, Bleaching.Time, Depth (you could also consider Species, Size)

resume_site_depth_status <- data.frame()
for(i in unique(data_analysed$Site)){
  new0 <-subset (data_analysed, Site == i)
  for(j in unique(new0$Bleaching.Time)){
    new <-subset (new0, Bleaching.Time == j)
    for (k in unique (new$Status)){
      new2 <- subset (new, Status == k)
      for (l in unique (new2$Depth)){
        new3 <- subset (new2, Depth == l)
        new4 <- aggregate(Number.Observations ~ Site + Bleaching.Time + Depth + Status, new3, sum)
        resume_site_depth_status = rbind (resume_site_depth_status, new4)
      }    
    }
  }
}

total <- aggregate (Number.Observations ~ Site + Bleaching.Time + Depth, resume_site_depth_status, sum)

resume_site_depth_status <- merge (resume_site_depth_status, total, by = c("Site","Bleaching.Time", "Depth"))
colnames (resume_site_depth_status)<- c("Site","Bleaching.Time","Depth","Status","Number.Observations","Total")

resume_site_depth_status$Proportion <- (resume_site_depth_status$Number.Observations / resume_site_depth_status$Total) 

# standard error/deviation of a sample proportion 1.96 to use 95% CI
resume_site_depth_status$Standard_Error <- (1.96) * sqrt ( resume_site_depth_status$Proportion * (1 - resume_site_depth_status$Proportion ) / resume_site_depth_status$Total)
# In percentages
resume_site_depth_status$Proportion <- resume_site_depth_status$Proportion*100
resume_site_depth_status$Standard_Error <- resume_site_depth_status$Standard_Error*100


# # Plot the proportions instead of the number of observations

resume_site_depth_status$Status = factor(resume_site_depth_status$Status,levels = c ("Pigmented",  "Partial bleached","Bleached","Dead"))
colours <- c( "forestgreen","orange","red", "black")

resume_site_depth_status$Site = factor(resume_site_depth_status$Site,levels = c ("Bluff Island","Sharp Island", "Tung Ping Chau"))
resume_site_depth_status$Bleaching.Time = factor(resume_site_depth_status$Bleaching.Time,levels = c ("During","After"))
resume_site_depth_status$Depth = factor(resume_site_depth_status$Depth,levels = c ("1_m","2_3_m","4_5_m"))

### THIS ONE IS THE USED FIGURE
ggplot(resume_site_depth_status, aes(x = Bleaching.Time, y = Proportion, fill = Status)) +
  geom_bar(stat = "identity",position = "dodge", colour = "black") + 
  geom_errorbar(aes(ymin=Proportion-Standard_Error, ymax=Proportion+Standard_Error), position = position_dodge(width = 0.9), width = 0.2, color = "black") + 
  facet_grid(Site ~ Depth, switch = "y") +  scale_y_continuous(position = "right",breaks = c(0,25,50,75,100)) +
  ylab ("Percentatge (%)") + xlab ("Status") + scale_fill_manual(values = colours) + ggtitle("During-After bleaching all Site & Depth")+
  theme_classic() +
  theme(legend.position="bottom") 


#### VERY IMPORTANT INFORMATION HERE ####
# Let's add an extra graph here CONSIDERING PARTIAL BLEACHED AND BLEACHED together, 
# They were very confusing to differentiate (Please see manuscript and response to reviewers to extra explanations)
# Keep in mind that Dead means "Partial or total mortality" with over 50% of the colony dead. 


# First transform names from "Partial bleached" to "Bleached"

data_analysed_2 <- data_analysed

data_analysed_2$Status <- str_replace_all(data_analysed_2$Status, 'Partial bleached', 'Bleached')
data_analysed_2$Status <- str_replace_all(data_analysed_2$Status, 'Bleached', 'Bleached or partially bleached')
data_analysed_2$Status <- str_replace_all(data_analysed_2$Status, 'Dead', 'Dead')


# Per Site, Bleaching.Time, Depth (you could also consider Species, Size)

resume_site_depth_status_2 <- data.frame()
for(i in unique(data_analysed_2$Site)){
  new0 <-subset (data_analysed_2, Site == i)
  for(j in unique(new0$Bleaching.Time)){
    new <-subset (new0, Bleaching.Time == j)
    for (k in unique (new$Status)){
      new2 <- subset (new, Status == k)
      for (l in unique (new2$Depth)){
        new3 <- subset (new2, Depth == l)
        new4 <- aggregate(Number.Observations ~ Site + Bleaching.Time + Depth + Status, new3, sum)
        resume_site_depth_status_2 = rbind (resume_site_depth_status_2, new4)
      }    
    }
  }
}

total <- aggregate (Number.Observations ~ Site + Bleaching.Time + Depth, resume_site_depth_status_2, sum)

resume_site_depth_status_2 <- merge (resume_site_depth_status_2, total, by = c("Site","Bleaching.Time", "Depth"))
colnames (resume_site_depth_status_2)<- c("Site","Bleaching.Time","Depth","Status","Number.Observations","Total")

resume_site_depth_status_2$Proportion <- (resume_site_depth_status_2$Number.Observations / resume_site_depth_status_2$Total) 

# standard error/deviation of a sample proportion 1.96 to use 95% CI
resume_site_depth_status_2$Standard_Error <- (1.96) * sqrt ( resume_site_depth_status_2$Proportion * (1 - resume_site_depth_status_2$Proportion ) / resume_site_depth_status_2$Total)
# In percentages
resume_site_depth_status_2$Proportion <- resume_site_depth_status_2$Proportion*100
resume_site_depth_status_2$Standard_Error <- resume_site_depth_status_2$Standard_Error*100


# # Plot the proportions instead of the number of observations

resume_site_depth_status_2$Status = factor(resume_site_depth_status_2$Status,levels = c ("Pigmented",  "Bleached or partially bleached","Dead"))
colours <- c( "coral4","white", "black")

resume_site_depth_status_2$Site = factor(resume_site_depth_status_2$Site,levels = c ("Bluff Island","Sharp Island", "Tung Ping Chau"))
resume_site_depth_status_2$Bleaching.Time = factor(resume_site_depth_status_2$Bleaching.Time,levels = c ("During","After"))
resume_site_depth_status_2$Depth <- str_replace_all(resume_site_depth_status_2$Depth, '1_m', '~ 1 m')
resume_site_depth_status_2$Depth <- str_replace_all(resume_site_depth_status_2$Depth, '2_3_m', '~ 2-3 m')
resume_site_depth_status_2$Depth <- str_replace_all(resume_site_depth_status_2$Depth, '4_5_m', '~ 4-5 m')
resume_site_depth_status_2$Depth = factor(resume_site_depth_status_2$Depth,levels = c ("~ 1 m","~ 2-3 m","~ 4-5 m"))


### Fig. 4 ###

fig_4 <- ggplot(resume_site_depth_status_2, aes(x = Bleaching.Time, y = Proportion, fill = Status)) +
  geom_bar(stat = "identity",position = "dodge", colour = "black") + 
  geom_errorbar(aes(ymin=Proportion-Standard_Error, ymax=Proportion+Standard_Error), position = position_dodge(width = 0.9), width = 0.2, color = "black") + 
  facet_grid(Depth ~ Site) +  scale_y_continuous(position = "left",breaks = c(0,25,50,75,100)) +
  ylab ("Percentatge (%)") + xlab ("") + scale_fill_manual(values = colours) + ggtitle("")+
  theme_classic() +
  theme(legend.position="bottom") 
fig_4

ggsave("Data/Figure_Outputs/fig_4.pdf", fig_4, width = 8.5, height = 6)
# width = 6, height = 6

# Some average values for MS and statistical tests During-After
aggregate (Proportion ~  Bleaching.Time + Status, resume_site_depth_status_2, mean)
aggregate (Proportion ~  Depth + Bleaching.Time + Status, resume_site_depth_status_2, mean)
aggregate (Proportion ~  Site + Depth + Bleaching.Time + Status, resume_site_depth_status_2, mean)
aggregate (Proportion ~  Depth + Bleaching.Time + Status, resume_site_depth_status_2, mean)
aggregate (Proportion ~  Site + Depth + Bleaching.Time + Status, resume_site_depth_status_2, mean)

resume_site_depth_status_2$Proportion_stats <- resume_site_depth_status_2$Proportion/100


# Statistical tests on proportions!
Proportions_model1 <- aov(Proportion_stats ~ Status : Bleaching.Time, data = resume_site_depth_status_2)
summary (Proportions_model1)
print(shapiro.test(residuals(Proportions_model1))) # Normality is rejected by little
qqnorm(residuals(Proportions_model1))
qqline(residuals(Proportions_model1), col = "red")
library(WRS2)
t2way(Proportion_stats ~ Status * Bleaching.Time, data = resume_site_depth_status_2)
# Status*Bleaching time interaction is highly significant and this is the most important

Proportions_model2 <- aov(Proportion_stats ~ Status : Bleaching.Time : Depth, data = resume_site_depth_status_2)
summary (Proportions_model2)
print(shapiro.test(residuals(Proportions_model2))) # Normality is accepted

# Less interesting!
Proportions_model3 <- aov(Proportion_stats ~ Status : Depth, data = resume_site_depth_status_2)
summary (Proportions_model3)
print(shapiro.test(residuals(Proportions_model3))) # Normality is accepted!

Proportions_model4 <- aov(Proportion_stats ~ Status : Site, data = resume_site_depth_status_2)
summary (Proportions_model4)
print(shapiro.test(residuals(Proportions_model4))) # Normality is rejected by little
qqnorm(residuals(Proportions_model1))
qqline(residuals(Proportions_model1), col = "red")

### Test of recovery (NUMBER OF COLONIES)
# Compare the before-after with number of colonies Pigmented
data_recovery <- subset(data_analysed_2, Status == "Pigmented") 


recovery_model <- aov(Number.Observations ~ Bleaching.Time + Depth, data = data_recovery)
summary (recovery_model)
print(shapiro.test(residuals(recovery_model))) # Normality is rejected!
# NEED TO FIND AN ALTERNATIVE
# Post-hoc test to see pairwise comparisons
TukeyHSD(recovery_model)

# Test of recovery with PROPORTIONS:


data_recovery <- subset(resume_site_depth_status_2, Status == "Pigmented") 

####### This is unnecessary! #######
data_recovery$prop_logit <- log(data_recovery$Proportion_stats/(1-data_recovery$Proportion_stats))
aov_trans <- aov(prop_logit ~ Bleaching.Time + Depth, data = data_recovery)
summary (aov_trans)

recovery_model <- aov(Proportion_stats ~ Bleaching.Time + Depth, data = data_recovery)
summary (recovery_model)
print(shapiro.test(residuals(recovery_model)))
qqnorm(residuals(recovery_model))
qqline(residuals(recovery_model), col = "red")
####### This is unnecessary! #######

# To work with proportions and deal with the lack of normality, the best is to work with beta regression models
# They also provide a cross-over comparisson
library (betareg)
beta_model_recovery <- betareg(Proportion_stats ~ Bleaching.Time + Depth + Site, data = data_recovery)
summary(beta_model_recovery)  
# Interpreatation: 
# 1. Bleaching Time highly significant; log-odds of being pigmented increases by 2.18 after bleaching
# 2. Depth have higher pigmented colonies. The comparison of 4-5 m with 1-2 is an estimate of 0.87 significant
#    No significant difference with 2-3 m
# 3. There is less bleaching in Bluff than in Sharp and TPC, - slopes and p-value
# 3. Excellence Fit R2 = 0.718 (72% of data explained)
# 4. Log likelihood 11.83, Good model fit. 



### Test of mortality
# Compare the before-after with number of colonies Dead
data_dead <- subset(resume_site_depth_status_2, Status == "Dead") 

beta_model_recovery <- betareg(Proportion_stats ~ Bleaching.Time + Depth + Site, data = data_dead)
summary(beta_model_recovery)  

##### Unnecessary #######
two_way_dead0 <- aov(Number.Observations ~  Depth, data = data_dead)
summary (two_way_dead0)
print(shapiro.test(residuals(two_way_dead0))) # Normality is rejected!
TukeyHSD(two_way_dead0) # Cannot trust

two_way_dead1 <- aov(Number.Observations ~  Bleaching.Time, data = data_dead)
summary (two_way_dead1)
print(shapiro.test(residuals(two_way_dead1))) # Normality is rejected!
TukeyHSD(two_way_dead1)

two_way_dead2 <- aov(Number.Observations ~ Bleaching.Time + Depth, data = data_dead)
summary (two_way_dead2)

two_way_dead3 <- aov(Number.Observations ~ Site+Depth, data = data_dead)
summary (two_way_dead3)
TukeyHSD(two_way_dead3)

two_way_dead4 <- aov(Number.Observations ~ Site:Depth, data = data_dead)
summary (two_way_dead4)
TukeyHSD(two_way_dead4)

##### Unnecessary #######

# Data dead tests with PROPORTIONS
data_dead <- subset(resume_site_depth_status_2, Status == "Dead") 

beta_model_dead <- betareg(Proportion_stats ~ Bleaching.Time + Depth + Site, data = data_dead)
summary(beta_model_dead)  
# Interpretation: 
# 1. Bleaching Time highly significant; log-odds of being dying increases by 1.556 after bleaching. Higher mortality after bleaching
# 2. Depth not significant
# 3. Site effects both significant. Sharp has more dead corals than Bluff and TPC
# 3. The model correctly accounts for the 0 inflation. 
# 4. High precision phi = 22.3 (p = 0.009) and low variability

beta_model_dead2 <- betareg(Proportion_stats ~ Bleaching.Time + Site*Depth, data = data_dead)
summary(beta_model_dead2)  

# Partial mortality means over 50% of the colony already dead
# Partial bleached means a very big majority of the colony bleached or with a different colouration than normal pigmentation
# Bleached means the colony is white


# Data bleached tests with PROPORTIONS
data_bleached <- subset(resume_site_depth_status_2, Status == "Bleached or partially bleached") 

beta_model_bleached <- betareg(Proportion_stats ~ Bleaching.Time + Depth + Site, data = data_bleached)
summary(beta_model_bleached)  
# Interpreatation: 
# 1. Less bleaching in the TimeAfter; log-odds of bleaching decrease by -3.02 after bleaching. 
# 2. Less bleaching in depth -1.2623 (p 2.92e-05)
# 3. TPC has more bleaching, and even Shap.
# 3. The model correctly accounts for 90% of the data


rm (resume_site_depth_status_2)






######## Extra plots for TPC   ######## 
# New plots, now just for Tung Ping Chau, considering Depths 2_3_m

TPC <- data_analysed [data_analysed$Site == "Tung Ping Chau",]
TPC <- TPC [TPC$Depth == "4_5_m",] # 4_5_m

resume_TPC_status <- aggregate (Number.Observations ~ Bleaching.Time + Status, TPC, sum)
total <- aggregate (Number.Observations ~ Bleaching.Time, TPC, sum)

resume_TPC_status <- merge (resume_TPC_status, total, by = c("Bleaching.Time"))
colnames (resume_TPC_status)<- c("Bleaching.Time","Status","Number.Observations","Total")

resume_TPC_status$Proportion <- (resume_TPC_status$Number.Observations / resume_TPC_status$Total) 

# standard error/deviation of a sample proportion 1.96 to use 95% CI
resume_TPC_status$Standard_Error <- (1.96) * sqrt ( resume_TPC_status$Proportion * (1 - resume_TPC_status$Proportion ) / resume_TPC_status$Total)

# In percentatges
resume_TPC_status$Proportion <- resume_TPC_status$Proportion*100
resume_TPC_status$Standard_Error <- resume_TPC_status$Standard_Error*100


resume_TPC_status$Status = factor(resume_TPC_status$Status,levels = c ("Pigmented",  "Partial bleached","Bleached","Dead"))
colours <- c("forestgreen","orange","red", "black")

resume_TPC_status$Bleaching.Time = factor(resume_TPC_status$Bleaching.Time,levels = c ("During","After"))

ggplot(resume_TPC_status, aes(x = factor(Status), y = Proportion, fill = Status)) +
  geom_bar(stat = "identity", colour = "black") + 
  geom_errorbar(aes(ymin=Proportion-Standard_Error, ymax=Proportion+Standard_Error), width = 0.2, color = "black") + 
  facet_grid(~ Bleaching.Time, switch = "y") +  scale_y_continuous(position = "left",breaks = c(0,25,50,75,100)) +
  ylab ("Percentatge (%)") + xlab ("Status") + scale_fill_manual(values = colours) + ggtitle("TPC During-After bleaching")+
  theme_classic() +
  theme(legend.position="bottom") 


# Plot the effect of depths in TPC bleaching status (or other islands)
TPC_depth <- data_analysed [data_analysed$Site == "Tung Ping Chau",] # "Bluff Island"

resume_TPC_depth_status <- aggregate (Number.Observations ~ Bleaching.Time + Depth + Status, TPC_depth, sum)
total <- aggregate (Number.Observations ~ Bleaching.Time + Depth, TPC_depth, sum)

resume_TPC_depth_status <- merge (resume_TPC_depth_status, total, by = c("Bleaching.Time","Depth"))
colnames (resume_TPC_depth_status)<- c("Bleaching.Time","Depth","Status","Number.Observations","Total")

resume_TPC_depth_status$Proportion <- (resume_TPC_depth_status$Number.Observations / resume_TPC_depth_status$Total) 


# standard error/deviation of a sample proportion 1.96 to use 95% CI
resume_TPC_depth_status$Standard_Error <- (1.96) * sqrt ( resume_TPC_depth_status$Proportion * (1 - resume_TPC_depth_status$Proportion ) / resume_TPC_depth_status$Total)

# In percentatges
resume_TPC_depth_status$Proportion <- resume_TPC_depth_status$Proportion*100
resume_TPC_depth_status$Standard_Error <- resume_TPC_depth_status$Standard_Error*100


resume_TPC_depth_status$Status = factor(resume_TPC_depth_status$Status,levels = c ("Pigmented",  "Partial bleached","Bleached","Dead"))
colours <- c("forestgreen","orange","red", "black")

resume_TPC_depth_status$Bleaching.Time = factor(resume_TPC_depth_status$Bleaching.Time,levels = c ("During","After"))
resume_TPC_depth_status$Depth = factor(resume_TPC_depth_status$Depth,levels = c ("1_m","2_3_m","4_5_m"))


ggplot(resume_TPC_depth_status, aes(x = factor(Status), y = Proportion, fill = Status)) +
  geom_bar(stat = "identity", colour = "black") + 
  geom_errorbar(aes(ymin=Proportion-Standard_Error, ymax=Proportion+Standard_Error), width = 0.2, color = "black") + 
  facet_grid(Depth ~ Bleaching.Time, switch = "y") +  scale_y_continuous(position = "right",breaks = c(0,25,50,75,100)) +
  ylab ("Percentatge (%)") + xlab ("Status") + scale_fill_manual(values = colours) + ggtitle("TPC During-After bleaching (Depth)")+
  theme_classic() +
  theme(legend.position="bottom") 
# Depth seems to be having an effect!!!

######## Extra plots for TPC  ######## 

######## Extra plots with the effect of Size for TPC  ########
# Plot the effect of size in TPC bleaching status
TPC_size <- data_analysed [data_analysed$Site == "Tung Ping Chau",]

resume_TPC_size_status <- aggregate (Number.Observations ~ Bleaching.Time + Size + Status, TPC_size, sum)
total <- aggregate (Number.Observations ~ Bleaching.Time + Size, TPC_size, sum)

resume_TPC_size_status <- merge (resume_TPC_size_status, total, by = c("Bleaching.Time","Size"))
colnames (resume_TPC_size_status)<- c("Bleaching.Time","Size","Status","Number.Observations","Total")

resume_TPC_size_status$Proportion <- (resume_TPC_size_status$Number.Observations / resume_TPC_size_status$Total) 


# standard error/deviation of a sample proportion 1.96 to use 95% CI
resume_TPC_size_status$Standard_Error <- (1.96) * sqrt ( resume_TPC_size_status$Proportion * (1 - resume_TPC_size_status$Proportion ) / resume_TPC_size_status$Total)

# In percentages
resume_TPC_size_status$Proportion <- resume_TPC_size_status$Proportion*100
resume_TPC_size_status$Standard_Error <- resume_TPC_size_status$Standard_Error*100


# Plot the 
resume_TPC_size_status$Status = factor(resume_TPC_size_status$Status,levels = c ("Pigmented",  "Partial bleached","Bleached","Dead"))
colours <- c("forestgreen","orange","red", "black")

resume_TPC_size_status$Bleaching.Time = factor(resume_TPC_size_status$Bleaching.Time,levels = c ("During","After"))
resume_TPC_size_status$Size = factor(resume_TPC_size_status$Size,levels = c ("Small","Medium","Large"))


ggplot(resume_TPC_size_status, aes(x = factor(Status), y = Proportion, fill = Status)) +
  geom_bar(stat = "identity", colour = "black") + 
  geom_errorbar(aes(ymin=Proportion-Standard_Error, ymax=Proportion+Standard_Error), width = 0.2, color = "black") + 
  facet_grid(Size ~ Bleaching.Time, switch = "y") +  scale_y_continuous(position = "right",breaks = c(0,25,50,75,100)) +
  ylab ("Percentatge (%)") + xlab ("Status") + scale_fill_manual(values = colours) + ggtitle("TPC During-After bleaching (Depth)")+
  theme_classic() +
  theme(legend.position="bottom") 
# Size does not seem to be having an effect!
######## Extra plots with the effect of Size for TPC  ########


rm (TPC, TPC_depth, TPC_size, resume_TPC_depth_status, resume_TPC_size_status, resume_TPC_status, total)



##### STATISTICAL TESTS

# For the statistical tests, you need to consider that the big majority are 0s 

# Anovas or manovas are not great!

#### Anova spatial comparisons, study the effect of Site and Depth: ####

# ANOVA to check the effect of Depths and Size in bleaching, first overall for corals!
# I am not sure these are necessary here:
data_bleached <- subset(data_analysed, Status == "Bleached" | Status == "Partial bleached") # Necessary to also consider partial bleached

# One way anova
one_way_1 <- aov(Number.Observations ~ Depth, data = data_bleached)
summary (one_way_1)

# The smallest the Degrees of freedom the best. However, they are considered in te F value!
# Here DF of residuals very high
# F value is high so Depth has an important contribution

one_way_2 <- aov(Number.Observations ~ Size, data = data_bleached)
summary (one_way_2)

# The effect of species will be tested later! Of course it is important!
# one_way_3 <- aov(Number.Observations ~ Species, data = data_bleached)
# summary (one_way_3) # Effect of species

one_way_4 <- aov(Number.Observations ~ Site, data = data_bleached)
summary (one_way_4)

# Two way anova 
two_way <- aov(Number.Observations ~ Depth + Size, data = data_bleached)
summary (two_way)
two_way <- aov(Number.Observations ~ Size + Depth, data = data_bleached)
summary (two_way) # Same output!

# Interaction
int_way1 <- aov(Number.Observations ~ Depth : Size, data = data_bleached)
summary (int_way1)

int_way2 <- aov(Number.Observations ~ Size:Depth, data = data_bleached)
summary (int_way2)


library(AICcmodavg)

model.set <- list(one_way_1, one_way_2, two_way, int_way1, int_way2)
model.names <- c("one_way_1", "one_way_2", "two_way", "int_way1", "int_way2")

aictab(model.set, modnames = model.names) # Lowest AICc is the best!

# Homocedasticity
par(mfrow=c(2,2))
plot(two_way)
par(mfrow=c(1,1))

# Post-hoc test to see pairwise comparisons
TukeyHSD(two_way)


# Plot results
tukey.plot.aov<-aov(Number.Observations ~ Depth, data = data_bleached)
tukey.plot.test<-TukeyHSD(tukey.plot.aov)
par(mfrow=c(1,1))
plot(tukey.plot.test, las = 1)



#### Anova comparisons: ####


#### Zero-Inflated Models  ####

# Zero-Inflated Models to deal with so many 0 observations
hist (data_bleached$Number.Observations)

# Following Copilot: 
library(pscl)
# Assuming your data frame is named 'data'
zip_model <- zeroinfl(Number.Observations ~ Site + Depth + Size | 1, data = data_bleached)
summary(zip_model)
# There is a significantDepth effect! The more depth the less bleaching compared to 2_3_m
# Compared to Large sizes, the smaller sizes favour the Number.Observations of bleaching
# Site is not really significant. For instance, there are no differences between Bluff and Sharp and tiny sign. differences between Bluff and TPC
# THIS MODEL NEEDS VALIDATION!!

# 1st Check if there is overdispersion to see if the zeroinfl model is good! If it is overdispersed we might need a Zero-Inflated Negative Binomial (ZINB) Model
# Calculate the ratio of the residual deviance to the degrees of freedom
# Assuming you have a fitted Poisson model
poisson_model <- glm(Number.Observations ~ Site + Depth + Size, family = poisson, data = data_bleached)
summary (poisson_model)


# Validate the model
# Plot residuals
par(mfrow = c(2, 2))
plot(poisson_model)
# Chi-squared goodness-of-fit test
library (ResourceSelection)
hoslem.test(poisson_model$y, fitted(poisson_model)) # it does not get validated!
# Interpretation: p-value is smaller than 0.05, reject the null hypothesis -> the model does not fit the data well 
# too large chi-square. Discrepancy between the observed and predicted values! 
# The model is not good!!
summary (poisson_model)
# Ratio of residual deviance / Degrees of Freedom is much larger than 1, it means overdispersion likely present
# 12624/8417 = 1.499822

dispersion_stat <- sum(residuals(poisson_model, type = "pearson")^2) / poisson_model$df.residual
dispersion_stat # It is significantly greater than 1! We have overdispersion in here!

library(performance)
check_overdispersion(poisson_model) # We have overdispersion so we need a Negative Binomial model


library(MASS)
nb_model <- glm.nb(Number.Observations ~ Site + Depth + Size, data = data_bleached)
summary(nb_model)
# Model validation
par(mfrow = c(2, 2))
plot(nb_model)

# Compare AIC values
AIC(poisson_model, nb_model) # Negative binomial model is much better! 

# Need to compare the two models!
anova(poisson_model,nb_model,test="Chisq") # Less residuals in Model 2. The Negative Binomial is better



# Let's fit now a Zero-Inflated Negative Binomial (ZINB)
zinb_model <- zeroinfl(Number.Observations ~ Site + Depth + Size | 1, data = data_bleached, dist = "negbin")
summary(zinb_model)
# Model validation (a bit especial because output is different): 
# Extract residuals and fitted values
residuals <- residuals(zinb_model, type = "pearson")
fitted_values <- fitted(zinb_model)

# Ensure they are vectors
residuals <- as.vector(residuals)
fitted_values <- as.vector(fitted_values)

# Plot residuals vs fitted values
par(mfrow = c(1, 1))
plot(fitted_values, residuals, xlab = "Fitted Values", ylab = "Pearson Residuals")
abline(h = 0, col = "red")
# Create the Normal Q-Q plot
qqnorm(residuals, main = "Normal Q-Q Plot of Pearson Residuals")
qqline(residuals, col = "red")
# Sharp and TPC increase the likeelihood of having bleaching than Bluff
# Depth 4_5_m decreases the likelihood of having bleaching compared to 2_3_m
# Size also has some effects! All these models overlap one with each other! 

# Goodness-of-Fit Tests
# Chi-squared goodness-of-fit test
library(ResourceSelection)
hoslem.test(zinb_model$y, fitted(zinb_model))
# The model is not fitting the data well!
# Interpretation: 
# p-value nearly 0 so we reject the null hypothesis, the model is not fitting the data well
# chi-square too high, discrepancy between the observed and predicted values!

# All models are saying more or less the same! But not really converging!

# LEt's compare all these models 
# Compare AIC and BIC
AIC(zip_model,poisson_model,nb_model, zinb_model) # Lower AIC indicates a better fit
BIC(zip_model,poisson_model,nb_model, zinb_model) # Lower BIC indicates a better fit! 

# Compare log-likelihood
logLik(zip_model)
logLik(poisson_model)
logLik(nb_model)
logLik(zinb_model) # Higher log-likelihood values indicate a better fit.

library("lmtest")
# Perform likelihood-ratio test
lrtest(zip_model, poisson_model,nb_model,zinb_model)
# Summary according to Copilot!
# Model 1 (Zero-Inflated Model) fits the data significantly better than Model 2 (Poisson Model).
# Model 3 (Negative Binomial Model) fits the data significantly better than Model 1 (Zero-Inflated Model).
# There is no significant difference between Model 3 (Negative Binomial Model) and Model 4 (Zero-Inflated Negative Binomial Model).
# Based on these results, Model 3 (Negative Binomial Model) appears to be the best fit for your data, as it provides a significantly better fit than the other models without the need for zero-inflation.


# nb_model (Negative Binomial Model) is the best!
# Validate the model: 
# 1. Plot residuals
par(mfrow = c(2, 2))
plot(nb_model)
# Residuals randonmly scattered around 0 and normality plot roughly along a diagonal line

# 2. Goodness-of-Fit Tests
# Chi-squared goodness-of-fit test
library(ResourceSelection)
hoslem.test(nb_model$y, fitted(nb_model))
# The model is not fitting the data well! 


# 3. Overdispersion Check
# Calculate dispersion statistic
dispersion_stat <- sum(residuals(nb_model, type = "pearson")^2) / nb_model$df.residual
dispersion_stat # close to 0 is no overdispersion so it should be okay :) 

# 4. Predictive performance
# Cross-validation
library(boot)
cv_error <- cv.glm(data_bleached, nb_model, K = 10)$delta[1]
cv_error # Necessary to compare with other models

# 5. Visualise predictions: 
# Plot predicted vs actual values
predicted_values <- predict(nb_model, type = "response")
par(mfrow = c(1, 1))
plot(data_bleached$Number.Observations, predicted_values, xlab = "Actual", ylab = "Predicted")
abline(0, 1, col = "red")


# We could also do a Manova: 
### MANOVA 
# Extends the capabilities of ANOVA by assessing multiple dependent variables simultaneously
# Check assumptions: normality and homogeneity of variance-covariance matrices
hist (data_bleached$Number.Observations)

# manova_result <- manova(cbind(Number.Observations "Bleached", Number.Observations "Partial bleached") ~ Site + Depth + Size, data = data_bleached)
# summary(manova_result)

#### Zero-Inflated Models  ####

# I think that all these overdispersion problems come from the fact that it is modelling Number of Observations 
# for the bleaching countings only instead of the proportions. Same for the graphs!

rm (data_analysed_2,data_bleached,int_way, int_way2,model.set,nb_model, new0, new2, new3,new4, one_way_1, one_way_2, one_way_4, poisson_model, zip_model, zinb_model,two_way,tukey.plot.aov,tukey.plot.test, int_way1, new)

# SOLUTION to all these problems: Go Bayesian! and run a Hurdle model with all the 0s

############# HURDLE MODEL ############# 

# 2- Hurdle model: https://library.virginia.edu/data/articles/getting-started-with-hurdle-models#:~:text=Hurdle%20Models%20are%20a%20class,covered%20by%20Medicare%20in%201988
# install.packages("AER")
library(AER); library(pscl)

data_hurdle <- data_analysed

# Only for the during bleaching survey time
data_hurdle <- subset(data_hurdle, Bleaching.Time == "During")
data_hurdle <- subset(data_hurdle, select = -c(Bleaching.Time, Size))

# Plot to see all the 0s
plot(table(data_hurdle$Number.Observations))
# How many obs have 0s? 
sum(data_hurdle$Number.Observations < 1)

# Run the hurdle (the data is still not binomial)
mod.hurdle <- hurdle(Number.Observations ~ ., data = data_hurdle)
summary (mod.hurdle)
# One part is prob of observing a 0 vs non 0 count (binomial with logit link)
# # The other part considers the positive counts considering a truncated poisson distribution (It did not work)
# All these NA means it did not converge well. Probably because of all the species comparisons or colinearity

# Conclusions: 
# Pearson relations are close to 0 which is good but with some extreme residuals...
# For the Zero hurdle model coefficients (binomial with logit link) 
# The log odds to have a 0 in TPC decrease ( + ) 0.5789) in comparison with Bluff. (i.e., TPC is less likely to have 0s)
# The log odds to have a 0 in 4_5_m increase by ( - ) -0.39223 in comparison with 1-2 m. (i.e., Deeper depths are more likely to have 0s)
# The log-odds to have a 0 in Porites lutea decrease by ( + ) 6.13401 compared to the reference Acropora species (i.e., Porites is less likely to have zeros).

# Second model
mod.hurdle2 <- hurdle(Number.Observations ~ ., data = data_hurdle, dist = "poisson", zero.dist = "binomial")
summary(mod.hurdle2)
# Same as above

mod.hurdle3 <- hurdle(Number.Observations ~  Status + Depth + Species + Site, data = data_hurdle, dist = "poisson", zero.dist = "binomial")
summary(mod.hurdle3) # With species it doesn't work

mod.hurdle4 <- hurdle(Number.Observations ~  Status, data = data_hurdle, dist = "poisson", zero.dist = "binomial")
summary(mod.hurdle4)

mod.hurdle5 <- hurdle(Number.Observations ~  Status + Depth + Site, data = data_hurdle, dist = "poisson", zero.dist = "binomial")
summary(mod.hurdle5)
# The log odds to have a 0 in Dead increase -2.60414 in comparison with Bleached(=reference standard) (i.e., Deads are more likely to have 0s)
# The log odds to have a 0 in Pigmented increase -0.46929 in comparison with Bleached (i.e., Pigmented are more likely to have 0s than bleached)


# First ouput (top) for Number.Observations > 1 and below for having Number.Observations = 0


sum(predict(mod.hurdle, type = "prob")[,1]) # Number of 0s in the expected data

predict(mod.hurdle, type = "response")[1:5] # Expected positive count success

predict(mod.hurdle, type = "count")[1:5] # mean of positive-count process

predict(mod.hurdle, type = "zero")[1:5] * predict(mod.hurdle, type = "count")[1:5] # multiply ratio and mean
# Which equals "predict(mod.hurdle, type = "response")[1:5]"

# For details on how the ratio of non-zero probabilities is calculated
# We can also check overdispersion


# Check a neg binomial
mod.hurdle.nb <- hurdle(Number.Observations ~  Status + Depth + Site, data = data_hurdle, dist = "negbin")

# Check AIC, lower is better
AIC(mod.hurdle)
AIC(mod.hurdle.nb) # lower is better

# fit the zero hurdle component using Status Depth and Site as predictors
mod.hurdle.nb2 <- hurdle(Number.Observations ~ . |  Status + Depth + Site, 
                         data = data_hurdle, dist = "negbin")
summary (mod.hurdle.nb2)

# Hurdle model is done but still necessary to interpret

# Check the effect of bleaching per species / the best will be to represent it with the Bayesian model with the likelihood of being healthy !


# WE NEED TO RUN THIS MODEL WITH BINOMIAL DISTRIBUTION 100% 

# Create the binomial database
data_hurdle_bi <- data_hurdle

# Remove the dead ones; 
data_hurdle_bi <- data_hurdle_bi %>%
  filter(Status != "Dead") # instead of filtering and dropping the dead, we could transform them to "Bleached"

data_hurdle_bi$Status <- str_replace_all(data_hurdle_bi$Status, 'Partial bleached', 'Bleached')
data_hurdle_bi$Status <- str_replace_all(data_hurdle_bi$Status, 'Bleached', 'Bleached or partial bleached')

unique (data_hurdle_bi$Status)

# Binomial database is ready!
# Run the model
mod.hurdle_bi <- hurdle(Number.Observations ~  Status + Depth + Site, data = data_hurdle_bi, dist = "poisson", zero.dist = "binomial")
summary(mod.hurdle_bi)
# Model converged after 24 BFGS iterations which is a good sign
# Log-Likelihood is quite low but better than the others. 12 DF means the model estimates 12 parameters

# Interpret the zero hurdle model coefficients
# The log odds to have a 0 in Pigmented decrease ( - ) -0.42812 in comparison with Bleached(=reference standard) (i.e., Pigmented are likely to have 0s counts)
# The log odds to have a 0 in Depth4_5_m increase (-) -0.31999 in comparison with 1_2m (i.e., 4_5m are less likely to have 0s than 1_2m)

# The log-odds to have a 0 in TPC decrease by ( + ) 0.40051 compared to the reference Bluff (i.e., TPC is less likely to have zero counts).

# Interpret the Truncated Poisson (the positive counts, non-zero observations)
# StatusPigmented: The log-count decreases by -0.16834 compared to the reference status (e.g., non-pigmented). 
# The log-count of TPC increases by 0.31284 compared to reference site (bluff Island)

# Deepseek
# Pigmented corals (StatusPigmented) are associated with significantly lower counts.
# Deeper depths (Depth2_3_m and Depth4_5_m) are associated with significantly lower counts.
# The site Tung Ping Chau is associated with significantly higher counts compared to the reference site.

# Copilot: 
# StatusPigmented: Negatively affects both the count and zero hurdle models, indicating fewer observations and a lower probability of zero observations.
# Depth: Deeper depths (4-5 m) significantly reduce the count and increase the probability of zero observations.
# Site: Tung Ping Chau has a positive effect on both models, suggesting more observations and a lower probability of zero observations.

# Compare all the models 
AIC (mod.hurdle5, mod.hurdle_bi, mod.hurdle) 
# the smaller value is the best

# Overall conclusion: 
# More 0s in depths (4-5 m) than in the shallows
# Less 0s in TPC than other sites, more colonies in TPC.
# More colonies present and therefore assessed for the bleaching in the shallows than in depths (please note that the difference between 1 vs 2-3 m was no significant (NS), Est = 0.02, p-value = 0.256677)

############# HURDLE MODEL ############# 












######## BAYESIAN MODELS - THESE ARE NOT USED ##########

#### Go to Script : "Read_Temps_Defi_Bayesian_Model.R"

# Here are some random Bayesian models without further use 
# In any case, conclusions are the same



# Go Bayesian! 

data_bm <- data_analysed # data_bm "bm" stands for bayesian model

data_bm <- subset(data_bm, Bleaching.Time == "During")
data_bm <- subset(data_bm, select = -c(Bleaching.Time, Size))


data_bm <- data_bm[data_bm$Number.Observations >0,] # removing all lines where observations are 0
# you have already run a Hurdle model before! 

# data_bm <- lapply(1:nrow(data_bm), function(x) {
#   
#   obs <- data_bm[x,]$Number.Observations
#   lines <- rep(x, obs)
#   
#   do.call(rbind,lapply(lines, function (y) {data_bm[y,]  }))
#   
# })
# 
# data_bm <- do.call(rbind, data_bm)
# 
# unique(data_bm$Status)


# Install the necessary bayesian packages - depends if working from server or personal computer

#  Using cmdstanr
# install.packages("posterior")

# install.packages("cmdstanr", repos = c("https://mc-stan.org/r-packages/", getOption("repos")))
# install_cmdstan() 
# set_cmdstan_path()

cmdstanr::install_cmdstan()
# download the latest brms
# if (!requireNamespace("remotes")) {
#   install.packages("remotes")
# }
# remotes::install_github("paul-buerkner/brms")

# install.packages("rstan", repos = c('https://stan-dev.r-universe.dev', getOption("repos"))) # This one was not working...

library (brms); library(parallel);  library (tidybayes) ;  library (posterior); library (cmdstanr); library (rstan)


# Necessary transformations to avoid the error
data_bm <- as.data.frame (data_bm)
data_bm$Number.Observations <- as.integer(data_bm$Number.Observations)
str (data_bm)
data_bm$Depth <- str_replace_all(data_bm$Depth, '1_m', '1')
data_bm$Depth <- str_replace_all(data_bm$Depth, '2_3_m', '2')
data_bm$Depth <- str_replace_all(data_bm$Depth, '4_5_m', '3')
data_bm$Depth <- as.integer(data_bm$Depth)

# Also necessary to get rid of the Unidentified, it does not bring anything to the table
data_bm <- data_bm %>% filter(Species != "Unidentified")



# First model, considering categorical
fit_bayes_1 <- brms::brm(Status ~ 1 + Depth + (1 + Depth | Species) +  (1|Site), data = data_bm, family = categorical(link = "logit", refcat = "Pigmented"),  control = list(max_treedepth = 17, adapt_delta = 0.99),  chains = 2, cores = 2, iter = 9000, warmup = 3000, backend = "cmdstanr",threads = 1)

# chains 4, cores 4, iter 7000 warmup 1000 threads up to 20 if another computer
# tree 15, delta 0.99. 
# Tree depth by default with Stan is 10. higher number helps analyse the data more throughfully and improves the Posterior Distribution
# Higher adapt delta means more conservative to avoid divergent transitions
# I increased these values until getting a model convergence without errors or Warnings. 
# Save the output
save(fit_bayes_1, file="Data/Bayesian_Outputs/fit_bayes_1.RData")
# Load the output of the model straight
load("Data/Bayesian_Outputs/fit_bayes_1.RData") 

# Interpretation for the first model, not bernoulli
summary (fit_bayes_1)
# conditional effects
ce <- conditional_effects(fit_bayes_1,categorical = T, probs = c(0.33, 0.66), method = c("fitted"))
# Probs  # 0.025, 0.975 had to be changed to 0.33 to 0.66 

# plot conditional effects for each predictor
# Set the levels and colors for the plot
ce$`Depth:cats__`$Status = factor(ce$`Depth:cats__`$Status,levels = c ("Pigmented",  "Partial bleached","Bleached","Dead"))
colours <- c( "forestgreen","green","orange", "red")

# Delete the x_continuous if you consider it is not necessary
plot(ce, plot = FALSE)[[1]] + scale_color_manual(values= colours,breaks=c("Pigmented",  "Partial bleached","Bleached","Dead"))+
  scale_fill_manual(values= colours, breaks = c("Pigmented",  "Partial bleached","Bleached","Dead"))  + 
  scale_x_continuous(name ="Depth (m)", limits=c(1,3), breaks = c(1,2,3)) +
  labs(x = "Depth (m)",  y = "Probability",  title = "Bayesian Prediction of Status in Depth") + theme_classic()


# This shows the expected/predicted status as a function of the predictor variable (Depth)
# The estimate of being bleached decreased with depth, Dead is unnecessary...
# Better to work with a binomial distribution only 

# If in the end, you want to to work with this model, go check the bottom of this script adapted from Pérez-Rosales et al 2021 RSOS




# From now on, the models are BINOMIAL (Bernoulli) combining the "Bleached" and "Partial bleached", and dropping the "Dead or partial mortality" because very few "Dead" during the first surveys
data_bm2 <- data_bm
# Remove the dead ones!
data_bm2 <- data_bm2 %>%
  filter(Status != "Dead")
# Combine the bleached ones
data_bm2$Status <- str_replace_all(data_bm2$Status, 'Partial bleached', 'Bleached')
data_bm2$Status <- str_replace_all(data_bm2$Status, 'Bleached', 'Bleached or partial bleached')
########## VERY IMPORTANT 
# Transform the data to the Binomial! 
# 0 is Pigmented and 1 is bleached! 
data_bm2$Status <- str_replace_all(data_bm2$Status, 'Pigmented', '0')
data_bm2$Status <- str_replace_all(data_bm2$Status, 'Bleached or partial bleached', '1')
unique (data_bm2$Status)

str (data_bm2)

# Second model since it is only 2 Status levels (binary response) use Bernoulli family instead
# 2nd model
fit_bayes_2 <- brms::brm(Status ~ 1 + Depth + (1 + Depth | Species) +  (1|Site), data = data_bm2, family = bernoulli(link = "logit"),  control = list(max_treedepth = 16, adapt_delta = 0.99),  chains = 2, cores = 2, iter = 9000, warmup = 3000, backend = "cmdstanr",threads = 1)
summary (fit_bayes_2) 
# Interpretation: 
# Convergence is okay
# With Depth (Estimate = -0.74), the probability of having Status 1 (= which is bleaching) decreases
save(fit_bayes_2, file="Data/Bayesian_Outputs/fit_bayes_2.RData")
# Load the output of the model straight
load("Data/Bayesian_Outputs/fit_bayes_2.RData") 


# Third model, still using Bernoulli
# Considering Species and Site as a Random effect (random intercept and slope), so it allows variations by groups
# Because Depth and Status might differ across Species and Site
# The syntaxis: (Status ~ 1 + Depth + (1 + Depth | Species) +  (1 + Depth | Site) always has some divergent transitions. We cannot trust the Posterior Distribution. 
# This is why, I kept increasing tree depth and adapt delta
fit_bayes_3 <- brms::brm(Status ~ 1 + Depth + Site + (1 + Depth | Species | Site), data = data_bm2, family = bernoulli(link = "logit"),  control = list(max_treedepth = 16, adapt_delta = 0.99),  chains = 2, cores = 2, iter = 9000, warmup = 3000, backend = "cmdstanr",threads = 1)
# Here it specifies that both the intercept and the slope of Depth can vary by Site. (not really what we are looking for)
summary (fit_bayes_3)
# Interp: 
# Convergence okay, no warnings
# Bleaching status 1 decreases with depth
# Sites are similar. TPC estimate is + (1.54), it means has a positive correlation towards bleaching compared with Bluff (the reference sie)
# However, the l-95% and u-95% intervals make it not significant
# Differentiating by site is not that necessary / important! Here it does not consider how for each site, it decreases with depth
save(fit_bayes_3, file="Data/Bayesian_Outputs/fit_bayes_3.RData")
# Load the output of the model straight
load("Data/Bayesian_Outputs/fit_bayes_3.RData") 


# 4th model to compare across sites more explicitly by depth
# 4th model like: 
# Formula = Status ~ 1 + Depth * Site + (1 + Depth | Species) + (1 | Site)
# Depth * Site interaction allows to see how the effect of Depth varies across different Sites
# (1 | Site): A random intercept for Site, which accounts for the variability between sites.

# Because it was converging with divergence - 3 of 12000 (0.0%) transitions ended with a divergence
# let's set some initial priors, suggested by Copilot:
default_priors <- brms::get_prior(Status ~ 1 + Depth * Site + (1 + Depth | Species) + (1 | Site),
                                  data = data_bm2,
                                  family = bernoulli(link = "logit"))
print(default_priors)
priors <- c( set_prior("student_t(3, 0, 2.5)", class = "sd"),  # Prior for standard deviations
             set_prior("normal(0, 1)", class = "sd", coef = "Depth", group = "Species"),  # Prior for random effect sd of Site
             set_prior("student_t(3, 0, 2.5)", class = "sd", group = "Site"),  # Prior for random effect sd of Site
             set_prior("student_t(3, 0, 2.5)", class = "sd", group = "Species"),  # Prior for random effect sd of Species
             set_prior("lkj(1)", class = "cor"),  # Prior for correlations
             set_prior("lkj(1)", class = "cor", group = "Species"))  # Prior for correlations within Species
# When I run the model, I still have divergent transitions! Better as sugested by DeepSeek below:

# Like this, suggested by Deepseek (avoid divergent transitions!)
priors <- c(
  # Prior for the Intercept
  set_prior("normal(0, 2)", class = "Intercept"),
  # Priors for fixed effects (b)
  set_prior("normal(0, 1)", class = "b", coef = "Depth"),
  set_prior("normal(0, 1)", class = "b", coef = "SiteSharpIsland"),
  set_prior("normal(0, 1)", class = "b", coef = "SiteTungPingChau"),
  set_prior("normal(0, 1)", class = "b", coef = "Depth:SiteSharpIsland"),
  set_prior("normal(0, 1)", class = "b", coef = "Depth:SiteTungPingChau"),
  # Priors for random effects (sd)
  set_prior("student_t(3, 0, 2.5)", class = "sd", group = "Site"),
  set_prior("student_t(3, 0, 2.5)", class = "sd", group = "Species"),
  # Prior for correlation (cor)
  set_prior("lkj(2)", class = "cor", group = "Species"))

# Now you can run the model:
fit_bayes_4 <- brms::brm(Status ~ 1 + Depth * Site + (1 + Depth | Species) + (1 | Site), data = data_bm2, family = bernoulli(link = "logit"),
                         prior = priors,
                         control = list(max_treedepth = 18, adapt_delta = 0.99), chains = 2, cores = 2, iter = 12000, warmup = 4000, backend = "cmdstanr", threads = 1)
summary (fit_bayes_4)
# Interpretation: 
# Depth is now fully significant decreasing bleaching (Status 1 with depth)
# The decreases in Sharp and TPC are not significant compared to Bluff. 
# The sites do not have a significant difference with Bluff
# All sites are behaving more or less equally, decreasing with depth but not having spatial significant differences
save(fit_bayes_4, file="Data/Bayesian_Outputs/fit_bayes_4.RData")
load("Data/Bayesian_Outputs/fit_bayes_4.RData")



# Check some extra models with binomial distribution
# Random effect for Species, it allows the effect of Depth on Status to vary by Species. Also variation on the intercept by Species
# Fixed effects for Depth and Site

# 5th model
fit_bayes_5 <- brms::brm(Status ~ 1 + Depth + Site + (1 + Depth | Species), data = data_bm2, family = bernoulli(link = "logit"),control = list(max_treedepth = 16, adapt_delta = 0.9), chains = 2, cores = 2, iter = 9000, warmup = 3000, backend = "cmdstanr", threads = 1)
summary (fit_bayes_5)
# Interp:
# It converged without priors or any additional tree depth or delta!
# Depth significant decrease of Status 1 (which is bleaching)
# Sharp and TPC have more bleaching than Bluff. Order is Bluff, Sharp and TPC
# I like this model!
save(fit_bayes_5, file="Data/Bayesian_Outputs/fit_bayes_5.RData")
load("Data/Bayesian_Outputs/fit_bayes_5.RData")

# 6th model
# This formula needs priors
default_priors <- brms::get_prior(Status ~ 1 + Depth + Site + (1 + Depth | Species) + (1 + Depth | Site),
                                  data = data_bm2,
                                  family = bernoulli(link = "logit"))
print(default_priors)
# Priors from DeepSeek
custom_priors <- c(
  # Prior for the Intercept
  set_prior("normal(0, 2)", class = "Intercept"),
  # Priors for fixed effects (b)
  set_prior("normal(0, 1)", class = "b", coef = "Depth"),
  set_prior("normal(0, 1)", class = "b", coef = "SiteSharpIsland"),
  set_prior("normal(0, 1)", class = "b", coef = "SiteTungPingChau"),
  # Priors for random effects (sd)
  set_prior("student_t(3, 0, 2.5)", class = "sd", group = "Site"),
  set_prior("student_t(3, 0, 2.5)", class = "sd", group = "Species"),
  # Priors for random slopes (sd)
  set_prior("student_t(3, 0, 2.5)", class = "sd", group = "Site", coef = "Depth"),
  set_prior("student_t(3, 0, 2.5)", class = "sd", group = "Species", coef = "Depth"),
  # Priors for correlation (cor)
  set_prior("lkj(2)", class = "cor", group = "Site"),
  set_prior("lkj(2)", class = "cor", group = "Species")
)
# Now run the model:
fit_bayes_6 <- brms::brm(Status ~ 1 + Depth + Site + (1 + Depth | Species) + (1 + Depth | Site), data = data_bm2, family = bernoulli(link = "logit"),
                         prior = custom_priors,
                         control = list(max_treedepth = 18, adapt_delta = 0.99), chains = 2, cores = 2, iter = 9000, warmup = 3000, backend = "cmdstanr", threads = 1)
summary (fit_bayes_6)
# Interp: 
# Fixed effcts are not significant
# Too high tree depth and adapt delta
save(fit_bayes_6, file="Data/Bayesian_Outputs/fit_bayes_6.RData")
load("Data/Bayesian_Outputs/fit_bayes_6.RData")
# This model is actually not so good... Still divergence so I had to increase again the max_treedepth and the adapt_delta


# Model selection from the fitted and converged models:

# 1. Compute WAIC, LOO-CV, or DIC for each model
# "loo_compare" 
# "model_weights" 
# Rhat conversion
# install.packages("loo")
library(loo)

# Extract Loo for each model and compare: 
# loo1 <- loo(fit_bayes_1)
loo2 <- loo(fit_bayes_2)
loo3 <- loo(fit_bayes_3)
loo4 <- loo(fit_bayes_4)
loo5 <- loo(fit_bayes_5)
loo6 <- loo(fit_bayes_6)
# Compare models
comparison <- loo_compare(loo2,loo3, loo4, loo5, loo6) # loo1 cannot be used because "categorical"
print(comparison) # Clearly the best models are fit_bayes_5 or fit_bayes_2


# Check rhat convergence
# Already checked but some, like fit_bayes_4 and fit_bayes_6 needed priors and extra tree depth and iterations

# Bayes plot (Need to find how to interpret this)
library(bayesplot)
np5 <- nuts_params(fit_bayes_5)
mcmc_parcoord(as.matrix(fit_bayes_5), np = np5)

np2 <- nuts_params(fit_bayes_2)
mcmc_parcoord(as.matrix(fit_bayes_2), np = np2)


# Perform posterior predictive checks to validate the selected model.
pp_check(fit_bayes_5, type = "dens_overlay", ndraws = 100)
pp_check(fit_bayes_2, type = "dens_overlay", ndraws = 100)
# The density plots overlap so we are happy with this model. Better in "fit_bayes_5"
pp_check(fit_bayes_5, type = "hist", ndraws = 6)
pp_check(fit_bayes_2, type = "hist", ndraws = 6)
# The predictions and observed look really good

pp_check(fit_bayes_5, type = "stat", stat = "mean") # Looks very good
pp_check(fit_bayes_2, type = "stat", stat = "mean") # Looks very good


# Check output of the model, 
print(fit_bayes_5, pars = "b")
summary (fit_bayes_5)
coef(fit_bayes_5)

print(fit_bayes_2, pars = "b")
summary (fit_bayes_2)
coef(fit_bayes_2)

# W are happy with "fit_bayes_5", adding some meaningful information for Site as a fixed effect; so we can compare!

# "fit_bayes_5" is the best model ever

load("Data/Bayesian_Outputs/fit_bayes_5.RData")
final_bi_model <- fit_bayes_5

# Check convergence of the model again
summary(final_bi_model)
coef (final_bi_model)
final_bi_model
# check the plots
plot (final_bi_model)
pp_check(final_bi_model)

# Conditional effects: 
conditional_effects(final_bi_model)

# Make a nicer plot
ce <- conditional_effects(final_bi_model,categorical = F, probs = c(0.025, 0.975), method = c("fitted"))
# Probs  # 0.025, 0.975 had to be changed to 0.33 to 0.66, you can change to prob = c (0.2)

# plot conditional effects for depth
plot(ce, plot = FALSE)[[1]] + 
  scale_x_continuous(name ="Depth (m)", limits=c(1,3), breaks = c(1,2,3)) +
  labs(x = "Depth (m)",  y = "Predicted status",  title = "0 = Pigmented, 1 = Bleaching") + theme_classic()

# plot conditional effects for Site as discrete variable
plot(ce, plot = FALSE)[[2]] + 
  labs(x = "Site",  y = "Predicted status",  title = "0 = Pigmented, 1 = Bleaching") + theme_classic()


# Prepare fully crossed conditions of the conditional effects
# Working with Site
conditions_site <- make_conditions(final_bi_model, vars = c( "Site"))
ce_Site <- conditional_effects(final_bi_model,  conditions = conditions_site, categorical = F, prob = c(0.2), method = c("fitted"), re_formula = NULL) # Instead of probs = c(0.33, 0.66)
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
conditions <- make_conditions(final_bi_model, vars = c( "Species"))
ce_Species <- conditional_effects(final_bi_model,  conditions = conditions, categorical = F, prob = c(0.2), method = c("fitted"), re_formula = NULL) # Instead of probs = c(0.33, 0.66)

plot (ce_Species)


# # Filter to certain species with higher occurrences: 
Depth_range <- ddply(data_bm2,~ Depth + Species ,function(x){c(Nb_observ_depth=nrow(x))})
Occurrences <- ddply(data_bm2,~  Species ,function(x){c(Nb_observ=nrow(x))})
# View(Occurrences)
# Less than 8 Observations total, the species are dropped
Keep_species <- Occurrences %>% filter(Nb_observ > 8) %>% pull(Species)


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
Depth <- unique (final_bi_model$data$Depth)
Species <- unique (final_bi_model$data$Species)
Site <- unique (final_bi_model$data$Site)
ref_data <- crossing(Site, Depth, Species)

fitted_values <- posterior_epred(final_bi_model, newdata = ref_data, re_formula = 'Status ~ 1 + Depth + Site + (1 + Depth | Species)')

str (fitted_values)
dim (fitted_values)

# View(fitted_values) # 3*3*18


# Take all conditions: 
Posterior <- as.data.frame (fitted_values [c(1:12000),]) # Taking all conditions because it is binary 
# 1 is bleaching
# 0 is pigmented

# Necessary to transpose
Posterior <- t(Posterior)
ref_data_fitted <- cbind (ref_data,Posterior)
# View(ref_data_fitted)

ref_data_fitted <- melt (ref_data_fitted, id.vars = c ("Site", "Depth", "Species"), na.rm = F, measure.vars = c(4:162), value.name = c("Prob"))

# check the depth ranges of the species
# # Filter to certain species with higher occurrences: 
Depth_range <- ddply(data_bm2,~ Depth + Species ,function(x){c(Nb_observ_depth=nrow(x))})
Occurrences <- ddply(data_bm2,~  Species ,function(x){c(Nb_observ=nrow(x))})
# View(Occurrences)
# Less than 8 Observations total, the species are dropped
Keep_species <- Occurrences %>% filter(Nb_observ > 8) %>% pull(Species)

# Filter the ref_data_fitted
ref_data_fitted2 <- ref_data_fitted %>% filter(Species %in% Keep_species)

# Make a plot: 
library (ggridges)
# Set the order you want:
ref_data_fitted2$Species <- factor(ref_data_fitted2$Species, levels = rev(sort(unique(ref_data_fitted2$Species))))
# Make the ggplot
ggplot(ref_data_fitted2, aes(x = Prob, y = Species)) + # fill = Species
  geom_density_ridges(scale = 1, rel_min_height = 0.1 ) +  
  facet_wrap(~Depth, nrow = 3) +  xlab ("Likelihood Status, 0 = Pigmented & 1 = Bleached") + ylab ("")+
  theme_bw() +  theme(legend.position="none")
# Depth 1 is 1 m; 2 is 2-3 m and 3 is 4-5 m.

# Without considering depths
ggplot(ref_data_fitted2, aes(x = Prob, y = Species)) + # fill = Species
  geom_density_ridges(scale = 1, rel_min_height = 0.1 ) +  
  xlab ("Likelihood Status, 0 = Pigmented & 1 = Bleached") + ylab ("")+
  theme_bw() +  theme(legend.position="none")


# Write csv for 2024 data_bm2 to run a Bayesian model with 2022 Jeffery's data

# Add a column with Year
data_bm_2024 <- data_bm2
data_bm_2024$Year <- 2024

write_csv(data_bm_2024, "Data/Bleaching/data_bm_2024.csv")



#### THE END ####




