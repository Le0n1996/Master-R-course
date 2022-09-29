# Step 1. Install R and its IDE, Rstudio
# For Windows, one should use a 100% compatible and slightly faster Microsoft R Open
# https://mran.microsoft.com/open

# For Mac, one should simply download the installation image
# https://www.r-project.org/

# For Linux (Debian-based distributions), use
# sudo apt install build-essential r-base
# Advanced users should build it from sources in order to get substantial speed gains

# Then, download the IDE
# https://www.rstudio.com

# Install R first, then RStudio

# Comments in R begin with an hash (pound sign)

# First of all, R can function as a basic calculator
# It contains arithmetic, trigonometric, and statistical functions

10 + 3
10 - 3
10 * 3
10 / 3
10^3
100^0.5
log(10)
log(1000, 10) # Log base 10
10 %% 3 # Remainder from integer division
10 %/% 3 # Integer division

# Other functions
abs(-3)
sin(1)
exp(4) # e%^4
sqrt(100)
#factorial(6)

# Arithmetic operations can be chained. Expressions in brackets are evaluated first
3 + 5 * 7
(3 + 5) * 7
log((6 + 4)^3, 10)
sin(1)^2 + cos(1)^2

# Special constants

exp(1) # e
pi

# Arguably the most important functions: create a vector and assign a value to an object
# 1. The function `c` does it, *c*oncatenating values
c(1, 2, 3, 4, 5)


# The same result
1:5

# 2. We can create objects in memory of computer. And then we can easily in further calculations. 

a <- 1:5 # Silently save something as a
a = 1:5 # Also works, but may cause problems. Do not use the = sign to assign; use <- only!

print(a) # Look at the object
a # Most objects can be looked at straight away


b <- c(1, 2, 3, 4, 5)
b

d <- c(a, b, 54)
d

# we can rewrite any object:
d <- -10
d

# sometimes this is very useful if you want to update values of some variable
s=0
s

s=s+1
s

s=s+2
s

# You should not use reserved commands like `c', `mean' etc. to denote variable names
# If invoked incorrectly, they can cause hard-to-detect errors - you can replace existing command.

# The case matters
y4 <- c(1, 2, 3, 4, 5)

Y4 <- 6:10


y4

Y4


# R has built-in help resources
help.start() # A function that brings the title page of the help centre

help("ifelse") # Gives help about a function
?ifelse  # The same effect

help.search("linear models") # Runs a full search
??linear



# replication command

help(rep)

e <- rep(6, 100)
e


e1 <- rep(c(1, 2, 3), times=10)
e1


e2 <- rep(c(1, 2, 3), each = 10)
e2


e3 <- rep(c(1, 2, 3), times = c(5, 7, 11))
e3

e4 <- c(rep(c(1,2), 3), 4)
e4

# R supports creating sequences either in increment or of fixed length
s1 <- seq(1, 20, by = 2) # Ends with 19, not 20!
s1


s2 <- seq(1, 21, by = 1/3)
s2

# defing the length of series
s3 <- seq(1, 21, length.out = 4)
s3


# Arithmetic operations are vectorised
s3 / s3 # Should be 1, ..., 1

# Measuring the length
length(a) # Should be 5
length(s7) # Should be 4

# The simplest function to compute a sum
sum(s1) # SHould be 100



# Problem 1. Compute the sum of all integer numbers between 1 an 100---a famous historical problem
s1 <- seq(1,100,1)
sum(s1)

# Problem 2. Generate the following sequence: (-6, -4, ..., 24, 26, 27) --- and divide it by
# the average value of that sequence (which is its sum divided by length)
s2 <- c(seq(-6,26,2), 27)
s2
s2/(sum(s2)/length(s2))

# Problem 3. If a = c(1, 2, 3, 4) and b = c(10000, 32, 10, 10), compute their sum, difference,
# product, and ratio, as well as a to the power of b
a <- c(1, 2, 3, 4)
b <- c(10000, 32, 10, 10)
a+b
a-b
a*b
a/b
a^b
# Problem 4. Generate the following sequence in the most optimal way using `rep`s
# and the fact that 10^(0:2) returns (1, 10, 100):
# 0.0001, 0.0002, 0.0005, 0.001, 0.002, 0.005, ... 1, 2, 5, 10, 20, 50.
a <- rep(c(1,2,5), 6)
l <- length(c(1,2,5))
b <- rep(10^(-4:1), each=l)
a*b

# Data classes and styles

help(class)

a <- 1:5
class(a) # Integer

a <- a + 0.5
class(a) # It has been changed to floating-point numeric!


n <- c("Jacque", "Svetlana")
class(n)

y <- c("1", "2", "100")
class(y) # Character!


# Here we use binary variables TRUE/FALSE
x <- a < 3 # Checking classes
x
class(x)

# A cautionary tale!
class(n) # Text
n > 3 # Why?
c(n, 3) # Because numbers are automatically converted to text
"A" < "B"
"0" < "A"
"!" < "0" # See the Unicode character map
# Actually, this is useful for alphabetical precedence comparison

# You can convert classes
mytext <- c("1", "2", "Annet")
as.numeric(mytext) # Numbers are converted without a hindrance, text becomes NA



# Special data types denoting that some value is not numeric
a1 <- c(1, 2, NA, 4) # NA denotes missingness. For example, empty cells in your data table.
a1


