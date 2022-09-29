###### Question 1. 
# Install the extra package microbenchmark and load it

# install.packages("microbenchmark") # Install package "microbenchmark"
library("microbenchmark")          # Load package "microbenchmark" in the memory


###### Question 2.
# The package microbenchmark allows the user to compare the performance of R commands so 
# that you could pick the quickest one. There are two expressions that return the same result:
{a <- numeric(1000); for (i in 1:1000) a[i] <- i^2}
{a <- (1:1000)^2}
# Invoke the help for the microbenchmark function, look up its example usage, 
# and compare the average time required to evaluate these two expressions. Which is faster?

help(microbenchmark)
microbenchmark(expr_1 <- {a <- numeric(1000); for (i in 1:1000) a[i] <- i^2}, 
               expr_2 <- {a <- (1:1000)^2},
               times=10L)
# The result shows that in this test expr_2 is the fastest.


###### Question 3.
# Download the datasets library, load it into memory, and focus on the iris data set. 
# Using the dplyr package, select only the columns that end with Length and the Species column. 
# From this subset, select only the rows that correspond to the versicolor species and have Petal.Length greater than 4.

# installed.packages()
library("dplyr")
head(iris)
select(iris, ends_with("Length"), Species)
filter(select(iris, ends_with("Length"), Species), Species=="versicolor", Petal.Length>=4)


###### Question 4.
# Using the iris data set, calculate the mean and the standard deviation for Petal.Length 
# for each species. Also, for each species, calculate the difference between the maximum and 
# minimum Sepal.Length.

for (i in unique(iris$Species)) {
  print(paste("Mean for Petal.Length for", i, "is equal to", mean(iris$Petal.Length[iris$Species == i])))
  print(paste("Standard deviation for Petal.Length for", i, "is equal to", sd(iris$Petal.Length[iris$Species == i])))
  print(paste("Range of variation for Sepal.Length for", i, "is equal to", max(iris$Sepal.Length[iris$Species == i])-
                                                                           min(iris$Sepal.Length[iris$Species == i])))
}


###### Question 5.
# Analyse the structure of the built-in iris data set. How many variables does it have? 
# What is their class? How many different species are present in this data set?

str(iris)
class(iris$Species)

# iris data set has 5 variables: 4 numeric variables and 1 factor variable.
# Variable "Species" has 3 levels "setosa", "versicolor", "virginica".


###### Question 6.
# Rank the species from the iris data set by median petal length in two ways: using the sort, 
# order and arrange functions.

# First way
for (i in unique(iris$Species)) {
  print(paste("Median for Petal.Length for", i, "is equal to", median(iris$Petal.Length[iris$Species == i])))
# print(Me <- median(iris$Petal.Length[iris$Species == i]))
  new_Species <- sort(iris$Species, decreasing = FALSE, median(iris$Petal.Length[iris$Species == i]))
}
print(new_Species)

# Second way
Me <- numeric(3)
Me_Petal_Length <- numeric(length(iris$Petal.Length))
iris$Me_Petal_Length <- numeric(length(iris$Petal.Length))

for (i in 1:length(iris$Petal.Length)){
  for (j in 1:3){
    Me[j] <- median(iris$Petal.Length[as.numeric(iris$Species) == j])
    iris$Me_Petal_Length[i] = Me[as.numeric(iris$Species)[i]]
  }
}
arrange(iris, desc(Me_Petal_Length))


###### Question 7.
# Using the read.dta13 function from the readstata13 package, read the file abdata.dta into a data set abdata 
# and keep only complete observations (that is, not containing NA values for any variable).

install.packages("readstata13")
library(readstata13)
d <- na.omit(read.dta13("abdata.dta")) # Omit all rows with NA


###### Question 8.
# Select a subset of the data set abdata from question 7 that contains observations with values of variables 
# n > 2 and year between 1980 and 1983 in two ways: using the built-in subsetting via square brackets 
# and using the filter command from the dplyr package.

# First way
f1 <- d[d$year == 1980:1983 & d$n > 2, ]
View(f1)

# Second way
f2 <- filter(d, year == 1980:1983, n > 2)
View(f2)


###### Question 9.
# Add a new variable into the abdata data frame that would be equal to the average n in groups defined 
# by the id variable (you can use any approach).

av_n <- numeric(max(d$id))
average_n <- numeric(length(d$id))
d$average_n <- numeric(length(d$id))

for (i in 1:length(d$id)){
  for (j in 1:max(d$id)){
    av_n[j] <- mean(d$n[d$id == j])
    d$average_n[i] = av_n[d$id[i]]
  }
}
View(d)


