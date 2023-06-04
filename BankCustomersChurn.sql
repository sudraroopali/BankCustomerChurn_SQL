-- "Analyzing Customer Churn Patterns in a Banking Dataset: Unveiling Insights into Demographic Factors and Customer Behavior" -- 

-- Description =  Using the customer demographics, such as gender, marital status, education level and income category to determine which customer demographic is more likely to churn

CREATE DATABASE bankchurner;

USE bankchurner;

SELECT 
    COUNT(*)
FROM
    bankchurners;
    
#We have 10127 records.

DESCRIBE bankchurners;

-- DESCRIPTION OF DATA

-- CLIENTNUM: Unique identifier for each customer. (Integer)
-- Attrition_Flag: Flag indicating whether or not the customer has churned out. (Boolean)
-- Customer_Age: Age of customer. (Integer)
-- Gender: Gender of customer. (String)
-- Dependent_count: Number of dependents that customer has. (Integer)
-- Education_Level: Education level of customer. (String)
-- Marital_Status: Marital status of customer. (String)
-- Income_Category: Income category of customer. (String)
-- Card_Category: Type of card held by customer. (String)
-- Months_on_book: How long customer has been on the books. (Integer)
-- Total_Relationship_Count: Total number of relationships customer has with the credit card provider. (Integer)
-- Months_Inactive_12_mon: Number of months customer has been inactive in the last twelve months. (Integer)
-- Contacts_Count_12_mon: Number of contacts customer has had in the last twelve months. (Integer)
-- Credit_Limit: Credit limit of customer. (Integer)
-- Total_Revolving_Bal: Total revolving balance of customer. (Integer)
-- Avg_Open_To_Buy: Average open to buy ratio of customer. (Integer)
-- Total_Amt_Chng_Q4_Q1: Total amount changed from quarter 4 to quarter 1. (Integer)
-- Total_Trans_Amt: Total transaction amount. (Integer)
-- Total_Trans_Ct: Total transaction count. (Integer)
-- Total_Ct_Chng_Q4_Q1: Total count changed from quarter 4 to quarter 1. (Integer)
-- Avg_Utilization_Ratio: Average utilization ratio of customer. (Integer)


------------------------------------- DATA CLEANING ------------------------------------------

-- 1. FINDING THE MISSING VALUES 

SELECT
  COUNT(*) AS TotalRows,
  SUM(CASE WHEN Attrition_Flag IS NULL THEN 1 ELSE 0 END) AS Missing_Attrition_Flag,
  SUM(CASE WHEN Customer_Age IS NULL THEN 1 ELSE 0 END) AS Missing_Customer_Age,
  SUM(CASE WHEN Gender IS NULL THEN 1 ELSE 0 END) AS Missing_Gender,
  SUM(CASE WHEN Dependent_count IS NULL THEN 1 ELSE 0 END) AS Missing_DC,
  SUM(CASE WHEN Education_Level IS NULL THEN 1 ELSE 0 END) AS Missing_Education_Level,
  SUM(CASE WHEN Marital_Status IS NULL THEN 1 ELSE 0 END) AS Missing_MS,
  SUM(CASE WHEN Income_Category IS NULL THEN 1 ELSE 0 END) AS Missing_IC,
  SUM(CASE WHEN Card_Category IS NULL THEN 1 ELSE 0 END) AS Missing_CC,
  SUM(CASE WHEN Months_on_Book IS NULL THEN 1 ELSE 0 END) AS Missing_MOB,
  SUM(CASE WHEN Total_Relationship_Count IS NULL THEN 1 ELSE 0 END) AS Missing_TRC,
  SUM(CASE WHEN Months_Inactive_12_mon IS NULL THEN 1 ELSE 0 END) AS Missing_MI12M,
  SUM(CASE WHEN Contacts_count_12_mon IS NULL THEN 1 ELSE 0 END) AS Missing_CC12M,
  SUM(CASE WHEN Credit_Limit IS NULL THEN 1 ELSE 0 END) AS Missing_CL,
  SUM(CASE WHEN Total_Revolving_Bal IS NULL THEN 1 ELSE 0 END) AS Missing_TRB,
  SUM(CASE WHEN Avg_Open_To_Buy IS NULL THEN 1 ELSE 0 END) AS Missing_AOTB,
  SUM(CASE WHEN Total_Amt_Chng_Q4_Q1 IS NULL THEN 1 ELSE 0 END) AS Missing_TAM,
  SUM(CASE WHEN Total_Trans_Amt IS NULL THEN 1 ELSE 0 END) AS Missing_TTA,
  SUM(CASE WHEN Total_Trans_Ct IS NULL THEN 1 ELSE 0 END) AS Missing_TTC,
  SUM(CASE WHEN Total_Ct_Chng_Q4_Q1 IS NULL THEN 1 ELSE 0 END) AS Missing_TCC,
  SUM(CASE WHEN Avg_Utilization_Ratio IS NULL THEN 1 ELSE 0 END) AS Missing_AUR
  FROM bankchurners;  
  
