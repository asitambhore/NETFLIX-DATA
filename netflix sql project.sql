-- netflix project

CREATE TABLE netflix 
  ( 
   show_id VARCHAR(10) PRIMARY KEY,
   type VARCHAR(15),
   title VARCHAR(150),
   director VARCHAR(250),
   casts VARCHAR(1000),
   country VARCHAR(150),
   date_added VARCHAR(50),
   release_year INT,
   rating VARCHAR(20),
   duration VARCHAR(50),
   listed_in VARCHAR(100),
   description VARCHAR(500)
  )

SELECT DISTINCT(type) FROM netflix;

SELECT* FROM netflix;

-- 15 Business Problems & Solutions

--1. Count the number of Movies vs TV Shows

SELECT  DISTINCT(type), COUNT(type) AS no_of_movie FROM netflix
GROUP BY type;


--2. Find the most common rating for movies and TV shows

SELECT DISTINCT(rating),COUNT(rating),type FROM netflix
GROUP BY 1 , 3
ORDER BY 2 DESC


--3. List all movies released in a specific year (e.g., 2020)

SELECT title,release_year FROM netflix
WHERE type = 'Movie'
AND release_year = '2020';
	

--4. Find the top 5 countries with the most content on Netflix

SELECT UNNEST(STRING_TO_ARRAY(country,',')),COUNT(show_id)
FROM netflix	
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;


--5. Identify the longest movie

SELECT type, duration 
FROM netflix 
WHERE type = 'Movie'
ORDER BY 2 DESC;
	


--6. Find content added in the last 5 years

SELECT *,
TO_DATE(date_added,'Month DD,YYYY')
FROM netflix
WHERE 
TO_DATE(date_added,'Month DD,YYYY')>= CURRENT_DATE -INTERVAL '7 YEARS';


--7. Find all the movies/TV shows by director 'Rajiv Chilaka'!

SELECT * FROM netflix
WHERE director LIKE  '%Rajiv Chilaka%'
GROUP BY 1;


--8. List all TV shows with more than 5 seasons

SELECT type,title,
    SPLIT_PART(duration, ' ', 1) FROM netflix
WHERE 
type = 'TV Show'
AND SPLIT_PART(duration, ' ', 1) :: numeric > 5 



--9. Count the number of content items in each genre
SELECT 
COUNT(show_id),
UNNEST(STRING_TO_ARRAY(listed_in,',')) AS genre
FROM netflix
GROUP BY 2;

--10.Find each year and the average numbers of content release in India on netflix 
     return top 5 year with highest avg content release.

 SELECT 
 EXTRACT( YEAR FROM TO_DATE(date_added, 'Month DD, YYYY')) AS year,
 COUNT(*),
 COUNT(*):: numeric /(SELECT COUNT(*) FROM netflix WHERE country = 'India'):: numeric *100
 FROM netflix
 WHERE country = 'India'
 GROUP BY 1;
	
--11. List all movies that are documentaries

SELECT title,listed_in FROM netflix
	WHERE listed_in ILIKE '%Documentaries%'


--12. Find all content without a director

SELECT *  FROM netflix
WHERE director IS NULL;


--13. Find how many movies actor 'Salman Khan' appeared in last 10 years!

SELECT title,casts,release_year
FROM netflix
WHERE casts LIKE '%Salman Khan%'
AND
release_year >EXTRACT (YEAR FROM CURRENT_DATE)- 13


--14. Find the top 10 actors who have appeared in the highest number of movies produced in India.

SELECT 
UNNEST(STRING_TO_ARRAY(casts,',')),
COUNT(*)
 FROM netflix
 WHERE country ILIKE 'India'
 GROUP BY 1 
 ORDER BY 2 DESC


--15.
--Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
  the description field. Label content containing these keywords as 'Bad' and all other 
content as 'Good'. Count how many items fall into each category.

WITH new_table
AS(

 SELECT * ,
 CASE 
 WHEN description ILIKE'%kill%' OR
     description ILIKE '%violence%'
	THEN 'BAD-FILM' 
	ELSE 'GOOD-FILM'
	END category
	FROM netflix )

	SELECT  category ,
	COUNT(*)
	FROM new_table
	GROUP BY 1;
	


