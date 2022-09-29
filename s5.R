# If your R uses not English language by default:
Sys.setenv(LANG = "en") # Windows
system("defaults write org.R-project.R force.LANG en_US.UTF-8") # Mac


# Questions about loops

# 1. Create a vector seq(2, by=5, length.out=300).  Using if and for functions, replace all values smaller
# than 300 with NA. Then do it without loops.

# 2. Print all squares of all numbers from -1 to 400 except those which can be divided
# by 7 without remainder (use a loop).

# 3. In the vector set.seed(2); x <- rnorm(500, 30, 15) replace values using the following principle.
# If a value is greater than 30, add -2, otherwise do nothing. Propose two solutions using
# the `if` (or `ifelse`) command and `for` + `next`.

# 4. Use the mtcars dataset. For all rows with even numbers, calculate the difference between their mpg and maximum mpg among all cars.

# There is a trick in R that is useful in some problematic settings: sequential binding.
# For example, you want to create a new vector but you don't know the final length (it can depend on some non-trivial condition)

mat <- matrix(nrow = 100, ncol = 1000, data = rnorm(100 * 1000, 0, 1))

# We want to calcualte sum of columns and if it is greater than 1 - add this sum to the first vector, if smalller or equal to 1 - add the second vector

sum_vector_1 <- NULL
sum_vector_2 <- NULL
for (j in 1:ncol(mat)) {
  ifelse(sum(mat[, j]) > 1, sum_vector_1 <- rbind(sum_vector_1, sum(mat[, j])), sum_vector_2 <- rbind(sum_vector_2, sum(mat[, j])))
}

############
# QUESTION 1
# Replicate the result without loops using vectorized subsetting of the vector.
############

############
# QUESTION 2
# Create another matrix  mat2 <- matrix(nrow=100, ncol=1000, data=rnorm(100*1000, 0.5, 1)). Create the third matrix following the rule:
# the columns of this matrix are equal to a sum of corresponding columns of mat and mat2 (creation should be made step-by-step),
# but there is an inclusion restriction: the sum of each of two columns from mat and mat2 should be greater than 1.1,
# otherwise, a new column is not created.
############

# Next, we need to learn how install packages that contain other useful functions
# (the packages can be loaded without quotation marks)
installed.packages() # List all installed packages
install.packages("sandwich") # Installs a package
install.packages(c("lmtest", "microbenchmark")) # Installing multiple packages at once

# Once a package has been downloaded and installed, we can load them im the memory
library(sandwich)
library("microbenchmark")
library("foreign")

# Working with data

# Best practice: setting the full path and then using relative paths
getwd()

# Windows
setwd("C:/Rdata")
setwd("C:/Users/username/Desktop/Research/Trust") # Note that the slashes must be forward
setwd("C:\\Users\\username\\Desktop\\Research\\Trust") # On Windows, backslashes must be escaped with another backslash

# Mac
setwd("/Users/username/Desktop/Research/Trust")
setwd("~/Desktop/Research/Trust") # A shorthand

# We can download data into R
# Here is the simplest case - csv
help(read.csv)
data_returns <- read.csv("actual_returns.csv")

# We can view data
View(data_returns)

############
# QUESTION 3
# Change the name of this series to "US_market_returns". Calculate summary statistics for returns (use the `summary`` command),
# create squared returns and estimate the correlation between them (the `cor`` command). Check the class.
############


# Data frame (taken from https://www.tutorialspoint.com/r/r_data_frames.htm)

# A data frame is a table or a two-dimensional array-like structure in which each column
# contains values of one variable and each row contains one set of values from each column.
#
# Following are the characteristics of a data frame.
#
# The column names should be non-empty.
# The row names should be unique.
# The data stored in a data frame can be of numeric, factor or character type.
# Each column should contain same number of data items.

# Create the data frame.
emp.data <- data.frame(
  emp_id = c(1:5),
  emp_name = c("Rick", "Dan", "Michelle", "Ryan", "Gary"),
  salary = c(623.3, 515.2, 611.0, 729.0, 843.25),

  start_date = as.Date(c("2012-01-01", "2013-09-23", "2014-11-15", "2014-05-11", "2015-03-27")),
  stringsAsFactors = FALSE
)

# Print the data frame.
emp.data

# Or view
View(emp.data)

# Get the structure of the data frame.
str(emp.data)

# Summary
summary(emp.data)

# Extract specific columns.
result <- emp.data[, c("emp_name", "salary")]
result
# Watch how botched the column name become if done differently
result <- data.frame(emp.data$emp_name, emp.data$salary)
result

# Extract 3rd and 5th row with 2nd and 4th column.
result <- emp.data[c(3, 5), c(2, 4)]
result

