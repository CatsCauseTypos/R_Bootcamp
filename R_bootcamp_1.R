# R bootcamp 9/2015
# Donnelly West
#Notes etc

#just in case
library("ggplot2", lib.loc="/Library/Frameworks/R.framework/Versions/3.2/Resources/library")
#Notes: C++ has to compile and run all lines at once, whereas R will run line by line ('REBL' - read, evaluate, print, repeat)

#Michael's other things:
library("scales", lib.loc="/Library/Frameworks/R.framework/Versions/3.2/Resources/library")
library("dplyr", lib.loc="/Library/Frameworks/R.framework/Versions/3.2/Resources/library")

library("cowplot", lib.loc="/Library/Frameworks/R.framework/Versions/3.2/Resources/library")

#Michael:
#primary thing we'll do in ggplot, is to 'ggplot' lolz
library(help = "ggplot2")
#gets 'help' for a package. google always superior, though.

?ggplot()
#gets help for any function (again, google= better)

str(movies)
#shows structure of the data frame in question

ggplot(movies, aes(x=year, y=budget))+
  geom_point()
#aesthetics says, go into movie data frame and map this aspect of the data

#yay tab completion

#then we try an example:
#Plot Petal length vs width for data set iris:
str(iris) #what does it look like?

ggplot(iris, aes(Petal.Length, Petal.Width, colour=Species))+
  geom_point()
#added color because WE CAN

#Michael:
myplot = 
  ggplot(iris, aes(x = Petal.Length, y = Petal.Width)) +
  geom_point()
#then run it
myplot

#adding a best fit line (or lines)
#one line per species
ggplot(iris, aes(Petal.Length,
                 Petal.Width,
                 color=Species))+
  geom_point()+
  geom_smooth(method="lm")

#or 
#one line for all data
ggplot(iris, aes(Petal.Length,
                 Petal.Width))+
  geom_point(aes(color=Species))+
  geom_smooth(method="lm", color="black")

#or can scale points to Sepal.Length

ggplot(iris, aes(Petal.Length,
                 Petal.Width))+
  geom_point(aes(color=Species, size=Sepal.Length))+
  geom_smooth(method="lm", color="black")

#can add lines in the axis to denote significance, species of interest, threshholds, etc

ggplot(iris, aes(Petal.Length,
                 Petal.Width))+
  geom_point(aes(color=Species, size=Sepal.Length))+
  geom_smooth(method="lm", color="black")+
  geom_hline(yintercept=1, linetype="dashed")+
  geom_vline(xintercept=4, linetype="dotted")


#can also add text any where you want
ggplot(iris, aes(Petal.Length,
                 Petal.Width))+
  geom_point(aes(color=Species, size=Sepal.Length))+
  geom_smooth(method="lm", color="black")+
  geom_hline(yintercept=1, linetype="dashed")+
  geom_vline(xintercept=4, linetype="dotted")+
  geom_text(x=3, y=2, label="RIGHT HERE, MAN")

#or put in another tread line to show a different ratio than your data represents:
ggplot(iris, aes(Petal.Length,
                 Petal.Width))+
  geom_point(aes(color=Species, size=Sepal.Length))+
  geom_smooth(method="lm", color="black")+
  geom_abline(intercept=0, slope=1, colour="orange")+
  geom_text(x=2.8, y=2, label="if slope = 3/2", colour="orange")

#You can also have your 'points' be the 'values' of your data:
ggplot(iris, aes(Petal.Length,
                 Petal.Width))+
  geom_smooth(method="lm", color="black")+
  geom_text(aes(color=Species, label= Sepal.Length), size=3)
#but it's ugly & hard to read

#setting ylim (or something y-ish)
ggplot(iris, aes(Petal.Length,
                 Petal.Width))+
  geom_point(aes(color=Species, size=Sepal.Length))+
  geom_smooth(method="lm", color="black")+
  scale_y_continuous(limits=c(0,3), expand=c(0,0))

#Michael wrote exactly code below for problem above.. it just changed the y axis value limits & gets rid of the 'white space' below 0 and above 3)
ggplot(iris, aes(x = Petal.Length, 
                 y = Petal.Width)) +
  #  geom_point(aes(color = Species, size = Sepal.Length)) +
  geom_smooth(method = "lm", color = "black") +
  geom_text(aes(color = Species, label = Sepal.Length),
            size = 2) +
  scale_y_continuous(limits=c(0, 3), 
                     expand = c(0, 0))


