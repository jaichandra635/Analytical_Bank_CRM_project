-- Objective Questions

/*
Q1.What is the distribution of account balance across different regions?
Ans:the account balance across different regions were as following
regions, account_balance
France, 311332479.49
Germany, 300402861.38
Spain, 153123552.01
*/

select g.GeographyLocation regions,round(sum(b.Balance),2) account_balance from customerinfo c 
inner join bank_churn b on c.CustomerId=b.CustomerId
inner join geography g on c.GeographyID=g.GeographyID
group by 1 order by account_balance desc ;

/*
Q2.Identify the top 5 customers with the highest number of transactions in the last quarter of the year. (SQL)
Ans: top 5 customers with the highest number of transactions in the last quarter of the latest year in database were as following
CustomerId, customer_name, transactions
15608528, Munro, 4
15625824, Kornilova, 4
15633194, Osborne, 4
15634974, Seppelt, 4
15668889, Galgano, 4
*/

select c.CustomerId,c.Surname customer_name,sum(b.NumOfProducts) transactions from customerinfo c 
inner join bank_churn b on c.CustomerId=b.CustomerId
where extract(year_month from c.BankDOJ) between '201910' and '201912'
group by 1,2
order by  transactions desc,CustomerId asc,c.Surname asc  limit 5;

/*
Q3.Calculate the average number of products used by customers who have a credit card. (SQL)
Ans: the average number of products used by customers who have a credit card is 2
*/

select round(avg(NumOfProducts)) avg_products_used_by_credit_card_holder from bank_churn
where HasCrCard=1;


/*
Q4.Determine the churn rate by gender for the most recent year in the dataset.
Ans: the most recent year churn rate by gender in the dataset were as following 
GenderCategory, churn_rate
Female, 25.05%
Male, 15.37%
*/

with  t1 as (select g.GenderCategory,count(b.exited) total_customers from customerinfo c 
inner join bank_churn b on c.CustomerId=b.CustomerId
inner join  gender g on c.GenderID=g.GenderID
where year(c.BankDOJ) in (select max(year(BankDOJ)) from customerinfo)
group by 1) ,t2 as (select g.GenderCategory,count(b.exited) exited_customers from customerinfo c 
inner join bank_churn b on c.CustomerId=b.CustomerId
inner join  gender g on c.GenderID=g.GenderID
where year(c.BankDOJ) in (select max(year(BankDOJ)) from customerinfo) and b.exited=1
group by 1)

select t1.GenderCategory,round((exited_customers/total_customers)*100,2) churn_rate
from t1 inner join t2 on t1.GenderCategory=t2.GenderCategory
;

/*
Q5.Compare the average credit score of customers who have exited and those who remain. (SQL)
Ans: the average credit score of customers who have exited and those who remain were as following
customer_Category, avg_credit_score
Exited customers, 645.35
Retained customers, 651.85
*/

select concat(e.ExitCategory,'ed customers') customer_Category,round(avg(b.CreditScore),2) avg_credit_score from bank_churn b
inner join exitcustomer e on b.Exited=e.ExitID
group by 1 
;

/*
Q6.Which gender has a higher average estimated salary, and how does it relate to the number of active accounts? (SQL)
Ans: by referring below table i can say that there is inverse co-relation between average estimated salary and number of active accounts
as per data we can see that female customers have higher average estimated salary then male customers but female customers have lower active accounts then
male customers .
GenderCategory, avg_EstimatedSalary, active_accounts
Female, 100601.54, 2284
Male, 99664.58, 2867
*/

with t1 as (select g.GenderCategory,round(avg(EstimatedSalary),2) avg_EstimatedSalary from customerinfo c 
inner join gender g on c.GenderID=g.GenderID
group by 1),t2 as (select g.GenderCategory,count(b.IsActiveMember) active_accounts from customerinfo c 
inner join gender g on c.GenderID=g.GenderID
inner join bank_churn b on c.CustomerId=b.CustomerId
where b.IsActiveMember=1 group by 1)

select  t1.GenderCategory,avg_EstimatedSalary,active_accounts from t1
inner join t2 on t1.GenderCategory=t2.GenderCategory
;