class(a1) # A numeric vector mixed with NA remains numeric
class(NA) # But NA itself is logical, like TRUE and FALSE, because it indicates missing values in data.

# Internally, R uses subtypes of NA for various kinds of data containing missing values
class(c(TRUE, NA)[2])
class(c(1, NA)[2])
class(c("3", NA)[2])


# NaN denotes that something is not a real number, but came from an illegal operation with numbers
a2 <- log(-1)
a2 # The logarithm of something negative is not a real number, and its limit as x tends to 0 from the right is minus infinity

is.finite(a1) # NA is not finite

is.finite(a2) # NAN is surely not finite.

a <- NULL # NULL denotes emptiness, an object with length 0, and can be used to denote emptyness
length(a)

# Factors are special variables that take arbitrary unordered values (i.e. categories)
a <- c("Moscow", "SPb", "Other", "SPb", "SPb","Other")
head(a)

class(a)

f <- factor(a)

head(f) # Looks like text

as.numeric(f) # But in reality, is an integer with character levels

as.numeric("2010")
as.numeric("2010 ") # Space is eliminated
as.numeric("2010year")

# Problem 5. A variable a <- c(1, 4, NA, NaN, "5", NULL) is given.
# What is its length? Do not use the `length` function
# What is its class?
# What is the class of the third element? Why?
s5 <- c(1, 4, NA, NaN, "5", NULL)
class(s5)
class(s5[3])

# R has versatile data structure that support multiple dimensions
a <- 1 # A constant that is treated as a vector of length 1
length(a)
aa <- (1:12)*10
length(aa)
dim(aa) # However, the dimensions are not available

# Subsetting a vector
aa[2]
length(aa)

aa[4:7]
length(aa)

aa[c(1, 5:7, 3, 1, 1, 3)]
length(aa)

# Getting the last element
aa[length(aa)]
# Getting the last n elements in the same order
tail(aa, 2)
# Removing the first element
aa[2:length(aa)]
# A better trick exists
aa[-1]
# Removing elements
aa[c(-1:-10)]


# Matrices are created from a vector
# Matrices can contain only one type of data (numeric, logical, charater etc.)
m <- matrix(aa, nrow = 4, ncol = 3)
m

nrow(m)
ncol(m)

dim(m)

# Matrices can be filled by row
m2 <- matrix(1:56, nrow = 8, ncol = 7, byrow = TRUE)

# Subsetting matrices with row and column indices
m2[, 1] # First column---note that it converted into a vector
dim(m2[, 1])

m2[, c(1, 3)] # Columns 1 and 3

m2[1, ] # First row---note that it converted into a vector
dim(m2[1, ])

m2[1:2, c(3, 3, 2, 3)] # Indices can be repeated

# Logical subsetting
m2[c(TRUE, FALSE, TRUE, TRUE, FALSE, FALSE, FALSE, FALSE), ] # Selects rows 1, 3, 4 
m2[, c(TRUE, FALSE, TRUE, TRUE, FALSE, FALSE, FALSE)] # Selects columns 1, 3, 4 

# Conditions can be arbitrarily complex
m2[seq(2, nrow(m2), 2), seq(1, ncol(m2), 2)] # Same

# Error: the index does not exist
m2[9, ]

# Matrices can have row and column names
rownames(m2) <- c("Andrei", "Bob", "Carol", "Dmitry", "Eve", "Fitzgerald", "Harold", "Irina")
m2
rownames(m2)
class(row.names(m2))
m2["Eve", ]
m2[c("Eve", "Harold"),]
m2["Zulaika", ] # Error
rownames(m2) <- NULL
m2

# Column names
colnames(m2) <- c("Day 1", "Day 2", "Day 3", "Day 5", "Day 8", "Day 10", "Day 31")
m2

rownames(m2) <- c("Andrei", "Bob", "Carol", "Anastasia", "Eve", "Fitzgerald", "Harold", "Irina")
m2

# Alphabetical sorting
m2[rownames(m2) >= "D", ]


# Most operations are vectorised
a <- 1:10
b <- seq(1000, 100, -100)
a + b
a / b
log(a)
a + 5


# Problem 6. For matrix m2 <- matrix(1:21, nrow = 7, ncol = 3, byrow = FALSE) select only the first
# and the last column and all rows.
m2 <- matrix(1:21, nrow = 7, ncol = 3, byrow = FALSE)
m2[, c(1, 3)]

# Problem 7. For matrix m2 <- matrix(1:21, nrow = 7, ncol = 3, byrow = FALSE) select only the first
# and the last column and all rows except the fifth.
m2 <- matrix(1:21, nrow = 7, ncol = 3, byrow = FALSE)
m2[-5, c(1,3)]

# Problem 8 For matrix m2 <- matrix(1:21, nrow = 7, ncol = 3, byrow = FALSE) select columns 
# with even numbers and rows with odd numbers.
m2 <- matrix(1:21, nrow = 7, ncol = 3, byrow = FALSE)
m2
m2[, seq(2, ncol(m2), 2)]
m2[seq(2, nrow(m2), 2), ]



# The most important fact: vectors are recycled
s <- seq(100, 600, 100)
s

a <- 1:10

a + s # The s vector got looped, and there is a warning!

a[1:length(s)] + s


# Binding vectors into matrices
as1 <- cbind(a[1:6], s)
as1

class(as1)

as2 <- rbind(a[1:6], s)
as2


