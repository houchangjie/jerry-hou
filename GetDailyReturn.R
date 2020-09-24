rm(list=ls())
library(Rblpapi)
library(mplot)
library(readxl)
library(stringr)
library(dplyr)
library(xts)

blpConnect() 

StartDate=as.Date("2020-08-01")
EndDate=as.Date("2020-08-17")
#Matrix<-bdh(securities = list[sort.list(list)], 
#           fields="PX_LAST",
#           start.date=as.Date("2020-03-01"),
#           include.non.trading.days = FALSE)


#datxts <- lapply(Matrix, function(d) xts(d[,-1], order.by=as.Date(d[,1])))
#res <- do.call(merge, datxts)
dir = "C:/Users/jhou/Desktop/R Scipt/Kelly/Old version/V1/"
#colnames(res) <-list[sort.list(list)]  
datafile <- paste(dir,"inputKelly.xlsx",sep="")
data<-read_excel(datafile ,sheet="Ticker",col_names = TRUE)
list1<-pull(data,var=1)

#list<-pull(raw,var=1)
opt <-c("periodicitySelection"="DAILY","nonTradingDayFillOption"="NON_TRADING_WEEKDAYS","nonTradingDayFillMethod"="PREVIOUS_VALUE") 
blpdata <- bdh(list1,"CHG_PCT_1D",start.date=StartDate,end.date=EndDate,options = opt)
datxts <- lapply(blpdata, function(d) xts(d[,-1], order.by=as.Date(d[,1])))
res <- do.call(merge, datxts)
colnames(res) <-list1
Daily<-res
Daily1<-Daily/100
Daily1[is.na(Daily1)]<-0
write.csv(Daily1,"dailyRet.csv")

