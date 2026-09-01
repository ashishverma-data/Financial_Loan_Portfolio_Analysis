-- ============================================================
-- FINANCIAL LOAN ANALYSIS 
-- ============================================================
-- Database: MySQL 8.0+
-- Primary table: finance_data
--
-- BUSINESS OBJECTIVE
-- ------------------------------------------------------------
-- Evaluate loan portfolio size, recovery, profitability, credit
-- risk, borrower profile, loan purpose, geography, income, credit
-- characteristics, loan status, and risk categories to support
-- portfolio monitoring and lending decisions.
-- -----------------------------------------------------------
-- FINANCIAL LOAN ANALYSIS
-- Purpose:
--   Loan portfolio performance, profitability, recovery,
--   risk, customer profile, geographic, purpose, income,
--   credit and loan-status analysis.

-- Note:
--   Single-table analysis. No JOINs are required.

-- ============================================================
-- 01. DATABASE & TABLE SETUP
-- QUERY PURPOSE: Create the finance database and define the loan portfolio schema.
-- ============================================================
CREATE DATABASE Finance_DB;
USE Finance_DB;
CREATE TABLE finance_data (
Loan_ID VARCHAR (30) PRIMARY KEY,
Customer_ID VARCHAR (30),
Purpose_Category VARCHAR(50),
Purpose VARCHAR(50),
State VARCHAR(20),
Employment_Title  VARCHAR(200),
Employment_Level  VARCHAR(50),
Emp_Length_Years INT,
Home_Ownership VARCHAR(50),
Annual_Income INT,
Income_Group  VARCHAR(50),
Income_Verification_Status  VARCHAR(30),
Verified_Income_Flag  TINYINT,
Debt_to_Income_Ratio DECIMAL(10,3),
DTI_Category  VARCHAR(50),
Total_Credit_Account INT,
Loan_Amount INT,
Loan_Size_Category  VARCHAR(50),
Interest_Rate DECIMAL(10,3),
Interest_Rate_Category VARCHAR(50),
EMI_Amount DECIMAL(10,3),
Loan_Term_Months INT,
Loan_Term_Category VARCHAR(50),
Loan_Grade VARCHAR(2),
Loan_Sub_Grade VARCHAR(4),
Loan_Issue_Date DATE,
Last_Credit_Check_Date DATE,
Last_Payment_Date DATE,
Next_Payment_Due_Date DATE,
Loan_to_Income_Ratio DECIMAL(10,3),
EMI_to_Income_Ratio DECIMAL(10,3),
Total_Payment INT,
Loan_Recovered_Percent DECIMAL(10,3),
Loan_Recovery_Category VARCHAR(50),
Loan_Status VARCHAR(50),
Profit_Status VARCHAR(50),
Risk_Score DECIMAL(10,3),
Risk_Category VARCHAR(50),
Risk_Aggregation DECIMAL(10,3),
Data_Validation_Flag VARCHAR(50)
);
-- ============================================================
-- 02. DATA IMPORT & MYSQL CONFIGURATION
-- QUERY PURPOSE: Configure MySQL and import the cleaned financial loan dataset.
-- ============================================================
SET GLOBAL local_infile = 1;
SHOW GLOBAL VARIABLES LIKE 'local_infile';
LOAD DATA INFILE
'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/financial_loan.csv.csv'
INTO TABLE finance_data
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

-- ============================================================
-- 03. DATA STRUCTURE & QUALITY VALIDATION
-- QUERY PURPOSE: Validate loan identifiers, critical fields, and basic data completeness.
-- ============================================================
SELECT * FROM finance_data LIMIT 10;
SELECT COUNT(*) AS Total_Loans FROM finance_data;
SELECT Loan_ID,
	   COUNT(*) AS Duplicate_Count
FROM finance_data
GROUP BY Loan_ID
HAVING COUNT(*) > 1;
SELECT
    SUM(Loan_ID IS NULL) AS Missing_Loan_ID,
    SUM(Customer_ID IS NULL) AS Missing_Customer_ID,
    SUM(Loan_Amount IS NULL) AS Missing_Loan_Amount,
    SUM(Total_Payment IS NULL) AS Missing_Total_Payment
FROM finance_data;