# Add the "dept" coulmn.
emp.data$dept <- c("IT", "Operations", "IT", "HR", "Finance")
v <- emp.data
v

# Create the second data frame
emp.newdata <- data.frame(
  emp_id = c(6:8),
  emp_name = c("Rasmi", "Pranab", "Tusar"),
  salary = c(578.0, 722.5, 632.8),
  start_date = as.Date(c("2013-05-21", "2013-07-30", "2014-06-17")),
  dept = c("IT", "Operations", "Finance"),
  stringsAsFactors = FALSE
)

# Bind the two data frames.
emp.finaldata <- rbind(emp.data, emp.newdata)
emp.finaldata

############
# QUESTION 4
# Using the `emp.finaldata` data frame, calculate the average wage and standard deviation for the IT and Finance departments.
############




















# We can easily do the same for all depatments using loop over string variables:
for (j in unique(emp.finaldata$dept)) {
  print(j)
  print(paste("Average salary for", j, "department is equal to", mean(emp.finaldata$salary[emp.finaldata$dept == j])))
  print(paste("Standard deviation of salary for", j, "department is equal to", sd(emp.finaldata$salary[emp.finaldata$dept == j])))
}

# Note that these two are equivalent
emp.finaldata$salary[emp.finaldata$dept == "IT"]
emp.finaldata[emp.finaldata$dept == "IT", ]$salary
# But the first syntax is better: subsetting vectors is much-much faster than subsetting matrices!


# Working with NA in data

# Create the second data frame
emp.newdata2 <- data.frame(
  emp_id = c(9:10),
  emp_name = c("Andrei", "Kim"),
  salary = c(NA, NA),
  start_date = as.Date(c("2013-04-23", "2014-07-10")),
  dept = c("Finance", "IT"),
  stringsAsFactors = FALSE
)

# Bind the two data frames.
emp.finaldata2 <- rbind(emp.finaldata, emp.newdata2)
emp.finaldata2

# Omit all rows with NA
na.omit(emp.finaldata2)



# R is capable of reading multiple data formats, including foreign and proprietary ones

?read.table
library(foreign)
?read.dta # For STATA versions 12 and under
library(readstata13) # For STATA versions 13 and above
?read.dta13 # But it is also capable of reading old formats
?read.spss # Reads from SPSS

d <- read.dta("fatality.dta")
summary(d)
head(d)

# The best way to save a data is using the CSV format with defaults
help(write.csv)
write.csv(d, "fatality.csv") # See that a column of numbers has been added, which is undesirable
write.csv(d, "fatality.csv", row.names = FALSE)

d <- read.csv("fatality.csv")

# There is a better library
# It works faster and does extra checks
library(data.table)
d <- fread("fatality.csv")
# However, it uses its own class that has more capabilities but sometimes conflicts with native R syntax
d <- as.data.frame(d)
# Or invoke it with an argument
d <- fread("fatality.csv", data.table = FALSE)

# Having a quick look at the performance
microbenchmark(d <- read.csv("fatality.csv"), d <- fread("fatality.csv"), d <- fread("fatality.csv", data.table = FALSE))

# In a data frame, columns can be renamed or cropped
d <- fread("fatality.csv", data.table = FALSE)
colnames(d)
colnames(d)[4] <- "unemp"
colnames(d)[colnames(d) == "beertax"] <- "tax"
colnames(d) <- paste0("Var", 1:ncol(d))

# One can sort the data on multiple keys
d <- fread("fatality.csv", data.table = FALSE)
d <- d[order(d$year, d$state), ]
head(d, 20)
d <- d[order(d$state, d$year), ]
head(d, 20)


# A very important package for data manipulation: dplyr

# This part of code mainly replicates the dplyr vignette
install.packages("dplyr")
library("dplyr")

# download data
install.packages("hflights")
library(hflights)

help(hflights)
flights <- hflights

dim(flights)

head(flights)

colnames(flights)

# Subseting rows with filter command.

help(filter)
# Attention: now there are two `filter` commands in the memory: one built-in, and one from `dplyr`!
# Now, should you need the old `filter`, use stats::filter
dplyr::filter
stats::filter

# For example, we can select all flights on January 1st with:
filter(flights, Month == 1 & DayofMonth == 1)

# Or we can use standard default approach.
flights[flights$Month == 1 & flights$DayofMonth == 1, ]

# You can use other logical operators:
filter(flights, Month == 1 | Month > 10)

############
# QUESTION 5
# Select all flights that occurred on January, 2nd and Febrary, 3rd from the `flights` data set
############

############
# QUESTION 6
# Select all fligths that occured on the 1st day of each of the first six months
############

