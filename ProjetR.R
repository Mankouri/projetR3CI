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

ubcfPredictionAccuracy <- calcPredictionAccuracy(ubcfPrediction,getData(evaluationSchema,"unknown"))
ibcfPredictionAccuracy <- calcPredictionAccuracy(ibcfPrediction,getData(evaluationSchema,"unknown"))
svdPredictionAccuracy <- calcPredictionAccuracy(svdPrediction,getData(evaluationSchema,"unknown"))
popPredictionAccuracy <- calcPredictionAccuracy(popPrediction,getData(evaluationSchema,"unknown"))
randPredictionAccuracy <- calcPredictionAccuracy(randPrediction,getData(evaluationSchema,"unknown"))
PredictionAccuracy <- rbind(ubcfPredictionAccuracy,ibcfPredictionAccuracy,svdPredictionAccuracy,popPredictionAccuracy,randPredictionAccuracy)

rownames(PredictionAccuracy) <- c("UBCF","IBCF","SVD","POP","RAND")

View(PredictionAccuracy)

algorithms <- list(POPULAR=list(name="POPULAR"),SVD=list(name="SVD"),UBCF=list(name="UBCF"))
evlist <- evaluate(eSetup,algorithms,n=c(5,10,15,20))
avg(evlist)




#resultat <- Recommender(realAllMerged, method = "UBCF")
#prediction <- predict(resultat,realAllMerged,, given = 3)


#as(prediction, "list")
