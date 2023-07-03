-------------------------------------------

/*Creating movies table */

-------------------------------------------

DROP TABLE IF EXISTS movies CASCADE;

CREATE TABLE movies (

    movieId INT PRIMARY KEY,
    title VARCHAR(255) ,
    genre VARCHAR(255),
    movie_year VARCHAR(255) NOT NULL

);

-------------------------------------------

/*Creating links table */

-------------------------------------------

DROP TABLE IF EXISTS links;

CREATE TABlE links (

    movieId INT REFERENCES movies(movieid),
    imdbId INT NOT NULL,
    tmbId INT
);

-------------------------------------------

/*Creating ratings table */

-------------------------------------------


DROP TABLE IF EXISTS ratings;

CREATE TABlE ratings (

    movieId INT REFERENCES movies(movieid),
    userId INT,
    rating FLOAT,
    time_stamp INT
);

-------------------------------------------

/*Creating tags table */

-------------------------------------------


DROP TABLE IF EXISTS tags;

CREATE TABlE tags (

    movieId INT REFERENCES movies(movieid),
    userId INT,
    tag VARCHAR(255),
    time_stamp INT
);

-------------------------------------------

/*Populating tables with data */

-------------------------------------------

\COPY movies FROM '../data/movies.csv' DELIMITER ',' CSV HEADER;

\COPY links FROM '../data/links.csv' DELIMITER ',' CSV HEADER;

\COPY ratings(userId,movieId,rating, time_stamp) FROM '../data/ratings.csv' DELIMITER ',' CSV HEADER;

\COPY tags(userId,movieId,tag,time_stamp) FROM '../data/tags.csv' DELIMITER ',' CSV HEADER;


-------------------------------------------

/*Display the (whole) movies table. */

-------------------------------------------

SELECT
	*
FROM
	movies;

-------------------------------------------

/* Display only title and genres of the first 10 entries from the movies table 
   that is sorted alphabetically (starting from A) by the movie titles.*/

-------------------------------------------

SELECT
	title,
	genre
FROM
	movies
ORDER BY
	title ASC
LIMIT 10 ;

-------------------------------------------

/* Display the total row count */

-------------------------------------------


SELECT
	COUNT (*)
FROM
	movies;

-------------------------------------------

/* Display first 10 pure Drama movies. Only Drama is in the genre column. */

-------------------------------------------


SELECT
	*
FROM
	movies
WHERE
	genre = 'Drama'
LIMIT 10;

-------------------------------------------

/* Display the count of pure Drama movies. */

-------------------------------------------

SELECT
	COUNT(genre)
FROM
	movies
WHERE
	genre = 'Drama';

-------------------------------------------

/* Display the count of drama movies that can also contain other genres. */

-------------------------------------------

SELECT
	count(genre)
FROM
	movies
WHERE
	genre ILIKE '%Drama%';

-------------------------------------------

/* Display the count of movies don’t have drama (in any combination) as assigned genre */

-------------------------------------------

SELECT
	count(genre)
FROM
	movies
WHERE
	genre NOT ILIKE '%Drama%';

-------------------------------------------

/* Display the count of movies that were released in 2003. */

-------------------------------------------

SELECT
	COUNT() (*) 
FROM
	movies
WHERE 
	movie_year = '2003';

-------------------------------------------

/* Find all movies with a year lower 1910. */

-------------------------------------------

SELECT
	* 
FROM
	movies
WHERE 
	movie_year  < '1910';
	
-------------------------------------------

/* Retrieve all Star Wars movies from the movie table. */

-------------------------------------------

SELECT
	* 
FROM
	movies
WHERE 
	title ILIKE '%star wars%';
	
-------------------------------------------

/* Display the total row count of the ratings table. */

-------------------------------------------

SELECT 
	COUNT(*)
FROM
	ratings;

-------------------------------------------

/* Display the total count of different genres combinations in the movies table. */

-------------------------------------------

SELECT 
	COUNT(DISTINCT(genre))
FROM
	movies;

-------------------------------------------

/* Display unique tags for movie with id equal 60756. Use tags table. */

-------------------------------------------

SELECT 
	DISTINCT(tag)
FROM
	tags
WHERE
	movieid = 60756;

-------------------------------------------

/* Display the count of movies in the years 1990-2000 using the movies table. Display year and movie_count. */

-------------------------------------------

SELECT 
	movie_year ,
	COUNT(movieId)
FROM
	movies
GROUP BY
	movie_year
HAVING 
	movie_year > '1989'
	AND movie_year < '2001'
ORDER BY
	movie_year ;

-------------------------------------------

/* Display the year where most of the movies u=in the database are from. */

-------------------------------------------

SELECT 
	movie_year ,
	COUNT(movieId) AS movie_count
FROM
	movies
GROUP BY
	movie_year
ORDER BY
	movie_count DESC
LIMIT 1;

-------------------------------------------

/* Display 10 movies with the most ratings. Use ratings table. Display movieid, count_movie_ratings. */

-------------------------------------------

SELECT 
	movieid ,
	COUNT(rating) AS count_movie_ratings
