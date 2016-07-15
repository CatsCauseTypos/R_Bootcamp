# R-bootcamp Day 3 9/16/2015
# DonWest@UCDavis.edu
getwd()
grass<-readRDS("grass_expt.RDS")
 # so i can steal michael's code
d <- grass
summary(grass)
# Load dplyr etc:
library(dplyr)
library(cowplot)
library(ggplot2)

# Filter rows
filter(grass, Plant == "Mc3")
grass %>% filter(Plant == "Mc3")
# Strings need quotes. Numbers don't
filter(grass, conc == 95)
# What kind of variable is Plant?
class(grass$Plant)

# select columns

d1 = select(grass,Plant)
d2 = grass$Plant
# why would you use d1 (data frame) vs d2 (just the vector)?
class(d1)
class(d2)

is(d1)
is(d2)
#if you want to know how many things there are, the vector is useful
unique(d2)
length(unique(d2))

#difference btwn dataframes and vectors w sum
sum(grass$uptake)
sum(grass)
 
#tangental vector
aVector = c(1,2,3)
aVector
aDataFrame = data.frame(x=c(1,4,7),y = c('a','b', 'c'))
aDataFrame
aDataFrame$x
sd(aDataFrame$x)
sd(aDataFrame) #not allowed

select(grass, -Plant)

#arrange rows of a data.frame

arrange(grass, conc) %>% 
  head()
#equivalent to 
head(arrange(grass, conc))

# if we want to save our rearrangement
newDF = arrange(grass, conc) 

# arrange by multiple columns
arrange(grass, conc, -uptake) %>% 
  head()
# or
arrange(grass, conc, desc(uptake)) %>% 
  head()

# Mutate: make new columns

# calc fraction of conc that is uptaken
mutate(grass, fracUptake = uptake / conc ) %>% 
  head()
# New column that doubles conc for quebec plants
mutate(grass, newConc = ifelse(Type =="Quebec", 2 * conc, conc)) %>% 
  head()
# checking function:
mutate(grass, newConc = ifelse(Type =="Quebec", 2 * conc, conc)) %>% 
  arrange(uptake) %>% 
  head()
# Grouping and Summarising
grass %>% 
  group_by(Type) %>% 
  summarise(avgUptake = mean(uptake)) #like mutate, summarise makes new columns; summarise aggregates the data

# pro tip: sometimes, if you have plyr running with dplyr, you have to quit r and start again because they interfere with each other

# Can make mult new columns
grass %>% 
  group_by(Type) %>% 
  summarise(avgUptake = mean(uptake),
            variance = var(uptake)
  ) 

# most functions in R only apply to vectors.


# is this experiment balanced?
grass %>% 
  count(Type)
# woo balance
grass %>% 
  group_by(Type) %>% 
  summarise(numPlants = n()) # n() is a function that counts the number of observations; count uses a grouping variable inside itself

# count wants a thing to group and then count
# n() wants an already-grouped-thing to count

# Multiple groupings - is this experiment balanced by treatment AND type?
group_by(grass, Type, Treatment) %>% 
  summarise(numPlants = n())

# or

count(grass, Type, Treatment)

# now on our own

# 1. How many plants uptake < 15
grass %>% 
  filter(uptake < 15) %>% 
  count()
  
# 2. arrange by conc from high to low and low to high
# low
grass %>% 
  arrange(conc) %>% 
  head()
# high
grass %>% 
  arrange(desc(conc)) %>% 
  head()

# 3. column = uptakeGroup that is 'high' if uptake > 35, 'low' if uptake <20 and 'mid' if between
g1 = grass %>% 
  mutate(uptakeGroup = ifelse(uptake > 35, 'high', 'mid')) %>% 
  mutate(uptakeGroup = ifelse(uptake < 20, 'low', uptakeGroup)) 
head(g1) #worked

# Michael
g2 = grass %>% 
  mutate(uptakeGroup = ifelse(uptake > 35,'high',
                              ifelse(uptake < 20,'low','mid'))
         )

head(g2) #worked

# 4. avg uptake per group
g1 %>% 
  group_by(uptakeGroup) %>% 
  summarise(avgUptake = mean(uptake)) %>% 
  arrange(avgUptake)