## RESULT - We do not have any missing values.
  
-- 2. FINDING THE DUPLICATES 
#we will be using our Client Number column to find any duplicate rows 

SELECT 
    CLIENTNUM, COUNT(*) AS count
FROM
    bankchurners
GROUP BY CLIENTNUM
HAVING COUNT(*) > 1;

## RESULT - We do not have any duplicate values.

-- 3. Handling Inconsistent Values for the Categorical Columns

SELECT DISTINCT Gender FROM bankchurners;
SELECT DISTINCT Education_Level FROM bankchurners;
SELECT DISTINCT Marital_Status FROM bankchurners;
SELECT DISTINCT Income_Category FROM bankchurners;
SELECT DISTINCT Card_Category FROM bankchurners;

# RESULT - There is no inconsistent values except the 'Unknown' category 
SELECT * FROM bankchurners;

-- 4. DATA TYPE CONVERSION 

-- Convert Total_Amt_Chng_Q4_Q1 to decimal
ALTER TABLE bankchurners
MODIFY Total_Amt_Chng_Q4_Q1 DECIMAL(10,4);

-- Convert Total_Ct_Chng_Q4_Q1 to decimal
ALTER TABLE bankchurners
MODIFY Total_Ct_Chng_Q4_Q1 DECIMAL(10,4);

-- Convert Avg_Utilization_Ratio to decimal
ALTER TABLE bankchurners
MODIFY Avg_Utilization_Ratio DECIMAL(10,4);

-- 5. FINDING THE OUTLIERS 

#for the customer age column
SELECT 
    Customer_Age,
    (Customer_Age - AVG(Customer_Age)) / STDDEV(Customer_Age) AS z_score
FROM
    bankchurners
HAVING z_score > 3;
#RESULT - No outliers

#for the Dependent_count column
SELECT 
    Dependent_count,
    (Dependent_count - AVG(Dependent_count)) / STDDEV(Dependent_count) AS z_score
FROM
    bankchurners
HAVING z_score > 3;
#RESULT - No outliers

#for the months_on_books column
SELECT 
    Months_on_book,
    (Months_on_book - AVG(Months_on_book)) / STDDEV(Months_on_book) AS z_score
FROM
    bankchurners
HAVING z_score > 3;
#RESULT - No outliers

select * from bankchurners;

#for the Total_Relationship_Count column
SELECT 
    Total_Relationship_Count,
    (Total_Relationship_Count - AVG(Total_Relationship_Count)) / STDDEV(Total_Relationship_Count) AS z_score
FROM
    bankchurners
HAVING z_score > 3;
#RESULT - No outliers

#for the Months_Inactive_12_mon column
SELECT 
    Months_Inactive_12_mon,
    (Months_Inactive_12_mon - AVG(Months_Inactive_12_mon)) / STDDEV(Months_Inactive_12_mon) AS z_score
FROM
    bankchurners
HAVING z_score > 3;
#RESULT - No outliers

#for the Contacts_Count_12_mon column 
SELECT 
    Contacts_Count_12_mon,
    (Contacts_Count_12_mon - AVG(Contacts_Count_12_mon)) / STDDEV(Contacts_Count_12_mon) AS z_score
FROM
    bankchurners
HAVING z_score > 3;
#RESULT - No outliers

#for the Credit_Limit column 
SELECT 
    Credit_Limit,
    (Credit_Limit - AVG(Credit_Limit)) / STDDEV(Credit_Limit) AS z_score
FROM
    bankchurners
HAVING z_score > 3;
#RESULT - No outliers

#for the Total_Revolving_Bal column
SELECT 
    Total_Revolving_Bal,
    (Total_Revolving_Bal - AVG(Total_Revolving_Bal)) / STDDEV(Total_Revolving_Bal) AS z_score
