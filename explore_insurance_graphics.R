# Last amended: 1/10/2018
# Myfolder: C:\Users\ashokharnal\OneDrive\Documents\insurance
# Kaggle link: https://www.kaggle.com/mirichoi0218/insurance
## Moodle page: Data Visualization->Feature plotting
##############################################################################
# Data Source:  https://github.com/stedy/Machine-Learning-with-R-datasets
# ggplot intro: https://www.ling.upenn.edu/~joseff/rstudy/summer2010_ggplot2_intro.html
#

##############################################################################
# Objectives
#        Data visualization for exploration
#        Insurance data
#          Data Attributes:   age, sex, bmi,
#                             children, smoker, region, charges, age_class
#                             bmi: Body mass index (BMI) is a measure of
#                             body-fat based on ht and wt. It applies to
#                             adult men and women
#       Types of plots:
#          Bar plot:       Counts/Distribution of levels of one categorical variable
#                          Counts/Distribution of levels of one category within another
#                          (smoker within each region)
#          Histograms:   | Distribution of continuos variable in bins
#          Density plots:| Interval-wise fraction of data
#                          (ie within certain interval of charges, what fractions of persons exist)
#          Scatterplots:   Relationship between two continuous variables
#  
#          Boxplots:       Relationship between categorical and continuous variables 
#          Heatmap:        Relationship between two categorical variables
#                          and a continuous variable
#          Facets:         Show subsets of data on panels, wrapping-wise or grid-wise
#                          Subsets can be based on one-category or two-categoires
#####################################################################################
# 1. Remove objects from R memory and collect garbage
rm(list=ls()) ; gc()

# 2. Call libraries
library(ggplot2)   # For plotting functions
library(ggthemes)	 # For a variety of plot-themes
library(dplyr)     # verbs: select, filter, mutate, group_by, summarise


# 2.1 Specify options
options(scipen=999)         # Avoid exponential notations
options(max.print=999999)   # For tibble, it is df %>% tbl_df %>% print(n=400)


# 3. Set working directory to where your data files are.
#     Note the forward slash below.
setwd("C:/Users/ashok/OneDrive/Documents/insurance")
setwd("D:\\data\\OneDrive\\Documents\\insurance")

# 3.1 Check what files are there in the working folder
#     You can use dir() also
list.files()


# 3.2 Read insurance dataset from working folder 
#      Argument, header, by default is TRUE; so also sep =","
insurance<-read.csv("insurance.csv", header = T)   


#*****************
## 4. OBSERVE DATA --------------------------
#*****************

# 4.1
# Have a look 4 records of data before plotting
head(insurance, 4)

# OR

View(insurance)

# 4.2 Get data structure
#     So how many are factors and how many numeric?
str(insurance)

# 4.3
# Summarize data. So, which num data is highly skewed (see median)
#  And which categorical data is unbalanced. Are there any missing data?
#  Should 'children' be numeric or categorical? Can there be 0.5 child?
summary(insurance)


# 4.4
# Get names of column headers
#   As an aside, what does 'names(insurance)[3]' give you?
names(insurance)

# 4.5 Is there any missing data
#     is.na(insurance), checks each element and returns
#      TRUE or FALSE. TRUE is treated as 1 by sum()
is.na(insurance)
sum(is.na(insurance))



# 4.6 Feature Engineering 
#     Convert age into three classes, young, middle and senior
insurance$age_class<-cut(insurance$age, 3,labels = c("young", "middle","senior"))


# 4.6.1 Also similarly transform, bmi
insurance$bmi_level<-cut(insurance$bmi,3,label=c("low", "medium", "high"))



# 4.7 Check now
head(insurance)


#*****************
## 5. Bar plots   ------Category wise counts-------------
#*****************

# 5. BAR PLOT  --------------------------
#    It is a distribution plot only for a factor variable.
#     It depicts by its height, category wise counts
#      Width of bar chart is unimportant-A category has no width
#       And unlike histograms for continuous variables, bar-charts
#        may not touch each other. In a histogram where a bin-boundary
#         finsihes, another one begins. So histograms must touch one another
# 5.1
# Plot bar chart of 'smoker' categorical data 
#       ggplot() may contain data/variables common to all layers
#       aes() stands for visual properties of graphs. It maps variables
#         to visual properties. ggplot also adds a legend explaining which
#          levels of variables map in what manner.
#       geom_bar() contains any data/variables/constants
#               but specific only to barplot layer and not to other layers
#  

ggplot(data=insurance, aes(x=smoker)) +             # Draws a window
  geom_bar()                                        # What geomtery? A bar-chart layer


