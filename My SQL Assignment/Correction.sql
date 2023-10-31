-- Set 1)Que5

use assignment;
-- Create Product Table

CREATE TABLE Product (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(255) NOT NULL UNIQUE,
    description TEXT,
    supplier_id INT,
    FOREIGN KEY (supplier_id) REFERENCES Supplier(supplier_id)
);

-- Create Supplier Table
CREATE TABLE Suppliers (
    supplier_id INT AUTO_INCREMENT PRIMARY KEY,
    supplier_name VARCHAR(255),
    location VARCHAR(255)
);

-- Create Stock Table
CREATE TABLE Stock (
    id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT,
    balance_stock INT,
    FOREIGN KEY (product_id) REFERENCES Product(product_id)
);

-- Que 10
CREATE VIEW emp_sal AS
SELECT emp_no, first_name, last_name, salary
FROM emp
ORDER BY salary DESC;

-- Set 2)Que 6
SELECT first_name, last_name, salary
FROM emp
WHERE salary > 2000
  AND hire_date > DATE_SUB(NOW(), INTERVAL 36 MONTH)
ORDER BY salary DESC;

-- Set 3)Que 3 a
DELIMITER //

CREATE FUNCTION GetPurchaseStatus(customernumber INT) RETURNS VARCHAR(50)
BEGIN
    DECLARE total_purchase_amount DECIMAL(10, 2);
    DECLARE status VARCHAR(50);

    SELECT SUM(amount)
    INTO total_purchase_amount
    FROM Payments
    WHERE customerNumber = customernumber;

    IF total_purchase_amount < 25000 THEN
        SET status = 'Silver';
    ELSEIF total_purchase_amount >= 25000 AND total_purchase_amount <= 50000 THEN
        SET status = 'Gold';
    ELSE
        SET status = 'Platinum';
    END IF;

    RETURN status;
END;
//

DELIMITER ;

-- Set 3 Que 3 b
SELECT customerNumber, customerName, GetPurchaseStatus(customerNumber) AS purchase_status
FROM customers;





