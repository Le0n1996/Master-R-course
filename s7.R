# If your R uses not English language by default:
Sys.setenv(LANG = "en") # Windows
system("defaults write org.R-project.R force.LANG en_US.UTF-8") # Mac


# Plan:
# 1. Simple linear models
# 2. Alternative specifications
# 3. Outputting beautiful tables
# 4. Various functional forms
# 5. Basic sensitivity diagnostics

# 6. Demonstration: why omitting variables is bad
# 7. Demonstration: why adding extra variables is not bad if there are many observations

# 8. Estimating probit and logit models
# 9. Interpretation and marginal effects

# 10. Graphs

# Now we say hello to a new structure---a list
# Lists are very general containers that can contain objects of various types
# Literally. Absolutely. Any type of object that can be stored can be put in a list
l <- list(seq(3, 5, 0.1), TRUE, c("John", "Mary")) # This list has 3 elements
l
str(l)
l[[1]] # Returns its first element
l[[2]]
l[[3]]
l[[1]][5:7] # Subsetting operations can be chained

l <- list(num = seq(3, 5, 0.1), val = TRUE, names = c("John", "Mary")) # This list has 3 elements
l$names
l[[3]]

# What is a linear model
# Let us have a look; you need not understand the code, just watch this simple demonstration
library(MASS)
library(rgl)
library(shiny)
set.seed(1) #For reproducable results
n <- 200

# Defining the parameters of the distribution of regressors we are going to use
covmat <- matrix(c(3, 2, 2, 4), nrow = 2)
# Draw random variables from multivariate normal distribution with mean c(1,2), variances 1 and covariance 0.7
X <- mvrnorm(n, mu = c(1, 2), Sigma = covmat)
X1 <- X[, 1]
X2 <- X[, 2]
U <- rnorm(n) * (1 + 0.5 * abs(X1 - min(X1)) + 0.5 * abs(X2 - min(X2))) # The only time in your life you see true errors

# Suppose Y is a linear function og X1 and X2, and one wants to get the parameters of that linear function
Y <- 0.35 + 0.4 * X1 + 0.2 * X2 + U / 3

# There is a different variable that is linear in only one regressor
Y1 <- 0.35 + 0.4 * X1 + U / 3

data1 <- data.frame(Y, Y1, X1, X2)
rm(Y, Y1, X1, X2)

plot(data1$X1, data1$Y) # Seems sort of linear
plot(data1$X2, data1$Y) # Seems linear

plot(data1$X1, data1$Y1) # Seems linear as well

# The simplest way to estimate a linear model:
library(lmtest)
library(sandwich)

mod0 <- lm(Y1 ~ X1, data = data1)
coeftest(mod0, vcov. = vcovHC)
# The true parameters are (0.35, 0.4)
# The estimates are (0.26, 0.45) --- not far away

# It is essential and obligatory to use coeftest with vcovHC for inference!
# Otherwise it will return wrong standard errors!

# Any linear model output is a list. Let's see what it contains
str(mod0)
mod0$coefficients # The estimates
mod0$residuals # Residuals
# Check the first-order conditions
summary(mod0$residuals) # Mean 0
cov(mod0$residuals, data1$X1) # Machine 0
mod0$fitted.values # Predicted values from the model
# One can plot the results
plot(data1$X1, data1$Y1)
abline(mod0)
points(data1$X1, mod0$fitted.values, pch = 16)
# Speaking of prediction, your model can give predictions!
Xnew <- c(-2, 0, 3)
Ynew <- predict(mod0, newdata = list(X1 = Xnew))
points(Xnew, Ynew, col = "red", pch = 16, cex = 2)

# There is a built-in `summary` function, but it returns wrong standard errors!
# We use it `only` to get extra diagnostics
sum0 <- summary(mod0)
sum0 # The standard errors, the t values, and p values are wrong! This is due to historical reasons
# There are even better ways to do inference on coefficients, like bootstrap, but are outside the scope of this course
sum0$r.squared # The ratio of signal to (signal + noise) in our model is 10%
# There is no such thing as good, enough, or just-right R-squared
# It just shows the relationship between the error and the dependent variable
# and says nothing about the model quality

