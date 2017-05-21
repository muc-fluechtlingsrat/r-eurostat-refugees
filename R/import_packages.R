# from https://gist.github.com/stevenworthington/3178163

ipak <- function(pkg){
    new.pkg <- pkg[!(pkg %in% installed.packages()[, "Package"])]
    if (length(new.pkg))
        install.packages(new.pkg, dependencies = TRUE)
    sapply(pkg, require, character.only = TRUE)
}

list.of.packages <- c("tidyr", "dplyr", "magrittr", "ggplot2", "eurostat", "gridExtra", "lubridate")
ipak(list.of.packages)

lapply(list.of.packages, require, character.only = TRUE)