# 5.2 We can put data variables in geom_layer also

ggplot() +                                           # Just draw a window
  geom_bar(data=insurance, aes(x=smoker))            # Draw layer  


# 5.3
# A plot can also be assembled in pieces

abc<-ggplot(data=insurance, aes(x=smoker))                # piece 1
abc<-abc + geom_bar()                                     # piece 1 + 2
abc


# 5.4 Three layers. Specify 'bar' related parameters in geom_bar()

ggplot(data=insurance, aes(x=smoker)) +            # Opens window
  geom_bar(width=0.5,color="red",fill="yellow") +  # Parameters specific to bar-layer  
  theme_solarized()                                # Layer of theme


#*****************
# 6. STACKED BAR CHARTS -------Distribution of one category within another----------------
#*****************
# Stacked bar chart can be used:
#      i)  to compare counts of categorical vriables
#          within another (yes/no smokers in northwest)
#      ii) to compare any summary measure of one categorical variable
#          within another (avg bmi of smokers in northwest)

# 6.1 Count of smokers, divided grouped by region

ggplot(data=insurance, aes(x=smoker, fill=region)) +
  geom_bar()	


# 6.2 Smokers, age_class wise, but side-by-side plots

ggplot(data=insurance, aes(x=smoker, fill=age_class)) +
  geom_bar(position="dodge")	


#  6.3 Flip plot/coordinates

ggplot(data=insurance, aes(x=smoker, fill=region)) +
  geom_bar() +
  coord_flip()


# 6.4 But I want bar heights for smokers to be represented
#      by another continuous variable say, mean of bmi
#       Bar heights represented as mean of 'bmi'

# 6.4.1

insurance %>% group_by(smoker) %>% summarise(mc=mean(charges)) -> sc

# 6.4.2

ggplot(sc, aes(x = smoker, y = mc)) + geom_bar(stat = "identity") +
    labs(y ="Mean charges")


#**************************
# 7. HISTOGRAMS & DENSITY GRAPHS   ----------distribution by bins----------------
#**************************
# Histogram is a frequency distribution of a continuous variable
#  A continuos variable is divided into bins and points within each
#   bin are counted. Height of each bin is count of points within the bin

# 7.1 We will plot histogram of charges in the nw region
#      So, filter data for 'northwest' region into 'nw' variable

insurance %>% filter(region == "southeast") -> nw

# 7.2 Histogram of 'charges' with base R function: hist()
hist(nw$charges,labels = TRUE)


# 7.3 Histogram with ggplot
#     Basic plot. In logscale, eg for scale of 
#     c(1, 10,20,30,40,50,60,70,80,90,100) => Normal scale, center 50
#     c(0, 1,........................ 2)   => Normal scale,  center is 10                       
gg<-ggplot(data=nw, aes(x=charges))       # Layer of window
gg<-gg+ geom_histogram(bins=10)           # Layer of histogram 
gg
gg+ scale_x_log10()                       # Change X-scale linear to log


# 7.4 Specify now some histogram-plot related parameters
gg<-ggplot(data=nw, aes(x=charges))                    # Layer of window
gg<-gg+ geom_histogram(col = "red", binwidth = 5000)   # Layer of histogram 
gg        # This histogram is difft from that in (7.2) above use,
          # center = 2500, to specify center of atleast one histogram.


# 7.5 Distribution of charges grouped sex wise. 
#     As charges increase, females decrease and male-numbers increase
#      In geom_histogram(), default position is "stack"
ggplot(data=nw, aes(x=charges, fill=sex)) +
  geom_histogram(alpha=0.8, position="stack", binwidth = 5000)


# 7.5.1 Side-by-side
ggplot(data=nw, aes(x=charges, fill=sex)) +
  geom_histogram(alpha=0.8, position="dodge", binwidth = 5000)


# 7.6 Frequency polygon. y-axis contains counts
ggplot(data=nw, aes(x=charges,col=sex))+ geom_freqpoly(binwidth = 5000)


# 7.7 Density graph of charges with and without log scale
ggplot(data=nw ,aes(x = charges) ) + geom_density(fill = "cyan")
ggplot(data=nw ,aes(x = charges) ) + geom_density(fill = "cyan") + scale_x_log10()


# 7.8 Density plot with multiple categories (age_class wise). Try log scale also.
ggplot(nw, aes(x = charges)) +
  geom_density(aes(fill = age_class), alpha = 0.2) 




# 7.9 Magnify graph between x=25000 and and 70000 
#      to see higher levels clearly

