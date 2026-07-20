create database
pharma

use
pharma

select *
from sales

--WHAT ARE THE COMPANY'S TOTAL REVENUE, TOTAL PROFIT,TOTAL ORDERS AND TOTAL QUANTITY SOLD ?

select 
sum(sales_amount) as total_revenue,
sum(profit) as total_profit,
sum(quantity) as total_quantity_sold,
count(invoice_id) as total_orders,
avg(profit) as avg_profit_per_order
from sales


--Which medicines generate the highest sales revenue?

select
p.medicine_name,
sum(s.sales_amount) as revenue
from sales s
join products p
on s.product_id = p.product_id 
group by p.medicine_name
order by revenue desc


--Which medicines generate the highest profit?

select
p.medicine_name,
sum(s.profit) as total_profit
from sales s 
join products p
on s.product_id = p.product_id 
group by p.medicine_name 
order by total_profit desc


--Which product categories contribute the most revenue and profit?

select 
p.category,
sum(s.sales_amount) as revenue,
sum(s.profit) as profit
from sales s 
join products p
on s.product_id = p.product_id 
group by p.category
order by revenue desc


--Which manufacturers contribute the highest revenue and profit?

select
p.manufacturer,
sum(s.sales_amount) as revenue,
sum(s.profit) as profit
from sales s
join products p
on s.product_id = p.product_id 
group by p.manufacturer
order by revenue desc




select 
sum(sales_amount) as total_revenue,
sum(profit) as total_profit,
sum(quantity) as total_quantity_sold,
count(invoice_id) as total_orders,
avg(profit) as avg_profit_per_order
from sales 


--Which payment methods are most preferred by customers, and how much revenue does each generate?

select 
payment_mode,
count(*) total_orders,
sum(sales_amount) as revenue,
sum(profit) as profit
from sales
group by payment_mode
order by revenue desc


--How does the discount percentage affect sales revenue and profit?

select 
discount_percent,
count(*) as orders,
sum(sales_amount) as revenue,
sum(profit) as profit,
avg(profit) as avg_profit
from sales
group by discount_percent
order by discount_percent





--What is the return rate, and what impact do returned orders have on revenue and profit?

select 
return_flag,
count(*) as total_orders,
sum(sales_amount) as revenue,
sum(profit) as profit
from sales 
group by return_flag


--What is the average, minimum, and maximum delivery time for customer orders?

select 
avg(delivery_days) as avg_delivery_days,
min(delivery_days) as fastest_delivery,
max(delivery_days)  as slowest_delivery
from sales

--Which salespersons generate the highest revenue, profit, and sales volume?

select
sp.salesperson_name,
sum(s.sales_amount) as revenue,
sum(s.profit) as profit,
sum(s.quantity) as quantity_sold 
from sales s
join salesperson sp
on s.salesperson_id =  sp.salesperson_id 
group by sp.salesperson_name 
order by revenue desc

--Which products have fallen below their reorder level and need replenishment?

select 
p.product_id,
p.medicine_name,
i.current_stock,
i.reorder_level
from inventory i
join products p
on i.product_id = p.product_id 
where i.current_stock <= i.reorder_level
order by i.current_stock


--What is the distribution of products across different stock statuses (In Stock, Low Stock, Out of Stock)?

select
stock_status,
count(*) as total_products 
from inventory
group by Stock_Status
order by total_products desc



--What is the inventory value available in each warehouse?

select 
i.warehouse,
sum(i.current_stock * p.cost_price) as inventory_value 
from inventory i
join products p on i.product_id = p.product_id 
group by i.warehouse
order by inventory_value desc

--Which medicines are nearing expiry and require immediate attention?

select 
p.medicine_name,
i.warehouse,
i.current_stock,
i.expiry_month
from inventory i
join products p
on i.Product_ID = p.Product_ID
where cast(i.Expiry_Month + '-01' as date)  <= dateadd(month,3,getdate())
order by i.Expiry_Month



--Which medicines have the highest inventory turnover rate?