/*
Q7.Segment the customers based on their credit score and identify the segment with the highest exit rate. (SQL)
Ans:by referring below table we can say that the segment with the highest exit rate is 850 credit score Segment with 10.24%  exit rate.
CreditScore, exit_rate
850, 10.24%
651, 4.05%
705, 3.81%
637, 3.33%
678, 3.10%
*/

with t1 as (select CreditScore,count(Exited) exited_customers,count(Exited) over() total_exited_customers from bank_churn
where Exited=1 group by 1)

select CreditScore,round((exited_customers/total_exited_customers)*100,2) exit_rate from t1
order by exit_rate desc limit 5
;

/*
Q8.Find out which geographic region has the highest number of active customers with a tenure greater than 5 years. (SQL)
Ans: by referring below table we can say that geographic region that has highest number of active customers with a tenure greater than 5 years
is France with number of active customers of 797.
regions, active_customers
France, 797
Spain, 431
Germany, 399
*/

select g.GeographyLocation regions,count(b.IsActiveMember) active_customers from customerinfo c 
inner join bank_churn b on c.CustomerId=b.CustomerId
inner join geography g on c.GeographyID=g.GeographyID
where b.Tenure>5 and b.IsActiveMember=1 group by 1
;

/*
Q9.What is the impact of having a credit card on customer churn, based on the available data?
Ans: by referring below table we can say that the impact of having a credit card is having negative impact towards retaining customers.
Category, exited_customers
credit card holder, 1424
non credit card holder, 613
*/

select c.Category,count(b.exited) exited_customers from  bank_churn b 
inner join creditcard c on c.CreditID=b.HasCrCard
where b.exited=1 group by 1 
;

/*
Q10.For customers who have exited, what is the most common number of products they had used?
Ans: by referring below table we can say that the most common number of products Exited_customers had used is 1.
NumOfProducts, Exited_customers
1, 1409
3, 220
2, 348
4, 60
*/

select NumOfProducts,count(Exited) Exited_customers from bank_churn
where Exited=1 group by 1
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

with t1 as (select  year(c.BankDOJ) year_,count(b.Exited) churn,ifnull(lag(count(b.Exited)) over(order by year(c.BankDOJ)),0) 
pre_churn from customerinfo c 
inner join bank_churn b on c.CustomerId=b.CustomerId
where Exited=1 group by 1)

select year_,churn,pre_churn,case when churn>pre_churn then 'increasing' when churn<pre_churn then 'decreasing'
else 'no change' end trend from t1
;

/*
Q15.Using SQL, write a query to find out the gender wise average income of male and female in each geography id. Also rank the gender according to the average value. (SQL)
Ans: the gender wise average income of male and female in each geography with along respective rank in each geography were as following
GeographyLocation, GenderCategory, average_income, ranks
France, Male, 100174.25, 1
France, Female, 99564.25, 2
Germany, Female, 102446.42, 1
Germany, Male, 99905.03, 2
Spain, Female, 100734.11, 1
Spain, Male, 98425.69, 2
*/

select L.GeographyLocation,g.GenderCategory,round(avg(c.EstimatedSalary),2) average_income,
dense_rank() over(partition by L.GeographyLocation order by round(avg(c.EstimatedSalary),2) desc) ranks from customerinfo c
inner join gender g on c.GenderID=g.GenderID 
inner join geography l on c.GeographyID=l.GeographyID
group by 1,2
;

/*
Q16.Using SQL, write a query to find out the average tenure of the people who have exited in each age bracket (18-30, 30-50, 50+).
Ans: the average tenure of the people who have exited in each age bracket were as following
age_bracket, average_tenure
31-50, 4.87
18-30, 4.84
50+, 4.85
*/

select case when c.age between '18' and '30' then '18-30' when c.age between '31' and '50' then '31-50'
when c.age>50 then '50+' else 'NA' end age_bracket,round(avg(b.Tenure),2) average_tenure from customerinfo c 
inner join bank_churn b on c.CustomerId=b.CustomerId
group by 1
;

/*
Q19.Rank each bucket of credit score as per the number of customers who have churned the bank.
Ans: please find below table with bucket of credit score along with their number of exited customers and ranks respectively.
credit_score_bucket, churn, ranks
580–669, 685, 1
300–579, 520, 2
670–739, 452, 3
740–799, 252, 4
800–850, 128, 5
*/

