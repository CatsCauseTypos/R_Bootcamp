# R bootcamp 9/15/2015
# Donnelly West
#Notes #2 

library("ggplot2", lib.loc="/Library/Frameworks/R.framework/Versions/3.2/Resources/library")

#Michael's other things:
library("scales", lib.loc="/Library/Frameworks/R.framework/Versions/3.2/Resources/library")
library("dplyr", lib.loc="/Library/Frameworks/R.framework/Versions/3.2/Resources/library")

library("cowplot", lib.loc="/Library/Frameworks/R.framework/Versions/3.2/Resources/library")


---
  title: "Day2"
author: "Donnelly West"
date: "September 15, 2015"
output: html_document
---
  
  ```{r}
summary(cars)
```

#You can also embed plots, for example:

```{r, echo=FALSE}
plot(cars)
```

```{r, echo=FALSE}
str(mtcars)
```
#prints all values for this column
mtcars$mpg
#tells you what R thinks the data type is
class(mtcars$wt)
#more info - mine looks different than his..
is(mtcars$wt)

#square bracet subsetting
head(mtcars)
#give me first row, first column 

mtcars[1,1] #it just says "21"?

#get row names
carRownames= rownames(mtcars)
#what class did it make it?
class(carRownames)
#pull first car row name
carRownames[1]
#last row name
#can count
carRownames[32]
#or can be clever
carRownames[length(carRownames)]
#tada

#Create a column on mtcars called "carname" from the rowname

#pull a column out = mtcars$wt, same principle to add a column
head(mtcars)
mtcars$carName = rownames(mtcars)
head(mtcars)

#functional programming - things don't change when you do a function to them, only when you assign a variable to it. you have to use an '=' or nothing will change.

#renaming columns
# This extracts the last column name
colnames(mtcars)[length(colnames(mtcars))]

colnames(mtcars)[length(colnames(mtcars))] = "theCarName"
colnames(mtcars)


#quiz: what does [3,2] return on mtcars?
mtcars[3,2]

#vectorization -> the unit of analysis is never A number, it's a vector or string of numbers. the order is preserved. demonstration w/ independent vectors

x = c(4,7,11)
#so x is a numeric vector, length 3

y= 1:3 #colon is inclusive

#x + y
x+y

x+1 #will add 1 to each value of x
#what if you only want to add 1 to the first?
x[1]+1

?seq()
#so if you type seq(,5,3) it will use 'from = 1' by default
4:12
seq(from=4, to=12, by=4)

#or it will calculate the gap
seq(from=4, to=12, length.out=3) #so will pick first, last, and exact middle

#equivalent to seq(... by =)
seq(4,12,4)

#pop quiz
seq(to=12, length.out=3)
seq(from=1,to=12,length.out=3)
seq(to=12, by=1, length.out=3)
#Michael: it doesn't matter; I don't know what it's doing. the point is you should name your arguements!
#but what's happening is that by=default >> from = default

#random # generator
?sample
sample(1:10, 1)
#is it really random?
sample(1:34694570, 5)

#looks like it

#default state is "replace=false" so you'll never pull the same # twice

#have your 10 samples randomly assorted:
sample(1:10,10)
#doesn't just work with numbers...

letters
sample(letters,3)
#all
sample(letters,length(letters))

#for reproducibility, you can set your seed
set.seed(95616)

#does R studio reset the seed upon close/open? yes!

#for decimales random uniform
runif(1, min=0, max = 1)

#random number from normal distribution
Mynorm = rnorm(1e6)
#1e6 is 1x10^6, default = mean=0, stdev =1
#plot the density quickly using R graphics
plot(density(Mynorm))

#add a column to data.frame
#p2w (power to weight)
#try to get R to tell you the name of the car with the highest p2wt ratio

head(mtcars)

mtcars$p2w = (mtcars$hp/mtcars$wt)
head(mtcars) #victory


?max #for just value
max(mtcars$p2w)

?which #nope
mtcars[max(mtcars$p2w, na.rm=TRUE),] #nope; dunno why though

which.max(mtcars$p2w) #tells you the # of the car = 31
#use that info to pull the name
mtcars$carName[which.max(mtcars$p2w)] #works


#pull out the row with the highest p2w
mtcars[mtcars$p2w == max(mtcars$p2w), ] #works

#Michael's version:
mtcars[which.max(mtcars$p2w), c("carName","p2w")]

#is there a way to know the # of the columns without looking at str??
colnames(mtcars) #gives ALL column names
colnames(mtcars) == "hp" #asking it to find the one that matches hp
which(colnames(mtcars) == "hp") # then 'which one matches' = 4

#want to know total # rows/columns?
dim(mtcars)

nrow(mtcars)
ncol(mtcars)

#adding a column T/F if weight >3
mtcars$bigCar = ifelse(mtcars$wt>3, TRUE, FALSE)
head(mtcars)

#Data types:
class(mtcars$wt)
#numeric
class(mtcars$bigCar)
#logical -most basic variable type

#Coersion happens (T/F is be default 1/0 in most programming languages)
as.numeric(mtcars$bigCar)