# Advanced: umm.. i think he wants us to count the groups...
?count # sooo not helpful
count(g1, desc(uptakeGroup)) #that is not a thing...
count(g1, uptakeGroup, sort=T) #Corwin's working version
desc(count(g1, uptakeGroup)) #dirty lies
# michael said you can't actually do the thing i was trying - ascending isn't an option. but you can add another line of code & use 'arrange'

# Any time you have a value of letters, it needs to be wrapped in quotes; beyond that, it's pretty fucking variable. If it doesn't work one way, try it the other way

# single quotes and double quotes are interchangeable EXCEPT you have to close one with the same " ' won't work. " " and '' will. you can also do "Thingy 'like' This" and it'll understand that there's 2 things in there.

# dplyr to ggplot

class(grass) #that first class can distinguish "printing ALL OF THE THINGS"
grass = tbl_df(grass) 
grass # now you get '...' after 10 rows.

# undoing it
as.data.frame(grass)

# what if we made important changes to our data set? can save it as a new file

?saveRDS()

saveRDS(grass, 'grassExpAfterR.RDS')

# or can save it somewhere else..

saveRDS('../R club/data sets/', grass, 'grassExpAfterR.RDS') #doesn't work

grass %>% 
  group_by(Type, Treatment) %>% 
  summarise(avgUptake = mean (uptake)) %>% 
  ggplot(aes(x = Type, fill = Treatment, y = avgUptake))+
  geom_bar(stat = "identity", position = "dodge")

# Michael loves point plots...
grass %>% 
  group_by(Type, Treatment) %>% 
  summarise(avgUptake = mean (uptake)) %>% 
  ggplot(aes(x = Type, colour = Treatment, y = avgUptake))+
  geom_point(size = 8)
# I find this much, much uglier

# Box plot time... to capture the variance of the data better
grass %>% 
  ggplot(aes(x = Type, colour = Treatment, y = uptake))+
  geom_boxplot()
  
grass %>% 
  ggplot(aes(x = Type, fill = Treatment, y = uptake))+
  geom_boxplot()

?geom_boxplot

# Facet wrap splits the data to make several of the same graph

grass %>%
  ggplot(aes(x = 1, y = uptake)) +
  geom_boxplot() +
  facet_grid(Treatment ~ Type)

# Somewhere in between those:
grass %>%
  ggplot(aes(x = Type, y = uptake, fill = Type)) +
  geom_boxplot() +
  facet_wrap(~ Treatment)

# Cowplot makes things prettier. increases font sizes, defaults to BW background. 

# Try these:

# 1.  Plot uptake for the two types in the two treatments. Which type uptakes more? Which type gets hurt more by chilling?

grass %>% 
  ggplot(aes(x = Treatment, fill = Type, y = uptake))+
  geom_boxplot()+
  scale_fill_manual(values = c("green","magenta"))

# Quebec uptakes more
# mississippi hurt more w cold =/

# 2. A reviewer says that due to structural differences, Mississipi plants' uptake should be increased by 35% to compare with Quebec type plants. Create a new column for adjusted uptake, and calculate the average adjusted uptake and the variance of adjusted uptake within each Type.

grass =
  grass %>% 
  group_by(Type) %>% 
  mutate(adjUptake = ifelse(Type == "Quebec", uptake, uptake*1.35)) 
  
tail(grass) #worked

  grass %>% 
  group_by(Type) %>% 
  mutate(adjUptake = ifelse(Type == "Quebec", uptake, uptake*1.35)) %>% 
  summarise(avgAdjUp = mean(adjUptake), varAdjUp = var(adjUptake))
  #done



# 
# Plot adjusted uptake vs CO2 concentration grouped by type and treatment
grass %>% 
  ggplot(aes(x = conc, y = adjUptake, fill = Treatment))+
  geom_boxplot()+
  facet_wrap(~Type)+
  scale_fill_manual(values = c("mediumorchid","magenta"))
#box plot isn't the best for this since concentration isn't discrete, but the other graphs are ulgy
print(grass$conc)

# My version of Michael's answer
grass %>% 
  ggplot(aes(x = conc, y = adjUptake, colour = Treatment))+
  geom_jitter(size = 4 )+
  facet_wrap(~Type)+
  scale_fill_manual(values = c("mediumorchid","magenta"))

 
# Adv: Make individual plants distinguishable in the plot. That is, we want to follow the response of each plant to changing conc and identify that plant's type and treatment.