-- ============================================================
-- 04. OVERALL LOAN PORTFOLIO KPI ANALYSIS
-- QUERY PURPOSE: Establish executive portfolio, risk, recovery, profitability, and borrower KPIs.
-- ============================================================
-- 04.01 Executive Overview KPIs
SELECT
COUNT(Loan_ID) AS Total_Loan,
SUM(Loan_Amount)AS Total_Loan_Amount,
SUM(Total_Payment)AS Total_Recovered_Amount,
ROUND(SUM(CASE WHEN Loan_Recovery_Category='Fully Recovered (≥100)' 
			THEN Total_Payment-Loan_Amount ELSE 0 END),0)AS Total_Interest_Received,
ROUND(ROUND(SUM(CASE WHEN Loan_Recovery_Category='Fully Recovered (≥100)' 
			THEN Total_Payment-Loan_Amount ELSE 0 END),0)*100/SUM(Loan_Amount),2) AS Profit_Margin,
ROUND(SUM(CASE WHEN Profit_Status="Loss" THEN 1 ELSE 0 END ),0) AS Loss_Loan_Cont,
ROUND(SUM(CASE WHEN Profit_Status="Loss" THEN 1 ELSE 0 END )*100/
			COUNT(Loan_ID),2) AS Loss_Loan_Rate,
ROUND(SUM(CASE WHEN Loan_Status="Charged Off" THEN 1 ELSE 0 END)*100/COUNT(Loan_ID),2) AS Charged_Off_Rate,
ROUND(SUM(CASE WHEN Risk_Category ="High"  THEN 1 ELSE 0 END),0) AS High_Risk_Loan,
ROUND(SUM(CASE WHEN Risk_Category ="High"  THEN 1 ELSE 0 END)*100/
			COUNT(Loan_ID),2) AS High_Risk_Cust_Rate
FROM finance_data ;

-- 04.02 Risk & category performance KPIs
SELECT 
ROUND(SUM(CASE WHEN Risk_Category ="High"  THEN 1 ELSE 0 END),0) AS High_Risk_Loan,
ROUND(SUM(CASE WHEN Risk_Category ="High"  THEN 1 ELSE 0 END)*100/
               COUNT(Loan_ID),2) AS High_Risk_Cust_Rate,
ROUND((AVG(Interest_Rate)*100),2)AS Avg_Interest_Rate,
ROUND((AVG(Debt_to_Income_Ratio)*100),2)AS Avg_DTI_Ratio ,
ROUND((AVG(Loan_to_Income_Ratio)*100),2)AS Avg_LTI_Ratio ,
ROUND((AVG(EMI_to_Income_Ratio)*100),2)AS Avg_EMI_TI_Ratio ,
ROUND(SUM(CASE WHEN Loan_Status="Charged Off" THEN 1 ELSE 0 END)*100/COUNT(Loan_ID),2) AS Charged_Off_Rate,
ROUND(SUM(CASE WHEN Verified_Income_Flag=0 THEN 1 ELSE 0 END)*100/COUNT(Loan_ID),2) AS Unverified_Loan
FROM finance_data ;

-- 04.03 Profitability & Recovery performance KPIs
SELECT
 ROUND(SUM(CASE WHEN Loan_Recovery_Category="Fully Recovered (≥100)"  THEN 1 ELSE 0 END),0) AS Profitable_Loan,
ROUND(SUM(CASE WHEN Loan_Recovery_Category="Fully Recovered (≥100)"  THEN 1 ELSE 0 END)*100/
               COUNT(Loan_ID),2) AS Profitable_Loan_Rate,
ROUND(SUM(CASE WHEN Loan_Recovery_Category="Fully Recovered (≥100)"  THEN 0 ELSE 1 END),0) AS Unrecovered_Loan,
ROUND(SUM(CASE WHEN Loan_Recovery_Category="Fully Recovered (≥100)"  THEN 0 ELSE 1 END)*100/
               COUNT(Loan_ID),2) AS Unrecovered_Loan_Rate,
ROUND(SUM(CASE WHEN Profit_Status="Loss" THEN 1 ELSE 0 END ),0) AS Loss_Loan_Cont,
ROUND(SUM(CASE WHEN Profit_Status="Loss" THEN 1 ELSE 0 END )*100/
               COUNT(Loan_ID),2) AS Loss_Loan_Rate,
