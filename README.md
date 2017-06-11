# r-eurostat-refugees

This is a package, and a rstudio project, based on https://github.com/rOpenGov/eurostat , to get and visualize asylum data from eurostat. To use it:

## Prepare
1. Install R and rstudio - e.g. as in https://github.com/muc-fluechtlingsrat/r-eurostat-refugees/blob/master/man/ON_FRESH_UBUNTU.md

2. Open the r-project file \*.Rproj in rstudio as a project (see https://support.rstudio.com/hc/en-us/articles/200526207-Using-Projects
3. import and load all libraries by running import_packages.R (there are probably better ways), library(eurostat)

## Get data
Import and clean the data.

To know which eurostat data source to use, check out http://htmlpreview.github.io/?https://github.com/muc-fluechtlingsrat/r-eurostat-refugees/blob/master/man/eurostat_asylum_data_sources.html


We have two use cases:

* filter with dplyr

## Example: Compare acceptance of asylum requests of one country of origin, across countries of application

Let's work with the annual data, migr_asydcfsta, and go through the steps slowly.
1. load data: decisions_firstinstance_annual=get_eurostat("migr_asydcfsta", time_format = "date") 
2. Clean data: We only want:
Being lazy, we use dplyr's filter to exclude some total, include other:
decfistann_rel <- decfistinannual_cleaned %>% group_by(citizen) %>% summarise(sum_dec=sum(values)) %>% arrange(sum_dec) 
decfistann_by_citizen <- mutate(decfistann_by_citizen, citizen_long_name=label_eurostat(decfistann_by_citizen)[["citizen"]])
decfistinannual_cleaned <- filter(decisions_firstinstance_annual, sex == "T", age == "TOTAL",  citizen != "EXT_EU28", citizen != "TOTAL", geo != "EU28", decision %in% c("TOTAL","TOTAL_POS"))

If we are interested in many countries, we restrict our analysis to the top 100 countries of origin ("citizen"), with the most decisions.

decfistann_rel <- decfistinannual_cleaned %>% group_by(citizen) %>% summarise(sum_dec=sum(values)) %>% arrange(sum_dec) %>% top_n(100,sum_dec)
sex - total; age - total; decision: total and total_pos; geo: not total and eu28.
If we know which country of origin we are interested in, we restrict to this country. We may need the lookup table.


## Notes
1. load data: data = load_data_acceptance_from_file('/full/path/to/data/data_acceptance') to get the data from the file, or data = load_data_acceptance() to get it from eurostat. 
This will load 8.6 MB / 45 mio values and look like
> str(data)
Classes ‘tbl_df’ and 'data.frame':	45571033 obs. of  8 variables:
 $ citizen : chr  "Andorra" "Andorra" "Andorra" "Andorra" ...
 $ sex     : chr  "Females" "Females" "Females" "Females" ...
 $ age     : chr  "Total" "Total" "Total" "Total" ...
 $ decision: chr  "Geneva Convention status" "Geneva Convention status" "Geneva Convention status" "Geneva Convention status" ...
 $ geo     : chr  "Germany (until 1990 former territory of the FRG)" "Estonia" "European Union (28 countries)" "Liechtenstein" ...
 $ unit    : chr  "Person" "Person" "Person" "Person" ...
 $ time    : Date, format: "2017-01-01" "2017-01-01" "2017-01-01" ...
 $ values  : num  0 0 0 0 0 0 0 0 0 0 ...
> 

to see all Countries of Origin:

unique(data[[1]])

to see all countries of destination / where the application was submitted, or decided:

unique(data[[5]])

