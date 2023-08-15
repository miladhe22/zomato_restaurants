-- Question 1 : Total number of restaurants in each city
select city , count(city) as TotalRestaurants
from zomato z
group by z.city
order by TotalRestaurants desc


-- question 2 : Average cost of food per country
select cc.country , avg(average_cost_for_two) as avg_cost
from zomato z
join country_code cc
on cc.country_code = z.country_code
group by cc.country
order by avg_cost desc;


-- question 3 : Display total votes and average points according to each color of points in each country
SELECT c.country, rating_color,
       SUM(votes) AS TotalVotes, AVG(aggregate_rating) AS AvgRating
FROM zomato z
JOIN country_code c
ON z.country_code = c.country_code
GROUP BY c.country, rating_color;




--question 4 : SELECT Locality, COUNT(*) AS TotalRestaurants
SELECT locality, COUNT(*) AS TotalRestaurants
FROM zomato
GROUP BY locality
HAVING COUNT(*) > 50
ORDER BY TotalRestaurants DESC;




-- question 5 : Average rating of restaurants in each country
select cc.country , avg(z.aggregate_rating) as avg_rating
from zomato z
join country_code cc
on cc.country_code = z.country_code
group by cc.country
order by avg_rating desc


-- question 6 : The names of the restaurants that have the highest cost of food in each region
with MaxCostPerLocality as(
	select locality , max(average_cost_for_two) as MaxCost
	from zomato z 
	group by locality
)
select z.locality , z.restaurant_name , z.average_cost_for_two
from zomato z
JOIN MaxCostPerLocality l
ON z.locality = l.Locality
WHERE z.average_cost_for_two = l.MaxCost;



--question 7 : Restaurants that are in the top five percent in terms 
-- of rating points in each city:
with CityTop5Percent as(
	select city, restaurant_name, aggregate_rating,
	percent_rank() over(partition by city order by aggregate_rating desc) as RatingPercent
	from zomato
)
select city , restaurant_name, aggregate_rating, RatingPercent
from CityTop5Percent
WHERE RatingPercent <= 0.05;



-- question 8 : The number of restaurants whose average cost of food in each city
-- is higher than the average cost of food in the whole country:
WITH AvgCostPerCity AS (
    SELECT city, AVG(average_cost_for_two) AS AvgCost
    FROM zomato
    GROUP BY city
),
AvgCostPerCountry AS (
    SELECT c.country_code, AVG(z.average_cost_for_two) AS AvgCost
    FROM zomato z
    JOIN country_code c 
	ON z.country_code = c.country_code
    GROUP BY c.country_code
)
SELECT z.restaurant_name, z.city, z.average_cost_for_two,
       c.AvgCost AS Country_Avg_Cost, cc.AvgCost AS City_Avg_Cost
FROM zomato z
JOIN AvgCostPerCity cc
ON z.City = cc.city
JOIN AvgCostPerCountry c 
ON z.country_code = c.country_code
WHERE cc.AvgCost > c.AvgCost;


-- question 9 : Display the name of the restaurants, the city and the status of their 
--online order
SELECT restaurant_name, City,
       CASE WHEN has_online_delivery = 'Yes' AND has_table_booking = 'Yes' THEN 'Both'
            WHEN has_online_delivery = 'Yes' THEN 'Online'
            WHEN has_table_booking = 'Yes' THEN 'Table Booking'
            ELSE 'None' 
			END AS OrderStatus
FROM zomato;