grass %>% 
  ggplot(aes(x = adjUptake, y= conc, shape = Type, colour = Treatment))+
  geom_point(size = 3)+
  facet_wrap(~Plant)+
  geom_smooth(method = "lm")+
  scale_colour_manual(values = c("blue","magenta"))
# am I missing plants?
count(grass, Plant) #nope, i got 'em all
length(count(grass, Plant)) #easier to get # of plants? didn't work at all....
nrow(count(grass, Plant))

head(grass)

# After Lunch - Missing Data
getwd()

load('dischargeData.RDA') # why is this not working?? <-- because the file i had was corrupt. FING A!

#PS - an RDA file has all these annoying features (like self-naming. so it's already created a data name for itself in my global environment called 'dis' - so impertinent)

summary(dis)

# NA means missing data
mean (dis$old_pine)

# R is trying to protect you because it doesn't know what NA is
# tell R to ignore them:
mean(dis$old_pine, na.rm = TRUE)
# To test for missing values
is.na(dis$old_pine)

# variable conversion

as.numeric(is.na(dis$old_pine))

# but can skip that since it's always thinking 'true/false' = 0's or 1's

sum(is.na(dis$old_pine))

# To remove ALL DATA with NA's...
na.omit(dis)

# can't run statistical analyses on NA's

lm(old_pine ~ dry_creek, data = dis)
 # by default, this lm function takes out ALL THE NA's --> can yeild biased results

# I stopped paying attention

# tidyr for tidying data
install.packages("tidyr")  # Only once
library(tidyr)  # Every session
# Want one column per variable
# Organized as key:value pairs

# Here station is the key; discharge is the value

gather(dis, )



?gather
# data frame, key , value, specifications of the columns valued together

# can you ungather? yes: spread

gather(dis, station, discharge, old_pine:dry_creek) %>% 
  head()
head(dis)
# you can tell it not to take columns (using -) and it will gather ALL OF THE OTHER COLUMNS
gather(dis, station, discharge, -year, -month) %>% 
  head()

# exercise:
# Ensure that dis is in tidy form.
dis2<- gather(dis, station, discharge, old_pine:dry_creek)
#done above

# Calculate the average discharge by station for each year with the missing values removed.

dis2 %>% 
  group_by(station, year) %>% 
  summarise(mean(discharge, na.rm=TRUE))

# The data collector tells you that the NAs actually represent zero discharge months. Replace the NAs with 0s.
dis2 %>% 
  group_by(discharge) %>% 
  as.data.frame()
# so there are multiple 'types' of NA..

dis2 %>% 
  mutate(discharge = ifelse(discharge == "NA", 0, discharge)) %>% 
  head() #didn't work - still have to use is.na instead of == NA

head(replace(dis2$discharge, "NA", 0)) #totally wrong

# Michael's
dis2$discharge[is.na(dis2$discharge)] = 0

head(dis2)
#works

# Make a line plot of average discharge per month with a separate line-type for each station
dis2 %>% 
  group_by(month, station) %>% 
  summarise(avgDis = mean(discharge)) %>% 
  ggplot(aes(x = month, y = avgDis, linetype = station, colour = station))+
  geom_line()

# More input, output

d <- read.csv("~/Desktop/R_bootcamp/wide_eg.csv")
head(wide_eg)
# This is not tidy; A tidy data frame has one column per variable

# re-saving it as a csv

write.csv(wide_eg, 'myCSV.csv') # if you want to save it in the home directory
write.csv(wide_eg, 'example/myCSV.csv') # if you want to save it in a nested folder
write.csv(wide_eg, '../myCSV.csv') # if you want to save it one folder up

# creating directories in R
dir.create('results')
# This is a nonsense plot!
# WRite a pdf
pdf('results/mygraph.pdf')
ggplot(d, aes(x = sex, y = subject)) +
  geom_point()
dev.off()

# Or, make an image
png('results/mygraph.png')
ggplot(d, aes(x = sex, y = subject)) +
  geom_point()
dev.off()


myplot = ggplot(d, aes(x = sex, y = subject)) +
  geom_point()
myplot
ggsave('results/graphviaggsave.jpg', myplot)

saveRDS(d, 'anRDSfile.RDS')

#write d to a text file
write.table(d,'results/mydataframe.txt')
write.table(d, sep = "HAHAHA", 'results/myHILARIOUSdataframe.txt')
# to use a tab separator = "\t"

# Pretty tables with xtable and stargazer