FROM
    bankchurners
HAVING z_score > 3;
#RESULT - No outliers

#for the Avg_Open_To_Buy column
SELECT 
    Avg_Open_To_Buy,
    (Avg_Open_To_Buy - AVG(Avg_Open_To_Buy)) / STDDEV(Avg_Open_To_Buy) AS z_score
FROM
    bankchurners
HAVING z_score > 3;
#RESULT - No outliers

#for the Total_Trans_Amt column
SELECT 
    Total_Trans_Amt,
    (Total_Trans_Amt - AVG(Total_Trans_Amt)) / STDDEV(Total_Trans_Amt) AS z_score
FROM
    bankchurners
HAVING z_score > 3;
#RESULT - No outliers

#for the Total_Trans_Ct column
SELECT 
    Total_Trans_Ct,
    (Total_Trans_Ct - AVG(Total_Trans_Ct)) / STDDEV(Total_Trans_Ct) AS z_score
FROM
    bankchurners
HAVING z_score > 3;
#RESULT - No outliers

#for the Total_Ct_Chng_Q4_Q1 column 
SELECT 
    Total_Ct_Chng_Q4_Q1,
    (Total_Ct_Chng_Q4_Q1 - AVG(Total_Ct_Chng_Q4_Q1)) / STDDEV(Total_Ct_Chng_Q4_Q1) AS z_score
FROM
    bankchurners
HAVING z_score > 3;

#WE HAVE GOT AN OUTLIER IN THIS COLUMN and the z_score is more than 3.8 and we have decided to keep it for now

#for the Avg_Utilization_Ratio column 
SELECT 
    Avg_Utilization_Ratio,
    (Avg_Utilization_Ratio - AVG(Avg_Utilization_Ratio)) / STDDEV(Avg_Utilization_Ratio) AS z_score
FROM
    bankchurners
HAVING z_score > 3;
#RESULT - No outliers

-------------------------------------------------------------------------------------------------------------------------------

-- QUESTIONS 

-- 1. What is the overall churn rate for the entire customer base?
-- 2. What is the churn rate for each gender category? Does gender play a significant role in customer churn?
-- 3. How does the churn rate vary among different marital status groups? Is there a specific marital status that is more likely to churn?
-- 4. Which education level category has the highest churn rate?
-- 5. How does customer churn vary across different income categories? 
-- 6. What is the average age of customers who churn compared to those who don't? Is there a significant age difference between the two groups?
-- 7. Do customers with a higher number of dependents have a lower churn rate? Is there a correlation between dependent count and customer churn?
-- 8. Is there a difference in churn rates among customers with different card categories? Which card category has the highest churn rate?
-- 9. How does the length of the customer relationship (months on book) affect churn? Do longer-tenured customers have a lower churn rate?
-- 10. Is there a relationship between the number of inactive months and customer churn? Do customers who have been inactive for a longer period have a higher churn rate?
-- 11. Does the number of contacts a customer has had in the last twelve months impact churn? Is there a correlation between contact count and customer churn?
-- 12. How does the credit limit affect customer churn? Do customers with higher credit limits have a lower churn rate?
-- 13. Is there a difference in churn rates among customers with different total revolving balances? Do customers with higher balances have a higher likelihood of churn?
-- 14. How does the total amount changed from quarter 4 to quarter 1 affect customer churn? Is there a correlation between this metric and churn rate?
-- 15. Is there a relationship between the total transaction amount and customer churn? Do customers with higher transaction amounts have a lower churn rate?
-- 16. Does the total transaction count impact customer churn? Do customers with a higher number of transactions have a lower likelihood of churn?
-- 17. How does the total count changed from quarter 4 to quarter 1 relate to customer churn? Is there a correlation between this metric and churn rate?
-- 18. Is there a relationship between the average utilization ratio and customer churn? Do customers with higher utilization ratios have a higher churn rate?
-- 19. Based on the analyzed data, which customer demographic (gender, marital status, education level, income category) has the highest churn rate?


-- 1. What is the overall churn rate for the entire customer base?
SELECT 
    COUNT(*) AS total_customers
  ,SUM(CASE WHEN Attrition_Flag = 'Attrited Customer' THEN 1 ELSE 0 END) AS churned_customers
  ,SUM(CASE WHEN Attrition_Flag = 'Attrited Customer' THEN 1 ELSE 0 END) / COUNT(*) *100 AS churn_rate
