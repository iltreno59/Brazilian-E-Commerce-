Анализ маркетплейса Olist (E-commerce)

Набор данных - https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce

Стек: PostgreSQL (Docker), Apache Superset.

Цель: Исследовать операционные показатели бизнеса и лояльность клиентов.

Ключевые блоки (Highlights):
- Retention: Построил когортный анализ, выявил низкую возвращаемость (менее 1%), что характерно для товаров длительного пользования (запрос cohort_analysis.sql).
<img width="936" height="419" alt="image" src="https://github.com/user-attachments/assets/7e55ccbb-32a0-43a7-9991-c41e915ade22" />

- Логистика: Обнаружил, что доставка занимает 70% времени всего цикла заказа, при этом компания сильно перестраховывается в обещанных сроках (fummel_analysis.sql).
<img width="888" height="279" alt="image" src="https://github.com/user-attachments/assets/6598a7f4-4313-4feb-aff2-5d8528ea6406" />

- ABC-анализ: Выделил ТОП-16 категорий, приносящих 80% выручки, расходы на остальные в реальном бизнесе можно было бы сократить.

<img width="430" height="110" alt="image" src="https://github.com/user-attachments/assets/d80718f0-bb59-48c5-ad29-043159dff0ae" /> (пример топ-5 из категории A, abc_analysis.sql)

<img width="440" height="290" alt="image" src="https://github.com/user-attachments/assets/acd93f3d-2d23-45f8-8358-0098a05edaec" />

- Провёл аналитику по активности пользователей в разные временные промежутки разных дней недели - наибольшая активность наблюдается в вечера понедельника и вторника, далее идёт на спад. Ночью, ожидаемо, просадок (user_activity_by_daytime_analysis.sql)

<img width="890" height="286" alt="image" src="https://github.com/user-attachments/assets/110ad986-68f8-46dd-b7fa-bd64aed2c67d" />

- Визуализировал динамику таких метрик, как GMV, AOV и кол-во заказов по месяцам (monthly_metrics.sql)

<img width="894" height="300" alt="image" src="https://github.com/user-attachments/assets/34fb1b6f-10c6-498d-8cd9-107ca746e210" />