SUM(Total_Payment)AS Total_Recovered_Amount,
ROUND(SUM(CASE WHEN Loan_Recovery_Category='Fully Recovered (≥100)' 
			     THEN Total_Payment-Loan_Amount ELSE 0 END),0)AS Interest_Received,
ROUND(ROUND(SUM(CASE WHEN Loan_Recovery_Category='Fully Recovered (≥100)' 
			     THEN Total_Payment-Loan_Amount ELSE 0 END),0)*100/SUM(Loan_Amount),2) AS Profit_Margin,
ROUND(SUM(Total_Payment)*100/
               SUM(Loan_Amount),2) AS Loan_Recovery_Rate,
ROUND(SUM(CASE WHEN Loan_Recovery_Category = "Fully Recovered (≥100)"  THEN 0 ELSE Loan_Amount-Total_Payment END),0) AS Unrecovered_Loan,
ROUND(SUM(CASE WHEN Loan_Recovery_Category = "Fully Recovered (≥100)"  THEN 0 ELSE Loan_Amount-Total_Payment END)*100/
               SUM(Loan_Amount),2) AS Unrecovered_Loan_Rate
FROM finance_data ;

-- 04.04 CUSTOMER & BORROWER PROFILE ANALYSIS KPIs
SELECT
COUNT(Customer_ID)AS Total_Customer,
ROUND(SUM(CASE WHEN Verified_Income_Flag<>0 THEN 1 ELSE 0 END),0) AS Verified_Borrower,
ROUND(SUM(CASE WHEN Verified_Income_Flag<>0 THEN 1 ELSE 0 END)*100/
               COUNT(Customer_ID),2) AS Verified_Borrower_Rate,
ROUND(AVG(Annual_Income),0)AS Avg_Annual_Income,
ROUND(AVG(Loan_Term_Months),0)AS Avg_Loan_Term,
ROUND(AVG(Emp_Length_Years),0)AS Avg_Emp_Year,
ROUND(SUM(CASE WHEN Home_Ownership<>"Rent" THEN 1 ELSE 0 END),0) AS Home_Owner_Cust,
ROUND(SUM(CASE WHEN Home_Ownership<>"Rent" THEN 1 ELSE 0 END)*100/
               COUNT(Customer_ID),2) AS Home_Ownership_Rate,
ROUND(AVG(Total_Credit_Account),0)AS Avg_Credit_Account
FROM finance_data ;

-- ============================================================
-- 05. LOAN RECOVERY & PROFITABILITY ANALYSIS
-- QUERY PURPOSE: Measure recovery performance, unrecovered balances, and profitability by status/category.
-- ============================================================
-- 05.01 Loan recovery category performance
SELECT Loan_Recovery_Category,
COUNT(Loan_ID) AS Total_Loan,
ROUND(COUNT(Loan_ID)*100/
           (SELECT COUNT(DISTINCT Customer_ID)
            FROM finance_data),2) AS Loan_Distribution,
SUM(Loan_Amount)AS Total_Loan_Amount,
ROUND(SUM(CASE WHEN Loan_Recovery_Category = "Fully Recovered (≥100)"  THEN 0 ELSE Loan_Amount-Total_Payment END),0) AS Unrecovered_Loan_Amount,
ROUND(SUM(CASE WHEN Loan_Recovery_Category = "Fully Recovered (≥100)"  THEN 0 ELSE Loan_Amount-Total_Payment END)*100/
               SUM(Loan_Amount),2) AS Unrecovered_Loan_Amount_Rate
FROM finance_data
GROUP BY Loan_Recovery_Category
ORDER BY Total_Loan DESC;

-- 05.02 Loan performance by loan status
SELECT Loan_Status,
COUNT(Loan_ID) AS Total_Loan,
ROUND(COUNT(Loan_ID)*100/
			(SELECT COUNT(DISTINCT Customer_ID)
            FROM finance_data),2) AS Loan_Distribution,
SUM(Loan_Amount)AS Total_Loan_Amount,
SUM(Total_Payment) AS Total_Recovered_Amount,
ROUND(SUM(CASE WHEN Loan_Recovery_Category='Fully Recovered (≥100)' 
			     THEN Total_Payment-Loan_Amount ELSE 0 END),0)AS Interest_Received,
