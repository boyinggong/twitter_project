## ---- setupSimilarity ----
#library(dplyr)
#library(ggplot2)
#library(rjson)

#source("read_data.R")

timelines_lower <- timelines %>% mutate(tweet_user_screen_name = tolower(tweet_user_screen_name))
nominees_metadata_lower <- nominees_metadata %>% mutate(TWITTER_SCREEN_NAME = tolower(TWITTER_SCREEN_NAME))
combined_timelines <- left_join(timelines_lower
                                , nominees_metadata_lower
                                , by = c("tweet_user_screen_name" = "TWITTER_SCREEN_NAME"))

combined <- combined_timelines %>% mutate(tweet_user_screen_name = tolower(tweet_user_screen_name))

filename <- "../data/output_data/following_computed_data/following_dot_products_normalized.csv"
dot_products <- as.matrix(read.csv(filename, header = FALSE))
indices <- upper.tri(dot_products) | diag(nrow = nrow(dot_products))
dot_products_flattened <- data.frame(Similarity = dot_products[indices])
names_vector <- fromJSON(file = "../data/output_data/following_computed_data/names.json")
names_vector <- tolower(gsub(".json", "", names_vector))
joined <- data.frame(tweet_user_screen_name = names_vector,
                     stringsAsFactors = FALSE) %>%
                     left_join(combined[c("tweet_user_screen_name", "NOMINEE")],
                               by = "tweet_user_screen_name") %>% distinct()
joined$NOMINEE[joined$tweet_user_screen_name == "spythemovieuk"] <- "Spy (UK account)"
rownames(dot_products) <- colnames(dot_products) <- joined$NOMINEE

## ---- similarityHist ----
p <- ggplot(data = dot_products_flattened, aes(x = Similarity))
p <- p + geom_histogram(bins = 30)
p <- p + labs(y = "Frequency",
              title = "Distribution of Following Similarity")
p <- p + annotate("rect", xmin = 0.05, xmax = 1, ymin = -100, ymax = 250,
                  alpha = 0.2)
p <- p + annotate("text", x = 0.025, y = 2700, label = "Very dissimilar")
p <- p + annotate("text", x = 1, y = 450,
                  label = "Similarity with self = 1")
p <- p + annotate("text", x = 0.5, y = 100, label = "Similar pairs")
p

## ---- similarityBar ----
#png("../poster_graphics/similarity.png")
top_pairs <- sort(dot_products[dot_products > 0.1 & dot_products < 0.9],
                  decreasing = TRUE)[seq(length.out = 15, by = 2)]
top_pairs <- rev(top_pairs)
extract_pair_names <- function(value) {
  paste(rownames(which(dot_products == value, arr.ind = TRUE)),
        collapse = ", ")
}
pair_names <- sapply(top_pairs, extract_pair_names)

pairs_df <- data.frame(Pair = pair_names, Similarity = top_pairs)
pairs_df <- pairs_df %>% mutate(Pair = factor(Pair, levels = Pair))
notable_pairs <- rep(1, nrow(pairs_df))
notable_pairs[c(2, 6, 8, 15)] <- 2
pairs_df <- pairs_df %>% mutate(Notable = factor(notable_pairs))

imgAnnotate <- function(filename, ...) {
  img  <- readJPEG(filename)
  g <- rasterGrob(img, interpolate = TRUE)
  annotation_custom(g, ...)
}



p <- ggplot(data = pairs_df,
            aes(x = Pair, y = Similarity, fill = Notable))
p <- p + geom_bar(stat = "identity") + coord_flip()
p <- p + ylim(0, 0.55)
## Note: coordinates have been flipped, so x and y adjustments are also flipped
# p <- p + imgAnnotate("../poster_graphics/pictures/thebigshortcsheader.jpg",
#                      xmin = 13, xmax = 16, ymin = 0.41, ymax = 0.51)
# p <- p + imgAnnotate("../poster_graphics/pictures/pixar_movies.jpg",
#                      xmin = 4, xmax = 7, ymin = 0.21, ymax = 0.31)
# p <- p + imgAnnotate("../poster_graphics/pictures/american_crime.jpg",
#                      xmin = 7, xmax = 10, ymin = 0.25, ymax = 0.35)
# p <- p + imgAnnotate("../poster_graphics/pictures/elba_henson.jpg",
#                      xmin = 1, xmax = 4, ymin = 0.2, ymax = 0.3)
p <- p + ggtitle("Following Similarity: Most Similar Pairs")
p <- p + theme(legend.position = "none")
p <- p + scale_fill_manual(values = c("#599ad3", "#f9a65a"))
p
#dev.off()
ggsave(filename = "../poster_graphics/similarity.png",
       plot = p, width = 50, height = 30, units = "cm")
