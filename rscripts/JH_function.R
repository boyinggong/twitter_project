#JH's function source code

###########################################
#Load In Packages
###########################################
#source('./read_data.R')
#install.packages('ggplot2')
#install.packages('grid')
#install.packages('gridExtra')
#library(ggplot2)
#library(grid)
#library(gridExtra)

###########################################
#Function 1: manipulate dataframe
###########################################
JH_dataframe_addcolumn=function(combined_timelines){
  x=strptime(combined_timelines$tweet_created_at,'%a %b %d %H:%M:%S %z %Y')
  combined_timelines$weekday=format(x,'%a')
  combined_timelines$hour=as.integer(format(x,'%H'))
  combined_timelines$is.weekend=as.logical((combined_timelines$weekday=='Sun')+(combined_timelines$weekday=='Sat'))
  combined_timelines$is.midnight=as.logical(combined_timelines$hour<6)
  combined_timelines$is.morning=as.logical((combined_timelines$hour<12)-(combined_timelines$hour<6))
  combined_timelines$is.afternoon=as.logical((combined_timelines$hour<18)-(combined_timelines$hour<12))
  combined_timelines$is.evening=as.logical((combined_timelines$hour<24)-(combined_timelines$hour<18))
  combined_timelines$is.female=(combined_timelines$GENDER_FLAG=='F')
  combined_timelines$is.male=(combined_timelines$GENDER_FLAG=='M')
  combined_timelines$is.45=as.logical(combined_timelines$ACTOR_AGE<45)
  combined_timelines$is.90=as.logical((combined_timelines$ACTOR_AGE<90)-(combined_timelines$ACTOR_AGE<45))
  return(combined_timelines)
}

###########################################
#Function 2: heatmap dataframe generation
###########################################
JH_heatmap_df_generation=function(combined_timelines){
  heatmap.df=data.frame(combined_timelines$weekday,combined_timelines$hour)
  colnames(heatmap.df)=c('DoW','Hour')
  heatmap.df['count']=rep(1,length((heatmap.df$DoW)))
  agg.heat <-aggregate(count~DoW+Hour,heatmap.df,sum)
  #fill in the blanks as NA
#   DoWlist=c("Mon",'Tue','Wed','Thu','Fri','Sat','Sun')
#   hourlist=0:23
#   for (i in DoWlist){
#     for (j in hourlist){
#       if (sum(agg.heatfe$DoW==i&agg.heatfe$Hour==j)==0)
#         
#     }
#   }
  return(agg.heat)
}

###########################################
#Function 3: heatmap plot
###########################################
JH_heatmap_plot=function(agg.heat,lowcar = "blue",highcar = "red1"){
  #heatmap full version
  heat_map=ggplot(agg.heat, aes(DoW, Hour)) +
    geom_tile(aes(fill = count),color='white')+ scale_fill_continuous(low = lowcar,high = highcar,na.value = 'grey') + 
    ylab("Day of the week") + 
    xlab("Hour of the day") + 
    theme(axis.text.y = element_text(angle = 00, hjust = 1, size=15,color="black")) +
    theme(axis.text.x = element_text(angle = 00, hjust = 1, size=15,color="black")) +
    theme(plot.title = element_text(lineheight=3, face="bold",color="black", size=29)) +
    theme(axis.title.y = element_text(size = rel(1.8), angle = 90)) +
    theme(axis.title.x = element_text(size = rel(1.8), angle = 00)) +
    theme_bw()+
    theme(axis.line = element_blank(),
          panel.grid.major = element_blank(),
          panel.grid.minor = element_blank(),
          panel.border = element_blank(),
          panel.background = element_blank())+
    scale_x_discrete(limits=c("Mon",'Tue','Wed','Thu','Fri','Sat','Sun'))
  
  return(heat_map)
}

###########################################
#Function 4: people dataframe generation
###########################################
JH_tweet_power_df_generation=function(combined_timelines,nominees_metadata){
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
  people$ttenure=people$ttenure/365
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
  
  people$age45=combined_timelines[people$index,]$is.45
  people$age90=combined_timelines[people$index,]$is.90
  return(people)
}

