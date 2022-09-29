# If your R uses not English language by default:
Sys.setenv(LANG = "en") # Windows
system("defaults write org.R-project.R force.LANG en_US.UTF-8") # Mac

# Some problems on the previous topics

# Round-up:
# Create sequence 11, 14, 13, 16, 15, 18, 17, 20, 19, 22, ... Write command which generates Yes, if 10th element of this sequence 
# isn't equal to 25 and gives its value if it is smaller.
a = seq(11,20,1)
a[a%%2==0] = a[a%%2==0]+2
# or a = 10:19 + rep(c(1,3), times=5)
ifelse(a[10] == 25, yes = 'Yes', ifelse(a[10] < 25, yes = a[10]))

# Note repetition of values in matrix:
m5 <- matrix(1:25, nrow = 5, ncol = 6, byrow = FALSE) # First column is repeated
m5

m6 <- matrix(1:25, nrow = 5, ncol = 6, byrow = TRUE) # First row is repeated
m6


# We can impose restrictions for values in a matrix, thus, subsetting this matrix
m2 <- matrix(1:56, nrow = 8, ncol = 7)
# We select only those rows which have in the first column values greater than 8
m2[m2[,1]>8,]

# We can impose similar restriction on columns
m2[,m2[1,]>3]

# Restrictions can be complex:
m2[m2[,1]>8 & m2[,2]>6,]
m2[m2[,1]>8 | m2[,2]>5,]

# columns 6 and 7 with values >28 and rows with values greater than 30
# m2[,m2[,6]>28 & m2[,7]>28] not working!
m2[m2[,6]>28 & m2[,7]>32, m2[1,]>30 & m2[4,]>30] # nice

############
# QUESTION 1
# For matrix m7 <- matrix(1:9, nrow = 3, ncol = 3, byrow = FALSE) select columns 
# and rows with values greater than 5.
m7 <- matrix(1:9, nrow = 3, ncol = 3, byrow = FALSE)
m7
m7[m7[,1]>5 | m7[,2]>5 | m7[,3]>5, m7[1,]>5 | m7[2,]>5 | m7[3,]>5]
m7[m7[,1]<=5 | m7[,2]<=5 | m7[,3]<=5, m7[1,]<=5 | m7[2,]<=5 | m7[3,]<=5]
############


# We can name elements in vector
a <- 1:5
names(a) <- c("Alexander", "Boris", "Cecilia", "Vladimir", "Egor") # assigning labels to a vector
a

a["Cecilia"]

unname(a)


# Matrices can also have row and column names
rownames(m2) <- c("Andrei", "Bob", "Carol", "Igor", "Eve", "Fitzgerald", "Harold", "Irina")

m2

rownames(m2)

class(row.names(m2))

m2["Eve", ]

m2[c("Eve", "Harold"),]

m2["Zulaika", ] # Error

# Delete rownames
rownames(m2) <- NULL
m2

# Column names
colnames(m2) <- c("Day 1", "Day 2", "Day 3", "Day 5", "Day 8", "Day 10", "Day 31")
m2

rownames(m2) <- c("Andrei", "Bob", "Carol", "Anastasia", "Eve", "Fitzgerald", "Harold", "Irina")
m2





# Binding vectors into matrices
a

s <- seq(6,10)

#Columns
as1 <- cbind(a, s) # column bind

as1

class(as1) #Matrix!

#Rows
as2 <- rbind(a, s) # row bind
as2


# What if we combine vectors with different length?
s <- seq(6,11)
as2 <- cbind(a, s) # short vector is repeated
as2


############
# QUESTION 2
# From vectors (1, 4, 3, 7) and  (2, 5, 8, 2) create matrix with two rows and four columns using rbind function.
# Name columns as A, B, C, D.
a <- rbind(c(1, 4, 3, 7), c(2, 5, 8, 2))
colnames(a) <- c("A", "B", "C", "D")
a
############

# We can combine different classes in one matrix
m8 <- matrix(c(1, 2, 3, 4), nrow = 2, ncol = 2) 
m8

class(m8)
class(m8[1,1])

m9 <- matrix(c(1, "2", 3, 4), nrow = 2, ncol = 2) 
m9

class(m9)
class(m9[1,1])

m10 <- matrix(c(1, NA, 3, 4), nrow = 2, ncol = 2) 
m10

class(m10)
class(m10[1,1])
class(m10[2,1])


m11 <- matrix(c(1, NULL, 3, 4), nrow = 2, ncol = 2)  
m11 # We omit one element and values start to replicate!!!



# We can impose restrictions on text data:
m9

m9[m9[,1]=="2",]

m9[,m9[1,]=="2"]



############
# QUESTION 3
# Use mtcars data. We should those cars which have mpg>=17 and gear==4. In addition, cars with  both wt<2.600 and hp>93 are also appropriate.
a <- mtcars
a
names(a) # now we know how to call them
a[mtcars$mpg>=17 & mtcars$gear == 4 | mtcars$wt<2.600 & mtcars$hp>93,]
############

