# This script creates plot4.png

require(lubridate)

# Checks if data file exists. Downloads and unzips if not.
if (!file.exists("data.zip")) {
  download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip",
                "data.zip")
}

if (!file.exists("household_power_consumption.txt")) {
  unzip("data.zip")
}

# Reads data as a data frame
data <- read.table("household_power_consumption.txt", header = TRUE, sep = ";",
                   na.strings = "?", nrows = 2880, skip = 66636, 
                   colClasses = c(rep("character", times = 2),
                                  rep("numeric", times = 7 )))

colnames(data) <- unlist(read.table("household_power_consumption.txt",
                                    header = FALSE, sep = ";", nrows = 1,
                                    stringsAsFactors = FALSE))

# Merges time with date. Changes class to POSIXct and POSIxt.
data$Date <- paste(data$Date, data$Time)
data$Date <- dmy_hms(data$Date)

# Plots and exports as PNG file
png("plot4.png")
# Creates space for 4 plots. Filled row-wise.
par(mfrow = c(2, 2))

# Plot 1
with(data, plot(Date, Global_active_power, type = "l",
                xlab = NA, ylab = "Global Active Power"))

# Plot 2
with(data, plot(Date, Voltage, type = "l", xlab = "datetime"))

# Plot 3
with(data, plot(Date, Sub_metering_1, type = "l", xlab = NA, 
                ylab = "Energy sub metering"))
with(data, points(Date, Sub_metering_2, type = "l", col = "red"))
with(data, points(Date, Sub_metering_3, type = "l", col = "blue"))
legend("topright", legend = colnames(data)[7:9], 
       col = c("black", "red", "blue"), lty = 1)

# Plot 4
with(data, plot(Date, Global_reactive_power, type = "l", xlab = "datetime"))

dev.off()