# Now let us estimate a model with two regressors
mod1 <- lm(Y ~ X1 + X2, data = data1)
coeftest(mod1, vcov. = vcovHC)
# The true parameters are (0.35, 0.4, 0.2)
# The estimates are (0.26, 0.45, 0.20) --- not far away

# Now, it is important to remember how to interpret p values

# The following block of code should be run once
# BEGIN RUN OH NO RGL
rgl.open()
bg3d("white")
rgl.spheres(x = data1$X1, y = data1$Y, z = data1$X2, r = 0.15, color = "#D95F02")
axes3d()
title3d(xlab = "X1", zlab = "X2", ylab = "Y")
aspect3d("iso")
grid.lines <- 10
x1.pred <- seq(min(data1$X1), max(data1$X1), length.out = grid.lines)
x2.pred <- seq(min(data1$X2), max(data1$X2), length.out = grid.lines)
xx <- expand.grid(X1 = x1.pred, X2 = x2.pred)
y.pred <- matrix(predict(mod1, newdata = xx), nrow = grid.lines, ncol = grid.lines)
rgl.surface(x1.pred, x2.pred, y.pred, color = "steelblue", alpha = 0.5, lit = FALSE)
rgl.surface(x1.pred, x2.pred, y.pred, color = "black", alpha = 0.5, lit = FALSE, front = "lines", back = "lines")
# END RUN
# This is the kind of thing we are going to be estimating today!

# Now, the first useful example: a linear regression
mtcars
cor(mtcars$mpg, mtcars$hp)
# mpg: miles per gallon, fuel efficienct
# There is a negative correlation between fuel efficiency and horsepower (hp)
# What is its exact effect?
mod0 <- lm(mpg ~ hp, data = mtcars)
coeftest(mod0, vcov = vcovHC)
# Each horsepower gives minus 0.07 miles per gallon
# However, the base level of fuel efficiency can be different for cars with a different number of cylinders
# We suppose that the model looks like this:
# mpg = a4 + beta*hp for cars with 4 cylinders
# mpg = a6 + beta*hp for cars with 6 cylinders
# mpg = a8 + beta*hp for cars with 8 cylinders
# In general, this can be simplified:
# mpg = a4 + (diff6 if 6 cyls?) + (diff8 if 8 cyls?) + beta*hp
# We need to convert this variable in to a set of factor levels and take the first as baseline:
mod1 <- lm(mpg ~ hp + factor(cyl), data = mtcars)
coeftest(mod1, vcov = vcovHC)
# Turns out, after accounting for the omitted variable, horsepower has almost no effect,
# and it is the number of cylinders that matters
# 6-cyl cars yield approx. 5.96 fewer miles per gallon compared to 4-cyl
# 8-cyl cars yield approx. 8.52 fewer miles per gallon compared to 4-cyl

# However, maybe the dependence on hp is not linear but quadratic?
plot(mtcars$hp, mtcars$mpg)
mod2 <- lm(mpg ~ hp + I(hp^2) + factor(cyl), data = mtcars)
coeftest(mod2, vcov = vcovHC)
points(mtcars$hp, mod2$fitted.values, col = ifelse(mtcars$cyl == 4, "darkgreen", ifelse(mtcars$cyl == 6, "darkorange", "red")), pch = 16)

