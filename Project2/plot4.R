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

# Gets SCC codes for coal-combustion related sources
SCC <- code[grep("[Cc]omb.*[Cc]oal", code$Short.Name), "SCC"]

# Subsets data for coal-combustion related sources
data <- data[which(data$SCC %in% SCC), ]

# Calculates yearly total emission in kilotons
total.year <- tapply(data$Emissions, data$year, sum, na.rm = TRUE) / 1000

# Plots data
png("plot4.png")
bp <- barplot(total.year, 
              main = bquote(atop("Total PM"[2.5]*" Emission from Coal Combustion-Related Sources",
                                 "in the United States")),
              xlab = "Year", 
              ylab = expression("Total PM"[2.5]*" / kiloton"), 
              ylim = c(0, 1.1*max(total.year)))
text(x = bp, y = total.year, labels = round(total.year, 3), pos = 3)
dev.off()