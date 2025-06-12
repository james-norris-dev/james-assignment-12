CREATE DATABASE `pizza_orders`;

-- 1. Customers Table
CREATE TABLE `customers` (
    `customer_id` INT NOT NULL AUTO_INCREMENT,
    `customer_name` VARCHAR(200),
    `customer_phone_number` VARCHAR(20),
    PRIMARY KEY (`customer_id`)
);

INSERT INTO `customers` (`customer_name`, `customer_phone_number`)
VALUES ('Trevor Page', '226-555-4982');

INSERT INTO `customers` (`customer_name`, `customer_phone_number`)
VALUES ('John Doe', '555-555-9498');

SELECT 
    *
FROM
    `customers`;

-- 2. Menu Table
CREATE TABLE `menu` (
    `menu_item_id` INT NOT NULL AUTO_INCREMENT,
    `pizza_type` VARCHAR(100),
    `pizza_price` DECIMAL(15 , 2 ),
    PRIMARY KEY (`menu_item_id`)
);

INSERT INTO `menu` (`pizza_type`, `pizza_price`)
VALUES ('Pepperoni & Cheese', 7.99);

INSERT INTO `menu` (`pizza_type`, `pizza_price`)
VALUES ('Vegetarian', 9.99);

INSERT INTO `menu` (`pizza_type`, `pizza_price`)
VALUES ('Meat Lovers', 14.99);

INSERT INTO `menu` (`pizza_type`, `pizza_price`)
VALUES ('Hawaiian', 12.99);

SELECT 
    *
FROM
    `menu`;

-- 3. Orders Table    
CREATE TABLE `orders` (
    `order_id` INT NOT NULL AUTO_INCREMENT,
    `customer_id` INT NOT NULL,
    `order_date_time` DATETIME NOT NULL,
    PRIMARY KEY (`order_id`),
    CONSTRAINT `customer_id` FOREIGN KEY (`customer_id`)
        REFERENCES `customers` (`customer_id`)
);

INSERT INTO `orders` (`customer_id`, `order_date_time`)
VALUES (1, '2023-09-10 09:47:00');

INSERT INTO `orders` (`customer_id`, `order_date_time`)
VALUES (2, '2023-09-10 13:20:00');

INSERT INTO `orders` (`customer_id`, `order_date_time`)
VALUES (1, '2023-09-10 09:47:00');

INSERT INTO `orders` (`customer_id`, `order_date_time`)
VALUES (2, '2023-10-10 10:37:00');

SELECT 
    *
FROM
    `orders`;

-- 4. Order Items Table
CREATE TABLE `order_items` (
    `order_item_id` INT NOT NULL AUTO_INCREMENT,
    `order_id` INT NOT NULL,
    `menu_item_id` INT NOT NULL,
    `quantity` INT NOT NULL,
    PRIMARY KEY (`order_item_id`),
    CONSTRAINT `order_id` FOREIGN KEY (`order_id`)
        REFERENCES `orders` (`order_id`),
    CONSTRAINT `menu_item_id` FOREIGN KEY (`menu_item_id`)
        REFERENCES `menu` (`menu_item_id`)
);

INSERT INTO `order_items` (`order_id`, `menu_item_id`, `quantity`)
VALUES (1, 1, 1), (1, 3, 1);

INSERT INTO `order_items` (`order_id`, `menu_item_id`, `quantity`)
VALUES (2, 2, 1), (2, 3, 2);

INSERT INTO `order_items` (`order_id`, `menu_item_id`, `quantity`)
VALUES (3, 3, 1), (3, 4, 1);

INSERT INTO `order_items` (`order_id`, `menu_item_id`, `quantity`)
VALUES (4, 2, 3), (4, 4, 1);

SELECT 
    *
FROM
    `order_items`;

-- Query 1 - How much money each customer has spent at the restaurant
SELECT 
    c.customer_name AS `Customer`,
    SUM(oi.quantity * m.pizza_price) AS `Total Spent`
FROM
    `customers` c
        JOIN
    `orders` o ON c.customer_id = o.customer_id
        JOIN
    `order_items` oi ON o.order_id = oi.order_id
        JOIN
    `menu` m ON oi.menu_item_id = m.menu_item_id
GROUP BY c.customer_id;

-- Query 2 - How much each customer is ordering on which date
SELECT 
    c.customer_name AS `Customer`,
    o.order_date_time AS `Order Date`,
    m.pizza_type AS `Pizza Type`,
    SUM(oi.quantity) AS `Total Ordered`
FROM
    `customers` c
        JOIN
    `orders` o ON c.customer_id = o.customer_id
        JOIN
    `order_items` oi ON o.order_id = oi.order_id
        JOIN
    `menu` m ON oi.menu_item_id = m.menu_item_id
GROUP BY c.customer_id , o.order_date_time, m.pizza_type
ORDER BY `Customer`, `Order Date`, `Pizza Type`;
    