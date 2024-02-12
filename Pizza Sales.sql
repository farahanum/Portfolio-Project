select * from dbo.pizza_sales

-- Total revenue (Sum of total price of all pizza order)

SELECT SUM(TOTAL_PRICE) AS TOTAL_REVENUE FROM PIZZA_SALES

-- Average order value (Average amount spent per order)

SELECT SUM(TOTAL_PRICE)/COUNT( DISTINCT ORDER_ID) AS Avg_Order_Value FROM PIZZA_SALES

-- Total pizza sold

Select SUM(QUANTITY) AS Total_Pizza_Sold FROM PIZZA_SALES

-- Total orders (Total no of order placed)

SELECT COUNT( DISTINCT ORDER_ID) AS Total_orders FROM PIZZA_SALES

-- Average Pizza per orders

SELECT CAST(CAST(SUM(QUANTITY) AS decimal(10,2))/
	cast(COUNT( DISTINCT ORDER_ID) AS DECIMAL(10,2)) AS DECIMAL(10,2)) 
FROM PIZZA_SALES

-- Daily trend for total orders

SELECT DATENAME(DW, order_date) AS order_day, COUNT(DISTINCT order_id) AS total_orders 
FROM pizza_sales
GROUP BY DATENAME(DW, order_date)

