activity=read.csv("activity.csv", stringsAsFactors = FALSE)
str(activity)
activity$date <- as.Date(activity$date, "%Y-%m-%d")

#What is mean total number of steps taken per day?-----

#Calculate the total number of steps taken per day. Ignore NAs
library(dplyr)
steps <- aggregate(steps~date, data=activity, sum)

#Making a histogram of the total number of steps taken each day:
hist(steps$steps,breaks = 25, col ="red", xlab ="Total number of steps", main="Histogram of total number of steps taken per day")

#Calculate the mean and median of the total number of steps taken per day:
mean_steps = mean(steps$steps)
median_steps = median(steps$steps)

#What is the average daily acitivity pattern?----

#Calculate the average daily pattern
steps_ave <- aggregate(steps~interval, activity,mean)

#Time series plot of 5 minut intervals and average number od steps taken
plot(steps_ave$interval,steps_ave$steps, type="l",col="red", xlab="5-minute interval", ylab="Number of steps", main = "Average number of steps per day per interval")

#5-minute interval with the maxium number of steps (on average)
max_interval = steps_ave[which.max(steps_ave$steps),1]

#Imputing missing values-----

#Total number of missing values in the dataset
anyNA(activity)
sum(is.na(activity))
colSums(is.na(activity))

#Imputing missing values with mean for that 5-minute interval
activity$CompleteSteps = ifelse(is.na(activity$steps), round(steps_ave$steps[match(activity$interval, steps_ave$interval)],0),activity$steps)

#Create new dataset with filled missing values
activity_new = data.frame(steps = activity$CompleteSteps, interval = activity$interval, date = activity$date)
head(activity_new)

#Make a histogram of the total number of steps taken each day
steps <- aggregate(steps~date, data=activity_new, sum)

hist(steps$steps,breaks = 25, col ="blue", xlab ="Total number of steps", main="Histogram of total number of steps taken per day (removed NAs)")

#Calculate the mean and median of the total number of steps taken per day:
mean_steps_new = mean(steps$steps)
median_steps_new = median(steps$steps)

#Are there differences in activity patterns between weekdays & weekends?--------

#Create factors to stora the weekdays & weekends
activity_new$weekday = weekdays(activity_new$date)
activity_new$Day = ifelse(activity_new$weekday =="Saturday" | activity_new$weekday =="Sunday","weekend","weekday")

#Create plots for weekends and weekdays for averaged number of steps taken per day per 5-minute intervals
steps_ave_W = aggregate(steps~interval + Day, activity_new, mean)

library(ggplot2)
ggplot(steps_ave_W, aes(interval,steps)) +
  geom_line(col="red") + facet_grid(Day ~.) +
  ggtitle("Average steps per 5-minute interval:weekday vs.weekends")
