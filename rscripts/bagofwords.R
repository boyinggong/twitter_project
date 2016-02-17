#nlp bag of words
library(dplyr)
JH_word_of_bag_POST=function(combined_timelines){
  ct_agg_tweetwords <- combined_timelines %>% distinct(GENDER_FLAG, tweet_user_screen_name, tweet_NLP_remove_stopwords) %>% 
    filter(pre_post_during_flag == "post") %>%
    group_by(GENDER_FLAG) %>% 
    summarise(., newvar = str_c(tweet_NLP_remove_stopwords, collapse = " "))
  
  male.index=(1:4)[ct_agg_tweetwords[,1]=='M']
  male.index=male.index[!is.na(male.index)]
  female.index=(1:4)[ct_agg_tweetwords[,1]=='F']
  female.index=female.index[!is.na(female.index)]
  
  male=data.frame(sort(table(str_split(string = ct_agg_tweetwords[male.index, 2], pattern = " ")), decreasing = TRUE)[1:10])
  female=data.frame(sort(table(str_split(string = ct_agg_tweetwords[female.index, 2], pattern = " ")), decreasing = TRUE)[1:10])
  
  df=data.frame('rank'=1:10)
  df['male top words']=row.names.data.frame(male)
  df['male count']=male
  df['female top words']=row.names.data.frame(female)
  df['female count']=female
  return(df)
}


JH_word_of_bag_DURING=function(combined_timelines){
  ct_agg_tweetwords <- combined_timelines %>% distinct(GENDER_FLAG, tweet_user_screen_name, tweet_NLP_remove_stopwords) %>% 
    filter(pre_post_during_flag == "during") %>%
    group_by(GENDER_FLAG) %>% 
    summarise(., newvar = str_c(tweet_NLP_remove_stopwords, collapse = " "))
  
  male.index=(1:4)[ct_agg_tweetwords[,1]=='M']
  male.index=male.index[!is.na(male.index)]
  female.index=(1:4)[ct_agg_tweetwords[,1]=='F']
  female.index=female.index[!is.na(female.index)]
  
  male=data.frame(sort(table(str_split(string = ct_agg_tweetwords[male.index, 2], pattern = " ")), decreasing = TRUE)[1:10])
  female=data.frame(sort(table(str_split(string = ct_agg_tweetwords[female.index, 2], pattern = " ")), decreasing = TRUE)[1:10])
  
  df=data.frame('rank'=1:10)
  df['male top words']=row.names.data.frame(male)
  df['male count']=male
  df['female top words']=row.names.data.frame(female)
  df['female count']=female
  return(df)
}


JH_word_of_bag_PRE=function(combined_timelines){
  ct_agg_tweetwords <- combined_timelines %>% distinct(GENDER_FLAG, tweet_user_screen_name, tweet_NLP_remove_stopwords) %>% 
    filter(pre_post_during_flag == "pre") %>%
    group_by(GENDER_FLAG) %>% 
    summarise(., newvar = str_c(tweet_NLP_remove_stopwords, collapse = " "))
  
  male.index=(1:4)[ct_agg_tweetwords[,1]=='M']
  male.index=male.index[!is.na(male.index)]
  female.index=(1:4)[ct_agg_tweetwords[,1]=='F']
  female.index=female.index[!is.na(female.index)]
  
  male=data.frame(sort(table(str_split(string = ct_agg_tweetwords[male.index, 2], pattern = " ")), decreasing = TRUE)[1:10])
  female=data.frame(sort(table(str_split(string = ct_agg_tweetwords[female.index, 2], pattern = " ")), decreasing = TRUE)[1:10])
  
  df=data.frame('rank'=1:10)
  df['male top words']=row.names.data.frame(male)
  df['male count']=male
  df['female top words']=row.names.data.frame(female)
  df['female count']=female
  return(df)
}

