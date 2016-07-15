# Day 5 R_bootcamp
# DonWest@UCDavis.edu

#Putting it all together
# 


pres <- readRDS("~/Downloads/pres.RDS")
head(pres)

# Download the quarterly presidential approval ratings dataset from SmartSite. Load and inspect it, making any necessary changes.

# Move years to a column of their own
pres$year = rownames(pres)

# Is it tidy? If not, tidy it.
# Tidy the data
library(tidyr)
tail(pres)
gather(pres, Quarter, Approval, Q1:Q4) %>% 
  head() #looks okay

pres1 = gather(pres, Quarter, Approval, Q1:Q4) 


# Graphically explore these questions to develop a testable hypothesis:
#     Do the presidents differ in their approval ratings?
library(dplyr)
library(ggplot2)
library(cowplot)

presAvg = pres1 %>% 
  group_by(president) %>% 
  mutate(apprAvg = mean(na.omit(Approval)))

head(presAvg)
  
ggplot(presAvg, aes(x = president, y = Approval, fill = Quarter))+
  geom_boxplot()

lm(president ~ apprAvg, na.omit(presAvg)) # why doesn't this work?? so it gave me an error message about NA's but what's actually wrong with this is the way I am trying to do the linear model - LOLZ

lm(apprAvg ~ president, na.omit(presAvg)) # works fine

# Do approval ratings vary over time?

class(presAvg$year)
presAvg$year = as.integer(presAvg$year)

na.omit(presAvg) %>% 
  ggplot(aes(x = year, y = Approval, colour = president))+
  geom_point()+
  geom_smooth(method = 'lm')


# Is there a seasonal effect of quarter on approval ratings?

na.omit(presAvg) %>% 
  ggplot(aes(x = Quarter, y = Approval, colour = president))+
  geom_point()+
  facet_wrap(~year)

# not the prettiest

na.omit(presAvg) %>% 
  ggplot(aes(x = year, y = Approval, colour = Quarter))+
  geom_violin()
#not pretty

# let's try to get the avg per quarter
pres1 = na.omit(pres1) %>% 
  group_by(Quarter) %>% 
  mutate(quartAvg = mean(Approval))


pres1 %>% 
  ggplot(aes(x = Quarter, y = Approval, fill = Quarter))+
  geom_violin()+
  geom_point( aes(x = Quarter, y = quartAvg), size = 3)+
  geom_hline(aes(yintercept = mean(quartAvg)), linetype = "dashed")+ # this works
  geom_text(x = 2.5, y = (mean(pres1$quartAvg)-2), label="Average Approval", size = 3.5)+
  #geom_text(aes(x = 1, y = mean(quarterAvg), label = 'TEXT'))+ # error here.
  ggtitle("Presidential Approval by Quarters")

# Test your hypothesis using a linear model.

# avg approval by pres
summary(lm(apprAvg ~ president, presAvg))

# approval by quarter
summary(lm(Approval ~ Quarter, presAvg)) # quarters do seem to have a rhythm

# approval by quarter interacting w pres
summary(lm(Approval ~ Quarter * president, presAvg)) # hmm

# Summarize your findings with one table and one plot.

# I got distracted trying to make a beautiful graph of pres approval by quarters, so I never got this far.

# Michael's answer:
# Download the quarterly presidential approval ratings dataset from SmartSite. Load and inspect it, making any necessary changes.
setwd('Dropbox/Teaching/RBootcamp/Day5/')
pres = readRDS('../Day4/data/pres.RDS')
# Is it tidy? If not, tidy it.
head(pres)
# Take year from rownames to a variable
pres$year = as.numeric(rownames(pres))
str(pres)
# Let's gather
library(tidyr)
pres = gather(pres, key = quarter, value = rating, -president, -year)

# Graphically explore these questions to develop a testable hypothesis:
#     Do the presidents differ in their approval ratings?
library(ggplot2)
ggplot(pres, aes(x = president, y = rating)) +
  geom_point()

ggplot(pres, aes(x = president, y = rating)) +
  geom_boxplot()

# Do approval ratings vary over time?
# This works best if year is numeric-class
ggplot(pres, aes(x = year, y = rating, 
                 color = quarter,
                 shape = president)) +
  geom_point(size = 4)

# Is there a seasonal effect of quarter on approval ratings?
ggplot(pres, aes(x = quarter, y = rating)) +
  geom_boxplot()

