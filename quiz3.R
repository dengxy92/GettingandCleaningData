#question 1
library("sqldf")
setwd('/Users/dengxiaoyan/Documents/Rstudio/Getting and Cleaning Data/')
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"
f <- file.path(getwd(), "q1.csv")
download.file(url, f)
data1 <- data.table::data.table(read.csv(f))
agricultureLogical <- with(data1, c(ACR == 3 & AGS==6))
head(which(agricultureLogical))

#question 2
library(jpeg)
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fjeff.jpg"
z <- tempfile()
download.file(url, z, mode="wb")
pic <- readJPEG(z, native=TRUE)
quantile <- quantile(pic, probs=c(0.3, 0.8))
rbind(quantile)

#question 3
library("sqldf")
library("dplyr")
url1 <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv"
url2 <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv"
setwd('/Users/dengxiaoyan/Documents/Rstudio/Getting and Cleaning Data/')
f1 <- file.path(getwd(), "GDPdata.csv")
f2 <- file.path(getwd(), "Edata.csv")
download.file(url1, f1)
download.file(url2, f2)
gdp <- data.table::fread(f1, skip = 5,nrows = 190, select = c(1, 2, 4, 5),
                col.names=c("CountryCode", "Rank", "Country", "Total"))
edu <- data.table::data.table(read.csv(f2))
gdp <- gdp[5:195,]
gdpedu<- merge(gdp, edu, by="CountryCode")
nrow(gdpedu)
country <- select( gdpedu, Rank, Country,)
des_country <- arrange(gdpedu, desc(Rank))
des_country$Country[13]

#question 4
high1 <- filter(gdpedu, Income.Group == "High income: OECD")
high2 <- filter(gdpedu, Income.Group == "High income: nonOECD")

h1 <- mean(high1$Rank)
h2<- mean(high2$Rank)
#question 5
breaks <- quantile(gdpedu$Rank,probs = seq(0, 1, 0.2) )
gdpedu$quantileGDP <- cut(gdpedu[, Rank], breaks = breaks)
table(gdpedu$quantileGDP,gdpedu$Income.Group)

