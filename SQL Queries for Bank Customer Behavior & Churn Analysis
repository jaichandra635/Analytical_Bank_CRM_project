create database canarabank;
use canarabank;
show tables;

drop table customerchurn;

select 
	*
from customerchurn;
ALTER TABLE customerchurn;

SET GLOBAL local_infile = 1;
SHOW GLOBAL VARIABLES LIKE 'local_infile';

-- First, make sure you're using the right database
USE canarabank;

-- Create the table
CREATE TABLE Customerinfo (
    CustomerId INT PRIMARY KEY,
    Surname VARCHAR(100),
    Age INT,
    GenderID INT,
    EstimatedSalary DECIMAL(12,2),
    GeographyID INT,
    BankDOJ DATE
);

-- First, delete the bad data
TRUNCATE TABLE Customerinfo;

-- Import with COMMA delimiter (not tab)
LOAD DATA LOCAL INFILE 'C:/Users/JAI CHANDRA/Downloads/Formatted_Tables/Customerinfo.csv'
INTO TABLE Customerinfo
FIELDS TERMINATED BY ','  -- Changed from '\t' to ','
ENCLOSED BY '"'            -- Add this for quoted fields
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
LOAD DATA LOCAL INFILE 'C:/Users/JAI CHANDRA/Downloads/Formatted_Tables/Customerinfo.csv'
INTO TABLE Customerinfo
FIELDS TERMINATED BY '\t'  -- TAB instead of comma
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT count(*) FROM Customerinfo;

show tables;
select
	count(*)
from customerchurn cc
join customerinfo ci using(customerid);

show tables;
select * from activecustomer;
select * from creditcard;

create view customer_churn as
select 
	*,
    case when CreditScore >= 800 and CreditScore <= 850 then "excellent"
		 when CreditScore >= 740 and CreditScore <= 799 then "very good"
         when CreditScore >= 670 and CreditScore <= 739 then "good"
         when CreditScore >= 580 and CreditScore <= 669 then "fair"
         when CreditScore >= 300 and CreditScore <= 579 then "poor"
	end as CreditSegment
from customerchurn;

create view customer_info as
select
	ci.customerid,
    ci.surname,
    ci.age,
    g.gendercategory,
    ci.estimatedsalary,
    gg.Geographylocation,
    ci.BankDOJ
from customerinfo ci
join gender g on ci.genderid = g.genderid
join geography gg on ci.GeographyID = gg.geographyid;

select * from exitcustomer;
select * from gender;
select * from geography;



/* country wise balance */
select 
	ci.geographylocation,
    round(sum(cc.balance),2) as total_balance
from customer_info ci
join customer_churn cc on ci.customerid = cc.customerid
group by ci.geographylocation
order by total_balance desc;

/* top 5 customers with highest salary */
select
	customerid,
    surname,
    estimatedsalary
from customer_info
order by estimatedsalary desc
limit 5;

select * from customer_info;
select * from customer_churn;

/* average number of products used by customers who have a credit card */
select
    round(avg(numofproducts),0) as avg_products
from customer_churn
where hascrcard = 1;

/* churn rate by gender */
select
	ci.gendercategory,
    round(count(case when cc.exited = 1 then cc.exited end) * 100/count(distinct cc.customerid),2) as churn_rate
from customer_info ci
join customer_churn cc on ci.customerid = cc.customerid
group by ci.gendercategory;

/* average credit score of customers who have exited and those who remain */
select
	cc.Exited,
    avg(cc.creditscore) avg_credit_score
from customer_info ci
join customer_churn cc on ci.customerid = cc.customerid
group by cc.exited;

/* gender has a higher average estimated salary, and how does it relate to the number of active accounts */

select * from customer_info;
select
	gendercategory,
    round(avg(estimatedsalary),2) as avg_salary
