library(dplyr)
library(arules)
library(arulesViz)
library(visNetwork)
library(igraph)
# importing
#####
movies <- read.csv("data/imdb/movies.csv")
nominees <- read.csv("data/oscars/best_pictures_nom.csv")

movies$startYear <- as.numeric(as.character(movies$startYear))
movies.2000_and_up <- filter(movies, startYear >= 2000)
movies.2000_and_up$X <- NULL
movies.2000_and_up.wo_doc <- movies.2000_and_up %>% filter(genres != 'Documentary')

imdb_crew <- read.delim(gzfile("data/imdb/title.crew.tsv.gz"))
imdb_principals <- read.delim(gzfile("data/imdb/title.principals.tsv.gz"))
imdb_ratings <- read.delim(gzfile("data/imdb/title.ratings.tsv.gz"))

# colnames(imdb_ratings)
# head(left_join(movies.2000_and_up.wo_doc, imdb_ratings) %>% filter(startYear >= 2000) %>% filter(numVotes >= 500000) %>% arrange(-averageRating),25)

imdb_principals.with_ratings <- left_join(imdb_principals, imdb_ratings)
imdb_principals.with_ratings.with_year <- left_join(imdb_principals.with_ratings, movies.2000_and_up[,c(1,4)])
imdb_principals.with_ratings.with_year.2000_and_up <- filter(imdb_principals.with_ratings.with_year, !is.na(startYear))
imdb_principals.with_ratings.with_year.2000_and_up <- filter(imdb_principals.with_ratings.with_year.2000_and_up, !is.na(averageRating))
imdb_principals.with_ratings.with_year.2000_and_up <- filter(imdb_principals.with_ratings.with_year.2000_and_up, averageRating > 5)
imdb_principals.with_ratings.with_year.2000_and_up <- filter(imdb_principals.with_ratings.with_year.2000_and_up, numVotes > 50)
imdb_principals.with_ratings.with_year.with_crew.2000_and_up <- left_join(imdb_principals.with_ratings.with_year.2000_and_up, imdb_crew)

max(imdb_principals.with_ratings.with_year.with_crew.2000_and_up$averageRating)

arrange(filter(imdb_principals.with_ratings.with_year.with_crew.2000_and_up, averageRating > 9), -averageRating)

nrow(imdb_principals.with_ratings.with_year.with_crew.2000_and_up)

#####
# rules
for_apriori <- imdb_principals.with_ratings.with_year.with_crew.2000_and_up
for_apriori$principalCast <- apply(for_apriori,1,function (x) {as.vector(strsplit(as.character(x[2]), ",")[[1]])})
for_apriori$principalCast <- apply(for_apriori,1,function (x) {as.character(x[2])})
for_apriori$principalCast <- as.data.frame(example)

str(for_apriori$principalCast[1])

example <- data.table::data.table(for_apriori$principalCast)
as.data.frame(example$V1)
for_apriori$principalCast[[1]]
"nm0107463" %in% for_apriori$principalCast[[1]]

for_apriori %>% filter("nm0000288" %in% principalCast)

rules = apriori(for_apriori$principalCast,parameter=list(support=5/length(for_apriori$principalCast),conf=0.5, maxtime=0))

inspect(rules)

rules = apriori(for_apriori$principalCast,parameter=list(maxtime=0))
rules.v1 = as(rules,"data.frame")
rules.v1 = rules.v1 %>% arrange(-count)

rules.v1.sub <- subset(rules, subset=lhs %pin% "nm0000288")
rules.sub.v1 = as(rules.v1.sub,"data.frame")
rules.sub.v1 = rules.sub.v1 %>% arrange(-count)
head(rules.sub.v1, n = 10)

colnames(movies.2000_and_up)

##### 
# drawing networks
subrules2 <- head(sort(rules, by="count"), 20)
ig <- plot( subrules2, method="graph", control=list(type="items") )
# saveAsGraph seems to render bad DOT for this case
tf <- tempfile( )
saveAsGraph( subrules2, file = tf, format = "dot" )
# clean up temp file if desired
#unlink(tf)

# let's bypass saveAsGraph and just use our igraph
ig_df <- get.data.frame( ig, what = "both" )
visNetwork(
  nodes = data.frame(
    id = ig_df$vertices$name
    ,value = ig_df$vertices$lift # could change to lift or confidence
    ,title = ifelse(ig_df$vertices$label == "",ig_df$vertices$name, ig_df$vertices$label)
    ,ig_df$vertices
  )
  , edges = ig_df$edges
) %>%
  visEdges(arrows = "to", dashes=TRUE, length = 250) %>%
  visOptions( highlightNearest = T )

# https://bl.ocks.org/timelyportfolio/762aa11bb5def57dc27f
