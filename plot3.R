##### plot3.R #####

library(ggplot2)
library(data.table)
library(reshape2)
# library(lubridate)

# My Preferences ---------------------------------------------------------------

memory.limit(size=2000000)
options(datatable.print.topn = 10)
options(datatable.print.nrows = 200)

#========================
#    Read data
#========================

dat <- fread("data/household_power_consumption.txt", na.strings = "?")
# summary(dat)

### make the dataframe smaller
dat[,Date:=as.Date(Date, "%d/%m/%Y")]
dat <- dat[Date == "2007-02-01" | Date == "2007-02-02"]

### format the date and time as s new column for plotting over 2 days
dat[, DateTime:=as.POSIXct(paste(Date,Time))]

#========================
#    Make plot: 480x480 PNG
#========================



### there are several ways to do this with ggplot. here is one:
### reshape the data for data.tables can colorize on the sub grouping
sm <- c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3")
dm <- melt(dat, id = "DateTime", measure.vars = sm)


png("plot3.png", width = 480, height = 480)

### plot the melted data
ggplot(dm, aes(DateTime, value)) + geom_line(aes(color=variable)) + 
    scale_color_manual(values = c("black","red","blue"), guide = guide_legend(title=NULL)) + 
    scale_x_datetime("", date_breaks = "1 day", date_labels = "%a") +
    ylab("Energy sub metering") + theme_bw() + 
    theme(legend.position = c(1,1), legend.justification = c(1,1), 
          legend.background = element_rect(color="black"))

dev.off()


