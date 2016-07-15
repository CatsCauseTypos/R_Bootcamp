# title: "R_bootcamp_day2_solutions"
# author: "Donnelly West"
# date: "September 15, 2015"

d = flights
# 1. Howmanyflightsarethereinthedataset?
nrow(d)
## [1] 1961489
# or
summarise(d, n())
##       n()
## 1 1961489
# 2. Whichairlinehasthemostflights?Theleast?
sort(table(d$carrier))

# or
d %>%
  group_by(carrier) %>%
  summarise(nFlights = n()) %>%
  arrange(-nFlights)
# or
d %>%
  group_by(carrier) %>%
  summarise(nFlights = n()) %>%
  arrange(-nFlights)

￼# or (and better than above)
d %>%
  count(carrier) %>%
  arrange(-n)
#3.HowmanyairlinesflyfromLAXtoSFO?
ssCarriers = d[d$origin == "LAX" & d$dest == "SFO", "carrier"]
length(unique(ssCarriers))

# or
d %>%
  filter(origin == "LAX" & dest == "SFO") %>%
  summarise(n_distinct(carrier))

# 4. a. To what airports can you fly from Sacramento (SMF)?
# b. Which of these represents the longest distance flight?
# c. Plot the average time to each airport from SMF. Make sure the order of the destination
# airports makes the plot easy to read.

#a

d %>%
  filter(origin == "SMF") %>%
  select(dest) %>%
  distinct

#b
d %>%
  filter(origin == "SMF") %>%
  group_by(dest) %>%
  summarise(dist = unique(distance)) %>%
  top_n(1, dist)
#c
d %>%
  filter(origin == "SMF") %>%
  group_by(dest) %>%
  summarise(avgTime = mean(air_time, na.rm = TRUE)) %>%
  ggplot(aes(x = reorder(dest, avgTime), y = avgTime)) +
  geom_point() +
  coord_flip()

# 6
# a. To what airports can you fly from Sacramento (SMF)?
# b. Which of these represents the longest distance flight?
# c. Plot the average time to each airport from SMF. Make sure the order of the destination
# airports makes the plot easy to read.