# Test your hypothesis using a linear model.
m = lm(rating ~ year, pres)
summary(m)
# That's a silly intercept.
# Scale the variables -> intercecpt is average of y.

# Let look at the linear model in our plot
ggplot(pres, aes(x = year, y = rating)) +
  geom_point(size = 4,
             aes(color = quarter,
                 shape = president)) +
  geom_smooth(method = 'lm', color = 'darkgray')
# Summarize your findings with one table and one plot.
library(stargazer)
stargazer(m , type = 'text', out = 'results/presTable.txt')

#save plot in r 
presPlot = ggplot(pres, aes(x = year, y = rating)) +
  geom_point(size = 4,
             aes(color = quarter,
                 shape = president)) +
  geom_smooth(method = 'lm', color = 'darkgray')

# Save plot
pdf('results/presPlot.pdf')
presPlot
dev.off() 

# can check if they're there:
list.files('results/')


# flashback to day 1 baby names

make_my_plot = function(theName) {
  babynames %>% 
} # he mentioned he didn't want to give us this code... but i dunno if he will    
# the browswer line will go in to the middle of the function and let you see if it's working:browser()

# Preview of lists:
numbers = 1:10
log10(numbers)
class(log10(numbers))
?lapply
class(lapply(numbers,log10))


# Now off to writing functions:
add2 = function(x) x + 2
# Look at it
add2
# Use it
add2(5)

combineMeans = function(x, y) {
  # x and y are numeric vectors
  # function returns mean of each
  xmean = mean(x)
  ymean = mean(y)
  c(xmean, ymean) # The last line will be returned
}

combineMeans(x = 1:5, y = c(2,4))

# so it will print the mean of x and the mean of y, which for us in above example is 3 and 3 

# Can also provide variabl-names as arguments
distributions = 
  data.frame(
    normal = rnorm(n = 10, mean = 25, sd = 3), # random normal
    uniform = runif(n = 10, min = -3, max = 3) # random uniform
  )
# made a data frame named distributions with some random numbers in it
head(distributions)

combineMeans(distributions$normal, distributions$uniform)

# gives you a numeric vector with #'s close to 25 and 0 

# Load subset of flights data (okay, we don't have the subset... but I'm going to use all flights data)
getwd()
flights = readRDS('Data_Files/flights.RDS')

str(flights)

# Michael's code: 

# Load flight data:
AAflights = readRDS('data/flights/AA.RDS')
str(AAflights)

# Model time vs. distance
m = lm(air_time ~ distance, AAflights)
summary(m)

# Let's put that in a function so can do with any dataframe
modelTimeVDist = function(flightDF) {
  m = lm(air_time ~ distance, flightDF)
  summary(m)
}

# Same as "Model time vs. distance"
modelTimeVDist(flightDF = AAflights)


# More Michael examples:
# Write a function to plot air speed vs. distance
ggplot(AAflights, aes(x = distance, y = distance / air_time)) +
  geom_point()

# Put that in a function that takes any data frame
plotSpeedVDist = function(theDataFrame) {
  ggplot(theDataFrame, aes(x = distance, y = distance / air_time)) +
    geom_point()
}

plotSpeedVDist
plotSpeedVDist(AAflights)

# Assign the plot to a variable name
AAspeedplot = plotSpeedVDist(AAflights)

# he Wants us to make a function that 'can take any housing data frame' use housingSF to try it, then look at housingNapa and see if it still works.

# Try these:

# Exercise
# Load the housingSF data from yesterday.


load('Data_Files/housingSF.RDA')
head(housingSF)
SF <- na.omit(housingSF)

# Make a plot (not a map).
ggplot(SF, aes(x = year, y = (price/(bsqft))))+
  geom_point()+
  geom_smooth(method = 'lm')# not pretty, but whatever

SF$price/SF$bsqft # just checking

range(SF$price)
range(SF$bsqft) # building sq ft
range(SF$lsqft) # lot sq ft

# how is this trend of decreased prices true?!?!?!

# Wrap the plot in a function that takes a dataframe as an argument.

# Let's say I want to see the cost per sqft over time
head(SF)
gouge = function(DF){
  ggplot(DF, aes(x = year, y = (price/bsqft)))+
    geom_point()+
    geom_smooth(method = 'lm')

}

gouge(SF)


# In your ggplot() call, change the data argument to the function's argument name.


