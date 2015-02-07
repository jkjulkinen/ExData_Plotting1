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


par(op)
dev.size("px")
cex_lab <- 0.7
par(pty="s") #,din=c(480,480))
Sys.setlocale("LC_TIME", "us")
plot(DT$DATETIME,DT$Global_active_power,type="l",xlab="",ylab="Global Active Power (kilowatts)",
     cex.axis=cex_lab,
     cex.lab=cex_lab,
     cex.main=cex_lab)
dev.copy(png,file="plot2.png")
dev.off()