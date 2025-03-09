create database coffeeshop;

use coffeeshop;

create table customers (
cust_id int Primary Key auto_increment, -- id of the customer
cust_name varchar(20) Not Null,
date_of_birth  Date,
email_id varchar(25) Unique Key,
contact_no varchar(15) Unique Key,
address varchar(20) Not Null,
postal_code varchar(20) Not Null,
membership_status enum('Regular', 'VIP') default 'Regular',
created_at timestamp default current_timestamp,
preferred_language varchar(20) Not Null Default 'English',
special_request Text Not Null default 'Nothing',
last_order_date Date );

create table customer_referrals (
referral_id int Primary Key auto_increment,
referrer_id int Not Null,  -- The customer who gave the reference
referred_id int Not Null,  -- The new customer who was referred
referral_date timestamp default current_timestamp, -- When the referral happened
reward_points int default 0,  -- Points earned for the referrence
status ENUM('Pending', 'Approved', 'Rejected') default 'Pending', -- Referral status
foreign key (referrer_id) references customers(cust_id) on delete cascade, -- deletes the data when the record is deleted from the customer table(parent table)
foreign key (referred_id) references customers(cust_id) on delete cascade );

create table staff (
staff_id int Primary Key auto_increment,
staff_name varchar(20) Not Null,
role_id int not Null,
email_id varchar(20) Unique Key,
contact_no varchar(15) Unique Key,
address varchar(20) Not Null,
hire_date Date Not Null,
salary Decimal(10,2) Not Null check (salary > 0),
shift enum('Morning', 'Evening', 'Night') not null,
status Enum('Active', 'Inactive') Default 'Active',
created_at timestamp default current_timestamp,
foreign key(role_id) references Roles(role_id) on delete Set Null );


CREATE TABLE Staff_Attendance (
    attendance_id INT PRIMARY KEY AUTO_INCREMENT,
    staff_id INT NOT NULL,
    date DATE NOT NULL,
    check_in_time TIME NOT NULL,
    check_out_time TIME NULL,
    total_hours DECIMAL(5,2) CHECK (total_hours >= 0),
    status ENUM('Present', 'Absent', 'Late') DEFAULT 'Present',
    remarks TEXT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (staff_id) REFERENCES Staff(staff_id) ON DELETE CASCADE
);



create table Roles (
    role_id INT PRIMARY KEY AUTO_INCREMENT,
    role_name VARCHAR(50) UNIQUE NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);	

create table Orders (
order_id INT PRIMARY KEY AUTO_INCREMENT,
customer_id INT,
staff_id INT,
total_price DECIMAL(10,2) NOT NULL CHECK (total_price > 0),
payment_id INT,
order_status ENUM('Pending', 'Completed', 'Cancelled') DEFAULT 'Pending',
created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
delivery_id INT,
special_requests TEXT NULL,
table_id INT,
FOREIGN KEY (customer_id) REFERENCES Customer(customer_id) ON DELETE SET NULL,
FOREIGN KEY (staff_id) REFERENCES Staff(staff_id) ON DELETE SET NULL,
FOREIGN KEY (payment_id) REFERENCES Payments(payment_id) ON DELETE SET NULL,
FOREIGN KEY (delivery_id) REFERENCES Delivery_Orders(delivery_id) ON DELETE SET NULL,
FOREIGN KEY (table_id) REFERENCES Reservation(table_id) ON DELETE SET NULL
);

CREATE TABLE Purchase_Order_Returns (
    return_id INT PRIMARY KEY AUTO_INCREMENT,
    purchase_order_id INT NOT NULL,
    supplier_id INT NOT NULL,
    return_date DATE NOT NULL,
    return_reason TEXT NOT NULL,
    total_refund DECIMAL(10,2) CHECK (total_refund >= 0),
    status ENUM('Pending', 'Approved', 'Rejected') DEFAULT 'Pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (purchase_order_id) REFERENCES Purchase_Orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (supplier_id) REFERENCES Suppliers(supplier_id) ON DELETE CASCADE
);

CREATE TABLE Purchase_Order_Items (
    item_id INT PRIMARY KEY AUTO_INCREMENT,
    purchase_order_id INT NOT NULL,
    inventory_id INT NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    unit_price DECIMAL(10,2) CHECK (unit_price > 0),
    total_price DECIMAL(10,2) GENERATED ALWAYS AS (quantity * unit_price) STORED,
    FOREIGN KEY (purchase_order_id) REFERENCES Purchase_Orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (inventory_id) REFERENCES Inventory(inventory_id) ON DELETE CASCADE
);

CREATE TABLE Equipment (
    equipment_id INT PRIMARY KEY AUTO_INCREMENT,
    equipment_name VARCHAR(100) NOT NULL,
    purchase_date DATE NOT NULL,
    warranty_expiry DATE NOT NULL,
    supplier_id INT,
    maintenance_schedule DATE NULL,
    status ENUM('Operational', 'Under Maintenance', 'Out of Order') DEFAULT 'Operational',
    last_serviced DATE NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (supplier_id) REFERENCES Suppliers(supplier_id) ON DELETE SET NULL
);


