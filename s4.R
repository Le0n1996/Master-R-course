# If your R uses not English language by default:
Sys.setenv(LANG = "en") # Windows
system("defaults write org.R-project.R force.LANG en_US.UTF-8") # Mac

# Recap of the previous topics

# 1. Create two sequences: (1) Even numbers begining with 0 and length 100; (2) A sequence (3, 9, 27, 81, ...)  of length 20
# with elements bigger than 50 000 replaced with NULL.
# 2. Create new matrix using these vectors, stacking them by columns. Restrict the number of rows by minimum.
# 3. Select all rows of the matrix except the first and the last one.
# 4. In the following matrix find number of column and row which have the smallest number (using which function)

a <- seq(0, 198, 2)
b <- 3^(1:20)
b <- ifelse(b>50000, NA, b)
f <- length(na.omit(b))

length(a)
n <- cbind(a[1:f], na.omit(b))
n
n[c(-1,-nrow(n)),]
which(n[,1]==min((n[,1])))

# Important function for work with vectors
# Sort
a <- c(3, 6, 2)
sort(a)

# Pay attention to NA
a2 <- c(3, 6, 2, NA) 
sort(a2)
sort(a2, na.last = TRUE)
sort(a2, decreasing = TRUE)

# Order function can be used to get numbers of element positions (again focus on NA).
order(a)
a[order(a)]

# It is very useful when sorting data sets
mtcars
mtcars[order(mtcars$mpg), ] # Sorted by miles-per-gallon
mtcars[order(mtcars$carb), ] # Sorted by the number of carburetors

# Unique
unique(c(2, 2, 3, 4, 5, 5))

# Again pay attention to NA
unique(c(2, 2, NA, 4, 5, 5))

# Next, recall that NULL can be used to completely remove values
c(1, NULL) # Equal to 1
# It is useful when working with loops to initiate an empty variable

####
# Loops

# For loop

# For example we want to fill missing values in some matrix:
m <- matrix(nrow = 5, ncol = 2)

# We can plug in some vector directly if we know it.
m[, 1] <- seq(5, 9)

# But if we have not a ready vector for the second column,
# We can manually put values:
m[1, 2] <- -1
m[2, 2] <- 2^0.5
m[3, 2] <- 6
m

# Or use loop for automatisation!
# Examples
# Cycle over all index values
for (i in 1:10) {
  print(i)
}

# Sweep over squared values
for (i in 1:5) {
  print(i^2)
}

# Add 5 to each index value (without cumulative summation!)
for (i in 1:10) {
  i <- i + 5
  print(i)
}

# More complicated case. Let's begin with command paste
help(paste)

paste("a", "b")
paste0("a", "b") # No extra space added
paste("a", "b", sep = "") # Same, no separator

paste("The value of i in memory is", i)

# Turn to loop (remember this trick with paste: it is very useful in many cases)
for (year in seq(2010, 2019)) {
  print(paste("The year is", year))
}


# We can create so-called nested loops (a loop in a loop)
for (i in 1:5) {
  for (j in 1:2)  {
    print(i * j)
  }
}

# Nested loops can be very useful
m <- matrix(nrow = 5, ncol = 2)
for (i in 1:5) {
  for (j in 1:2) {
    m[i, j] <- i / j
  }
}
m

# Even more complicated cases
m <- matrix(nrow = 5, ncol = 2)
a <- c(3, 6, 4, 9, 5, 10, 0, -1, 4, 5)

r <- 1

for (i in 1:5) {
  for (j in 1:2) {
    
    m[i, j] <- a[r]
    r <- r + 1
  }
}
m

# However, in most cases, loops can be replaced with R built-ins
# Try avoiding loops and searching for ways (e. g. on StackExchange) how to eschew them

############
# QUESTION 7
# Replicate matrix multiplication using nested loops. Use two example matrices A <- matrix(10:19, nrow=5, ncol=2)
# B <- matrix(20:29, nrow=2, ncol=5)

A <- matrix(10:19, nrow=5, ncol=2)
B <- matrix(20:29, nrow=2, ncol=5)
A
B
C <- matrix(rep(0,25), nrow=5, ncol=5)
for (i in 1:5)
  for (j in 1:5)
    for (k in 1:2)
      C[i,j] = C[i,j]+A[i,k]*B[k,j]
C

for (i in 1:5)
  for (j in 1:5)
    C[i,j] = sum(A[i,]*B[,j]) # better to vectorize
C
A%*%B # well, nice
############

