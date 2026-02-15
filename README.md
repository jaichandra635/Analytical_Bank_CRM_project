Customer Churn & Retention Analytics Dashboard
Project Overview

This project presents a complete Customer Churn and Retention Analytics Dashboard built using MySQL and Power BI. The objective is to analyze customer behavior, identify churn drivers, segment high-risk customers, and provide strategic recommendations to improve retention and reduce revenue loss.

The solution integrates SQL-based data preparation with Power BI data modeling and dynamic DAX measures to create an interactive and business-ready dashboard.

Business Problem

Customer churn reduces long-term profitability and increases acquisition costs. The bank needs to understand:

What is happening with churn?

Why customers are leaving?

Where churn is concentrated?

Which customer segments are most at risk?

What strategic actions can reduce churn?

This dashboard provides a structured, data-driven approach to answering these questions.

Tools & Technologies Used

MySQL – Data import, cleaning, transformation, schema design

Power BI – Data modeling, DAX measures, interactive visualizations

DAX (Data Analysis Expressions) – Dynamic KPI calculations and segmentation logic

Data Model

The project follows a structured data modeling approach:

fact_customer_churn – Contains behavioral and financial metrics including churn flag, balance, credit score, tenure, number of products, activity status, etc.

dim_customer_info – Contains customer demographics such as age, geography, gender, estimated salary, and joining date.

Supporting dimension tables such as geography and gender.

Relationships were defined to ensure dynamic filtering and accurate aggregations across visuals.

Dashboard Structure

The dashboard consists of four analytical pages:

Page 1 – Executive Overview

Purpose: Provide a high-level summary of business health and churn distribution.

Layout:

| KPI | KPI | KPI | KPI | KPI |
| Churn by Geography | Customer Join Trend |
| Churn by Age Group | Churn by Gender |

SNIP1 - Page 1 Executive Overview

Key Metrics:

Total Customers

Total Churned

Churn Rate %

Average Balance

Average Tenure

Page 2 – Churn Drivers Analysis

Purpose: Identify the primary factors driving customer churn.

Layout:

| Driver KPI Strip |
| Credit Segment vs Churn |
| NumOfProducts vs Churn |
| Active Status vs Churn |
| Credit Card Impact |

SNIP2 - Page 2 Churn Drivers

Key Focus Areas:

Product ownership impact

Engagement level impact

Credit segment behavior

Activity status relationship with churn

Page 3 – Customer Segmentation & Risk Profiling

Purpose: Identify high-value and high-risk customer segments.

Layout:

| Segment KPI Strip |
| Avg Salary by Geography & Gender |
| Tenure Group vs Churn |
| Age Group vs Avg Balance |
| Salary vs Balance Distribution (Scatter) |

SNIP3 - Page 3 Customer Segmentation

Advanced Insights:

Revenue at Risk from churned customers

High income customer concentration

Early tenure vulnerability

Balance vs Salary behavioral distribution

Page 4 – Strategic Insights & Recommendations

Purpose: Convert analysis into actionable business strategy.

Layout:

| Risk Snapshot |
| Key Insights |
| Strategic Recommendations |

SNIP4 - Page 4 Strategic Insights

Key Insights

Overall churn rate is approximately 20%, representing significant revenue exposure through churned balances.

Customers in their first 0–2 years and those holding only one product show the highest churn probability.

Inactive customers churn significantly more than active members, indicating engagement as a critical retention driver.

Certain geographies demonstrate higher churn rates, suggesting regional strategy gaps.

High-income and high-balance customers are not immune to churn, emphasizing the importance of engagement beyond wealth segmentation.

Strategic Recommendations

Strengthen Early Lifecycle Retention
Implement structured onboarding programs and proactive engagement within the first two years.

Increase Product Stickiness
Introduce bundled financial products and incentives for multi-product ownership to reduce switching behavior.

Proactive Risk-Based Retention
Develop a churn risk scoring framework to identify high-risk customers early and trigger personalized retention offers.

Methodology

Imported and structured raw data in MySQL.

Created views and validated relationships.

Connected Power BI to MySQL.

Built star schema data model.

Created dynamic DAX measures.

Designed interactive dashboard with slicers and segmentation.

Key DAX Measures

Total Customers

Total Churned

Churn Rate %

Active Member %

Credit Card %

Revenue at Risk

Average Balance (Churned)

Tenure Group segmentation

All KPIs dynamically respond to user filters and slicers.

Business Impact

This dashboard enables:

Clear visibility into churn patterns

Identification of high-risk segments

Quantification of revenue exposure

Data-driven retention strategy development

Future Enhancements

Predictive churn modeling

Customer lifetime value estimation

Campaign effectiveness tracking

Automated churn risk alerts

Conclusion

This project demonstrates:

SQL data preparation and schema management

Power BI data modeling and DAX expertise

Business intelligence storytelling

Strategic insight generation

The dashboard provides a complete end-to-end churn analysis framework suitable for real-world banking applications.