#Data types:
#logicals = TRUE or FALSE (TRUE != True, true ; TRUE= T)
#numeric 
#character

#Exploring 'true'
# TRUE is different than true or True. But same as T
TRUE == T
TRUE == true
TRUE == "true"
TRUE == 1
as.numeric(TRUE == 1)
as.character(TRUE == 1) == TRUE  # this should be false, but R fixed it for us = Michael "R is being a smartass" 

boys = c("james","mike","sam","mike","bill","bill")
class(boys) #naturally, character class
boys = factor(boys) #change. looks different
#assigned 'levels' -> bill = 1, james = 2, mike = 3, sam = 4

# is or typeof gives you more info than 'class'

as.numeric(boys)
#you can see their # assignment this way

#get the levels
levels(boys)

#if you have lots of things, this is an easier-on-the-memory way to 'remember' the characters as factors; factors are the natural variable type. they're problematic too: 

boys ==2 #error; detour anyway, so abandoning this

#After the break...
library(dplyr)

#updating R is not necessarily a trivial process... there's an automated attempt that helps, but it's still annoying.

# exercises in the meantime... trying to get columns to look at each other

x = sample(1:10,5)
y = sample (1:10, 5)

# is 3 in y?
3 %in% y
#True

#Side note: functions that don't look like other functions '+' and 'in' 

# is x in y? tells you for each:
x %in% y

#can also ask, for which elements of x is the above true?

x[x%in%y]

#or subset
x[3] #just pulls 3rd number
x[c(TRUE,TRUE,FALSE,FALSE,FALSE)] #pulls numbers 1 and 2
#x -> 9,2,10,7,4
#y -> 5,6,4,10,3

#which elements of x are not in y?
x[!(x %in% y)]

#can ask if two things are completely equal? TRUE or it will give you the relative difference

all.equal(1:3, c(1,2,3))

all.equal(x,y)

#can look at: are any the same?
any(1:3 == c(1,2,3))
any(1:3 == c(3,1,2)) #order matters

#can you subset your fascets?

ggplot(mtcars, aes(x = wt, y = hp))+
  geom_point(size = 4)+
  facet_wrap(~cyl)
#so now, you just want 8-cyl cars
cly_eight = mtcars[mtcars$cyl==8,]

ggplot(cly_eight, aes(x = wt, y = hp))+
  geom_point(size = 4)

#adding significance by shape (or by geom_text)

ggplot(cly_eight, aes(x = wt, y = hp, shape = factor(am)))+
  geom_point(size = 4)

mtcars[mtcars$cyl == 8 & mtcars$mpg>15,]
#or
mtcars[mtcars$cyl == 8 | mtcars$mpg>15,]

#remember, you can also say "a or b, and c" or "a or b and c" -- paranthesis will help you make this clear to R

#deleting a column
mtcars$deleteme = 14
head (mtcars)
mtcars = mtcars[, !colnames(mtcars) == "deleteme"]

#dplyr time (also written by ggplot dude)

filter(mtcars, cyl == 8)

filter(mtcars, cyl == 8 & mpg >= 15)

#rearrange columns
select(mtcars, carName, hp, wt)

#can delete
select(mtcars,-carName)

#select is meant to rearrange columns, but you can use it to rearrange them

# Pipe command shift m keyboard shortcut
#%>% 
# sends whatever's on the left to the right in the exact order
  
mtcars%>% select(-carName) #functionally equivalent to select(mtcars,-carName)

# Stringing together 
mtcars %>%
  filter(gear == 3) %>% 
  select(gear, carName)

#range of hp?
range(mtcars$hp)

mtcars %>%
  filter(hp > 250) %>% 
  select(carName, hp, wt)

#even simpler:

filter(mtcars, hp > 250) %>% 
  select(carName, hp, wt)


#old fashioned way:
select(
  filter(mtcars, hp>250),
  carName, hp, wt
)
#same answers

#Arrange
mtcars %>%
  filter(hp > 250) %>% 
  select(carName, hp, wt) %>% 
  arrange(desc(hp)) #can use 'minus' (-) or 'descending' (desc); descending is a tad clearer since minus sign does lots of things 

#add power to weight
mtcars %>%
  filter(hp > 250) %>% 
  select(carName, hp, wt, p2w) %>% 
  arrange(desc(hp)) %>% 
  mutate(p22w = hp/wt)

#cheat sheet:
# filter = choose rows
# select = choose colums
# arrange = order rows
# mutate = add column

#Try this: create DF with 2 columns car model and kmperL, containing only 4 cyl cars. store to DF called fuelEff
#1 mpg = 0.43km/L 

fuelEff=
  mtcars %>% 
  filter(cyl == 4) %>% 
  mutate(KmperL = mpg*0.43) %>% 
  select(carName, KmperL)

fuelEff

#'other questions' 
#sorting & ordering
sort(mtcars$hp)
#decreasing
sort(mtcars$hp, decreasing = TRUE)

# Order mtcars by hp
ord = order(mtcars$hp)
mtcars[ord, ]

# with dplyr
arrange(mtcars, hp)

