setwd("D:/Pacific cod/DataAnalysis/PCod-Korea-repo/pipeline_analyses")
readsVtags_all_meta <- read_delim("D:/Pacific cod/DataAnalysis/PCod-Korea-repo/readsVtags_all_meta.txt",
"\t", escape_double = FALSE, trim_ws = TRUE)
View(readsVtags_all_meta)


sample_codes <- readsVtags_all_meta$Group
colors <- c()
for(i in sample_codes){
  if(i == "deg"){
    colors <- c(colors,"darkgoldenrod")
  } 
  else if(i == "contam"){
    colors <- c(colors,"firebrick")
  }
  else if(i == "pcontam"){
    colors <- c(colors,"coral2")
  }
  else if(i == "reg"){
    colors <- c(colors,"darkblue")
  }
  else if(i == "combo"){
    colors <- c(colors,"darkcyan")
  }
  else if(i == "ak"){
    colors <- c(colors,"gray45")
  }
  
}

points = c()
for(i in sample_codes){
  if(i == "reg"){
    points <- c(points,1)
  } 
  else {
    points <- c(points,19)
  }
}


################# plotting number of reads by population ###################
x <- readsVtags_all_meta$Pop_Code
y <- readsVtags_all_meta$n_reads/1000000

plot(x,y, main = "Number of Reads per Sample (Fastq)", xlab = "Population", ylab= "# Reads (x 1 mill)", col=alpha(colors, 0.75), pch = points, xaxt = "n", yaxt = "n", ylim = c(0, 18), cex = 1.5)
axis(1, at = seq(1,10, by=1), labels = c("YS", "BOR", "GE15", "GE14", "NAM", "JBE", "JBL", "POH", "JUK", "UP"))
axis(2, at = seq(0, 18, by = 1))
abline(v = c(1,2,3,4,5,6,7,8,9,10), col = "gray", lty = 3)
legend("topleft", legend = c("reg", "combo", "contam", "pcontam", "part deg", "alaska"), col = c("darkblue", "darkcyan", "firebrick", "coral2", "darkgoldenrod", "gray45"), pch = 19)
?legend




################# plotting number of loci by population ###################
x <- readsVtags_all_meta$Pop_Code
y <- readsVtags_all_meta$n_tags/1000

plot(x,y, main = "Number of Tags per Sample (ustacks)", xlab = "Population", ylab= "# tags (x 1000)", col=alpha(colors, 0.75), pch = points, xaxt = "n", , yaxt = "n", cex = 1.5)
axis(1, at = seq(1,10, by=1), labels = c("YS", "BOR", "GE15", "GE14", "NAM", "JBE", "JBL", "POH", "JUK", "UP"))
axis(2, at = seq(0, 150, by = 25))
abline(v = c(1,2,3,4,5,6,7,8,9,10), col = "gray", lty = 3)
legend(x = 5, y = 150, legend = c("reg", "combo", "contam", "pcontam", "part deg", "alaska"), col = c("darkblue", "darkcyan", "firebrick", "coral2", "darkgoldenrod", "gray45"), pch = 19)





################# plotting number of reads v. number of loci ###################
x <- readsVtags_all_meta$n_reads/1000000
y <- readsVtags_all_meta$n_tags/1000

plot(x,y, main = "Number of Reads v. Number of Tags", xlab = "# Reads (x 1mill)", ylab= "# tags (x 1000)", col=alpha(colors, 0.75), pch = points, cex = 1.5, xlim = c(0,18), xaxt = "n", yaxt = "n")
axis(1, at = seq(0,18, by=1))
axis(2, at = seq(0, 150, by = 25))
legend("topright", legend = c("reg", "combo", "contam", "pcontam", "part deg", "alaska"), col = c("darkblue", "darkcyan", "firebrick", "coral2", "darkgoldenrod", "gray45"), pch = 19)





############# comparing the new lane 5 samples to all other samples ###############


readsVtags_all_meta <- read_delim("D:/Pacific cod/DataAnalysis/PCod-Korea-repo/readsVtags_all_meta.txt", "\t", escape_double = FALSE, trim_ws = TRUE)
View(readsVtags_all_meta)



lanes <- readsVtags_all_meta$lane
colors2 = c()
for(i in lanes){
  if(i == 5){
    colors2 <- c(colors2,"darkcyan")
  } 
  else {
    colors2 <- c(colors2,"gray45")
  }
}

x <- readsVtags_all_meta$n_reads/1000000
y <- readsVtags_all_meta$n_tags/1000

plot(x,y, main = "Number of Reads v. Number of Tags", xlab = "# Reads (x 1mill)", ylab= "# tags (x 1000)", col=alpha(colors2, 0.75), pch = 19, cex = 1.5, xlim = c(0,18), xaxt = "n", yaxt = "n")
axis(1, at = seq(0,18, by=1))
axis(2, at = seq(0, 150, by = 25))
legend("topright", legend = c("new sample", "existing sample"), col = c("darkcyan","gray45"), pch = 19)








################# with ggplot instead #########################

install.packages("ggplot2")

library(ggplot2)

read_data <- cbind(x,y)
head(read_data)

qplot(x,y, color = readsVtags_all_meta$Group, alpha = 0.7, size = 0.5, xlab = "Population", ylab = "# Reads") + xlim(c(0,10))
