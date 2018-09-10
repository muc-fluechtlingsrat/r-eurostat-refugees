## To get dictionary with country codes and labels

(since get_eurostat_dic and label_eurostat seem to be broken)


German version:
Dictionaries are at 
Vollständiges Herunterladen -> dic -> de -> geo;

https://ec.europa.eu/eurostat/estat-navtree-portlet-prod/BulkDownloadListing?sort=1&downfile=dic%2Fde%2Fgeo.dic

This is tab seperated, load into R with

    geodic = read.delim(file = "Downloads/geo.dic", col.names = c("code","label"))


Create lookup table:

    geo_migr_asydcfsta = levels(migr_asydcfsta$geo)
    geodic %>% filter(code %in% geo_migr_asydcfsta)

    