#New section time: histograms & density curves

#movies made by year...

ggplot(movies, aes(x=year))+
  geom_histogram()

#get error of binwidth, so set it manually:

ggplot(movies, aes(x=year))+
  geom_histogram(binwidth=1) #per year

#or per decade
ggplot(movies, aes(x=year))+
  geom_histogram(binwidth=10)

#me: How do you separate the bins to look less bloby? Michael tried some things, but none of them worked on the movies data set for some reason (this is exactly why I hate R); we have no idea how to do it. 

#accidental, hilarious MIDDLE FINGER while trying to get the bins separated
ggplot(movies, aes(x=year))+
  geom_histogram(binwidth=50, width=.001)
  

#combining elements - he buzzed through this so quickly as to be useless to anyone not already familiar with it.

c(1,2)

x=3

y=17

z=c(x,y)

#Can set x limits "programmatically"

#First set the limits you want to a value
xlimits= c(1980,2010)
#Then use the value
ggplot(movies, aes(x=year))+
  geom_histogram(binwidth=1)+
  xlim(xlimits)

#Density curves
ggplot(movies, aes(x=year))+
  geom_density(adjust=.1) #default is 1... the 'adjust' serves to change how 'smooth' the data is.. sidenote: .1 = ugly

#look at the ratings of movies over the year
ggplot(movies, aes(x=year, colour=mpaa))+
  geom_density()

#Excude movies without rating
movies_1= movies[movies$mpaa!="",]

ggplot(movies_1, aes(x=year, colour=mpaa))+
  geom_density()

# Reload the movies data.frame:
data(movies)

#it's cute that he bitched about reproducibility of data and how people just keep what they want, but rather than ACTUALLY fixing the legend, he decided to dump all of the movies that didn't have ratings SO HILARIOUS. #h8

#In Iris, make density curve of petal length
ggplot(iris, aes(Petal.Length))+
  geom_density()
#Then, separate curves by species
ggplot(iris, aes(Petal.Length, colour=Species))+
  geom_density()

#or
ggplot(iris, aes(Petal.Length))+
  geom_density(aes(colour=Species))
#or fill
ggplot(iris, aes(Petal.Length))+
  geom_density(aes(fill=Species))
# change transparancy 
ggplot(iris, aes(Petal.Length))+
  geom_density(aes(fill=Species), alpha=0.5)

#in R, every color has R,G,B values and an alpha value 


ggplot(iris, aes(Petal.Length))+
  geom_line(stat="density", aes(color=Species), size =2)

#combing scatter plots & distributional info
ggplot(movies, aes(x=year, y=budget))+
  geom_point(position="jitter")+ #tried jitter... still ugly
  scale_x_log10() #tried to transform.. still ugly

#rug plot
ggplot(movies, aes(x=year, y=budget))+
  geom_point(position="jitter", alpha=.5, color="pink")+ #tried jitter... still ugly
  scale_x_log10()+ #tried to transform.. still ugly
  geom_rug(alpha=.01) #puts hash mark on axis, made them transparent so darkness=quantity
  
#our turn...
ggplot(iris, aes(x=Petal.Width, y=Petal.Length))+
  geom_point()+
  geom_rug(alpha=0.3)

#use both 'methods' to color data by species
#1
ggplot(iris, aes(x=Petal.Width, y=Petal.Length))+
  geom_point(aes(color=Species))+
  geom_rug(alpha=0.3)
#2
ggplot(iris, aes(x=Petal.Width, y=Petal.Length, color=Species))+
  geom_point(shape=2)+
  geom_rug(alpha=0.3)

#2 is better because hash marks are also colored - VICTORY!
#also, we got bored and started messing with the shapes of the points

#Micheal: Make x and y axes have same scale and jitter rug plots
ggplot(iris, aes(x=Petal.Width, y=Petal.Length, color=Species))+
  geom_point()+
  geom_rug(position='jitter')+
  xlim(c(0,7))+
  ylim(c(0,7))

#Michael: Get rid of bottom line note: what??
ggplot(iris, aes(x = Petal.Length)) +
  geom_density(aes(fill = Species), alpha = .5)

ggplot(iris, aes(x = Petal.Length)) +
  geom_line(stat = "density",
            aes(color = Species), size = 2)

