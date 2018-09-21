
major_countries_dest_labels=c("Belgium","France","Germany (until 1990 former territory of the FRG)","Greece","Italy","Netherlands","Norway","Sweden","Spain","Switzerland","United Kingdom")
major_countries_dest_codes=c("BE","France","Germany (until 1990 former territory of the FRG)","Greece","Italy","Netherlands","Norway","Sweden","Spain","Switzerland","United Kingdom")

decision_cum=c("Rejected", "Total positive decisions", "Total")
decision_acc_total=c("Total positive decisions", "Total")


mutate(decision = ifelse(decision == "Total positive decisions",
                         "Total_positive_decisions",
                         decision))

