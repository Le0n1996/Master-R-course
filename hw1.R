### Question 1
a1 <- seq(from = 101, to = 110, by = 1) # sequence from 101 to 110 with step 1
print(a1)
a1 <- seq(from = 101, to = 110, length.out = 10) # sequence from 101 to 110 with length 10 and equal steps
print(a1)
b1 <- seq(from = 6, to = -6, by = -2) # sequence from 6 to -6 with step -2
print(b1)
b1 <- seq(from = 6, to = -6, length.out = 7) # sequence from 6 to -6 with length 7 and equal steps
print(b1)

### Question 2
a2 <- c(1,-1,1,-1,1,-1,1,-1,1,-1) # simply creating vector with such values
print(a2)
a2 <- rep(c(1,-1), times = 5) # repeat this pair 5 times
print(a2)
b2 <- c(1,1,1,1,1,-1,-1,-1,-1,-1) # simply creating vector with such values
print(b2) 
b2 <- rep(c(1,-1), each = 5) # repeat each element in this pair 5 times
print(b2)

### Question 3
v <- rep(1:10, times = 1:10) # each number n is repeated n times
print(v)

### Question 4
d <- rep(c(1,3), 8) # getting 1 and 3 repeated 8 times
power <- rep(10^(-4:3), each=2) # get powers of 10 from -4 to 3
d <- c(d*power, 10000) # multipling vectors of the same length and adding 10000 to the end of resulting vector
print(d)

### Question 5
a <- 1:100 # get the vector with all integers from 1 to 100
a5 <- a[a%%7==0] # choose elements, which are divisible by 7
print(a5) # printing them
a5sum <- sum(a5) # computing sum
a5mean <- mean(a5) # computing average
print(a5sum)
print(a5mean)

### Question 6
class(2019)
class("2019")
# in the first case, 2019 is a number, therefore it has class numeric
# in the second case, it is still 2019, but written as a string, and string values are represented as character object

### Question 7
aa7 <- matrix(c(5,9,10,3,7,4,1,8,2), nrow = 3, ncol = 3, byrow = TRUE) # write numbers in matrix 3õ3 by rows
print(aa7) # just checking everything's fine
subaa <- aa7[c(2,3), c(1, 3)] # select rows 2,3 and columns 1,3 
print(subaa) # the answer

### Question 8
a <- 3
aa8 <- matrix(1:9, a, 3) # this is how error should be fixed
print(aa8)
# aa <- matrix(1:9, "a", 3)
# Error happens because "a" is symbol a, instead of number expected by function matrix() there
# If we want to pass a to the function matrix(), we should drop the quotes

### Question 9
help(sum) # this is how call for help looks like
# As we can see, na.rm is a logical variable indicating how function sum() has to treat missing values
# If na.rm is TRUE, function sum() ignores NA and NaN entries, otherwise NA or NaN is returned
# As we can see from Usage section, by default na.rm = FALSE (NA could be returned)
a9 <- c(1, 2, 3, NA)
sum(a9) # just some examples of how it works, in this case returns NA
sum(a9, na.rm = TRUE) # now NA is ignored, and sum of the rest is 6

### Question 10
a <- c(6, 8, 1, -5, 7, 9, 5, 5, 3, 2) # remember the vector as a
a10 <- a[8:5] # selecting 8th-5th elements from vector a
print(a10)

### Question 11
cars <- mtcars$mpg # import data
print(cars) # look at all dataset
print(cars[(length(cars)-4):length(cars)]) # getting last 5 values with slicing
print(tail(cars, 5)) # getting last 5 values with function tail()
print(length(cars)) # so this dataset contains 32 elements

### Question 12
cars[seq(2,length(cars)-length(cars)%%2,2)] # getting values at EVEN positions (as 2,4,6,... were needed) whatever the length is

### Question 13
a13 = length(cars)^(1/3) # number of element in sequence, corresponding to the length (works for any length)
print(cars[seq(1, a13, 1)^3]) # getting values standing at "cubic" positions, where this number is not greater than length of mtcars$mpg

### Question 14
a14 = log(length(cars)/2, base = 3) # number of element in sequence, corresponding to the length of geom. progression in this case (works for any length)
print(cars[2*3^(seq(0, a14, 1))]) # slicing and getting values standing at positions needed

# Comment: or the solution to numbers 13 and 14 could look the same but with a13=3 and a14=2, if we know in advance, that length is 32 (32<64 and 32<54)

### Question 15
sum(cars^2)/length(cars) - (sum(cars)/length(cars))^2 # second empirical moment minus first empirical moment squared equals sample variance
