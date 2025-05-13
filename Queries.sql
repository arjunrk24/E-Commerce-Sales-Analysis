/* 1. Total Revenue */
SELECT 
  SUM(od.quantityOrdered * od.priceEach) AS total_revenue
FROM 
  orderdetails od;
  
/* 2. Monthly Sales Trend */
SELECT 
  DATE_FORMAT(o.orderDate, '%Y-%m') AS month,
  SUM(od.quantityOrdered * od.priceEach) AS monthly_sales
FROM 
  orders o
JOIN 
  orderdetails od ON o.orderNumber = od.orderNumber
GROUP BY 
  month
ORDER BY 
  month;
  
/* 3. Top 10 Best-Selling Products */
SELECT 
  p.productName,
  SUM(od.quantityOrdered) AS total_sold
FROM 
  orderdetails od
JOIN 
  products p ON od.productCode = p.productCode
GROUP BY 
  p.productName
ORDER BY 
  total_sold DESC
LIMIT 10;

/* 4. Average Order Value (AOV) */
SELECT 
  AVG(order_total) AS average_order_value
FROM (
  SELECT 
    o.orderNumber,
    SUM(od.quantityOrdered * od.priceEach) AS order_total
  FROM 
    orders o
  JOIN 
    orderdetails od ON o.orderNumber = od.orderNumber
  GROUP BY 
    o.orderNumber
) AS sub;

/* 5. Highest Spending Customers */
SELECT 
  c.customerName,
  SUM(od.quantityOrdered * od.priceEach) AS total_spent
FROM 
  customers c
JOIN 
  orders o ON c.customerNumber = o.customerNumber
JOIN 
  orderdetails od ON o.orderNumber = od.orderNumber
GROUP BY 
  c.customerName
ORDER BY 
  total_spent DESC
LIMIT 10;

/* 6. Sales by Country */
SELECT 
  c.country,
  SUM(od.quantityOrdered * od.priceEach) AS total_sales
FROM 
  customers c
JOIN 
  orders o ON c.customerNumber = o.customerNumber
JOIN 
  orderdetails od ON o.orderNumber = od.orderNumber
GROUP BY 
  c.country
ORDER BY 
  total_sales DESC;
  
/* 7. Repeat vs. One-Time Customers */
SELECT 
  CASE 
    WHEN order_count = 1 THEN 'One-Time Customer'
    ELSE 'Repeat Customer'
  END AS customer_type,
  COUNT(*) AS number_of_customers
FROM (
  SELECT 
    customerNumber,
    COUNT(orderNumber) AS order_count
  FROM 
    orders
  GROUP BY 
    customerNumber
) AS sub
GROUP BY 
  customer_type;

/* 8. Product Line Performance */
 SELECT 
  pl.productLine,
  SUM(od.quantityOrdered * od.priceEach) AS revenue
FROM 
  orderdetails od
JOIN 
  products p ON od.productCode = p.productCode
JOIN 
  productlines pl ON p.productLine = pl.productLine
GROUP BY 
  pl.productLine
ORDER BY 
  revenue DESC;

/* 9. Peak Order Days */
SELECT 
  DAYNAME(orderDate) AS day_of_week,
  COUNT(*) AS total_orders
FROM 
  orders
GROUP BY 
  day_of_week
ORDER BY 
  FIELD(day_of_week, 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday');

/* 10. Sales by Office Location */
SELECT 
  o.city AS office_city,
  SUM(od.quantityOrdered * od.priceEach) AS office_sales
FROM 
  employees e
JOIN 
  customers c ON e.employeeNumber = c.salesRepEmployeeNumber
JOIN 
  orders ord ON c.customerNumber = ord.customerNumber
JOIN 
  orderdetails od ON ord.orderNumber = od.orderNumber
JOIN 
  offices o ON e.officeCode = o.officeCode
GROUP BY 
  o.city
ORDER BY 
  office_sales DESC;
