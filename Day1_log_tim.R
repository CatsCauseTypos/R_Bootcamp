install.packages("ggplot2") #only once
library(ggplot2) # every time
library(help = "ggplot2")

?ggplot()
str(movies)
ggplot(movies, aes(x = year, y = budget)) + 
        geom_point()

## Iris Dataset Plotting ##
# Iris petal length x width
str(iris)
ggplot(iris, aes(x = Petal.Length, y = Petal.Width)) + 
        geom_point()

ggplot(iris, aes(x = Petal.Length, y = Petal.Width)) +
        geom_point(aes(color = Species, size = Sepal.Length)) +
        geom_smooth(method = "lm", color = "black") +
        geom_hline(yintercept = 1, linetype = "dashed") +
        geom_vline(xintercept = 4, linetype = "dotted") +
        geom_abline(intercept = 0, slope = 1) +
        geom_text(x = 3, y = 2, label = "text here!")
ggplot(movies, aes(x = year)) +
        geom_histogram(binwidth = 1)

# separate bins
ggplot(movies, aes(x = year)) +
        geom_bar(width = 0.5,
                position = position_dodge(width=0.5))

# combining elements
c(1, 2)
y = 17
z = c(x, y)
z


#change axis limits
ggplot(movies, aes(x = year)) +
        geom_histogram(binwidth = 1) +
        xlim(xlimits)

# set x limits 'programitacally"
xlimits = c(1980, 2010)

# Density curves
ggplot(movies, aes(x = year)) + 
        geom_density(adjust=.25)

# # movies per rating
ggplot(movies, aes(x = year, color = mpaa)) + 
        geom_density()

# Exclude movies without a rating
movieswithrating= movies[movies$mpaa != "", ]

ggplot(movies, aes(x = year, color = mpaa)) + 
        geom_density()

data(movies)
movies
head(movies)

# make a density curve of Iris Petal.Length; separate curves by Species
ggplot(iris, aes(x = Petal.Length, color = Species)) +
        geom_density()

# or
ggplot(iris, aes(x = Petal.Length)) +
        geom_density(aes(fill = Species))

# change the opacity

ggplot(iris, aes(x = Petal.Length)) +
        geom_density(aes(fill = Species), alpha = 0.5)

# Eliminate bottom line at 0

ggplot(iris, aes(x = Petal.Length)) +
        geom_line(stat = "density",
                  aes(color = Species), size = 1)

# Compning scatter plots and distributional information
ggplot(movies, aes(x = year, y = budget)) +
        geom_point(position = "jitter", alpha = .05) +
        geom_rug(alpha = 0.01)

# Excercise: 2 ways to color by species; implement both; decide preference
ggplot(iris, aes(x = Petal.Width, y = Petal.Length, color = Species)) +
        geom_point() +
        geom_rug(alpha = 0.3)


# Excercise: 2 ways to color by species; implement both; decide preference
ggplot(iris, aes(x = Petal.Width, y = Petal.Length)) +
        geom_point(aes(color = Species)) +
        geom_rug(alpha = 0.3)

# Render x- and y-axis with the same scale
ggplot(iris, aes(x = Petal.Width, y = Petal.Length, color = Species)) +
        geom_point() +
        geom_rug(position = jitter = 0.3) +
        xlim(c(0, 7)) +
        ylim(c(0, 7))


## Boxplots
# How has the length of movies changed over time?
ggplot(movies, aes(x = factor(year), y = length)) +
        geom_boxplot()

        # year set as a factor, not the default variable

## Plot variance amone groups using the iris dataset; Petal.Length x Species
# Boxplot

ggplot(iris, aes(x = Species, y = Petal.Length)) +
        geom_boxplot(aes(fill = Species))

ggplot(iris, aes(x = Petal.Length, color = Species)) +
        geom_boxplot()
        #returns an arror: y aesthetic missing

#Density Curve
ggplot(iris, aes(x = Petal.Length, color = Species)) +
        geom_density(aes(fill = Species), alpha = 0.5)

##Faceting
#separate into different windows:
ggplot(movies, aes(x = length)) + 
        geom_histogram() + 
        facet_wrap(~ mpaa)      # facet by rating, default scales are same

#scale on a per-plot basis
ggplot(movies, aes(x = length)) + 
        geom_histogram() + 
        facet_wrap(~ mpaa, scales = "free_y")

# set n_row to one
ggplot(movies, aes(x = length)) + 
        geom_histogram() + 
        facet_wrap(~ mpaa, scales = "free_y", nrow = 1)

#Dual facets
movies$isComedy = ifelse(movies$Comedy == 1,
                         "it's a comedy",
                         "it's not a comedy")
table(movies$isComedy , movies$Comedy)
ggplot(movies, aes(x = budget, y = rating)) +
        geom_point() +
        facet_grid(Action ~ isComedy)
        
#Create 2 scatterplots of Sepal.Length vs. Petal.Length
## 1. Color the points by Species
## 2. Facet the plot by Species
## WHich works better?
## 3. To preferred plot, add another layer to the plot 
##      to illustrate the relationship more explicetly with geom_smooth
## 4. Your advisor doesn't understand the squiggly lines and wants to see
##      a linerar regression of the data. Can you add an argument to the 
##      geom_smooth to add a linear fit? (Hint: 'lm' is used for a linear fit)

#Facet by Species

ggplot(iris, aes(x = Sepal.Length, y = Petal.Length, color = Species)) +
        geom_point() +
        facet_grid(~ Species)

# Add a linear regression to Facet by Species plots

ggplot(iris, aes(x = Sepal.Length, y = Petal.Length, color = Species)) +
        geom_point() +
        facet_grid(~ Species) +
        geom_smooth(method = "lm")



# Scatterplot by Species
ggplot(iris, aes(x = Sepal.Length, y = Petal.Length, color = Species)) +
        geom_point() +
        geom_rug(alpha = 0.3)

# Add a linear regression
ggplot(iris, aes(x = Petal.Length, 
                 y = Sepal.Length, 
                 color = Species)) +
        geom_point() +
        geom_smooth(method = "lm")

# Preview of linear modeling"
lm(Sepal.Length ~ Petal.Length, iris)

# Adding a title
ggplot(iris, aes(x = Petal.Length, 
                 y = Sepal.Length, 
                 color = Species)) +
        geom_point() +
        geom_smooth(method = "lm") +
        ggtitle("Iris spp. Sepal and Petal Lengths") +
        ylab("Sepal length (cm?)") +
        xlab("Petal length (cm?)")

        
## R MARKDOWN
# Create a new Rmarkdown document
# Save doc to disk
# Kniit the default document to HTML using cmd-shift-k & examine output
# Edit default documents so that it provides:
        # some information about the iris data.frame, and 
        # one of your plots of the iris data including the code that generate it

str(diamonds)


       
