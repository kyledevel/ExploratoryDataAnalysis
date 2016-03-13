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

# Reads data and classification code
data <- readRDS("summarySCC_PM25.rds")
code <- readRDS("Source_Classification_Code.rds")

# Gets SCC codes for emissions from motor vehicle sources
SCC <- code[grep("Vehicle", code$EI.Sector), "SCC"]

# Subsets data for Baltimore City
data <- subset(data, fips == "24510")
# Subsets Baltimore City data for emissions from motor vehicle sources
data <- data[which(data$SCC %in% SCC), ]

# Calculates yearly total emission in tons
total.year <- tapply(data$Emissions, data$year, sum, na.rm = TRUE)

# Plots data
png("plot5.png")
bp <- barplot(total.year, 
              main = bquote(atop("Total PM"[2.5]*" Emission from Motor Vehicle Sources",
                                 "in Baltimore City, Maryland")),
              xlab = "Year", 
              ylab = expression("Total PM"[2.5]*" / ton"), 
              ylim = c(0, 1.1*max(total.year)))
text(x = bp, y = total.year, labels = round(total.year), pos = 3)
dev.off()