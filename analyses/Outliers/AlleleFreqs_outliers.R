outliers <- read_delim("D:/Pacific cod/DataAnalysis/PCod-Korea-repo/results/verif/Outliers_AlleleFreqs_Regions.txt", "\t", escape_double = FALSE, trim_ws = TRUE)


ggplot(outliers, aes(x=Population, y=Allele_Freq)) +
  geom_col(position="stack", aes(fill=Allele)) +
  facet_wrap(~Locus) +
  ylab("Allele Frequency") +
  theme(axis.text.y=element_text(size = 14), axis.title.y = element_text(size = 14), axis.text.x = element_text(size=14), axis.title.x = element_text(size = 14), strip.text = element_text(size=14)) + 
  theme(legend.title=element_blank(), legend.text=element_blank())
