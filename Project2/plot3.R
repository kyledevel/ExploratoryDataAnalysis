require(ggplot2)

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

# Plots data
png("plot3.png")
print(
  ggplot(data,aes(factor(year), Emissions / 1000)) + # Emission in kilotons
    geom_bar(stat = "identity") +
    facet_wrap(~ type, nrow = 2) +
    xlab("Year") +
    ylab(expression("Total PM"[2.5]*" / kiloton")) +
    ggtitle(expression("Total PM"[2.5]*
                       " Emission in Baltimore City, Maryland by Source Type"))
)
dev.off()