### Question 1
set.seed(1)
n <- 500
d <- data.frame(X = rlnorm(n)) #log-normal distribution
d$Y <- 1 + d$X + rnorm(n) * (1 + d$X) #normal distribution
d <- rbind(d, c(NA, NA))
summary(d)
# As we can see, mean value of X and Y are 1.736 and 2.559
# For both X and Y, median is less than the mean,
# therefore these distributions are not symmetrical
# and right tail is heavier

### Question 2
D <- ifelse(d$X>1, 1, 0)
d <- cbind(d, D)
summary(d$D) # what gives us info that only 47.8% of X are greater than 1

### Question 3
T <- ifelse(d$X>5, 'High', 
            ifelse(d$X>1, 'Medium', 'Small'))
d <- cbind(d, T)

# summary(d$T)
# we can see that there are 261 small values, 210 medium and 29 high values
# and (210+29)/500 = 0.478, as D = 1 for medium and high values
# we get NA for the last row

### Question 4
d[which(d$T == 'High'),]$X # using which() function, as for all X>5, T='High', we can use it. And as for last row it is NA, no problem here.
# length(d[which(d$T == 'High'),]$X)
# the number of such values is 29, as according to the summary of variable T

### Question 5
set.seed(1)
m <- matrix(round(rnorm(12*10), 1), nrow = 12, ncol = 10)
m
m[m[,1]>0,] # select only rows satisfying the condition

### Question 6
m[m[,3]>-1 | m[,4]>-1 , m[6,]>0 & m[9,]>0] # all rows where column condition is satisfied; all columns where row condition is satisfied

### Question 7
rownames(m) <- c("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec")
# m
# we can see it worked

### Question 8
condition_a <- grepl("a", rownames(m))
subm <- m[condition_a,]
summary(subm)
# in the case if capital A appears in name of the month, we don't need to select it

### Question 9
for (i in 1:length(rownames(m)))
  if(condition_a[i] == FALSE)
    print(i)

### Question 10
v <- c(1,3,6,8)
a <- matrix(rep(v, 3*5 %% length(v) + 1), nrow = 3, ncol = 5, byrow = TRUE)
a # printing it
b <- matrix(rep(v, 7*9 %% length(v) + 1), nrow = 7, ncol = 9, byrow = FALSE)
b # printing it
# As in both cases total number of elements in matrix is not divisible by 4, the length of this vector, R returns warning, but there is no problem with that
# Because of this, length of this vector (4) doesn't divide length of the row of matrix a (5) and length of the column of matrix b (7)
# So numbers move by one in both cases 

### Question 11
a <- numeric(20)
a[1] <- 19
for (i in 2:20){
  if (a[i-1] %% 2 == 0)
    a[i] <- a[i-1]/2
  else 
    a[i] <- 3*a[i-1]+1}
a
# if we want to look at the result

### Question 12
row <- rep(1:25, each = 20) # getting numbers to fill the auxillary matrix a
col <- rep(1:20, each = 25) # getting numbers to fill the auxillary matrix b
a <- matrix(row, nrow = 20, ncol = 25, byrow = FALSE)
b <- matrix(col, nrow = 20, ncol = 25, byrow = TRUE)
multtable <- a*b # here we use the fact that it is not usual matrix multiplication
multtable # no need to assign names for colnames(multtable) and rownames(multtable), as it is set already

### Question 13
data <- mtcars
for (i in 1:length(colnames(data)))
  print(paste("Variable ", colnames(data)[i], ", median ", median(data[,i]), sep = "")) # using function paste() with print() to solve it

### Question 14
set.seed(1)
r <- rnorm(500, 0, 0.02) # preparing series
v <- numeric(500)
v[1] <- 0.01 # initializing first value
for (i in 2:500){
  v[i] <- 0.007+0.3*v[i-1]+ifelse(r[i-1]<0, 0.7, 0.5)*r[i-1]*r[i-1] # using ifelse() to determine what the multiplier is equal to, depending of if the previous r value is negative or not
}
length(v[v>0.12]) # number of elements v exceeding 0.12

### Question 15
set.seed(1)
s <- round(rexp(200, 1)*100, 2) # generate 'stock prices'

# Method 1: Using while loop

cheap <- s[s<100] # select only shares costing less than 100 euros
acc <- 5000 # start with 5000 in our account
i <- 0 # initializing while loop
portfolio <- numeric(200) # creating empty portfolio vector, where we will keep the share price
while (acc >= 500){ # we stop when we don't have 500 euros remaining
  i <- i+1
  acc <- acc - cheap[i] # we buy share, which costs less than 100
  portfolio[i] <- cheap[i] # and add the price of this particular share to our portfolio
}
portfolio <- portfolio[1:i] # we have only these shares, other elements are 0's left after initialization; deleting them
# length(portfolio)
# what means that we have exactly 102 shares in our portfolio

print(acc) # amount of money remaining in our account
summary(portfolio) # summary for our portfolio

# Method 2, no loops, made with cumsum()
# help(cumsum)
# if we need explanation how it works

cheap <- s[s<100] # select only shares costing less than 100 euros

summed_cheap <- cumsum(cheap) # calculate how much does it cost to buy first k shares from cheap ones, keeping that info in summed_cheap[k]
buy <- c(which(summed_cheap <= 4500), length(which(summed_cheap <= 4500))+1) # the list of shares which will be bought; when total expenses exceed 4500, we stop buying shares
total_cost <- summed_cheap[length(buy)] # sum of prices for selected shares in our portfolio
acc <- 5000 - total_cost # amount of money remaining in our account
portfolio <- cheap[buy] # create portfolio vector with share prices

print(acc) # amount of money remaining in our account
summary(portfolio) # summary for our portfolio

### Question 16
sorted <- sort(s, decreasing = TRUE) # sorting s in decreasing order instead of increasing, and saving this to s
sorted # printing the sorted values of shares prices

### Question 17
length(which(sorted > 200)) # select the shares which cost more than 200
# then calculate the length of resulting vector. As s is sorted, this will be the index of last such element.
