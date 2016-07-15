# Day 4 R_bootcamp
# DonWest@UCDavis.edu

# more file / directory stuff

# expects data, key, value, ...

wide_eg = gather(wide_eg, key = 'treatment', value = 'measurement', -subject, - sex)
head(wide_eg)

# Plot the effect of the 3 treatments

ggplot(wide_eg, aes(x = treatment, y = measurement))+
  geom_boxplot()

# Create an Rbootcamp/results folder. Save this plot as a pdf file there.

ggsave('results/treatmentEffect.pdf')

# Optional: Run a linear regression of the measurement on the treatments. Examine the results via summary(theModel). Write a pretty summary table to a .txt file in your Rbootcamp/results folder using the stargazer function in the stargazer package.

# Always takes the first thing, and they're organized by default in alphabetical 
m = lm(measurement ~ treatment, wide_eg)
summary(m)

# Change the excluded category
# check the organization to begin with:
levels(wide_eg$treatment)

#change order in the data frame
d1 = relevel(wide_eg$treatment, 'cond2')
 
m2 = lm(measurement ~ treatment, wide_eg)
summary(m2)

# file is crap; trying to fix it
d10 = read.table("~/Desktop/R_bootcamp/weatherData")
d10$`.` = rownames(d10)
rownames(d10) = d10$`.`
library(dplyr)
d10 = select(d10, -`.`)
d10

d10 = as.data.frame(t(d10))

# other ways to fix it
d2 = read.delim("~/Desktop/R_bootcamp/weatherData",
                sep = '\t',
                row.names = 1)
d2 = as.data.frame(t(d2))
d2

# move rownames to a variable
d2$month = rownames(d2)
d2 # now it finally looks okay

select(d2, -AvgPrecip) %>%
  gather(key = hivslow, value = temp, -month) %>%
  ggplot(aes(x = month, y = temp, color = hivslow)) +
  geom_point(size = 5)

# Loading baseball data
bb = read.csv('baseballStats.csv', skip = 6)
head(bb)

# Making a well-formatted plot

ggplot(bb, aes(x = teamID, y = HR)) + 
  geom_boxplot() #ugly



bb[bb$HR > 0 & ! is.na(bb$HR), ] %>%  head #filtering out the no home runs and the na home runs

# so then michael tried a lot of stuff that didn't work at all and everything went from base r to ggplot to dplyr and back again, and it was a confusing, weird time. AND MY R FROZE. so... yeah.

# Making a well-formatted plot
bb[bb$HR > 0 & !is.na(bb$HR), ] %>%  # Filter no HR player-years
  # bb[bb$lgID == "NL" | bb$lgID == "AL", ] %>% # or, equiv
  filter(lgID %in% c("NL", "AL")) %>%
  ggplot(aes(x = teamID, y = HR)) + 
  geom_boxplot()+
  theme(axis.text.x=element_text(angle=-90,hjust=0)) #less helpful than I'd hoped

# Michael's version
bb[bb$HR > 0 & !is.na(bb$HR), ] %>%  # Filter no HR player-years
  # bb[bb$lgID == "NL" | bb$lgID == "AL", ] %>% # or, equiv
  filter(lgID %in% c("NL", "AL")) %>%
  ggplot(aes(x = reorder(teamID,
                         HR,
                         median),
             y = HR)) + 
  geom_boxplot()+
  scale_y_log10()+ # scale looks at the thing you sourced y from
  coord_flip()+ # order doesn't matter, apparently
  theme(axis.text.y = element_text(size = 6)) # theme looks at the actual axis that is 'y' on the graph you made
  
  
# Michael just keeps adding to his plot, but I think it'd be useful to have the iterations:

bb2 = bb[bb$HR > 0 & !is.na(bb$HR), ] %>%  
  filter(lgID %in% c("NL", "AL"))
  ggplot(bb2, aes(x = reorder(teamID,
                         HR,
                         median),
             y = HR)) + 
  geom_boxplot()+
  scale_y_log10()+ 
  coord_flip()+ 
  theme(axis.text.y = element_text(size = 6))+
  xlab("Team")+
  facet_wrap(~lgID) # weird empty spaces are because of NA values

head(bb2)

# log ticks ???
ggplot(bb2, aes(x = reorder(teamID, HR, median), y = HR, fill = lgID)) + 
  geom_boxplot()+
  scale_y_log10(name = "Home Runs per Player/Year", 
                breaks = c(1, 2, 5, 10, 20, 50))+ #chosing 1, 2, 5, 10, 20, 50 b/c they're spaced pretty evenly on the logscale.
  coord_flip()+ 
  theme(axis.text.y = element_text(size = 6))+
  xlab("Team")+
  annotation_logticks(sides = '1') #so we want them on HR axis, but they're showing up on teams axis. seems like a bug, but /shrug


# Try these:
# Using Finder or Windows Explorer (adv: using R), create a RBootcamp/day4 folder and a data folder within it.
# Download the IMDB_data.csv file from the SmartSite resources/day4 folder. Save it to your day4/data folder.
# Note the file type and use the appropriate function to read it into R.
# Inspect the file via head or str. Did the import work? In addition to the file, you will need to specify at least one argument to the read.x function.
# Are the data tidy?
# Is there missingness in the data? yes. NA or <NA>
#In which variables? 

# Michael's code:
summary(moviesData) # contains NA info
sapply(moviesData, function(column) sum(is.na(column))) # will give you a total of NA's per column

# Find the blanks:
head(moviesData$mpaa == "")

moviesData$mpaa[moviesData$mpaa == ''] = NA
sum(is.na(moviesData)) #they're baaaack! 

# You can also use the read.csv to classify na stuff

movies2 <- read.csv('moviesData.csv', skip = 4, na.strings = c("", "NA"))
head(movies2)


# My code (chronologically wrong because I tried it before Michael gave us the answers): 

# Advanced Are you sure you found all the missing data? There is a form other than NA - find it and replace with NA.

moviesData <- read.csv("~/Downloads/moviesData.csv", skip = 4)

str(moviesData)
head(moviesData)
head(moviesData$title) # some titles have $ in them.. instead of s's??

sum(is.na(moviesData)) # are there NA's? yes

moviesData = na.omit(moviesData) # KILL THE NA's!!!

sum(is.na(moviesData)) # are there NA's? no; 0

tail(moviesData) 

count(moviesData, '') # looks like there are blank spaces

moviesData %>% 
  select('' = NA) #doesn't work
?select

?na.strings # no documentation

moviesData %>% 
  na.strings = c("", " ") #seems to hate dplyr

# Stats stuff in R

#formulae (super short hand for looking at y by effects of x, or multiple x's)
y ~ x 
class(y ~ x)
y ~ x1 + x2
y ~ x1 + x2 + x3

#lm() # linear models
# glm() generalized linear models

?lm()

names(movies)

# do more expensive movies get better ratings?
lm(rating ~budget, movies) #yup
# or
model = lm(movies$rating ~ movies$budget)
class(model) # is a linear model
typeof(model) # it's a list (how R sees it) - like vectors BUT more flexible

names(model) # a data frame is a list, so we can manipulate it just like our DF's

model$coefficients

model$call # tells us how we made this model SUPER COOL!!

# can access elements with []

model[1]

# why doesn't this work?
lm(rating ~ budget + votes, movies)

mymodels = list() #creating an empty list

# putting stuff into the list:
mymodels$simple = lm(rating ~ budget, moviesData)

mymodels$mult = lm(rating ~ budget + votes, moviesData)

names(mymodels) # checking in

mymodels$interact = lm(rating ~ budget * votes, moviesData)

length(mymodels)
summary(mymodels$mult)

# try These

# are animated movies longer than regular movies? use a graph and a stats model
head(movies)

