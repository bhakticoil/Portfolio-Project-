SELECT *
FROM project..indian_food

-- we are going to do indian cuisine analysis 
--Now select the data we are going to be using 
--Lets count total vegetarian and non vegetarian diet 

SELECT
      COUNT(diet) AS total_count,
      COUNT(CASE WHEN diet = 'vegetarian'THEN 0 END) AS vegetarian_count,
	  COUNT(CASE WHEN diet = 'non vegetarian' THEN 0 END) AS non_vegetarian_count
FROM project..indian_food

--Now we are going to get proportion of vegetarian and non vegetarian diet 

SELECT      
      COUNT(CASE WHEN diet = 'vegetarian'THEN 1 END) AS vegetarian_count,
	  COUNT(CASE WHEN diet = 'non vegetarian' THEN 1 END) AS non_vegetarian_count,
	  COUNT(diet) AS total_count,
	  CAST(SUM(CASE WHEN diet = 'vegetarian' THEN 1 END) AS decimal)/ COUNT(diet)*100 AS proportion_vegetarian,
	  CAST(SUM(CASE WHEN diet = 'non vegetarian' THEN 1 END) AS decimal)/ COUNT(diet)*100 AS proportion_nonvegetarian
FROM project..indian_food

--We are going to find number of dishes based on region we are going to exclude null and -1 values.


SELECT region, COUNT(name) AS num_dishes
FROM project..indian_food
WHERE region IS NOT NULL AND region <> '-1'
GROUP BY region;


--Let's get State wise distribution of indian sweets

SELECT state, name, flavor_profile, course,COUNT(*) AS sweet_count
FROM project..indian_food
WHERE course='dessert'and state <> '-1'
GROUP BY state, name, flavor_profile, course
ORDER BY state ASC

-- Number of dishes based on courses of meal

SELECT course, COUNT(name) AS num_dishes
FROM project..indian_food
GROUP BY course
ORDER BY num_dishes ASC

-- Proportion of Flavor Profiles
SELECT flavor_profile, COUNT(*) AS count,
       ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) AS proportion
FROM project..indian_food
WHERE flavor_profile IN ('sweet', 'spicy', 'sour', 'bitter')
GROUP BY flavor_profile
ORDER BY proportion DESC

--Ingredient used in indain sweets 
SELECT ingredients, course
FROM project..indian_food
WHERE course='dessert'
GROUP BY ingredients, course

--Ingredient used in south indian cuisine


SELECT ingredients, course, region
FROM project..indian_food
WHERE region='South'
 

 --Ingredient used in north indian cuisine
 SELECT ingredients, course, region
FROM project..indian_food
WHERE region='North'

--Top 10 snacks with shortest cooking time

SELECT TOP 10 name,course, cook_time
FROM project..indian_food
WHERE course='snack' AND cook_time <>'-1'
ORDER BY cook_time ASC 

--Top 10 snacks with longest cooking time 
SELECT TOP 10 name,course, cook_time
FROM project..indian_food
WHERE course='snack' AND cook_time <>'-1'
ORDER BY cook_time DESC

--TOP 10 main course with shortest cooking time 


SELECT TOP 10 name,course, cook_time
FROM project..indian_food
WHERE course='main course' AND cook_time <>'-1'
ORDER BY cook_time ASC

--Top 10 main course with longest cooking time 


SELECT TOP 10 name,course, cook_time
FROM project..indian_food
WHERE course='main course' AND cook_time <>'-1'
ORDER BY cook_time DESC


--Creating View to store data for later visualization

CREATE VIEW veG_nonveg_diet_proportion AS
SELECT COUNT(CASE WHEN diet = 'vegetarian'THEN 1 END) AS vegetarian_count,
	  COUNT(CASE WHEN diet = 'non vegetarian' THEN 1 END) AS non_vegetarian_count,
	  COUNT(diet) AS total_count,
	  CAST(SUM(CASE WHEN diet = 'vegetarian' THEN 1 END) AS decimal)/ COUNT(diet)*100 AS proportion_vegetarian,
	  CAST(SUM(CASE WHEN diet = 'non vegetarian' THEN 1 END) AS decimal)/ COUNT(diet)*100 AS proportion_nonvegetarian
FROM project..indian_food


CREATE VIEW num_dishes_based_region AS
SELECT region, COUNT(name) AS num_dishes
FROM project..indian_food
WHERE region IS NOT NULL AND region <> '-1'
GROUP BY region;


CREATE VIEW state_wise_sweets AS
SELECT state, name, flavor_profile, course,COUNT(*) AS sweet_count
FROM project..indian_food
WHERE course='dessert'and state <> '-1'
GROUP BY state, name, flavor_profile, course
--ORDER BY state ASC;

CREATE VIEW proportion_flavor AS
SELECT flavor_profile, COUNT(*) AS count,
       ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) AS proportion
FROM project..indian_food
WHERE flavor_profile IN ('sweet', 'spicy', 'sour', 'bitter')
GROUP BY flavor_profile
--ORDER BY proportion DESC

CREATE VIEW ingredient_sweet AS
SELECT ingredients, course
FROM project..indian_food
WHERE course='dessert'
GROUP BY ingredients, course

CREATE VIEW top_10_snack_with_short_cooking_time AS
SELECT TOP 10 name,course, cook_time
FROM project..indian_food
WHERE course='snack' AND cook_time <>'-1'
--ORDER BY cook_time ASC 


CREATE VIEW top_10_maincourse_with_longest_time AS
SELECT TOP 10 name,course, cook_time
FROM project..indian_food
WHERE course='main course' AND cook_time <>'-1'
--ORDER BY cook_time DESC







 





     








     
	 



