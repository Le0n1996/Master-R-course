## Question 1
install.packages("microbenchmark") # downloading
library("microbenchmark")          # activating

## Question 2
{a <- numeric(1000); for (i in 1:1000) a[i] <- i^2}
{a <- (1:1000)^2}
help(microbenchmark) # call for help
microbenchmark({a <- numeric(1000); for (i in 1:1000) a[i] <- i^2}, 
               {a <- (1:1000)^2}, control = list("inorder"))
# as we can see from the result, second expression is much faster than the first one (hundreds times faster!!).

## Question 3
install.packages("dplyr")
# datasets are already downloaded
library("datasets")
library("dplyr") # activating
head(iris) # checking if dataset is here
subsetlen <- select(iris, ends_with("Length"), Species) # Sepal.Length, Petal.Length, and Species selected
filter(subsetlen, Species == "versicolor", Petal.Length >= 4) # filtering first subset

## Question 4
for (i in unique(iris$Species)) {
  print(paste("Mean for ", i, ": ", mean(iris$Petal.Length[iris$Species == i]), sep = "")) # mean
  print(paste("Standart deviation for ", i, ": ", sd(iris$Petal.Length[iris$Species == i])), sep = "") # stand.dev
  print(paste("Range of variation for ", i, ": ", max(iris$Sepal.Length[iris$Species == i]) - min(iris$Sepal.Length[iris$Species == i]), sep = "")) # range of variation
}

## Question 5
str(iris) # 50 of each species, 150 obs. in total
# 5 variables: Sepal.Length, Sepal.Width, Petal.Length, Petal.Width, Species
class(iris$Sepal.Length)
class(iris$Sepal.Width)
class(iris$Petal.Length)
class(iris$Petal.Width)
class(iris$Species)
# so first 4 are numeric, and the last one is factor indicating three different species
iris$Species # three levels - setosa, versicolor, virginica

## Question 6

# First easy way using sort:
print("Medians for Petal.Length for all species:")
for (i in unique(iris$Species)) { # for each of three species
  print(paste("Median for ", i, ":  ", median(iris$Petal.Length[iris$Species == i]), sep=""))
  # print(Me <- median(iris$Petal.Length[iris$Species == i]))
  new_Species <- sort(iris$Species, decreasing = FALSE, median(iris$Petal.Length[iris$Species == i]))
}

# Second not-so-easy way using arrange
Medians <- numeric(3) # we will put medians here later
Medians_Petal_Length <- numeric(length(iris$Petal.Length))
iris$Medians_Petal_Length <- numeric(length(iris$Petal.Length))
for (i in 1:length(iris$Petal.Length)){
  for (j in 1:3){
    Medians[j] <- median(iris$Petal.Length[as.numeric(iris$Species) == j])
    iris$Medians_Petal_Length[i] <- Medians[as.numeric(iris$Species)[i]]
  }
}
arrange(iris, desc(Medians_Petal_Length))

## Question 7

install.packages("readstata13")
library(readstata13)
# setwd("~/Programming/R/HA")
abd <- na.omit(read.dta13("abdata.dta")) # Omit all rows with NA using na.omit
# head(abd) # can look at our data: everything looks fine

## Question 8

# First way with subsetting
f1 <- abd[abd$year == 1980:1983 & abd$n > 2,] # combining conditions, selecting only the rows which correspond
# View(f1) # and we can see that only 21 observations were selected

# Second way with function filter from dplyr package
f2 <- filter(abd, year == 1980:1983, n > 2)
# View(f2) # and we can see that only 21 observations were selected

#microbenchmark({f1 <- abd[abd$year == 1980:1983 & abd$n > 2,]}, 
#               {f2 <- filter(abd, year == 1980:1983, n > 2)}, control = list("inorder"))
# by the way, standart subsetting is faster in this case... ~400 mcs vs ~1000 mcs in average

## Question 9

by_id <- group_by(abd, id) # group abd data by id
a <- mutate(by_id, average_n = mean(n)) # calculate mean of n for groupped abd and create new variable average_n
#View(a) # this looks fine