SELECT
  1 AS "Funnel",
  AVG(EXTRACT(EPOCH FROM (order_approved_at - order_purchase_timestamp))/86400) AS "1. Оплата (дн.)",
  AVG(EXTRACT(EPOCH FROM (order_delivered_carrier_date - order_approved_at))/86400) AS "2. Склад (дн.)",
  AVG(EXTRACT(EPOCH FROM (order_delivered_customer_date - order_delivered_carrier_date))/86400) AS "3. Доставка (дн.)"
FROM olist_orders_dataset
WHERE order_delivered_customer_date IS NOT NULL 
  AND order_delivered_carrier_date IS NOT NULL 
  AND order_approved_at IS NOT NULL