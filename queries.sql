-- ==========================================
-- SECTION A: SQL Fundamentals (Q1 - Q10)
-- ==========================================

-- Q1: Retrieve all customer records.
SELECT * 
FROM customers;

-- Q2: Display customer names, cities, and segments.
SELECT customer_name, city, customer_segment 
FROM customers;

-- Q3: Find customers living in Nairobi.
SELECT * 
FROM customers 
WHERE city = 'Nairobi';


-- Q4: Find customers registered after January 1, 2025.
SELECT * 
FROM customers 
WHERE registration_date > '2025-01-01';

-- Q5: Display all unique customer cities.
SELECT DISTINCT city 
FROM customers;

-- Q6: Retrieve the 10 most recent orders.
SELECT * 
FROM orders 
ORDER BY order_date DESC 
LIMIT 10;

-- Q7: Find orders with unit prices above KSh 10,000…
SELECT * 
FROM orders 
WHERE unit_price > 10000;


-- Q8: Find customers whose names start with A.
SELECT * 
FROM customers 
WHERE customer_name LIKE 'A%';

-- Q9: Retrieve orders with quantities between 2 and 5.
SELECT * 
FROM orders 
WHERE quantity BETWEEN 2 AND 5;

-- Q10: Find orders paid through M-Pesa.
SELECT * 
FROM orders 
WHERE payment_method = 'M-Pesa';

--SECTION B 
--Q11. Count all customers.
select count (*) from customers;

--Q12. Count all orders.
select count (*) from orders;

--Q13. Calculate completed-order revenue.
SELECT round(sum(quantity * unit_price * (1 - discount / 100)), 2) AS completed_revenue
FROM orders
WHERE order_status = 'Completed';

--Q14. Calculate the average completed-order value.

SELECT round(avg(quantity * unit_price * (1 - discount / 100)), 2) AS Avg_completed_order_value
FROM orders
WHERE order_status = 'Completed';

--Q15. Find the highest and lowest product prices.
select max (unit_price) as highest_price,
min (unit_price) as lowest_price
from orders;



--Q16. Calculate revenue by product category.
SELECT product_category, round(sum(quantity * unit_price * (1 - discount / 100)), 2) AS revenue
FROM orders
WHERE order_status = 'Completed'
group by product_category;

--Q17. Count customers by city.
select city,
count (*) as customer
from customers
group by city;

--Q18. Calculate quantity sold by product.
select product_name,
count (quantity) as units_sold
from orders
group by product_name;


--Q19. Find categories generating more than KSh 100,000 in revenue.
SELECT product_category,round(sum(quantity * unit_price * (1 - discount / 100)), 2) AS revenue
FROM orders
WHERE order_status = 'Completed'
group by product_category 
having round(sum(quantity * unit_price * (1 - discount / 100)), 2) > 100000;



--Q20. Calculate the percentage of cancelled orders.
select 
round (COUNT(*) FILTER (where order_status = 'Cancelled' ) *100.0/count(*),2) as percentage_cancelled_orders
from orders;

--Section C
select * from customers;
select * from orders;
--Q21. Display orders with customer names and cities.
select c.customer_id,
c.customer_name,
c.city,
o.order_id 
from orders o
join customers c
on o.customer_id = c.customer_id;

--Q22. Calculate total spending by customer.
select c.customer_name,
c.customer_id,
round(sum(o.quantity * o.unit_price * (1 - o.discount / 100)), 2) as total_spending
from customers c
join orders o on c.customer_id = o.customer_id
where o.order_status = 'Completed'
group by c.customer_id, c.customer_name ;

--Q23. Identify customers who have never ordered.
select c.customer_name,
c.customer_id
from customers c
left join orders o
on o.customer_id = c.customer_id
where o.order_id is null;

