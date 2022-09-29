# If your R uses not English language by default:
Sys.setenv(LANG = "en") # Windows
system("defaults write org.R-project.R force.LANG en_US.UTF-8") # Mac

# Question about еру dplyr package
install.packages("dplyr")
library("dplyr")

# download data
install.packages("hflights")
library(hflights)

flights <- hflights
# For example, we can select all flights on January 1st with:
filter(flights, Month == 1 & DayofMonth == 1)

############
# QUESTION 1
# Select all flights that occurred on January, 2nd and Febrary, 3rd from the `flights` data set
filter(flights, (Month == 1 & DayofMonth == 2) | (Month == 2 & DayofMonth == 3))
############

############
# QUESTION 2
# Select all fligths that occured on the 1st day of each of the first six months
View(filter(flights, (Month == 1:6 & DayofMonth == 1)))
############


# Use desc() to order a column in descending order
arrange(flights, desc(ArrDelay))


############
# QUESTION 3
# Order the data in descending order: first, according to arrival time, then by arrival delay
View(arrange(flights, desc(ArrTime, ArrDelay)))
############

# For example, select all variables which names begins with "arr".
select(flights, starts_with("Arr"))

############
# QUESTION 4
# Select all columns that end with "time".
View(select(flights, ends_with("time")))
############

# New variables creating
mutate(flights, Gain = ArrDelay - DepDelay, Speed = Distance / AirTime * 60)

############
# QUESTION 5
# Create a new variable---average flight speed
View(mutate(flights, Av_Speed = Distance / AirTime))
############


# Grouping by
# In the following example, we split the complete dataset into individual planes
# and then summarise each plane by counting the number of flights (count = n())
# and computing the average distance (dist = mean(distance, na.rm = TRUE))
# and arrival delay (delay = mean(arr_delay, na.rm = TRUE)).

by_tailnum <- group_by(flights, TailNum)
delay <- summarise(by_tailnum,
                   Count = n(),
                   Dist = mean(Distance, na.rm = TRUE),
                   Delay = mean(ArrDelay, na.rm = TRUE)
)

############
# QUESTION 6
# Calculate the average distance for each origin.
by_origin <- group_by(flights, Origin)
origin <- summarise(by_origin,
                  Dist = mean(Distance, na.rm = TRUE))
View(origin)
############









# Merging of datasets

authors <- data.frame(
  ## I(*) : use character columns of names to get sensible sort order
  surname = I(c("Tukey", "Venables", "Tierney", "Ripley", "McNeil")),
  nationality = c("US", "Australia", "US", "UK", "Australia"),
  deceased = c("yes", rep("no", 4))
)
authorN <- within(authors, {
  name <- surname
  rm(surname)
})
books <- data.frame(
  name = I(c(
    "Tukey", "Venables", "Tierney",
    "Ripley", "Ripley", "McNeil", "R Core"
  )),
  title = c(
    "Exploratory Data Analysis",
    "Modern Applied Statistics ...",
    "LISP-STAT",
    "Spatial Statistics", "Stochastic Simulation",
    "Interactive Data Analysis",
    "An Introduction to R"
  ),
  other.author = c(
    NA, "Ripley", NA, NA, NA, NA,
    "Venables & Smith"
  )
)


m0 <- merge(authorN, books)
m1 <- merge(authors, books, by.x = "surname", by.y = "name")

# Merging with NA
x <- data.frame(k1 = c(NA, NA, 3, 4, 5), k2 = c(1, NA, NA, 4, 5), data = 1:5)
y <- data.frame(k1 = c(NA, 2, NA, 4, 5), k2 = c(NA, NA, 3, 4, 5), data = 1:5)
merge(x, y, by = c("k1", "k2")) # NA's match
merge(x, y, by = "k2", incomparables = NA) # 2 rows








# Beautiful plots in R! Ggplot2
install.packages("ggplot2")
library(ggplot2)

# http://r-statistics.co/Complete-Ggplot2-Tutorial-Part1-With-R-Code.html
# https://rpubs.com/AllaT/rprog-ggplot2
# https://www.bioinformatics.babraham.ac.uk/training/ggplot_course/Introduction%20to%20ggplot.pdf
# https://ggplot2-book.org/preface-to-the-third-edition.html
# https://github.com/rstudio/cheatsheets/blob/master/data-visualization-2.1.pdf

