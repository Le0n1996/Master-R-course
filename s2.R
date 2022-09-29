# If your R uses not English language by default:
Sys.setenv(LANG = "en") # Windows
system("defaults write org.R-project.R force.LANG en_US.UTF-8") # Mac

# Some problems on the previous topics

# Round-up:
# How many arithmetic operations in R do you know?
# How does one create vectors? How does one create sequences?
# Create a sequence 1, 6, 11, 16, ..., 271.
# How does one repeat values? Create vectors c(1, 1, 2, 2, 3, 3) and c(1, 2, 3, 1, 2, 3) using a dedicated function.
# Create a sequence of 101 numbers between 1 and 5.
# Create a sequence 2^0, 2^1, 2^2, 2^3, ...,2^10. 
# What are the differences between 0, NULL, not a number, not available, and FALSE?
# What are classes? What is the difference between 2 and "2"? Why can one use c("2", 2), but not "2" + 2?



# Functions in R are very important!
# They transform something into something

# Like in a cookbook: take flour, water, sugar, eggs, mix them, bake for 30 minutes, get out of the oven

# A function always has an INPUT and OUTPUT
# It can have multiple inputs, but the output must be one object

# length function
help(length)

# sequence function
help(seq)

# Selecting parts of data

# Subsetting a vector
aa <- 13:24

aa[2] # Selecting the second element
length(aa[2])

aa[4:7] # Selecting elements with indices 4 to 7
length(aa[4:7]) 

# We can easily select elements with numbers 1, 2, 5, 6 using c()
aa[c(1, 2, 5, 6)]

# One can call the same element of a vector many times!
aa[c(1, 5:7, 3, 1, 1, 3)] # This is a way to achieve repetition
length(aa[c(1, 5:7, 3, 1, 1, 3)])


############
# Question 0
# Create vector bb with values 1, 4, 5, 6, ..., 11. Select first three values.
############


1:length(aa) # Should return 1, 2, ..., 11, 12

aa[1:length(aa)] # Select all values = the original vector.

length(aa):1 # Should return 12, 11, ..., 2, 1

# What happens if we call a vector with reversed indices?
aa[length(aa):1] # It should get reversed!

# Getting the last elements---remember that length(aa) is identical to 12
aa[length(aa)] # Get the last one

tail(aa, 1) # Same result

# The first input is the vector that should be cut from the end
# The second input is how many elements from the end of the first input we want


# How to get the last 2 elements?
aa[(length(aa)-1):length(aa)] # Returns the 11th and 12th element of aa

# Getting the last n elements in the same order
tail(aa, 2)


############
# QUESTION 1
# Using both approaches, write two expressions (with subsetting and tail) that return the last 5 elements of vector aa
############


# How does one remove some elements from a vector?

# Easy: removing the first element
# There is no `remove` function for vectors. However, it is equivalent to selecting everything EXCEPT that element

aa[2:length(aa)]

# A shorter trick exists
aa[-1] # Elemants with negative indices are excluded

# Many elements can be removed---again, this expression returns elements 11 and 12
aa[c(-1:-10)]

############
# QUESTION 2
# Drop elements 4, 5, and 8 from the vector aa
############

############
# QUESTION 3
# Given: set.seed(1); myvec <- rpois(300, 1)
# Look at the vector myvec; it has length 300
# Drop elements 201 through 300 from the vector myvec in two ways: with negative indices or by selecting everything but the indices to be dropped
############

############
# QUESTION 4
# Drop all elements of myvec with indices 2, 4, 6, ..., 298, 300, i. e. keeping 1, 3, ..., 297, 299.
############

# Now we see how vectors work with each other
# NB: Most operations are vectorised
a <- 1:10 
b <- seq(1000, 100, -100)

############
# QUESTION 5
# Check the lenghts of these vectors. Are they equal in length?
############

# Arithmetic operators work on vectors
a + b

a / b

log(a) # Algebraic functions also work on vectors

a^2 # It squares each number

# When a vector enters an expression with a scalar, the scalar is treated as a vector of identical values
a + 5


# More complicated thing: individual power for each element
a^c(1, 2, 1, 2, 1, 2, 1, 2, 1, 2) # This is what happens

# or the same (more mature approach!:)
a^rep(c(1,2), 5)



############
# QUESTION 6
# Create vector rr equal to (2, 3, 6). Directly show that product of the first and the second elements of the vector is equal to the third.
############


############
# QUESTION 7
# Create vector сс equal to (1, 7, 2). 1. Create new vector with squared values. 2. Raise the first element of the cc to power -1, 
# the second element to power 0.5 and the last one to power 1.1^13.
############



# Now, utmost attention!

# Create new vectors
s <- seq(100, 600, 100)
s

length(s)

a <- 1:10

length(a)

# The most important fact: vectors are recycled

a + s # The s vector got looped, and there is a warning!

a[1:length(s)] + s # This is how we trim the longer vector to a shorter one!



# Dimension of the vector
aa <- (1:12)*10 # We create a vector from a sequence multipled by 10

length(aa) # Should be 12

dim(aa) # However, the dimensions are not available despite it being one-dimensional
# In R, one-dimensional objects can have length but NOT dimensions

help(dim)


############
# QUESTION 8
# Create vector a1 equal to (1, 2) and vector b1 which has values 4, 5 pairly repeated 5 times (1, 2, 1, 2, ...). Calcualte sum of these two vectors.
# Calculte sum of elements of each vector.
############



### Logical operators

# Let's have a closer look at logical operations
TRUE
FALSE

