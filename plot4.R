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
par(mfrow=c(2,2),oma=c(2,3,0,2), mar=c(4,4,2,1))
plot(DT$DATETIME,DT$Global_active_power,type="l",xlab="",ylab="Global Active Power",cex.lab=cex_lab,cex.axis=cex_lab)

plot(DT$DATETIME,DT$Voltage,type="l",ylab="Voltage",xlab="datetime",cex.lab=cex_lab,cex.axis=cex_lab)

Sys.setlocale("LC_TIME", "us")
leg.txt <- c("Sub_metering_1   ","Sub_metering_2   ","Sub_metering_3   ")
#legend("topright", leg.txt, cex=0.4, box.lty = 0, adj=0.1, col=c("black","red","blue"), lty = 1)
plot(DT$DATETIME,DT$Sub_metering_1,type="l", xlab="",ylab="Energy sub metering"
     ,cex.lab=cex_lab,cex.axis=cex_lab)
points(DT$DATETIME,DT$Sub_metering_2,col="red",type="l")
points(DT$DATETIME,DT$Sub_metering_3,col="blue",type="l")
legend("topright", leg.txt, cex=0.5, bty = "n", inset=0.01, col=c("black","red","blue"), lty = 1)

plot(DT$DATETIME,DT$Global_reactive_power,type="l",xlab="datetime",ylab="Global_reactive_power"
     ,cex.lab=cex_lab,cex.axis=cex_lab)
dev.copy(png,file="plot4.png")
dev.off()