CREATE TABLE Menu_Items (
    menu_id INT PRIMARY KEY AUTO_INCREMENT,
    category_id INT NOT NULL,
    item_name VARCHAR(100) NOT NULL,
    description TEXT NULL,
    price DECIMAL(10,2) NOT NULL CHECK (price > 0),
    availability_status ENUM('Available', 'Out of Stock') DEFAULT 'Available',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    seasonal_id INT,
    recipe_id INT,
    calories INT NULL CHECK (calories >= 0),
    FOREIGN KEY (category_id) REFERENCES Categories(category_id) ON DELETE CASCADE,
    FOREIGN KEY (seasonal_id) REFERENCES Seasonal_Menu(seasonal_id) ON DELETE SET NULL,
    FOREIGN KEY (recipe_id) REFERENCES Recipe(recipe_id) ON DELETE SET NULL
);

CREATE TABLE Categories (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(50) UNIQUE NOT NULL,
    description TEXT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Inventory (
    inventory_id INT PRIMARY KEY AUTO_INCREMENT,
    item_name VARCHAR(100) NOT NULL,
    supplier_id INT,
    quantity INT NOT NULL CHECK (quantity >= 0),
    unit_price DECIMAL(10,2) NOT NULL CHECK (unit_price > 0),
    stock_date DATE NOT NULL,
    expiry_date DATE NULL,
    status ENUM('In Stock', 'Low Stock', 'Out of Stock') DEFAULT 'In Stock',
    purchase_order_id INT,
    storage_location VARCHAR(100) NULL,
    FOREIGN KEY (supplier_id) REFERENCES Suppliers(supplier_id) ON DELETE CASCADE,
    FOREIGN KEY (purchase_order_id) REFERENCES Purchase_Orders(order_id) ON DELETE CASCADE
);

CREATE TABLE Equipment_Maintenance (
    maintenance_id INT PRIMARY KEY AUTO_INCREMENT,
    equipment_id INT,
    maintenance_date DATE NOT NULL,
    issue_description TEXT NULL,
    maintenance_status ENUM('Pending', 'Completed') DEFAULT 'Pending',
    cost DECIMAL(10,2) NULL CHECK (cost >= 0),
    technician VARCHAR(100) NULL,
    next_scheduled_maintenance DATE NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (equipment_id) REFERENCES Equipment(equipment_id) ON DELETE CASCADE
);


CREATE TABLE Vendor_Payments (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    supplier_id INT,
    purchase_order_id INT,
    amount_paid DECIMAL(10,2) CHECK (amount_paid > 0),
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    payment_method ENUM('Bank Transfer', 'Credit Card', 'Cash', 'UPI', 'Cheque') NOT NULL,
    payment_status ENUM('Pending', 'Completed', 'Failed') DEFAULT 'Pending',
    transaction_id VARCHAR(50) UNIQUE,
    notes TEXT NULL,
    due_date DATE NOT NULL,
    FOREIGN KEY (supplier_id) REFERENCES Suppliers(supplier_id) ON DELETE CASCADE,
    FOREIGN KEY (purchase_order_id) REFERENCES Purchase_Orders(order_id) ON DELETE CASCADE
);

CREATE TABLE Seasonal_Menu (
    seasonal_id INT PRIMARY KEY AUTO_INCREMENT,
    item_name VARCHAR(100) UNIQUE NOT NULL,
    description TEXT NULL,
    available_from DATE NOT NULL,
    available_until DATE NOT NULL,
    price DECIMAL(10,2) CHECK (price > 0),
    status ENUM('Active', 'Expired') DEFAULT 'Active',
    menu_id INT,
    popularity_score INT CHECK (popularity_score BETWEEN 1 AND 100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (menu_id) REFERENCES Menu_Items(menu_id) ON DELETE CASCADE
);

CREATE TABLE Reservation (
    reservation_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    table_number INT NOT NULL CHECK (table_number > 0),
    reservation_date DATE NOT NULL,
    reservation_time TIME NOT NULL,
    number_of_guests INT NOT NULL CHECK (number_of_guests > 0),
    status ENUM('Confirmed', 'Cancelled', 'Completed') DEFAULT 'Confirmed',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id) ON DELETE CASCADE
);

CREATE TABLE Waste_Management (
    waste_id INT PRIMARY KEY AUTO_INCREMENT,
    waste_type ENUM('Food', 'Packaging', 'Other') NOT NULL,
    quantity_kg DECIMAL(5,2) CHECK (quantity_kg >= 0),
    disposal_method ENUM('Recycled', 'Composted', 'Disposed') NOT NULL,
    recorded_date DATE NOT NULL,
    remarks TEXT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE Staff_Bonus (
    bonus_id INT PRIMARY KEY AUTO_INCREMENT,
    staff_id INT NOT NULL,
    bonus_amount DECIMAL(10,2) CHECK (bonus_amount > 0),
    reason TEXT NOT NULL,
    bonus_date DATE NOT NULL,
    status ENUM('Pending', 'Approved', 'Rejected') DEFAULT 'Pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (staff_id) REFERENCES Staff(staff_id) ON DELETE CASCADE
);

CREATE TABLE Gift_Cards (
    card_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    card_code VARCHAR(20) UNIQUE NOT NULL,
    balance DECIMAL(10,2) CHECK (balance >= 0),
    expiry_date DATE NULL,
    status ENUM('Active', 'Expired', 'Redeemed') DEFAULT 'Active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id) ON DELETE SET NULL
);


CREATE TABLE Bill_Generation (
    bill_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    customer_id INT NOT NULL,
    total_amount DECIMAL(10,2) CHECK (total_amount > 0),
    tax_amount DECIMAL(10,2) CHECK (tax_amount >= 0),
    discount DECIMAL(10,2) DEFAULT 0 CHECK (discount >= 0),
    final_amount DECIMAL(10,2) GENERATED ALWAYS AS (total_amount + tax_amount - discount) STORED,
    payment_status ENUM('Paid', 'Unpaid') DEFAULT 'Unpaid',
    generated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id) ON DELETE CASCADE
);


CREATE TABLE Energy_Consumption (
    record_id INT PRIMARY KEY AUTO_INCREMENT,
    equipment_id INT NOT NULL,
    date DATE NOT NULL,
    energy_used_kWh DECIMAL(10,2) CHECK (energy_used_kWh >= 0),
    cost_incurred DECIMAL(10,2) CHECK (cost_incurred >= 0),
    recorded_by INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (equipment_id) REFERENCES Equipment(equipment_id) ON DELETE CASCADE,
    FOREIGN KEY (recorded_by) REFERENCES Staff(staff_id) ON DELETE SET NULL
);

CREATE TABLE Recipe (
    recipe_id INT PRIMARY KEY AUTO_INCREMENT,
    recipe_name VARCHAR(100) UNIQUE NOT NULL,
    ingredients TEXT NOT NULL,
    instructions TEXT NOT NULL,
    preparation_time INT CHECK (preparation_time > 0),
    calories INT CHECK (calories >= 0),
    menu_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (menu_id) REFERENCES Menu_Items(menu_id) ON DELETE CASCADE
);

CREATE TABLE Feedback (
    feedback_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    order_id INT NOT NULL,
    rating INT CHECK (rating BETWEEN 1 AND 5),
    comments TEXT NULL,
    feedback_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    response_status ENUM('Pending', 'Resolved') DEFAULT 'Pending',
    responded_by INT NULL,
    response_text TEXT NULL,
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id) ON DELETE CASCADE,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (responded_by) REFERENCES Staff(staff_id) ON DELETE SET NULL
);