# Maybe it is not quadratic, just linear, but the slopes are different for every category?
plot(mtcars$hp, mtcars$mpg)
mod3 <- lm(mpg ~ hp * factor(cyl), data = mtcars)
coeftest(mod3, vcov = vcovHC)
# Here, we see a problem: too many parameters, too few data points
points(mtcars$hp, mod3$fitted.values, col = ifelse(mtcars$cyl == 4, "darkgreen", ifelse(mtcars$cyl == 6, "darkorange", "red")), pch = 16)
updateR() 
# We want to test a linear hypothesis that the slopes of the red and yellow ones are the same. How do we do it?
library(car)
linearHypothesis(mod3, "hp:factor(cyl)6 = hp:factor(cyl)8", vcov. = vcovHC) # This hypothesis is not rejected
# Other hypotheses can be tested
linearHypothesis(mod3, "hp = 0", vcov. = vcovHC)
linearHypothesis(mod3, c("hp = 0", "hp:factor(cyl)6 = factor(cyl)8"), vcov. = vcovHC) # This is a silly hypothesis
# We can increase accuracy by taking into account this information
mtcars$cylnew <- factor(ifelse(mtcars$cyl == 4, "base", "6or8"))
mtcars$cylnew <- relevel(mtcars$cylnew, ref = "base")
mod4 <- lm(mpg ~ hp + factor(cyl) + hp:factor(cylnew), data = mtcars)
coeftest(mod4, vcov = vcovHC)
# Here, we see a problem: too many parameters, too few data points
plot(mtcars$hp, mtcars$mpg, bty = "n", xlab = "Horsepower", ylab = "MPG", main = "Fuel efficiency analysis")
points(mtcars$hp, mod4$fitted.values, col = ifelse(mtcars$cyl == 4, "darkgreen", ifelse(mtcars$cyl == 6, "darkorange", "red")), pch = 16)
# How the slope is the same for 6- and 8-cylinder cars!

# Sometimes, coeftest with vcovHC might result in an error
mod.broken <- lm(mpg ~ factor(cyl) + disp + hp + wt + vs + am + factor(gear) + factor(carb), data = mtcars)
# This model is broken in the sense that there are too many dummies, and some combinations of them
# apply to only one observations (singleton), and there is no statistical uncertainty
coeftest(mod.broken, vcov. = vcovHC)
# A very quick fix is slightly modifying the expression by introducing a very rough simple version
# of robust errors (which is, incidentally, the default in STATA)
coeftest(mod.broken, vcov. = vcovHC, type = "HC1")

# How do we report these results
library(stargazer)
# You remember those fancy tables with coefficients, standard errors and significance stars?
# The only thing we need is a list of standard errors
# They are the square root of the diagonal of the variance-covariance matrix of a model,
# so we prepare them
se0 <- sqrt(diag(vcovHC(mod0)))
se1 <- sqrt(diag(vcovHC(mod1)))
se2 <- sqrt(diag(vcovHC(mod2)))
se3 <- sqrt(diag(vcovHC(mod3)))
se4 <- sqrt(diag(vcovHC(mod4)))

stargazer(mod0, mod1, mod2, mod3, mod4, se = list(se0, se1, se2, se3, se4), type = "html", out = "session6-outtable.html")
# How open this file in Firefox!

# Looks a bit ugly, so we prettify the names
names(mod0$coefficients)
names(mod1$coefficients)
names(mod2$coefficients)
names(mod3$coefficients)
names(mod4$coefficients)
names(mod0$coefficients)[2] <- "Horsepower"
names(mod1$coefficients)[2:4] <- c("Horsepower", "Diff. 4-6 cyl", "Diff. 4-8 cyl")
names(mod2$coefficients)[2:5] <- c("Horsepower", "Horsepower squared", "Diff. 4-6 cyl", "Diff. 4-8 cyl")
names(mod3$coefficients)[2:6] <- c("Horsepower 4 cyl", "Diff. 4-6 cyl", "Diff. 4-8 cyl", "Diff. Horsepower 4-6 cyl", "Diff. Horsepower 4-8 cyl")
names(mod4$coefficients)[2:5] <- c("Horsepower 4 cyl", "Diff. 4-6 cyl", "Diff. 4-8 cyl", "Diff. Horsepower 4-higher cyl")

stargazer(mod0, mod1, mod2, mod3, mod4, se = list(se0, se1, se2, se3, se4), type = "html", out = "session6-outtable.html")