###########################################
#Function 5: scatter plot
###########################################
JH_tweet_power_scatter_plot=function(people){
  tenure.splitup=mean(c(max(people$ttenure),min(people$ttenure)))
  power.splitup=4.9
  dotplotspower=ggplot(people, aes(ttenure, power)) + 
    geom_point(aes(colour = factor(factor)), size = 4) + 
    geom_vline(xintercept = tenure.splitup,color='red') + 
    geom_hline(yintercept = 4.9,color='red') + 
    ggtitle("Scatter Plot for Tweet Influence VS Tweeter Tenure") +
    ylab("Tweet Influence") + 
    xlab("Tweeter Tenure") + 
    theme(axis.text.x = element_text(angle = 00, hjust = 1, size=15,color="black")) +
    theme(axis.text.y = element_text(angle = 00, hjust = 1, size=15,color="black")) +
    theme(plot.title = element_text(lineheight=3, face="bold",color="black", size=29)) +
    theme(axis.title.y = element_text(size = rel(1.8), angle = 90)) +
    theme(axis.title.x = element_text(size = rel(1.8), angle = 00)) + 
    #theme_bw()+
    #theme(#axis.line = element_blank(),
          #panel.grid.major = element_blank(),
          #panel.grid.minor = element_blank()#,
          #panel.border = element_blank(),
          #panel.background = element_blank()
    #      ) + 
    scale_color_manual('Grouping',values = c('indianred1','#599ad3','#f9a65a','pink'))
  
  return(dotplotspower)
}

###########################################
#Function 6: profile plot
###########################################
JH_tweet_power_profile_plot=function(people){
  profile=data.frame('group'=rep(c('Old and Weak','Young and Powerful'),5))
  profile$type=c('female','female','winner','winner','tv','tv',"age 0-45","age 0-45",'age 45-90','age 45-90')
  profile$value=c(
    mean(people$female[as.logical((1-people$tenuresplit)*(people$powersplit))]),
    mean(people$female[as.logical((people$tenuresplit)*(1-people$powersplit))]),
    mean(people$winner[as.logical((1-people$tenuresplit)*(people$powersplit))]),
    mean(people$winner[as.logical((people$tenuresplit)*(1-people$powersplit))]),
    mean((1-people$TVFILM)[as.logical((1-people$tenuresplit)*(people$powersplit))]),
    mean((1-people$TVFILM)[as.logical((people$tenuresplit)*(1-people$powersplit))]),
    #age band
    mean(people$age45[as.logical((1-people$tenuresplit)*(people$powersplit))]),
    mean(people$age45[as.logical((people$tenuresplit)*(1-people$powersplit))]),
    mean(people$age90[as.logical((1-people$tenuresplit)*(people$powersplit))]),
    mean(people$age90[as.logical((people$tenuresplit)*(1-people$powersplit))])
  )
  
  profileplot=ggplot(profile,aes(x=as.factor(type),y=value,fill=as.factor(group)))+
    geom_bar(position = position_dodge(),stat = 'identity')+
    coord_flip()+
    scale_fill_manual('Grouping',values=c("#599ad3", "#f9a65a")) + 
    ggtitle("Profile Plot") +
    ylab("Proportion in Each Group") + 
    xlab("Categories of Interest") + 
    theme(axis.text.x = element_text(angle = 00, hjust = 1, size=15,color="black")) +
    theme(axis.text.y = element_text(angle = 00, hjust = 1, size=15,color="black")) +
    theme(plot.title = element_text(lineheight=3, face="bold",color="black", size=29)) +
    theme(axis.title.y = element_text(size = rel(1.8), angle = 90)) +
    theme(axis.title.x = element_text(size = rel(1.8), angle = 00)) #+ 
#     theme_bw()+
#     theme(#axis.line = element_blank(),
#           panel.grid.major = element_blank(),
#           panel.grid.minor = element_blank(),
#           #panel.border = element_blank(),
#           panel.background = element_blank())#+
#     #scale_x_discrete(limits=c("winner",'tv','female','age 0-30','age 30-60','age 60-90'))

  return(profileplot)
}