# Assign the function to a variable name. It should appear in your environment.
# Run the function with the housingSF dataframe.
# Download the housingNapa dataframe from the SmartSite, load it, and run your function with it.
# Advanced: What else can you make flexible by including as an argument to your function?


# Michael's code:
housingSF = filter(housingSF, bsqft < 5e4)

ggplot(housingSF, aes(x = factor(br), y = bsqft))+
  geom_boxplot()

plotPricevBr = function(df) {
  ggplot(housingSF, aes(x = factor(br), y = bsqft))+
    geom_boxplot()
}

plotPricevBr(housingSF)

load('Data_Files/housingNapa.RDA')

plotPricevBr(housingNapa)


# Advanced
plotPricevBr2 = function(df, boxcolor) {
  ggplot(housingSF, aes(x = factor(br), y = bsqft))+
    geom_boxplot(colour = boxcolor)
}

plotPricevBr2(housingNapa, "firebrick")

# Can set default
plotPricevBr2 = function(df, boxcolor = "green") {
  ggplot(housingSF, aes(x = factor(br), y = bsqft))+
    geom_boxplot(colour = boxcolor)
}


plotPricevBr2(housingNapa)

## After lunch:

# lapply
x = 1:10
lapply(x, log10)
# equiv:
lapply(x, function(element_in_x) log10(element_in_x))
# Sometime useful to be able to refer to the element:
products = 
  lapply(x, function(element_in_x) 
    (element_in_x - 1) * element_in_x)
names(products) = x
products

kids = sample(c('Jimmy', 'Jessy', 'Joe'), 5, replace = TRUE)
kids
# Paste combines string with (by default) a space between
introductions = lapply(kids, function(kidsName) 
  paste('Hi I am', kidsName) 
) # then we gave it a value

# Paste0 combines string with nothing between
lapply(kids, function(kidsName) 
  paste0('Hi I am', kidsName)
)


# so that's the thing we made...
introductions

# so you can assign the 'names' of your list 'introductions' to be 'kids'

names(introductions) = kids # names is a function


introductions

# re explaining lapply

?lapply

a1= lapply(1:3, function(n) n^(2)) # so each element gets passed through the function 

# My tangent to understand the 'names' thing
names(a1) # gives you nothing, because you haven't set the names yet.
names(a1) = 1:3 # this is you setting the names of the a1 list

a1 # now it prints out the 'names' that you assigned

# equivalent to the lapply:

list(1^2, 2^2, 3^2)

distributions = 
  list(
    normal = rnorm(n = 5, mean = 25, sd = 3),
    uniform = runif(n = 5, min = -3, max = 3)
  )
distributions

lapply(distributions, mean)
# equiv:
lapply(distributions, function(oneDistribution)
  mean(oneDistribution))
# Also equiv:
lapply(distributions, function(oneDistribution) {
  mean(oneDistribution)
})


stats = lapply(distributions, function(oneDistribution) {
  mean = mean(oneDistribution)
  median = median(oneDistribution)
  stDev = sd(oneDistribution)
  c(theMean = mean, theMedian = median, theDev = stDev)
})

stats

# how does this work with data frames?

distributions

dfDist = as.data.frame(distributions) # remember, data frames are lists.

class(dfDist) 
typeof(dfDist) # a special type of data frame, it's square - all columns must be same length

lapply(dfDist, function(oneDistribution) {
  mean = mean(oneDistribution)
  median = median(oneDistribution)
  stDev = sd(oneDistribution)
  c(theMean = mean, theMedian = median, theDev = stDev)
})

# Collecting the ouput of lapply into a data frame

class(stats)
length(stats)

# suppose we want to collect those two entries and stick them in the data frame

# directly as a data frame
as.data.frame[rbind(stats$normal, stats$uniform)]
rbind(stats$normal, stats$uniform) # comes out as a matrix

?do.call

# constructs/executes a function call w/ a list of stuff to pass through...
# so in rbind, it got two arguments...

do.call(rbind,stats) # makes the same matrix, but with row names.

# a matrix is made to be used as a matrix (covariance, etc); all of the entries must be the same type ALL STRINGS or ALL ___
# data frame is really just a table with observations; each column can be its own thing: column 1 = string, column 2 = whatever

# working w lists

names(stats)

stats$normal

stats[1] # says "keep container - stay in the list" - so it says 'normal'