# Let's analyze population dataset (http://r-statistics.co/Complete-Ggplot2-Tutorial-Part1-With-R-Code.html)
help(midwest)
str(midwest)
colnames(midwest)
View(midwest)

# Basic scatterplot
ggplot(midwest, aes(x=area, y=poptotal)) + geom_point()


help(ggplot)
help(aes)
help(geom_point)

# ggplot - basic graph
# aes - mapping of data + some "beaty" properties.
# geom_points is an example of layer


# Delete the points outside the limits
g <- ggplot(midwest, aes(x=area, y=poptotal)) + geom_point()
g + xlim(c(0, 0.1)) + ylim(c(0, 1000000))

# Zoom in without deleting the points outside the limits. Deleting/zooming have important differences 
# when you calculate
g1 <- g + coord_cartesian(xlim=c(0,0.1), ylim=c(0, 1000000))  # zooms in
plot(g1)

# Add Title and Labels, and subtitles
g2 <- g1 + labs(title="Population by area", subtitle="from the 'midwest' dataset", y="Population", x="Area",
          caption="Midwest Demographics")
plot(g2)

# Define colours apriori
g3 <- g2 + geom_point(col="steelblue", size=1.5)
plot(g3)

# Define colours by state
g4 <- g2 + geom_point(aes(col=state), size=2)
plot(g4)

# Change the color palette
g5 <- g4 + scale_colour_brewer(palette = "Set1") 
plot(g5)

# Change background
g5 + theme_bw() + labs(subtitle="BW Theme")
g5 + theme_classic() + labs(subtitle="Classic Theme")


# We can add scatter ellipse !! pretty easy
g5 + stat_ellipse()

# Beaver time!!! (source: https://rpubs.com/AllaT/rprog-ggplot2)
library(dplyr)
beav <- beaver1
beav$id <- 1:nrow(beaver1)

# Time-series graph 
ggplot(data = beav, aes(x = id, y = temp)) + geom_line()

# Add points to the graph 
ggplot(data = beav, aes(x = id, y = temp)) + geom_line() + geom_point()

# We can control sizes and colours of dots and lines
ggplot(data = beav, aes(x = id, y = temp)) + 
  geom_line(color = "blue") +
  geom_point(size = 0.75)

#  Grouping of beavers into active and and non-active !! use group in aes
ggplot(data = beav, aes(x = id, y = temp, group = activ, color = activ)) +
geom_line() + geom_point()

# Hmm, strange legend. `active` is a binary variable... But R does not know it!

# Convert active from numeric to factor
beav <-  mutate(beav, activ = factor(activ))

# The correct legend 
ggplot(data = beav, 
       aes(x = id, y = temp, 
           group = activ, color = activ)) +
  geom_line() + 
  geom_point()

# Let's change colors manually!!! perfect!
ggplot(data = beav, 
       aes(x = id, y = temp, 
           group = activ, color = activ)) +
  geom_line() + 
  geom_point() +
  scale_color_manual(values = c("red", "blue"))

# But scale_color_manual is also useful for legend changing 
ggplot(data = beav, 
       aes(x = id, y = temp, 
           group = activ, color = activ)) +
  geom_line() + 
  geom_point() +
  scale_color_manual(values = c("red", "blue"),                    
                     labels = c("Not active", "Active"))

# And add legend name scale_color_manual can everything!
ggplot(data = beav, 
       aes(x = id, y = temp, 
           group = activ, color = activ)) +
  geom_line() + 
  geom_point() +
  scale_color_manual(values = c("red", "blue"),                    
                     labels = c("Not active", "Active"),
                     name = "Activity")

# Add labels to axes and overall graph
ggplot(data = beav, aes(x = id, y = temp, group = activ, color = activ)) +
  geom_line() + geom_point() +
  scale_color_manual(values = c("red", "blue"),                    
                     labels = c("Not active", "Active")) + 
  labs(title = "Beavers: body temperature", 
       x = "Observations", 
       y = "Temperature, C")

# Change theme to black-white AND we can google another themes
ggplot(data = beav, aes(x = id, y = temp, group = activ, color = activ)) +
  geom_line() + geom_point() +
  scale_color_manual(values = c("red", "blue"),                    
                     labels = c("Not active", "Active")) + 
  labs(title = "Beavers: body temperature", 
       x = "Observations", 
       y = "Temperature, C") +
  theme_bw() 