select case when CreditScore between 300 and 579 then '300–579' when CreditScore between 580 and 669 then '580–669'
when CreditScore between 670 and 739 then '670–739' when CreditScore between 740 and 799 then '740–799'
when CreditScore between 800 and 850 then '800–850' else 'NA' end credit_score_bucket,count(distinct CustomerId) churn,
dense_rank() over(order by  count(distinct CustomerId) desc) ranks from bank_churn
where Exited=1 group by 1
;

/*
Q20.According to the age buckets find the number of customers who have a credit card. Also retrieve those buckets who have lesser than average number of credit cards per bucket.
Ans1: please find below table with age buckets along with their credit card holders.
age_bracket, credit_card_holders
18-30, 1400
31-50, 4781
50+, 874
Ans2: please find below table with age buckets along with their credit card holders who have lesser than average number of credit cards per bucket
age_bracket, credit_card_holders
18-30, 1400
50+, 874
*/

select case when c.age between '18' and '30' then '18-30' when c.age between '31' and '50' then '31-50'
when c.age>50 then '50+' else 'NA' end age_bracket,count(distinct c.CustomerId) credit_card_holders from customerinfo c 
inner join bank_churn b on c.CustomerId=b.CustomerId
where HasCrCard=1 group by 1
;

with t1 as (select case when c.age between '18' and '30' then '18-30' when c.age between '31' and '50' then '31-50'
when c.age>50 then '50+' else 'NA' end age_bracket,count(distinct c.CustomerId) credit_card_holders from customerinfo c 
inner join bank_churn b on c.CustomerId=b.CustomerId
where HasCrCard=1 group by 1)

select age_bracket,credit_card_holders from t1 
where credit_card_holders<(select round(avg(credit_card_holders),2) from t1)
;

/*
Q21.Rank the Locations as per the number of people who have churned the bank and average balance of the learners.
Ans: please find below table with Locations along with their number of exited customers,average balance and ranks respectively.
GeographyLocation, exited_customers, avg_balance, ranks
Germany, 814, 120361.08, 1
France, 810, 71192.8, 2
Spain, 413, 72513.35, 3
*/

select g.GeographyLocation,count(distinct c.CustomerId) exited_customers,round(avg(b.Balance),2) avg_balance,
dense_rank() over (order by count(distinct c.CustomerId) desc) ranks from customerinfo c 
inner join bank_churn b on c.CustomerId=b.CustomerId
inner join geography g on c.GeographyID=g.GeographyID
where b.Exited=1 group by 1
;

-- Subjective Question:

/*
1.Customer Behavior Analysis: 
Q1.What patterns can be observed in the spending habits of long-term customers compared to new customers, and what might these patterns suggest about customer loyalty?
Ans:By referring below table we can be observe there is no significance difference in spending habits of long-term customers compared to new customers
and hence it is hard suggest about customer loyalty based on these patterns.
Tenure_category, NumOfProducts_per_customers, customers_percentage
long-term customers, 1.51, 31.71%
medium-term customers, 1.53, 54.81%
new customers, 1.56, 13.48%
[note:long-term customers are those customers who Tenure is greater than 5 years,
medium-term customers are those customers who Tenure is between 4 and 5 years,
new customers are those customers who Tenure is lesser than or equal to 3 years
those definition were created after finding minimum Tenure of customers(3 years) ,average Tenure of customers(5 years) 
and maximum Tenure of customers(7 years)]
*/

with t1 as (select min(Tenure) min_Tenure,max(Tenure) max_Tenure,round(avg(Tenure)) avg_Tenure from bank_churn),
t2 as (select case when Tenure>(select avg_Tenure from t1) then 'long-term customers' when Tenure=(select min_Tenure from t1) 
then 'new customers' else 'medium-term customers' end Tenure_category,sum(NumOfProducts) total_NumOfProducts,
count(CustomerId) number_customers from bank_churn group by 1),
t3 as (select Tenure_category,total_NumOfProducts,number_customers,round(total_NumOfProducts/number_customers,2) 
NumOfProducts_per_customers,sum(number_customers) over() total_customers from t2)