ggplot(nw, aes(x = charges)) +
  geom_density(aes(fill = age_class), alpha = 0.2)  +
  xlim(25000,70000)    # Limit/change x-axis boundaries


#  7.10  Add a theme
ggplot(data=nw, aes(x=charges)) +
  geom_histogram(binwidth = 1000, fill="red", col="blue") +
  theme_economist()     # Plot theme



#*****************
# 8. SCATTERPLOTS --------------------------
#*****************
# Scatterplots display relationships between two continuous variables
# 8.1 Scatter plot between bmi and charges
#      Too confusing. All categories mixed together

ggplot(data=insurance,aes(x=bmi,y=charges)) +
  geom_point()   


# 8.2 First, let us draw scatter plots only for young
#     Clarity is still missing 
# Step 1 Consider data just for young persons

insurance %>% filter(age_class =="young") -> df      


# Step 2

ggplot(data=df,aes(x=bmi,y=charges)) +
  geom_point()   # Still three overlapping levels


# 8.3 Next draw scatter plots only for young and 'yes', smokers
# Step 1

insurance %>% filter(age_class =="young") %>% filter(smoker=="yes") -> df

# Step 2
#  For smokers risk increases suddenly after a certain bmi
#    (See the difference after putting smoker=="no" above)
#      Higher charges mostly concentrated between 33000-40000 belt

ggplot(data=df,aes(x=bmi,y=charges)) +geom_point()   


# 8.4 Draw scatter plots only for young->smokers->females
#     Still two levels. It shows that after bmi of 30, charges suddenly jump
#     Get data first

insurance %>% 
  filter(age_class =="young") %>%
  filter(smoker=="yes") %>%
  filter (sex=="female")-> df


# 8.41 Plot it
#     Higher charges mostly concentrated between 33000-40000 belt

ggplot(data=df,aes(x=bmi,y=charges)) +geom_point() 


# 8.42 Draw a smooth line
#      Graph confidence interval: CI is high whenever there is greater
#      uncertainity. Less the number of points, greater the uncertainty 
#      & broader the CI. Higher density of points leads to narrow CIs.

ggplot(data=df,aes(x=bmi,y=charges)) +
  geom_point() +
  geom_smooth()  # loess: (local polynomial regression) 
                 # LOWESS (locally weighted scatterplot smoothing)
                 # nearer points are given more weightage than farther away points

# 8.43 Add label to each point
ggplot(data=df,aes(x=bmi,y=charges)) +
  geom_point() +
  geom_smooth() +
  geom_text(aes(label = bmi_level))



# 8.52 Scatter plot with multiple factor variables displayed
#      Note the number of dimensions in the plot

ggplot(data=insurance,aes(x=bmi,y=charges,col=smoker,shape=sex,size=age_class)) +
  geom_point()


#*****************
## 9. Box plots   --------------------------
#*****************
# How do I see relationship of one categorical variable
#   with one continuous variable. Use boxplot

# Boxplot shows distribution of continuous data and outliers
#  Read boxplot with histogram to understand distribution properly
# IQR = Q3 - Q1
# Suspected outliers: 1.5 * IQR
# Confirmed outliers: 3 * IQR
# Lower whisker is at 1.5 * IQR below or min(x) whichever is more
# Upper whisker is at 1.5 * IQR above or max(x) whichever is less



# 9.1 Boxplot of charges, region wise. 
#      boxplot() is a 'Base' R function
#       charges: continuous variable
#       region:  factor variable
boxplot(charges ~ region, data=insurance)


# 9.2 With ggplot2
#       ggplot() contains data/variables common to all layers
#       aes() contains only data variables
#       geom_boxplot() may contain any data/variables/constants
#               specific only to boxplot layer 

ggplot(data=insurance, aes(x=region,y=charges)) +   # Open window
  geom_boxplot()                         # Layer of boxplot


# 9.3 Above plot has only major breaks at
#     0, 20,000, 40,000 and 60,000
#     We can create minor breaks by redesiging y-scale

ggplot(data=insurance, aes(x=region,y=charges)) +   
  geom_boxplot() +                         
  scale_y_continuous(
    minor_breaks = seq(0 , 70000, 2000)  # Can specify minor/major breaks
    ) 

# scale_y_continuous(breaks = seq(0,70000,10000),
#   minor_breaks = seq(0 , 70000, 2000))     # Can specify minor/major breaks
#    labels must be same length as breaks

# 9.4 Display points also. But avoid point overlapping
#      with jitter. width: amt of vertical, horiz jitter

