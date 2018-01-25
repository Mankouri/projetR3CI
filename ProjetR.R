# PROJET R - 3CI

library("rjson")
library(data.table)
library(recommenderlab)
#data("MovieLense")

setwd("C:/Users/rushi/Desktop/PROJETR/")

# On charge les fichiers CSV
movies <- read.csv("C:/Users/rushi/Desktop/PROJETR/movies.csv")
ratings <- read.csv("C:/Users/rushi/Desktop/PROJETR/ratings.csv")
tags <- read.csv("C:/Users/rushi/Desktop/PROJETR/tags.csv")

# On fusionne les deux csv movies et ratings en prenant 'l'attribut movieId comme jointure
mergeMovRat <- merge(ratings, movies, by="movieId")

# Transformer le type data.frame en RealRatingMatrix (utile pour la suite)
mergeMovRat <- as(mergeMovRat, "realRatingMatrix")

# Affichage à l'aide de deux histogrammes, le premier contiendra les données brutes tandis que le second les données normalisées
hist(getRatings(mergeMovRat), breaks = 20, main="Données brutes movies ratings")
hist(getRatings(normalize(mergeMovRat)), breaks = 20, main="Données normalisées movies ratings")

# Création du schéma d'évaluation pour notre analyse prédictive sur le dataset movies/ratings (mergeMovRat) en utilisant 
# la méthode de la validation croisée. On décide de ne prendre que 80% (0.8) du set de données d'entrainement afin de prédire la partie 
# restante. Il faut préciser à la fonction ci-dessous quelle est la note à partir de laquelle on considère qu'il s'agit 
# d'une bonne notations(>=4), le paramètre k représente le nombre de plis pour la validation croisée. (10)
evaluationSchema <-evaluationScheme(mergeMovRat,method='cross-validation',train=.8,given=1,goodRating=4,k=10)

# Pour réaliser notre étude nous utiliserons les deux fonctions "recommender" et "getdata" afin d'obtenir l'ensemble de données en 
# utilisant les 5 techniques de modélisations (UBCF, IBCF, SVD, POPULAR, RANDOM)
ubcfRecommender <- Recommender(getData(evaluationSchema,"train"),"UBCF")
ibcfRecommender <- Recommender(getData(evaluationSchema,"train"),"IBCF")
svdRecommender <- Recommender(getData(evaluationSchema,"train"),"svd")
popularRecommender <- Recommender(getData(evaluationSchema,"train"),"POPULAR")
randomRecommender <- Recommender(getData(evaluationSchema,"train"),"RANDOM")

# Maintenant que nous avons construit nos modèles pour chaques techniques (voir plus haut), il nous faut lancer une prédiction à l'aide
# de la fonction "predict" en complément de la fonction "getdata" avec pour argument "type" les notations (ratings)
ubcfPrediction <- predict(ubcfRecommender,getData(evaluationSchema,"known"),type="ratings")
ibcfPrediction <- predict(ibcfRecommender,getData(evaluationSchema,"known"),type="ratings")
svdPrediction <- predict(svdRecommender,getData(evaluationSchema,"known"),type="ratings")
popPrediction <- predict(popularRecommender,getData(evaluationSchema,"known"),type="ratings")
randPrediction <- predict(randomRecommender,getData(evaluationSchema,"known"),type="ratings")

# Sur les prédictions générées, nous calculons la précisions des 5 techniques de modélisations. Ici le taux d'erreur sera calculé 
ubcfPredictionAccuracy <- calcPredictionAccuracy(ubcfPrediction,getData(evaluationSchema,"unknown"))
ibcfPredictionAccuracy <- calcPredictionAccuracy(ibcfPrediction,getData(evaluationSchema,"unknown"))
svdPredictionAccuracy <- calcPredictionAccuracy(svdPrediction,getData(evaluationSchema,"unknown"))
popPredictionAccuracy <- calcPredictionAccuracy(popPrediction,getData(evaluationSchema,"unknown"))
randPredictionAccuracy <- calcPredictionAccuracy(randPrediction,getData(evaluationSchema,"unknown"))

# Il nous faut ensuite combiner les résultats précédents ensemble afin de déterminer les techniques de modélisations les plus forts.
PredictionAccuracy <- rbind(ubcfPredictionAccuracy,ibcfPredictionAccuracy,svdPredictionAccuracy,popPredictionAccuracy,randPredictionAccuracy)
rownames(PredictionAccuracy) <- c("UBCF","IBCF","SVD","POP","RAND")
View(PredictionAccuracy)
# On observe que les techniques de modélisations IBCF et RAND sont les moins précises.
# Nous allons donc nous concentrer sur les trois autres techniques de modélisations

# Sur ces trois techniques de modélisations, on évalue sur plusieurs varaibles (ex: TP True Positive, FP False Positive, 
# FN False Negative, TN True Negative, Precision, recall)
algorithms <- list(POPULAR=list(name="POPULAR"),SVD=list(name="SVD"),UBCF=list(name="UBCF"))
evaluatelist <- evaluate(evaluationSchema,algorithms,n=c(5,10,15,20))
avg(evaluatelist)

# Cette visualisation nous permet de conclure que la technique de modélisation la plus optimale est la "POP", en regardant la valeur 
# pour 5 films, POPULAR est la plus élevé avec 0.30 sur les "TP" ( SVD avec 0.10, UBCF 0.13)
plot(evaluatelist,legend="topleft", annotate=T)

# Sur la technique de modélisation "POPULAR", nous allons construire des recommendations cette fois-ci individuelles.
RecommenderOnE<-Recommender(mergeMovRat,method="POPULAR")
RecommenderOnE

# On réalise un tirage pour les 5 premières recommendations pour les 5 premiers évaluateurs afin de construire une liste
predictRecommend<-predict(RecommenderOnE,mergeMovRat[1:5],n=5)
# Les numéros correspondent au idendifiants (id) des films du dataset ratings d'origine
as(predictRecommend,"list")

# Nous prédisons les notes probable que les 5 premiers évaluateurs pourraient attribuer à chaques films
predictRating <- predict(RecommenderOnE,mergeMovRat[1:5],type='ratings')
predictRating

# Sur les 5 premiers évaluateurs et les 3 trois premiers films du dataset ratings Toy Story, Jumanji et Grumpier.
RESULTAT <- as(predictRating,'matrix')[1:5,1:3]
colnames(RESULTAT)<-c("Toy Story","Jumanji","Grumpier Old Men")
RESULTAT