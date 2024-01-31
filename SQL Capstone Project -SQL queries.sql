# creating database Bank
create database Bank;

# selecting Bank database
use Bank;

# checking if we got all of our tables
show tables;

# let's check what's inside the data
select*from activecustomer limit 10;
select * from bank_churn limit 10;
select * from creditcard limit 10;
select * from customerinfo limit 10;
select * from exitcustomer limit 10;
select * from gender limit 10;
select * from geography limit 10;

# let's create a full_view of all these tables so we do our analysis even better

CREATE VIEW full_view AS 
SELECT 
    ci.customerid,
    ci.surname,
    ci.age,
    ci.genderid,
    ci.estimatedsalary,
    ci.geographyid,
    ci.bank_doj,
    bc.CreditScore,
    bc.Tenure,
    bc.Balance,
    bc.NumOfProducts,
    bc.HasCrCard,
    bc.IsActiveMember,
    bc.Exited,
    ac.ActiveID,
    ac.ActiveCategory,
    cc.CreditID,
    cc.Category,
    gg.GeographyLocation,
    g.GenderCategory,
    ec.ExitID,
    ec.ExitCategory
FROM 
    customerinfo ci
left JOIN 
    bank_churn bc ON ci.customerid = bc.customerid
left JOIN 
    activecustomer ac ON bc.IsActiveMember = ac.activeid
left JOIN 
    creditcard cc ON bc.HasCrCard = cc.creditid
left JOIN 
    exitcustomer ec ON bc.exited = ec.exitid
left JOIN 
    gender g ON ci.genderid = g.genderid
left JOIN 
    geography gg ON ci.geographyid = gg.geographyid;

-- DROP VIEW IF EXISTS full_view;

-- ALTER TABLE customerinfo
-- CHANGE `Bank DOJ` bank_doj TEXT;


/* 
Q1) What is the distribution of account balance across different regions?
Ans: by referring below table i can say that there is inverse co-relation between average estimated salary and number of active accounts
as per data we can see that female customers have higher average estimated salary then male customers but female customers have lower active accounts then
male customers .
GenderCategory, avg_EstimatedSalary, active_accounts
Female, 100601.54, 2284
Male, 99664.58, 2867
*/

select * from bank_churn limit 1;

# Approach 1
select distinct
GeographyLocation,
round(sum(balance) over(partition by GeographyLocation),2) as balance
from full_view;

# Approach 2
select distinct
g.GeographyLocation,
round(sum(bc.balance) over(partition by g.GeographyLocation),2) as balance
from customerinfo c 
left join bank_churn bc on c.CustomerId = bc.CustomerId
left join geography g on c.geographyid = g.GeographyID;

/*
Q2) Identify the top 5 customers with the highest Salary
Ans) by referring below table we can say that the customers with higest salary are
 Customer_Name, Salary
'Lucciano', '199992.48'
'Dyer', '199970.74'
'Gannon', '199953.33'
'Moss', '199929.17'
'Adams', '199909.32'
*/

select
surname as Customer_Name,
max(estimatedsalary) as Salary 
from full_view
group by 1
order by Salary desc
limit 5;

/*
Q3) Calculate the average number of products used by customers who have a credit card.
Ans: the average number of products used by customers who have a credit card is 2
*/

select round(avg(NumOfProducts)) avg_products_used_by_credit_card_holder from full_view
where HasCrCard=1;


/* Q4) Determine the churn rate by gender for the most recent year in the dataset.
Ans: the most recent year churn rate by gender in the dataset were as following 
GenderCategory, churn_rate
Female, 25.05%
Male, 15.37%
 */

with  t1 as (select GenderCategory,count(exited) total_customers from full_view
group by 1),
t2 as (select GenderCategory,count(exited) exited_customers from full_view
where exitid = 1
group by 1)

select t1.GenderCategory,round(exited_customers/total_customers * 100,2) as churn_rate from t1
inner join t2 on t1.GenderCategory = t2.GenderCategory;


/* Q5) Compare the average credit score of customers who have exited and those who remain. 
the average credit score of customers who have exited and those who remain were as following
customer_Category, avg_credit_score
Exited customers, 645.35
Retained customers, 651.85
*/

select * from full_view limit 4;

select ExitCategory,round(avg(CreditScore),2) 
avg_credit_score from full_view
group by 1;

/* Q6) Which gender has a higher average estimated salary, and how does it relate to the number of active accounts? 
by referring below table i can say that there is inverse co-relation between average estimated salary and number of active accounts
as per data we can see that female customers have higher average estimated salary then male customers but female customers have lower active accounts then
male customers .
GenderCategory, avg_EstimatedSalary, active_accounts
Female, 100601.54, 2284
Male, 99664.58, 2867
*/

select gendercategory
,round(avg(estimatedsalary),2) avg_estimated_salary
from full_view
where activeid = 1
group by gendercategory
;

/* Q7) Segment the customers based on their credit score and identify the segment with the highest exit rate.
Ans:by referring below table we can say that the segment with the highest exit rate is 850 credit score Segment
*/

select * from full_view limit 4;

-- CreditScore: A numerical representation of the customer's creditworthiness.
-- Credit score: 
-- Excellent: 800–850
-- Very Good: 740–799
-- Good: 670–739
-- Fair: 580–669
-- Poor: 300–579

with cte as (select customerid, creditscore, exited,
case 
when creditscore >= 800 and creditscore <= 850 then 'excellent'
when creditscore >= 740 and creditscore <= 799 then 'verygood'
when creditscore >= 670 and creditscore <= 739 then 'good'
when creditscore >= 580 and creditscore <= 669 then 'fair'
else 'poor' 
end as credit_type
from full_view
)

