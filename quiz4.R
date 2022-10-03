#question 1
library("sqldf")
library("dplyr")
url1 <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"
setwd('/Users/dengxiaoyan/Documents/Rstudio/Getting and Cleaning Data/')
f1 <- file.path(getwd(), "housing.csv")
download.file(url1, f1)
housing <- data.table::fread(f1)

ss <- strsplit(names(housing), split = "^wgtp")
ss[[123]]

#question 2
url2 <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv"
setwd('/Users/dengxiaoyan/Documents/Rstudio/Getting and Cleaning Data/')
f2 <- file.path(getwd(), "gdp4.csv")
download.file(url2, f2)
gdp <- read.csv(f2, nrow = 190, skip = 4)
gdp <- gdp[,c(1, 2, 4, 5)]
colnames(gdp) <- c("CountryCode", "Rank", "Country", "Total")
gdp_amount<- as.integer(gsub(pattern=",",replacement="",gdp$Total))
mean(gdp_amount, na.rm = TRUE)
grep("^United",gdp$Country)

#question 3
url3 <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv"
f3 <- file.path(getwd(), "edu4.csv")
download.file(url3, f3)
edu <- read.csv(f3)
gdpedu <- merge(gdp, edu, by = 'CountryCode')
FiscalJune <- grep("Fiscal year end: June", gdpedu$Special.Notes)
nrow


#question 4
library(quantmod)
amzn = getSymbols("AMZN",auto.assign=FALSE)
sampleTimes = index(amzn)
amzn2012 <-grep("^2012",sampleTimes)
amzn2012[weekdays(amzn2012) == "Monday"]
