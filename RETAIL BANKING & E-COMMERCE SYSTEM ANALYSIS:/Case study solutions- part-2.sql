/*
1. Display the product details as per the following criteria and sort them in descending order of category:
   #a.  If the category is 2050, increase the price by 2000
   #b.  If the category is 2051, increase the price by 500
   #c.  If the category is 2052, increase the price by 600
*/

SELECT *, CASE 
WHEN PRODUCT_CLASS_CODE = 2050 THEN PRODUCT_PRICE + 2000 
WHEN PRODUCT_CLASS_CODE = 2051 THEN PRODUCT_PRICE + 500
WHEN PRODUCT_CLASS_CODE = 2052 THEN PRODUCT_PRICE + 600
ELSE PRODUCT_PRICE + 0
END AS new_PRODUCT_PRICE 
FROM product ORDER BY PRODUCT_CLASS_CODE DESC;

#########################################################################################################################################################


# 2. List the product description, class description and price of all products which are shipped. 

SELECT p.PRODUCT_DESC AS 'Product Description', pc.PRODUCT_CLASS_DESC AS "Product class Description", p.PRODUCT_PRICE AS "Price of Product" 
FROM product_class pc 
JOIN product p ON p.PRODUCT_CLASS_CODE = pc.PRODUCT_CLASS_CODE 
JOIN order_items oi ON p.PRODUCT_ID = oi.PRODUCT_ID 
JOIN order_header oh ON oi.ORDER_ID = oh.ORDER_ID
WHERE oh.ORDER_STATUS = 'shipped';

#########################################################################################################################################################

/*
3. Show inventory status of products as below as per their available quantity:
#a. For Electronics and Computer categories, if available quantity is < 10, show 'Low stock', 11 < qty < 30, show 'In stock', > 31, show 'Enough stock'
#b. For Stationery and Clothes categories, if qty < 20, show 'Low stock', 21 < qty < 80, show 'In stock', > 81, show 'Enough stock'
#c. Rest of the categories, if qty < 15 – 'Low Stock', 16 < qty < 50 – 'In Stock', > 51 – 'Enough stock'
#For all categories, if available quantity is 0, show 'Out of stock'.
*/

#3a. For Electronics and Computer categories, if available quantity is < 10, show 'Low stock', 11 < qty < 30, show 'In stock', > 31, show 'Enough stock'
SELECT p.PRODUCT_DESC AS "Product Name", pc.PRODUCT_CLASS_DESC AS 'Product Class', P.PRODUCT_QUANTITY_AVAIL AS 'Available Quantity',
CASE
WHEN p.PRODUCT_QUANTITY_AVAIL < 10 THEN "LOW STOCK"
WHEN (p.PRODUCT_QUANTITY_AVAIL > 11 AND p.PRODUCT_QUANTITY_AVAIL < 30)  THEN "In STOCK"
WHEN p.PRODUCT_QUANTITY_AVAIL > 31 THEN "Enough Stock"
WHEN p.PRODUCT_QUANTITY_AVAIL <= 0 THEN "Out of Stock"
END AS 'Inventory Status'
FROM product_class pc 
JOIN product p ON pc.PRODUCT_CLASS_CODE = p.PRODUCT_CLASS_CODE
WHERE pc.PRODUCT_CLASS_DESC IN ('Computer', 'Electronics')

UNION

#3b. For Stationery and Clothes categories, if qty < 20, show 'Low stock', 21 < qty < 80, show 'In stock', > 81, show 'Enough stock'
SELECT p.PRODUCT_DESC AS "Product Name", pc.PRODUCT_CLASS_DESC AS 'Product Class', P.PRODUCT_QUANTITY_AVAIL AS 'Available Quantity',
CASE
WHEN p.PRODUCT_QUANTITY_AVAIL < 20 THEN "LOW STOCK"
WHEN (p.PRODUCT_QUANTITY_AVAIL > 21 AND p.PRODUCT_QUANTITY_AVAIL < 80)  THEN "In STOCK"
WHEN p.PRODUCT_QUANTITY_AVAIL > 81 THEN "Enough Stock"
WHEN p.PRODUCT_QUANTITY_AVAIL <= 0 THEN "Out of Stock"
END AS 'Inventory Status'
FROM product_class pc 
JOIN product p ON pc.PRODUCT_CLASS_CODE = p.PRODUCT_CLASS_CODE
WHERE pc.PRODUCT_CLASS_DESC IN ('Clothes', 'Stationery')

UNION

#3c. Rest of the categories, if qty < 15 – 'Low Stock', 16 < qty < 50 – 'In Stock', > 51 – 'Enough stock'
SELECT p.PRODUCT_DESC AS "Product Name", pc.PRODUCT_CLASS_DESC AS 'Product Class', P.PRODUCT_QUANTITY_AVAIL AS 'Available Quantity',
CASE
WHEN p.PRODUCT_QUANTITY_AVAIL < 15 THEN "LOW STOCK"
WHEN (p.PRODUCT_QUANTITY_AVAIL > 16 AND p.PRODUCT_QUANTITY_AVAIL < 50)  THEN "In STOCK"
WHEN p.PRODUCT_QUANTITY_AVAIL > 51 THEN "Enough Stock"
WHEN p.PRODUCT_QUANTITY_AVAIL <= 0 THEN "Out of Stock"
END AS 'Inventory Status'
FROM product_class pc 
JOIN product p ON pc.PRODUCT_CLASS_CODE = p.PRODUCT_CLASS_CODE
WHERE pc.PRODUCT_CLASS_DESC NOT IN ('Computer', 'Electronics', 'Clothes', 'Stationery');




#########################################################################################################################################################

-- 4. List customers from outside Karnataka who haven’t bought any toys or books 

SELECT oc.CUSTOMER_FNAME as 'First Name', oc.CUSTOMER_LNAME AS 'Last Name', 
p.PRODUCT_DESC AS "Product Name", pc.PRODUCT_CLASS_DESC AS "Product Class", a.CITY AS "City", a.STATE AS "State" 
FROM product_class pc 
JOIN product p ON pc.PRODUCT_CLASS_CODE = p.PRODUCT_CLASS_CODE
JOIN order_items oi ON p.PRODUCT_ID = oi.PRODUCT_ID 
JOIN order_header oh ON oi.ORDER_ID = oh.ORDER_ID
JOIN online_customer oc ON oh.CUSTOMER_ID = oc.CUSTOMER_ID 
JOIN address a ON oc.ADDRESS_ID = a.ADDRESS_ID
WHERE (a.state != 'Karnataka') AND (pc.PRODUCT_CLASS_DESC NOT IN ('Toys', 'Books'))
;