# Last amended: 30/09/2018
# My folder: C:\Users\ashokharnal\OneDrive\Documents\bigDataLessons\3-dayclasses\data_exploration\bankmarketing
#
# 
# Why data Collection by banks?
#     i)  To retain existing customers and make new ones
#     ii) To detect fraud in dealings
#    iii) To support marketing campaigns for new products
#     iv) To diversify in insurance/ medical care and other finacial-sectors
#
#
# Objectives:
#           A. How to read a csv file
#           B. How to look at data-structure
#           C. How to access slices of data
#           D. How to calculate frequency distribution
#           E. How to aggregate data
#           F. Basic plotting
#           G. Statistical tests


# 0. Remove all earlier variables and
#    collect garbage from memory
rm(list = ls()) 
gc()
invisible(gc())

# 1
# Set all libraries that we will use
# Install them using RStudio as:
#   Tools->Install Packages...
#    in the text box write:   dplyr,prettyR,ggplot2 
#     and then press 'Install' button
library(dplyr)     # For glimpse()  (structure) and sample_n functions
library(prettyR)   # For describe() (similar to summary function)
library(corrplot)  # For correlation plots


# 2      ******IMPORTANT*******
# Set path to your data files (change it appropriately for your machine)
#   Note the use of forward slash (/) in the path statement
# 2.1
setwd("C:/Users/ashok/OneDrive/Documents/bigDataLessons/3-dayclasses/data_exploration/bankmarketing")
# OR, this
setwd("C:\\Users\\ashok\\OneDrive\\Documents\\bigDataLessons\\3-dayclasses\\data_exploration\\bankmarketing")

# Just Check what path has been set
# 2.2 Note the forward-slash that appears in the output. 
getwd()

#2.3
# List all files in current directory
#  Are these actually the files in your folder?
dir()


# 2.4
#  Read bank-full.csv file into some variable 'bankdata'.
#    Fields are separated by semi-colon
# 2.4.1 Try this first
bankdata<-read.table("bank-full.csv")
View(bankdata)

# 2.4.2 Try next
bankdata<-read.table("bank-full.csv", sep = ";")
View(bankdata)

# 2.4.3 Finally try
bankdata<-read.table("bank-full.csv", header=TRUE, sep=";")
View(bankdata)

#******************
# 3. Have a look at data 
#******************

# 3.1
# See some data
View(bankdata)    # Note that 'V' of View is capital
head(bankdata)		# Display some starting rows
tail(bankdata)		# Display rows from tail-end

# 3.2
# Data dimesion: How many rows and columns?
dim(bankdata)		  #  45211 rows and 17 columns
ncol(bankdata)		# Number of columns: 17
nrow(bankdata)		# Number of rows: 45211

# 3.3
# Check data type of variable 'bankdata'
class(bankdata)   # It is data.frame

# 3.4
# What is the structure of 'bankdata'
str(bankdata)         # How many are integers, how many are factors 
glimpse(bankdata)


# 3.4.1 How factor saves memory
h <- rep(c("a", "b"), 10000000)
object.size(h)                   # 160000136 bytes
object.size(as.factor(h))        # 80000512 bytes


# 3.5
# Row and col names
row.names(bankdata)	  # Rownames
names(bankdata)		    # Again column names
colnames(bankdata)	  # Column names

# 3.6
# 3.6.1 See a data point at row 5, column 6
bankdata[5,6]

## 3.6.2 Square-bracket operator
#         Look at first five rows
bankdata[1:5,]

## 3.6.3 Look at first few colnames
names(bankdata)[1:5]
dim(bankdata)[2]


# 3.7 Select just 'job' column from the dataset
bankdata[,'job']

# 3.7.1 OR, as
bankdata$job

# 3.7.2 Or, as
bankdata['job']

# 3.7.3 bankdata, after all, is a list. Try
bankdata[['job']]

# 3.7.4 Also, check
bankdata[[2]]


# 3.8 Select multiple columns
#     Select job and age
bankdata[c('age','job')]