ani = movies %>% 
  group_by(Animation) %>% # Animated or not
  select()

range(movies$length)
range(ani$length) #5220 mins is unreasonable
ani = movies %>% 
  group_by(Animation) %>% # Animated or not
  filter(length < 300) #there's gotta be a way to select movies with a reasonable length run time


head(ani) # looks okay.

as.numeric(TRUE) # double checking; 1 = True

summary (lm(Animation ~ length, ani)) # is it significantly related? yes; animated movies are shorter! 

ggplot(ani, aes(x = as.factor(Animation), y = length))+
  geom_boxplot()+
  geom_point(aes(x = as.factor(Animation), y = mean(length)), fill = "pink", size = 10)+
  ylab("Duration (mins)")+
  xlab("Genre by Animation or Not")

#so you make a graph... but it's not pretty

ggplot(ani, aes(x = as.factor(Animation), y = length))+
  geom_point()+
  ylab("Duration (mins)")+
  xlab("Genre by Animation or Not")

# This one is much better 
ggplot(ani, aes(x = as.factor(Animation), y = length))+
  geom_boxplot()+
  geom_point(aes(x = as.factor(Animation), y = mean(length)), colour = "pink", size =4)+
  ylab("Duration (mins)")+
  xlab("Genre by Animation or Not")

# Michael's code:

ggplot(movies, aes(x = as.factor(Animation), y = length))+
  geom_boxplot()

# or you can get it to say 'false & true'

ggplot(movies, aes(x = as.logical(Animation), y = length))+
  geom_boxplot()

# Remove too-long movies
filter(movies, length < 300) %>% 
  ggplot(aes(x = as.logical(Animation), y = length))+
  geom_boxplot()

# Density plot more useful

filter(movies, length < 300) %>% 
  ggplot(aes(colour = as.logical(Animation), x = length))+
  geom_density()


filter(movies, length < 300) %>% 
  ggplot(aes(fill = as.logical(Animation), x = length))+
  geom_density(alpha = 0.5)


filter(movies, length < 300) %>% 
  lm(length ~ Animation, .) %>% 
  summary()
# animated movies are not longer; they're 66 mins shorter on average!

# Advanced: over time, animated movies have gotten faster or have they?

filter(movies, length < 300) %>% 
  ggplot(aes(colour = as.logical(Animation), x = year, y = length))+
  #geom_point(alpha = 0.3)+
  geom_smooth(method = 'lm')

# so if you filtered the data set to remove NAs (michael's data set), then it looks like animated movies have gotten longer more slowly THAN non-animated

filter(movies, length < 300) %>%
lm(length ~ year * Animation, .) %>% 

    

#output is:

# Coefficients:
#   (Intercept)            year       Animation  year:Animation  
# -252.5126          0.1713       -734.7554          0.3416

# year:Animation = interaction effect ==  the change in the slope between the animated movies and not-animated movies

# year = only year effect on length

# animation = only animation effect on length

# I was just thinking... did mike rename the intrinsic movies data set?
filter(moviesData, length < 300) %>% 
  ggplot(aes(colour = as.logical(Animation), x = year, y = length))+
  #geom_point(alpha = 0.3)+
  geom_smooth(method = 'lm')

summary(is.na(moviesData)) # still has na values
na.omit(moviesData) # now they're gone

# After Lunch:


# Standardizing variables

# what did we put in there again?
mymodels$mult$call

# Get summary
summary(mymodels$mult)

# sometimes it's good to standardize, sometimes not, but you should know how

?scale

# so you can scale some columns, and not others, if you give it the indicies of those columns

names(moviesData) %in% c('votes', 'budget') # so you can see which columns you want

summary(moviesData$budget)
summary(scale(moviesData$budget))

moviesData$stdBudg = scale(moviesData$budget)
moviesData$stdVote = scale(moviesData$votes)

stdModel = lm(rating ~ stdBudg + stdVote, moviesData)
summary(stdModel)

