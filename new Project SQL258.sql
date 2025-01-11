
USE ShoppingTrends;
GO

SELECT *
FROM shopping_trends

--- Where clause

SELECT *
FROM shopping_trends
WHERE Customer_ID = 308

SELECT Customer_ID, 
       Item_Purchased, 
       Age,
       Location, 
       Season, 
       Payment_Method, 
       Frequency_of_Purchases
FROM shopping_trends
WHERE Gender = 'male' and Size = 's'

SELECT Customer_ID, 
       Age, 
	   Purchase_Amount_USD
FROM shopping_trends
WHERE  Category IN ('Accessories','Footwear','Outerwear') and Gender = 'Female'

SELECT *
FROM shopping_trends
WHERE Season LIKE 'W%' 

--- Aggregate Function

SELECT Gender, 
       AVG(Age) AS Average_age
FROM shopping_trends
GROUP BY  Gender

SELECT Gender, 
       Item_Purchased, 
	   max(Age) AS maximum_age, 
	   COUNT(Customer_ID) AS Total_Customer
FROM shopping_trends
GROUP BY  Gender,Item_Purchased

SELECT *
FROM shopping_trends
ORDER BY  2, 4 DESC


SELECT Category, AVG(Purchase_Amount_USD)
FROM shopping_trends
WHERE Age > 50 and Gender = 'Female'
GROUP BY Category
HAVING AVG(Purchase_Amount_USD) >= 50

---self join

SELECT st1.Customer_ID, 
       st1.Age, 
	   st1.Frequency_of_Purchases, 
	   st1.Season, 
	   st2.Customer_ID AS Customer_ID, 
	   st2.Age AS Customer_Age, 
	   st2.Frequency_of_Purchases AS Purchase_history, 
	   st2.Season AS Season_of_the_year
FROM shopping_trends st1 JOIN shopping_trends st2 ON st1.Customer_ID = st2.Customer_ID

----UNION

SELECT Gender
FROM shopping_trends
UNION ALL
SELECT Item_Purchased
FROM shopping_trends


---case statement

SELECT 
    Customer_ID, 
    Frequency_of_Purchases, 
    Age,
CASE 
        WHEN Age <= 30 and Frequency_of_purchases = 'Weekly' THEN 'TrendFollower'
        WHEN Age >= 31 and Frequency_of_purchases = 'Annually' THEN 'Oldies'
        ELSE 'Normal' 
END AS Fashion_Follower
FROM 
    shopping_trends

	
---- CTE common table expression

WITH CTE_AmountSpent AS (
    SELECT 
        sho.Item_Purchased, 
        SUM(sho.Purchase_Amount_USD) AS sum_dollarSpent
    FROM 
        shopping_trends sho
    GROUP BY 
        sho.Item_Purchased
)
SELECT 
    SUM(sum_dollarSpent) AS total_amount_spent
FROM 
    CTE_AmountSpent;

-- Create the temporary table

CREATE TABLE #Amount_spent_over_50
(
     Customer_ID INT NOT NULL,
	 DollarSpent Varchar(50) NOT NULL,
	 Item_Purchased Varchar(50) NOT NULL
)

INSERT INTO #Amount_spent_over_50 (Customer_ID, DollarSpent,Item_Purchased) VALUES (1, 20, 'Dress'), (2, 60, 'jacket')

SELECT *
FROM #Amount_spent_over_50

---let's create stored procedure

GO
CREATE PROC sp_shoppingbasedOnLocation
AS
BEGIN 
   SELECT *
   FROM shopping_trends
   WHERE Location LIKE 'LO%'
END;

EXEC sp_shoppingbasedOnLocation

-----stored procedure with parameters

CREATE PROC sp_shoppingbasedOnCatagory
 @Catagory nvarchar(50)
AS
BEGIN 
   SELECT *
   FROM shopping_trends
   WHERE Category = 'clothing'
END;

EXEC sp_shoppingbasedOnCatagory @Catagory = 'clothing'

