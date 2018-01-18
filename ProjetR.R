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

ubcfRecommender <- Recommender(getData(evaluationSchema,"train"),"UBCF")
ibcfRecommender <- Recommender(getData(evaluationSchema,"train"),"IBCF")
svdRecommender <- Recommender(getData(evaluationSchema,"train"),"svd")
popularRecommender <- Recommender(getData(evaluationSchema,"train"),"POPULAR")
randomRecommender <- Recommender(getData(evaluationSchema,"train"),"RANDOM")

ubcfPrediction <- predict(ubcfRecommender,getData(evaluationSchema,"known"),type="ratings")
ibcfPrediction <- predict(ibcfRecommender,getData(evaluationSchema,"known"),type="ratings")
svdPrediction <- predict(svdRecommender,getData(evaluationSchema,"known"),type="ratings")
popPrediction <- predict(popularRecommender,getData(evaluationSchema,"known"),type="ratings")
randPrediction <- predict(randomRecommender,getData(evaluationSchema,"known"),type="ratings")

ubcfPredictionAccuracy <- calcPredictionAccuracy(ubcf_pred,getData(eSetup,"unknown"))
ibcfPredictionAccuracy <- calcPredictionAccuracy(ibcf_pred,getData(eSetup,"unknown"))
svdPredictionAccuracy <- calcPredictionAccuracy(svd_pred,getData(eSetup,"unknown"))
popPredictionAccuracy <- calcPredictionAccuracy(pop_pred,getData(eSetup,"unknown"))
randPredictionAccuracy <- calcPredictionAccuracy(rand_pred,getData(eSetup,"unknown"))
PredictionAccuracy <- rbind(ubcf_error,ibcf_error,svd_error,pop_error,rand_error)

rownames(PredictionAccuracy) <- c("UBCF","IBCF","SVD","POP","RAND")




#resultat <- Recommender(realAllMerged, method = "UBCF")
#prediction <- predict(resultat,realAllMerged,, given = 3)


#as(prediction, "list")
