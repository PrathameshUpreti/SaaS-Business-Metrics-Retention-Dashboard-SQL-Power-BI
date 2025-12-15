CREATE TABLE saas_subscriptions_dataset (
    subscription_id VARCHAR(20),
    customer_id INTEGER,
    signup_date DATE,
    plan VARCHAR(50),
    monthly_fee INTEGER,
    churn_date DATE
);

select * from saas_subscriptions_dataset

--Active Customers 

select count(distinct customer_id) as active_user
from saas_subscriptions_dataset
where churn_date is  null;


-- Monthly Recurring Revenue (MRR)

select date_trunc('month', signup_date )as month,
sum(monthly_fee) as mrr
from saas_subscriptions_dataset
where churn_date is null
group by month
order by month

--3. New Customers Per Month (Acquisition)
select date_trunc('month', signup_date )as month,
count(distinct customer_id) as new_user
from saas_subscriptions_dataset
group by month
order by month

--4. Churned Customers Per Month
select date_trunc('month', signup_date )as month,
count(distinct customer_id) as churned_user
from saas_subscriptions_dataset
where churn_date is not null
group by month
order by month

--5. Monthly Churn Rate
with customer_start as(
select date_trunc('month', signup_date )as month,
count(distinct customer_id) as customer_start
from saas_subscriptions_dataset
group by month
order by month
),
churned_customer as(
select date_trunc('month', signup_date )as month,
count(distinct customer_id) as churned
from saas_subscriptions_dataset
where churn_date is not null
group by month
)
select s.month , s.customer_start, coalesce(c.churned , 0 ) as churned,
ROUND(100* coalesce(c.churned,0) / NULLIF(s.customer_start,0),2)as churnd_rate
from customer_start as s
left join churned_customer as c
on s.month=c.month
order by s.month

--6. ARPU (Average Revenue Per User)
select ROUND(SUM(monthly_fee)*1.0/ count(distinct customer_id),2)as ARPU
FROM saas_subscriptions_dataset
where churn_date is null


--7. Revenue by Plan
select plan , count(*) as totalSuscription,
sum(monthly_fee)as total_revenue
from saas_subscriptions_dataset
group by plan
order by total_revenue  desc

--8. Average Customer Lifetime (LTV base)
select 
ROUND(AVG(churn_date-signup_date),2) as average_customer_lifetime
from saas_subscriptions_dataset
where churn_date is not null

 --9.Revenue Lost Due to Churn

select date_trunc('month', churn_date)as churned_month,
sum(monthly_fee) as revenue_lost
from saas_subscriptions_dataset
where churn_date is not null
group by  churned_month
order by churned_month

--Customer Concentration Risk (Is revenue dependent on few customers?)
select customer_id, sum(monthly_fee) as total_revenue
FROM saas_subscriptions_dataset
WHERE churn_date IS NULL
GROUP BY customer_id
ORDER BY total_revenue DESC
LIMIT 20

--Plan Performance: Growth vs Churn
select plan , count(*)FilTER ( WHERE churn_date is null) as active_customer,
count(*)FILTER(WHERE churn_date is not null) as churned_customer
from saas_subscriptions_dataset
group by plan

--Early Churn Detection (Bad Onboarding)

select  customer_id , plan , churn_date - signup_date as days_to_churn
from saas_subscriptions_dataset
where churn_date is not null
and churn_date - signup_date >=30

--MoM Growth Rate (MRR Growth)

with mrr as(
select date_trunc('month', signup_date )as month,
sum(monthly_fee) as mrr
from saas_subscriptions_dataset
where churn_date is null
group by month
ORDER by month
)
select month , mrr,
ROUND( mrr-lag(mrr)over(order by month) )as mom_growth,
ROUND( (mrr-lag(mrr)over(order by month))*100/NULLIF(lag(mrr)over(order by month),0),2)as mompct
from mrr

