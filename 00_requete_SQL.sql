
Determination du CA par An :

SELECT YEAR(order_date) as date,  SUM(ROUND(oi.list_price,2)) as  CA
FROM orders o
left JOIN order_items oi on o.order_id = oi.order_id -- jointure des tables orders_items et orders
group by date
order by date


"2016"  "1806105.07"
"2017"  "2567332.96"
"2018"  "1352968.54"

Determination du magasin qui enregistre le plus de commande :

SELECT o.store_id, st.store_name, COUNT(order_id) as nb_cmde
FROM orders o
LEFT JOIN stores st on o.store_id = st.store_id -- jointure des tables orders et stores
GROUP BY o.store_id
ORDER BY nb_cmde DESC

"2"	"Baldwin Bikes"	"1093"
"1"	"Santa Cruz Bikes"	"348"
"3"	"Rowlett Bikes"	"174"






Cout du discount / An

SELECT year(order_date) as date , sum(ROUND(quantity*list_price*discount,2)) as discount
FROM orders o
left JOIN order_items oi on o.order_id = oi.order_id
group by date

"2016"	"282108.30"
"2017"	"398309.96"
"2018"	"209460.91"


evolution du discount par an et par mois (voir si il y a des pics)

SELECT year(order_date) as date, month(order_date) as month_date , sum(ROUND(quantity*list_price*discount,2)) as discount
FROM orders o
left JOIN order_items oi on o.order_id = oi.order_id
group by date, month_date

Evolution des cmde par marque de Bike

SELECT year(order_date) as Year, b.brand_name, sum(quantity)
FROM orders o 
left join order_items as oi ON o.order_id = oi.order_id
left join products as pd on oi.product_id = pd.product_id
left join categories as cat on pd.category_id = cat.category_id
LEFT JOIN brands as b on b.brand_id = pd.brand_id
group by year, brand_name
order by Year

Evolution des commandes par marque en 2017 :

SELECT year(order_date) as Year, b.brand_name, sum(quantity)
FROM orders o 
left join order_items as oi ON o.order_id = oi.order_id -- création des différentes jointures des tables
left join products as pd on oi.product_id = pd.product_id
left join categories as cat on pd.category_id = cat.category_id
LEFT JOIN brands as b on b.brand_id = pd.brand_id
group by year, brand_name
having year = 2017 -- having pour faire filtrer l'année
order by sum(quantity) desc - classement par quantité descendant

SELECT * 
FROM orders o 
left join order_items as oi ON o.order_id = oi.order_id
left join products as pd on oi.product_id = pd.product_id
left join categories as cat on pd.category_id = cat.category_id


SELECT year(order_date) as Year, cat.category_name, sum(quantity)
FROM orders o 
left join order_items as oi ON o.order_id = oi.order_id
left join products as pd on oi.product_id = pd.product_id
left join categories as cat on pd.category_id = cat.category_id
group by year, category_name
order by Year

"2016"	"Children Bicycles"	"350"
"2016"	"Comfort Bicycles"	"313"
"2016"	"Cruisers Bicycles"	"924"
"2016"	"Cyclocross Bicycles"	"233"
"2016"	"Electric Bikes"	"104"
"2016"	"Mountain Bikes"	"739"
"2017"	"Children Bicycles"	"589"
"2017"	"Comfort Bicycles"	"373"
"2017"	"Cruisers Bicycles"	"814"
"2017"	"Cyclocross Bicycles"	"128"
"2017"	"Electric Bikes"	"98"
"2017"	"Mountain Bikes"	"764"
"2017"	"Road Bikes"	"333"
"2018"	"Children Bicycles"	"240"
"2018"	"Comfort Bicycles"	"127"
"2018"	"Cruisers Bicycles"	"325"
"2018"	"Cyclocross Bicycles"	"33"
"2018"	"Electric Bikes"	"113"
"2018"	"Mountain Bikes"	"252"
"2018"	"Road Bikes"	"226"

best sellers

SELECT  cat.category_name, sum(quantity)
FROM orders o 
left join order_items as oi ON o.order_id = oi.order_id
left join products as pd on oi.product_id = pd.product_id
left join categories as cat on pd.category_id = cat.category_id
group by  category_name
order by category_name

"Children Bicycles"	"1179"
"Comfort Bicycles"	"813"
"Cruisers Bicycles"	"2063"
"Cyclocross Bicycles"	"394"
"Electric Bikes"	"315"
"Mountain Bikes"	"1755"
"Road Bikes"	"559"