# 3.8.1  Subset of two columns
#        Chaining
bankdata[c('age','job')][c(1,5,8),]
bankdata[c('age','job')][c(1,5,8),][,2]

# 3.8.2 Look at only job (1) and marital (3) columns
bankdata[,c(1,3)]


# 3.8.3 Or use dplyr pipe, as:
#       Note variable names are unquoted
bankdata %>% select(job, marital) %>% head()

# 3.8.4 But quoted names are also OK.
bankdata %>% select('job', 'marital') %>% head()

# Apply functions
# 3.9 Find mean of numeric columns
#     Use apply
# apply:  When you want to apply a function to the rows or columns of a matrix 
#         Column-wise mean
x<-apply(bankdata[,c(1,6,10,12:15)], 2, mean)  
x

class(x)   # What if you want a dataframe

# 3.9.1 Find mean row-wise
g<-apply(bankdata[,c(1,6,10,12:15)], 1, mean)  
g


# 3.9.2 Use lapply
#       lapply - When you want to apply a function to each
#                element of a list (ie column) in turn and
#                get a list back.
h<-lapply(bankdata[,c(1,6,10,12:15)], mean)  
h
data.frame(h)



# 3.9.3  Use sapply
#        sapply: When you want to apply a function to each element
#                of a list in turn, but you want a vector back,
#                rather than a list.
x<-sapply(bankdata[,c(1,6,10,12:15)], mean)  
x
class(x)
data.frame(x)             # Got a dataframe
row.names(data.frame(x))  # But colnames are row names




# 3.9.4 What are the unique values in each factor
#       Function sapply(), applies a function to
#       each column of dataframe and gives results
ifac<-sapply(bankdata, is.factor)   # Apply is.factor() to each column
ifac   # It is a vector
sapply(bankdata[, ifac], unique)    # Apply unique() to each column


# 3.9.6 Get sum of each numeric column
ifnum <-sapply(bankdata, is.numeric)
ifnum
sapply(bankdata[,ifnum], sum)





#******************
# 4. Slice data
#******************

## Slice data
# Only look at all those rows data where job = management

# 4.1
## Which rows have values 'management'. Note double equal to (==)
#  Returns TRUE or FALSE
bankdata[,'job']=='management'   

# 4.1.1 Get these values in a variable to get complete data
myvalues<-bankdata[,'job']=='management'
bankdata[myvalues,]
head(bankdata[myvalues,])


# 4.1.2 Or write directly as
bankdata[bankdata[,'job']=='management',]
OR
bankdata[bankdata$job=='management',]


# 4.2
# Look at those rows where age > 21
bankdata[bankdata[,'age']> 21,]		# Try first bankdata[,'age']> 21

# 4.2.1 OR
bankdata[bankdata$age > 21,]


# 4.3
# Look rows 42 to 78 of job and marital columns
bankdata[c(42:78),c(1,3)]
# OR
bankdata[c(42:78),c('job','marital')]


# 4.4 Problem with below line as age_level is defined only in para 5.1.3 (below)
# Assign those who are "young" and whose education level is 'unknown;
#  education of "secondary"
#   Filter age_level wise and education wise
g<-bankdata[bankdata$age_level=="middle" & bankdata$education == "unknown"    ,]
head(g)

# 4.5 Create a logical vector as per filter
lv<-bankdata$age_level=="senior" & bankdata$education == "unknown"
bankdata[lv,]$education <-"secondary"


#***************************
# 5. Frequency distribution
#***************************

# 5.1
# 5.1.1 Examine distribution of individual factors
#       No of persons with various qualifications
# 5.1.2 See frequency of each education level among population
#       Use table() command:
table(bankdata$education)  # What to do with 'unknown' value


# 5.1.3 Divide/cut age into three discrete levels
bankdata$age_level=cut(bankdata$age,3,labels = c("young","middle","senior"))

