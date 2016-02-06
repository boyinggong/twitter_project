#read in the csv
source('./read_data.R')
#"Sun Jan 31 08:25:12 +0000 2016"
x=strptime(combined_timelines$tweet_created_at_datetime_offset,'%a %b %d %H:%M:%S %z %Y')

combined_timelines$weekday=format(x,'%u%a')
combined_timelines$hour=as.integer(format(x,'%H'))

#library(dplyr)

#timelines %>%
#  group_by(weekday, hour) %>%
#  summarise(avg = mean(tweet_user_statuses_count)) %>%
#  arrange(avg)



combined_timelines$is.weekend=as.logical((combined_timelines$weekday=='7Sun')+(combined_timelines$weekday=='6Sat'))
combined_timelines$is.midnight=as.logical(combined_timelines$hour<6)
combined_timelines$is.morning=as.logical((combined_timelines$hour<12)-(combined_timelines$hour<6))
combined_timelines$is.afternoon=as.logical((combined_timelines$hour<18)-(combined_timelines$hour<12))
combined_timelines$is.evening=as.logical((combined_timelines$hour<24)-(combined_timelines$hour<18))

heatmap.df=data_frame(combined_timelines$weekday,combined_timelines$hour)
colnames(heatmap.df)=c('DoW','Hour')
heatmap.df['count']=rep(1,length((heatmap.df$DoW)))


agg.heat <-aggregate(count~DoW+Hour,heatmap.df,sum)



library(ggplot2)
#heatmap full version
full_heat_map=ggplot(agg.heat, aes(Hour, DoW)) +
  geom_tile(aes(fill = count),color='white')+ scale_fill_continuous(low = "blue",high = "red1")

#weekend heatmap
heatmap.df.weekend=heatmap.df[combined_timelines$is.weekend,]
colnames(heatmap.df.weekend)=c('DoW','Hour')
heatmap.df.weekend['count']=rep(1,length((heatmap.df.weekend$DoW)))

agg.heat.weekend <-aggregate(count~DoW+Hour,heatmap.df.weekend,sum)
weekend_heatmap=ggplot(agg.heat.weekend, aes(Hour, DoW)) +
  geom_tile(aes(fill = count),color='white')+ scale_fill_continuous(low = "blue",high = "red1")
weekend_heatmap

#weekday heatmap
heatmap.df.weekday=heatmap.df[!combined_timelines$is.weekend,]
colnames(heatmap.df.weekday)=c('DoW','Hour')
heatmap.df.weekday['count']=rep(1,length((heatmap.df.weekday$DoW)))

agg.heat.weekday <-aggregate(count~DoW+Hour,heatmap.df.weekday,sum)
weekday_heatmap=ggplot(agg.heat.weekday, aes(Hour, DoW)) +
  geom_tile(aes(fill = count),color='white')+ scale_fill_continuous(low = "blue",high = "red1")
weekday_heatmap