best sellers par an 

SELECT year(order_date) as Year,   cat.category_name, sum(quantity) as quantity
FROM orders o 
left join order_items as oi ON o.order_id = oi.order_id
left join products as pd on oi.product_id = pd.product_id
left join categories as cat on pd.category_id = cat.category_id
group by year, category_name
order by year, quantity desc


SELECT 
    order_id,
    ROUND(SUM(quantity * list_price * (1 - discount)), 2) final_sale_price
FROM 
    order_items
GROUP BY
    1

ORDER BY
    2 DESC;

    
SELECT year(order_date) as Year,  st.store_name, cat.category_name, sum(quantity) as quantity, SUM(ROUND(oi.list_price,2))  AS CA
FROM orders o 
left join order_items as oi ON o.order_id = oi.order_id
left join products as pd on oi.product_id = pd.product_id
left join categories as cat on pd.category_id = cat.category_id
left join stores as st on o.store_id = st.store_id
group by store_name, category_name, year
order by year, store_name

moyenne d article commandé :

SELECT avg(quanity)
FROM order_items 

1.48

CALCUL DU CA PAR order_id:

SELECT order_id, ROUND((quantity*list_price)-(quantity*list_price*discount),2) as CA
FROM order_items
group by order_id

-- calcul CA total :
SELECT  sum(ROUND((quantity*list_price)-(quantity*list_price*discount),2)) as CA
    FROM order_items


Calcul du CA et de la moyenne de CA par order ID en 1 requete (partition by ) :

SELECT 
    YEAR(order_date) AS year,
    o.order_id,
    ROUND(SUM(quantity * oi.list_price - quantity * oi.list_price * discount), 2) AS CA,
    ROUND(SUM((quantity * oi.list_price - quantity * oi.list_price * discount) / quantity)
        OVER (PARTITION BY o.order_id),2) AS Avg_CA
FROM 
    orders o
LEFT JOIN 
    order_items oi ON o.order_id = oi.order_id
LEFT JOIN 
    products pd ON oi.product_id = pd.product_id
LEFT JOIN 
    categories cat ON pd.category_id = cat.category_id
LEFT JOIN 
    stores st ON o.store_id = st.store_id
Group by year(order_date), order_id



CAlcul du CA par an, nb de cmde et avg_ca par An


SELECT 
    YEAR(order_date) AS year,
    st.store_name,
    COUNT(DISTINCT o.order_id) as nb_cmde,
    ROUND(SUM(quantity * oi.list_price - quantity * oi.list_price * discount), 2) AS CA,
    ROUND(SUM(quantity * oi.list_price - quantity * oi.list_price * discount)/ COUNT(DISTINCT o.order_id), 2) AS Avg_CA
FROM 
    orders o
LEFT JOIN 
    order_items oi ON o.order_id = oi.order_id
LEFT JOIN 
    products pd ON oi.product_id = pd.product_id
LEFT JOIN 
    categories cat ON pd.category_id = cat.category_id
LEFT JOIN 
    stores st ON o.store_id = st.store_id
Group by year(order_date), store_name


evaluation du cout du discount :

SELECT 
    YEAR(order_date) AS year,
    st.store_name,
    COUNT(DISTINCT o.order_id) as nb_cmde,
    ROUND(SUM(quantity * oi.list_price - quantity * oi.list_price * discount), 2) AS CA,
    ROUND(SUM(quantity * oi.list_price - quantity * oi.list_price * discount)/ COUNT(DISTINCT o.order_id), 2) AS Avg_CA,
    ROUND(SUM(quantity * oi.list_price * discount), 2) AS Amount_discount,
    ROUND(SUM(quantity * oi.list_price * discount)/ COUNT(DISTINCT o.order_id), 2) as AVG_Amount_discount,
    ROUND(SUM(quantity * oi.list_price * discount)/ SUM(quantity * oi.list_price - quantity * oi.list_price * discount),2)*100 AS Discount_percentage
FROM 
    orders o
LEFT JOIN 
    order_items oi ON o.order_id = oi.order_id
LEFT JOIN 
    products pd ON oi.product_id = pd.product_id
LEFT JOIN 
    categories cat ON pd.category_id = cat.category_id
LEFT JOIN 
    stores st ON o.store_id = st.store_id
Group by year(order_date), store_name