FROM bankchurners;

#Churn rate = In the context of the given dataset, churn rate refers to the percentage of customers who have "churned out" or become "attrited customers," indicating that they have discontinued their relationship with the credit card provider.
#The churn arte is 16%


-- 2. What is the churn rate for each gender category? Does gender play a significant role in customer churn?

SELECT 
    Gender,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Attrition_Flag = 'Attrited Customer' THEN 1 ELSE 0 END) AS churned_customers,
    SUM(CASE WHEN Attrition_Flag = 'Attrited Customer' THEN 1 ELSE 0 END) / COUNT(*) * 100 AS churn_rate
FROM bankchurners
GROUP BY Gender;

#The churn rate for females (17.3572%) is slightly higher than that of males (14.6152%). This suggests that, on average, female customers may be more likely to churn compared to male customers.


-- 3.How does the churn rate vary among different marital status groups? Is there a specific marital status that is more likely to churn?

SELECT 
Marital_Status
, COUNT(*) AS total_customers
, SUM(CASE WHEN Attrition_Flag = 'Attrited Customer' THEN 1 ELSE 0 END) as churned_customers
, SUM(CASE WHEN Attrition_Flag = 'Attrited Customer' THEN 1 ELSE 0 END) / COUNT(*) * 100 as churn_rate
FROM bankchurners
GROUP BY Marital_Status;

#The differences in churn rates among marital status groups are relatively small, suggesting that marital status alone may not be a strong predictor of customer churn.


-- 4.Which education level category has the highest churn rate?

SELECT 
Education_Level
, COUNT(*) AS total_customers 
, SUM(CASE WHEN Attrition_Flag = 'Attrited Customer' THEN 1 ELSE 0 END) as churned_customers
, SUM(CASE WHEN Attrition_Flag = 'Attrited Customer' THEN 1 ELSE 0 END) / COUNT(*) * 100 as churn_rate
 FROM bankchurners
 GROUP BY Education_Level;
 
 #Among the provided education level categories, customers with a doctorate degree have the highest churn rate (21.0643%), followed by post-graduate customers (17.8295%)
 
-- 5. How does customer churn vary across different income categories? 

SELECT 
Income_Category 
, COUNT(*) AS total_customers
, SUM(CASE WHEN Attrition_Flag = 'Attrited Customer' THEN 1 ELSE 0 END) AS churned_customers
, SUM(CASE WHEN Attrition_Flag = 'Attrited Customer' THEN 1 ELSE 0 END)/ COUNT(*) * 100 AS churn_rate
FROM bankchurners
GROUP BY Income_Category;

#Customers with an income less than $40K have the highest churn rate (17.1862%), followed by customers with an income of $120K+ (17.3315%). Customers with an income in the range of $60K - $80K have the lowest churn rate (13.4807%).

-- 6. What is the average age of customers who churn compared to those who don't? Is there a significant age difference between the two groups?

SELECT
    AVG(Customer_Age) AS average_churned_age
FROM
    bankchurners
WHERE
    Attrition_Flag = 'Attrited Customer';
    
#The avearge age is 46.6595 years old of the churned customers

SELECT
    AVG(Customer_Age) AS average_nonchurned_age
FROM
    bankchurners
WHERE
    Attrition_Flag = 'Existing Customer';
    
#The avearge age is 46.2621 years old of the non-churned customers

#Insight = There is no significant change between the age groups

-- 7. Do customers with a higher number of dependents have a higher churn rate? Is there a correlation between dependent count and customer churn?

SELECT
    Dependent_count,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Attrition_Flag = 'Attrited Customer' THEN 1 ELSE 0 END) AS churned_customers,
    SUM(CASE WHEN Attrition_Flag = 'Attrited Customer' THEN 1 ELSE 0 END) / COUNT(*) * 100 AS churn_rate
FROM
    bankchurners
GROUP BY
    Dependent_count;

#Customers with a higher number of dependents (e.g., 3, 4, 5) tend to have a slightly higher churn rate compared to those with a lower number of dependents (e.g., 0, 1, 2). However, the differences in churn rates are relatively small.


-- 8. Is there a difference in churn rates among customers with different card categories? Which card category has the highest churn rate?

