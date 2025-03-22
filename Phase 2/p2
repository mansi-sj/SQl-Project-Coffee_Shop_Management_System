UPDATE Orders 
SET order_status = 'Completed' 
WHERE order_id = 2;

UPDATE Payments 
SET transaction_status = 'Success' 
WHERE transaction_id = 'PAY002';

DELETE FROM Suppliers 
WHERE supplier_name = 'Fresh Dairy Ltd.';

-- 1. Get all orders with total price greater than 500
SELECT * FROM Orders WHERE total_price > 500;

-- 2. Get all staff with a salary less than 30000
SELECT staff_name, salary FROM Staff WHERE salary < 30000;

-- 3. Get customers whose membership status is not 'Regular'
SELECT cust_name, membership_status FROM Customers WHERE membership_status <> 'Regular';

-- 4. Get purchase orders with total amount greater than or equal to 1000
SELECT * FROM Purchase_Orders WHERE total_amount >= 1000;

-- 5. Get reservations with at most 4 guests
SELECT * FROM Reservation WHERE number_of_guests <= 4;


-- 6. Get all customers whose names start with 'A'
SELECT * FROM Customers WHERE cust_name LIKE 'A%';

-- 7. Get all suppliers whose name contains 'Coffee'
SELECT * FROM Suppliers WHERE supplier_name LIKE '%Coffee%';

-- 8. Get all staff with email ending in 'gmail.com'
SELECT * FROM Staff WHERE email_id LIKE '%gmail.com';

-- 9. Get all customers whose phone number starts with '98'
SELECT * FROM Customers WHERE contact_no LIKE '98%';

-- 10. Get all orders with special requests mentioning 'extra'
SELECT * FROM Orders WHERE special_requests LIKE '%extra%';

-- 11. Get all customers who are VIP members
SELECT * FROM Customers WHERE membership_status IN ('VIP');

-- 12. Get all staff who work morning or night shifts
SELECT * FROM Staff WHERE shift IN ('Morning', 'Night');

-- 13. Get all orders with status either 'Pending' or 'Cancelled'
SELECT * FROM Orders WHERE order_status IN ('Pending', 'Cancelled');

-- 14. Get all suppliers who are NOT in the 'Packaging' category
SELECT * FROM Suppliers WHERE supply_category NOT IN ('Packaging');

-- 15. Get all menu items that are NOT in 'Out of Stock' status
SELECT * FROM Menu_Items WHERE availability_status NOT IN ('Out of Stock');

-- 16. Get all orders with total price between 100 and 500
SELECT * FROM Orders WHERE total_price BETWEEN 100 AND 500;

-- 17. Get staff hired between 2020 and 2023
SELECT * FROM Staff WHERE hire_date BETWEEN '2020-01-01' AND '2023-12-31';

-- 18. Get energy consumption records where energy usage is between 50 and 100 kWh
SELECT * FROM Energy_Consumption WHERE energy_kwh BETWEEN 50 AND 100;

-- 19. Get waste management records where waste quantity is between 5 and 20 kg
SELECT * FROM Waste_Management WHERE quantity_kg BETWEEN 5 AND 20;

-- 20. Get customers born between 1990 and 2000
SELECT * FROM Customers WHERE date_of_birth BETWEEN '1990-01-01' AND '2000-12-31';


-- 21. Get orders with total price greater than ALL other orders (highest order)
SELECT * FROM Orders WHERE total_price > ALL (SELECT total_price FROM Orders);

-- 22. Get staff who earn more than ANY other staff in the same role
SELECT staff_name, salary FROM Staff WHERE salary > ANY (SELECT salary FROM Staff WHERE role_id = Staff.role_id);

-- 23. Get suppliers who have supplied at least one item
SELECT * FROM Suppliers WHERE EXISTS (SELECT * FROM Inventory WHERE Suppliers.supplier_id = Inventory.supplier_id);

-- 24. Get customers who have placed an order
SELECT * FROM Customers WHERE EXISTS (SELECT * FROM Orders WHERE Customers.cust_id = Orders.cust_id);

-- 25. Get staff who have received a bonus
SELECT * FROM Staff WHERE EXISTS (SELECT * FROM Staff_Bonus WHERE Staff.staff_id = Staff_Bonus.staff_id);





