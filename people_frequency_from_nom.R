nominees <- read.csv("data/oscars/best_pictures_nom.csv")
colnames(nominees)
imdb_crew <- read.delim(gzfile("data/imdb/title.crew.tsv.gz"))
imdb_principals <- read.delim(gzfile("data/imdb/title.principals.tsv.gz"))
imdb_ratings <- read.delim(gzfile("data/imdb/title.ratings.tsv.gz"))

movies$startYear <- as.numeric(as.character(movies$startYear))
movies.2000_and_up <- filter(movies, startYear >= 2000)
movies.2000_and_up$X <- NULL
movies.2000_and_up.wo_doc <- movies.2000_and_up %>% filter(genres != 'Documentary')

nominees.with_principals <- left_join(nominees,imdb_principals) %>% filter(genres != 'Documentary') %>% filter(Year >= 2000)
nominees.with_principals <- left_join(nominees.with_principals, imdb_ratings) %>% filter(!is.na(averageRating))
nominees.with_principals <- left_join(nominees.with_principals, imdb_crew)
nominees.with_principals$X <- NULL
nominees.with_principals$X.1 <- NULL

for_apriori <- nominees.with_principals
colnames(for_apriori)
for_apriori$principalCast <- apply(for_apriori,1,function (x) {as.vector(strsplit(as.character(x[10]), ",")[[1]])})
str(for_apriori$principalCast)

rules = apriori(for_apriori$principalCast,parameter=list(support=5/length(for_apriori$principalCast),conf=0.5, maxtime=0))

rules.nom = apriori(for_apriori$principalCast)
rules.v1_nom = as(rules.nom,"data.frame")
rules.v1_nom = rules.v1_nom %>% arrange(-count)
head(rules.v1_nom, n = 10)
