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

##Draw a plot using combined column timestamp and global active power
plot(powerDataRange$Global_active_power~powerDataRange$timestamp, type="l", ylab = "Global Active Power (kwh)", xlab="", main="")

##Open a png device and copy the histogram to plot2.png. Not adjusting width and heigth, since the default is 480px for both witdth and heigth
dev.copy(png, file="plot2.png")

##close the device
dev.off()

##Turn warning back on
options(warn=0)