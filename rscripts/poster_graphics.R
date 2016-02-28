#Slide Graphics Generation

source("./read_data.R")

###########################
# Graphics For JH
###########################

## TWO HEATMAPS ##
source("./JH_function.R")
combined_timelines=JH_dataframe_addcolumn(combined_timelines)
agg.heatoc=JH_heatmap_df_generation(
  combined_timelines[as.logical(1-(combined_timelines$is.female+combined_timelines$is.male)),]
)

agg.heatfe=JH_heatmap_df_generation(combined_timelines[combined_timelines$is.female,])
agg.heatma=JH_heatmap_df_generation(combined_timelines[combined_timelines$is.male,])
p1=JH_heatmap_plot(agg.heatfe,lowcar = 'blue',highcar = 'red')
p2=JH_heatmap_plot(agg.heatma,lowcar = 'blue',highcar = 'violetred')
g=arrangeGrob(p1 + ggtitle("Female Tweets Heatmap"),
             p2 + ggtitle("Male Tweets Heatmap"),
             nrow=1,
             name = textGrob("Heatmap For Tweet Density",
                            gp = gpar(fontsize=29))
             
)
ggsave(filename = "../poster_graphics/heatmap.png",
       plot = g, width = 23, height = 34, units = "cm")
## Profile Grouping ##
people=JH_tweet_power_df_generation(combined_timelines,nominees_metadata)
a=JH_tweet_power_scatter_plot(people)
ggsave(filename = "../poster_graphics/profile_group.png",
       plot = a, width = 30, height = 20, units = "cm")

## Profile Plot ##
c=JH_tweet_power_profile_plot(people)
ggsave(filename = "../poster_graphics/profile.png",
       plot = c, width = 30, height = 20, units = "cm")


###########################
# Graphics For GH
###########################


###########################
# Graphics For PS
###########################


###########################
# Graphics For TO
###########################