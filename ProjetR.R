# PROJET R - 3CI

library("rjson")
library(data.table)
library(recommenderlab)
data("MovieLense")

#getwd()
setwd("C:/Users/rushi/Desktop/PROJETR/")

#links <- read.csv("C:/Users/rushi/Desktop/PROJETR/links.csv")
movies <- read.csv("C:/Users/rushi/Desktop/PROJETR/movies.csv")
ratings <- read.csv("C:/Users/rushi/Desktop/PROJETR/ratings.csv")
tags <- read.csv("C:/Users/rushi/Desktop/PROJETR/tags.csv")


mergeMovRat <- merge(movies, ratings, by="movieId")
mergeMovTag <- merge(movies, tags, by="movieId")

allmerged <- merge(mergeMovRat, mergeMovTag, by = "movieId")

#summary(ratings$rating)
#ratingsReal <- as(ratings, "realRatingMatrix")
#moviesReal <- as(movies, "realRatingMatrix")
#tagsReal <- as(tags, "realRatingMatrix")

#realMergeMovRat <- as(mergeMovRat, "realRatingMatrix")
#realMergeMovTag <- as(mergeMovTag, "realRatingMatrix")

realAllMerged <- as(allmerged, "realRatingMatrix")

#hist(getRatings(normalize(ratingsReal, method = "Z-score")))

#Predictions

resultat <- Recommender(realAllMerged, method = "UBCF")
prediction <- predict(resultat,realAllMerged,, given = 3)


as(prediction, "list")
