-- Data Exploration & Quality
select * from customer_table;
-- Total customers are in the dataset:
SELECT COUNT(*) FROM customer_table;
-- Distribution across churned vs. retained customers
SELECT
  (SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END)/count(churn))*100 AS churned_rate,
  (SUM(CASE WHEN Churn = 'No' THEN 1 ELSE 0 END)/count(churn))*100 AS retained_rate
FROM customer_table;

-- Customer tenure range
SELECT MIN(tenure) AS min_tenure, MAX(tenure) AS max_tenure FROM customer_table;

-- Find Missing values
SELECT * FROM customer_table WHERE TotalCharges IS NULL OR MonthlyCharges IS NULL;


-- Data Cleaning

-- No. of missing values in TotalCharges
SELECT COUNT(*) AS missing_totalcharges
FROM customer_table
WHERE TotalCharges IS NULL OR TRIM(TotalCharges) = '';

-- Check Duplicate entries
SELECT COUNT(*) FROM customer_table GROUP BY customerid HAVING COUNT(*) > 1;

--Check any invalid entries
SELECT * FROM customer_table WHERE customerid IS NULL;
SELECT * FROM customer_table WHERE MonthlyCharges IS NULL;
SELECT * FROM customer_table WHERE TotalCharges < MonthlyCharges;
SELECT * FROM customer_table WHERE tenure = 0 AND Churn = 'No';
/* The customers with tenure=0 means they’ve just joined and have not completed one billing cycle.  We can also observe that these are the same rows with missing Total charges and haven’t been billed yet.*/

--Fill missing values
SELECT
  CASE
    WHEN TRIM(TotalCharges) = '' OR TotalCharges IS NULL THEN 0
    ELSE CAST(TotalCharges AS FLOAT)
  END AS TotalCharges_Cleaned
FROM customer_table;

--Data Transformation / Aggregation
-- Creating a summary table to capture per customer:
CREATE TABLE customer_summary AS
SELECT customerID, tenure, MonthlyCharges, TotalCharges FROM customer_table;

-- Count of services subscribed :
SELECT
  SUM(CASE WHEN PhoneService = 'Yes' THEN 1 ELSE 0 END) AS phonesubs,
  SUM(CASE WHEN InternetService <> 'No' THEN 1 ELSE 0 END) AS internetsubs,
  SUM(CASE WHEN OnlineSecurity = 'Yes' THEN 1 ELSE 0 END) AS olsecuritysubs,
  SUM(CASE WHEN OnlineBackup = 'Yes' THEN 1 ELSE 0 END) AS olbackupsubs,
  SUM(CASE WHEN StreamingTV = 'Yes' THEN 1 ELSE 0 END) AS TVsubs,
  SUM(CASE WHEN StreamingMovies = 'Yes' THEN 1 ELSE 0 END) AS Moviesubs
FROM customer_table;


-- Count of customers based onContract type, payment method
SELECT contract, COUNT(*) AS customers FROM customer_table GROUP BY contract;
SELECT PaymentMethod, COUNT(*) AS customers FROM customer_table GROUP BY PaymentMethod;


 -- Descriptive Churn Analytics
-- Overall churn rate:
SELECT (SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) * 100) / COUNT(churn) AS churn_rate from customer_table;

-- Average monthly charge and total charges for churned vs. non-churned groups.
SELECT
 churn,
  AVG(MonthlyCharges) AS avg_monthlycharges,
  AVG(CAST(TotalCharges AS FLOAT)) AS avg_totalcharges
FROM customer_table
GROUP BY Churn;

--Churn rate by contract type 

SELECT contract, (SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) * 100) / COUNT(churn) AS churn_rate
FROM customer_table
GROUP BY contract;

--Churn rate across internet service types and payment methods.
SELECT
  InternetService, PaymentMethod,
  (SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) * 100) / COUNT(churn) AS churn_rate
FROM customer_table
GROUP BY InternetService, PaymentMethod
order by churn_rate desc;

-- Analyze churn by service combinations
WITH service_bundles AS (
    SELECT 
        customerID,
        churn,
        CASE 
            WHEN PhoneService = 'Yes' AND InternetService != 'No' THEN 'Phone + Internet'
            WHEN PhoneService = 'Yes' AND InternetService = 'No' THEN 'Phone Only'
            WHEN PhoneService = 'No' AND InternetService != 'No' THEN 'Internet Only'
            ELSE 'No Services'
        END AS service_bundle,
        (CASE WHEN OnlineSecurity = 'Yes' THEN 1 ELSE 0 END) +
        (CASE WHEN OnlineBackup = 'Yes' THEN 1 ELSE 0 END) +
        (CASE WHEN DeviceProtection = 'Yes' THEN 1 ELSE 0 END) +
        (CASE WHEN TechSupport = 'Yes' THEN 1 ELSE 0 END) +
        (CASE WHEN StreamingTV = 'Yes' THEN 1 ELSE 0 END) +
        (CASE WHEN StreamingMovies = 'Yes' THEN 1 ELSE 0 END) AS addon_services_count
    FROM customer_table
)
SELECT 
    service_bundle,
    addon_services_count,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(100.0 * SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS churn_rate
FROM service_bundles
GROUP BY service_bundle, addon_services_count
ORDER BY churn_rate DESC;

-- Having Tech support can effect churn?
SELECT
  TechSupport,
  (SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) * 100) / COUNT(churn) AS churn_rate
