# PROJET R - 3CI

library("rjson")
library(data.table)
library(recommenderlab)
#data("MovieLense")

#getwd()
setwd("C:/Users/rushi/Desktop/PROJETR/")

#links <- read.csv("C:/Users/rushi/Desktop/PROJETR/links.csv")
movies <- read.csv("C:/Users/rushi/Desktop/PROJETR/movies.csv")
ratings <- read.csv("C:/Users/rushi/Desktop/PROJETR/ratings.csv")
tags <- read.csv("C:/Users/rushi/Desktop/PROJETR/tags.csv")


mergeMovRat <- merge(ratings, movies, by="movieId")
#mergeMovTag <- merge(movies, tags, by="movieId")

#allmerged <- merge(mergeMovRat, mergeMovTag, by = "movieId")

#summary(ratings$rating)
#ratingsReal <- as(ratings, "realRatingMatrix")
#moviesReal <- as(movies, "realRatingMatrix")
#tagsReal <- as(tags, "realRatingMatrix")

mergeMovRat <- as(mergeMovRat, "realRatingMatrix")
#realMergeMovTag <- as(mergeMovTag, "realRatingMatrix")

#realAllMerged <- as(allmerged, "realRatingMatrix")
hist(getRatings(mergeMovRat), breaks = 20)
hist(getRatings(normalize(mergeMovRat)), breaks = 20)

evaluationSchema <-evaluationScheme(mergeMovRat,method='cross-validation',train=.8,given=1,goodRating=4,k=10)

#Predictions

resultat <- Recommender(realAllMerged, method = "UBCF")
prediction <- predict(resultat,realAllMerged,, given = 3)


as(prediction, "list")