# 5.1.4 Specify breaks explicitly:
min(bankdata$age)
max(bankdata$age)
#  Breaks are (0,30]; (30, 50]; (50,95]
f<-cut(bankdata$age,breaks = c(0, 30, 50, 95),labels=c("y","m","h"))


# 5.1.5 See distribution of education vs age
#         And the fill up education, age-level wise
table(bankdata$education,bankdata$age_level)



#******************
# 6. Aggregate data
#******************

##
## GETTING TWO SUMMARIES TRY IT ALSO
## p<- aggregate(age ~ marital,
##                 data = bankdata,
##                 FUN = function(bankdata) c(mn = mean(bankdata), n = length(bankdata) ) )
##


# 6.1
########## Explore individual variables #################
# Summarise. Note the differences between summary of
#   numerical and categorical data 
summary(bankdata)
describe(bankdata)

# 6.2
#   Aggregate is more general form of table.
#    class of aggregate is data.frame
#     Aggregate  age, marital status wise
# 6.2.1 Break 'age' as per (or 'by') 'marital' status and find mean
aggregate(age ~ marital, mean , data=bankdata)
aggregate(age ~ marital, length , data=bankdata)  # How many per group


# 6.2.1.1 Same as above but using tapply()
#         Apply a function to each group of values (age)
#         given by levels of certain factors (marital).
tapply(bankdata$age, bankdata$marital,mean)
tapply(bankdata$age, bankdata$marital, length)  # How many per group


# 6.2.2   Group 'balance' by 'job' and find mean
aggregate(avgyearlybalance ~ job ,mean, data=bankdata)

# 6.2.3  Group and Sort it
#        arrange() is dplyr function
aggregate(avgyearlybalance ~ job , mean, data=bankdata) %>% arrange(avgyearlybalance)
aggregate(avgyearlybalance ~ job , mean, data=bankdata) %>% arrange(job)

# 6.2.4 Group by multiple variables: Group age by marital
#       status and housing
aggregate(age ~ marital+hashousingloan, mean , data=bankdata)

# 6.2.5 Summarise multiple variables grouping by a single variable
aggregate(cbind(age,avgyearlybalance) ~ marital, mean , data=bankdata)

# g<-aggregate(balance ~ job ,mean,data=bankdata)
# ggplot(data=g,mapping = aes(x=job,y=balance)) + geom_bar(stat="identity")

# 6.2.6 Little Advanced
aggregate(cbind(avgyearlybalance,contactDuration) ~ job+education+hashousingloan ,mean,data=bankdata)
# 6.2.7
aggregate(cbind(age,avgyearlybalance) ~ marital, mean , data=bankdata)
# 6.2.8
aggregate(.  ~ marital, mean , data=bankdata)


########## Some statistical operations #################
########## Explore multiple variables #################

# 7 Relationships
# 7.1 Between numerical variables
#     Correlation between numerical age, balance and duration
cr <- cor(bankdata[,c(1,6,12)])
cr

# 7.2 Draw correlation graphs
corrplot(cr)


# 7.3 Between categorical variables
# Chi-sqaure test
# Is there a relationship between 'has housing loan?' 
#   and 'has personal loan?'
# Get a contingency table
p<-table(bankdata$hashousingloan,bankdata$haspersonalloan)
p

# 7.2  Better still give names to rows and columns
p<-table("Has housing loan?"=bankdata$hashousingloan,
         "Has personal loan?"=bankdata$haspersonalloan)
p # Contingency table


# 7.3
# Apply chisquare test
chisq.test(p)


# 7.4 What is the p-value for two random categorical variables
#     Code contibuted by Piyush Ranjan of Big data II batch
v=cut(runif(45211),3,c("a","b","c"))
d=cut(runif(45211),3,c("f","g","h"))
chisq.test(v,d)



# 7.5
#  Compare two means
# Are the means of 'balance' different for those with 'yes' 
#  and with 'no' hosuing loan
sample1<-bankdata[bankdata$hashousingloan == "yes",]$avgyearlybalance
sample2<-bankdata[bankdata$hashousingloan == "no",]$avgyearlybalance
t.test(sample1,sample2)



