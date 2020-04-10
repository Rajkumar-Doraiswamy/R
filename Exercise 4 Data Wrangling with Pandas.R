rm(list=ls())
library(ggplot2)
library(ggthemes)
library(dplyr)
options(scipen=999)   
options(max.print=999999)
setwd("D:/Raj/Training/Big Data/Datavisualisation")
list.files()
xx<-read.csv("MELBOURNE_HOUSE_PRICES_LESS.csv", header=T)
colnames(xx)
View(xx)
head(xx, 4)
dim(xx)
str(xx)
summary(xx)
sum(is.na(xx))
is.na(xx)
##Plot the graph of top 10 suburbs by the number of houses. Which suburb has maximum number of houses?
top10sub<-xx %>% group_by(Suburb) %>% summarise(n=n()) %>% arrange(desc(n)) %>% head(10)
top10sub
plottop10sub<-ggplot(data=top10sub,aes(reorder(Suburb,n),n))+geom_bar(stat = "identity")+coord_flip()
plottop10sub
##top 10 suburbs according to the average price of houses
f<-xx %>% select(Suburb,Price) %>% na.omit()
g<-f %>% select(Suburb,Price) %>% group_by(Suburb) %>% summarise(avg=sum(Price)/n()) %>% arrange(desc(avg)) %>% head(10)
g
h<-xx %>% select(Suburb,Price) %>% filter(Suburb=="Balwyn") %>% na.omit() %>%summarise(ag=sum(Price)/n())
h
k<-xx %>% select (Suburb,Price,Address) %>% na.omit() %>% filter(Suburb=="Balwyn") %>% count(Address, sort=TRUE)
k  
?count
m<- xx%>% select (1:5) %>% filter(Address=="10 Myambert Av")
m
plottop10sub1<-ggplot(g,aes(reorder(Suburb,avg),avg))+geom_bar(stat = "identity")+coord_flip()
plottop10sub1
################################
#####Plot the price trend in Melbourne (Distribution of Price by date and average price trend).
library(lubridate)
