-- E-commerce Database for Cohort, Churn, Retention & Fraud Detection Practice
-- This schema simulates a realistic e-commerce platform

-- Users table: Customer information
CREATE TABLE users (
    user_id INT PRIMARY KEY,
    email VARCHAR(255),
    signup_date DATE,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    country VARCHAR(50),
    device_type VARCHAR(50), -- mobile, desktop, tablet
    marketing_channel VARCHAR(50), -- organic, paid_search, social, email, referral
    account_status VARCHAR(20) -- active, suspended, deleted
);

-- Transactions table: Purchase history
CREATE TABLE transactions (
    transaction_id INT PRIMARY KEY,
    user_id INT,
    transaction_date TIMESTAMP,
    amount DECIMAL(10,2),
    payment_method VARCHAR(50), -- credit_card, debit_card, paypal, crypto
    payment_status VARCHAR(20), -- completed, failed, refunded, disputed
    product_category VARCHAR(100),
    quantity INT,
    shipping_country VARCHAR(50),
    ip_address VARCHAR(45),
    device_fingerprint VARCHAR(255),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- User activity log: Track engagement
CREATE TABLE user_activity (
    activity_id INT PRIMARY KEY,
    user_id INT,
    activity_date DATE,
    activity_type VARCHAR(50), -- login, page_view, add_to_cart, search, profile_update
    session_duration_minutes INT,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- Subscriptions table: For subscription-based revenue
CREATE TABLE subscriptions (
    subscription_id INT PRIMARY KEY,
    user_id INT,
    plan_type VARCHAR(50), -- basic, premium, enterprise
    start_date DATE,
    end_date DATE,
    monthly_price DECIMAL(10,2),
    status VARCHAR(20), -- active, cancelled, expired, paused
    cancellation_date DATE,
    cancellation_reason VARCHAR(100),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- Fraud flags table: Suspicious activity indicators
CREATE TABLE fraud_flags (
    flag_id INT PRIMARY KEY,
    transaction_id INT,
    user_id INT,
    flag_date TIMESTAMP,
    flag_type VARCHAR(100), -- multiple_cards, velocity_check, ip_mismatch, stolen_card, unusual_amount
    risk_score INT, -- 1-100
    investigation_status VARCHAR(50), -- pending, confirmed_fraud, false_positive, resolved
    FOREIGN KEY (transaction_id) REFERENCES transactions(transaction_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- Sample data insertion for practice

-- Insert users (representing different cohorts)
INSERT INTO users VALUES
(1, 'john.doe@email.com', '2023-01-15', 'John', 'Doe', 'USA', 'desktop', 'organic', 'active'),
(2, 'jane.smith@email.com', '2023-01-20', 'Jane', 'Smith', 'UK', 'mobile', 'paid_search', 'active'),
(3, 'bob.wilson@email.com', '2023-02-10', 'Bob', 'Wilson', 'Canada', 'mobile', 'social', 'active'),
(4, 'alice.brown@email.com', '2023-03-05', 'Alice', 'Brown', 'USA', 'desktop', 'email', 'active'),
(5, 'charlie.davis@email.com', '2023-04-12', 'Charlie', 'Davis', 'Australia', 'tablet', 'referral', 'suspended'),
(6, 'eva.martinez@email.com', '2023-05-18', 'Eva', 'Martinez', 'Spain', 'mobile', 'organic', 'active'),
(7, 'frank.lee@email.com', '2023-06-22', 'Frank', 'Lee', 'USA', 'desktop', 'paid_search', 'active'),
(8, 'grace.kim@email.com', '2023-07-30', 'Grace', 'Kim', 'South Korea', 'mobile', 'social', 'deleted'),
(9, 'henry.patel@email.com', '2023-08-14', 'Henry', 'Patel', 'India', 'mobile', 'organic', 'active'),
(10, 'iris.nguyen@email.com', '2023-09-09', 'Iris', 'Nguyen', 'Vietnam', 'desktop', 'email', 'active');

-- Insert transactions (various patterns including fraud indicators)
INSERT INTO transactions VALUES
(101, 1, '2023-01-16 10:30:00', 49.99, 'credit_card', 'completed', 'Electronics', 1, 'USA', '192.168.1.1', 'fp_abc123'),
(102, 1, '2023-02-20 14:20:00', 129.99, 'credit_card', 'completed', 'Clothing', 2, 'USA', '192.168.1.1', 'fp_abc123'),
(103, 2, '2023-01-25 09:15:00', 79.99, 'paypal', 'completed', 'Books', 3, 'UK', '10.0.0.1', 'fp_xyz789'),
(104, 2, '2023-03-10 16:45:00', 199.99, 'credit_card', 'completed', 'Electronics', 1, 'UK', '10.0.0.1', 'fp_xyz789'),
(105, 3, '2023-02-15 11:00:00', 39.99, 'debit_card', 'completed', 'Home & Garden', 1, 'Canada', '172.16.0.1', 'fp_def456'),
(106, 4, '2023-03-08 13:30:00', 299.99, 'credit_card', 'completed', 'Electronics', 1, 'USA', '192.168.2.1', 'fp_ghi789'),
(107, 5, '2023-04-15 10:00:00', 999.99, 'credit_card', 'disputed', 'Electronics', 5, 'Nigeria', '203.0.113.1', 'fp_fraud1'),
(108, 5, '2023-04-15 10:05:00', 899.99, 'credit_card', 'failed', 'Electronics', 4, 'Russia', '203.0.113.1', 'fp_fraud1'),
(109, 6, '2023-05-20 15:20:00', 59.99, 'paypal', 'completed', 'Beauty', 2, 'Spain', '198.51.100.1', 'fp_jkl012'),
(110, 7, '2023-06-25 12:10:00', 149.99, 'credit_card', 'refunded', 'Clothing', 1, 'USA', '192.168.3.1', 'fp_mno345');

-- Insert user activity
INSERT INTO user_activity VALUES
(1001, 1, '2023-01-16', 'login', 25),
(1002, 1, '2023-02-20', 'login', 30),
(1003, 1, '2023-03-15', 'login', 15),
(1004, 2, '2023-01-25', 'login', 40),
(1005, 2, '2023-03-10', 'login', 35),
(1006, 3, '2023-02-15', 'login', 20),
(1007, 4, '2023-03-08', 'login', 45),
(1008, 5, '2023-04-15', 'login', 10),
(1009, 6, '2023-05-20', 'login', 30),
(1010, 7, '2023-06-25', 'login', 25);

-- Insert subscriptions
INSERT INTO subscriptions VALUES
(201, 1, 'premium', '2023-01-15', '2024-01-15', 19.99, 'active', NULL, NULL),
(202, 2, 'basic', '2023-01-20', '2023-07-20', 9.99, 'cancelled', '2023-06-15', 'too_expensive'),
(203, 3, 'premium', '2023-02-10', '2024-02-10', 19.99, 'active', NULL, NULL),
(204, 4, 'enterprise', '2023-03-05', '2024-03-05', 49.99, 'active', NULL, NULL),
(205, 6, 'basic', '2023-05-18', '2023-11-18', 9.99, 'cancelled', '2023-10-01', 'not_using_enough'),
(206, 7, 'premium', '2023-06-22', '2024-06-22', 19.99, 'active', NULL, NULL),
(207, 9, 'basic', '2023-08-14', '2024-08-14', 9.99, 'active', NULL, NULL);

-- Insert fraud flags
INSERT INTO fraud_flags VALUES
(301, 107, 5, '2023-04-15 10:01:00', 'velocity_check', 85, 'confirmed_fraud'),
(302, 107, 5, '2023-04-15 10:01:00', 'ip_mismatch', 90, 'confirmed_fraud'),
(303, 108, 5, '2023-04-15 10:06:00', 'multiple_cards', 95, 'confirmed_fraud'),
(304, 110, 7, '2023-06-25 12:15:00', 'unusual_amount', 45, 'false_positive');

-- Practice queries you should try:

-- COHORT ANALYSIS:
-- 1. Monthly signup cohorts and their retention over time
-- 2. First purchase conversion rate by cohort
-- 3. Revenue by acquisition cohort

-- CHURN ANALYSIS:
-- 1. Monthly churn rate for subscriptions
-- 2. Identify users who haven't transacted in 90 days
-- 3. Churn reasons breakdown
-- 4. User activity before churn

-- RETENTION ANALYSIS:
-- 1. Day 1, 7, 30, 90 retention rates
-- 2. Repeat purchase rate by cohort
-- 3. Active users month-over-month

-- FRAUD DETECTION:
-- 1. Transaction velocity (multiple transactions in short time)
-- 2. Unusual transaction amounts compared to user history
-- 3. Geographic anomalies (IP vs shipping country)
-- 4. High-risk score transactions pending review
-- 5. False positive rate in fraud detection


select * from users
select * from transactions
--================================================================
-- COHORT ANALYSIS:

-- 1. Monthly signup cohorts and their retention over time
with acc_cohort as(
select user_id,
DATE_TRUNC('month',signup_date) as cohort_month
from users
),
user_month as(
select distinct c.user_id ,c.cohort_month,
DATE_TRUNC('month', t.transaction_date) as transaction_month,
EXTRACT(MONTH FROM AGE(t.transaction_date , c.cohort_month)) as months_since_signup
from acc_cohort as c
left join transactions as t
on c.user_id=t.user_id
where t.payment_status='completed'
)
SELECT 
    cohort_month,
    COUNT(DISTINCT CASE WHEN months_since_signup = 0 THEN user_id END) AS month_0,
    COUNT(DISTINCT CASE WHEN months_since_signup = 1 THEN user_id END) AS month_1,
    COUNT(DISTINCT CASE WHEN months_since_signup = 2 THEN user_id END) AS month_2,
    COUNT(DISTINCT CASE WHEN months_since_signup = 3 THEN user_id END) AS month_3,
    -- Calculate retention percentages
    ROUND(100.0 * COUNT(DISTINCT CASE WHEN months_since_signup = 1 THEN user_id END) / 
          NULLIF(COUNT(DISTINCT CASE WHEN months_since_signup = 0 THEN user_id END), 0), 2) AS retention_month_1_pct,
    ROUND(100.0 * COUNT(DISTINCT CASE WHEN months_since_signup = 2 THEN user_id END) / 
          NULLIF(COUNT(DISTINCT CASE WHEN months_since_signup = 0 THEN user_id END), 0), 2) AS retention_month_2_pct
FROM user_month
GROUP BY cohort_month
ORDER BY cohort_month;


---- 2. First purchase conversion rate by cohort
with acc_cohort as (
select user_id , date_trunc('month',signup_date)as cohort_month
from users
),
user_activity as(
select user_id,
MIN(transaction_date) as first_transaction
from transactions
where payment_status='completed'
group by user_id

)
select c.cohort_month,
count(distinct c.user_id )as total_signup,
count(distinct u.user_id)as user_with_trasaction,
ROUND(100.0* count(distinct u.user_id)/count(distinct c.user_id ),2)as conversion_rate
from acc_cohort as c
left join  user_activity as u
on c.user_id=u.user_id
group by cohort_month
order by cohort_month

-- 3. Revenue by acquisition cohort
select c.marketing_channel,
DATE_TRUNC('MONTH', signup_date ) as cohort_month,
count(distinct c.user_id)as cohort_user,
count(distinct t.transaction_id) as total_transaction,
ROUND(SUM(CASE WHEN t.payment_status = 'completed' THEN t.amount ELSE 0 END), 2) AS total_revenue,
ROUND(SUM(CASE WHEN t.payment_status='completed' then t.amount else 0 end)/count(distinct c.user_id),2) as acc_cost
from users as c
left join transactions as t
on c.user_id=t.user_id
group by cohort_month, c.marketing_channel

-- ============================================
-- CHURN ANALYSIS QUERIES
-- ============================================
select * from subscriptions
select * from transactions
select * from users
-- 1. Monthly churn rate for subscriptions 
--same month cancellation

with month as (
 SELECT DATE_TRUNC('month', start_date) AS month,
 count(*) as active_start,
 count(*)filter( where status='cancelled' AND DATE_TRUNC('month',cancellation_date)=DATE_TRUNC('month', start_date))as churned
 from subscriptions
 group by month
 order by month  
)
select month,active_start,churned,
ROUND(100.0 * churned / NULLIF(active_start, 0), 2) AS churn_rate_pct

from month 
order by month

--total churned

select date_trunc('month',start_date) as month,
count(*) as active_total,
count(*)filter(where status='cancelled') as churned,
ROUND(100.0*count(*)filter(where status='cancelled')/count(*)) as churned_percentage
from subscriptions
group by month
order by month

---- 2. Identify users who haven't transacted in 90 days (dormant users)

with last_transaction as (
select user_id , max(transaction_date)as last_transaction_date,
count(*) as total_transaction
from transactions
where payment_status='completed'
group by user_id

)
select u.user_id, u.email, lt.last_transaction_date, u.signup_date,lt.total_transaction,
CURRENT_DATE - lt.last_transaction_date::date AS days_since_last_transaction
from users as u 
left join last_transaction  as lt 
on u.user_id=lt.user_id
WHERE (CURRENT_DATE - lt.last_transaction_date::date > 90 
       OR lt.last_transaction_date IS NULL)
  AND u.account_status = 'active'
ORDER BY days_since_last_transaction DESC;


-- 3. Churn reasons breakdown
select cancellation_reason, count(*) as canacellation_count,
ROUND(100.0* COUNT(*)/SUM(COUNT(*) )OVER (),2) AS percentage,
ROUND(AVG(cancellation_date - start_date), 2) AS avg_days_to_churn,
ROUND(AVG(monthly_price), 2) AS avg_price_point
from subscriptions 
WHERE status = 'cancelled' AND cancellation_reason IS NOT NULL
group by cancellation_reason
order by cancellation_reason desc

1. FROM  
2. JOIN  
3. WHERE  
4. GROUP BY  
5. HAVING  
6. SELECT  
7. DISTINCT  
8. ORDER BY  
9. LIMIT