#  Some researchers estimate models in logs because they want elasticities
mod.alt.1 <- lm(mpg ~ hp + factor(cyl), data = mtcars) # A change of hp by 1 causes efficiency to go down by 0.068 after controlling for the number of cylinders
mod.alt.2 <- lm(I(log(mpg)) ~ hp + factor(cyl), data = mtcars) # Here, things are trickier
(exp(mod.alt.2$coefficients["hp"]) - 1) * 100 # Approximate percentage change, almost insignificant:
# A change of hp by 1 causes efficiency to go down by 0.12% after controlling for the number of cylinders
mod.alt.2$coefficients["factor(cyl)6"]
(exp(mod.alt.2$coefficients["factor(cyl)6"]) - 1) * 100 # 6-cyl cars are approx. 21.5% less efficient, NOT 24.2!
# Note that when log(dependent variable) is taken, the interpretation is APPROXIMATE!
mod.alt.3 <- lm(mpg ~ log(hp) + factor(cyl), data = mtcars)
# Here, an increase of hp 2.718 times (e) causes a change of efficiency by -5.86 miles per gallon after controlling for the number of cylinders
# However, a more intuitive interpretation has percentages
mod.alt.3$coefficients["log(hp)"] * log(1 + 1 / 100) # A change of hp by 1 per cent causes this change of MPG efficiency
mod.alt.3$coefficients["log(hp)"] * log(1 + 10 / 100) # Note that a 10% change does not cause a 10*effect of a 1% change
mod.alt.4 <- lm(I(log(mpg)) ~ I(log(hp)) + factor(cyl), data = mtcars) # A change of hp by 1 causes efficiency to go down by 0.068
mod.alt.4$coefficients[2] # a 1% change of horsepower causes a -0.26% change of MPG efficiency after controlling for the number of cylinders








# How to do some quick diagnostics
plot(mod4)
infl <- influence(mod4)
infl$coefficients # How removal of one observation affects the coefficient
library(car)
outlierTest(mod4)

plot(mtcars$hp, mtcars$mpg, bty = "n", xlab = "Horsepower", ylab = "MPG", main = "Fuel efficiency analysis")
points(mtcars$hp, mod4$fitted.values, col = ifelse(mtcars$cyl == 4, "darkgreen", ifelse(mtcars$cyl == 6, "darkorange", "red")), pch = 1, cex = 2)
points(mtcars$hp[rownames(mtcars) == "Lotus Europa"], mtcars$mpg[rownames(mtcars) == "Lotus Europa"], pch = 16, cex = 2)

# Although this is not good practice, and this is just a toy example, one may need to drop observations
# with strange values if evidence says there might be coding erro
restriction <- rownames(mtcars) != "Lotus Europa"
mod4.fixed <- lm(mpg ~ hp + factor(cyl) + hp:factor(cylnew), data = mtcars, subset = restriction)
round(cbind(mod4$coefficients, mod4.fixed$coefficients), 4)
points(mtcars$hp[restriction], mod4.fixed$fitted.values, col = ifelse(mtcars$cyl[restriction] == 4, "darkgreen", ifelse(mtcars$cyl[restriction] == 6, "darkorange", "red")), pch = 2, cex = 1.2)

# Finally, one can use re-weighted fitting that reduces the impact of influential points without discarding them
mod4.reweighted <- rlm(mpg ~ hp + factor(cyl) + hp:factor(cylnew), data = mtcars)
round(cbind(mod4$coefficients, mod4.fixed$coefficients, mod4.reweighted$coefficients), 4)
points(mtcars$hp, mod4.reweighted$fitted.values, col = ifelse(mtcars$cyl == 4, "darkgreen", ifelse(mtcars$cyl == 6, "darkorange", "red")), pch = 16, cex = 0.9)
# We see that the reweighted estimator is very close to the one where one observation was deleted






# A demonstration: if you have a large data set, try to control for omitted variables
# Including an irrelevant variable does not cause any biases, but omission of relevant ones does!
# Just watch; do not think too much abour the data design, think about the conclusions
set.seed(1)
n <- 3000
V <- matrix(5, nrow = 5, ncol = 5) + diag(rep(1, 5))
X <- mvrnorm(n, mu = rep(1, 5), Sigma = V)
U <- rnorm(n, 0, 3) * sqrt(rowSums(abs(X + 3) + 1))