ROUND(ROUND(SUM(CASE WHEN Loan_Recovery_Category='Fully Recovered (≥100)' 
			     THEN Total_Payment-Loan_Amount ELSE 0 END),0)*100/SUM(Loan_Amount),2) AS Profit_Margin
FROM finance_data
GROUP BY Loan_Status 
ORDER BY Total_Loan DESC;

-- 05.03 Profit status performance
SELECT Profit_Status,
COUNT(Loan_ID) AS Total_Loan,
ROUND(COUNT(Loan_ID)*100/
            (SELECT COUNT(DISTINCT Customer_ID)
            FROM finance_data),2) AS Loan_Distribution,
SUM(Loan_Amount)AS Total_Loan_Amount,
SUM(Total_Payment) AS Total_Recovered_Amount
FROM finance_data
GROUP BY Profit_Status
ORDER BY Total_Loan DESC;

-- ============================================================
-- 06. CUSTOMER & BORROWER PROFILE ANALYSIS
-- QUERY PURPOSE: Profile borrowers by income.
-- ============================================================
-- 06.01 Borrower income group analysis
SELECT 
    Income_Group,
    COUNT(Customer_ID) AS Cust_Count,
    ROUND( COUNT(DISTINCT Customer_ID) * 100.0 /
           (SELECT COUNT(DISTINCT Customer_ID)
            FROM finance_data),2) AS Customer_Distribution_Rate,
    ROUND(AVG(Debt_to_Income_Ratio) * 100, 2) AS Avg_DTI,
    ROUND(AVG(Loan_to_Income_Ratio) * 100, 2) AS Avg_LTI
FROM finance_data
GROUP BY Income_Group
ORDER BY Cust_Count DESC;

-- 06.02 Employment level analysis
SELECT 
    Employment_Level,
    COUNT(Customer_ID) AS Cust_Count,
    ROUND(COUNT(Customer_ID)*100/
            (SELECT COUNT(DISTINCT Customer_ID)
            FROM finance_data),2) AS Loan_Distribution,
    ROUND(AVG(Annual_Income), 0) AS Average_Annual_Income,
    ROUND(AVG(Emp_Length_Years), 1) AS Average_Employment_Years
FROM finance_data
GROUP BY Employment_Level
ORDER BY Cust_Count DESC;


-- ============================================================
-- 07. TIME & LOAN ISSUANCE ANALYSIS
-- QUERY PURPOSE: Analyze loan issuance and financial performance over time.
-- ============================================================
-- 07.01 Monthly loan issuance and financial performance
WITH 
Time_Analysis AS
       (SELECT *,
        MONTH(Loan_Issue_Date)AS Month_No,
	    DATE_FORMAT(Loan_Issue_Date, '%b') AS Month_
        FROM finance_data
        ORDER BY Loan_Issue_Date ASC)
SELECT Month_No, Month_,
COUNT(*) AS Total_Loans,
SUM(Loan_Amount)AS Total_Loan_Amount,
SUM(Total_Payment)AS Total_Recovered_Amount,
ROUND(SUM(CASE WHEN Loan_Recovery_Category='Fully Recovered (≥100)' 
			     THEN Total_Payment-Loan_Amount ELSE 0 END),0)AS Interest_Received,
ROUND(SUM(CASE WHEN Profit_Status='Loss' 
			     THEN Loan_Amount-Total_Payment ELSE 0 END),0)AS Loss_Amount,
ROUND(ROUND(SUM(CASE WHEN Loan_Recovery_Category='Fully Recovered (≥100)' 
			     THEN Total_Payment-Loan_Amount ELSE 0 END),0)*100/SUM(Loan_Amount),2) AS Profit_Margin,
ROUND(SUM(CASE WHEN Loan_Recovery_Category = "Fully Recovered (≥100)"  THEN 0 ELSE Loan_Amount-Total_Payment END),0) AS Unrecovered_Loan_Amount
FROM Time_Analysis
GROUP BY Month_No,Month_
ORDER BY Month_No ASC;
-- ============================================================
-- 08. LOAN GRADE & RISK ANALYSIS
-- QUERY PURPOSE: Evaluate portfolio performance across loan grades and risk categories.
-- ============================================================

