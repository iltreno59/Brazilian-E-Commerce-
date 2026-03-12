WITH total_orders_info AS (SELECT
    ood.order_id,
    ocd.customer_unique_id,
    ood.order_purchase_timestamp,
    EXTRACT(YEAR FROM ood.order_purchase_timestamp) AS "year_date",
    EXTRACT(MONTH FROM ood.order_purchase_timestamp) AS "month_date",
    TO_CHAR(order_purchase_timestamp, 'TMDay') AS "day_name",
    items_amount.total_products,
    items.total_price,
    payments.total_payment,
    opd.product_category_name,
    pcnt.product_category_name_english
FROM olist_orders_dataset ood
INNER JOIN (
    SELECT order_id, product_id, SUM(price) as total_price
    FROM olist_order_items_dataset 
    GROUP BY order_id, product_id
) items ON ood.order_id = items.order_id
INNER JOIN (
    SELECT order_id, COUNT(product_id) AS "total_products" FROM olist_order_items_dataset GROUP BY order_id 
) items_amount ON items_amount.order_id = ood.order_id
INNER JOIN olist_products_dataset opd ON items.product_id = opd.product_id
INNER JOIN olist_customers_dataset ocd ON ood.customer_id = ocd.customer_id
INNER JOIN (
    SELECT order_id, SUM(payment_value) as total_payment 
    FROM olist_order_payments_dataset 
    GROUP BY order_id
) payments ON ood.order_id = payments.order_id
INNER JOIN product_category_name_translation pcnt ON pcnt.product_category_name = opd.product_category_name),
GMV_parts AS (SELECT product_category_name_english, SUM(total_price)/SUM(SUM(total_price)) OVER() * 100 AS GMV_part  FROM total_orders_info GROUP BY 1 ORDER BY 2 DESC),
cumulative_sums AS (SELECT product_category_name_english, GMV_part, SUM(GMV_part) OVER(ORDER BY GMV_part DESC) AS "cumulative_sum" FROM GMV_parts),
cumulative_sums_parts AS (SELECT product_category_name_english, CASE WHEN cumulative_sum < 80 THEN '80%' WHEN cumulative_sum < 95 THEN '15%' ELSE '5%' END AS "abc_part" FROM cumulative_sums)
SELECT *, COUNT(product_category_name_english) OVER(PARTITION BY ABC_part) AS "amount_in_part" FROM cumulative_sums_parts ORDER BY 2 DESC, 1