--Q24. Find the 10 highest-spending customers.
select c.customer_name,
c.customer_id,
round(sum(o.quantity * o.unit_price * (1 - o.discount / 100)), 2) as total_spending
from customers c
join orders o on c.customer_id = o.customer_id
where o.order_status = 'Completed'
group by c.customer_id, c.customer_name 
order by total_spending desc limit 10;


--Q25. Calculate revenue by customer city.
select c.city,
round(sum(o.quantity * o.unit_price * (1 - o.discount / 100)), 2) as total_revenue_city
from customers c
join orders o on o.customer_id = c.customer_id
where o.order_status = 'Completed'
group by c.city;

--Q26. Identify customers with more than five orders.
select c.customer_id,
c.customer_name,
count (*) as order_count
from customers c
join orders o on o.customer_id = c.customer_id 
group by c.customer_id, c.customer_name
having count (*) > 5;

--27. Calculate average customer spending by segment.

SELECT 
    cs.customer_segment,
    AVG(cs.total_spent) AS avg_spending_per_customer
FROM (
    SELECT 
        c.customer_id,
        c.customer_segment,
        SUM(o.quantity * o.unit_price * (1 - o.discount / 100.0)) AS total_spent
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    WHERE o.order_status = 'Completed'
    GROUP BY c.customer_id, c.customer_segment
) cs
GROUP BY cs.customer_segment
ORDER BY avg_spending_per_customer DESC;




 --Q28: Identify the most popular category among VIP customers 
SELECT 
    o.product_category,
    COUNT(o.order_id) AS order_count
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
WHERE c.customer_segment = 'VIP'
GROUP BY o.product_category
ORDER BY order_count DESC
LIMIT 1;


 -- popular - by orders


-- ==========================================
-- SECTION D: Subqueries and CTEs (Q29 - Q34)
-- ==========================================

-- Q29: Find customers spending above the average total spending per purchasing customer.
-- Definition: total spending = Completed orders only; the average is taken over customers
-- who have at least one completed order.
WITH customer_spend AS (
    SELECT c.customer_id,
           c.customer_name,
           SUM(o.quantity * o.unit_price * (1 - o.discount / 100)) AS total_spent
    FROM customers c
    JOIN orders o ON o.customer_id = c.customer_id
    WHERE o.order_status = 'Completed'
    GROUP BY c.customer_id, c.customer_name
)
SELECT customer_id,
       customer_name,
       ROUND(total_spent, 2) AS total_spent
FROM customer_spend
WHERE total_spent > (SELECT AVG(total_spent) FROM customer_spend)
ORDER BY total_spent DESC;


-- Q30: Find products priced above the overall average unit price.
-- DISTINCT so each product appears once, not once per order.
SELECT DISTINCT product_name, unit_price
FROM orders
WHERE unit_price > (SELECT AVG(unit_price) FROM orders)
ORDER BY unit_price DESC;


-- Q31: Use a CTE to identify the three highest-revenue months.
-- Month = year and month together; Completed orders only.
WITH monthly AS (
    SELECT DATE_TRUNC('month', order_date)::date AS month,
           ROUND(SUM(quantity * unit_price * (1 - discount / 100)), 2) AS revenue
    FROM orders
    WHERE order_status = 'Completed'
    GROUP BY DATE_TRUNC('month', order_date)
)
SELECT month, revenue
FROM monthly
ORDER BY revenue DESC
LIMIT 3;


-- Q32: Find customers purchasing from at least three categories.
-- Counts categories across Completed orders only.
SELECT c.customer_id,
       c.customer_name,
       COUNT(DISTINCT o.product_category) AS categories_bought
FROM customers c
JOIN orders o ON o.customer_id = c.customer_id
WHERE o.order_status = 'Completed'
GROUP BY c.customer_id, c.customer_name
HAVING COUNT(DISTINCT o.product_category) >= 3
ORDER BY categories_bought DESC, c.customer_id;