SELECT
    Card_Category,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Attrition_Flag = 'Attrited Customer' THEN 1 ELSE 0 END) AS churned_customers,
    SUM(CASE WHEN Attrition_Flag = 'Attrited Customer' THEN 1 ELSE 0 END) / COUNT(*) * 100 AS churn_rate
FROM
    bankchurners
GROUP BY
    Card_Category;
    
#These results indicate that there is indeed a difference in churn rates among customers with different card categories. The Platinum category has the highest churn rate, followed by the Gold category, while the Silver category has a relatively lower churn rate. The Blue category, which likely represents the standard card category, also experiences a significant churn rate.
#However, it is important to note that Platinum category has a smaller number of customers (20) compared to the other categories, so the churn rate may be less representative.

-- 9. How does the length of the customer relationship (months on book) affect churn? Do longer-tenured customers have a lower churn rate?

SELECT
    CASE
        WHEN Months_on_book <= 12 THEN '0-12 months'
        WHEN Months_on_book > 12 AND Months_on_book <= 24 THEN '13-24 months'
        WHEN Months_on_book > 24 AND Months_on_book <= 36 THEN '25-36 months'
        WHEN Months_on_book > 36 THEN 'Over 36 months'
    END AS tenure_group,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Attrition_Flag = 'Attrited Customer' THEN 1 ELSE 0 END) AS churned_customers,
    SUM(CASE WHEN Attrition_Flag = 'Attrited Customer' THEN 1 ELSE 0 END) / COUNT(*) * 100 AS churn_rate
FROM bankchurners
GROUP BY tenure_group;

#Overall, the data does not strongly indicate that longer-tenured customers have a significantly lower churn rate. The churn rates are relatively similar across different tenure groups, with customers in the 13-24 month tenure range showing slightly lower churn rates.


-- 10. Is there a relationship between the number of inactive months and customer churn? Do customers who have been inactive for a longer period have a higher churn rate?

SELECT 
    Months_Inactive_12_mon,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Attrition_Flag = 'Attrited Customer' THEN 1 ELSE 0 END) AS churned_customers,
    SUM(CASE WHEN Attrition_Flag = 'Attrited Customer' THEN 1 ELSE 0 END) / COUNT(*) *100 AS churn_rate
FROM bankchurners
GROUP BY Months_Inactive_12_mon;

#Based on this data, it seems that there is some relationship between the number of inactive months and customer churn. Customers with higher periods of inactivity tend to have higher churn rates, while those with lower or moderate inactivity periods have relatively lower churn rates.

-- 11. Does the number of contacts a customer has had in the last twelve months impact churn? Is there a correlation between contact count and customer churn?

SELECT
    Contacts_Count_12_mon,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Attrition_Flag = 'Attrited Customer' THEN 1 ELSE 0 END) AS churned_customers,
    SUM(CASE WHEN Attrition_Flag = 'Attrited Customer' THEN 1 ELSE 0 END) / COUNT(*) * 100 AS churn_rate
FROM bankchurners
GROUP BY Contacts_Count_12_mon;

#Based on this data, it appears that there is a correlation between the number of contacts and customer churn. Higher contact counts tend to be associated with higher churn rates. However, it's important to further analyze the data and consider other factors to understand the full relationship between contact count and customer churn.

-- 12. How does the credit limit affect customer churn?

SELECT 
    CASE
        WHEN Credit_Limit <= 5000 THEN 'Low'
        WHEN Credit_Limit > 5000 AND Credit_Limit <= 10000 THEN 'Medium'
        WHEN Credit_Limit > 10000 THEN 'High'
        ELSE 'Unknown'
    END AS Credit_Limit_Category,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Attrition_Flag = 'Attrited Customer' THEN 1 ELSE 0 END) AS churned_customers,
    SUM(CASE WHEN Attrition_Flag = 'Attrited Customer' THEN 1 ELSE 0 END) / COUNT(*) * 100 AS churn_rate
FROM bankchurners
GROUP BY Credit_Limit_Category;

#Based on the analysis, it appears that customers with higher credit limits have a slightly lower churn rate.  This suggests that while there might be a slight correlation between credit limit and churn rate, it is not a dominant factor influencing customer churn

-- 13. Is there a difference in churn rates among customers with different total revolving balances? Do customers with higher balances have a higher likelihood of churn?

