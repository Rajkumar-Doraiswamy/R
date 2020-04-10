## Last amended: 27/09/2018
## Myfolder: C:\Users\ashok\OneDrive\Documents\bigDataLessons\3-dayclasses

## Objective:
#         1. Quick introduction to dplyr
#         2. Learning dplyr verbs

## dplyr tutorial
# 	select (col1, col2)    		     # Select specifc columns
#   select (-c(col1, col2))    	   # Remove specifc columns
#	  filter (col1 == "someValue")	 # Select only those rows that match criteria
#                                  #   It is not filter-out 
#   df %>% select (.....) %>% filter (.....)  # Pipe data into 'select' and the result into filter
#	  df %>% filter (.....) %>% select (.....)  # Pipe data into 'filter' and from result select some columns
#   df %>% group_by(x) %>% summarise (mean(y)) # Pipe data into group_by and then into summarise
#          Grouping and summarization go together. Group a column	
#          and then summarise its values in another column				

#----------------Learn to use dplyr------------------
#### Quick experimentation with dplyr ##################
library(dplyr)
# 1. Create a simple dataframe of six columns and look at it
df<-data.frame(
               x=c("A","A","A","B","B","C"),
               y = c(1,1,2,2,3,4),
               z=c("Delhi","Abd","Abd","Delhi","Kolkatta","Abd"))
df	
				 
## 2. Usual filters, restricting rows to display
# 2.1 Filter all rows with x == 'A'
df %>% filter (x == "A")

## 3.

# 3.1 Filter all rows with x == 'A' OR z=='Delhi'
df %>% filter (x == "A" | z=="Delhi")

# 3.2 Filter all rows with x == 'A' AND y >= 2
df %>% filter (x == "A" & y >= 2)

## 4.
# 4.1. Select specific columns and then filter
df %>% select (x,y) %>% filter (x=="C")

# 4.2 Select all columns from x to z and then filter
df %>% select (x:z) %>% filter (z == "Abd")

# 4.3 Reorder columns
df %>% select (z,everything()) %>% filter (z == "Abd")	

## 5.
# 5.1 Group and summarise
df %>% select (x,y) %>% group_by(x) %>% summarise (m=min(y))
df %>% select (x,y) %>% group_by(x) %>% summarise (m=min(y),cn=n())	# Also count no of rows per group

# 5.2
df %>% select (x,y,z) %>% group_by(x) %>% summarise (m=min(y),ma=max(y))
df %>% select (x,y,z) %>% group_by(x,z) %>% summarise (m=min(y),ma=max(y))

## 6. Sampling
# 6.1 Sample 3 data points or a fraction of 0.5
df %>% sample_n(3)
df %>% sample_frac(0.5)

## 7. Create a new column
# 7.1 Create a new column which is sqrt of y. mutate() creates a new column.
df %>% mutate(sy=sqrt(y))

## 8. Sort rows
# 8.1
df %>% select(x,y) %>% arrange(y)	# Sort by y
# 8.2
df %>% select(x,y,z) %>% arrange(desc(y,z)) # by y and z descending
# 8.3
df %>% select(x,y,z) %>% arrange(y,z)	# by ascending
# 8.4
df %>% select(x,y,z) %>% arrange(y,desc(z))	# y ascending, z descending

## 9. Join two tables
# 9.1 Create two data frames
#     Column id is common column among both dataframes
df<-data.frame( id=1:6,
		x=c("A","A","A","B","B","C"),
		y = c(1,1,2,2,3,4),
		z=c("Delhi","Abd","Abd","Delhi","Kolkatta","Abd"))  # Create a quick data frame

df1<-data.frame(id=1:6,
		y = c(1,1,2,2,3,4),
		s=c("AS","AS","BS","BS","CC","DD")
		)

# 9.2 Now feed 'df' into left_join and join with df1 on id.
df %>% left_join(df1,by="id")

# 10 Select all but few columns
# 10.1
mtcars %>% select (-c(disp,cyl)) %>% head()

# 10.1 Reorder columns
mtcars %>% select (wt,qsec, everything()) %>% head()

# 10.2 Difference between tibble and DataFrame
#  Convert mtcars dataframe to tibble
mt<-as_data_frame(mtcars)

# 10.3 Now subset one column of each, mtcars and mt
#  and see the results
mtcars[mtcars$cyl > 6, 2]  # Output a vector
mt[mt$cyl > 6, 2]          # Output a tibble

# 10.4 Using if_else of dplyr to create a column
mtcars %>%
          mutate( y = if_else(hp > 80, "1", "0", "NA_missing_" )) -> mr


########################################################