-- Q33: Use a CTE to calculate category revenue, cost, profit, and profit margin.
-- Completed orders only; NULLIF avoids division by zero.
WITH category_totals AS (
    SELECT product_category,
           SUM(quantity * unit_price * (1 - discount / 100)) AS revenue,
           SUM(quantity * cost_price)                        AS cost
    FROM orders
    WHERE order_status = 'Completed'
    GROUP BY product_category
)
SELECT product_category,
       ROUND(revenue, 2)        AS revenue,
       ROUND(cost, 2)           AS cost,
       ROUND(revenue - cost, 2) AS profit,
       ROUND((revenue - cost) / NULLIF(revenue, 0) * 100, 2) AS profit_margin_pct
FROM category_totals
ORDER BY profit DESC;


-- Q34: Find customers whose latest completed order is more than 90 days before
-- the latest order date in the dataset.
-- "Today" = MAX(order_date) over ALL orders (README rule 4).
WITH latest_completed AS (
    SELECT customer_id, MAX(order_date) AS last_order_date
    FROM orders
    WHERE order_status = 'Completed'
    GROUP BY customer_id
),
today AS (
    SELECT MAX(order_date) AS today FROM orders
)
SELECT c.customer_id,
       c.customer_name,
       lc.last_order_date,
       t.today - lc.last_order_date AS days_since_last_order
FROM latest_completed lc
JOIN customers c ON c.customer_id = lc.customer_id
CROSS JOIN today t
WHERE t.today - lc.last_order_date > 90
ORDER BY days_since_last_order DESC;


--### Section E — Window functions (Q35–Q42)

--*Concepts:* `OVER`, `PARTITION BY`, `ROW_NUMBER`, `RANK`, `DENSE_RANK`, `LAG`, `NTILE`

--```sql
--SELECT customer_id, order_date,
     --  ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY order_date DESC) AS n
--FROM orders;
-- RANK leaves gaps after ties (1,1,3); DENSE_RANK does not (1,1,2)
-- running total:  SUM(x) OVER (ORDER BY month)
-- previous row:   LAG(x) OVER (ORDER BY month)
```

--35. Rank customers by spending using `RANK()`.

select
    customer_id,
    sum(quantity * unit_price * (1 - discount / 100)) as spending,
    rank() over (order by sum(quantity * unit_price * (1 - discount / 100)) desc) as customer_rank
from orders
where order_status = 'Completed'
group by customer_id;

--36. Number each customer's orders by recency using `ROW_NUMBER()`.

SELECT customer_id, order_id, order_date, order_status,
       ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY order_date DESC, order_id DESC) AS recency_no
FROM orders
ORDER BY customer_id, recency_no;
--37. Rank products within categories using `DENSE_RANK()`.

SELECT product_category, product_name,
       ROUND(SUM(quantity * unit_price * (1 - discount / 100)), 2) AS revenue,
       DENSE_RANK() OVER (PARTITION BY product_category
                          ORDER BY SUM(quantity * unit_price * (1 - discount / 100)) DESC) AS rank_in_category
FROM orders
WHERE order_status = 'Completed'
GROUP BY product_category, product_name
ORDER BY product_category, rank_in_category;
--38. Calculate cumulative monthly revenue.

WITH monthly AS (
    SELECT DATE_TRUNC('month', order_date)::date AS month,
           SUM(quantity * unit_price * (1 - discount / 100)) AS revenue
    FROM orders
    WHERE order_status = 'Completed'
    GROUP BY 1
)
SELECT month,
       ROUND(revenue, 2) AS revenue,
       ROUND(SUM(revenue) OVER (ORDER BY month), 2) AS cumulative_revenue
FROM monthly
ORDER BY month;
--39. Compare monthly revenue using `LAG()`.

WITH monthly AS (
    SELECT DATE_TRUNC('month', order_date)::date AS month,
           SUM(quantity * unit_price * (1 - discount / 100)) AS revenue
    FROM orders
    WHERE order_status = 'Completed'
    GROUP BY DATE_TRUNC('month', order_date)
)
SELECT month,
       ROUND(revenue, 2) AS revenue,
       ROUND(LAG(revenue) OVER (ORDER BY month), 2) AS previous_month_revenue,
       ROUND(revenue - LAG(revenue) OVER (ORDER BY month), 2) AS change
