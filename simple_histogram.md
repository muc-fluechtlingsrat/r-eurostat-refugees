# Example with pure eurostat. 
library(eurostat)
library(ggplot)
library(scales)
### get data
migr_asyappctza=get_eurostat("migr_asyappctza")
### inspect data
str(migr_asyappctza)
### Reduce data 
de_afgh_migr_asyappctza=subset(migr_asyappctza, citizen == "AF" & age == "TOTAL" & asyl_app == "ASY_APP" & geo == "DE" & sex == "T")[7:8]
### plot histogram
p <- ggplot(de_afgh_migr_asyappctza, aes(x=time, y=values)) + geom_bar(stat="identity", fill="steelblue")  + scale_y_continuous(labels=comma) + scale_x_date() + ggtitle("Asylanträge von afghanischen Staatsangehörigen, in Deutschland") + xlab("Jahr") + ylab("Anzahl Asylanträge")
p