from customer_info
group by gendercategory;
with active as(
select
	ci.gendercategory,
    count(case when cc.isactivemember = 1 then cc.isactivemember end) as active_count
from customer_churn cc
join customer_info ci on ci.customerid = cc.customerid
group by ci.gendercategory
), inactive as (
select
	ci.gendercategory,
    count(case when cc.isactivemember = 0 then cc.isactivemember end) as inactive_count
from customer_churn cc
join customer_info ci on ci.customerid = cc.customerid
group by ci.gendercategory
), final_count as(
select 
	distinct
	a.gendercategory,
    a.active_count,
    ia.inactive_count
from active a
join inactive ia on a.gendercategory = ia.gendercategory
), salary as (
select
	gendercategory,
    round(avg(estimatedsalary),2) as avg_salary
from customer_info
group by gendercategory
), final_table as (
select
	s.gendercategory,
    s.avg_salary,
    fc.active_count,
    fc.inactive_count
from salary s
join final_count fc on s.gendercategory = fc.gendercategory
), final_cte as (
select
	*,
    active_count + inactive_count as total_count
from final_table
)
select
	*,
    round(active_count * 100/total_count, 2) as active_percent,
	round(inactive_count * 100/total_count, 2) as inactive_percent,
    round(active_count * 100/total_count, 2) - round(inactive_count * 100/total_count, 2) as percent_diff
from final_cte;




select
sum(active_count) as total_active_count,
sum(inactive_count) as total_inactive_count,
sum(active_count) + sum(inactive_count) as total_count
from final_count;

use canarabank;
select * from customer_churn;
/* 7.	Segment the customers based on their credit score and identify the segment with the highest exit rate. (SQL) */

select
    cc.creditsegment,
    round(count(case when cc.exited = 1 then exited end)*100/count(cc.exited),2) as exit_rate
from customer_churn cc
join customer_info ci on cc.customerid = ci.customerid
group by cc.creditsegment;

/* 8. Find out which geographic region has the highest number of active customers with a tenure greater than 5 years. (SQL) */
select
    ci.geographylocation,
    count(*) as active_cust
from customer_churn cc
join customer_info ci on cc.customerid = ci.customerid
where cc.tenure > 5 and cc.isactivemember = 1
group by ci.geographylocation;


/* 9. What is the impact of having a credit card on customer churn, based on the available data? */
select	* from customer_info;
select * from customer_churn;
select max(tenure) as maxi, min(tenure) as mini from customer_churn;
select 
	count(case when hascrcard = 1 then 1 end) as has_cr,
    count(case when hascrcard = 0 then 1 end) as no_cr,
    count(case when exited = 1 then 1 end) as exited,
    count(case when hascrcard = 1 and exited = 1 then 1 end) as has_cr_exited,
    count(case when hascrcard = 0 and exited = 1 then 1 end) as no_cr_exited
from customer_churn;

select 
    hascrcard,
    count(*) as total_customers,
    sum(case when exited = 1 then 1 else 0 end) as churned,
    round(sum(case when exited = 1 then 1 else 0 end) * 100.0 / count(*),2) as churn_rate
from customer_churn
group by hascrcard;

/* For customers who have exited, what is the most common number of products they had used? */
select 
    NumOfProducts,
    COUNT(*) AS frequency
from customer_churn
where Exited = 1
group by NumOfProducts
order by frequency desc;

/* 11.	Examine the trend of customer joining over time and identify any seasonal patterns (yearly or monthly). Prepare the data through SQL and then visualize it. */
select 
    year(bankdoj) as join_year,
    count(*) as total_customers
from customer_info
group by year(bankdoj)
order by join_year;

select 
	date_format(bankdoj, "%Y-%m") order_month,
    count(*) as total_customers
from customer_info
group by date_format(bankdoj, "%Y-%m")
order by order_month;

/* 12.	Analyze the relationship between the number of products and the account balance for customers who have exited. */
select
    numofproducts,
    count(*) as total_customers,
    round(avg(balance), 2) as avg_balance,
    round(min(balance), 2) as min_balance,
    round(max(balance), 2) as max_balance
from customer_churn
where exited = 1
group by numofproducts
order by numofproducts;

