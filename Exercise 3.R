rm(list=ls())
setwd("D:/Raj/Training/Big Data/Certificate in Big Data Analytics for Business and Management/Ex 3")
getwd()
list.files()
TR<-read.csv("train.csv")
TR
TR<-read.csv("train.csv", header=T)
TR
View(TR)
dim(TR)
head(TR)
ncol(TR)
nrow(TR)
TR<-read.csv("train.csv", head=7)
TR
?head
head(TR,n=7)
tail(TR,n=8)
colnames(TR)
str(TR)
count(ncol(TR))
levels(factor(TR$col))
unique(TR$col)
names(table(TR$col))
levels(TR)
summary(TR)
class(TR)

aa<-read.csv("train.csv",header=T)
aa
colnames(aa)
bb<-aa[c(3,5,7)]
bb
bb<-aa[c(1:6),c(1:5)]
bb
bb<-aa[c(10,15,20),c(3,5,10)]
bb
?mean
x=mean(aa$SalePrice)
x
install.packages("dplyr")
aa %>% group_by(SaleType) %>% summarise(avg=mean(SalePrice))
library(dplyr)
aa %>% group_by(YrSold) %>% summarise(avg=mean(SalePrice))
install.packages("ggplot2")
library(ggplot2)
library(ggthemes)
library(corrplot)
ggplot(aa,aes(x=EnclosedPorch))+geom_histogram(bins=10)+scale_x_log10()
?table
table(aa$MSZoning,aa$Street)
u<-as.numeric(aa$MSZoning)
u
cr<-cor(u,aa$SalePrice)
cr
