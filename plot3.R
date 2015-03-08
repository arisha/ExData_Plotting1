##Supress warnings globally
options(warn=-1)

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


##Draw a blank plot using Sub_metering_1 and timestamp
plot(x$Sub_metering_1~x$timestamp, type="n", ylab = "Energi sub metering", xlab="", main="")
##Draw Sub_metering_1 data
points(x$Sub_metering_1~x$timestamp, type="l")
##Draw Sub_metering_2 data in color red
points(x$Sub_metering_2~x$timestamp, type="l", col="red")
##Draw Sub_metering_3 data in color blue
points(x$Sub_metering_3~x$timestamp, type="l", col="blue")
##add legends
legend("topright",c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), lty = 1, col=c("black","red","blue"))

##Open a png device and copy the histogram to plot2.png. Not adjusting width and heigth, since the default is 480px for both witdth and heigth
dev.copy(png, file="plot3.png")

##close the device
dev.off()

##Turn warning back on
options(warn=0)