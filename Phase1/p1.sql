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
status enum('Pending', 'Approved', 'Rejected') default 'Pending', -- Referral status
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


create table Staff_Attendance (
    attendance_id int Primary Key auto_increment,
    staff_id int Not Null,
    date date Not Null,
    check_in_time time Not Null,
    check_out_time time null,
    total_hours decimal(5,2) check (total_hours >= 0),
    status enum('Present', 'Absent', 'Late') default 'Present',
    remarks text null,
    created_at timestamp default current_timestamp,
    foreign key (staff_id) references Staff(staff_id) on delete cascade
);



create table Roles (
    role_id int Primary Key auto_increment,
    role_name varchar(50)unique Not Null,
    description text,
    created_at timestamp default current_timestamp
);	

create table Orders (
order_id int Primary Key auto_increment,
customer_id int,
staff_id int,
total_price decimal(10,2) not null check (total_price > 0),
payment_id int,
order_status enum('Pending', 'Completed', 'Cancelled') default 'Pending',
created_at timestamp default current_timestamp,
delivery_id int,
special_requests text null,
table_id int,
foreign key (customer_id) references Customer(customer_id) on delete set null,
foreign key (staff_id) references Staff(staff_id) on delete set null,
foreign key (payment_id) references Payments(payment_id) on delete set null,
foreign key (delivery_id) references Delivery_Orders(delivery_id) on delete set null,
foreign key (table_id) references Reservation(table_id) on delete set null
);

create table Purchase_Order_Returns (
    return_id int Primary Key auto_increment,
    purchase_order_id int not null,
    supplier_id int not null,
    return_date date not null ,
    return_reason text  not null,
    total_refund decimal(10,2) check (total_refund >= 0),
    status enum('Pending', 'Approved', 'Rejected') default 'Pending',
    created_at timestamp default current_timestamp,
    foreign key (purchase_order_id) references Purchase_Orders(order_id)  on delete cascade,
    foreign key(supplier_id) references Suppliers(supplier_id)  on delete set null
);

create table Purchase_Order_Items (
    item_id int Primary Key auto_increment,
    purchase_order_id int not null,
    inventory_id int not null,
    quantity int not null check (quantity > 0),
    unit_price decimal(10,2) check (unit_price > 0),
    total_price decimal(10,2) generated always as  (quantity * unit_price) stored,
   foreign key (purchase_order_id)  references Purchase_Orders(order_id)  on delete cascade,
    foreign key (inventory_id)  references Inventory(inventory_id)  on delete cascade
);

create table Equipment (
    equipment_id int Primary Key auto_increment,
    equipment_name varchar(100) not null,
    purchase_date date not null,
    warranty_expiry date not null,
    supplier_id int,
    maintenance_schedule date null,
    status enum('Operational', 'Under Maintenance', 'Out of Order') default 'Operational',
    last_serviced date null,
    created_at timestamp default current_timestamp,
   foreign key (supplier_id)  references Suppliers(supplier_id)  on delete set null
);


create table Menu_Items (
    menu_id int Primary Key auto_increment,
    category_id int not null,
    item_name varchar(100) not null,
    description text null,
    price decimal(10,2) not null check (price > 0),
    availability_status ENUM('Available', 'Out of Stock') default 'Available',
    created_at timestamp default current_timestamp,
    seasonal_id int,
    recipe_id int,
    calories int null check(calories >= 0),
    foreign key (category_id) references Categories(category_id) on delete cascade,
    foreign key (seasonal_id) REFERENCES Seasonal_Menu(seasonal_id) on delete set null,
    foreign key (recipe_id) REFERENCES Recipe(recipe_id) on delete set null
);

