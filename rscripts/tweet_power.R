#twitter power analysis
#read in the csv
source('./read_data.R')

people.list=nominees_metadata$TWITTER_SCREEN_NAME[as.logical(nominees_metadata$PERSON_FLAG)]
people.createdat=rep('',length(people.list))
people.index=rep(0,length(people.list))
for (i in 1:length(people.list)){
  people.index[i]=which(combined_timelines$tweet_user_screen_name==people.list[i])[1]
  people.createdat[i]=combined_timelines[people.index[i],]$tweet_user_created_at
}
people.list=people.list[!is.na(people.createdat)]
people.index=people.index[!is.na(people.createdat)]
people.createdat=people.createdat[!is.na(people.createdat)]

people=data.frame('list'=people.list)
people$index=people.index
people$createdat=people.createdat

people$followers=as.integer(combined_timelines[people$index,]$tweet_user_followers_count)
people$datetime=strptime(people$createdat,'%a %b %d %H:%M:%S %z %Y')
current.time=Sys.time()
people$ttenure=rep(0,length(people$list))
for (i in 1:length(people$datetime)){
  people$ttenure[i]=floor((Sys.time()-people$datetime)[[i]])
}
people$tweetscount=combined_timelines[people$index,]$tweet_user_statuses_count
#plot(people.ttenure,log(people.followers/people.tweetscount))
people$power=log(people$followers/people$tweetscount)
tenure.splitup=mean(c(max(people$ttenure),min(people$ttenure)))
#power.splitup=mean(c(max(people$power),min(people$power)))
power.splitup=4.9


people$name=combined_timelines[people$index,]$tweet_user_name

#people=data.frame(people.power,people.ttenure,people.name)
people$tenuresplit=(people$ttenure<=tenure.splitup)
people$powersplit=(people$power<=power.splitup)

#age #winner #gender #TV/FILM
people$male=combined_timelines[people$index,]$GENDER_FLAG=='M'
people$female=combined_timelines[people$index,]$GENDER_FLAG=='F'
people$winner=combined_timelines[people$index,]$WINNER_FLAG=='W'
people$loser=combined_timelines[people$index,]$WINNER_FLAG=='L'
people$gender=combined_timelines[people$index,]$GENDER_FLAG
people$winlose=combined_timelines[people$index,]$WINNER_FLAG
people$TVFILM=combined_timelines[people$index,]$FILM_FLAG

people$factor=rep('',length(people$index))
people$factor[as.logical(people$tenuresplit*people$powersplit)]='Young and Weak'
people$factor[as.logical((1-people$tenuresplit)*people$powersplit)]='Old and Weak'
people$factor[as.logical((people$tenuresplit)*(1-people$powersplit))]='Young and Powerful'
people$factor[as.logical((1-people$tenuresplit)*(1-people$powersplit))]='Old and Powerful'

people$age=combined_timelines[people$index,]$ACTOR_AGE

library(ggplot2)
dotplotspower=ggplot(people, aes(ttenure, power))+geom_point(aes(colour = factor(factor)), size = 4)
dotplotspower

#create profile plot
profile=data.frame('group'=rep(c('Old and Weak','Young and Powerful'),6))
profile$type=c('age','age','male','male','female','female','winner','winner','tv','tv','film','film')
profile$value=c(
  mean(people$age[as.logical((1-people$tenuresplit)*(people$powersplit))])/100,
  mean(people$age[as.logical((people$tenuresplit)*(1-people$powersplit))])/100,
  mean(people$male[as.logical((1-people$tenuresplit)*(people$powersplit))]),
  mean(people$male[as.logical((people$tenuresplit)*(1-people$powersplit))]),
  mean(people$female[as.logical((1-people$tenuresplit)*(people$powersplit))]),
  mean(people$female[as.logical((people$tenuresplit)*(1-people$powersplit))]),
  mean(people$winner[as.logical((1-people$tenuresplit)*(people$powersplit))]),
  mean(people$winner[as.logical((people$tenuresplit)*(1-people$powersplit))]),
  mean((1-people$TVFILM)[as.logical((1-people$tenuresplit)*(people$powersplit))]),
  mean((1-people$TVFILM)[as.logical((people$tenuresplit)*(1-people$powersplit))]),
  mean(people$TVFILM[as.logical((1-people$tenuresplit)*(people$powersplit))]),
  mean(people$TVFILM[as.logical((people$tenuresplit)*(1-people$powersplit))])
)

profileplot=ggplot(profile,aes(x=as.factor(type),y=value,fill=as.factor(group)))+geom_bar(position = position_dodge(),stat = 'identity')+coord_flip()+scale_fill_manual(values=c("blue1", "red1"))
profileplot
