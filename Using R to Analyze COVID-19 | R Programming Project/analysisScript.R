# HOUSEKEEPING; library imports, variable cleanup, credits, etc
# credit: https://www.youtube.com/watch?v=D_CNmYkGRUc
rm(list = ls()) # remove all variables stored previously ; good practice
library(Hmisc)

# DATA READ IN
data <- read.csv("~/Desktop/Coding/R/Using R to Analyze COVID-19 | R Programming Project/COVID19_line_list_data.csv")
describe(data) # Hmisc command

# DEATH STATISTICS
# cleaned up death column is data$deathDummy
data$deathDummy <- as.integer(data$death != 0) # cleans up data; some data entries report 1 if the person died, 0 if they didnt, and some report just a date, cleanup fixes inconsistencies 
# ^ if the death column does not equal 0, the person died
sum(data$deathDummy)/nrow(data) # get death rate; result: ~5.8%

# AGE STATISTICS
# claim being tested: people who die are older
dead <- subset(data, deathDummy == 1)
alive <- subset(data, deathDummy == 0)
mean(dead$age, na.rm = TRUE) # na.rm = TRUE removes all data that is simply NA (aka age is unknown)
mean(alive$age, na.rm = TRUE)
# is the 20 year age difference between the mean alive and dead satistically significant?
t.test(alive$age, dead$age, alternative = "two.sided", conf.level = 0.95)
# p value ~ 0, so we reject the null hypothethis and conclude that age is statistically significant

# GENDER STATISTICS
# claim being tested: gender has no effect on survivability
men <- subset(data, gender == "male")
women <- subset(data, gender == "female")
mean(men$deathDummy, na.rm = TRUE) # result: 8.5%
mean(women$deathDummy, na.rm = TRUE) # result: 3.7%
# men have a higher death rate according to this dataset; is this statistically significant?
t.test(men$deathDummy, women$deathDummy, alternative = "two.sided", conf.level = 0.95)
# 99% confidence: men have from .8-8.8% higher chance of dying
# p value = .002 < .05, so this is statistically significant


# RESULTS:
# 1. death rate is ~5.8%
# 2. age is statistically significant; older people die at a higher rate than younger people
# 3. sex is statistically significant; men die at a higher rate than women

