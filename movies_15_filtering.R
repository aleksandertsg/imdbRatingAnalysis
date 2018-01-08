movies <- read.csv("data/imdb/movies.csv")
movies$startYear <- as.numeric(as.character(movies$startYear))
movies.2015 <- filter(movies, startYear == 2015)
movies.2015$X <- NULL
movies.2015 <- movies.2015 %>% filter(genres != 'Documentary')

# runtime filtering
movies.2015 <- left_join(movies.2015, basics[,c(1,8)])
movies.2015$runtimeMinutes <- as.numeric(as.character(movies.2015$runtimeMinutes))

movies.2015 <- movies.2015 %>% filter(runtimeMinutes >= 91, runtimeMinutes <= 201)

# ratings filtering
movies.2015 <- left_join(movies.2015, ratings)
movies.2015$averageRating <- as.numeric(as.character(movies.2015$averageRating))
movies.2015$numVotes <- as.numeric(as.character(movies.2015$numVotes))

movies.2015 <- movies.2015 %>% filter(numVotes >= 2349, averageRating >= 6.7)

# genre filtering
movies.2015.genre_filtering <- movies.2015

movies.2015.genre_filtering$genres <- apply(movies.2015.genre_filtering,1, function (x) {as.vector(strsplit(as.character(x[5]), ",")[[1]])})
movies.2015.genre_filtering$genres <- factor(movies.2015.genre_filtering$genres)

genres_from_prev_oscars <- unique(unlist(nom.w_genres$genres))
genres_from_2015 <- unique(unlist(movies.2015$genres))

movies.2015.genre_filtering %>% filter(genres %>% genres_from_prev_oscars)

movies.2015 <- movies.2015[c(1:218),]

# directors, writers, principals
movies.2015 <- left_join(movies.2015, crew)
movies.2015 <- left_join(movies.2015, principals)

movies.2015$directors <- apply(movies.2015,1, function (x) {as.vector(strsplit(as.character(x[9]), ",")[[1]])}) 
movies.2015$writers <- apply(movies.2015,1, function (x) {as.vector(strsplit(as.character(x[10]), ",")[[1]])}) 
movies.2015$principalCast <- apply(movies.2015,1, function (x) {as.vector(strsplit(as.character(x[11]), ",")[[1]])}) 


compare <- function (data, toCompare, type="soft") {
  result <- c()
  for (director in data) {
    results <- c()
    for(d in director) {
      if (d %in% toCompare) {
        results <- c(results,TRUE)
      } else {
        results <- c(results,FALSE)
      }
    }
    if (type=="soft") {
      r <- any(results)
      result <- c(result,r)
    } else {
      r <- all(results)
      result <- c(result,r)
    }
  }
  return(result)
}

directors_from_prev_oscars <- unlist(nom.w_crew$directors)
writers_from_prev_oscars <- unlist(nom.w_crew$writers)
principals_from_prev_oscars <- unlist(nom.w_principals$principalCast)

## Directors
movies.2015.w_director <- movies.2015 %>% filter(compare(directors, directors_from_prev_oscars))
# remained movies
nrow(movies.2015.w_director)

# CHECK with director filter
movies.2015.w_director %>% filter(tconst %in% nominees.2015)

## Writers
movies.2015.w_writers <- movies.2015 %>% filter(compare(writers, writers_from_prev_oscars))
# remained movies
nrow(movies.2015.w_writers)

# CHECK with writers filter
movies.2015.w_writers %>% filter(tconst %in% nominees.2015)

## Principals
movies.2015.w_principals <- movies.2015 %>% filter(compare(principalCast, principals_from_prev_oscars))
# remained movies
nrow(movies.2015.w_principals)

# CHECK with principals filter
movies.2015.w_principals %>% filter(tconst %in% nominees.2015)

# CHECK
nom <- read.csv("data/oscars/best_pictures_nom.csv")

nominees.2015 <- unlist(as.vector(strsplit(as.character((nom %>% filter(Year == 2015))$tconst), " ")))
length(nominees.2015)
current <- movies.2015.w_director %>% filter(tconst %in% nominees.2015)

length(nominees.2015) == length(current)
