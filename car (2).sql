USE classicmodels;

CREATE OR REPLACE VIEW vw_sales_by_country AS
SELECT c.country,SUM(od.quantityOrdered * od.priceEach) AS total_sales
FROM orders o
INNER JOIN customers c ON c.customerNumber = o.customerNumber
INNER JOIN orderdetails od ON o.orderNumber = od.orderNumber
GROUP BY c.country;

CREATE OR REPLACE VIEW vw_sales_by_productline AS
SELECT p.productLine,SUM(od.quantityOrdered * od.priceEach) AS total_sales
FROM orderdetails od
INNER JOIN products p ON p.productCode = od.productCode
GROUP BY p.productLine;
 
 
 CREATE OR REPLACE VIEW vw_customer_summary AS
SELECT c.customerNumber,c.customerName,IFNULL(o.orders_count, 0) AS count_order,IFNULL(p.total_paid, 0) AS sum_amount
FROM customers c
LEFT JOIN (SELECT customerNumber, COUNT(*) AS orders_count
    FROM orders
    GROUP BY customerNumber) o ON c.customerNumber = o.customerNumber
LEFT JOIN (SELECT customerNumber, SUM(amount) AS total_paid
    FROM payments
    GROUP BY customerNumber) p ON c.customerNumber = p.customerNumber;
 
CREATE OR REPLACE VIEW vw_customer_count_by_country AS
SELECT country,COUNT(customerNumber) AS customer_count
FROM customers
GROUP BY country;
 
 DROP VIEW IF EXISTS vw_top_products_by_sales  ;

CREATE OR REPLACE VIEW vw_product_inventory_summary AS
SELECT productName, productLine, quantityInStock,buyPrice
FROM products;
 
CREATE OR REPLACE VIEW vw_top_products_by_sales AS
SELECT p.productName, p.productLine, SUM(od.quantityOrdered * od.priceEach) AS total_sales
FROM products p
INNER JOIN orderdetails od ON p.productCode = od.productCode
GROUP BY p.productName, p.productLine
ORDER BY total_sales DESC;
 
  DROP VIEW IF EXISTS vw_sales_by_month  ;
 
 CREATE OR REPLACE VIEW vw_product_sales_by_country AS
SELECT p.productName,p.productLine,c.country,SUM(od.quantityOrdered * od.priceEach) AS total_sales
FROM orders o
INNER JOIN customers c ON c.customerNumber = o.customerNumber
INNER JOIN orderdetails od ON o.orderNumber = od.orderNumber
INNER JOIN products p ON p.productCode = od.productCode
GROUP BY p.productName, p.productLine, c.country;

CREATE OR REPLACE VIEW vw_sales_by_year AS
SELECT YEAR(paymentDate) AS sales_year,SUM(amount) AS total_sales
FROM payments
GROUP BY YEAR(paymentDate);

CREATE OR REPLACE VIEW vw_sales_by_month AS
SELECT YEAR(paymentDate) AS sales_year,MONTH(paymentDate) AS sales_month,SUM(amount) AS total_sales
FROM payments
GROUP BY YEAR(paymentDate), MONTH(paymentDate);

CREATE VIEW vw_orders_by_country AS
SELECT c.country, COUNT(o.orderNumber) AS total_orders
FROM customers c
INNER JOIN orders o ON c.customerNumber = o.customerNumber
GROUP BY c.country
order by total_orders desc