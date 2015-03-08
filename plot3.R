##Supress warnings globally
options(warn=-1)
##use english locale
Sys.setlocale("LC_TIME", "English")

##For speed fread is used, install data.table package if not intalled
if (!require("data.table")){
        install.packages("data.table")
}

##Check if file exist, if not download to ./data folder
if(!file.exists("./data/household_power_consumption.txt")){
        temp <- tempfile()
        download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip",temp)
        unzip(temp, exdir = "./data")
        unlink(temp)         
}

##Load data using fread
powerData<- fread("./data/household_power_consumption.txt", na.strings = "?")

##Coerce date column to Date types
powerData$Date<- as.Date(powerData$Date, format="%d/%m/%Y")

##subset data choosing only dates 2007-02-01 and 2007-02-02
powerDataRange<- subset(powerData, Date =="2007-02-01" | Date=="2007-02-02")

##combine date and time into a new timestamp column
powerDataRange$timestamp<- as.POSIXct(paste(powerDataRange$Date, powerDataRange$Time))

##create a png device
png(filename = "plot3.png", width = 480, height = 480, units = "px")
##Draw a blank plot using Sub_metering_1 and timestamp
plot(powerDataRange$Sub_metering_1~powerDataRange$timestamp, type="n", ylab = "Energi sub metering", xlab="", main="")
##Draw Sub_metering_1 data
points(powerDataRange$Sub_metering_1~powerDataRange$timestamp, type="l")
##Draw Sub_metering_2 data in color red
points(powerDataRange$Sub_metering_2~powerDataRange$timestamp, type="l", col="red")
##Draw Sub_metering_3 data in color blue
points(powerDataRange$Sub_metering_3~powerDataRange$timestamp, type="l", col="blue")
##add legends
legend("topright",c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), lty = 1, col=c("black","red","blue"))

##close the device
dev.off()

##Turn warning back on
options(warn=0)