SELECT
    p.Medicine_Name,
    i.Quantity_Sold,
    i.Current_Stock,
    ROUND(
        CAST(i.Quantity_Sold AS FLOAT) /
        NULLIF(i.Opening_Stock + i.Stock_Received, 0),
        2
    ) AS Inventory_Turnover
FROM inventory i
JOIN products p
ON i.Product_ID = p.Product_ID
ORDER BY Inventory_Turnover DESC;



--How do revenue, profit, and quantity sold change month by month?

SELECT
    d.Year,
    d.Month,
    d.Month_Name,
    SUM(s.Sales_Amount) AS Total_Revenue,
    SUM(s.Profit) AS Total_Profit,
    SUM(s.Quantity) AS Total_Quantity
FROM sales s
JOIN dates d
ON s.Order_Date = d.Date
GROUP BY d.Year, d.Month, d.Month_Name
ORDER BY d.Year, d.Month;


--Which quarter performs best in terms of revenue and profit?

SELECT
    d.Year,
    d.Quarter,
    SUM(s.Sales_Amount) AS Revenue,
    SUM(s.Profit) AS Profit
FROM sales s
JOIN dates d
ON s.Order_Date = d.Date
GROUP BY d.Year, d.Quarter
ORDER BY d.Year, d.Quarter;




--How has business performance changed year over year?

SELECT
    d.Year,
    SUM(s.Sales_Amount) AS Revenue,
    SUM(s.Profit) AS Profit,
    SUM(s.Quantity) AS Quantity_Sold
FROM sales s
JOIN dates d
ON s.Order_Date = d.Date
GROUP BY d.Year
ORDER BY d.Year;



--Which months generate the highest revenue?

SELECT
    d.Month_Name,
    SUM(s.Sales_Amount) AS Revenue
FROM sales s
JOIN dates d
ON s.Order_Date = d.Date
GROUP BY d.Month_Name
ORDER BY Revenue DESC;




--Are sales higher on weekdays or weekends?

SELECT
    d.Weekend,
    COUNT(s.Invoice_ID) AS Orders,
    SUM(s.Sales_Amount) AS Revenue,
    SUM(s.Profit) AS Profit
FROM sales s
JOIN dates d
ON s.Order_Date = d.Date
GROUP BY d.Weekend;



--Which are the Top 10 revenue-generating medicines?

SELECT TOP 10
    p.Medicine_Name,
    SUM(s.Sales_Amount) AS Revenue
FROM sales s
JOIN products p
ON s.Product_ID = p.Product_ID
GROUP BY p.Medicine_Name
ORDER BY Revenue DESC;




--Which are the Top 10 most profitable medicines?

SELECT TOP 10
    p.Medicine_Name,
    SUM(s.Profit) AS Profit
FROM sales s
JOIN products p
ON s.Product_ID = p.Product_ID
GROUP BY p.Medicine_Name
ORDER BY Profit DESC;


--How do salespersons rank based on revenue generated?

SELECT top 10
    sp.Salesperson_Name,
    SUM(s.Sales_Amount) AS Revenue,
    RANK() OVER(
        ORDER BY SUM(s.Sales_Amount) DESC
    ) AS Sales_Rank
FROM sales s
JOIN salesperson sp
ON s.Salesperson_ID = sp.Salesperson_ID
GROUP BY sp.Salesperson_Name;




--How do medicines rank based on revenue generated?

SELECT top 10
    p.Medicine_Name,
    SUM(s.Sales_Amount) AS Revenue,
    DENSE_RANK() OVER(
        ORDER BY SUM(s.Sales_Amount) DESC
    ) AS Product_Rank
FROM sales s
JOIN products p
ON s.Product_ID = p.Product_ID
GROUP BY p.Medicine_Name;


--How does cumulative (running) profit grow over time?

SELECT
    d.Year,
    d.Month,
    SUM(s.Profit) AS Monthly_Profit,
    SUM(SUM(s.Profit))
    OVER(
        ORDER BY d.Year,d.Month
    ) AS Running_Profit