select credit_type, count(distinct customerid) as customer_count
from cte
where exited = 1
group by credit_type
order by count(distinct customerid) desc;


/* Q8) Find out which geographic region has the highest number of active customers with a tenure greater than 5 years. 
Ans: by referring below table we can say that geographic region that has highest number of active customers with a tenure greater than 5 years
is France with number of active customers of 797.
regions, active_customers
France, 797
Spain, 431
Germany, 399
*/

select distinct GeographyLocation,
count(customerid) as active_customers
from full_view
where activeID = 1 and Tenure > 5
group by GeographyLocation;

/*
Q9.What is the impact of having a credit card on customer churn, based on the available data?
Ans: by referring below table we can say that the impact of having a credit card is having negative impact towards retaining customers.
Category, exited_customers
credit card holder, 1424
non credit card holder, 613
*/

select * from full_view limit 1;

with churndata as (
select
HasCrCard,
count(*) as total_customers,
sum(case when exitid = '1' then 1 else 0 end) as churned_customers
from full_view
group by HasCrCard
)

select
HasCrCard,
total_customers,
churned_customers,
churned_customers/total_customers as churn_rate
from churndata;


/*
Q10.For customers who have exited, what is the most common number of products they had used?
Ans: by referring below table we can say that the most common number of products Exited_customers had used is 1.
NumOfProducts, Exited_customers
1, 1409
3, 220
2, 348
4, 60
*/
select * from full_view limit 10;

select numofproducts, count(numofproducts) as productcount
from full_view
where exited = 1
group by numofproducts
order by productcount desc
;


/*
Q11.Examine the trend of customer exits over time and identify any seasonal patterns (yearly or monthly). Prepare the data through SQL and then visualize it.
Ans: by referring below table we can say that the trend of customer exits over time is increasing year by year.
year_, churn, pre_churn, trend
2016, 376, 0, increasing
2017, 479, 376, increasing
2018, 524, 479, increasing
2019, 658, 524, increasing
*/
with t1 as (select  year(c.bank_doj) year_,count(b.Exited) churn,ifnull(lag(count(b.Exited)) over(order by year(c.bank_doj)),0) 
pre_churn from customerinfo c 
inner join bank_churn b on c.CustomerId=b.CustomerId
where Exited=1 group by 1)
select year_,churn,pre_churn,case when churn>pre_churn then 'increasing' when churn<pre_churn then 'decreasing'
else 'no change' end trend from t1
;

/* Q12) Analyze the relationship between the number of products and the account balance for customers who have exited.
*/
select
NumOfProducts,
round(avg(Balance),2) as AvgBalance,
count(customerID) as CustomerCount
from full_view
where exitid = 1
group by NumOfProducts
order by NumOfProducts;

/* Q13) Identify any potential outliers in terms of spend among customers who have remained with the bank.*/

select * from full_view 
where exitid = 0;

/* Q15) Using SQL, write a query to find out the gender-wise average income of males and females in each geography id. 
# Also, rank the gender according to the average value. */

select
gendercategory,
geographyid,
avg(estimatedsalary) as avg_salary,
rank() over (partition by geographyid order by avg(estimatedsalary) desc) as gender_rank
from
full_view
group by
gendercategory, geographyid
order by
geographyid, gender_rank;

/* Q16)Using SQL, write a query to find out the average tenure of the people who have exited in each age bracket
# (18-30, 30-50, 50+). */

select * from full_view limit 10;

select
case
    when age between 18 and 30 then '18-30'
    when age between 31 and 50 then '31-50'
    when age >= 51 then '50+'
  end as age_bracket,
avg(Tenure) AS avg_tenure
from full_view
where exitid = 1
group by age_bracket
order by age_bracket;

/* Q19) Rank each bucket of credit score as per the number of customers who have churned the bank. */
with creditscorebuckets as (
select
customerid,
creditscore,
case
when creditscore >= 800 and creditscore <= 850 then 'excellent'
when creditscore >= 740 and creditscore <= 799 then 'very_good'
when creditscore >= 670 and creditscore <= 739 then 'good'
when creditscore >= 580 and creditscore <= 669 then 'fair'
else 'poor'
end as credit_type
from
full_view
)

select
credit_type,
count(customerid) as churned_customers,
rank() over (order by count(customerid) desc) as rnk
from creditscorebuckets
where customerid in (select customerid from full_view where exited = 1)
group by credit_type
order by rnk;

/* Q20) According to the age buckets find the number of customers who have a credit card. 
# Also retrieve those buckets who have lesser than average number of credit cards per bucket. */

select * from full_view limit 3;

with agebuckets as (
  select
case
when age between 18 and 30 then '18-30'
when age between 31 and 50 then '31-50'
when age >= 51 then '50+'
end as age_bucket,
count(distinct customerid) as num_customers,
avg(case when hascrcard = 1 then 1 else 0 end) as avg_credit_cards
from full_view
group by age_bucket
)
select
age_bucket,
num_customers,
avg_credit_cards
from agebuckets
where avg_credit_cards < (select avg(avg_credit_cards) from agebuckets);

/* Q21) Rank the Locations as per the number of people who have churned the bank and average balance of the customers.*/
select * from full_view limit 10;

with cust_count as
(
select
geographylocation,
count(customerid) as customer_count,
avg(balance) as avg_balance
from full_view
where exitid = 1
group by geographylocation
)

select
geographylocation,
customer_count,
round(avg_balance,0) as average_balance,
rank() over(order by customer_count desc) as rnk
from cust_count;

select * from full_view limit 12;