CREATE TABLE Payments (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    customer_id INT NOT NULL,
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    amount DECIMAL(10,2) NOT NULL CHECK (amount > 0),
    payment_method ENUM('Cash', 'Credit Card', 'Debit Card', 'UPI', 'Gift Card') NOT NULL,
    transaction_status ENUM('Success', 'Failed', 'Pending') DEFAULT 'Pending',
    transaction_id VARCHAR(50) UNIQUE,
    refund_status ENUM('None', 'Requested', 'Completed') DEFAULT 'None',
    FOREIGN KEY (order_id) REFERENCES Orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id) ON DELETE CASCADE
);

CREATE TABLE Delivery_Orders (
    delivery_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    delivery_address TEXT NOT NULL,
    delivery_status ENUM('Pending', 'Out for Delivery', 'Delivered', 'Cancelled') DEFAULT 'Pending',
    estimated_delivery_time TIMESTAMP NULL,
    actual_delivery_time TIMESTAMP NULL,
    delivery_person VARCHAR(100) NULL,
    contact_number VARCHAR(15) NULL,
    delivery_fee DECIMAL(10,2) CHECK (delivery_fee >= 0) DEFAULT 0,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id) ON DELETE CASCADE
);

CREATE TABLE Suppliers (
    supplier_id INT PRIMARY KEY AUTO_INCREMENT,
    supplier_name VARCHAR(100) NOT NULL,
    contact_person VARCHAR(100) NOT NULL,
    phone_number VARCHAR(15) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    address TEXT NOT NULL,
    supply_category ENUM('Coffee Beans', 'Dairy', 'Bakery', 'Packaging', 'Equipment') NOT NULL,
    contract_status ENUM('Active', 'Expired') DEFAULT 'Active',
    contract_start_date DATE NOT NULL,
    contract_end_date DATE NULL CHECK (contract_end_date > contract_start_date)
);


create table Franchises (
    franchise_id INT PRIMARY KEY AUTO_INCREMENT,
    franchise_name VARCHAR(100) UNIQUE NOT NULL,
    owner_name VARCHAR(100) NOT NULL,
    location TEXT NOT NULL,
    contact_number VARCHAR(15) UNIQUE NOT NULL,
    opening_date DATE NOT NULL,
    revenue_share_percentage DECIMAL(5,2) CHECK (revenue_share_percentage BETWEEN 0 AND 100),
    status ENUM('Active', 'Closed') DEFAULT 'Active',
    total_revenue DECIMAL(15,2) DEFAULT 0 CHECK (total_revenue >= 0),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);