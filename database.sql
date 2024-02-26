CREATE TABLE users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  username VARCHAR(50) NOT NULL,
  email VARCHAR(100) NOT NULL UNIQUE,
  password VARCHAR(255) NOT NULL,
  active BOOLEAN NOT NULL DEFAULT 1,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE customers (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  phone VARCHAR(15) NULL,
  address VARCHAR(255) NULL,
  user_id INT NOT NULL,
  active BOOLEAN NOT NULL DEFAULT 1,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE orders (
  id INT AUTO_INCREMENT PRIMARY KEY,
  customer_id INT NOT NULL,
  order_details TEXT NOT NULL,
  status ENUM('pending', 'in_delivery', 'delivered') NOT NULL,
  delivery_id INT NULL,
  user_id INT NOT NULL,
  active BOOLEAN NOT NULL DEFAULT 1,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (customer_id) REFERENCES customers(id),
  FOREIGN KEY (delivery_id) REFERENCES deliveries(id),
  FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE deliveries (
  id INT AUTO_INCREMENT PRIMARY KEY,
  employee_id INT NOT NULL,
  delivery_time DATETIME NOT NULL,
  status ENUM('pending', 'completed') NOT NULL,
  user_id INT NOT NULL,
  active BOOLEAN NOT NULL DEFAULT 1,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (employee_id) REFERENCES employees(id),
  FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE employees (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  role ENUM('chef', 'delivery') NOT NULL,
  user_id INT NOT NULL,
  active BOOLEAN NOT NULL DEFAULT 1,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id)
);

-- VISTAS
CREATE VIEW ViewUsers AS
SELECT id, username, email, active, created_at, updated_at
FROM users;

CREATE VIEW ViewCustomers AS
SELECT c.id, c.name, c.phone, c.address, u.username AS user_name, c.active, c.created_at, c.updated_at
FROM customers c
JOIN users u ON c.user_id = u.id;

CREATE VIEW ViewOrders AS
SELECT o.id, cu.name AS customer_name, o.order_details, o.status, d.id AS delivery_id, o.active, o.created_at, o.updated_at
FROM orders o
JOIN customers cu ON o.customer_id = cu.id
LEFT JOIN deliveries d ON o.delivery_id = d.id
JOIN users u ON o.user_id = u.id;

CREATE VIEW ViewDeliveries AS
SELECT d.id, e.name AS employee_name, d.delivery_time, d.status, d.active, d.created_at, d.updated_at
FROM deliveries d
JOIN employees e ON d.employee_id = e.id
JOIN users u ON d.user_id = u.id;

CREATE VIEW ViewEmployees AS
SELECT e.id, e.name, e.role, e.active, e.created_at, e.updated_at
FROM employees e
JOIN users u ON e.user_id = u.id;

-- Stored Procedures

# CRUD USUARIOS
DELIMITER //
CREATE PROCEDURE CreateUser(IN _username VARCHAR(50), IN _email VARCHAR(100), IN _password VARCHAR(255))
BEGIN
    INSERT INTO users (username, email, password) VALUES (_username, _email, _password);
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE UpdateUser(IN _id INT, IN _username VARCHAR(50), IN _email VARCHAR(100), IN _password VARCHAR(255))
BEGIN
    UPDATE users SET username = _username, email = _email, password = _password WHERE id = _id;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE DeleteUser(IN _id INT)
BEGIN
    DELETE FROM users WHERE id = _id;
END //
DELIMITER ;

#CRUD CLIENTES
DELIMITER //
CREATE PROCEDURE CreateCustomer(IN _name VARCHAR(100), IN _phone VARCHAR(15), IN _address VARCHAR(255), IN _user_id INT)
BEGIN
    INSERT INTO customers (name, phone, address, user_id) VALUES (_name, _phone, _address, _user_id);
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE UpdateCustomer(IN _id INT, IN _name VARCHAR(100), IN _phone VARCHAR(15), IN _address VARCHAR(255))
BEGIN
    UPDATE customers SET name = _name, phone = _phone, address = _address WHERE id = _id;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE DeleteCustomer(IN _id INT)
BEGIN
    DELETE FROM customers WHERE id = _id;
END //
DELIMITER ;

#CRUD ORDERS
DELIMITER //
CREATE PROCEDURE CreateOrder(IN _customer_id INT, IN _order_details TEXT, IN _status ENUM('pending', 'in_delivery', 'delivered'), IN _user_id INT)
BEGIN
    INSERT INTO orders (customer_id, order_details, status, user_id) VALUES (_customer_id, _order_details, _status, _user_id);
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE UpdateOrder(IN _id INT, IN _status ENUM('pending', 'in_delivery', 'delivered'))
BEGIN
    UPDATE orders SET status = _status WHERE id = _id;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE DeleteOrder(IN _id INT)
BEGIN
    DELETE FROM orders WHERE id = _id;
END //
DELIMITER ;

#CRUD DELIVERIES
DELIMITER //
CREATE PROCEDURE CreateDelivery(IN _employee_id INT, IN _delivery_time DATETIME, IN _status ENUM('pending', 'completed'), IN _user_id INT)
BEGIN
    INSERT INTO deliveries (employee_id, delivery_time, status, user_id) VALUES (_employee_id, _delivery_time, _status, _user_id);
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE UpdateDelivery(IN _id INT, IN _status ENUM('pending', 'completed'))
BEGIN
    UPDATE deliveries SET status = _status WHERE id = _id;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE DeleteDelivery(IN _id INT)
BEGIN
    DELETE FROM deliveries WHERE id = _id;
END //
DELIMITER ;

#CRUD EMPLOYEES
DELIMITER //
CREATE PROCEDURE CreateEmployee(IN _name VARCHAR(100), IN _role ENUM('chef', 'delivery'), IN _user_id INT)
BEGIN
    INSERT INTO employees (name, role, user_id) VALUES (_name, _role, _user_id);
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE UpdateEmployee(IN _id INT, IN _name VARCHAR(100), IN _role ENUM('chef', 'delivery'))
BEGIN
    UPDATE employees SET name = _name, role = _role WHERE id = _id;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE DeleteEmployee(IN _id INT)
BEGIN
    DELETE FROM employees WHERE id = _id;
END //
DELIMITER ;

