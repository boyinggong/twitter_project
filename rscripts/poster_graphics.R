#Slide Graphics Generation

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
p2=JH_heatmap_plot(agg.heatma,lowcar = 'blue',highcar = 'darkorchid1')
grid.arrange(p1 + ggtitle("Female Tweets Heatmap"),
             p2 + ggtitle("Male Tweets Heatmap"),
             nrow=2,
             top = textGrob("Heatmap For Tweet Density",
                            gp = gpar(fontsize=29)) 
)



###########################
# Graphics For GH
###########################


###########################
# Graphics For PS
###########################


###########################
# Graphics For TO
###########################