# This is the same as Y = 1 + 1*X1 + 1*X2 + 1*X3 + 1*X4 + 1*X5 + U
Y <- 1 + rowSums(X) + U
# We run a regression on 5, 4, 3, and 2 variables respectively
mod_full <- lm(Y ~ X[, 1:5])
coeftest(mod_full, vcov = vcovHC)

mod_without_X5 <- lm(Y ~ X[, 1:4])
coeftest(mod_without_X5, vcov = vcovHC)
plot(X[, 4:5], bty = "n") # See that X4 and X5 are strongly correlated
summary(mod_without_X5)$r.squared

mod_without_X4X5 <- lm(Y ~ X[, 1:3])
coeftest(mod_without_X4X5, vcov = vcovHC)
summary(mod_without_X4X5)$r.squared

mod_without_X3X4X5 <- lm(Y ~ X[, 1:2])
coeftest(mod_without_X3X4X5, vcov = vcovHC)
summary(mod_without_X3X4X5)$r.squared
# Here, the Multiple R-squared is high but the estimates are severely biased

# Now, we generate some irrelevant variables (white noise) and add it into the full regression
garbage <- mvrnorm(n, mu = rep(0, 20), Sigma = diag(rep(1, 20))) + 0.5 * rowMeans(X)
Xextended <- cbind(X, garbage) # Create a full matrix of regressors
colnames(Xextended) <- c(paste0("X", 1:5), paste0("garbage", 1:20))

modgarbage <- lm(Y ~ Xextended)
coeftest(modgarbage, vcov = vcovHC)
summary(modgarbage)$r.squared
summary(mod_full)$r.squared
# You see that the coefficients for relevant variables are almost the same,
# and for garbage variables, close to zero!
barplot(rbind(mod_full$coefficients, modgarbage$coefficients[1:6]), beside = TRUE, names.arg = paste0("beta", 0:5))

# Moral of the story: do not exclude variables if they might affect the regressand

# However, models can be non-linear
# One can model probability that does not exceed 1 and does not go below 0
psid <- read.csv("data/psid1990.csv")
# age : age in years;
# male : 1 for males, 0 for females.
# empl : 1 for working now, 2 for temporarily laid off, 3 for unemployed looking for work, 4 for retired, 5 for
#  permanently disabled, 6 for housewife, 7 for student, 8 for other.
# educ : highest grade or year of school if not postgraduate.
# postgrad : 1 for at least some postgraduate work, 0 otherwise.
# inc : taxable money income (or loss) of the individual (censored at levels 9,999 or 99,999 and −99,999 or −99,999).
# tran : transfer money income (censored at 99,999).
# hours : work hours.
# bwnorm : 1 if birth weight was above 88 oz., 0 otherwise.
# children : the number of live births to this individual as of 1990.
# marr : number of marriages.
# currmarr : 1 for married, 2 for never married, 3 for widowed, 4 for divorced, 5 for separated.

# Some people are getting social transfers from the government. What affects them? Can we model that?
summary(psid)
table(psid$empl)
psid <- psid[psid$inc >= 0, ]
psid <- psid[psid$totinc >= 0, ]
psid <- psid[psid$empl != 8, ]
psid <- psid[!is.na(psid$marr) & !is.na(psid$currmarr) & !is.na(psid$children), ]
psid$social <- as.numeric(psid$tran > 0)
mean(psid$social) # 26% people are getting transfers

# The income might affect it, but it is a monetary indicator, so we take its log

# First, we estimate a very simple, but inherently misspecified linear model with `social` as a dependent variable
mod.lp <- lm(social ~ I(log(inc)) + age + I(age^2) + male + children + educ + postgrad + factor(empl) + marr + factor(currmarr) + bwnorm, data = psid)
coeftest(mod.lp, vcov. = vcovHC)