# The 'which' function is really useful for extracting the positions of the TRUE elements
set.seed(1)
n <- 50
r <- rnorm(n, 0.01, 0.03)

r 
r < 0
which(r < 0) # Numbers of negative values

# This works extremely well and saves spaces for long logical vectors that have very few TRUEs
set.seed(3)
r <- rnorm(1000)
r

very.bad.case <- (r < -3) # Can you find the truth?
very.bad.case # Can you find the truth?

which(very.bad.case) # Now we clearly see it

# In subsetting, both work
a <- 1:100
g <- a %% 6 == 0
g

a1 <- a2 <- a

a1[g] <- 0
a1

which(g)

a2[which(g)] <- 0
a2

all(a1 == a2)

############
# QUESTION 4 
# For vector z <- rnorm(500, 0, 1). Select position of the maximum and minimum values (max and min functions).
z <- rnorm(500, 0, 1)
z
which(z==min(z))
which(z==max(z))
############


# Matrix algebra
A <- matrix (c(1, 2, 3, 4), nrow = 2, ncol = 2)
B <- matrix (c(5, 6, 7, 8), nrow = 2, ncol = 2)

A+B
A-B

# Matrix multiplication
A%*%B

# If we use standard multiplication we get incorrect result (elements with the same indices will be multiplied)
A*B



####
# For simple logical checks of length one, one can use the basic function `if`:
a <- 3
if (a > 5) print("This message is printed only if 'a' is greater than 5")


a <- 6
if (a > 5) print("This message is printed only if 'a' is greater than 5")

if (a < 5) print("a is less than five") else print("'a' is greater or equal to five")



# The readily available table mtcars has car data
# Check if Honda Civic has 4, 6, or 8 cylinders, and name the price: $200 for 4 cylinders, $250 for 6 cylinders and $290 for 8 cylinders
civic.cylinders <- mtcars$cyl[rownames(mtcars) == "Honda Civic"]
print (if(civic.cylinders == 4) "$200" else if(civic.cylinders == 6) "$250" else if(civic.cylinders == 8) "$290")



# Checking can be done in loops
# Let's ask the computer to simulate a diсe-rolling process in a table-top game while making pauses
set.seed(1)

# Roll dice 20 times and make corresponding 
for (i in 1:20) {
 
  a <- sample(1:6, 1) # Roll the dice
  
  print(i)
  
  print(if (a == 1) "Walk forward one square" else if (a == 2) "Walk forward two squares"
        else if (a == 3) "Skip a turn" else if (a == 4) "Draw a card"
        else if (a == 5) "Go back one square" else "Walk forward one square")
  
  Sys.sleep(1)
}


# Nested loop for age restrictions
my.age <- as.integer(28.4)

if (my.age < 18) {
  print("You are Not a Major.") 
  print("You are Not Eligible to Work")
} else {
  if (my.age >= 18 && my.age <= 60 )  {
    print("You are Eligible to Work")
    print("Please fill the Application Form and Email to us")
  } else {
    print("As per the Government Rules, You are too Old to Work")
    print("Please Collect your pension!")
  }  
}


# However, `if` is only one-dimensional. For vectorised operations, use the ifelse function
a <- 1:100
if (a < 10) print("Small") else print("Large") # Error!

ifelse(a < 10, "Small", "Large")

# We want to return "Correct" if number is divisible by 6 or "Duh" otherwise
ifelse(a %% 6 == 0, "Correct", "Duh")



############
# QUESTION 5
# Create vector setseed(1) x <- rnorm(500, 20, 15). Take square root from values but if value is negative return NA.
setseed(1)
x <- rnorm(500, 20, 15)
ifelse(x>=0, sqrt(x), NA)
############

############
# QUESTION 6
# Write nested ifelse statement for some bank: if person has income less $40 000 per year, then credit products are not eligible for him/her, 
# if income is less $80 000 some check is needed, otherwise, bank can give creditr to him/her. Create such ifelese statement for credit product worker.
income <- 65000
if (income < 40000) {
  print("Credit products are not eligible") 
} else {
  if (income < 80000)  {
    print("Some check is needed")
  } else {
    print("Bank can give credit for you")
  }  
}
############


####
# Loops

# For loop

# In order to repeate some action we can write. For example we want to fill missing values in some matrix: 
m <- matrix(nrow=5, ncol=2)

# We can plug in some vector directly if we know it. 
m[,1] <- seq(5,9)

# But if we have not presaved vector for the second column. We can manually put values:

m[1,2] <- -1
m[2,2] <- 2^0.5
m[3,2] <- 6

#Or use loop for automatization!

# Examples

# Sweep over all index values
for (i in 1:10) {
  print(i)
}

# Sweep over square values
for(i in 1:5)
{
  print (i^2)
}

# Add 5 to each index value (without cumulative summation!)
for (i in 1:10) {
  i <- i+5
  print(i)
}

