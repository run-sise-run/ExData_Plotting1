##### plot2.R #####

library(ggplot2)
library(data.table)
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


png("plot2.png", width = 480, height = 480)

ggplot(dat, aes(x = DateTime, Global_active_power)) + 
    geom_line(color = "black") + scale_x_datetime("", date_breaks = "1 day", date_labels = "%a") +
    ylab("Global Active Power (kilowats)") + theme_bw() 

dev.off()