# It is hard to interpret the age. Can we average the effect of age and get its average marginal effect?
library(margins)
m.lp <- margins(mod.lp)
summary(m.lp)

# Now, we estimate a probit and a logit model
mod.probit <- glm(social ~ I(log(inc)) + age + I(age^2) + male + children + educ + postgrad + factor(empl) + marr + factor(currmarr) + bwnorm, data = psid, family = binomial(link = "probit"))
mod.logit <- glm(social ~ I(log(inc)) + age + I(age^2) + male + children + educ + postgrad + factor(empl) + marr + factor(currmarr) + bwnorm, data = psid, family = binomial(link = "logit"))

# Model summary
summary(mod.probit) # Assuming correct specification
summary(mod.logit)

coeftest(mod.probit)
coeftest(mod.probit, vcov. = vcovHC) # Here, the robustness does NOT come from the residual distribution
# It is assumed to be fully parametrised, so instead, we are guarding against potential
# mis-specification of the conditional distribution of model errors

# These models are not directly comparable or interpretable!
# This is almost useless:
stargazer(mod.probit, mod.logit, type = "text")

# However, we can first compare the coefficients by adjusting those by a correcting factor of sqrt(3)
round(cbind(mod.probit$coefficient, mod.logit$coefficients / sqrt(3)), 3)

# But the effects of these variables must be computed additionally
m.logit <- margins(mod.logit)
m.probit <- margins(mod.probit)
sum.prob <- summary(m.logit)
sum.prob
sum.log <- summary(m.probit)
sum.log

round(cbind(sum.prob$AME, sum.log$AME), 4) # Almost identical

# This means that the number of children has a negative impact on the amount of social transfers
# Employment status 5 (permanently disabled) is very significant. The probability of getting
# transfers for disabled people of 0.4 higher than that for non-disabled

# Hypotheses can be tested
summary(mod.probit)
# Comparing the effect for widowed and never married
linearHypothesis(mod.probit, "factor(currmarr)2 = factor(currmarr)3")

# The effect of age is non-linear
m.probit.age <- margins(mod.probit, at = list(age = c(18, 40, 60))) # Might take a minute or two
m.probit.age
summary(m.probit.age)
# We see that the probability of getting transfers due to an extra year at the age of 18 is 3.5 percentage POINTS lower
# and at the age of 60, 2.3 percentage POINTS higher

# If `margins` is too slow, it can be done in a quicker (and a much worse) way:
library(mfx)
mfx.probit <- probitmfx(social ~ I(log(inc)) + age + I(age^2) + male + children + educ + postgrad + factor(empl) + marr + factor(currmarr) + bwnorm, data = psid)
mfx.probit

mfx.logit <- logitmfx(social ~ I(log(inc)) + age + I(age^2) + male + children + educ + postgrad + factor(empl) + marr + factor(currmarr) + bwnorm, data = psid)
mfx.logit
# However, note that it does NOT expand expressions! Only margins() from library(margins) does this

# In order to output the models with marginal effects, we have to estimate two silly models
# with variables as they are in the output list, in that order:
sum.prob
mod.probit.silly <- glm(social ~ age + bwnorm + children + factor(currmarr) + educ + factor(empl) + inc + male + marr + postgrad, data = psid, family = binomial(link = "probit"))
mod.logit.silly <- glm(social ~ age + bwnorm + children + factor(currmarr) + educ + factor(empl) + inc + male + marr + postgrad, data = psid, family = binomial(link = "logit"))
mod.probit.silly$coefficients <- mod.probit.silly$coefficients[-1]
mod.logit.silly$coefficients <- mod.logit.silly$coefficients[-1]
cbind(sum.prob$factor, names(mod.probit.silly$coefficients), names(mod.logit.silly$coefficients)) # Good
marg.probit <- sum.prob$AME
marg.logit <- sum.log$AME
marg.se.probit <- sum.prob$SE
marg.se.logit <- sum.log$SE
# Prettifying
marg.probit["inc"] <- marg.probit["inc"] * 10000
marg.se.probit["inc"] <- marg.se.probit["inc"] * 10000
marg.logit["inc"] <- marg.logit["inc"] * 10000
marg.se.logit["inc"] <- marg.se.logit["inc"] * 10000

