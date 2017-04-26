# r-eurostat-refugees

This is a package, and a rstudio project

using https://github.com/rOpenGov/eurostat , to get and visualize asylum data from eurostat

1. Install R and rstudio

2. Open the r-project file *.Rproj in rstudio as a project (see https://support.rstudio.com/hc/en-us/articles/200526207-Using-Projects
3. import and load all libraries by running import_packages.R (there are probably better ways)

Now you can start. We have two use cases:

## Compare acceptance of asylum requests of one country of origin, across countries of application

1. load data: data = load_data_acceptance_from_file('/full/path/to/data/data_acceptance') to get the data from the file, or data = load_data_acceptance() to get it from eurostat. 
This will load 8.6 MB / 45 mio values and look like


  # A tibble: 45,571,033 × 8
     citizen     sex   age                 decision                                              geo
       <chr>   <chr> <chr>                    <chr>                                            <chr>
  1  Andorra Females Total Geneva Convention status Germany (until 1990 former territory of the FRG)
  2  Andorra Females Total Geneva Convention status                                          Estonia
  3  Andorra Females Total Geneva Convention status                    European Union (28 countries)
  4  Andorra Females Total Geneva Convention status                                    Liechtenstein
  
  