# Histograms
ggplot(data = beav, aes(x = temp)) +
  geom_histogram()

# Change bar width
ggplot(data = beav, aes(x = temp)) +
  geom_histogram(binwidth = 0.1)

help(geom_histogram)

# We can change color of bars and their boundaries
ggplot(data = beav, aes(x = temp)) +
  geom_histogram(binwidth = 0.1, 
                 fill = "yellowgreen", 
                 color = "black")

# We can add lines to graphs (not only histogram)
ggplot(data = beav, aes(x = temp)) +
  geom_histogram(binwidth = 0.1,
                 fill = "yellowgreen", 
                 color = "black") + 
  geom_hline(yintercept = 15, color = "red")

ggplot(data = beav, aes(x = temp)) +
  geom_histogram(binwidth = 0.1,
                 fill = "yellowgreen", 
                 color = "black") + 
  geom_vline(xintercept = median(beav$temp), 
             color = "red",
             lty = 2) # lty defines type

# Histograms for groups
ggplot(data = beav, aes(x = temp, group = activ, fill = activ)) +
  geom_histogram()

# Continuous versions of histograms
ggplot(data = beav, aes(x = temp, group = activ, fill = activ)) +
  geom_density(alpha = 0.5) # beavers are smashed now

# Add rugs for clarity
ggplot(data = beav, aes(x = temp, group = activ, fill = activ)) +
  geom_density(alpha = 0.5) + geom_rug()

# Combine continuous densities and histograms (..density.. - function used for density estimation)
ggplot(data = beav, aes(x = temp)) +
  geom_histogram(aes(y = ..density..), 
                 fill = "violetred", color = "black") +
  geom_density(col = "darkblue")



# Some examples from https://www.r-graph-gallery.com/

# Additional themes and theme components for 'ggplot2'
install.packages("hrbrthemes")
library(hrbrthemes)
# Histogram

# Load dataset from github
data <- read.table("https://raw.githubusercontent.com/holtzy/data_to_viz/master/Example_dataset/1_OneNum.csv", 
                   header=TRUE)

# Make the histogram alpha for transparency
data %>%
  filter( price<300 ) %>%
  ggplot( aes(x=price)) +
  geom_density(fill="#69b3a2", color="#e9ecef", alpha=0.8) +
  ggtitle("Night price distribution of Airbnb appartements") +
  theme_ipsum()


# Scatterplots
# Transparency
ggplot(iris, aes(x=Sepal.Length, y=Sepal.Width, alpha=Species)) + 
  geom_point(size=4, color="#69b3a2") +
  theme_ipsum()

# Shape
ggplot(iris, aes(x=Sepal.Length, y=Sepal.Width, shape=Species, color=Species)) + 
  geom_point(size=5) +
  theme_ipsum()

# Size
ggplot(iris, aes(x=Sepal.Length, y=Sepal.Width, size=Species)) + 
  geom_point(color="#69b3a2") +
  theme_ipsum()

# Labeling data points 
# Keep 30 first rows in the mtcars natively available dataset
data=head(mtcars, 30)

# add text with geom_text, use nudge to nudge the text
ggplot(data, aes(x=wt, y=mpg)) +
  geom_point() + # Show dots
  geom_text(
    label=rownames(data), 
    nudge_x = 0.25, nudge_y = 0.25, 
    check_overlap = T
  )

# Beautiful time-series graph

#Bitcoin price
data <- read.table("https://raw.githubusercontent.com/holtzy/data_to_viz/master/Example_dataset/3_TwoNumOrdered.csv", header=T)
data$date <- as.Date(data$date)

# plot
data %>% 
  ggplot( aes(x=date, y=value)) +
  geom_line(color="#69b3a2") +
  ylim(0,22000) +
  annotate(geom="text", x=as.Date("2017-01-01"), y=20089, 
           label="Bitcoin price reached $20k\nat the end of 2017") +
  annotate(geom="point", x=as.Date("2017-12-17"), y=20089, size=10, shape=21, fill="transparent") +
  geom_hline(yintercept=5000, color="orange", size=.5) +
  theme_ipsum()