# Example:
3 > 2 # TRUE

4 < 0 # FALSE

# Logical negation: change TRUE to FALSE and vice versa (!)

!TRUE #FALSE
!(4 > 0) # TRUE


# Logical OR: if either of these elements is TRUE, return TRUE, otherwise FALSE (|)
# (at least one is equal to TRUE then overall expression is equal to TRUE)

TRUE | FALSE
FALSE | FALSE
TRUE | TRUE
FALSE | FALSE

(3 > 2) | (3 < 2)
(3 > 2) | (3 < 4)

# NB: Equality sign is doubled in the case of logical comparison (==)

5 == 5
3 == 2
(3+1) == 3

# "Not equal" (!=)

5 != 4 # TRUE
3 != 3 # FALSE

# Logical AND: if both are TRUE, return TRUE, otherwise FALSE (&)
TRUE & FALSE
TRUE & TRUE
FALSE & FALSE

(3 > 2) & (3 < 2)
(3 > 2) & (3 < 4)


# Vectors can be logical
a <- c(TRUE, FALSE, TRUE, TRUE, TRUE, TRUE, FALSE)
b <- c(TRUE, TRUE, FALSE, FALSE, TRUE, FALSE, FALSE)

!a
!b

a | b
a & b

!(a | b)


# Subsetting in R can be done via logical vectors (select only "TRUE" colums)
a <- 1:7

# Select all elements except the second, the fifth and the sixth
l <- c(TRUE, FALSE, TRUE, TRUE, FALSE, FALSE, TRUE)
a[l]


############
# QUESTION 9
# Solve without R: (TRUE & TRUE) | FALSE; (TRUE & FALSE) | FALSE; (FALSE | FALSE) | FALSE;  
# (!FALSE) | FALSE | FALSE; (!FALSE) | FALSE & TRUE.
############


# Ifelse function
help(ifelse)

ifelse(test = 5 > 3, yes = 1, no = 0)

ifelse(test = 5 != 3, yes = "Yes", no = "No")

ifelse(10^2 == 100, TRUE, NA)




### Matrices

aa <- 1:12
m <- matrix(aa, nrow = 4, ncol = 3)
m

nrow(m)
ncol(m)

dim(m)

# Matrices can be filled by row
m2 <- matrix(1:56, nrow = 8, ncol = 7, byrow = TRUE)
m2

# or by column
m3 <- matrix(1:56, nrow = 8, ncol = 7, byrow = FALSE)
m3

# Subsetting matrices with row and column indices

m2[, 1] # First column---note that it converted into a vector

m2[, c(1, 3)] # Columns 1 and 3

m2[1,] # First row---note that it converted into a vector

dim(m2[1, ]) # dim not applicable because m2[1, ] is vector

# Both rows and columns can be selected
m2[1:2, c(2, 3)]

# Even with repetition
m2[1:2, c(2, 3, 2, 3)]

# Conditions can be arbitrarily complex
m2[seq(1, nrow(m2), 2), seq(3, ncol(m2), 2)]

# Logical subsetting
m2[c(TRUE, FALSE, TRUE, TRUE, FALSE, FALSE, FALSE, FALSE), ] # Selects rows 1, 3, 4 
m2[, c(TRUE, FALSE, TRUE, TRUE, FALSE, FALSE, FALSE)] # Selects columns 1, 3, 4 

# Error: the index does not exist
m2[9, ]


############
# QUESTION 10
# For matrix m4 <- matrix(1:21, nrow = 7, ncol = 3, byrow = FALSE) select only the first
# and the last column and all rows.
############

############
# QUESTION 11
# For matrix m4 <- matrix(1:21, nrow = 7, ncol = 3, byrow = FALSE) select only the first
# and the last column and all rows expect the fifth.
############

############
# QUESTION 12
# For matrix m4 <- matrix(1:21, nrow = 7, ncol = 3, byrow = FALSE) select columns 
# with even numbers and rows with odd numbers.
############


# Note repetition of values in matrix:
m5 <- matrix(1:25, nrow = 5, ncol = 6, byrow = FALSE) # First column is repeated
m5

m6 <- matrix(1:25, nrow = 5, ncol = 6, byrow = TRUE) # First row is repeated
m6


# We can impose restrictions for values in a matrix, thus, subsetting this matrix

# We select only those rows which have in the first column values greater than 8
m2[m2[,1]>8,]

# We can impose similar restriction on columns
m2[,m2[1,]>3]

# Restrictions can be complex:
m2[m2[,1]>8 & m2[,2]>8,]
m2[m2[,1]>8 | m2[,2]>8,]



############
# QUESTION 12
# For matrix m7 <- matrix(1:9, nrow = 3, ncol = 3, byrow = FALSE) select columns 
# and rows with values greater than 5.
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

s

#Columns
as1 <- cbind(a[1:6], s)

as1

class(as1) #Matrix!

#Rows
as2 <- rbind(a[1:6], s)
as2


############
# QUESTION 13
# From vectors (1, 4, 3, 7) and  (2, 5, 8, 2) create matrix with two rowns and four columns using rbind function.
# Name columns as A, B, C, D.
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
m9[m9[,1]=="2",]




# Matrix algebra
A <- matrix (c(1, 2, 3, 4), nrow = 2, ncol = 2)
B <- matrix (c(5, 6, 7, 8), nrow = 2, ncol = 2)

A+B
A-B

# Matrix multiplication
A%*%B

# If we use standard multiplication we get incorrect result (elements with the same indices will be multiplied)
A*B

