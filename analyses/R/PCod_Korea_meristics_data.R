library(readr)
pohang <- read_delim("D:/Pacific cod/DataAnalysis/PCod-Korea-repo/analyses/Meristics/pohang.txt",
"\t", escape_double = FALSE, trim_ws = TRUE)
View(pohang)

hist(pohang$`TL(cm)`, main = "Total Length (Pohang)", xlab = "Length (cm)")
hist(pohang$GW, main = "Gonad Weight (Pohang)", xlab = "Weight (units)")
hist(pohang$`BW(g)`, main = "Body Weight (Pohang)", xlab = "Weight (units)")


library(readr)
south_14_15 <- read_delim("D:/Pacific cod/DataAnalysis/PCod-Korea-repo/analyses/Meristics/south_14_15.txt",
"\t", escape_double = FALSE, trim_ws = TRUE)
View(south_14_15)

south_14_15$`TL(cm)`[south_14_15$`TL(cm)` == "-"] <- NA
south_14_15$GW[south_14_15$GW == "-"] <- NA 
for(i in range(1,length(south_14_15$GW))){
  if(is.na(south_14_15$GW[i]) == FALSE){
    south_14_15$GW[i] <- as.numeric(south_14_15$GW[i])
  } else {
    south_14_15$GW[i] <- 0
  }
}

south_14_15$GW[49] <- as.numeric(south_14_15$GW[49])
south_14_15$GW[49]

hist(south_14_15$`TL(cm)`, main = "Total Length (South)", xlab = "Length (cm)")
hist(south_14_15$GW, main = "Gonad Weight (South)", xlab = "Weight (units)")
hist(south_14_15$`BW(g)`, main = "Body Weight (South)", xlab = "Weight (units)")

typeof(south_14_15$GW[50])
