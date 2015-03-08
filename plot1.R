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

##create a png device
png(filename = "plot1.png", width = 480, height = 480, units = "px")
##Draw a histogram using the subset data, color the columns red, put title and x axis label
hist(as.numeric(powerDataRange$Global_active_power),col = "Red",xlab = "Global Active Power (kilowatts)", main="Global Active Power")

##close the device
dev.off()

##Turn warning back on
options(warn=0)