CREATE TABLE Categories (
    category_id int Primary Key auto_increment,
    category_name VARCHAR(50) UNIQUE NOT NULL,
    description TEXT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Inventory (
    inventory_id int Primary Key auto_increment,
    item_name VARCHAR(100) NOT NULL,
    supplier_id INT,
    quantity INT NOT NULL CHECK (quantity >= 0),
    unit_price DECIMAL(10,2) NOT NULL CHECK (unit_price > 0),
    stock_date DATE NOT NULL,
    expiry_date DATE NULL,
    status ENUM('In Stock', 'Low Stock', 'Out of Stock') DEFAULT 'In Stock',
    purchase_order_id INT,
    storage_location VARCHAR(100) NULL,
    foreign key (supplier_id) REFERENCES Suppliers(supplier_id) ON DELETE CASCADE,
    foreign key (purchase_order_id) REFERENCES Purchase_Orders(order_id) ON DELETE CASCADE
);

CREATE TABLE Equipment_Maintenance (
    maintenance_id int Primary Key auto_increment,
    equipment_id INT,
    maintenance_date DATE NOT NULL,
    issue_description TEXT NULL,
    maintenance_status ENUM('Pending', 'Completed') DEFAULT 'Pending',
    cost DECIMAL(10,2) NULL CHECK (cost >= 0),
    technician VARCHAR(100) NULL,
    next_scheduled_maintenance DATE NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    foreign key (equipment_id) REFERENCES Equipment(equipment_id) ON DELETE CASCADE
);


CREATE TABLE Vendor_Payments (
    payment_id int Primary Key auto_increment,
    supplier_id INT,
    purchase_order_id INT,
    amount_paid DECIMAL(10,2) CHECK (amount_paid > 0),
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    payment_method ENUM('Bank Transfer', 'Credit Card', 'Cash', 'UPI', 'Cheque') NOT NULL,
    payment_status ENUM('Pending', 'Completed', 'Failed') DEFAULT 'Pending',
    transaction_id VARCHAR(50) UNIQUE,
    notes TEXT NULL,
    due_date DATE NOT NULL,
    foreign key (supplier_id) REFERENCES Suppliers(supplier_id) ON DELETE CASCADE,
    foreign key (purchase_order_id) REFERENCES Purchase_Orders(order_id) ON DELETE CASCADE
);

CREATE TABLE Seasonal_Menu (
    seasonal_id int Primary Key auto_increment,
    item_name VARCHAR(100) UNIQUE NOT NULL,
    description TEXT NULL,
    available_from DATE NOT NULL,
    available_until DATE NOT NULL,
    price DECIMAL(10,2) CHECK (price > 0),
    status ENUM('Active', 'Expired') DEFAULT 'Active',
    menu_id INT,
    popularity_score INT CHECK (popularity_score BETWEEN 1 AND 100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    foreign key (menu_id) REFERENCES Menu_Items(menu_id) ON DELETE CASCADE
);

create table Reservation (
    reservation_id int Primary Key auto_increment,
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
    bonus_id int Primary Key auto_increment,
    staff_id INT NOT NULL,
    bonus_amount DECIMAL(10,2) CHECK (bonus_amount > 0),
    reason TEXT NOT NULL,
    bonus_date DATE NOT NULL,
    status ENUM('Pending', 'Approved', 'Rejected') DEFAULT 'Pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    foreign key (staff_id) REFERENCES Staff(staff_id) ON DELETE CASCADE
);

CREATE TABLE Gift_Cards (
    card_id int Primary Key auto_increment,
    customer_id INT,
    card_code VARCHAR(20) UNIQUE NOT NULL,
    balance DECIMAL(10,2) CHECK (balance >= 0),
    expiry_date DATE NULL,
    status ENUM('Active', 'Expired', 'Redeemed') DEFAULT 'Active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    foreign key (customer_id) REFERENCES Customer(customer_id) ON DELETE SET NULL
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
    foreign key (order_id) REFERENCES Orders(order_id) ON DELETE CASCADE,
    foreign key (customer_id) REFERENCES Customer(customer_id) ON DELETE CASCADE
);


CREATE TABLE Energy_Consumption (
    record_id INT PRIMARY KEY AUTO_INCREMENT,
    equipment_id INT NOT NULL,
    date DATE NOT NULL,
    energy_used_kWh DECIMAL(10,2) CHECK (energy_used_kWh >= 0),
    cost_incurred DECIMAL(10,2) CHECK (cost_incurred >= 0),
    recorded_by INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    foreign key (equipment_id) REFERENCES Equipment(equipment_id) ON DELETE CASCADE,
    foreign key (recorded_by) REFERENCES Staff(staff_id) ON DELETE SET NULL
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
    foreign key (menu_id) REFERENCES Menu_Items(menu_id) ON DELETE CASCADE
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
    foreign key (customer_id) REFERENCES Customer(customer_id) ON DELETE CASCADE,
    foreign key (order_id) REFERENCES Orders(order_id) ON DELETE CASCADE,
    foreign key (responded_by) REFERENCES Staff(staff_id) ON DELETE SET NULL
);


CREATE TABLE Payments (
    payment_id int Primary Key auto_increment,
    order_id INT NOT NULL,
    customer_id INT NOT NULL,
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    amount DECIMAL(10,2) NOT NULL CHECK (amount > 0),
    payment_method ENUM('Cash', 'Credit Card', 'Debit Card', 'UPI', 'Gift Card') NOT NULL,
    transaction_status ENUM('Success', 'Failed', 'Pending') DEFAULT 'Pending',
    transaction_id VARCHAR(50) UNIQUE,
    refund_status ENUM('None', 'Requested', 'Completed') DEFAULT 'None',
    foreign key (order_id) REFERENCES Orders(order_id) ON DELETE CASCADE,
    foreign key (customer_id) REFERENCES Customer(customer_id) ON DELETE CASCADE
);

CREATE TABLE Delivery_Orders (
    delivery_id int Primary Key auto_increment,
    order_id INT NOT NULL,
    delivery_address TEXT NOT NULL,
    delivery_status ENUM('Pending', 'Out for Delivery', 'Delivered', 'Cancelled') DEFAULT 'Pending',
    estimated_delivery_time TIMESTAMP NULL,
    actual_delivery_time TIMESTAMP NULL,
    delivery_person VARCHAR(100) NULL,
    contact_number VARCHAR(15) NULL,
    delivery_fee DECIMAL(10,2) CHECK (delivery_fee >= 0) DEFAULT 0,
    foreign key (order_id) REFERENCES Orders(order_id) ON DELETE CASCADE
);

create table Suppliers (
    supplier_id int Primary Key auto_increment,
    supplier_name varchar(100) not null,
    contact_person varchar(100)  not null,
    phone_number varchar(15) UNIQUE  not null,
    email varchar(100) unique  not null,
    address text  not null,
    supply_category enum('Coffee Beans', 'Dairy', 'Bakery', 'Packaging', 'Equipment')  not null,
    contract_status enum('Active', 'Expired') default 'Active',
    contract_start_date date  not null,
    contract_end_date date null check (contract_end_date > contract_start_date)
);


create table Franchises (
    franchise_id int Primary Key auto_increment,
    franchise_name varchar(100) unique Not Null,
    owner_name varchar(100) Not Null,
    location text Not Null,
    contact_number varchar(15) unique Not Null,
    opening_date date Not Null,
    revenue_share_percentage decimal(5,2) check (revenue_share_percentage between 0 and 100),
    status enum('Active', 'Closed') default 'Active',
    total_revenue decimal(15,2) default 0 check (total_revenue >= 0),
    created_at  timestamp default current_timestamp
);


create table Feedback (
    feedback_id int Primary Key auto_increment,
    customer_id int not null,
    order_id int not null,
    rating int check (rating between 1 and 5),
    comments text null,
    feedback_date timestamp default current_timestamp,
    response_status enum('Pending', 'Resolved') default 'Pending',
    responded_by int null,
    response_text text null,
    resolution_date timestamp null,
    created_at timestamp default current_timestamp,
    foreign key (customer_id) references customers(cust_id)on delete cascade,
    foreign key (order_id) references Orders(order_id) on delete cascade,
    foreign key (responded_by) references staff(staff_id) on delete set null
);


create table Reservation (
    reservation_id int Primary Key auto_increment,
    customer_id int not null,
    table_number int not null check (table_number > 0),
    reservation_date date not null,
    reservation_time time not null ,
    number_of_guests int not null check (number_of_guests > 0),
    status enum('Confirmed', 'Cancelled', 'Completed') default 'Confirmed',
    special_requests text null,
    created_at timestamp default current_timestamp,
    assigned_staff int null,
    foreign key (customer_id) references customers(cust_id) on delete cascade,
    foreign key (assigned_staff) references staff(staff_id)on delete set null
);


create table Bill_Generation (
    bill_id int Primary Key auto_increment,
    order_id int not null,
    customer_id int not null,
    total_amount decimal(10,2) check (total_amount > 0),
    tax_amount decimal(10,2) check (tax_amount >= 0),
    discount decimal(10,2) default 0 check (discount >= 0),
    final_amount decimal(10,2) generated always as (total_amount + tax_amount - discount) stored,
    payment_status enum('Paid', 'Unpaid') default 'Unpaid',
    generated_at timestamp default current_timestamp,
    processed_by int null,
    foreign key (order_id) references Orders(order_id) on delete cascade,
   foreign key (customer_id) references customers(cust_id) on delete cascade,
    foreign key (processed_by) references staff(staff_id) on delete set null
);

create table Recipe (
    recipe_id int Primary Key auto_increment,
    recipe_name varchar(100) unique Not Null,
    ingredients text not null,
    instructions text not null,
    preparation_time int check(preparation_time > 0),
    calories int check (calories >= 0),
    menu_id int,
    created_at timestamp default current_timestamp,
    chef_id int null,
    difficulty_level enum('Easy', 'Medium', 'Hard') default 'Medium',
    seasonal_availability enum('Yes', 'No') default 'No',
	foreign key (menu_id) references Menu_Items(menu_id) on delete cascade,
    foreign key (chef_id) references staff(staff_id) on delete set null
);
