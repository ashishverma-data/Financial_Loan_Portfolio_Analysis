# Financial Loan Portfolio Analysis 💰

## Project Overview

This project analyzes a financial loan portfolio using an end-to-end data analytics workflow.

**Workflow:** Excel → Power Query → Power BI → MySQL

**Objective:** Evaluate portfolio performance, recovery, profitability, credit risk, borrower characteristics and geographic concentration to support data-driven lending decisions.

**Dataset:** 38,576 loan records from the Financial Loan Dataset.

---

## Tools Used

- Excel
- Power Query
- Power BI
- MySQL
- SQL

---

## Project Workflow

### Data Preparation

Performed:

- Data cleaning and standardization
- Data type transformation
- Duplicate and data quality checks
- Feature engineering
- Income, loan size, employment and term classification
- Recovery and profitability calculations
- Risk and affordability segmentation
- Date-quality validation

**Final Dataset:** 38,576 rows × 40 columns

### Data Modeling & Dashboard

Power BI was used for data modeling, analytical measures and interactive dashboard development.

The dashboard contains **4 analytical pages**:

- Executive Overview
- Risk & Credit Analysis
- Profitability & Recovery Analysis
- Borrower Profile

Analysis includes portfolio performance, loan grades, risk, recovery, profitability, borrower income, DTI/LTI, purpose and geography.

---

## Key KPIs

| KPI | Value |
|---|---:|
| Total Loans | **38,576** |
| Total Loan Amount | **$435.8M** |
| Total Payments Received | **$473.1M** |
| Interest Earned | **$71.4M** |
| Profit Margin | **16.4%** |
| Recovery Rate | **108.6%** |
| Unrecovered Amount | **$34.1M** |
| Charged-Off Rate | **13.8%** |
| High-Risk Loans | **7,873 (20.4%)** |

---

## Key Insights

- **Personal loans** dominate the portfolio with approximately **77%** of total loan value.
- **84.8%** of loans are classified as fully recovered.
- **High-risk loans** account for **20.4%** of the portfolio.
- Charged-off rate increases from **5.7% in Grade A** to **31.3% in Grade G**.
- Project-defined margin increases from **8.8% in Grade A** to **28.5% in Grade G**.
- **Business-purpose loans** have the highest charged-off rate at **25.6%**.
- **California** has the highest portfolio value at approximately **$78.5M**.
- **December** records the highest issuance volume with **4,314 loans** and **$54.0M** issued.
- **15,453 records (40.1%)** are flagged for date-quality issues where payment dates precede loan issue dates.

---

## SQL Validation

MySQL was used as an independent validation and analytical layer.

Performed:

- Data structure and quality validation
- Duplicate and missing-value checks
- Portfolio KPI reconciliation
- Recovery and profitability analysis
- Loan grade and risk analysis
- Borrower and income analysis
- Monthly portfolio analysis
- Geographic and purpose analysis
- Loss-making purpose ranking

**SQL concepts:** Aggregations, `CASE`, `GROUP BY`, CTEs,  window functions(`ROW_NUMBER()`), conditional analysis and indexing.

---

## Project Structure

```
Financial-Loan-Portfolio-Analysis/

├── 01_Raw_Data
│   └── Original loan dataset
├── 02_Cleaned_Data
│   └── Cleaned and engineered dataset
├── 03_SQL
│   └── SQL validation & analysis queries
├── 04_Power_BI
│   └── Power BI dashboard (.pbix)
├── 05_Screenshots
│   └── Dashboard & Power Query evidence
├── 06_Project_Report
│   └── Professional project documentation
└── README.md
```

## Skills Demonstrated

- Excel
- Data Cleaning
- Power Query
- Feature Engineering
- Data Quality Validation
- Data Modeling
- DAX / Measures
- Power BI
- Dashboard Development
- SQL / MySQL
- Financial Analysis
- Credit Risk Analysis
- Portfolio Analysis
- Business Intelligence
- Business Reporting

## Conclusion

This project demonstrates an end-to-end financial analytics workflow using Excel, Power Query, Power BI and MySQL to transform loan-level data into actionable insights across portfolio performance, recovery, profitability, credit risk and borrower segments.

## Project Information

**Project Title:** Financial Loan Portfolio Analysis  
**Project Type:** End-to-End Data Analytics & Business Intelligence Project  
**Tools Used:** Excel | Power Query | Power BI | MySQL  
**Dataset:** Financial Loan Dataset — DataWithAryan  
**Portfolio Records:** 38,576
