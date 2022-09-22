### Make example data file from ONS CPI data:

library(readxl)
library(tidyverse)
library(openxlsx)

### Indices
### File sourced September 2022 from
### https://www.ons.gov.uk/file?uri=/economy/inflationandpriceindices/datasets/consumerpriceinflation/current/consumerpriceinflationdetailedreferencetables.xls

dat <- 
  read_excel("~/Downloads/consumerpriceinflationdetailedreferencetables.xls", 
             sheet = "Table 9", skip = 21)

### Set missing col names for first two cols
colnames(dat)[1] <- "code"
colnames(dat)[2] <- "cat"
colnames(dat)[3:ncol(dat)] <- 2008:2021

### Ignore lines with missing "code, which are blank lines in the raw data
dat <- dat[!is.na(dat$code),]
### Ignore a single line with code == 1, this is a line with a note.
dat <- dat[dat$code != 1,]

### Make dat numeric category code:
dat <- add_column(dat, 
                  catn=unlist(lapply(strsplit(dat$cat, " "), 
                                     function(x) x[1])), .after = "cat")
### Add shorter numeric category code:
dat <- add_column(dat, catn0=substr(dat$catn, 1, 4), .after="catn")

### Build numeric code - name table:
dat_cats <- as.data.frame(str_split_fixed(dat$cat, " ", 2))
names(dat_cats) <- c("Code","Name")
### Save numeric code - name table
write.xlsx(dat_cats, "Data/CPI codes and names.xlsx")

### Strip out code name from CPI indices table:
dat$cat <- str_split_fixed(dat$cat, " ", 2)[,1]
### Drop code col:
dat$code <- NULL
dat$cat <- NULL
### Rename some columns for exercise purposes:
names(dat)[names(dat)=="catn"] <- "CODE"
names(dat)[names(dat)=="catn0"] <- "Short code"
names(dat)[3:ncol(dat)] <- paste0("i",names(dat)[3:ncol(dat)])
### Save index data file example:
write.xlsx(dat, "Data/CPI indices example.xlsx")


# ### Weights
# wgt <- read_excel("~/Downloads/consumerpriceinflationdetailedreferencetables.xls", sheet = "Table 11", skip = 23)
# wgt[,1] <- NULL
# colnames(wgt)[1] <- "code"
# colnames(wgt)[2] <- "cat"
# 
# ### Read col names for cols 3: separately and replace:
# cnames <- read_excel("~/Downloads/consumerpriceinflationdetailedreferencetables.xls", sheet = "Table 11", skip=5,n_max=1,col_names=FALSE)[1,]
# cnames <- as.data.frame(cnames)
# cnames <- cnames[1,]
# names(cnames) <- NULL
# cnames <- gsub("\n", " ", cnames)
# cnames <- gsub("  ", " ", cnames)
# names(wgt)[3:ncol(wgt)] <- cnames
# 
# ### Ignore lines with missing "code, which are blank lines in the raw data
# wgt <- wgt[!is.na(wgt$code),]
# ### Keep only rows with code length == 4
# wgt <- wgt[nchar(wgt$code)==4,]
# ### Make wgt numeric category code:
# wgt$catn <- unlist(lapply(strsplit(wgt$cat, " "), function(x) x[1]))
# 
# ### Indices for 2016-2020 only
# dat2 <- dat[,c("code","cat","catn","2016")]
# wgt2 <- wgt[,c("code","cat","catn","2016")]
# 
# 
# test <-dat2 %>% 
#   left_join(wgt, by = "catn")
# 
# write.csv(test, "~/Documents/docs/test.csv")
