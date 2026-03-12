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
day_hour_orders AS (SELECT day_name, EXTRACT(HOUR FROM order_purchase_timestamp) AS "hour", COUNT(DISTINCT order_id) AS "unique_orders" FROM total_orders_info GROUP BY 1, 2)
SELECT 
  day_name, 
  CASE 
    WHEN hour BETWEEN 0 AND 6 THEN 'Night' 
    WHEN hour BETWEEN 7 AND 12 THEN 'Morning' 
    WHEN hour BETWEEN 13 AND 18 'Day' 
    ELSE 'Evening' 
  END AS "daytime",
  SUM(unique_orders) AS "total_orders"
FROM
  day_hour_orders
GROUP BY 1, 2
ORDER BY 1, 2