# Stargazer

stargazer(stdModel, type = 'text') #can use HTML, plain text = text, or something else 
?"stargazer"
# lots of customization.


stargazer(stdModel, type = 'text', title = 'this is my model table.', digits = 2) # digits limits places after decimal point
stargazer(stdModel, type = 'text', title = 'this is my model table.', digits = 2, omit.stat = 'f') # omit the summary statistics 

stargazer(stdModel, type = 'text', title = 'this is my model table.', digits = 2, omit.stat = 'f', out = 'myTable.txt') # out put to a file

stargazer(mymodels$simple, mymodels$mult, mymodels$interact, 'text') # it doesn't understand what type you want; must specify type

stargazer(mymodels$simple, mymodels$mult, mymodels$interact, type = 'text') 

# or, better way
stargazer(mymodels, type = 'text') 

# also for data.frame
stargazer(head(moviesData), summary = FALSE, type = 'text') 
stargazer(head(moviesData), summary = TRUE, type = 'text') 

?predict

# For many functions (e.g. summary), it spits out a different thing depending on what TYPE of data you feed in (e.g. data.frame vs string)

# "generic function" means we want to pick the 'kind of object' we're going to use. click on predict.lm

temp = predict(mymodels$simple)
head(temp)
length(temp) # 5215 --> it gives you predicted values for every x variable (budget), it spits out a predicted rating
length(mymodels$simple)

moviesData$predictRate = predict(mymodels$simple)
# could be an error b/c NA's are there if the legnths are different. just create a new data.frame and run na.omit

str(moviesData)

ggplot(moviesData, aes(x = rating, y = predictRate))+
  geom_point()
# why are the values all above 6? because the budget is always positive, so the intercept moves. this is why you might want to standardize your predictors

range(moviesData$rating)
range(moviesData$predictRate) # hilariously different ranges

# Predict on new values

budgGrid = seq(0,1e9, 1e3) # from $0 to $ 1 bil by $1000 intervals 
head(budgGrid)


preds = 
  data.frame(budget = budgGrid) # data frame with one column
preds$predRating = 
  predict(mymodels$simple, preds)

ggplot(preds, aes(x = budget, y = predRating))+
  geom_line()
# ok, maybe too many intervals... let's try by 1x10^5
budgGrid = seq(0,1e9, 1e5)

preds = 
  data.frame(budget = budgGrid) # data frame with one column
preds$predRating = 
  predict(mymodels$simple, preds)


ggplot(preds, aes(x = budget, y = predRating))+
  geom_line()
# it's a straight line b/c it's a linear model. 

# can use with other models... 
# in your new data frame, just make sure you have a column for each of your predictors

# Predicting means vs predictions == saved for stats classes. can generate confidence intervals around predictions around the value of x or mean predictions. does this via the argument 'interval' 

# ggplot does this by default (all of this work)

ggplot(moviesData, aes(x = budget, y = rating))+
  geom_point()+
  geom_smooth(method = 'lm') # we think this is based off of the mean

#Try These:

Exercise
# Does the length of a movie affect its rating? Plot and model.
All<-lm(length ~ rating, moviesData)

ggplot(moviesData,
       aes(x = rating, y = length))+
  geom_point()+
  geom_smooth(method = 'lm')+
  ggtitle("All Movies")
  
# Pick one genre and evaluate whether the above relationship is different for movies of that genre; that is, is there an interactive effect of length x genre on rating?

Com<-lm(rating ~ length * Comedy, moviesData) # not really interacting

moviesData %>% 
  select(-stdVote, -stdBudg) %>%  #these created some sort of matrices within the data frame that messed everything up later
  filter(Comedy == 1) %>% 
  ggplot(aes(x = rating, y = length))+
  geom_point()+
  geom_smooth(method = 'lm')+
  ggtitle("Comedies Only")




# Use stargazer to write a text-based table comparing the results of the above two models to a .txt file.

