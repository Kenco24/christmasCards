select * from customers
select * from employees




use classicmodels

INSERT INTO employees (employeeNumber, lastName, firstName, extension, email, officeCode, reportsTo, jobTitle)
VALUES ('1287', 'Johnson', 'Michael', 'x4321', 'mjohnson@classicmodelcars.com', '1', '1056', 'Sales Representative');

INSERT INTO customers (customerNumber, customerName, contactLastName, contactFirstName, phone, addressLine1, addressLine2, city, state, postalCode, country, salesRepEmployeeNumber, creditLimit)
VALUES ('497', 'New Global Gifts Inc', 'Johnson', 'Michael', '5551234567', '789 Broadway', 'Suite 303', 'Los Angeles', 'CA', '90001', 'USA', '1287', '7500.00');




INSERT INTO employees (employeeNumber, lastName, firstName, extension, email, officeCode, reportsTo, jobTitle)
VALUES ('1288', 'Smith', 'Jennifer', 'x5432', 'jsmith@classicmodelcars.com', '1', '1056', 'Sales Representative');

INSERT INTO customers (customerNumber, customerName, contactLastName, contactFirstName, phone, addressLine1, addressLine2, city, state, postalCode, country, salesRepEmployeeNumber, creditLimit)
VALUES ('510', 'Global Collectibles', 'Anderson', 'Robert', '9876543210', '456 Main St', 'Suite 101', 'New York', 'NY', '10001', 'USA', '1288', '6000.00');



INSERT INTO employees (employeeNumber, lastName, firstName, extension, email, officeCode, reportsTo, jobTitle)
VALUES ('1289', 'Williams', 'Karen', 'x6543', 'kwilliams@classicmodelcars.com', '2', '1056', 'Sales Representative');

INSERT INTO customers (customerNumber, customerName, contactLastName, contactFirstName, phone, addressLine1, addressLine2, city, state, postalCode, country, salesRepEmployeeNumber, creditLimit)
VALUES ('499', 'EuroGifts Ltd', 'Brown', 'Alice', '8765432109', '789 Market St', 'Floor 2', 'Berlin', NULL, '10117', 'Germany', '1289', '8000.00');

UPDATE employees
SET email = 'diane@uacs.edu.mk'
WHERE lastName = 'Murphy' AND firstName = 'Diane';


SELECT COUNT(DISTINCT country) AS num_countries
FROM customers;

DELIMITER //

CREATE PROCEDURE GetCustomersByCountry(IN target_country VARCHAR(255))
BEGIN
    SELECT *
    FROM customers
    WHERE country = target_country;
END //

DELIMITER ;

CALL  GetCustomersByCountry('USA')


CREATE VIEW CustomersInTorino AS
SELECT *
FROM customers
WHERE city = 'Torino';


select * from CustomersInTorino




DELIMITER //

CREATE PROCEDURE GetCustomersByCity(IN target_city VARCHAR(255))
BEGIN
    SELECT *
    FROM customers
    WHERE city = target_city;
END //

DELIMITER ;

CALL GetCustomersByCity('Lyon')




DELIMITER //

CREATE PROCEDURE GetCustomersByPaymentAmount(IN payment_amount DECIMAL(10, 2))
BEGIN
    SELECT customerName
    FROM customers
    WHERE customerNumber IN (
        SELECT customerNumber
        FROM payments
        GROUP BY customerNumber
        HAVING SUM(amount) > payment_amount
    );
END //

DELIMITER ;





CALL GetCustomersByPaymentAmount2(1000.00, OUT num_customer_result)





DELIMITER //

CREATE PROCEDURE GetCustomersByPaymentAmount2(IN payment_amount DECIMAL(10, 2), OUT num_customers INT)
BEGIN
    SELECT customerName
    FROM customers
    WHERE customerNumber IN (
        SELECT customerNumber
        FROM payments
        GROUP BY customerNumber
        HAVING SUM(amount) > payment_amount
    );
    
    SELECT COUNT(*) INTO num_customers;
END //

DELIMITER ;


-- Set the session variable to store the output parameter
SET @num_customers_result = 0;

-- Call the stored procedure with the desired payment amount
CALL GetCustomersByPaymentAmount2(6000.00, @num_customers_result);

-- Display the result
SELECT @num_customers_result AS 'Number of Customers';






CREATE DATABASE IF NOT EXISTS new_database;
USE new_database;


CREATE TABLE IF NOT EXISTS CustomersItaly AS
SELECT *
FROM classicmodels.customers
WHERE country = 'Italy';

use new_database
select * from CustomersItaly



use classicmodels
CREATE TABLE IF NOT EXISTS trigger_log (
    id INT AUTO_INCREMENT PRIMARY KEY,
    table_name VARCHAR(255),
    action VARCHAR(255),
    timestamp TIMESTAMP
);

DELIMITER //

CREATE TRIGGER before_update_employees
BEFORE UPDATE ON employees
FOR EACH ROW
BEGIN
    INSERT INTO trigger_log (table_name, action, timestamp)
    VALUES ('employees', 'update', NOW());
END //

DELIMITER ;


DELIMITER //

CREATE TRIGGER after_insert_customers
AFTER INSERT ON customers
FOR EACH ROW
BEGIN
    INSERT INTO trigger_log (table_name, action, timestamp)
    VALUES ('customers', 'insert', NOW());
END //

DELIMITER ;



INSERT INTO customers 
(customerNumber, customerName, contactLastName, contactFirstName, phone, addressLine1, city, country, salesRepEmployeeNumber, creditLimit)
VALUES
('501', 'Test Customer', 'Test', 'Customer', '123456789', 'Test Address', 'Test City', 'USA', '1288', '10000.00');

SELECT * FROM trigger_log;

