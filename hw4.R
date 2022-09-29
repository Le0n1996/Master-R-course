## Problem 1
library(data.table) # activate
fat <- fread("fatality.csv") # read
View(fat) # look at the dataset
# As we can see, there are 336 observations in total

## Problem 2
library(ggplot2) # activate
library(hrbrthemes) # activate for themes
ggplot(data = fat, aes(x = beertax, y = ..density..)) + # ..density.. is used for combining both histogram & density on one graph
  geom_histogram(binwidth = 0.2,                        # set bin width
                 fill = "yellowgreen", color = "black") +
  geom_density(col = "red") + theme_ipsum() +
  labs(title = "Beer taxes in American states, in USD", 
       x = "Beer tax", 
       y = "Density (frequency)")

## Problem 3
library(dplyr) # activating dplyr for mutate
fatrat <- mutate(fat, fatalityrate = mrall*10000)
summary(fatrat$fatalityrate)

## Problem 4
graph1 <- ggplot(fatrat, aes(x = beertax, y = fatalityrate)) +
  geom_point(aes(col = state), size = 2) + theme_ipsum() +
  labs(title = "Fatality rate by beer tax", 
       x = "Beer tax", 
       y = "Fatality rate")
graph1
graph2 <- ggplot(fatrat, aes(x = beertax, y = fatalityrate)) +
  geom_point(aes(col = year), size = 2) + theme_ipsum() +
  labs(title = "Fatality rate by beer tax", 
       x = "Beer tax", 
       y = "Fatality rate") # legend is here; darker colours correspond to earlier years
graph2

## Problem 5
library(lmtest) # import package for linear models
library(sandwich)
model <- lm(fatalityrate ~ beertax, data = fatrat)
model$coefficients # if we want to see only coefficients for our model
coeftest(model, vcov. = vcovHC) # with heteroskedasticity-robust s.e.
summary(model, vcov. = vcovHC)
plot(fatrat$beertax, fatrat$fatalityrate, xlab = "Beer tax", ylab = "Fatality rate",
     main = "Beer tax efficiency", col="darkgreen")
abline(model, col = "red")

## Problem 6

## Problem 7
library(car) # can be used for fast diagnostics
model2 <- lm(fatalityrate ~ beertax + spircons, data = fatrat) # new model with spircons added
coeftest(model2, vcov. = vcovHC)
summary(model2, vcov. = vcovHC)
linearHypothesis(model2, c("beertax = 0", "spircons=0"), test = "F", vcov. = vcovHC)

## Problem 8
fatrat <- mutate(fatrat, fyear = factor(year)) # create dummies
model3 <- lm(fatalityrate ~ beertax + spircons + fyear, data = fatrat) # using it to fit model
coeftest(model3, vcov. = vcovHC)
summary(model3, vcov. = vcovHC)
# Plotting now:
plot(fatrat$year[2:6], model3$coefficients[4:8], xlab = "Year", ylab = "Time effect", ylim = c(-0.12,-0.02),
     main = "Time effect", col="darkgreen", pch = 20 ) # as we need years 1983-1987
lines(fatrat$year[2:6], model3$coefficients[4:8])
text(fatrat$year[2:6], model3$coefficients[4:8], labels = round(model3$coefficients[4:8], 2), cex = 0.75, pos = 1)

## Problem 9
fatrat <- mutate(fatrat, fstate = factor(state)) # create dummies for state
model4 <- lm(fatalityrate ~ beertax + spircons + fyear + fstate, data = fatrat) # fit model
coeftest(model4, vcov. = vcovHC)
summary(model4, vcov. = vcovHC)
#Plotting:
ggplot(fatrat, aes(x = beertax, y = fatalityrate, color = "Actual")) +
  geom_point() + theme_ipsum() +
  geom_point(aes(x = beertax, y = model4$fitted.values, color = "Fitted")) +
  labs(title = "Fatality rate by beer tax", 
       x = "Beer tax", 
       y = "Fatality rate",
       color = "")

## Question 10
library(stargazer) # activate
# We need heteroskedasticity-robust standard errors:
se1 <- sqrt(diag(vcovHC(model)))
se2 <- sqrt(diag(vcovHC(model2)))
se3 <- sqrt(diag(vcovHC(model3)))
se4 <- sqrt(diag(vcovHC(model4))) # calculated
stargazer(model, model2, model3, model4, se = list(se1, se2, se3, se4), type = "html", title = "Regression Results", 
          model.numbers = FALSE, column.labels = c("Model 1", "Model 2", "Model 3", "Model 4"), # use our names
          omit = c("fyear*", "fstate*"), # omit all with reg.exp
          order = c("Constant", "beertax", "spircons"), # otherwise constant is the last one
          add.lines = list(c("Time effects", rep("No", 2), rep("Yes", 2)), 
                         c("State fixed effects", rep("No", 3), "Yes")),
          out = "Reg_results.html")

## Question 11
