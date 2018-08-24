## Analyzing first decisions on applications from Afghanistan across Europe

### Data Sources:
decision data from Eurostat is in the tables and the datasets migr_asydcfstq , migr_asydcfsta. Let's start with the annual data , the full title being "	First instance decisions on applications by citizenship, age and sex Annual aggregated data (rounded)", size 85 MB, 13311070 values, from 2008 to 2017 (as of July 2018).


migr_asydcfsta=get_eurostat("migr_asydcfsta")

Reduce to: Only totals in age and sex, only Afghanistan, only countries with at least 1000 decisions in 2017, only columns of interest.
1 - extract list of countries with > 1000 decisions in 2017:

for nicer code, use dplyr:

    library(dplyr)

    major_geo=filter(migr_asydcfsta, values > 500, time >= "2017-01-01", decision == "TOTAL", sex == "T", age == "TOTAL", citizen == "AF", geo != "EU28", geo != "TOTAL") %>%  arrange(desc(values)
+ )

    > select(major_geo, geo, values)
# A tibble: 15 x 2
      geo values
   <fctr>  <dbl>
 1     DE 109732
 2     SE  25155
 3     AT  17730
 4     FR   7516
 5     BE   5160
 6     CH   3094
 7     EL   2134
 8     IT   1972
 9     UK   1909
10     NL   1894
11     HU   1800
12     NO   1518
13     BG   1388
14     DK   1349
15     FI   1334
