---
title: "Homework 11"
subtitle: "Team members: Aleksndr Tsõganov, Aramais Khachatryan, Yaroslav Hrushchak"
output:
  pdf_document: default
  pdf: default
---

# Final poster

![alt text](https://github.com/aramYnwa/imdbRatingAnalysis/blob/master/plakat.png "Final poster")


# Exercise 1

This project is not commercial and is not related to any business case

### Identifying your business goals - not relevant.

### Assessing your situation 
* Inventory of resources
    * [IMDb  1000 movies data](https://www.kaggle.com/PromptCloudHQ/imdb-data/)
    * [The Academy Awards dataset](https://www.kaggle.com/theacademy/academy-awards)
    * [5000 movies dataset from IMDb](https://www.kaggle.com/tmdb/tmdb-movie-metadata)
    * [Python library to retrieve data from IMDb](https://imdbpy.sourceforge.io/)
* Terminology
    * Movie - movie in context
    * Person - actor, producer or any other type of person related to topic
    * Rating/Rank - the movie rating
    * Votes - number of people voted for movie
    * Genres - genres of movie

* Costs and benefits - not relevant.

## Defining your data-mining goals
### Data-mining goals
The purpose of this project is to analyse the data of IMDb and other sources and 
find different type of correlations between various features such as:

* Movie rating and chances to win an Oscar
* Combinations of actors and directors and rating in IMDB
* Popularity of movie genres during last years and ratings in IMDB
* predict IMDB ratings of upcoming movies based on genre, actor and director collaboration happend before.
  
### Data-mining success criteria
  Success criteria for this project can be predicting rating ranges for upcoming movies with high correctness.
  
  In perfect world, the results of this research would help new movie companies to choose right actors, directors and plots for making really good movies and pursue higher income. :)

  

# Exercise 2
### Gathering data
* Outline data requirements
    * Data should contain movies and their IMDb ids, there should be persons related to the movie presented.         Data structure should be similar between different sources.
* Verify data availability
    * Open source data from kaggle, and python library to retrieve specific data from IMDb if needed.
* Define selection criteria
    * Initially we have chosen IMDB dataset from Kaggle. In addition we’ve decided to find other datasets which contains some more additional information, features which can help us make more precise and interesting analysis. The main criteria for all datasets we use is presence of IMDB id’s for all features (movie, actor, director etc.). This criteria is vital because we will use also python library for IMDB (imdbspy) to retrieve all necessary data we need to feel the gaps.
* Describing data	
	The resource data for our project contains the following features:
    * “IMDB  1000 movies data”: Rank, TItle, Genre, Description, Director, Actors, Year, Runtime (Minutes), Rating, Votes, Revenue (Millions) and Metascores.
    * “The Academy Awards dataset”: Year, Ceremony, Award, Winner, Name and Film
    * “5000 movies dataset from IMDB”: Budget, Genres, Homepage, id, keywords, original language, original title, overview, popularity, production companies, production countries, release date, revenue, runtime, spoken language, status, tagline, title, vote average, vote count.
* Exploring data
    *	Our datasets has different sizes as they have been served to concret more narrow tasks. They also have some overlaps which need to be removed to avoid information duplication. The main features of our data are listed above. Although, from initial viewpoint they are sufficient to do proper analysis, python library ImdbSpy gives us confidence that in any case we will be able get any missing information we need. 
* Verifying data quality
    * We have done brief research on each dataset we have got. Each of them meets our choice criteria, contains quite much information, which, for sure, need to be cleaned for proper use.





# Exercise 3
Here is a link to our project [HERE](https://github.com/aramYnwa/imdbRatingAnalysis.git)

Description slide was added to other slides

At this moment it is hard to do some estimation of time we will consume solving different tasks of our project.  List of tasks are not finally certain as well,  but here are some parts of that cycle:

Gathering all necessary data together: we are using different sources of movies, trying to fill the gaps of each dataset, and make one overall dataset for each goal. 

Field research and data cleaning. We need to find any help from this field which will lead us in choosing right feature parameters for our goals. The amount of the work is hard to assess at this current moment.

Make different models for rating prediction goals and for the movie cast classification goals. Using cross validations we need check performance and correctness of our models. Probably in some cases models will be in need of tuning. 

Summing up results we have on different models we will choose the best model and use it for our initial goals.