-- 08.01 Loan grade performance
SELECT Loan_Grade,
COUNT(Loan_ID) AS Total_Loan,
SUM(Loan_Amount)AS Total_Loan_Amount,
ROUND(SUM(CASE WHEN Loan_Recovery_Category='Fully Recovered (≥100)' 
			     THEN Total_Payment-Loan_Amount ELSE 0 END),0)AS Interest_Received,
ROUND(ROUND(SUM(CASE WHEN Loan_Recovery_Category='Fully Recovered (≥100)' 
			     THEN Total_Payment-Loan_Amount ELSE 0 END),0)*100/SUM(Loan_Amount),2) AS Profit_Margin,
SUM(Total_Payment)AS Total_Recovered_Amount,
ROUND(SUM(CASE WHEN Profit_Status='Loss' 
			     THEN Loan_Amount-Total_Payment ELSE 0 END),0)AS Loss_Amount,
ROUND(SUM(CASE WHEN Loan_Recovery_Category = "Fully Recovered (≥100)"  THEN 0 ELSE Loan_Amount-Total_Payment END),0) AS Unrecovered_Loan_Amount,
ROUND(AVG(Risk_Score)*10,2) AS Avg_Risk_Score
FROM finance_data
GROUP BY Loan_Grade
ORDER BY Loan_Grade ASC;

-- 08.02 Risk category performance
SELECT Risk_Category,
COUNT(Loan_ID) AS Total_Loan,
ROUND(COUNT(Loan_ID)*100/
            (SELECT COUNT(DISTINCT Customer_ID)
            FROM finance_data),2) AS Loan_Distribution,
SUM(Loan_Amount)AS Total_Loan_Amount,
SUM(CASE WHEN Loan_Status="Charged Off" THEN 1 ELSE 0 END) AS Charged_Off,
ROUND(SUM(CASE WHEN Loan_Status="Charged Off" THEN 1 ELSE 0 END)*100/COUNT(Loan_ID),2) AS Charged_Off_Rate,
ROUND(ROUND(SUM(CASE WHEN Loan_Recovery_Category='Fully Recovered (≥100)' 
			     THEN Total_Payment-Loan_Amount ELSE 0 END),0)*100/SUM(Loan_Amount),2) AS Profit_Margin
FROM finance_data
GROUP BY Risk_Category
ORDER BY Total_Loan DESC;


-- 08.03 DTI category analysis
SELECT DTI_Category,
COUNT(Loan_ID) AS Total_Loan,
ROUND(COUNT(Loan_ID)*100/
            (SELECT COUNT(DISTINCT Customer_ID)
            FROM finance_data),2) AS Loan_Distribution,
SUM(Loan_Amount)AS Total_Loan_Amount,
ROUND(AVG(Debt_to_Income_Ratio) * 100, 2) AS Average_DTI_Percent,
ROUND(SUM(CASE WHEN Loan_Status="Charged Off" THEN 1 ELSE 0 END)*100/
      COUNT(Loan_ID),2) AS Charged_Off_Rate
FROM finance_data
GROUP BY DTI_Category
ORDER BY Total_Loan DESC;


-- ============================================================
-- 09. GEOGRAPHIC ANALYSIS
-- ============================================================

-- 09.01 State-level loan portfolio performance
SELECT State,
COUNT(*) AS Total_Loans,
COUNT(Customer_ID)AS Customer_Count,
SUM(Loan_Amount)AS Total_Loan_Amount,
SUM(Total_Payment) AS Total_Recovered_Amount,
ROUND(SUM(CASE WHEN Loan_Recovery_Category='Fully Recovered (≥100)' 
			     THEN Total_Payment-Loan_Amount ELSE 0 END),0)AS Interest_Received,
ROUND(ROUND(SUM(CASE WHEN Loan_Recovery_Category='Fully Recovered (≥100)' 
			     THEN Total_Payment-Loan_Amount ELSE 0 END),0)*100/SUM(Loan_Amount),2) AS Profit_Margin
FROM finance_data
GROUP BY State
ORDER BY Total_Loan_Amount DESC;


-- ============================================================
-- 10. LOAN PURPOSE ANALYSIS
-- ============================================================

