##### plot1.R #####

library(ggplot2)
library(data.table)

# My Preferences ---------------------------------------------------------------

memory.limit(size=2000000)
options(datatable.print.topn = 10)
options(datatable.print.nrows = 200)

#========================
#    Read data
#========================

dat <- fread("data/household_power_consumption.txt", na.strings = "?")
summary(dat)

### make the dataframe smaller
dat[,Date:=as.Date(Date, "%d/%m/%Y")]
dat <- dat[Date == "2007-02-01" | Date == "2007-02-02"]

#========================
#    Make plot: 480x480 PNG
#========================

png("plot1.png", width = 480, height = 480)
ggplot(dat, aes(x = Global_active_power)) + 
    geom_histogram(breaks = seq(0,8,0.5), fill = "red", color = "black") + 
    xlab("Global Active Power (kilowats)") + ylab("Frequency") +
    ggtitle("Global Active Power") +  theme_bw() 

dev.off()


