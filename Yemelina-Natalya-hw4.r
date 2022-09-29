library(plyr)
library(dplyr)
library(ggplot2)

###### Question 1. 
# Load the data from fatality.csv using the fread function from the data.table package. 
# How many observations does it contain?

library(data.table)
d <- fread("fatality.csv")
# Database contains 336 observations.


###### Question 2. 
# Create a histogram with bin width 0.2 and a kernel density plot (smooth histogram) 
# with a rug for the variable beertax. Label the axes properly, add a title. 
# Use any plotting theme that does not have background colour but has subtle axis lines instead.

ggplot(data = d, aes(x = beertax, y = ..density..)) +
  geom_histogram(binwidth = 0.2, 
                 fill = "yellowgreen", color = "black")+
  geom_density(col = "red") +
  labs(title = "State beer tax on American states in 1988, USD", 
       x = "Beer tax", 
       y = "Density") +
  theme_bw()


###### Question 3. 
# Generate a new variable in the data frame, fatalityrate, based on mrall, equal to fatality 
# rate per 10,000 people, and provide its summary statistics.

d1 <- mutate(d, fatalityrate = mrall*10000)
summary(d1$fatalityrate)


###### Question 4.
# Plot the two variables, beertax and fatalityrate. Make it colourful: colour the points by 
# the variable state (observations from the same state should have the same colour). 
# Do not forget to label the axes and to add a title to the plot. Create a second plot like 
# the one before, but colour points according to year, and add a legend explaining which colour 
# corresponds to which year.

g1 <- ggplot(d1, aes(x=beertax, y=fatalityrate)) +
  geom_point(aes(col=state), size=3) +
  labs(title = "Fatality rate by beer tax", 
       x = "Beer tax", 
       y = "Fatality rate")+
  theme_classic()
g1

g2 <- ggplot(d1, aes(x=beertax, y=fatalityrate)) +
  geom_point(aes(col=year), size=3) +
  labs(title = "Fatality rate by beer tax", 
       x = "Beer tax", 
       y = "Fatality rate")+
  theme_classic()
g2


###### Question 5.
# Estimate a simple linear model where fatalityrate is the dependent variable and beertax is 
# the explanatory variable. Report the coefficients and heteroskedasticity-robust standard errors. 
# Is beer an effective measure to reduce fatality rate? Is it statistically significant? 
# Create a plot with semi-opaque points in one colour (like in question 4), and add the regression line.

m1 <- lm(data=d1, fatalityrate ~ beertax)
coeftest(m1, vcov. = vcovHC)
summary(m1)

plot(d1$beertax, d1$fatalityrate, xlab = "Beer tax", ylab = "Fatality rate",
     main = "Beer tax efficiency analysis", col="darkblue")
abline(m1)


###### Question 6.
# Are you sure that the beer tax can fully explain the variability in fatality rate? 
# Can you think of any other factors that can affect it, but are not included in the model?



###### Question 7.
# Estimate a new model, adding spircons as an explanatory variable. 
# Report heteroskedasticity-robust standard errors. Interpret the results. 
# Are the slope coefficients individually significant? 
# Test the joint significance of coefficients on spircons and beertax. 
# Comment the results. Does this result seem counter-intuitive?

m2 <- lm(data=d1, fatalityrate ~ beertax + spircons)
coeftest(m2, vcov. = vcovHC)
summary(m2)

library(car)
linearHypothesis(m2, c("beertax = 0", "spircons=0"), test = "F", vcov. = vcovHC)


###### Question 8.
# Now, add intercept time dummies to the last model (in other words, add a factor variable 
# for the year using the factor function). Did the overall fatality rate change over time 
# ceteris paribus? Make a plot showing the time effect (on the x axis, years 1983, ..., 1987, 
# and on the y axis, coefficients on the time dummies).

m3 <- lm(data=d1, fatalityrate ~ beertax + spircons + factor(year))
coeftest(m3, vcov. = vcovHC)
summary(m3)

plot(d1$year[2:7], m3$coefficients[4:9], xlab = "Year", ylab = "Time effect",
      main = "Time efficiency analysis", col="darkblue", pch = 20 )
lines(d1$year[2:7], m3$coefficients[4:9])
text(d1$year[2:7], m3$coefficients[4:9], labels = round(m3$coefficients[4:9], 2), cex = 0.75, pos = 3)


###### Question 9.
# Now, add state dummy variables (again, use the factor function) into the model in order to control
# for unobserved heterogeneity across states. Report heteroskedasticity-robust standard errors.
# What can you say about the effect of the beer tax now? Is it significant? 
# Plot two series of points in one plot: fatalityrate (y axis) versus beertax (x axis), 
# and predicted values of fatalityrate (y axis) from this regression model versus beertax (x axis) 
# (in a different colour).

m4 <- lm(data=d1, fatalityrate ~ beertax + spircons + factor(year) + factor(state))
coeftest(m4, vcov. = vcovHC)
summary(m4)

ggplot(d1, aes(x=beertax, y=fatalityrate, color="Actual")) +
  geom_point() +
  geom_point(aes(x=d1$beertax, y=m4$fitted.values, color="Fitted")) +
  labs(title = "Fatality rate by beer tax", 
       x = "Beer tax", 
       y = "Fatality rate",
       color = "") +
  theme_classic()


###### Question 10.
# Output an HTML table comparing these four models using the stargazer package, 
# copy and paste it into your text file. (If you are using LaTeX, output a LaTeX table and 
# copy and paste it.) Use the built-in help to learn how to add an extra row (line) of statistics 
# or how to omit certain variables from output. Drop the time effects and state effects lines from 
# reporting, instead, add two new ones: ‘Time effects’ that says ‘No’ for the first two models 
# and ‘Yes’ for the last two ones, and ‘State fixed effects’ that says ‘No’ for the first three models
# and ‘Yes’ for the last one. You should write a command that will do it for you, thus eliminating 
# the need to post-process and remove rows manually. (Hint: do not forget to supply the list of 
# heteroskedasticity-robust standard errors as one of the arguments of the stargazer command.)

library(stargazer)

stargazer(m1, m2, m3, m4, type = "html", title="Regression Results", 
          column.labels=c("Model 1", "Model 2", "Model 3", "Model 4"),
          model.numbers = FALSE, 
          omit=c("factor(year)*", "factor(state)*"),
          order=c("Constant", "beertax", "spircons"),
          add.lines=list(c("Time effects", "No", "No", "Yes", "Yes"), 
                         c("State fixed effects", "No", "No", "No", "Yes")),
          out = "HW_outtable.html", no.space=TRUE)


###### Question 11.
# Write a short summary of your findings about the impact of beer tax on vehicle fatality rate and 
# provide an explanation for the different estimates of beer tax effect in these 4 models. 
# Which one, in your opinion, is the best one for policymakers?