-- 10.01 Purpose category performance
SELECT Purpose_Category,
COUNT(*) AS Total_Loans,
COUNT(Customer_ID)Total_Customer,
SUM(Loan_Amount)AS Total_Loan_Amount,
SUM(Total_Payment)AS Total_Recovered_Amount,
ROUND(SUM(CASE WHEN Loan_Recovery_Category='Fully Recovered (≥100)' 
			     THEN Total_Payment-Loan_Amount ELSE 0 END),0)AS Interest_Received,
ROUND(ROUND(SUM(CASE WHEN Loan_Recovery_Category='Fully Recovered (≥100)' 
			     THEN Total_Payment-Loan_Amount ELSE 0 END),0)*100/SUM(Loan_Amount),2) AS Profit_Margin,
ROUND(SUM(CASE WHEN Profit_Status='Loss' 
			     THEN Loan_Amount-Total_Payment ELSE 0 END),0)AS Loss_Amount,
ROUND(SUM(CASE WHEN Loan_Recovery_Category = "Fully Recovered (≥100)"  THEN 0 ELSE Loan_Amount-Total_Payment END),0) AS Unrecovered_Loan_Amount,
ROUND(AVG(Risk_Score)*10,2) AS Avg_Risk_Score
FROM finance_data
GROUP BY Purpose_Category
ORDER BY Total_Loan_Amount DESC;


-- 10.02 Top 3 loss-making purposes within each purpose category
WITH 
Loss_Purpose AS
     (SELECT Purpose_Category, Purpose, 
			ROUND(SUM(CASE WHEN Profit_Status='Loss' 
			     THEN Loan_Amount-Total_Payment ELSE 0 END),0)AS Loss_Amount
      FROM finance_data
      GROUP BY Purpose_Category, Purpose),
Ranked_Purpose AS
      (SELECT Purpose_Category, Purpose, Loss_Amount,
              ROW_NUMBER() OVER(PARTITION BY Purpose_Category
              ORDER BY Loss_Amount DESC) AS Loss_Purpose_Rank
       FROM Loss_Purpose)
SELECT Purpose_Category, Purpose, Loss_Amount,Loss_Purpose_Rank
FROM Ranked_Purpose
WHERE Loss_Purpose_Rank <=3
ORDER BY Purpose_Category, Purpose;
-- ============================================================
-- 12. FINAL FINANCIAL PORTFOLIO ANALYSIS
-- ============================================================
SELECT 
COUNT(Loan_ID) AS Loan_Count,
ROUND(SUM(CASE WHEN Loan_Recovery_Category="Fully Recovered (≥100)"  THEN 1 ELSE 0 END)*100/
               COUNT(Loan_ID),2) AS Profitable_Loan_Rate,
ROUND(SUM(CASE WHEN Loan_Recovery_Category="Fully Recovered (≥100)"  THEN 1 ELSE 0 END),0) AS Profitable_Loan,
ROUND(ROUND(SUM(CASE WHEN Loan_Recovery_Category='Fully Recovered (≥100)' 
			THEN Total_Payment-Loan_Amount ELSE 0 END),0)*100/SUM(Loan_Amount),2) AS Profit_Margin,
ROUND(SUM(CASE WHEN Profit_Status="Loss" THEN 1 ELSE 0 END ),0) AS Loss_Loan_Count,               
ROUND(SUM(CASE WHEN Profit_Status="Loss" THEN 1 ELSE 0 END )*100/
               COUNT(Loan_ID),2) AS Loss_Loan_Rate,
SUM(CASE WHEN Loan_Recovery_Category = "Fully Recovered (≥100)"  THEN 0 ELSE 1 END) AS Unrecovered_Loan_Count,
ROUND(SUM(CASE WHEN Loan_Recovery_Category = "Fully Recovered (≥100)"  THEN 0 ELSE Loan_Amount-Total_Payment END)*100/
               SUM(Loan_Amount),2) AS Unrecovered_Amount_Rate,
ROUND(SUM(CASE WHEN Risk_Category ="High"  THEN 1 ELSE 0 END),0) AS High_Risk_Loan,
SUM(CASE WHEN Loan_Status="Charged Off" THEN 1 ELSE 0 END) AS Charged_Off_Loan             
FROM finance_data;

-- ============================================================
-- END OF FINANCIAL LOAN ANALYSIS
-- ============================================================