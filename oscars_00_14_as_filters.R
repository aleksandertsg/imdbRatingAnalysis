library(dplyr)
library(arules)
library(arulesViz)
library(visNetwork)
library(igraph)

nominees <- read.csv("data/oscars/best_pictures_nom.csv")
basics <- read.delim(gzfile("data/imdb/title.basics.tsv.gz"))
ratings <- read.delim(gzfile("data/imdb/title.ratings.tsv.gz"))
crew <- read.delim(gzfile("data/imdb/title.crew.tsv.gz"))
principals <- read.delim(gzfile("data/imdb/title.principals.tsv.gz"))
names <- read.delim(gzfile("data/imdb/name.basics.tsv.gz"))

#####
nominees <- nominees %>% filter(Year >= 2000) %>% filter(Year < 2015)
nominees$X.1 <- NULL
nominees$X <- NULL
#####

## runtimeMinutes ##

nom.w_output <- left_join(nominees, basics[,c(1,8)])
nom.w_output$runtimeMinutes <- as.numeric(as.character(nom.w_output$runtimeMinutes))

# result
min(nom.w_output$runtimeMinutes)
max(nom.w_output$runtimeMinutes)

#####
## ratings ##

nom.w_ratings <- left_join(nominees, ratings)
nom.w_ratings$averageRating <- as.numeric(as.character(nom.w_ratings$averageRating))
nom.w_ratings$numVotes <- as.numeric(as.character(nom.w_ratings$numVotes))

# result
min(na.omit(nom.w_ratings)$averageRating)
min(na.omit(nom.w_ratings)$numVotes)


#####
## genres unique ##
nom.w_genres_u <- nominees

nom.w_genres_u$genres <- as.character(nom.w_genres_u$genres)
table(nom.w_genres_u$genres)

# genres
nom.w_genres <- nominees

nom.w_genres$genres <- apply(nom.w_genres,1, function (x) {as.vector(strsplit(as.character(x[9]), ",")[[1]])})
table(unlist(nom.w_genres$genres))
nrow(nominees)

nom.w_genres.apriori <- apriori(nom.w_genres$genres,parameter=list(support=5/length(nom.w_genres$genres),conf=0.5, maxtime=0, minlen=2))
nom.w_genres.apriori.v1 = as(nom.w_genres.apriori,"data.frame")
nom.w_genres.apriori.v1 = nom.w_genres.apriori.v1 %>% arrange(-lift)
head(nom.w_genres.apriori.v1, n = 10)

## visualise genres assoc ##
draw_apriori(nom.w_genres.apriori, 'count', 20)
inspect(head(sort(nom.w_genres.apriori, by='count'), 20))

## genres won ##
nom.w_genres_won <- nominees %>% filter(Winner == 1) 

nom.w_genres_won$genres <- apply(nom.w_genres_won,1, function (x) {as.vector(strsplit(as.character(x[9]), ",")[[1]])})
nom.w_genres_won$genres <- factor(nom.w_genres_won$genres)

table(unlist(nom.w_genres_won$genres))

#####
## directors ##
nom.w_crew <- left_join(nominees, crew)

nom.w_crew$directors <- apply(nom.w_crew,1, function (x) {as.vector(strsplit(as.character(x[10]), ",")[[1]])})

as.data.frame(table(unlist(nom.w_crew$directors))) %>% arrange(-Freq)

## writers ##
nom.w_crew$writers <- apply(nom.w_crew,1, function (x) {as.vector(strsplit(as.character(x[11]), ",")[[1]])})

as.data.frame(table(unlist(nom.w_crew$writers))) %>% arrange(-Freq)

## principals ##
nom.w_principals <- left_join(nominees, principals)

nom.w_principals$principalCast <- apply(nom.w_principals,1, function (x) {as.vector(strsplit(as.character(x[10]), ",")[[1]])})
nom.w_principals.table <- table(unlist(nom.w_principals$principalCast))

nom.w_principals.table.result <- as.data.frame(nom.w_principals.table) %>% arrange(-Freq)

head(nom.w_principals.table.result,20)

nrow(as.data.frame(nom.w_principals.table) %>% arrange(-Freq))