stats[[1]] # says "pull element out of the list and discard its container"

stats[1]$normal # okay
stats[[1]]$normal # nope

class(stats[1])
class(stats[[1]])

stats[1][1][1]

stats[[1]][[1]]

# Try these:

# Exercise
# Download and load aList.RDS.
aList <- readRDS('Data_Files/aList.RDS')
aList$names
aList$distributions
aList$ideas

#How many elements does it have? 3
length(aList)
#What are their names? names, distributions, ideas
names(aList)

#Use lapply to determine the class of each element.

lapply(aList, class)
       
      
# Extract the first element of the list, and use lapply to determine the median of each element.
aList$distributions %>% 
  lapply(., median)

# Michael's way:
first = aList[[1]]

head(first)
lapply(first, median)

# Create a new list that is a subset of aList containing only the elements that are data frames. Advanced: Do this programmatically (ie, testing whether each element is a data frame).

typeof(aList)

#newList = filter(aList, class == data.frame) # filter doesn't work on lists, and stupid aList is a list. lolz



lapply(aList, function(x) is.data.frame(x)) # this is a list, but we need a vector to do it the way I was trying..

df = aList[1:2]

# if it had been columns 1 & 3, not 1 & 2
df2 = aList[c(1,3)]

aList[unlist(lapply(aList, function(x) is.data.frame(x)))] # this makes it not a list

dfs = aList[sapply(aList, is.data.frame)]

head(dfs)

?sapply


# Use lapply to extract the first column (df[, 1]) of each data frame.

lapply(dfs, [,1]) # since square brackets are special characters, this doesn't work, but... (you could go through lots of crappy formating magic to make it understand you're using sq brackets on purpose, but it's far easier to do the next thing instead)

lapply(dfs, function(df) df[,1] ) # this works.


# Advanced: On the list of data frames, nest two lapplys to find the class of each column in both data frames.

# Michael's other examples:
distributions
# What's its class
class(distributions)
# How many elements?
length(distributions)
# Pull out the first element from distributions (a vector)
distributions[[1]]
# Pull out the first element of the first element of distributions
distributions[[1]][1]
# Pull out the fifth element of the first element of distributions
distributions[[1]][5]
# Execute a function (class) on each element in distribution
lapply(distributions, class)

# Like

class(distributions[[1]])
class(distributions[[2]])

# can, but don't have to, refer to elements by name
lapply(distributions, function(x) class(x)) 
# Single brackets pull elements out, keep in a list
# Double brackets pull ONE element out, not in a list
products[[10]]
products[10]
products[8:10]
products[[8:10]]  # fails

# No matter what the list or element is
# will always be list
class(alist[anindex]) 
# will be the class of the anindex-th element of alist
class(alist[[anindex]]) 

aList = readRDS('data/aList.RDS')
aList[[1]]
aList[1]
class(aList[[1]])
class(aList[1])
length(aList[1])
length(aList[[1]])

# Looping over data to do analyses on each
flights 
length(flights)

# function to model speed vs distance

modelTimeVDist # hit command enter and it'll print out the function, or click on it in the global environment to get a creepy window with the function

# there are two fucking data frames named flights... one is 'allFlights' and is much shorter - i renamed it 'fly'

fly <- readRDS('~/Downloads/allFlights.RDS')

length(fly)
class(fly)
names(fly)
head(fly[[1]])
# My function to model speed vs. distance
# Let's put that in a function so can do with any dataframe
modelTimeVDist = function(flightDF) {
  m = lm(air_time ~ distance, flightDF)
  summary(m)
}

lapply(fly, modelTimeVDist) # there's a lot of output

# To make sense of the output, just keep the coefs

modelTimeVDist2 = function(flightDF) {
  m = lm(air_time ~ distance, flightDF)
  m$coefficients
}
modelTimeVDist2(fly[[1]])
coefs = lapply(fly, modelTimeVDist2)

# Two ways to bind those together

do.call(rbind, coefs) # so much easier to read as columns

sapply(fly, modelTimeVDist2)

# Write a stargazer table to file for each model

dir.create('results/flightModels')
modelTimeVDist3 = function(flightDF) {
  m = lm(air_time ~ distance, flightDF)
  stargazer(m, type = 'text', 
            out = paste0('results/flightModels/test.txt'))
} 

