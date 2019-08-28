##### plot4.R #####

library(ggplot2)
library(data.table)
library(reshape2)
library(gridExtra)

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

sm <- c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3")
dm <- melt(dat, id = "DateTime", measure.vars = sm)

### plot the melted data
p3 <- ggplot(dm, aes(DateTime, value)) + geom_line(aes(color=variable)) + 
    scale_color_manual(values = c("black","red","blue"), guide = guide_legend(title=NULL)) + 
    scale_x_datetime("", date_breaks = "1 day", date_labels = "%a") +
    ylab("Energy sub metering") + theme_bw() + 
    theme(legend.position = c(1,1), legend.justification = c(1,1), 
          legend.background = element_blank(),
          legend.key = element_blank())

p1 <- ggplot(dat, aes(x = DateTime, Global_active_power)) + 
    geom_line(color = "black") + scale_x_datetime("", date_breaks = "1 day", date_labels = "%a") +
    ylab("Global Active Power") + theme_bw() 

p2 <- ggplot(dat, aes(x = DateTime, Voltage)) + geom_line(color = "black") + 
    scale_x_datetime("", date_breaks = "1 day", date_labels = "%a") + theme_bw() 

p4 <- ggplot(dat, aes(x = DateTime, Global_reactive_power)) + geom_line(color = "black") + 
    scale_x_datetime("", date_breaks = "1 day", date_labels = "%a") + theme_bw() 


### Arrange the plots and save to a file

png("plot4.png", width = 480, height = 480)

grid.arrange(p1,p2,p3,p4,nrow=2,ncol=2)

dev.off()


