WITH first_orders AS (
    SELECT 
        ocd.customer_unique_id, 
        MIN(ood.order_purchase_timestamp) AS first_order_date
    FROM olist_orders_dataset ood
    JOIN olist_customers_dataset ocd ON ood.customer_id = ocd.customer_id
    GROUP BY 1
),
cohort_data AS (
    SELECT 
        f.customer_unique_id,
        TO_CHAR(f.first_order_date, 'YYYY-MM') AS cohort_month,
        (EXTRACT(YEAR FROM ood.order_purchase_timestamp) * 12 + EXTRACT(MONTH FROM ood.order_purchase_timestamp)) -
        (EXTRACT(YEAR FROM f.first_order_date) * 12 + EXTRACT(MONTH FROM f.first_order_date)) AS month_index
    FROM first_orders f
    JOIN olist_customers_dataset ocd ON f.customer_unique_id = ocd.customer_unique_id
    JOIN olist_orders_dataset ood ON ocd.customer_id = ood.customer_id
),
cohort_counts AS (
    SELECT 
        cohort_month,
        month_index,
        COUNT(DISTINCT customer_unique_id) AS active_customers
    FROM cohort_data
    GROUP BY 1, 2
),
cohort_sizes AS (
    SELECT 
        cohort_month,
        active_customers AS size_at_zero
    FROM cohort_counts
    WHERE month_index = 0
)
SELECT 
    cc.cohort_month,
    cc.month_index,
    CAST(cc.active_customers AS FLOAT) / cs.size_at_zero AS retention_rate
FROM cohort_counts cc
JOIN cohort_sizes cs ON cc.cohort_month = cs.cohort_month
WHERE cc.month_index >= 0 
ORDER BY 1, 2;