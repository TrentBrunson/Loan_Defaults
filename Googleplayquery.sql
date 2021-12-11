-- Trent Brunson Google Play

SELECT *
  FROM apps;

SELECT DISTINCT Category,
  COUNT(AppName) appCount	
  FROM apps
  GROUP BY Category
  ORDER BY Category;
  -- count is 34 categories

SELECT Category, COUNT(*) 
  FROM apps 
  GROUP BY Category 
  ORDER BY Category; 

SELECT TOP 1 WITH TIES (AppName), COUNT(ReviewText) ReviewCount
  FROM reviews
  GROUP BY AppName
  ORDER BY ReviewCount DESC;
  -- 7 with 4 reviews from the apps table
  -- 3 apps with 320 reviews from the reviews table

SELECT TOP 1 WITH TIES AppName, COUNT(*) [Number of Reviews] 
FROM reviews 
GROUP BY AppName 
ORDER BY [Number of Reviews] DESC; 

-- Create an alphabetically listing of the genres available in the ‘GAME’ category.
-- Include the number of reviews, most installations, and least reviews for each genre. 
SELECT Genres, 
    COUNT(Reviews) as [Number of Reviews],
	MAX (Installs) as [Highest Installations],
	MIN (Reviews) as [Least Reviews]
  FROM apps
  WHERE Category = 'GAME'
  GROUP BY Genres
  ORDER BY Genres;

SELECT Genres,  
       COUNT(*) [COUNT of Reviews],       
--   This is the aggregate function I wanted but I asked for "number of reviews" 
		MAX(Installs) [MAX of Installs],  
		MIN(Reviews) [MIN of Reviews] 
	FROM apps 
	WHERE Category = 'GAME' 
	GROUP BY Genres; 

-- How many different genres does each category have? List the categories and the
-- number of genres for each category. Sort the results from most genres to least genres.

