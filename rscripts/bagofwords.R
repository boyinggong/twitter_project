#nlp word of bags
library(dplyr)
# library(stringr)
# python_liststring_to_rstring <- function(python_list_string){
#    # str_replace_all(python_list_string, "\'|\\[|\\]|,", "")
#    str_replace_all(python_list_string, "\\[", "")
# }
# ct_agg_tweetwords <- combined_timelines %>%
#    #head() %>% 
#    # mutate(. ,tweet_NLP_processTweet2 = python_liststring_to_rstring(tweet_NLP_processTweet)) %>% 
#   group_by(GENDER_FLAG) %>% 
#   summarise(., newvar = str_c(tweet_NLP_processTweet, collapse = " "))
# 
# male=data.frame(sort(table(str_split(string = ct_agg_tweetwords[2, 2], pattern = " ")), decreasing = TRUE)[1:10])
# female=data.frame(sort(table(str_split(string = ct_agg_tweetwords[3, 2], pattern = " ")), decreasing = TRUE)[1:10])
# 
# df=data.frame('rank'=1:10)
# df['male top words']=row.names.data.frame(male)
# df['male count']=male
# df['female top words']=row.names.data.frame(female)
# df['female count']=female

JH_word_of_bag=function(combined_timelines){
  ct_agg_tweetwords <- combined_timelines %>%
    #head() %>% 
    # mutate(. ,tweet_NLP_processTweet2 = python_liststring_to_rstring(tweet_NLP_processTweet)) %>% 
    group_by(GENDER_FLAG) %>% 
    summarise(., newvar = str_c(tweet_NLP_processTweet, collapse = " "))
  
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