# More complicated case. Let's begin with command paste
help(paste)

paste("a", "b")

paste(i, "i")

# Turn to loop
for (year in seq(2010, 2019)){
  print(paste("The year is", year))
}


# We can create so-called nested loops (a loop in a loop)

for(i in 1:5)
{
  for(j in 1:2)
  {
    print(i*j);
  }
}

# Nested loops can be useful 
m <- matrix(nrow=5, ncol=2)

a <- seq(3, by=3, length.out=10)

for(i in 1:5)
{
  for(j in 1:2)
  {
    m[i,j] <- i
  }
}
m

# Even more complicated case

m <- matrix(nrow=5, ncol=2)

r=1
for(i in 1:5)
{
  for(j in 1:2)
  {
    m[i,j] <- a[r]
    
    r <- r+1
  }
}
m

############
# QUESTION 7
# Replicate matrix multiplication using nested loops. Use two example matrices A <- matrix(10:19, nrow=5, ncol=2) B <- matrix(20:29, nrow=2, ncol=5)
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
A%*%B # well, nice
############

############
# QUESTION 8
# Difficult task! Using loop over i values 2, 5, 8, ..., 29, create new variables x1,..., x10 and save corresponding i values into them. For example,
# x1 <- 2, x2 <- 5, ... At first, variable names outside loop should be created!
x <- rep(0, 10)

for (i in 1:10)
  x[i] <- 3*i-1
x
############

############
# QUESTION 9
# For vector c(1, 2, NA, 4) using scalar if function and loop check each value whether it is NA or not (use is.na function).
a <- c(1, 2, NA, 4)
for (i in 1:4)
  if(is.na(a[i])==TRUE)
    print(i)
############

############
# QUESTION 10
# For mtcars dataset calcualte mean (mean function) and standard error (sd function) of each row. Then repeat results for columns.
a <- mtcars
a
for (j in 1:length(a[1,]))
  print(mean(a[,j], na.rm = TRUE))
for (i in 1:length(a[,1]))
  print(mean(a[i,], na.rm = TRUE))
unname(a[1,])
help(mean)
############



# Suppose you have a series:
set.seed(1)
n <- 400
r <- rnorm(n, 0.01, 0.03)

# The first value is set to 0.00001
# Each subsequent value in the series is equal to 0.000003 plus 0.3 times its previous value plus 0.4 times the squared previous value of the r series
x <- rep(NA, n) # create empty vector
x[1] <- 0.001
for (i in 2:n) {
  x[i] <- 0.000003 + 0.7 * x[i - 1] + 0.4 * r[i - 1]^2
}

print(x)

############
# QUESTION 11
# Create vector of length 500. First value is 0, second is 1. All other consequent values are generated by squred sum of two previous values plus 5.
a <- c(0,1, rep(0, 498))
for (i in 3:500)
  a[i] = a[i-2]^2+a[i-2]^2
############


# While: statement is repeated while condition holds. After first FALSE a loop stops.
i <- 1
while (i <= 6) {
  print(i^2)
  
  i <- i+1
}


# Suppose you want to purchase stocks one by one and want to stop whenever you wallet has less than $10 
# The prices of the stocks are given, and you want to know when to stop
set.seed(2)
wallet <- 200
stock.prices <- round(rlnorm(100, mean = 0.5), 2)
start.number <- 1
while(wallet > 10) {
  wallet <- wallet - stock.prices[start.number]
  start.number <- start.number + 1
}
stop.number <- start.number - 1
sum(stock.prices[1:stop.number])


############
# QUESTION 12
# Create vector seq(2, by=5, length.out=300).  Replace all values smaller than 300 with NULL values. Rest values should be the same.
############


# Break and next options

# You need to print all uneven numbers between 1 and 10 
# but even numbers should not be printed.

# We can restrict values from start but also we can try to print all values 
# and eliminate irrelevant ones.
for (i in 1:10) {
  if (!i %% 2){
    next
  }
  print(i)
}


# All values except 2
x <- 1:5
for (i in x) {
  if (i == 2){
    next
  }
  print(i)
}

# Loop with break
x <- 1:5
for (i in x) {
  if (i == 3){
    break
  }
  print(i)
}


# The following code print squred values for values smaller than 6 except 4.
i <- 1
while (i <= 6) {
  if (i==4)
  {
    i=i+1
    next;
  }
  print(i*i);
  i = i+1;
}



# While loop with break statement: print squred values until 4.

i <- 1
while (i <= 6) {
  if (i==4)
    break;
  print(i^2)
  i = i+1
}


############
# QUESTION 13
# Print all squares of all numbers from -1 to 400 except those which can be divided by 7 without remainder. 
############


############
# QUESTION 14
# For vector setseed(2) x <- rnorm(500, 30, 15) create replace values using the following principle. 
# If a value is greater than 30 add -2, otherwise do nothing. Propose two solution using for and if commands and for and next.
############


