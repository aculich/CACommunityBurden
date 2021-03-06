# =====================================================================================
# "tractPopulationProcessorTotal.R" file                                              |
#            designate folder locations and load packages                             |
#            load packages                                                            |
#            get census tract population data                                         |
#            link tracts to "community IDs" and to county names                       |
#            save data set                                                            |
#                                                                                     |   
# =====================================================================================

#-- Load Packages ---------------------------------------------------------------------------------------------------

library(tidycensus)  # gets census and ACS data - get_acs function
library(tigris)      # gets "shape" files  # requires census_api_key("MYKEY") to be run once
library(tidyverse)   # data processing
library(fs)          # just for path function

yearGrp <- "2013-2017"


#-- Set Locations Etc----------------------------------------------------------------------

myDrive  <- "E:"  
myPlace  <- path(myDrive,"/0.CBD/myCBD///")  
upPlace  <- path(myDrive,"/0.CBD/myUpstream")  

#.path  <- "H:/Ben's Work file/Projects/CBD/Education and Poverty"
#setwd(.path)
#census_api_key(read_file("census.api.key.txt"),install=T)

#-- Set API ACS Table/variable list ----------------------------------------------------------------------

# B01001_*E except totals   MCS FIXED FROM ---- c(3:26,28:49))

list.tot  <- "B01003_001"                                     # B01003_001       total: census tract x year
list.race <- sprintf("B02001_%03d",c(1:10)) 		              # B02001_001-010   total: census tract x year x race (H incl)
list.sex  <- c("B01001_001E","B01001_002E", "B01001_026E")    # B01001_002E,026E total: census tract x year x sex (Total, Male, Female)

#-- Get, process, and export data -----------------------------------------------------------------------------------

makePop <- function(inList=list.sex,inyear=2016,yearlabel=yearGrp) {

acs.varlist <- inList  
  
options(tigris_use_cache = TRUE)
workDat   <- get_acs(geography = "tract", variables = acs.varlist, state = "CA",year=inyear)  # GEOID is 11 digit character string - 2011-2015 - N=8057

#---Issues Here
.acsvariables <- load_variables(inyear,"acs5")
mylabels      <- .acsvariables
names(mylabels)[names(mylabels) == "name"] = "variable"                                                       # rename variable to Name (to merge with labels)
mylabels<-mylabels[ (substr(mylabels$variable,0,7)==substring(acs.varlist,0,7)) &
                    (substr(mylabels$variable,nchar(mylabels$variable),nchar(mylabels$variable)) == "E"), ]   # filter mylabels to contain only entries from acs.varlist
mylabels$variable <- substr(mylabels$variable,1,nchar(mylabels$variable)-1)
workDat <- merge(workDat,mylabels)
#---To Here

cbdLinkCA <- read.csv(path(myPlace,"/myInfo/cbdLinkCA.csv"),colClasses = "character") # maps census tracts to MSSAs and counties - N= 8036
workDat   <- workDat %>% mutate(yearG = paste0(yearlabel),  
                                comID  = cbdLinkCA[match(workDat$GEOID,cbdLinkCA[,"GEOID"]),"comID"],
                                county = cbdLinkCA[match(workDat$GEOID,cbdLinkCA[,"GEOID"]),"county"],
                                pop    = estimate              ) %>%
                         select(-NAME,-estimate,-variable,-concept)

}

tDat <- makePop(list.sex,2016,yearGrp)                                                   # edit "sex" or "race" as appropate
tDat <- tDat %>%  
                # filter(label !="Total:") %>%
                  transform(label = str_replace(label, ":", "")) %>%
                  transform(sex   = label) %>%                              # edit "sex" or "race" as appropate
                  select(-label)  %>%
                  arrange(GEOID)
saveRDS(tDat, file=paste0(upPlace,"/upData/popTractSex2013.RDS"))           # edit "sex" or "race" as appropate


# tDat <- makePop(list.tot) 
# tDat <- tDat %>%  select(-label)  
# saveRDS(tDat, file=paste0(upPlace,"/upData/popTractTot2013.RDS"))          

# Ben: this didn't work for the race file, so I changed it to above transform
#                  transform(label = substr(label,1,nchar(label)-1)) %>%

# END ---------------------------------------------------------------------------------------------------------------

# confirmed that male+female = total (i.e. no sex is supressed etc.)