FROM
	ratings r
GROUP BY
	movieid
ORDER BY
	count_movie_ratings DESC
LIMIT 10;

-------------------------------------------

/*Display the top 10 highest rated movies by average that have at least 50 ratings.
  Display the movieid, average rating and rating count. Use the ratings table. */

-------------------------------------------

SELECT 
	movieid ,
	ROUND(AVG(rating)::NUMERIC,2 ) AS average_rating,
	COUNT(rating) AS rating_count
FROM
	ratings r
GROUP BY
	movieid
HAVING
	COUNT(rating) >= 50
ORDER BY
	average_rating DESC
LIMIT 10;

-------------------------------------------

/* Create a view that is a table of only movies that contain drama as one of it’s genres.
   Display the first 10 movies in the view. */

-------------------------------------------

CREATE VIEW drama_movies AS
SELECT
	title,
	movie_year
FROM
	movies m
WHERE 
	genre ILIKE '%drama%';

SELECT
	*
FROM
	drama_movies
LIMIT 10;


-------------------------------------------

/* Using a JOIN display 5 movie titles with the lowest imdb ID */

-------------------------------------------

SELECT
	m.title,
	m.movie_year ,
	l.imdbid
FROM
	movies m
LEFT JOIN links l  
ON
	m.movieid = l.movieid
ORDER BY
	l.imdbid
LIMIT 5;

-------------------------------------------

/* Display the count of drama movies using genre table */

-------------------------------------------

SELECT
	count(genre) AS count_drama_movies
FROM
	genres g
WHERE
	genre = 'Drama';

-------------------------------------------

/* Using a JOIN display all of the movie titles that have the tag "fun" */

-------------------------------------------

SELECT 
	m.movieid, 
	m.title,
	m.movie_year 
FROM movies m 
LEFT JOIN tags t  
ON m.movieid = t.movieid 
WHERE t.tag  = 'fun';

-------------------------------------------

/* Using a JOIN find out which movie title is the first without a tag */

-------------------------------------------

SELECT 
	m.movieid, 
	m.title,
	m.movie_year
FROM
	movies m
LEFT JOIN tags t  
ON
	m.movieid = t.movieid
WHERE
	t.tag IS NULL
ORDER BY
	movie_year
LIMIT 1;

-------------------------------------------

/* Using a JOIN display the top 3 genres and their average rating */

-------------------------------------------

SELECT 
	g.genre AS Genre,
	round(avg(r.rating)::NUMERIC ,2) AS average_rating
FROM
	genres g
LEFT JOIN ratings r 
ON
	g.movieid = r.movieid
GROUP BY
	g.genre 
ORDER BY average_rating DESC 
LIMIT 3;

-------------------------------------------

/* Using a JOIN display the top 10 movie titles by the number of ratings */

-------------------------------------------

SELECT 
	m.title,
	m.movie_year,
	count(r.rating) AS number_of_ratings
FROM
	movies m 
LEFT JOIN ratings r 
ON
	m.movieid = r.movieid
GROUP BY
	m.movieid 
ORDER BY number_of_ratings DESC 
LIMIT 10;

-------------------------------------------

/* Using a JOIN display all of the Star Wars movies in order of average rating
 * where the film was rated by at least 40 users */

-------------------------------------------

SELECT 
	m.title,
	m.movie_year, 
	round(avg(r.rating)::NUMERIC ,2) AS average_rating,
	count(r.rating) AS number_of_ratings
FROM
	movies m 
LEFT JOIN ratings r 
ON
	m.movieid = r.movieid
GROUP BY
	m.title,m.movie_year 
HAVING m.title ILIKE '%Star Wars%' AND count(r.rating) >= 40
ORDER BY average_rating DESC 
;

-------------------------------------------

/* Create a derived table from one or more of the above queries:
   Movies from the year 1994 with average rating and number of ratings for movies with atleast 10 ratings */

-------------------------------------------

DROP TABLE IF EXISTS movies_1994;

CREATE TABLE movies_1994 AS (
SELECT
	m.title,
	m.genre,
	m.movie_year, 
	round(avg(r.rating)::NUMERIC ,2) AS average_rating,
	count(r.rating) AS number_of_ratings
FROM
	movies m
LEFT JOIN ratings r 
ON
	m.movieid = r.movieid
GROUP BY
	m.title,
	m.genre,
	m.movie_year
HAVING
	m.movie_year = '1994'
	AND count(r.rating) > 10
ORDER BY
	average_rating DESC 
);

-------------------------------------------

/* Number of movies, average ratings and number of ratings per year 
   with atleast 5 ratings and 100 movies per year */

-------------------------------------------

SELECT
	m.movie_year ,
	count(m.movieid) AS number_of_movies,
	round(avg(r.rating)::NUMERIC, 2) AS average_rating,
	count(r.rating) AS number_of_ratings
FROM
	movies m
LEFT JOIN ratings r 
ON
	m.movieid = r.movieid
GROUP BY
	m.movie_year 
HAVING count(r.rating) >= '5' AND count(m.movieid) >= 100
ORDER BY
	average_rating DESC
;

