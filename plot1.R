fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
zipFileName <- "household_power_consumption.zip"
FileName <- "household_power_consumption.txt"
dataDir <- "ExploratyDataAnalysisData"
fullZipFileName <- file.path(getwd(),dataDir,zipFileName)

if (!file.exists(dataDir)) {
  message("Directory not found, creating it.")
  dir.create(file.path(getwd(), dataDir))
} else {
  message("Directory found")
  message(dir(dataDir))
}

if (!file.exists(fullZipFileName)) {
  download.file(fileUrl,fullZipFileName)
}
if (file.exists(fullZipFileName)) {
  if (!file.exists(file.path(getwd(),dataDir,FileName))) {
    unzip(fullZipFileName,exdir = file.path(getwd(),dataDir))
  }
}

if (file.exists(file.path(getwd(),dataDir,FileName))) {
  message("datafile ", file.path(getwd(),dataDir,FileName), " found.")
}

library(data.table)
DT0 <- fread(file.path(getwd(),dataDir,FileName),na.strings = "?") #,nrows=10)
DT <- DT0[which(DT0$Date=="1/2/2007" | DT0$Date=="2/2/2007"),]

DT[,DATETIME:={as.POSIXct(strptime(paste(DT$Date,DT$Time),format="%d/%m/%Y %H:%M:%S"))}]

#par(mar=c(5,5,5,5))
par(op)
dev.size("px")
par(pty="s",oma=c(1,1,1,1)) #,din=c(480,480),
Sys.setlocale("LC_TIME", "us")
cex_lab <- 0.7
hist(as.numeric(DT$Global_active_power),
     xlab="Global Active Power (kilowatts)",
     main="Global Active Power",
     col="red",
     cex.axis=cex_lab,
     cex.lab=cex_lab,
     cex.main=cex_lab
)
dev.copy(png,file="plot1.png")
dev.off()