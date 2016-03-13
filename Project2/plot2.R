# Checks for data files in working directory; downloads and extracts them if not
# present
if (!file.exists("Source_Classification_Code.rds") | 
    !file.exists("summarySCC_PM25.rds")) {
  
  if (!file.exists("exdata-data-NEI_data.zip")) {
    download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip",
                  "exdata-data-NEI_data.zip")
    unzip("exdata-data-NEI_data.zip")
    
  } else {
    unzip("exdata-data-NEI_data.zip")
    
  }
}

# Reads data for Baltimore City
data <- readRDS("summarySCC_PM25.rds")
data <- subset(data, fips == "24510")

# Calculates yearly total emission in kilotons
total.year <- tapply(data$Emissions, data$year, sum, na.rm = TRUE) / 1000

# Plots data
png("plot2.png")
bp <- barplot(total.year, 
              main = expression("Total PM"[2.5]*" Emission from All Sources in Baltimore City, Maryland"), 
              xlab = "Year", 
              ylab = expression("Total PM"[2.5]*" / kiloton"), 
              ylim = c(0, 1.1*max(total.year)))
text(x = bp, y = total.year, labels = round(total.year, 3), pos = 3)
dev.off()