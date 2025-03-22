-- 1. Get all orders with customer details (INNER JOIN)
SELECT Orders.order_id, Customers.cust_name, Orders.total_price, Orders.order_status 
FROM Orders 
INNER JOIN Customers ON Orders.cust_id = Customers.cust_id;

-- 2. Get all vendor payments along with supplier names (INNER JOIN)
SELECT Vendor_Payments.payment_id, Suppliers.supplier_name, Vendor_Payments.amount, Vendor_Payments.status
FROM Vendor_Payments 
INNER JOIN Suppliers ON Vendor_Payments.supplier_id = Suppliers.supplier_id;

-- 3. Get staff details along with their roles (INNER JOIN)
SELECT Staff.staff_name, Roles.role_name, Staff.salary, Staff.shift 
FROM Staff 
INNER JOIN Roles ON Staff.role_id = Roles.role_id;

-- 4. Get all orders including customers (LEFT JOIN)
SELECT Orders.order_id, Customers.cust_name, Orders.total_price, Orders.order_status 
FROM Orders 
LEFT JOIN Customers ON Orders.cust_id = Customers.cust_id;

-- 5. Get all suppliers and their purchase orders (LEFT JOIN)
SELECT Suppliers.supplier_name, Purchase_Orders.order_id, Purchase_Orders.total_amount 
FROM Suppliers 
LEFT JOIN Purchase_Orders ON Suppliers.supplier_id = Purchase_Orders.supplier_id;

-- 6. Get all staff including those without roles (LEFT JOIN)
SELECT Staff.staff_name, Roles.role_name 
FROM Staff 
LEFT JOIN Roles ON Staff.role_id = Roles.role_id;

-- 7. Get orders and related payments (RIGHT JOIN)
SELECT Orders.order_id, Orders.total_price, Payments.transaction_status 
FROM Orders 
RIGHT JOIN Payments ON Orders.order_id = Payments.order_id;

-- 8. Get all purchase orders and their suppliers (RIGHT JOIN)
SELECT Suppliers.supplier_name, Purchase_Orders.order_id, Purchase_Orders.total_amount 
FROM Purchase_Orders 
RIGHT JOIN Suppliers ON Purchase_Orders.supplier_id = Suppliers.supplier_id;

-- 9. Find which menu items belong to which category (INNER JOIN)
SELECT Menu_Items.item_name, Categories.category_name 
FROM Menu_Items 
INNER JOIN Categories ON Menu_Items.category_id = Categories.category_id;

-- 10. Find orders and their assigned staff (INNER JOIN)
SELECT Orders.order_id, Staff.staff_name 
FROM Orders 
INNER JOIN Staff ON Orders.staff_id = Staff.staff_id;

-- 11. Find vendor payments and related purchase orders (INNER JOIN)
SELECT Vendor_Payments.payment_id, Purchase_Orders.order_id, Vendor_Payments.amount 
FROM Vendor_Payments 
INNER JOIN Purchase_Orders ON Vendor_Payments.purchase_order_id = Purchase_Orders.order_id;

-- 12. Find all staff bonuses and their approval status (INNER JOIN)
SELECT Staff_Bonus.bonus_id, Staff.staff_name, Staff_Bonus.bonus_amount, Staff_Bonus.status 
FROM Staff_Bonus 
INNER JOIN Staff ON Staff_Bonus.staff_id = Staff.staff_id;

-- 13. Get equipment details along with suppliers (INNER JOIN)
SELECT Equipment.equipment_name, Suppliers.supplier_name 
FROM Equipment 
INNER JOIN Suppliers ON Equipment.supplier_id = Suppliers.supplier_id;

-- 14. Find customers who have placed an order (INNER JOIN)
SELECT DISTINCT Customers.cust_name 
FROM Customers 
INNER JOIN Orders ON Customers.cust_id = Orders.cust_id;

-- 15. Get all reservations and their assigned staff (INNER JOIN)
SELECT Reservation.reservation_id, Customers.cust_name, Staff.staff_name 
FROM Reservation 
INNER JOIN Customers ON Reservation.customer_id = Customers.cust_id 
INNER JOIN Staff ON Reservation.assigned_staff = Staff.staff_id;