FROM customer_table
GROUP BY TechSupport;

-- Cohort & Temporal Analysis
--Monthly churn rate over tenure
SELECT
  Tenure,
  (SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) * 100) / COUNT(churn) AS churn_rate
FROM customer_table
GROUP BY Tenure
ORDER BY Tenure;

-- Comparing churn rate with tenure segments
SELECT
  CASE
    WHEN tenure <= 6 THEN 'Less tenure'
    WHEN tenure > 24 THEN 'High Tenure'
  END AS tenure_seg,
  (SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) * 100) / COUNT(churn) AS churn_rate
FROM customer_table
GROUP BY tenure_seg;

 -- Combine Behavioral Insights
-- Correlation of services with churn:
SELECT
  StreamingMovies,
  StreamingTV,
  COUNT(CASE WHEN churn = 'Yes' THEN 1 END) AS churned,
  (SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) * 100) / COUNT(churn) AS churn_rate
FROM customer_table
GROUP BY StreamingMovies, StreamingTV
ORDER BY churn_rate;

--Churn rate by demographics
SELECT
  SeniorCitizen, Partner, Dependents,
  COUNT(*) AS total_customers,
  COUNT(CASE WHEN churn = 'Yes' THEN 1 END) AS churned,
  (SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) * 100) / COUNT(*) AS churn_rate
FROM customer_table
GROUP BY SeniorCitizen, Partner, Dependents
ORDER BY churn_rate DESC;
SELECT
  gender,
  SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) AS churned
FROM customer_table
GROUP BY gender;

--Risk-based churn categories

/*“At Risk” = month-to-month + no tech support + fiber internet
Medium Risk= month-to-month + notech suppot/fiber optics+ <6months tenure
Low risk= One/two year contract + tech support+DSL */

SELECT
  contract,
  Internetservice,
  techsupport,
  tenure,
  CASE
    WHEN contract = 'Month-to-month' AND internetservice = 'Fiber optic' AND techsupport = 'No' THEN 'At Risk'
    WHEN contract = 'Month-to-month' AND (internetservice = 'Fiber optic' OR techsupport = 'No') AND tenure < 6 THEN 'Medium risk'
    WHEN contract = 'One year' AND internetservice = 'DSL' AND techsupport = 'Yes' AND tenure > 12 THEN 'Low risk'
    ELSE 'No risk'
  END AS risk_categories
FROM customer_table;


--Top 3 risk factor combinations
SELECT
  internetservice,
  techsupport,
  tenure,
  paymentmethod,
  contract,
  COUNT(*) AS total_customers,
  (SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) * 100) / COUNT(churn) AS churn_rate
FROM customer_table
GROUP BY internetservice, techsupport, tenure, paymentmethod, contract
HAVING COUNT(*) > 10
ORDER BY churn_rate DESC;

-- 5. CHURN PREDICTION SCORE view
-
CREATE VIEW churn_prediction_score AS
SELECT 
    customerID,
    churn,
    (CASE WHEN tenure <= 6 THEN 3 WHEN tenure <= 12 THEN 2 ELSE 1 END) +
    (CASE WHEN Contract = 'Month-to-month' THEN 3 WHEN Contract = 'One year' THEN 2 ELSE 1 END) +
    (CASE WHEN PaymentMethod = 'Electronic check' THEN 2 ELSE 1 END) +
    (CASE WHEN TechSupport = 'No' THEN 2 ELSE 1 END) +
    (CASE WHEN InternetService = 'Fiber optic' THEN 2 ELSE 1 END) +
    (CASE WHEN PaperlessBilling = 'Yes' THEN 1 ELSE 0 END) +
    (CASE WHEN SeniorCitizen = 1 THEN 1 ELSE 0 END) +
    (CASE WHEN Partner = 'No' AND Dependents = 'No' THEN 1 ELSE 0 END) AS churn_risk_score
FROM customer_table;
-- key tasks performed and insights
-- 1. overview
-- 2. overall churn rate = 26 percent
-- 3. data cleaning
-- 4. 72 months highest tenure
-- 5. phone subscribers and internet subscribers are most,monthly customers and its churn is higher and whose monthly charges are also higher churns more,
-- 6. phone +internet without other services churns more
-- 7. internet service is fiber and payment type electronic check has highest churn
-- 8. higher tenure less churn
-- 9. streaming movies and streaming tv who has opted for both churs less
-- 10. male females churns equally
-- 11. senior citizens churns more and if dependents are there or partner is there it decreases
-- 12. top 3 risk factors categories
-- 13. churn score