FROM monthly
ORDER BY month;

--40. Calculate month-over-month revenue growth (%).

-- The first month has no previous month, so its growth is NULL.
WITH monthly AS (
    SELECT DATE_TRUNC('month', order_date)::date AS month,
           SUM(quantity * unit_price * (1 - discount / 100)) AS revenue
    FROM orders
    WHERE order_status = 'Completed'
    GROUP BY DATE_TRUNC('month', order_date)
)
SELECT month,
       ROUND(revenue, 2) AS revenue,
       ROUND((revenue - LAG(revenue) OVER (ORDER BY month))
             / NULLIF(LAG(revenue) OVER (ORDER BY month), 0) * 100, 2) AS growth_pct
FROM monthly
ORDER BY month;
--41. Divide customers into four spending groups using `NTILE(4)`.

-- Purchasing customers only (Completed orders). Group 1 = top 25% spenders.
WITH customer_spend AS (
    SELECT c.customer_id,
           c.customer_name,
           SUM(o.quantity * o.unit_price * (1 - o.discount / 100)) AS total_spent
    FROM customers c
    JOIN orders o ON o.customer_id = c.customer_id
    WHERE o.order_status = 'Completed'
    GROUP BY c.customer_id, c.customer_name
)
SELECT customer_id,
       customer_name,
       ROUND(total_spent, 2) AS total_spent,
       NTILE(4) OVER (ORDER BY total_spent DESC) AS spending_group
FROM customer_spend
ORDER BY spending_group, total_spent DESC;
--42. Calculate each category's share of total revenue using window functions.

-- SUM(SUM(x)) OVER () gives the grand total next to each category.
SELECT product_category,
       ROUND(SUM(quantity * unit_price * (1 - discount / 100)), 2) AS revenue,
       ROUND(SUM(quantity * unit_price * (1 - discount / 100)) * 100.0
             / SUM(SUM(quantity * unit_price * (1 - discount / 100))) OVER (), 2) AS revenue_share_pct
FROM orders
WHERE order_status = 'Completed'
GROUP BY product_category
ORDER BY revenue_share_pct DESC;

*Tip:* for monthly questions, build a `monthly` CTE (month, revenue) first, then apply the window
function to it. *Q42:* `SUM(SUM(x)) OVER ()` is the grand total next to each group.




-- ==========================================
-- SECTION F: Advanced Business Intelligence (Q43 - Q46)
-- ==========================================

-- Q43: Create a monthly_sales_summary view (month, orders, revenue, cost, profit).
-- "orders" counts every order in the month (README rule 2);
-- revenue, cost and profit use Completed orders only (README rule 1).
CREATE OR REPLACE VIEW monthly_sales_summary AS
SELECT DATE_TRUNC('month', order_date)::date AS month,
       COUNT(*) AS orders,
       ROUND(COALESCE(SUM(quantity * unit_price * (1 - discount / 100))
                      FILTER (WHERE order_status = 'Completed'), 0), 2) AS revenue,
       ROUND(COALESCE(SUM(quantity * cost_price)
                      FILTER (WHERE order_status = 'Completed'), 0), 2) AS cost,
       ROUND(COALESCE(SUM(quantity * unit_price * (1 - discount / 100) - quantity * cost_price)
                      FILTER (WHERE order_status = 'Completed'), 0), 2) AS profit
FROM orders
GROUP BY DATE_TRUNC('month', order_date);

SELECT * FROM monthly_sales_summary ORDER BY month;


-- Q44: Function returning completed-order revenue for a customer ID.
-- COALESCE makes an unknown customer (or one with no completed orders) return 0, not NULL.
CREATE OR REPLACE FUNCTION get_customer_revenue(p_customer_id INTEGER)
RETURNS NUMERIC
LANGUAGE plpgsql
AS $$
DECLARE
    v_result NUMERIC;
