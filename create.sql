CREATE DATABASE IF NOT EXISTS lab_mysql;

USE lab_mysql;

DROP TABLE IF EXISTS invoices;
DROP TABLE IF EXISTS customer;
DROP TABLE IF EXISTS salesperson;
DROP TABLE IF EXISTS cars;

CREATE TABLE cars (
    car_id INT NOT NULL AUTO_INCREMENT,
    vin CHAR(17),
    manufacturer VARCHAR(20),
    model VARCHAR(20),
    year CHAR(4),
    color VARCHAR(10),
    PRIMARY KEY (car_id)
);

CREATE TABLE salesperson (
    staff_uk INT NOT NULL AUTO_INCREMENT,
    staff_id CHAR(5),
    salesperson_name VARCHAR(20),
    store VARCHAR(20),
    PRIMARY KEY (staff_uk)
);

CREATE TABLE customer (
    cust_uk INT NOT NULL AUTO_INCREMENT,
    cust_id CHAR(5),
    cust_name VARCHAR(20),
    cust_phone CHAR(12),
    cust_email VARCHAR(100),
    cust_address VARCHAR(30),
    cust_city VARCHAR(20),
    cust_state VARCHAR(20),
    cust_country VARCHAR(20),
    cust_zipcode CHAR(5),
    PRIMARY KEY (cust_uk)
);

CREATE TABLE invoices (
    invoice_nr INT NOT NULL AUTO_INCREMENT,
    invoice_date DATE,
    cust_uk INT NOT NULL,
    car_id INT NOT NULL,
    staff_uk INT NOT NULL,
    PRIMARY KEY (invoice_nr),
    FOREIGN KEY (cust_uk) REFERENCES customer(cust_uk) ON DELETE CASCADE,
    FOREIGN KEY (car_id) REFERENCES cars(car_id) ON DELETE CASCADE,
    FOREIGN KEY (staff_uk) REFERENCES salesperson(staff_uk) ON DELETE CASCADE
);