#back to 'on our own' question...
#let's add on a ascending order
mtcars %>% 
  filter(cyl == 4) %>% 
  mutate(KmperL = mpg*0.43) %>% 
  select(carName, KmperL) %>% 
  arrange(KmperL)

#after lunch dplyr == stuff that's supposedly easier in dplyr than in base R
#smidge of text editing: can you split car model vs make? yup..
strsplit(fuelEff$carName, "\\s")

#Sumarize / Sumarise
#looks over a whole group of data and gives some aggrigate answer
summarise(mtcars,mean(hp))
#or
mean(mtcars$hp)

mtcars %>% 
  group_by(cyl) %>% 
  summarise(avgPower = mean(hp))

mtcars %>% 
  group_by(cyl, gear) %>% 
  summarise(bestEff = max(mpg))

#try this: mtcars$am is 0 for automatic and 1 for manual. which is avg mpg higher for?
# calc avgs by group
# plot
# fuel vs transmission types

transEff =
  mtcars %>% 
  group_by(am) %>% 
  summarise(avgFuel = mean(mpg))

ggplot()+
  geom_point(data = transEff, aes(x = avgFuel, y = am), color="blue")+
  geom_point(data = mtcars, aes(x = mpg, y = am), color="pink")
#works, but ugly

ggplot()+
  geom_bar(stat = "identity",
           data = transEff,
           aes(x = am, y = avgFuel),
           color = "blue")+
  
  geom_bar(stat = "identity",
           data = mtcars,
           aes(x = am, y = mpg),
           color = "pink")
#works, but ugly and makes very little sense

ggplot()+ 
  geom_boxplot(data = transEff,
           aes(x = factor(am), y = avgFuel),
          color = "blue", size=10)+
  
  geom_boxplot(data = mtcars,
           aes(x = factor(am), y = mpg),
           color = "pink") #hey, that's not so bad!

#Michael's way:
transEff =
  mtcars %>% 
  group_by(am) %>% 
  summarise(avgFuel = mean(mpg)) %>% 
  ggplot(aes(x = factor(am), y=avgFuel))+
  geom_bar(stat='identity')+
  scale_x_discrete(labels = c("auto", "manual"))

#Why summarize when you can show the whole distribution? 
ggplot(mtcars, aes(x = factor(am), y = mpg))+
  geom_violin()

ggplot(mtcars, aes(color = factor(am), x = mpg)) +
  geom_density() #not super informative

### how to change factor levels?
mtcars %>% 
  group_by(am) %>% 
  summarise(count = n())
#or
mtcars %>% 
  count(am)
#add a thing
mtcars %>% 
  count(am, gear)
#I get these weird (dbl) and (int) when I run this in addition to the other stuff... dunno why..
class(mtcars$am)
#thinks it's numeric, so not 'dbl' /shrug

# or, in base R
table(mtcars$am)

mtcars %>%
  count(am, gear)
# or in base R
table(mtcars$am, mtcars$gear)

# top_n
mtcars %>%
  count(gear) %>%
  top_n(2)

# Or, more laboreously
mtcars %>%
  count(gear) %>%
  arrange(-n) %>%
  .[1:2, ] #this dot does some magic with the data frame that I definitely don't understand.

#Try these:
# Exercise
# What combination of tranmission type and number of gears has the fastest average quarter-mile time ("qsec")?

mtcars %>% 
  group_by(am & gear & qsec) %>% #i dunno - OH IT TURNS OUT you have to use a comma, not an &
  summarise(FAST = mean(qsec)) #nope

mtcars %>% 
  group_by(qsec) %>% #not what i want
  arrange(desc(qsec)) #doesn't work anyhow

mtcars %>% 
  group_by(am, gear) %>% 
  summarise(avgQsec = mean(qsec)) %>% 
  arrange(desc(avgQsec))
  
#turns out, a bigger number is a slower car HAHAHAHA
mtcars %>% 
  group_by(am, gear) %>% 
  summarise(avgQsec = mean(qsec)) %>% 
  arrange(avgQsec) #doesn't work b/c it prioritizes the 'groups' over what you asked for.. insolent little...
mtcars %>% 
  group_by(am, gear) %>% 
  summarise(avgQsec = mean(qsec)) %>% 
  ungroup %>% 
  arrange(avgQsec)
#there we go
mtcars %>% 
  group_by(am, gear) %>% 
  summarise(avgQsec = mean(qsec)) %>% 
  ungroup %>% 
  arrange(avgQsec) %>% 
  slice(1:3)
#in case your data set is hilariously large and you don't want all of it to print
# Vizualization:
mtcars %>%
  group_by(am, gear) %>%
  summarise(avgTime = mean(qsec)) %>%
  ggplot(aes(x = am, y = gear, fill = avgTime)) +
  geom_tile()
  
#loading data
#check working directory
getwd()
#set / change working directory
setwd("~/Desktop/R_bootcamp/")

flights = readRDS("flights.RDS")

str(flights)

flights %>% 
  count(carrier)
#prints them all, because you have 16


flights %>% 
  count(origin)
# get ...
#fix:
flights %>% 
  count(origin) %>% 
  as.data.frame()