############
# QUESTION 8
# Difficult task! Using loop over i values 2, 5, 8, ..., 29, create a matrix `d` with variables
# x1, ..., x10 with one row and save corresponding i values into them. For example,
# d$x1 <- 2, d$x2 <- 5, ...
# Variable names should be created in a loop!

a <- seq(2, by=3, length.out=10)
a
d <- matrix(nrow=1, ncol=10)
for (i in 1:10)
  d[,i] <- a[i]
d
############
  
############
# QUESTION 9
# For the vector c(1, 2, NA, 4), using scalar if function and loops, check each value whether
# it is NA or not (use is.na function). Then apply `is.na` to the entire vector/ What can you say?
a <- c(1, 2, NA, 4)
for (i in 1:4)
  ifelse(is.na(a[i]), print('yes'),  print('no'))

s <- ifelse(is.na(a), 'yes',  'no')
s
############

############
# QUESTION 10
# For the `mtcars` dataset calcualte mean (mean function) and standard deviation (sd function)
# of each row. Then repeat results for columns.
a <- mtcars
a
for (i in 1:nrow(a)){
  print(mean(as.numeric(a[i,])))
  print(sd(a[i,]))
}
for (j in 1:ncol(a)){
  print(mean(as.numeric(a[,j])))
  print(sd(a[,j]))
}

############
help(mean)

# Suppose you have a series:
set.seed(1)
n <- 400
r <- rnorm(n, 0.01, 0.03)

# The first value is set to 0.001
# Each subsequent value in the series is equal to 0.000003 plus 0.3 times its previous value plus 0.4 times 
# the squared previous value of the r series

x <- rep(NA, n) # create empty vector
x[1] <- 0.001
for (i in 2:n) {
  x[i] <- 0.000003 + 0.7 * x[i - 1] + 0.4 * r[i - 1]^2
}
print(x)


# Checking can be done in loops
# Let's ask the computer to simulate dice rolling in a table-top game while making pauses
set.seed(1)

# Roll a die 20 times and make corresponding
for (i in 1:20) {
  a <- sample(1:6, 1) # Roll a die

  print(i)

  print(if (a == 1) {
    "Walk forward one square"
  } else if (a == 2) {
    "Walk forward two squares"
  } else if (a == 3) {
    "Skip a turn"
  } else if (a == 4) {
    "Draw a card"
  } else if (a == 5) "Go back one square" else "Walk forward one square")

  Sys.sleep(1)
}



############
# QUESTION 11
# Create a vector of length 500. The first value is 0, the second is 1.
# All other subsequent values are equal to the squared sum of two previous values plus 5.
x <- rep(NA, n) # create empty vector
x[1]=0
x[2]=1
for (i in 3:n) {
  x[i] <- 5 + (x[i - 2]+x[i - 1])^2
}
print(x)
############
x <- 100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
print(x)
# While: statement is repeated while condition holds. After first FALSE a loop stops.
i <- 1
while (i <= 6) {
  print(i^2)
  i <- i + 1
}

# Suppose you want to purchase stocks one by one and want to stop whenever you wallet has less than $10
# The prices of the stocks are given, and you want to know when to stop
set.seed(2)
wallet <- 200
stock.prices <- round(rlnorm(100, mean = 0.5), 2)
start.number <- 1
while (wallet > 10) {
  wallet <- wallet - stock.prices[start.number]
  start.number <- start.number + 1
}
stop.number <- start.number - 1
sum(stock.prices[1:stop.number])


############
# QUESTION 12
# Create a vector seq(2, by=5, length.out=300).  Usigng while function, replace all values smaller 
# than 300 with NA.
############


# Break and next options
# You need to print all odd numbers between 1 and 10,
# but even numbers should not be printed.

# We can restrict values from start but also we can try to print all values
# and eliminate irrelevant ones.
for (i in 1:10) {
  if (!i %% 2) {
    next
  }
  print(i)
}


# All values except 2
x <- 1:5
for (i in x) {
  if (i == 2) {
    next
  }
  print(i)
}

# A loop with a break
x <- 1:5
for (i in x) {
  if (i == 3) {
    break
  }
  print(i)
}

# The following code prints squared values for values smaller than 6 except 4.
i <- 1
while (i <= 6) {
  if (i == 4) {
    i <- i + 1
    next
  }
  print(i * i)
  i <- i + 1
}

# A while loop with a break statement: print squared values up to 4.

  i <- 1
while (i <= 6) {
  if (i == 4) {
    break
  }
  print(i^2)
  i <- i + 1
}


############
# QUESTION 13
# Print all squares of all numbers from -1 to 400 except those which can be divided 
# by 7 without remainder.
############


