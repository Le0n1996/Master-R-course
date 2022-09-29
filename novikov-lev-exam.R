## Problem 1

dat <- read.csv("demography.csv") # import data
View(dat) # we can look and see 21 groups

#1
ages <- seq(2.5, 102.5, 5) # corresponding ages
sum(ages*dat$Fertility)/sum(dat$Fertility) # don't forget to normalize
# So the answer a = 30.01094. Seems reasonable enough

#2
f <- dat$Fertility/(2*sum(dat$Fertility)) # as we assuming half of children are boys


## Problem 2 (THE MAIN ONE)

#1
library(data.table)
fat <- fread("fatality.csv")
View(fat)
# As we can see, there are 336 observations in total

#2
library(ggplot2)
library(hrbrthemes)
ggplot(data = fat, aes(x = spircons)) +
  geom_histogram(binwidth = 0.1, 
                 fill = "yellowgreen", 
                 color = "black") +
  geom_density(bw = 0.037, alpha = 0.5) + geom_rug() +
  theme_ipsum() +
  ggtitle("Spirits consumption distribution")

#3
library(dplyr)
fat3 <- select(fat, state, spircons, year, starts_with("mr"))
group_by(fat3, state) %>%
  summarise(mean = mean(mrall), n = n())
View(group_by(fat3, state) %>%
       summarise(mean = mean(mrall), n = n()))
# So there are 7 observations for each state
group_by(fat3, year) %>%
  summarise(mean = mean(mrall), n = n())
View(group_by(fat3, year) %>%
       summarise(mean = mean(mrall), n = n()))
# and 48 observations for each year from 1982 to 1988
# So the answers are YES and YES.

#4
fat <- mutate(fat, fatalityrate = mrall/10000)
summary(fat$fatalityrate)
sd(fat$fatalityrate)
# Hence standart deviation is approximately 5.7*10^-9

#5
ggplot(fat, aes(x=spircons, y=fatalityrate, color=state)) + 
  geom_point(size=3) + theme_ipsum() + ggtitle("Fatality rate and spirits consumption for different states") +
  labs(x = "Spirits consumption", y = "Fatality rate")

#6
cor(fat[,c("spircons", "fatalityrate", "breath")])
# We can see small (-0.06) negative correlation between spircons and fatalityrate
# However, there is negative correlation (-0.28) between presence of breath test law and fatality rate (less drunk drivers)
# And positive correlation (0.209) between breath law presence and spirit consumption

#7
library(lmtest) # import package for linear models
library(sandwich)

lmodel <- lm(fatalityrate ~ spircons + breath, data = fat)
lmodel$coefficients # if we want to see only coefficients for our model
coeftest(lmodel, vcov. = vcovHC) # heteroskedasticity-robust errors
# As we can see, the effect of spirits consumption on fatality rate is not significant (even on 0.1 SL)
# breath effect is significant and negative (presence of law decreases fatality rate, and vice versa)
# It is logical that laws affect the situation (it's America in the 80's, not Africa!)

#8
summary(lmodel, vcov. = vcovHC) # heteroskedasticity-robust errors
# R^2 is VERY small (~0.07), this is not good, they are not significant

#9
lmodel2 <- lm(fatalityrate ~ spircons + breath + year + state, data = fat) # adding state causes it to construct features using one-hot encoding
lmodel2$coefficients # if we want to see only coefficients
coeftest(lmodel2, vcov. = vcovHC) # heteroskedasticity-robust errors
# Now spirits consumption is significant and breath law presence is not significant

summary(lmodel2, vcov. = vcovHC)
# Now we get R^2 = 0.9, and p-value ~ 2*10^-16.
# All this variables in total explain our dataset well, they are jointly significant

#10
# we can compare coefficients by looking at them:
lmodel$coefficients
lmodel2$coefficients
# as we can see, effect changes direction from negative to positive