#******************
# 8. Plotting data
#******************
library(ggplot2)   # For plotting

# 8.1
# Histogram of numerical variables, such as, age
#     Specify number of bins with breaks = 20
#      Also show labels
hist(bankdata$age, labels = TRUE)
# Have 10 bins
hist(bankdata$age,breaks=10, labels = TRUE)

# 8.2
# Get information about plotted histogram
histinfo<-hist(bankdata$age,breaks=10)
histinfo


# 8.3 Create a relative frequency graph
library(lattice)          # Use library lattice
histogram(bankdata$age)
densityplot(bankdata$age)

densityplot( ~ balance | y, data = bankdata)
densityplot( ~ duration | y, data = bankdata)


# 8.3
# MAke a density, not frequency histogram
#   Read density points on y-axis
#     Sum of areas must total to 1
histinfo<-hist(bankdata$age,freq=FALSE)
histinfo

# 8.4
# Transform data and then plot
hist(log10(bankdata$age),breaks=20)

# 8.5
# Density plot using Base R
plot(density(bankdata$age))

# Superimpose normal distribution on histogram
#    dnorm is for density distribution function
# hist(bankdata$age,freq=FALSE)
# Note that in dnorm(), we have not specified 'x'. Default values are taken 
#   from the x-limits used from the previous plot. (see ?curve)
# curve(dnorm(x, mean=mean(bankdata$age), sd=sd(bankdata$age)), add=TRUE, col="darkblue", lwd=2) 

# 8.6
# Frequency of values in column education
table(bankdata$education)
# Draw a pie chart of education (levels) factors
pie(table(bankdata$education))
# Or draw a simple barplot of categorical data
pie(table(bankdata$education))
barplot(table(bankdata$education))
barplot(table(bankdata$marital, bankdata$housing))  # Stacked barplot
legend("topright", legend=c("a","b","c"))
legend("bottom", legend=c("single","married","divorced"), fill=c("lightgray","gray","darkgray"))

# 8.7
# Draw boxplots maritl status wise 
#   X-axis (independent) has categorical variable 
boxplot(age ~ marital,  data=bankdata)

# Draw scatter plot between age and balance
plot(bankdata$balance,bankdata$age)


# 8.8
# Or use ggplot() to draw a good bar-plot
ggplot(bankdata, aes(x = education)) + geom_bar()
# Bar plots of two categorical variables: education and job
ggplot(bankdata, aes(x = education,fill=job)) + geom_bar()
# Or barplot with proportion of jobs education wise
ggplot(bankdata, aes(x = education,fill=job)) + geom_bar(position="fill")

# 8.9
# Draw boxplots maritl status wise 
#   X-axis (independent) has categorical variable 
ggplot(bankdata,aes(x=marital,y=age))+geom_boxplot()
# You can draw a single boxplot() with imaginary
#   categorical variable on x-axis
ggplot(bankdata,aes(x=factor(0),y=age))+geom_boxplot()

# 8.10
# Plot density graph of counts of education (x-axis), job-wise
ggplot(bankdata, aes(x = education, color = job)) + geom_density()

# 9. gc() Garbage Collector output:
#    The max used column shows that you started with certain memory
#      sometime during startup R was using more memory,
#       and the gc trigger shows that garbage collection
#        will happen when you get above certain number of Ncells or
#           Vcells.
# 9.1 Remove/delete all objects from memory
rm(list = ls()) 
gc()

################# FINISHED #####################

## Diference between & and &&
# The shorter ones are vectorized, 
#  meaning they can return a vector, like this:
# Note: (-2:2) => -2, -1, 0, 1, 2
# Also -2 > 0 & -2 > 0  returns FALSE
  
  ((-2:2) >= 0) & ((-2:2) <= 0)
# [1] FALSE FALSE  TRUE FALSE FALSE

# The longer form evaluates left to right examining
#   only the first element of each vector, so the above gives

((-2:2) >= 0) && ((-2:2) <= 0)

# [1] FALSE

