library(ggplot2)
str(diamonds)
summary(diamonds)
head(diamonds)
# Histogram of `carat` vs. count:
ggplot(diamonds, aes(x = carat)) +
        geom_histogram(binwidth = .001)

# Density curve of `carat` vs. count:
ggplot(diamonds, aes(x = carat)) +
        geom_density(adjust = 0.001)
        

# Histrogram of `cut` (quality) vs count:
ggplot(diamonds, aes(x = cut)) +
        geom_histogram(binwidth = .001)

# Use `str` to determine the number of cuts in the 'diamonds' data.frame:
str(diamonds$cut)
        # 5 quality tiers

# Create a histogram to explore the distribution of `carat` (size) x `cut` qualities. 
        #Cuts separated by `facet`
ggplot(diamonds, aes(x = carat)) +
        geom_histogram(binwidth = 0.01) +
        facet_grid( ~ cut)

        #Cuts separated by line color
ggplot(diamonds, aes(x = carat, color = cut)) +
        geom_histogram(binwidth = 0.01)

# Create a  density curve to explore the distribution of `carat` (size) x `cut` qualities. 
        # Cuts separated by  facet
ggplot(diamonds, aes(x = carat)) +
        geom_density(adjust = 0.01) +
        facet_grid( ~ cut)

        # Cuts separated by line color
ggplot(diamonds, aes(x = carat, color = cut)) +
        geom_density(binwidth = 0.01)
        xlim(0, 10)
        ylim(0, 5)

# Which of the above plots would be more appropriate if we were interested in 
        # absolute quantity of diamonds of each cut? 
        # Which would be more appropriate if we were interested in the relative 
                # distribution of sizes within each cut? Why?

        # The histograms (carat x count) are better to evaluate the absolute
                # numbers of diamonds sold for cut x quality
        # The density plot is better suited to determine whether the percentages
                # of a carat within a quality grade are more common for cut x vs 
                # cut y
        
# Create a boxplot that compares the distribution of sizes within each `cut`.
ggplot(diamonds, aes(x = cut, y = carat)) +
        geom_boxplot()

# Change the above plot to be a violin plot. 
        # Add a single line to facet the plots by both color and clarity. 
        # Don’t worry about the legibility of the resulting plot.
ggplot(diamonds, aes(x = cut, y = carat)) +
        geom_violin(aes(fill = cut))

# Let’s try to get all that information in a more comprehensible plot. 
        # Leave carat on the y-axis, and experiment with mapping 
                # `cut`, `clarity`, and `color` to x.
        # Use color/fill, and facets arguments to produce a reasonable plot. 
        # Use whichever of boxplots or violin plots is more legible.
#a.
ggplot(diamonds, aes(x = cut, y = carat)) +
        geom_boxplot(aes(fill = cut))           # Good plot

#b.
ggplot(diamonds, aes(x = clarity, y = carat, color = cut)) +
        geom_boxplot() +
        facet_grid(~ cut)                       # Good plot, aesthetically pleasing
        
#c.
ggplot(diamonds, aes(x = cut, y = carat)) +
        geom_boxplot(aes(fill = cut))           # Informative, but not useful
                                                # `fill` = `color` not useful

#d.
ggplot(diamonds, aes(x = clarity, y = carat)) +
        geom_boxplot(aes(fill = cut)) + 
        facet_grid(~ cut)                       # Better than #2, but not great

#e.
ggplot(diamonds, aes(x = color, y = carat)) +
        geom_boxplot(aes(fill = cut))           # Informative, but not useful
                                                # `fill` = `color` not useful

#f.
ggplot(diamonds, aes(x = cut, y = carat)) +
        geom_violin(aes(fill = cut))           # Not useful; no points shown

#g.
ggplot(diamonds, aes(x = cut, y = carat)) +
        geom_violin(aes(fill = cut)) +
        facet_grid(~ clarity)

#h.
ggplot(diamonds, aes(x = cut, y = carat)) +
        geom_violin(aes(fill = cut)) +
        facet_grid(~ color + clarity)

# Preferred Plots (Violin > Boxplot):
        # Boxplot: 
        ggplot(diamonds, aes(x = clarity, y = carat, color = cut)) +
        geom_boxplot() +
                facet_grid(~ cut)

        # Violin plot:
        ggplot(diamonds, aes(x = cut, y = carat)) +
                geom_violin(aes(fill = cut)) +
                facet_grid(~ clarity)

#6. Create a scatterplot of diamond price as a function of size.
ggplot(diamonds, aes(x = carat, y = price)) +
                geom_point()

# There is a lot of overplotting there, so information is being lost. 
        # Adjust the alpha level of the points to fix this.
ggplot(diamonds, aes(x = carat, y = price)) +
        geom_point(alpha = .01)

# Add marginal rug plots to provide variable distribution information
        # Consider adjusting the alpha level of the rug plots too
ggplot(diamonds, aes(x = carat, y = price)) +
        geom_rug(alpha = .8)                    
        #possible problems w/ RAM due to dataset size

ggplot(diamonds, aes(x = carat, y = price)) +
        geom_point(alpha = .01) +
        geom_rug(alpha = .3)

# Add a smoothing curve to plot. 
        ggplot(diamonds, aes(x = carat, y = price)) +
        geom_point(alpha = 0.1) +
        geom_smooth(method = "lm")

        # What do you think about the right side of the curve? 
        # Consider that and the marginal distributions of each variable. 
        # Should you transform either or both of the axes? Experiment.
        ggplot(diamonds, aes(x = carat, y = price)) +
                geom_point(alpha = 0.1) +
                geom_smooth(method = "lm") +
                scale_y_continuous(formatter='log10')

        