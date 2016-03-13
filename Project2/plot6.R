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

# Subsets Baltimore City data for emissions from motor vehicle sources
ba <- subset(data, fips == "24510")
ba <- ba[which(ba$SCC %in% SCC), ]
# Calculates yearly total emission in tons
ba <- tapply(ba$Emissions, ba$year, sum, na.rm = TRUE)

# Subsets Los Angeles County data for emissions from motor vehicle sources
la <- subset(data, fips == "06037")
la <- la[which(la$SCC %in% SCC), ]
# Calculates yearly total emission in tons
la <- tapply(la$Emissions, la$year, sum, na.rm = TRUE)

# Plots data
png("plot6.png", 960, 480 )
par(mfrow = c(1, 2))
bp.ba <- barplot(ba, 
                 xlab = "Baltimore City, Maryland", 
                 ylab = expression("Total PM"[2.5]*" / ton"), 
                 ylim = c(0, 1.1*max(la)))
text(x = bp.ba, y = ba, labels = round(ba), pos = 3)
bp.la <- barplot(la, 
                 xlab = "Los Angeles County", 
                 ylab = expression("Total PM"[2.5]*" / ton"), 
                 ylim = c(0, 1.1*max(la)))
text(x = bp.la, y = la, labels = round(la), pos = 3)
mtext(expression("Total PM"[2.5]*" Emission from Motor Vehicle Sources"), 
      side = 3, line = -2, outer = TRUE, cex = 1.5)
dev.off()