#setwd("H:/r/Projects/GitHubTest/")

install.packages("likert")
library("likert")
demo('likert', package='likert')

devtools::install_github('jbryer/likert')
library("likert")
likert::likert.bar.plot


p<-plot(l24)
p +
  scale_fill_manual(values=c("blue", "red", "yellow", "green")) + 
  labs(fill="", title="This is a test.") +
  theme(plot.background = element_rect(fill="gray80"),
        panel.grid=element_blank(), 
        panel.background = element_rect(fill="white"),
        axis.text=element_text(face="italic"),
        legend.background = element_rect(fill=NA),
        legend.key=element_rect(fill=NA, color=NA)
        ) 
    
xtable(l24)
summary(l24)
l29