ggplot(data=insurance,aes(x=region,y=charges)) +    # Open window
  geom_boxplot()  +            # First layer of boxplot
  geom_jitter(width=0.2)       # Second layer of points
                               #  width: Amount of vertical and horizontal jitter

# 9.5 More width

ggplot(data=insurance,aes(x=region,y=charges)) + 
  geom_boxplot() +                  # First layer of boxplot
  geom_jitter(width=0.4)            # Second layer of points
                 


## 10. HEATMAP --------------------------

# How do I see relationship of two categorical variables with
#  one continuous variable: heatmap

## Heatmap vs Stacked Bar Plots:
# One can draw a stacked-bar plot of age_class. stacked within
#  region and height of bar being represented by avg_bmi for that
#  sub-category of age_class within a region. Difference with
#   heatmap is while in heatmap the avg_bmi is represented by
#   intensity of colour, here it is represented by height of bar.

# 10.1 How does average bmi vary with age_class and with region
#      First for every region & every age_class, get mean(bmi)
#      in a table.

insurance %>% 
  group_by(region,age_class) %>%    # Group data region,age_class wise
  summarise(m_bmi=mean(bmi)) -> df  # For each group calculate mean(bmi)

# 10.2 Next draw tiles and intensity of colour is as per mean(bmi)

ggplot(df, aes(region, age_class, fill=m_bmi)) + 
  geom_tile() 

# 10.3 Colour scales can be changed with scale_fill_gradient

ggplot(df, aes(region, age_class, fill=m_bmi)) + 
  geom_tile() +
  scale_fill_gradient(low="white", high="steelblue")



#*****************
## 11. Facet grid -----------subset data in panels-------------
#*****************
# Facets display subsets of data in different panels.
#  Data can be subdivided into panels only by categorical variables
#   Sub-division can be row-wise (one category) 
#    and also column-wise (another category)
#
# facet_grid: Arrange panels in a grid (row_cat ~ column_cat)
#             (row_cat ~ .) ==> means no faceting column wise
#             (. ~ column_cat) ==> means no faceting row wise
# facet_wrap: Arrange panels in a ribbon. Ribbon will wrap around (~ cat_var)

# ** Trellis plot (facet): The Trellis graphics system in R was written by Deepayan Sarkar
#      of the University of Wisconsin, using the 'Grid' graphics system written by
#         Paul Murrell of Auckland.

# 11 Create a new categorical variable from continuous variable

insurance$bmi_level<-cut(insurance$bmi,3,label=c("low", "medium", "high"))


#### Using first  facet_grid


# 11.1 For every bmi_level and for every smoker level,
#      plot distribution of charges, age_class wise  

ggplot(data=insurance,aes(x=age_class,y= charges))+
  geom_boxplot() +
  facet_grid( bmi_level ~ smoker) # Group column wise as also row-wise


# 11.2 Making more complicated panels,
#      age_class & bmi_class (both row-wise)
#       as also smoker (but column-wise)       
ggplot(data=insurance,aes(x=age_class,y= charges))+
  geom_boxplot() +
  facet_grid( age_class + bmi_level ~ smoker) 

#### Using next  facet_wrap

# 11.3  For every 'region', draw a ribbon of boxplots
#       of charges against age_class 
ggplot(data=insurance,aes(x=age_class,y= charges))+
  geom_boxplot() +
  facet_wrap(  ~ region )   # No dot here. Wrap plots on region


# 11.4 Following two plots are same
ggplot(data=insurance,
       aes(
         x=age_class,
         y=insurance$charges
         )
       )+
  geom_boxplot() +
  facet_wrap(  ~ region + smoker )   # No dot here




#####END#############-----------------------------------
##############################################################
# EXTRA READING. NOT COVERED IN CLASS
##############################################################

# stat='identity' The identity statistic leaves the data unchanged.
# stat_count, counts the number of cases at each x position.
# If you want to bin the data in ranges, you should use stat_bin instead.
# stat_summary operates on unique x; stat_summary_bin operators on binned x.
#   They are more flexible versions of stat_bin: instead of just counting,
#     they can compute any aggregate.


## Miscelleneous

# M1. Ordering barcharts
# The barchart we want to order
ggplot(data = insurance, aes(bmi_level)) + geom_bar()

# M1.1 The barcharts are plotted in following sequence:
levels(insurance$bmi_level)    # low, medium, high

#M1.2     One way:
#        use factor() on the factor and specify the order directly 
#        Want levels to be ordered as:  "high", "low", "medium"
x<-factor(insurance$bmi_level, levels = c("high", "low", "medium"))
levels(x)
ggplot(data = insurance, aes(x)) + geom_bar()