# Reordering of rows in dataset. If one provides more than one column name,
# each additional column will be used to break ties in the values of preceding columns.
help("arrange")

arrange(flights, Year, Month, DayofMonth)

# Use desc() to order a column in descending order
arrange(flights, desc(ArrDelay))

############
# QUESTION 7
# Order the data in descending order: first, according to arrival time, then by arrival delay
############

# Selecting columns.

# Select columns by name.
select(flights, Year, Month, DayofMonth)

# Select all columns between year and day (inclusive)
select(flights, Year:DayofMonth)

# Select all columns except those from year to day (inclusive)
select(flights, -(Year:DayofMonth))

# Variable selection can be very complicated

# For example, select all variables which names begins with "arr".
select(flights, starts_with("Arr"))

# Regular expressions are supported!
# If you want to select x1, x2, x3
select(data, matches("x[1-3]"))

############
# QUESTION 8
# Select all columns that end with "time".
############

# New variables creating
help(mutate)

mutate(flights, Gain = ArrDelay - DepDelay, Speed = Distance / AirTime * 60)

# If you only want to keep the new variables, use transmute()
transmute(flights,
  Gain = ArrDelay - DepDelay,
  GainPerHour = Gain / (AirTime / 60)
)

############
# QUESTION 9
# Create a new variable---average flight speed
############

# Grouping

# combination with the discussed functions.
# grouped select() is the same as ungrouped select(), except that grouping variables are always retained.
# grouped arrange() is the same as ungrouped; unless you set .by_group = TRUE, in which case it orders first by the grouping variables
# mutate() and filter() are most useful in conjunction with window functions (like rank(), or min(x) == x).
# summarise() computes the summary for each group.

# Grouping by
# In the following example, we split the complete dataset into individual planes
# and then summarise each plane by counting the number of flights (count = n())
# and computing the average distance (dist = mean(distance, na.rm = TRUE))
# and arrival delay (delay = mean(arr_delay, na.rm = TRUE)).

by_tailnum <- group_by(flights, TailNum)
delay <- summarise(by_tailnum,
  Count = n(),
  Dist = mean(Distance, na.rm = TRUE),
  Delay = mean(ArrDelay, na.rm = TRUE)
)
delay <- filter(delay, Count > 20, Dist < 2000)

# You use summarise() with aggregating functions that take a vector of values and returns a single number.
# There are many useful examples of such functions in base R like min(), max(), mean(), sum(), sd(), median(), and IQR().
# dplyr provides a handful of others:
# n(): the number of observations in the current group
# n_distinct(x): the number of unique values in x.
# first(x), last(x) and nth(x, n)---these work similarly to x[1], x[length(x)],and x[n]
# but give you more control over the result if the value is missing.
# For example, we could use these to find the number of planes and the number of flights that go to each possible destination:

destinations <- group_by(flights, Dest)
summarise(destinations,
  planes = n_distinct(TailNum),
  flights = n()
)


# We can use subsequent grouping
daily <- group_by(flights, Year, Month, DayofMonth)
per_day <- summarise(daily, flights = n())
per_month <- summarise(per_day, flights = sum(flights))
per_year <- summarise(per_month, flights = sum(flights))

############
# QUESTION 10
# Calculate the average distance for each origin.
############

# Merging of datasets

authors <- data.frame(
  ## I(*) : use character columns of names to get sensible sort order
  surname = I(c("Tukey", "Venables", "Tierney", "Ripley", "McNeil")),
  nationality = c("US", "Australia", "US", "UK", "Australia"),
  deceased = c("yes", rep("no", 4))
)
authorN <- within(authors, {
  name <- surname
  rm(surname)
})
books <- data.frame(
  name = I(c(
    "Tukey", "Venables", "Tierney",
    "Ripley", "Ripley", "McNeil", "R Core"
  )),
  title = c(
    "Exploratory Data Analysis",
    "Modern Applied Statistics ...",
    "LISP-STAT",
    "Spatial Statistics", "Stochastic Simulation",
    "Interactive Data Analysis",
    "An Introduction to R"
  ),
  other.author = c(
    NA, "Ripley", NA, NA, NA, NA,
    "Venables & Smith"
  )
)


m0 <- merge(authorN, books)
m1 <- merge(authors, books, by.x = "surname", by.y = "name")

# Merging with NA
x <- data.frame(k1 = c(NA, NA, 3, 4, 5), k2 = c(1, NA, NA, 4, 5), data = 1:5)
y <- data.frame(k1 = c(NA, 2, NA, 4, 5), k2 = c(NA, NA, 3, 4, 5), data = 1:5)
merge(x, y, by = c("k1", "k2")) # NA's match
merge(x, y, by = "k2", incomparables = NA) # 2 rows