names(mod.probit.silly$coefficients) <- names(mod.logit.silly$coefficients) <- names(marg.probit) <- names(marg.logit) <- names(marg.se.probit) <- names(marg.se.logit) <- c("Age", "Good birth weight", "No. of children", "Never married", "Widowed", "Divorced", "Separated", "Education (years)", "Temprarily laid off", "Unemployed", "Retired", "Disabled", "Housewife", "Student", "Income, tens of thousands $", "Male", "Total No. of marriages", "Post-graduate")

stargazer(mod.probit.silly, mod.logit.silly, coef = list(marg.probit, marg.logit), se = list(marg.se.probit, marg.se.logit), type = "html", out = "session6-marginal-effects.html") 

# Visualising marginal effects
plot(m.probit)
cp <- cplot(mod.probit, x = "age", dx = "age", what = "effect", n = 10) # Takes a lot of time, maybe 5 minutes

# We can predict probabilities that the dependent variable will be 
psid$predicted.prob <- predict(mod.probit, type = "response")
plot(psid$age, psid$social, pch = 16, col = "#00000015") # Notice two darker regions on top!
points(psid$age, psid$predicted.prob, pch = 16, col = "darkred", cex = 0.5)
# However, sometimes we want to model outcomes. What do we do! At which level do we cut off?

psid$predicted50 <- as.numeric(psid$predicted.prob > 0.5)
table(psid$social, psid$predicted50)

# We can try various cut-offs
table(psid$social, as.numeric(psid$predicted.prob > 0.05)) # Too many predicted 1's, we never predict correct 0's
table(psid$social, as.numeric(psid$predicted.prob > 0.95)) # Too many predicted 0's, we never predict correct 1's







# Graphs
library(ggplot2)
dat <- read.csv("https://raw.githubusercontent.com/allatambov/R-programming-3/master/lectures/lect9-02-02/wgi_fh_new.csv", dec = ",")
dat <- na.omit(dat)

ggplot(data = dat, aes(x = va, y = rl)) +
  geom_point() + 
  labs(title = "WGI indicators", 
       x = "Voice and Accountability", 
       y = "Rule of Law") 

ggplot(data = dat, aes(x = va, y = rl)) +
  geom_point() + 
  labs(title = "WGI indicators", 
       x = "Voice and Accountability", 
       y = "Rule of Law") + stat_ellipse()

ggplot(data = dat, aes(x = va, y = rl)) +
  geom_point() + 
  labs(title = "WGI indicators", 
       x = "Voice and Accountability", 
       y = "Rule of Law") + 
  geom_smooth(method = lm)

ggplot(data = dat, aes(x = va, y = rl)) +
  geom_point() + 
  labs(title = "WGI indicators", 
       x = "Voice and Accountability", 
       y = "Rule of Law") + 
  geom_smooth(method =loess)


# Limits vs coordinates
g <- ggplot(midwest, aes(x=area, y=poptotal)) + geom_point() + geom_smooth(method="lm")

# Limits
g + xlim(c(0, 0.1)) + ylim(c(0, 1000000))

# Coordinations cartesian
g + coord_cartesian(xlim=c(0,0.1), ylim=c(0, 1000000))

# Separate models for subgroups
data(mpg, package="ggplot2")
# mpg <- read.csv("http://goo.gl/uEeRGu")

mpg_select <- mpg[mpg$manufacturer %in% c("audi", "ford", "honda", "hyundai"), ]

# Scatterplot
theme_set(theme_bw())  # pre-set the bw theme.
g <- ggplot(mpg_select, aes(displ, cty)) + 
  labs(subtitle="mpg: Displacement vs City Mileage",
       title="Bubble chart")

g + geom_jitter(aes(col=manufacturer, size=hwy)) + 
  geom_smooth(aes(col=manufacturer), method="lm", se=F)

