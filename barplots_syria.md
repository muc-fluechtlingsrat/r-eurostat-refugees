# Example with pure eurostat. 
library(eurostat)
library(ggplot)
library(scales)
### get data
migr_asyappctza=get_eurostat("migr_asyappctza")
### inspect data
str(migr_asyappctza)
### Reduce data 
#### Applications from Syrian citizens in Germany; All Applications; Exclude age and sex totals and overlapping age class; Reduce to columns needed
de_sy_migr_asyappctza <- subset(migr_asyappctza, citizen == "SY" & asyl_app == "ASY_APP" & geo == "DE" & sex != "T" & age != "Y_LT14" & age != "TOTAL")[c(2,4,7:8)]
#### Aggregate per year to be able to compare to bpb ... close enough
agg_sy=aggregate(de_sy_migr_asyappctza_df$value ~ de_sy_migr_asyappctza_df$time, de_sy_migr_asyappctza_df, FUN=sum)

### barplot by sex, and age

bar_sy_de_sex <- ggplot(de_sy_migr_asyappctza, aes(x=time, y=values, fill=sex)) + geom_bar(stat="identity", position="dodge")  + scale_y_continuous(labels=comma) + scale_x_date() + ggtitle("Asylanträge von syrischen Staatsangehörigen, in Deutschland, nach Geschlecht") + xlab("Jahr") + ylab("Anzahl Asylanträge")
bar_sy_de_sex + theme_light()
#### For plot per age, change order

### very basic example for Afghanistan, useful to compare with other sources (such as https://www.bpb.de/gesellschaft/migration/flucht/218788/zahlen-zu-asyl-in-deutschland
de_afgh_migr_asyappctza=subset(migr_asyappctza, citizen == "AF" & age == "TOTAL" & asyl_app == "ASY_APP" & geo == "DE" & sex == "T")[7:8]

p <- ggplot(de_afgh_migr_asyappctza, aes(x=time, y=values)) + geom_bar(stat="identity", fill="steelblue")  + scale_y_continuous(labels=comma) + scale_x_date() + ggtitle("Asylanträge von afghanischen Staatsangehörigen, in Deutschland") + xlab("Jahr") + ylab("Anzahl Asylanträge")

p