/* 13.	Identify any potential outliers in terms of spend among customers who have remained with the bank.
14.	Can you create a dashboard incorporating the visuals mentioned above and additionally derive more KPIs if possible?
15. Using SQL, write a query to find out the gender wise average income of male and female in each geography id. Also rank the gender according to the average value. (SQL)
16. Using SQL, write a query to find out the average tenure of the people who have exited in each age bracket (18-30, 30-50, 50+).
*/
select
    round(avg(balance), 2) as avg_balance,
    round(stddev(balance), 2) as std_balance
from customer_churn
where exited = 0;
/* overview kpis */
select
    count(*) as total_customers,
    sum(case when exited = 1 then 1 else 0 end) as total_churned,
    round(sum(case when exited = 1 then 1 else 0 end)*100.0/count(*),2) as churn_rate,
    round(avg(balance),2) as avg_balance,
    round(avg(tenure),2) as avg_tenure
from customer_churn;
/* churn rate by geography */
select
    ci.geographylocation,
    round(sum(case when cc.exited = 1 then 1 else 0 end)*100.0/count(*),2) as churn_rate
from customer_churn cc
join customer_info ci on cc.customerid = ci.customerid
group by ci.geographylocation;
/* churn rate by age bracket */
select
    case 
        when ci.age between 18 and 30 then '18-30'
        when ci.age between 31 and 50 then '31-50'
        else '50+'
    end as age_group,
    round(sum(case when cc.exited = 1 then 1 else 0 end)*100.0/count(*),2) as churn_rate
from customer_churn cc
join customer_info ci on cc.customerid = ci.customerid
group by age_group;

/*15. gender wise average income by geography + rank */
select
    ci.geographylocation,
    ci.gendercategory,
    round(avg(ci.estimatedsalary),2) as avg_income,
    rank() over (
        partition by ci.geographylocation
        order by avg(ci.estimatedsalary) desc
    ) as income_rank
from customer_info ci
group by ci.geographylocation, ci.gendercategory;

/* 16. average tenure of exited people by age bracket */

select
    case 
        when ci.age between 18 and 30 then '18-30'
        when ci.age between 31 and 50 then '31-50'
        else '50+'
    end as age_group,
    round(avg(cc.tenure),2) as avg_tenure_exited
from customer_churn cc
join customer_info ci on cc.customerid = ci.customerid
where cc.exited = 1
group by age_group;

/* 17. correlation between salary and balance (overall + by churn status) */
select 
    (
        avg(ci.estimatedsalary * cc.balance)
        - avg(ci.estimatedsalary) * avg(cc.balance)
    ) 
    /
    (
        stddev(ci.estimatedsalary) * stddev(cc.balance)
    ) as correlation_salary_balance
from customer_churn cc
join customer_info ci 
    on cc.customerid = ci.customerid;
/* 19. rank credit score buckets by churn count */
select
    creditsegment,
    count(*) as churned_customers,
    rank() over (order by count(*) desc) as churn_rank
from customer_churn
where exited = 1
group by creditsegment;

/* 20. age buckets → credit card count + below average buckets */
with age_card_counts as (
    select
        case 
            when ci.age between 18 and 30 then '18-30'
            when ci.age between 31 and 50 then '31-50'
            else '50+'
        end as age_group,
        count(*) as credit_card_count
    from customer_churn cc
    join customer_info ci 
        on cc.customerid = ci.customerid
    where cc.hascrcard = 1
    group by age_group
)

select *
from age_card_counts
where credit_card_count < (
    select avg(credit_card_count)
    from age_card_counts
);


/* 21. rank locations by churn count and avg balance */
select
    ci.geographylocation,
    count(case when cc.exited = 1 then 1 end) as churned_count,
    round(avg(cc.balance),2) as avg_balance,
    rank() over (order by count(case when cc.exited = 1 then 1 end) desc) as churn_rank,
    rank() over (order by avg(cc.balance) desc) as balance_rank
from customer_churn cc
join customer_info ci 
    on cc.customerid = ci.customerid
group by ci.geographylocation;