select Tenure_category,NumOfProducts_per_customers,round((number_customers/total_customers)*100,2) customers_percentage from t3
;

/*
3.Geographic Market Trends: 
Q3.How do economic indicators in different geographic regions correlate with the number of active accounts and customer churn rates?
Ans: by referring below table we can say that there is no correlation with the number of active accounts and customer churn rates in different geographic regions
GeographyLocation, active_customers_percentage, exited_customers_percentage
France, 50.30, 39.76
Spain, 25.47, 20.27
Germany, 24.23, 39.96
*/

with t1 as (select g.GeographyLocation,count(distinct c.CustomerId) active_customers from bank_churn b 
inner join customerinfo c on c.CustomerId=b.CustomerId
inner join geography g on c.GeographyID=g.GeographyID
where b.IsActiveMember=1 group by 1),
t2 as (select g.GeographyLocation,count(distinct c.CustomerId) exited_customers from bank_churn b 
inner join customerinfo c on c.CustomerId=b.CustomerId
inner join geography g on c.GeographyID=g.GeographyID
where b.Exited=1 group by 1),t3 as
(select t1.GeographyLocation,t1.active_customers,sum(t1.active_customers) over() total_active_customers,t2.exited_customers,
sum(t2.exited_customers) over() total_exited_customers from t1
inner join t2 on t1.GeographyLocation=t2.GeographyLocation)


select GeographyLocation,round((active_customers/total_active_customers)*100,2) active_customers_percentage,
round((exited_customers/total_exited_customers)*100,2) exited_customers_percentage from t3
order by active_customers_percentage desc
;

/*
4.Risk Management Assessment: 
Q4.Based on customer profiles, which demographic segments appear to pose the highest financial risk to the bank, and why?
Ans: by referring below table we can say that there is no particular demographic segments appears to pose the highest financial risk to the bank based on average CreditScore
GeographyLocation, GenderCategory, age_bracket, avg_CreditScore
Germany, Female, 18-30, 650.56
France, Male, 18-30, 654.78
Spain, Male, 18-30, 649.76
France, Female, 18-30, 650.24
Spain, Female, 18-30, 644.48
Germany, Male, 18-30, 652.48
France, Female, 31-50, 649.27
Spain, Female, 31-50, 652.58
Spain, Male, 31-50, 651.14
France, Male, 31-50, 648.19
Germany, Male, 31-50, 649.86
Germany, Female, 31-50, 656.20
Germany, Male, 50+, 646.95
France, Female, 50+, 646.99
Spain, Female, 50+, 658.41
France, Male, 50+, 652.48
Spain, Male, 50+, 652.11
Germany, Female, 50+, 642.28
*/

select g1.GeographyLocation,g.GenderCategory,case when c.age between '18' and '30' then '18-30' 
when c.age between '31' and '50' then '31-50' when c.age>50 then '50+' else 'NA' end age_bracket,
round(avg(b.CreditScore),2) avg_CreditScore from customerinfo c 
inner join bank_churn b on c.CustomerId=b.CustomerId
inner join  gender g on c.GenderID=g.GenderID
inner join  geography g1 on c.GeographyID=g1.GeographyID
group by 1,2,3 order by age_bracket
;

/*
5.Customer Lifetime Value Forecast: 
Q5.How would you use the available data to model and predict the lifetime value of different customer segments?
Ans: by referring below table we can say that customers of age range between 31 to 50 can be consider as most valuable customer segment their total account balance Significantly higher than other customer segments and can used for most banking activities for business growth.
age_bracket, account_balance, avg_CreditScore
31-50, 519985034.96, 650.50
18-30, 144055167.65, 651.20
50+, 100818690.27, 649.63
*/

select case when c.age between '18' and '30' then '18-30' when c.age between '31' and '50' then '31-50' 
when c.age>50 then '50+' else 'NA' end age_bracket,round(sum(b.Balance),2) acount_balance,
round(avg(b.CreditScore),2) avg_CreditScore from customerinfo c 
inner join bank_churn b on c.CustomerId=b.CustomerId
group by 1 order by acount_balance desc,avg_CreditScore desc
;

/*
7.Customer Exit Reasons Exploration: 
Q7.Can you identify common characteristics or trends among customers who have exited that could explain their reasons for leaving?

*/

