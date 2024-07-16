library(dplyr)
library(tidyr)

newData <- data[,c(2,37)] 

colnames(newData) <- c("target", "PfamAnnot")

data_expanded <- newData %>%
  +   separate_rows(target, sep = "\\|")

newData <- data_expanded %>% filter(target != "-")
newData <- newData %>% filter(PfamAnnot != "-")

write.table(newData,"annotPfam_NeoRdRp.tsv",sep = '\t',row.names = FALSE)