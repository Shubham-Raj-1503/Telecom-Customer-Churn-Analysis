# 📊 Customer Churn Analysis

<div align="center">

![SQL](https://img.shields.io/badge/SQL-Analysis-blue?style=for-the-badge&logo=postgresql&logoColor=white)
![Status](https://img.shields.io/badge/Status-Complete-success?style=for-the-badge)
![License](https://img.shields.io/badge/License-MIT-yellow?style=for-the-badge)

**A comprehensive SQL-based analysis to identify customer churn patterns, risk factors, and actionable insights for retention strategies.**

[Key Findings](#-key-findings) • [Analysis Overview](#-analysis-overview) • [Risk Framework](#-risk-framework) • [Getting Started](#-getting-started)

</div>

---

## 🎯 Project Overview

Customer churn is one of the biggest challenges for subscription-based businesses. This project performs an **end-to-end churn analysis** using SQL to uncover:

- 📈 **Churn Patterns** – Understanding who leaves and why
- 🔍 **Risk Indicators** – Identifying at-risk customers before they churn
- 💡 **Actionable Insights** – Data-driven recommendations for retention

---

## 📌 Key Findings

| Metric | Value | Insight |
|--------|-------|---------|
| **Overall Churn Rate** | 26% | ~1 in 4 customers churn |
| **Highest Risk Contract** | Month-to-month | Significantly higher churn than annual contracts |
| **Tenure Impact** | Higher tenure = Lower churn | Retention efforts should focus on early months |
| **Max Tenure** | 72 months | Long-term customers show strong loyalty |

### 🔥 Top Churn Drivers

```
┌─────────────────────────────────────────────────────────────┐
│  1. 📡 Fiber Optic + Electronic Check Payment = Highest Churn │
│  2. 📱 Phone + Internet (No Add-ons) = High Churn            │
│  3. 👴 Senior Citizens without Partners/Dependents           │
│  4. ⏱️  Low Tenure (< 6 months) Customers                    │
│  5. 🚫 No Tech Support Subscription                          │
└─────────────────────────────────────────────────────────────┘
```

---

## 📂 Analysis Overview

### 1️⃣ Data Exploration & Quality
- Dataset inspection and customer count
- Churn vs. retention distribution
- Tenure range analysis
- Missing value identification

### 2️⃣ Data Cleaning & Transformation
- Handling missing `TotalCharges` values
- Duplicate detection
- Invalid entry validation
- Customer summary table creation

### 3️⃣ Descriptive Churn Analytics
- Overall churn rate calculation
- Average charges comparison (churned vs. retained)
- Churn rate by:
  - 📋 Contract type
  - 🌐 Internet service type
  - 💳 Payment method
  - 📦 Service bundles

### 4️⃣ Cohort & Temporal Analysis
- Monthly churn rate over tenure
- Tenure segmentation analysis
- Behavioral patterns identification

### 5️⃣ Demographic Analysis
- Churn by senior citizen status
- Impact of partner/dependents
- Gender-based analysis

---

## ⚠️ Risk Framework

A custom **Churn Risk Score** model categorizes customers:

| Risk Level | Criteria | Action Required |
|------------|----------|-----------------|
| 🔴 **At Risk** | Month-to-month + Fiber Optic + No Tech Support | Immediate intervention |
| 🟠 **Medium Risk** | Month-to-month + (Fiber OR No Tech Support) + < 6 months tenure | Proactive engagement |
| 🟢 **Low Risk** | 1-2 year contract + DSL + Tech Support + > 12 months tenure | Maintain relationship |

### Churn Prediction Score Components

```sql
Risk Score = Tenure Factor + Contract Factor + Payment Factor + 
             Tech Support Factor + Internet Factor + Paperless Factor + 
             Senior Factor + Family Factor
```

---

## 📊 Dataset

**File:** `Churn.csv`

| Column | Description |
|--------|-------------|
| `customerID` | Unique customer identifier |
| `gender` | Customer gender |
| `SeniorCitizen` | Whether customer is senior (1/0) |
| `Partner` | Has partner (Yes/No) |
| `Dependents` | Has dependents (Yes/No) |
| `tenure` | Months with company |
| `PhoneService` | Phone service subscription |
| `InternetService` | Internet service type |
| `OnlineSecurity` | Online security add-on |
| `OnlineBackup` | Online backup add-on |
| `TechSupport` | Tech support subscription |
| `StreamingTV` | Streaming TV subscription |
| `StreamingMovies` | Streaming movies subscription |
| `Contract` | Contract type |
| `PaymentMethod` | Payment method |
| `MonthlyCharges` | Monthly charges |
| `TotalCharges` | Total charges to date |
| `Churn` | Customer churned (Yes/No) |

---

## 🚀 Getting Started

### Prerequisites
- Any SQL database (MySQL, PostgreSQL, SQLite, SQL Server)
- Import capability for CSV files

### Setup

1. **Clone the repository**
   ```bash
   git clone https://github.com/Shubham-Raj-1503/churn-analysis.git
   ```

2. **Import the dataset**
   ```sql
   -- Create table and import Churn.csv as customer_table
   CREATE TABLE customer_table (...);
   ```

3. **Run the analysis**
   ```bash
   # Execute the SQL script
   source churn_analysis.sql
   ```

---

## 💡 Business Recommendations

Based on the analysis:

| Strategy | Target Segment | Expected Impact |
|----------|----------------|-----------------|
| **Loyalty Programs** | Month-to-month customers | Convert to annual contracts |
| **Tech Support Bundles** | Fiber optic users | Reduce friction & churn |
| **Early Engagement** | Customers < 6 months | Prevent early churn |
| **Senior Outreach** | Senior citizens | Personalized support |
| **Family Plans** | Singles without dependents | Increase stickiness |

---

## 📈 Future Enhancements

- [ ] Machine learning churn prediction model
- [ ] Interactive dashboard (Tableau/Power BI)
- [ ] Customer lifetime value (CLV) analysis
- [ ] A/B testing framework for retention strategies

---

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

<div align="center">

**⭐ Star this repository if you found it helpful!**

Made with ❤️ and SQL

</div>
