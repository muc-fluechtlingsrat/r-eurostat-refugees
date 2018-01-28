# r-eurostat-refugees

This is a package, and a rstudio project, based on https://github.com/rOpenGov/eurostat , to get and visualize asylum data from eurostat. To use it:

## Prepare
1. Install R and rstudio - e.g. as in https://github.com/muc-fluechtlingsrat/r-eurostat-refugees/blob/master/man/ON_FRESH_UBUNTU.md

2. Open the r-project file \*.Rproj in rstudio as a project (see https://support.rstudio.com/hc/en-us/articles/200526207-Using-Projects
3. import and load all libraries by running import_packages.R (there are probably better ways), library(eurostat)

## Get data

To know which eurostat data source to use, check out http://htmlpreview.github.io/?https://github.com/muc-fluechtlingsrat/r-eurostat-refugees/blob/master/man/eurostat_asylum_data_sources.html

Let's work with the annual data, migr_asydcfsta, and go through the steps slowly.
1. load data into R, run in your console: 

> decisions_firstinstance_annual=get_eurostat("migr_asydcfsta", time_format = "date") 

Have a look at the data in rstudio or plain r respectively: 

> View(decisions_firstinstance_annual)
> str(decisions_firstinstance_annual)

2. Clean data

"citizen" is the country of origin, "geo" is the country where the asylum application was filed. 
Let's exclude the totals of citizen ("EXT_EUR28") and the totals of geo ("EU28"). Also, we only want the totals of "age" and "sex", so we only retain the total rows and drop the columns. We also drop the "unit" column.

decfirstnannual_cleaned <- filter(decisions_firstinstance_annual, sex == "T", age == "TOTAL",  citizen != "EXT_EU28", citizen != "TOTAL", geo != "EU28", geo != "TOTAL", decision %in% c("TOTAL","TOTAL_POS")) %>% select(-unit, -sex, -age)

We still over 100'000 observations (or rows), for the time between:

    min(decfirstnannual_cleaned$time)
    [1] "2008-01-01"
    max(decfirstnannual_cleaned$time)
    [1] "2016-01-01"

Let's have a look at the countries of origin.
decfan_by_citizen <- filter(decfirstannual_cleaned, decision == "TOTAL") %>% group_by(citizen, geo, time) %>% summarize(sum_dec = sum(values)) %>% arrange(sum_dec)

To see the long names of the countries, get the labels from eurostat:
decfan_by_citizen_label <- filter(decfan_by_citizen, sum_dec != 0) %>% select(citizen, geo) %>% label_eurostat() %>% distinct()



If we are interested in many countries, we restrict our analysis to the top 100 countries of origin ("citizen"), with the most decisions.

decfistann_rel <- decfistinannual_cleaned %>% group_by(citizen) %>% summarise(sum_dec=sum(values)) %>% arrange(sum_dec) %>% top_n(100,sum_dec)
sex - total; age - total; decision: total and total_pos; geo: not total and eu28.
If we know which country of origin we are interested in, we restrict to this country. We may need the lookup table.

## A dictionary of the countries of origin

To get a table with the citizen codes and the eurostat labels (long names) of the countries of origin, this works (though it's a strange solution):

    cit <- decfan_by_citizen %>% group_by(citizen) %>% summarise(sum(sum_dec)) %>% select(citizen)
    citp <- label_eurostat(cit, code="citizen")
    View(citp)

I'm interested in Ethiopia = ET.
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