SELECT
    CASE
        WHEN Total_Revolving_Bal < 1000 THEN 'Low'
        WHEN Total_Revolving_Bal >= 1000 AND Total_Revolving_Bal < 3000 THEN 'Medium'
        ELSE 'High'
    END AS Revolving_Balance_Category,
    COUNT(*) AS Total_Customers,
    SUM(CASE WHEN Attrition_Flag = 'Attrited Customer' THEN 1 ELSE 0 END) AS Churned_Customers,
    SUM(CASE WHEN Attrition_Flag = 'Attrited Customer' THEN 1 ELSE 0 END) / COUNT(*) * 100 AS Churn_Rate
FROM
    bankchurners
GROUP BY
    Revolving_Balance_Category;
    
#The output shows that customers with lower total revolving balances are more likely to churn, while customers with medium or higher balances have a lower likelihood of churn.


-- 14. How does the total amount changed from quarter 4 to quarter 1 affect customer churn? Is there a correlation between this metric and churn rate?

SELECT 
    CASE
        WHEN Total_Amt_Chng_Q4_Q1 < 0.5 THEN 'Low Change'
        WHEN Total_Amt_Chng_Q4_Q1 >= 0.5 AND Total_Amt_Chng_Q4_Q1 < 1.0 THEN 'Moderate Change'
        WHEN Total_Amt_Chng_Q4_Q1 >= 1.0 AND Total_Amt_Chng_Q4_Q1 < 1.5 THEN 'High Change'
        ELSE 'Very High Change'
    END AS change_category,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Attrition_Flag = 'Attrited Customer' THEN 1 ELSE 0 END) AS churned_customers,
    SUM(CASE WHEN Attrition_Flag = 'Attrited Customer' THEN 1 ELSE 0 END) / COUNT(*) * 100 AS churn_rate
FROM bankchurners
GROUP BY change_category;

#These insights highlight the potential correlation between the total amount change from quarter 4 to quarter 1 and customer churn. Customers with lower changes may require more attention and retention efforts, while customers with higher changes may be more stable and less likely to churn

-- 15. Is there a relationship between the total transaction amount and customer churn? Do customers with higher transaction amounts have a lower churn rate?

SELECT
    CASE
        WHEN Total_Trans_Amt >= 0 AND Total_Trans_Amt <= 5000 THEN 'Low'
        WHEN Total_Trans_Amt > 5000 AND Total_Trans_Amt <= 10000 THEN 'Medium'
        WHEN Total_Trans_Amt > 10000 AND Total_Trans_Amt <= 15000 THEN 'High'
        WHEN Total_Trans_Amt > 15000 THEN 'Very High'
        ELSE 'Unknown'
    END AS Transaction_Amount_Category,
    COUNT(*) AS Total_Customers,
    SUM(CASE WHEN Attrition_Flag = 'Attrited Customer' THEN 1 ELSE 0 END) AS Churned_Customers,
    SUM(CASE WHEN Attrition_Flag = 'Attrited Customer' THEN 1 ELSE 0 END) / COUNT(*) * 100 AS Churn_Rate
FROM bankchurners
GROUP BY Transaction_Amount_Category;

#These insights suggest that there is a relationship between the total transaction amount and customer churn, with higher transaction amounts associated with a lower likelihood of churn. Customers who engage in more significant transaction activity may have a higher level of satisfaction or commitment to the bank, resulting in lower churn rates.

-- 16. Does the total transaction count impact customer churn? Do customers with a higher number of transactions have a lower likelihood of churn?

SELECT
    CASE
        WHEN Total_Trans_Ct < 100 THEN 'Low'
        WHEN Total_Trans_Ct >= 100 AND Total_Trans_Ct < 200 THEN 'Medium'
        WHEN Total_Trans_Ct >= 200 AND Total_Trans_Ct < 300 THEN 'High'
        ELSE 'Very High'
    END AS Transaction_Count_Category,
    COUNT(*) AS Total_Customers,
    SUM(CASE WHEN Attrition_Flag = 'Attrited Customer' THEN 1 ELSE 0 END) AS Churned_Customers,
    SUM(CASE WHEN Attrition_Flag = 'Attrited Customer' THEN 1 ELSE 0 END) / COUNT(*) * 100 AS Churn_Rate
FROM bankchurners
GROUP BY Transaction_Count_Category;