FROM sales s
JOIN dates d
ON s.Order_Date=d.Date
GROUP BY d.Year,d.Month
ORDER BY d.Year,d.Month;


--Which product category generates the highest overall revenue?

SELECT TOP 1
Category,
SUM(s.Sales_Amount) Revenue
FROM sales s
JOIN products p
ON s.Product_ID=p.Product_ID
GROUP BY Category
ORDER BY Revenue DESC;



--Which warehouse is the most efficient based on inventory sold and stock availability?

SELECT
Warehouse,
SUM(Current_Stock) Stock,
SUM(Quantity_Sold) Sold
FROM inventory
GROUP BY Warehouse
ORDER BY Sold DESC;




--Which product categories have the highest profit margins?

SELECT
Category,
ROUND(
SUM(s.Profit)*100.0/
SUM(s.Sales_Amount),2
) AS Profit_Margin
FROM sales s
JOIN products p
ON s.Product_ID=p.Product_ID
GROUP BY Category
ORDER BY Profit_Margin DESC;




--Which salespersons achieved or exceeded their assigned sales targets?

SELECT
    sp.Salesperson_Name,
    sp.Target,
    SUM(s.Sales_Amount) AS Achieved_Sales,
    SUM(s.Sales_Amount) - sp.Target AS Target_Variance,
    ROUND((SUM(s.Sales_Amount) * 100.0 / sp.Target), 2) AS Achievement_Percentage
FROM sales s
JOIN salesperson sp
ON s.Salesperson_ID = sp.Salesperson_ID
GROUP BY sp.Salesperson_Name, sp.Target
ORDER BY Achievement_Percentage DESC;



--How has monthly revenue changed compared with the previous month (Month-over-Month Growth)?

WITH MonthlySales AS
(
    SELECT
        d.Year,
        d.Month,
        SUM(s.Sales_Amount) AS Revenue
    FROM sales s
    JOIN dates d
    ON s.Order_Date = d.Date
    GROUP BY d.Year, d.Month
)

SELECT
    Year,
    Month,
    Revenue,
    LAG(Revenue) OVER(ORDER BY Year, Month) AS Previous_Month_Revenue,
    Revenue - LAG(Revenue) OVER(ORDER BY Year, Month) AS Revenue_Change
FROM MonthlySales;





--How has yearly revenue changed compared with the previous year (Year-over-Year Growth)?

WITH YearlySales AS
(
    SELECT
        d.Year,
        SUM(s.Sales_Amount) AS Revenue
    FROM sales s
    JOIN dates d
    ON s.Order_Date = d.Date
    GROUP BY d.Year
)

SELECT
    Year,
    Revenue,
    LAG(Revenue) OVER(ORDER BY Year) AS Previous_Year_Revenue,
    Revenue - LAG(Revenue) OVER(ORDER BY Year) AS Growth
FROM YearlySales;






--Which medicines contribute most to total revenue according to the Pareto (80/20) principle?

WITH ProductRevenue AS
(
    SELECT
        p.Medicine_Name,
        SUM(s.Sales_Amount) AS Revenue
    FROM sales s
    JOIN products p
    ON s.Product_ID = p.Product_ID
    GROUP BY p.Medicine_Name
)

SELECT
    Medicine_Name,
    Revenue,
    SUM(Revenue) OVER(ORDER BY Revenue DESC) AS Cumulative_Revenue
FROM ProductRevenue
ORDER BY Revenue DESC;



--Can we create a reusable sales summary view for reporting and dashboard development?

CREATE VIEW vw_sales_summary AS
SELECT
    d.Year,
    d.Month_Name,
    p.Category,
    SUM(s.Sales_Amount) AS Revenue,
    SUM(s.Profit) AS Profit,
    SUM(s.Quantity) AS Quantity_Sold
FROM sales s
JOIN products p
ON s.Product_ID = p.Product_ID
JOIN dates d
ON s.Order_Date = d.Date
GROUP BY
    d.Year,
    d.Month_Name,
    p.Category;