# M1.3 IInd way
library(forcats)
ggplot(data = insurance, aes(fct_infreq(bmi_level))) + geom_bar()



# M2. Use Colour scale
# M2.1 Default colour scale
ggplot() + geom_point(data = insurance,
                      aes(x = bmi,
                          y = age,
                          col =charges)) 

# M2.2 Have your own colour scale
ggplot() + geom_point(data = insurance,
                      aes(x = bmi,
                          y = age,
                          col =charges)) +
  scale_color_continuous(low = "white", high = "red")

# M2.3
ggplot() + geom_point(data = insurance,
                      aes(x = bmi,
                          y = age,
                          col =charges)) +
  scale_colour_gradient2()


# M3. Percentage bar charts

# M3.1 Default
ggplot(data=insurance, aes(x=age_class, fill=bmi_level)) +
  geom_bar()	

# M3.2 By percentages
ggplot(data=insurance, aes(x=age_class, fill=bmi_level)) +
  geom_bar(position = "fill")	


# M4. Reordering boxplots as per median
#     Use reorder(). The method treats its first argument
#     as a categorical variable, and reorders its levels
#     based on the values of a second variable, usually numeric.

# M4.1 Order (sort) dataframe
View(insurance[order(insurance$age),])

# M4.2
# Default boxplot
ggplot(data=insurance, aes(x=region,y=charges)) +   # Open window
  geom_boxplot()                         # Layer of boxplot

# M4.3 Change order of levels
levels(insurance$region)     # generally by alphabet
reorder(insurance$region, insurance$charges, FUN = median)

# M4.4
ggplot(data=insurance, aes(x=reorder(region, charges, FUN=median),y=charges)) +
  geom_boxplot()                         


# M5. Labeling points. Avoid text overlap on the plot window.
#   Use ggrepel
#   See: https://cran.r-project.org/web/packages/ggrepel/vignettes/ggrepel.html
library(ggrepel)
# M5.1 Default
ggplot(insurance, aes(x = age, y = bmi)) + geom_point() +
  geom_text(aes(label = sex), size = 3)

# M5.2 USing geom_text_repel()
ggplot(insurance, aes(x = age, y = bmi)) + geom_point() +
  geom_text_repel(aes(label = sex), size = 3)


# M5.3 Violin plots
#    Violin plots also give distribution of data
ggplot(data=insurance, aes(x=smoker,y=charges)) +   # Open window
  geom_violin()                         # Layer of boxplot


# M6. Plot two histograms on the same window
ggplot() + 
  geom_histogram(data = insurance, aes(x =age)) +
  geom_histogram(data = insurance, aes(x = bmi, col = "red", alpha = 0.1))










###############################################



#$$$$$$$$$$$$$$
  
  # 4.6.1  Specify your age-breakpoints as (10,30], (30,50], (50,100]. 
  #        By default right break is closed and left open.
  #        Values which fall outside the range of breaks are coded as NA,
  #        as are NaN and NA values.
  #insurance$age_class<-cut(insurance$age, breaks = c( 10, 30,50,100), labels = c("young", "middle","senior"))
  #insurance$age_class<-cut(insurance$age, breaks = quantile(insurance$age), labels = c("vy", "y","m","s"))
  


abc<-ggplot(data=insurance, aes(x=smoker))                # piece 1
abc<-abc + geom_bar()                                     # piece 1 + 2
abc<- abc+ geom_text(stat='count', aes(label=..count..))  # piece 2 + 3
# What stat to display?   
abc<- abc+ geom_text(stat='count', aes(label=..count..), vjust = -1)
abc                                                       # Show assembled graph   

#        stat_summary operates on unique x. For every unique x, calculate fun.y()

ggplot(insurance, aes(x=age_class, y=bmi)) +
  stat_summary(fun.y="mean", geom="bar", fill= "yellow")        # Both bars are of same height


# 6.5 Same as above, but bar-height as per mean charges
#     Insurance charges for non-smokers are very less
ggplot(insurance, aes(x=smoker, y=charges)) +
  stat_summary(fun.y="mean", geom="bar") +
  labs(y ="Mean charges")

# 7.9 Show density instead of counts
#     y-axis contains density NOT counts
#      and group by 'sex'  : USe geom_density() + geom_rug()
gg1<-ggplot(data=nw, aes(x=charges, y=..density.. ,col=sex)) + 
  geom_freqpoly(binwidth = 5000, center = 2500)
gg1
