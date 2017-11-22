library(ggplot2)
ggplot(Korea_PCod_Catch$Year, Korea_PCod_Catch$`Catch(MT)`)


g <- qplot(Year, `Catch(MT)`, data = Korea_PCod_Catch, geom="col") + 
  xlab("Year") + 
  ylab("Catch (MT)") +
  scale_fill_manual(values = "blue")

g
g+theme(axis.text = element_text(size = 16), axis.title = element_text(size = 22,face = "bold"))+scale_x_continuous(expand=c(0,0), breaks = seq(1925,2015,10)) + scale_y_continuous(expand=c(0,0)) + theme(plot.margin=unit(c(1,1,.5,.5),"cm"))
                                                                                                                                                                                        