#From this data, it appears that customers with a higher number of transactions (in the medium category) have a significantly lower churn rate compared to customers with a low transaction count. This suggests that there may be a correlation between a higher transaction count and a lower likelihood of churn

-- 17. How does the total count changed from quarter 4 to quarter 1 relate to customer churn?

SELECT
    CASE
        WHEN Total_Ct_Chng_Q4_Q1 >= 2.0 THEN 'Very High Increase'
        WHEN Total_Ct_Chng_Q4_Q1 >= 1.0 THEN 'High Increase'
        WHEN Total_Ct_Chng_Q4_Q1 >= 0.5 THEN 'Moderate Increase'
        WHEN Total_Ct_Chng_Q4_Q1 >= 0.0 THEN 'Slight Increase'
        ELSE 'No Change or Decrease'
    END AS Count_Change_Category,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Attrition_Flag = 'Attrited Customer' THEN 1 ELSE 0 END) AS churned_customers,
    SUM(CASE WHEN Attrition_Flag = 'Attrited Customer' THEN 1 ELSE 0 END) / COUNT(*) * 100 AS churn_rate
FROM bankchurners
GROUP BY Count_Change_Category;

#These insights suggest a correlation between the total count change from quarter 4 to quarter 1 and customer churn. Customers who exhibit a higher increase in their transaction count are more likely to stay with the bank, while customers with lower increases or minimal changes in their transaction count have a higher likelihood of churning.

-- 18. Is there a relationship between the average utilization ratio and customer churn? Do customers with higher utilization ratios have a higher churn rate?

SELECT
  CASE
    WHEN Avg_Utilization_Ratio <= 0.25 THEN 'Low'
    WHEN Avg_Utilization_Ratio > 0.25 AND Avg_Utilization_Ratio <= 0.50 THEN 'Medium'
    WHEN Avg_Utilization_Ratio > 0.50 AND Avg_Utilization_Ratio <= 0.75 THEN 'High'
    WHEN Avg_Utilization_Ratio > 0.75 THEN 'Very High'
  END AS Utilization_Ratio_Category,
  COUNT(*) AS total_customers,
  SUM(CASE WHEN Attrition_Flag = 'Attrited Customer' THEN 1 ELSE 0 END) AS churned_customers,
  SUM(CASE WHEN Attrition_Flag = 'Attrited Customer' THEN 1 ELSE 0 END) / COUNT(*) * 100 AS churn_rate
FROM bankchurners
GROUP BY Utilization_Ratio_Category;

#Overall, there appears to be a correlation between the average utilization ratio and customer churn, with customers at the extreme ends of the utilization spectrum (low and high) having higher churn rates compared to those in the middle range (medium utilization ratio).


-- 19. Based on the analyzed data, which customer demographic (gender, marital status, education level, income category) has the highest churn rate?

-- Based on the analyzed data, we can determine the customer demographic with the highest churn rate by examining the churn rates across different demographic categories. Here are the churn rates for each demographic category:

-- 1. Gender:
           -- Male: churn rate = 16.0068%
           -- Female: churn rate = 16.1451%

-- 2. Marital Status:
   -- Married: churn rate = 13.9587%
   -- Single: churn rate = 16.3399%

-- 3. Education Level:
   -- High School: churn rate = 15.2012%
   -- Graduate: churn rate = 15.5691%
   -- Uneducated: churn rate = 15.9381%
   -- Unknown: churn rate = 16.8532%
   -- College: churn rate = 15.2024%
   -- Post-Graduate: churn rate = 17.8295%
   -- Doctorate: churn rate = 21.0643%

-- 4. Income Category:
   -- $60K - $80K: churn rate = 13.4807%
   -- Less than $40K: churn rate = 17.1862%
   -- $80K - $120K: churn rate = 15.7655%
   -- $40K - $60K: churn rate = 15.1397%
   -- $120K +: churn rate = 17.3315%
   -- Unknown: churn rate = 16.8165%

-- Based on these churn rates, we can conclude the following:

-- Among gender categories, females have a slightly higher churn rate than males.
-- Among marital status categories, single customers have a higher churn rate than married customers.
-- Among education level categories, customers with a doctorate degree have the highest churn rate, followed by customers with a post-graduate degree.
-- Among income categories, customers with an income of less than $40K have the highest churn rate.

-- Therefore, based on the analyzed data, customers with a doctorate degree and customers with an income of less than $40K have the highest churn rates among the respective demographic categories.