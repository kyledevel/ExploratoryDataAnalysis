# This script creates plot1.png

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

# Plots and exports as PNG file
png("plot1.png")
with(data, hist(Global_active_power, xlab = "Global Active Power (kilowatts)",
                col = "red", main = "Global Active Power"))
dev.off()