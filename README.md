# r-eurostat-refugees

This is a package, and a rstudio project, based on https://github.com/rOpenGov/eurostat , to get and visualize asylum data from eurostat

1. Install R and rstudio

2. Open the r-project file *.Rproj in rstudio as a project (see https://support.rstudio.com/hc/en-us/articles/200526207-Using-Projects
3. import and load all libraries by running import_packages.R (there are probably better ways)

Now you can start. We have two use cases:

## Compare acceptance of asylum requests of one country of origin, across countries of application

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