SELECT Category,
		COUNT(Genres) [# of genres]
	FROM apps
	GROUP BY Category
	ORDER BY [# of genres] DESC;
	-- 34 rows, max 1972
SELECT Category,
		COUNT(DISTINCT Genres) [# of genres]
	FROM apps
	GROUP BY Category
	ORDER BY [# of genres] DESC;
	-- 34 rows, max 73

-- List the app name, current version, last updated date, review text, and sentiment for
-- all apps that have a ‘Neutral’ value for ‘Sentiment’. Sort the results by app name.

SELECT a.AppName,
	a.[Current Ver],
	a.[Last Updated],
	r.ReviewText,
	r.Sentiment
	FROM apps a JOIN reviews r ON
		a.AppName = r.AppName
	WHERE r.Sentiment = 'Neutral'
	ORDER BY a.AppName
	;

-- List the app name that would be alphabetically first as [first app] and the app name
-- that would be alphabetically last as [last app] from the apps table in a single result set. 
SELECT MIN(AppName) First,
		MAX(AppName) Last
	FROM apps
	;

-- Add a column to the reviews table named “Length of Review”. Set the data type to
-- integer. Allow NULL values to be stored in the column. Count the number of characters for each
-- review and store the number of characters in the new “Length of Review” column. How long is
-- the longest review? How long is the shortest review?

-- Make working copies

SELECT * INTO appsAnalysis FROM apps;
SELECT * INTO reviewsAnalysis FROM reviews;


ALTER TABLE reviewsAnalysis
ADD [Length of Review] INT null;

ALTER TABLE reviewsAnlysis
  ADD Trent varchar;

ALTER TABLE reviews
  ALTER COLUMN Trent varchar(500);

UPDATE reviewsAnalysis
	SET [Length of Review] = LEN(ReviewText);

SELECT MAX([Length of Review]) long,
		MIN([Length of Review]) short
	FROM reviewsAnalysis;
	-- long = 2737 character
	-- shortest has 0 characters

SELECT MAX([Length of Review]) long,
		MIN([Length of Review]) short
	FROM reviewsAnalysis;

ALTER TABLE reviewsAnalysis
	ADD [Cleaned_Sentiment_Polarity] NUMERIC(15,10) NULL;

SELECT Sentiment_Polarity,    
		COUNT(*) AS [Number of Reviews]    
	FROM reviewsAnalysis
	GROUP BY Sentiment_Polarity    
	ORDER BY [Number of Reviews] DESC;    

SELECT Sentiment_Polarity,    
		COUNT(*) AS [Number of Reviews]    
	FROM reviewsAnalysis
	GROUP BY Sentiment_Polarity    
	ORDER BY [Number of Reviews];   
	-- interesting NAN and 0

SELECT * FROM reviewsAnalysis
	WHERE Sentiment_Polarity = 'nan';   
	-- NAN show review length 3; where senttiment_polarity = nan, set sentiment columns to NULL and Review Length to 0

UPDATE reviewsAnalysis
	SET [Length of Review] = NULL WHERE ReviewText = 'nan';

--check updated with nulls
SELECT * FROM reviewsAnalysis WHERE Sentiment_Polarity = 'nan';

-- check 0 values
SELECT * FROM reviewsAnalysis WHERE Sentiment_Polarity = '0.0';

SELECT COUNT(Sentiment), COUNT(Sentiment_Polarity) 
	FROM reviewsAnalysis WHERE Sentiment_Polarity = '0.0';
-- values same = 5163; neutral is 0 polarity

SELECT * FROM reviewsAnalysis WHERE Sentiment_Polarity LIKE '%e%';
	-- 55 rows; all values are 10 to the -17 or 18; essentially 0
	-- need to change sentiment to neutral as well; verify with SME

-- update clean column with cleaned data
UPDATE reviewsAnalysis
	SET Cleaned_Sentiment_Polarity = CAST(LEFT(Sentiment_Polarity,10) AS numeric(15,10))
	WHERE Sentiment_Polarity <> 'nan' AND Sentiment_Polarity NOT LIKE '%e%';

SELECT * FROM reviewsAnalysis WHERE Sentiment_Polarity = '0.0';

SELECT COUNT(Sentiment), COUNT(Sentiment_Polarity) 
	FROM reviewsAnalysis WHERE Sentiment_Polarity = '0.0';
-- values same = 5163; neutral is 0 polarity

SELECT * FROM reviewsAnalysis WHERE Sentiment_Polarity LIKE '%e%';
-- nulls stil present for these near 0 values; 55 rows

-- update near 0 to 0
UPDATE reviewsAnalysis
	SET Cleaned_Sentiment_Polarity = 0
	WHERE Sentiment_Polarity LIKE '%e%';
	-- executed on 55 rows; ran preceeding query to verify


ALTER TABLE reviewsAnalysis
ADD Cleaned_Sentiment varchar(50) NULL;

UPDATE reviewsAnalysis
	SET Cleaned_Sentiment = Sentiment
	WHERE Sentiment <> 'nan';

-- verify
SELECT * FROM reviewsAnalysis WHERE Cleaned_Sentiment IS NOT NULL;
-- 37432 returned vs 64295

UPDATE reviewsAnalysis
	SET Cleaned_Sentiment = (CASE WHEN Sentiment_Polarity LIKE '%e%' THEN 'Neutral'
								-- use most restrictive first to exit
								WHEN Sentiment = 'Positive' THEN 'Positive'
								WHEN Sentiment = 'Negative' THEN 'Negative'
								WHEN Sentiment = 'Neutral' THEN 'Neutral'
								end);

-- verify
SELECT * FROM reviewsAnalysis
	WHERE Cleaned_Sentiment_Polarity = 0.0;
	-- 5218 rows are neutral and 0.0

SELECT * FROM reviewsAnalysis
	WHERE Sentiment = 'Positive';
-- positives match, 23998

SELECT * FROM reviewsAnalysis
	WHERE Sentiment = 'Negative';
-- negatives match; 8271

SELECT * FROM reviewsAnalysis
	WHERE Sentiment = 'nan';
-- null-nan match; 28863

SELECT DISTINCT Cleaned_Sentiment
	FROM reviewsAnalysis;
	-- 4 desired values

SELECT * FROM reviewsAnalysis;

-- Create a new table that includes the following columns from the apps and reviews
-- tables. Name the new table ‘Analysis_Apps_Reviews’.

SELECT a.AppName,
		a.Category,
		a.[Content Rating],
		a.Price,
		r.ReviewText,
		r.Cleaned_Sentiment,
		r.Cleaned_Sentiment_Polarity,
		r.[Length of Review]
	INTO Analysis_Apps_Reviews
	FROM reviewsAnalysis r JOIN appsAnalysis a ON
		r.AppName = a.AppName;

SELECT * FROM Analysis_Apps_Reviews;

-- Analyze the app names in the apps and reviews table. Does the apps table have apps
-- that are not in the reviews table? Does the reviews table have apps that are not in the apps
-- table? Randomly choose three app names (e.g., “10 Best Foods for You”, “Bubble Shooter”,
-- “Guns of Glory”, etc.) from the reviews table. Explore the reviews for these apps. Add comments
-- with any conclusions or recommendations you have regarding the app names data. 

SELECT * FROM appsAnalysis
	WHERE AppName NOT IN (SELECT DISTINCT AppName FROM reviewsAnalysis);
	-- 9306 records in apps table not in the reviews table

SELECT DISTINCT * FROM appsAnalysis
	WHERE AppName NOT IN (SELECT DISTINCT AppName FROM reviewsAnalysis);
	-- 9306
SELECT DISTINCT AppName FROM appsAnalysis
	WHERE AppName NOT IN (SELECT DISTINCT AppName FROM reviewsAnalysis);
	--8619 rows
-- reverse the search
SELECT * FROM reviewsAnalysis
	WHERE AppName NOT IN (SELECT DISTINCT AppName FROM appsAnalysis);
	-- 2739 reviews; lots of repeats

SELECT DISTINCT AppName FROM reviewsAnalysis
	WHERE AppName NOT IN (SELECT DISTINCT AppName FROM appsAnalysis);
	-- 54 rows not in the appsAnalysis table

SELECT DISTINCT AppName, MIN(Reviews)
	FROM appsAnalysis
	GROUP BY AppName;

SELECT AppName, COUNT(Reviews) RevCnt
	FROM appsAnalysis
	GROUP BY AppName
	ORDER BY RevCnt DESC;

SELECT AppName, COUNT(ReviewText) RevCnt
	FROM reviewsAnalysis
	GROUP BY AppName
	ORDER BY RevCnt DESC;

-- App selection
-- ROBLOX
-- Angry Birds Classic
-- Drawing Clothes Fashion Ideas

SELECT * 
	FROM appsAnalysis
	WHERE AppName = 'Angry Birds Classic';

SELECT * 
	FROM reviewsAnalysis
	WHERE AppName = 'Angry Birds Classic';

SELECT * 
	FROM appsAnalysis
	WHERE AppName = 'Angry Birds Classic'