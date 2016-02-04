library("ggplot2")
library("plotflow")

################# mention stat #################

mentioned <- read.csv("mention.csv", stringsAsFactors = TRUE)
mentioned$winner[which(mentioned$winner == 1)] = "win"
mentioned$winner[which(mentioned$winner == 0)] = "loss"

mentioned$name2 <- reorder(mentioned$name, mentioned$frequencies)

png("mention_bar.png", width=640,height=400)
ggplot(mentioned, aes(x=name, y=frequencies, fill=winner)) + 
  geom_bar(aes(x=name2), data = mentioned, stat='identity') + 
  theme(axis.text.x  = element_text(angle = 90, hjust = 1)) +
  scale_fill_manual(values=c("grey50", "red")) +
  coord_flip()
dev.off()

################# domain stat #################

domains_stat <- read.csv("domains.csv", stringsAsFactors = TRUE)
domains_stat <- domains_stat[1:30, ]
domains_stat$logfrequencies <- log(domains_stat$frequencies)
domains_stat$domain1 <-  reorder(domains_stat$domain, domains_stat$frequencies)

ggplot(domains_stat, aes(x=domain, y=frequencies)) + 
  geom_bar(aes(x=domain1), data = domains_stat, stat='identity') + 
  theme(axis.text.x  = element_text(angle = 90, hjust = 1)) +
  coord_flip()

library(MASS) # to access Animals data sets
library(scales) # to access break formatting functions

png("domain_bar.png", width=640,height=400)
ggplot(domains_stat, aes(x=domain, y=frequencies)) + 
  geom_bar(aes(x=domain1), data = domains_stat, stat='identity') + 
  theme(axis.text.x  = element_text(angle = 90, hjust = 1)) +
  scale_y_sqrt(breaks = trans_breaks("sqrt", function(x) x^2),
               labels = trans_format("sqrt", math_format(.x^2))) +
  coord_flip()
dev.off()

################# wordcloud #################

domains_stat <- read.csv("domains.csv", stringsAsFactors = TRUE)
domains_stat <- domains_stat[1:100, ]

library(wordcloud)


# 8, "Dark2"
# 9, "BuGn"
# 8, "Set2"

library(RColorBrewer)
png("domain_wordcloud.png", width=1280,height=800)
wordcloud(words = domains_stat$domain, freq = log(domains_stat$frequencies), min.freq = 1,
          max.words=200, random.order=FALSE, rot.per=0,
          colors=brewer.pal(11, "BuGn"))
dev.off()

