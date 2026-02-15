#**Customer Churn and Retention Analytics Dashboard**#

Project Overview
This project presents a complete Customer Churn and Retention Analytics Dashboard built using MySQL and Power BI. The objective is to analyze customer behavior, identify churn drivers, segment high-risk customers, and provide strategic recommendations to improve retention and reduce revenue loss.

The solution integrates SQL-based data preparation with Power BI data modeling and dynamic DAX measures to create an interactive and business-ready dashboard.

Business Problem
Customer churn reduces long-term profitability and increases acquisition costs. The bank needs to understand:
- What is happening with churn?
- Why customers are leaving?
- Where churn is concentrated?
- Which customer segments are most at risk?
- What strategic actions can reduce churn?

Tools and Technologies Used
- MySQL – Data import, cleaning, transformation, schema design
- Power BI – Data modeling, DAX measures, interactive visualizations
- DAX – Dynamic KPI calculations and segmentation logic

Data Model
The project follows a structured data modeling approach:

fact_customer_churn – Contains behavioral and financial metrics including churn flag, balance, credit score, tenure, number of products, activity status.

dim_customer_info – Contains customer demographics such as age, geography, gender, estimated salary, and joining date.

Relationships were defined to ensure dynamic filtering and accurate aggregations across visuals.

Dashboard Structure

Page 1 – Executive Overview
Purpose: Provide a high-level summary of business health and churn distribution.

<img width="1307" height="720" alt="image" src="https://github.com/user-attachments/assets/7e7b26d2-7647-4159-b679-cb2e4f9817af" />

Key Metrics:
- Total Customers
- Total Churned
- Churn Rate Percentage
- Average Balance
- Average Tenure

Page 2 – Churn Drivers Analysis
Purpose: Identify the primary factors driving customer churn.

Layout:
Driver KPI Strip
Credit Segment vs Churn
Number of Products vs Churn
Active Status vs Churn
Credit Card Impact

<img width="1300" height="730" alt="image" src="https://github.com/user-attachments/assets/8616d93b-8509-4d57-b322-654afd475d17" />


Page 3 – Customer Segmentation and Risk Profiling
Purpose: Identify high-value and high-risk customer segments.

Layout:
Segment KPI Strip
Average Salary by Geography and Gender
Tenure Group vs Churn
Age Group vs Average Balance
Salary vs Balance Distribution (Scatter Plot)

<img width="1293" height="735" alt="image" src="https://github.com/user-attachments/assets/9f324071-1ee9-401f-a38d-bbe810aaf42a" />


Page 4 – Strategic Insights and Recommendations
Purpose: Convert analysis into actionable business strategy.

Layout:
Risk Snapshot
Key Insights
Strategic Recommendations

<img width="1249" height="692" alt="image" src="https://github.com/user-attachments/assets/f7ac7d22-80d0-405a-b419-69423443869d" />


Strategic Recommendations
1. Strengthen Early Lifecycle Retention
   Implement structured onboarding programs and proactive engagement within the first two years.

2. Increase Product Stickiness
   Introduce bundled financial products and incentives for multi-product ownership.

3. Proactive Risk-Based Retention
   Develop a churn risk scoring framework to identify high-risk customers early and trigger personalized retention offers.

Methodology
1. Imported and structured raw data in MySQL.
2. Created views and validated relationships.
3. Connected Power BI to MySQL.
4. Built star schema data model.
5. Created dynamic DAX measures.
6. Designed interactive dashboard with slicers and segmentation.

Business Impact
- Clear visibility into churn patterns
- Identification of high-risk segments
- Quantification of revenue exposure
- Data-driven retention strategy development

Conclusion
This project demonstrates SQL data preparation, Power BI data modeling, DAX expertise, business intelligence storytelling, and strategic insight generation. The dashboard provides a complete end-to-end churn analysis framework suitable for real-world banking applications.
