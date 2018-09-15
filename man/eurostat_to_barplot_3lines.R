library(eurostat) 
library(ggplot2) 
library(scales)

migr_asyappctza=get_eurostat("migr_asyappctza")

de_sy_migr_asyappctza <- subset(migr_asyappctza, citizen == "SY" & geo == "DE" & asyl_app == "ASY_APP" & sex != "T" & age != "TOTAL" & age != "Y_LT18")[c(2,4,7:8)]

ggplot(de_sy_migr_asyappctza, aes(x=time, y=values, fill=sex)) + geom_bar(stat="identity", position="dodge")  + scale_y_continuous(labels=comma) + scale_x_date() + ggtitle("Asylantr?ge von syrischen Staatsangeh?rigen", subtitle="In Deutschland, nach Geschlecht") + xlab("Jahr") + ylab("Anzahl Asylantr?ge") + scale_fill_discrete() + theme_light()