# This function returns just the first 
modelTimeVDist3(fly[[1]]) # makes a table, saved as 'test' as defined above

head(fly[[1]]) #looks like fly[[1]] is just grabbing the first carrier 
tail(fly[[1]])


# how to out put multiple files for each individual airline

lapply(seq_along(fly), function(i) {
  m = modelTimeVDist3(fly[[i]])
  stargazer(m, type = 'text', 
            out = paste0('results/flightModels/', names(fly)[i], '.txt'))
  
})

# Try This:

# exercise
# Download and load housingByCounty.RDA.
getwd()
load('Data_Files/housingByCounty.RDA')

#What type of object is it? 
typeof(housingCounties)
#list

#How many elements does it have? 
length(housingCounties)
#9
#What are their names? 

names(housingCounties)

#What is each element?

lapply(housingCounties, class)

# Execute your plotting function for all counties in the dataset with a single, simple line of code.
head(housingCounties$`Alameda County`)

lapply(seq_along(housingCounties), function(DF)
  ggplot(housingCounties[[DF]], aes(x = year, y = (price/bsqft)))+
    geom_point()+
    ggtitle(names(housingCounties)[DF])
)


# Alter your function to write each plot to a file with the name county_name.pdf. The paste0 function will be helpful to create the file name.

lapply(seq_along(housingCounties), function(DF)
  ggplot(housingCounties[[DF]], aes(x = year, y = (price/bsqft)))+
    geom_point()+
    ggtitle(names(housingCounties)[DF])) # this works
    

lapply(seq_along(housingCounties), function(DF) 
  ggplot(housingCounties[[DF]], aes(x = year, y = (price/bsqft)))+
    geom_point()+
    ggtitle(names(housingCounties)[DF]),
  ggsave('results/names(housingCounties)[DF].pdf')) #wtf saves only Sonoma County as "names(housingCounties)[DF].pdf" >< >< 

lapply(seq_along(housingCounties), function(DF) 
  ggplot(housingCounties[[DF]], aes(x = year, y = (price/bsqft)))+
    geom_point()+
    ggtitle(names(housingCounties)[DF])
  ggsave('results/', names(housingCounties)[DF],'.pdf')) #wtf 'unexpected symbol... add comma

lapply(seq_along(housingCounties), function(DF) {
  ggplot(housingCounties[[DF]], aes(x = year, y = (price/bsqft)))+
    geom_point()+
    ggtitle(names(housingCounties)[DF])
  ggsave(paste0('results/',names(housingCounties)[DF],'.pdf'))}) #wtf 'ggplot object DF not found'--> so it turns out, if you're just running 'one line' of code (e.g. the ggplot), then you don't need the {} around your function. HOWEVER, if you are running more than one thing within your function (e.g. ggplot, then ggsave), then you MUST HAVE {} or the function breaks. /sigh
DF=1 # for trouble shooting

# Advanced: Load the ggmap package. Make a map of the housingNapa data using make_bbox() to pass a bounding box to the location argument of get_map(). Wrap the plotting call in a function that takes a housing data frame as an argument. Execute for each county. Double bonus: provide an argument for the variabale by which to color points. You'll want to use aes_string for mapping.


# Michael's solutions:
exercise
# Download and load housingByCounty.RDA. What type of object is it? How many elements does it have? 
# What are their names? What is each element?
load('data/housingByCounty.RDA')
class(housingCounties)
length(housingCounties)
names(housingCounties)
sapply(housingCounties, class)
sapply(housingCounties, colnames)
# Execute your plotting function for all counties 
# in the dataset with a single, simple line of code.
# Arrange the plots in a grid with cowplot's plot_grid
library(cowplot)
plots = lapply(housingCounties, plotPriceVBR)
sapply(plots, class)
plot_grid(plotlist = plots)
# plot_grid is a function of cowplots

# Use an lapply to write each plot to a file with
# the name county_name.pdf. The paste0 function will be 
# helpful to create the file name.


lapply(seq_along(housingCounties), function(i) {
  theplot = plotPricevBr2(housingCounties[[i]])
  ggsave(paste0('results/', names(housingCounties)[i], '.pdf'))
})

# other tips: list files --> how to stick a ton of csv files together into a single list

zipFiles = list.files('data/zips',
                      full.names = TRUE,
                      pattern = 'csv')
zipFiles

d = lapply(zipFiles, read.csv)
class(d)
length(d)