BEGIN
    SELECT COALESCE(ROUND(SUM(quantity * unit_price * (1 - discount / 100)), 2), 0)
    INTO v_result
    FROM orders
    WHERE customer_id = p_customer_id
      AND order_status = 'Completed';

    RETURN v_result;
END;
$$;

-- An existing customer:
SELECT get_customer_revenue(141) AS revenue_customer_141;
-- A customer ID that does not exist (should return 0):
SELECT get_customer_revenue(9999) AS revenue_customer_9999;


-- Q45: Segment customers into High, Medium and Low Value.
-- Thresholds: percentiles of completed-order spending among purchasing customers.
--   High   = at or above the 75th percentile (top quarter of spenders)
--   Medium = between the 25th and 75th percentile (the middle half)
--   Low    = below the 25th percentile, plus customers who have not spent anything
-- Why percentiles: they adapt to the data's spread and give a roughly 25/50/25 split,
-- so "High" means the customers who matter most rather than an arbitrary round amount.
WITH spend AS (
    SELECT c.customer_id,
           c.customer_name,
           COALESCE(SUM(o.quantity * o.unit_price * (1 - o.discount / 100))
                    FILTER (WHERE o.order_status = 'Completed'), 0) AS total_spent
    FROM customers c
    LEFT JOIN orders o ON o.customer_id = c.customer_id
    GROUP BY c.customer_id, c.customer_name
),
thresholds AS (
    SELECT percentile_cont(0.75) WITHIN GROUP (ORDER BY total_spent) AS p75,
           percentile_cont(0.25) WITHIN GROUP (ORDER BY total_spent) AS p25
    FROM spend
    WHERE total_spent > 0
),
segmented AS (
    SELECT s.customer_id,
           s.customer_name,
           ROUND(s.total_spent, 2) AS total_spent,
           CASE WHEN s.total_spent >= t.p75 THEN 'High Value'
                WHEN s.total_spent >= t.p25 THEN 'Medium Value'
                ELSE 'Low Value'
           END AS value_band
    FROM spend s
    CROSS JOIN thresholds t
)
SELECT value_band,
       COUNT(*) AS customers,
       ROUND(SUM(total_spent), 2) AS band_revenue
FROM segmented
GROUP BY value_band
ORDER BY band_revenue DESC;
-- To see each customer's band, replace the final SELECT with: SELECT * FROM segmented ORDER BY total_spent DESC;


-- Q46: Management report (Completed orders only for all money figures).

-- 46a: Top five customers by spending

SELECT c.customer_id, c.customer_name,
       ROUND(SUM(o.quantity * o.unit_price * (1 - o.discount / 100)), 2) AS total_spent
FROM customers c
JOIN orders o ON o.customer_id = c.customer_id
WHERE o.order_status = 'Completed'
GROUP BY c.customer_id, c.customer_name
ORDER BY total_spent DESC
LIMIT 5;

-- 46b: Top five products by revenue
SELECT product_name,
       ROUND(SUM(quantity * unit_price * (1 - discount / 100)), 2) AS revenue
FROM orders
WHERE order_status = 'Completed'
GROUP BY product_name
ORDER BY revenue DESC
LIMIT 5;

-- 46c: Most profitable category
SELECT product_category,
       ROUND(SUM(quantity * unit_price * (1 - discount / 100)) - SUM(quantity * cost_price), 2) AS profit
FROM orders
WHERE order_status = 'Completed'
GROUP BY product_category
ORDER BY profit DESC
LIMIT 1;

-- 46d: Lowest-revenue month
SELECT DATE_TRUNC('month', order_date)::date AS month,
       ROUND(SUM(quantity * unit_price * (1 - discount / 100)), 2) AS revenue
FROM orders
WHERE order_status = 'Completed'
GROUP BY DATE_TRUNC('month', order_date)
ORDER BY revenue ASC
LIMIT 1;