############
# QUESTION 14
# In the vector set.seed(2); x <- rnorm(500, 30, 15) replace values using the following principle.
# If a value is greater than 30, add -2, otherwise do nothing. Propose two solution using
# `if` command and `for` and `next`.
############


# Next, we need to learn how install packages that contain other useful functions
# (the packages can be loaded without quotation marks)
installed.packages() # List all installed packages
install.packages("sandwich") # Installs a package
install.packages(c("lmtest", "microbenchmark")) # Installing multiple packages at once

# When package is downloaded we can activate
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

data_returns <- read.csv("actual_returns.csv")

# This part of code mainly replicates dplyr vignette.
# dplyr package for data managing
install.packages("dplyr")
library("dplyr")

# install data
install.packages(hflights)
library(hflights)

help(hflights)

dim(flights)

head(flights)

colnames(flights)

# Subseting rows with filter command.

help(filter)
# For example, we can select all flights on January 1st with:
filter(flights, month == 1, day == 1)

# Or we can use standard default approach.
flights[flights$month == 1 & flights$day == 1, ]

# You can use also other logic operators:
filter(flights, Month == 1 | Month == 2)

############
# QUESTION 15
# From flights database select all flights on January 2nf and Febrary 3rd.
############

############
# QUESTION 16
# Select all fligths which occured on the 1st day of each of first six monthes
# (use filter, for(loop) and rbind functions).
############

# Reordering of rows in dataset. If you provide more than one column name,
# each additional column will be used to break ties in the values of preceding columns.
help("arrange")

arrange(flights, year, month, day)

# Use desc() to order a column in descending order
arrange(flights, desc(arr_delay))


############
# QUESTION 17
# Order the data in descending order, at first, according to arrival time,
# then by arrival delay.
############

# Selecting columns.

# Select columns by name.
select(flights, year, month, day)

# Select all columns between year and day (inclusive)
select(flights, year:day)

# Select all columns except those from year to day (inclusive)
select(flights, -(year:day))

# Variable selection can be very complicated.

# For example, select all variables which begin with arr.
select(flights, starts_with("arr"))

# If you want to select x1, x2, x3
select(data, matches("x[1-3]"))

############
# QUESTION 18
# Select all columns with ends with "time".
############

# New variables creating
help(mutate)

mutate(flights, gain = arr_delay - dep_delay, speed = distance / air_time * 60)

# If you only want to keep the new variables, use transmute()
transmute(flights,
  gain = arr_delay - dep_delay,
  gain_per_hour = gain / (air_time / 60)
)

############
# QUESTION 19
# Create new variable - average speed of the flight.
############

# Grouping

# combination with discussed functions.
# grouped select() is the same as ungrouped select(), except that grouping variables are always retained.

# grouped arrange() is the same as ungrouped; unless you set .by_group = TRUE, in which case it orders first by the grouping variables

# mutate() and filter() are most useful in conjunction with window functions (like rank(), or min(x) == x).

# summarise() computes the summary for each group.

# Grouping by
# In the following example, we split the complete dataset into individual planes
# and then summarise each plane by counting the number of flights (count = n())
# and computing the average distance (dist = mean(distance, na.rm = TRUE))
# and arrival delay (delay = mean(arr_delay, na.rm = TRUE)).

by_tailnum <- group_by(flights, tailnum)
delay <- summarise(by_tailnum,
  count = n(),
  dist = mean(distance, na.rm = TRUE),
  delay = mean(arr_delay, na.rm = TRUE)
)
delay <- filter(delay, count > 20, dist < 2000)

# You use summarise() with aggregate functions, which take a vector of values and return a single number.
# There are many useful examples of such functions in base R like min(), max(), mean(), sum(), sd(), median(), and IQR().
# dplyr provides a handful of others:
# n(): the number of observations in the current group
# n_distinct(x):the number of unique values in x.
# first(x), last(x) and nth(x, n) - these work similarly to x[1], x[length(x)],
# and x[n] but give you more control over the result if the value is missing.
# For example, we could use these to find the number of planes and the number of flights that go to each possible destination:

destinations <- group_by(flights, dest)
summarise(destinations,
  planes = n_distinct(tailnum),
  flights = n()
)


# We can use subsequent grouping
daily <- group_by(flights, year, month, day)
per_day <- summarise(daily, flights = n())
per_month <- summarise(per_day, flights = sum(flights))
per_year <- summarise(per_month, flights = sum(flights))

############
# QUESTION 20
# Calculate average distance for each origin.
############

