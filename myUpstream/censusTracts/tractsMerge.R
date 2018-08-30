#Read and merge shape, death, pop and other files

library(fs)
library(readr)
library(dplyr)
library(tigris) #Added this one per Zev's instructions below

myDrive  <- "h:"                            
myPlace  <- paste0(myDrive,"/0.CBD/myUpstream")  


#R should usually be able to detect character (c) vs. numeric (n) automatically based on first 1000 rows but making sure with col_types below 
#Can use pipes (%/%) to tell R that final tables (e.g., d.mssa00) should only have selected variables and other changes specified
#Without pipes would have to rename table (e.g., d.new_mssa00)

d.correct <- read_csv(path(myPlace,"censusTracts/myData","Deaths_County_Corrected.csv"), col_types = "ncncn") %>%
            mutate(GEOID        = paste0("0",GEOID), #Add "0" to beginning of GEOID as it's shown in some databases
                   wrong_county1 = wrong_deaths_co1,
                   inDEATHS   = 1)  # this creates the indicator variable for this data set


d.mssa00  <- read_csv(path(myPlace,"censusTracts/myData","mssa00.csv"))  %>%
            mutate(GEOID      = paste0("0",GEOID),
                   county     = COUNTY,
                   inMSSA00   = 1) %>%  
            select(GEOID,county,inMSSA00, POP2000,POP2000CIV)



d.mssa13 <- read_csv(path(myPlace,"censusTracts/myData","mssa13.csv")) %>%
            mutate(GEOID      = paste0("0",GEOID),
                   county     = COUNTY,
                   inMSSA13   = 1,  
                   POP2013    = pop2013,
                   POP2013CIV = pop2013civ) %>%
            select(GEOID,county,inMSSA13,POP2013,POP2013CIV)


d.pov <- read_csv(path(myPlace,"censusTracts/myData","pov_2006_10.csv")) %>%
            mutate(GEOID      = paste0("0",GEOID),
                   inPOV      = 1) %>%  
            select(GEOID,county,inPOV)


d.group <- read_csv(path(myPlace,"censusTracts/myData","SVI_CDC_group_living.csv")) %>%
            mutate(GEOID      = paste0("0",GEOID),
                   county     = COUNTY,
                   inGROUP    = 1) %>% 
            select(GEOID,county,inGROUP,tot_pop_grp,e_groupQ)


#Have to use col_types below or R gets confused by one very big area of water way down the list
d.shape <- read_csv(path(myPlace,"censusTracts/myData","tracts_tiger.csv"),col_types = "nnnnnc") %>%
            mutate(GEOID      = paste0("0",GEOID),
                   inSHAPE    = 1) %>% 
            select(GEOID,county,inSHAPE)





#Doesn't look so easy to join (or merge?) more than 2 data sets at a time, although the purrr package could allow this: https://rpubs.com/williamsurles/293454 
# merged <- full_join(d.correct, d.mssa00, d.mssa13, d.pov, d.group, d.shape, by = "GEOID", suffix = c("de","00","13","po","gr","sh"))
#Error: `suffix` must be a character vector of length 2, not list of length 5


#This works OK but could I do it with pipes and/or get rid of multiple county columns or give better names than .x or .y.y?
merged <- full_join(d.correct, d.mssa00, by = "GEOID" , "county")
merged <- full_join(merged, d.mssa13, by = "GEOID" , "county")
merged <- full_join(merged, d.pov, by = "GEOID" , "county")
merged <- full_join(merged, d.group, by = "GEOID" , "county")
merged <- full_join(merged, d.shape, by = "GEOID" , "county")




#This looks better if we're confident we don't need to see multiple county columns
merged <- full_join(d.correct, d.mssa00, by = "GEOID" , "county") %>%
          full_join(merged, d.mssa13, by = "GEOID" , "county") %>%
          full_join(merged, d.pov, by = "GEOID" , "county") %>%
          full_join(merged, d.group, by = "GEOID" , "county") %>%
          full_join(merged, d.shape, by = "GEOID" , "county") %>%


#Better yet get rid of 2nd county column too, don't need to match on county?
  merged <- full_join(d.correct, d.mssa00, by = "GEOID") %>%
  full_join(merged, d.mssa13, by = "GEOID") %>%
  full_join(merged, d.pov, by = "GEOID") %>%
  full_join(merged, d.group, by = "GEOID") %>%
  full_join(merged, d.shape, by = "GEOID") %>%

  
  
  
  #Guessing for now we're using the corrected deaths file with totals for all years as before, 
#but CCB shows for each year as in the raw file below, so why did we do that? 
#d.raw      <- read_csv(path(myPlace,"censusTracts/myData","rawDeaths.csv"),col_types = "ncnc") %>%
 #               group_by(GEOID,county) %>%
  #              summarize(n=sum(Ndeaths))


#Starting adapting code below from Zev's link but not sure yet how to match on both county AND GEOID
#although I think we've fixed only GEOID's in wrong counties so wouldn't matter except for mssa00
#http://zevross.com/blog/2015/10/14/manipulating-and-mapping-us-census-data-in-r-using-the-acs-tigris-and-leaflet-packages-3/#do-the-merge-tigris
# 4) Do the merge (tigris)
#The package tigris has a nice little merge function to do the sometimes difficult merge between the spatial and tabular data.
#merged<- geo_join(d.shape, d.correct, d.mssa00, d.mssa13, d.pov, d.group, "GEOID", "GEOID")
#merged<- geo_join(d.shape, d.correct, d.mssa00, d.mssa13, d.pov, d.group, "GEOID", "GEOID", "GEOID", "GEOID", "GEOID", "GEOID")
# Could exclude tracts with no land but Michael says not for now: merged <- merged[merged$ALAND>0,]