stargazer(Com, All, type = "text", out = 'Movie_length_table.txt')

# Save a plot illustrating your model's findings to a .pdf.

moviesData %>% 
  select(-stdVote, -stdBudg) %>%  #these created some sort of matrices within the data frame that messed everything up later
  filter(Comedy == 1) %>% 
  ggplot(aes(x = rating, y = length))+
  geom_point()+
  geom_smooth(method = 'lm')+
  ggtitle("Comedies Only")
ggsave('results/Movie_Comedy.pdf')

# Advanced: Create an html version of the stargazer table. Create and compile an R Markdown document that includes the table and the plot.


# Advanced: Append your movies data.frame with predictions from your model and 95% confidence intervals on predictions. Add the predictions with CIs to the plot of the emprical data. How did your model do?



# Michael's solutions:
select(moviesData,-stdVote, -stdBudg) %>% 
  filter(length <=240 & length >= 60) %>% 
  ggplot(aes(x = length, y = rating))+
  geom_point(alpha = 0.1, position = 'jitter')+
  scale_x_log10()+
  annotation_logticks(sides = 'b')+
  geom_smooth(method = 'lm')

# w/o interaction
moviesData %>% 
  select(-stdVote, -stdBudg) %>% 
  filter(length <=240 & length >= 60) %>% 
  lm(rating ~ length + Action, data = .) %>% 
  summary()
  
# w interaction
moviesData %>% 
  select(-stdVote, -stdBudg) %>% 
  filter(length <=240 & length >= 60) %>% 
  lm(rating ~ length * Action, data = .) %>% 
  summary()

# Actually copied / pasted Michael's
#model
filter(movies, length <= 240 & length >= 60) %>%
  lm(rating ~ length, .) %>%
  summary

# Pick one genre and evaluate whether the above relationship
# is different for movies of that genre; 
# that is, is there an interactive effect of 
# length x genre on rating?
filter(movies, length <= 240 & length >= 60) %>%
  ggplot(aes(x = length, 
             y = rating, 
             color = as.logical(Action))) +
  geom_point(alpha = .1, position = 'jitter') +
  scale_x_log10() +
  annotation_logticks(sides = 'b') + 
  geom_smooth(method = 'lm')

# w/o interaction
filter(movies, length <= 240 & length >= 60) %>%
  lm(rating ~ length + Action, .)   %>%
  summary()

#w/ interaction
yesInt =
  filter(movies, length <= 240 & length >= 60) %>%
  lm(rating ~ length * Action, .) 

# Use stargazer to write a text-based table comparing the results of the above two models to a .txt file.
stargazer(noInt, yesInt, type = 'text', out = 'results/ratingVlengthByActionModels.txt')

# Save a plot illustrating your model's findings to a .pdf.
ggsave('results/ratingVlengthByActionPlots.pdf')

# GG MAP TIME!! ggmap
?ggmap
?get_map

sfMap = get_map("San Francisco") # query the google map server in r, and stole their stuff

ggmap(sfMap) # look at dat map what what

# Add some data to the map:
load('housingSF.RDA')
str(housing)

ggmap(sfMap)+
  geom_point(aes(x = long, y = lat, colour = year), housingSF)
# removes rows with missing data, but no big deal

# Zoom in on SF

sfZoom = get_map('san francisco', zoom = 12, source = 'osm')
ggmap(sfZoom) + 
  geom_point(aes(x = long, y = lat, colour = year, size = br), housingSF)

sfToner = get_map('san francisco', zoom = 12, maptype = 'toner')

ggmap(sfToner) + 
  geom_point(aes(x = long, y = lat, colour = price, size = br), housingSF)
# not a pretty map

#makes the map black and white and grey 

ggmap(sfToner) + 
  geom_point(aes(x = long, y = lat, colour = log10(price), size = br), housingSF)
# a bit easier to see there are houses in 'many' price ranges


