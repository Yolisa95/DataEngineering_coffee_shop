--====================================================
-- CREATE DATABASES
--====================================================

IF DB_ID('stg_coffee_shop') IS NULL
BEGIN
    CREATE DATABASE stg_coffee_shop;
END;
GO

IF DB_ID('dwh_coffee_shop') IS NULL
BEGIN
    CREATE DATABASE dwh_coffee_shop;
END;
GO

--====================================================
-- CREATE STAGING TABLE
--====================================================

IF OBJECT_ID('stg_coffee_shop.dbo.coffee_shop_sales', 'U') IS NULL
BEGIN
    CREATE TABLE stg_coffee_shop.dbo.coffee_shop_sales
    (
        beverage          VARCHAR(250),
        price             INT,
        discount          INT,
        bev_size          VARCHAR(50),
        payment_method    VARCHAR(50)
    );
END;
GO

--====================================================
-- CREATE DATA WAREHOUSE TABLE
--====================================================

IF OBJECT_ID('dwh_coffee_shop.dbo.coffee_shop_sales', 'U') IS NULL
BEGIN
    CREATE TABLE dwh_coffee_shop.dbo.coffee_shop_sales
    (
        beverage          VARCHAR(250),
        price             INT,
        discount          INT,
        total_price       INT,
        bev_size          VARCHAR(50),
        payment_method    VARCHAR(50)
    );
END;
GO

--====================================================
-- LOAD STAGING TABLE
--====================================================

IF NOT EXISTS
(
    SELECT 1
    FROM stg_coffee_shop.dbo.coffee_shop_sales
)
BEGIN
    INSERT INTO stg_coffee_shop.dbo.coffee_shop_sales
    (
        beverage,
        price,
        discount,
        bev_size,
        payment_method
    )
    VALUES
    ('Cappuccino',25,5,'Medium','cash'),
    ('Americano',30,7,'Large','card'),
    ('Latte',40,8,'Small','voucher'),
    ('Espresso',20,0,'Small','cash'),
    ('Mocha',45,10,'Large','card'),
    ('Flat White',35,5,'Medium','cash'),
    ('Macchiato',28,3,'Small','card'),
    ('Hot Chocolate',32,5,'Medium','voucher'),
    ('Chai Latte',38,6,'Large','card'),
    ('Iced Coffee',36,4,'Medium','cash'),
    ('Caramel Latte',42,8,'Large','card'),
    ('Vanilla Latte',41,7,'Medium','voucher'),
    ('Cold Brew',39,5,'Large','cash'),
    ('Green Tea',24,2,'Small','card'),
    ('Black Coffee',22,0,'Medium','cash');
END;

--====================================================
-- LOAD DATA WAREHOUSE
--====================================================

INSERT INTO dwh_coffee_shop.dbo.coffee_shop_sales
(
    beverage,
    price,
    discount,
    total_price,
    bev_size,
    payment_method
)
SELECT
    s.beverage,
    s.price,
    s.discount,
    s.price - s.discount AS total_price,
    s.bev_size,
    s.payment_method
FROM stg_coffee_shop.dbo.coffee_shop_sales s
WHERE NOT EXISTS
(
    SELECT 1
    FROM dwh_coffee_shop.dbo.coffee_shop_sales d
    WHERE d.beverage = s.beverage
);

--====================================================
-- CREATE CASH PAYMENT TABLE
--====================================================

IF OBJECT_ID('dwh_coffee_shop.dbo.cash_payment', 'U') IS NULL
BEGIN
    CREATE TABLE dwh_coffee_shop.dbo.cash_payment
    (
        beverage          VARCHAR(250),
        price             INT,
        discount          INT,
        total_price       INT,
        bev_size          VARCHAR(50),
        payment_method    VARCHAR(50)
    );
END;

--====================================================
-- CREATE CARD PAYMENT TABLE
--====================================================

IF OBJECT_ID('dwh_coffee_shop.dbo.payment_card', 'U') IS NULL
BEGIN
    CREATE TABLE dwh_coffee_shop.dbo.payment_card
    (
        beverage          VARCHAR(250),
        price             INT,
        discount          INT,
        total_price       INT,
        bev_size          VARCHAR(50),
        payment_method    VARCHAR(50)
    );
END;

--====================================================
-- CREATE VOUCHER PAYMENT TABLE
--====================================================

IF OBJECT_ID('dwh_coffee_shop.dbo.voucher_payment', 'U') IS NULL
BEGIN
    CREATE TABLE dwh_coffee_shop.dbo.voucher_payment
    (
        beverage          VARCHAR(250),
        price             INT,
        discount          INT,
        total_price       INT,
        bev_size          VARCHAR(50),
        payment_method    VARCHAR(50)
    );
END;

--====================================================
-- LOAD CASH PAYMENTS
--====================================================

INSERT INTO dwh_coffee_shop.dbo.cash_payment
(
    beverage,
    price,
    discount,
    total_price,
    bev_size,
    payment_method
)
SELECT
    beverage,
    price,
    discount,
    total_price,
    bev_size,
    payment_method
FROM dwh_coffee_shop.dbo.coffee_shop_sales s
WHERE s.payment_method = 'cash'
AND NOT EXISTS
(
    SELECT 1
    FROM dwh_coffee_shop.dbo.cash_payment c
    WHERE c.beverage = s.beverage
);

--====================================================
-- LOAD CARD PAYMENTS
--====================================================

INSERT INTO dwh_coffee_shop.dbo.payment_card
(
    beverage,
    price,
    discount,
    total_price,
    bev_size,
    payment_method
)
SELECT
    beverage,
    price,
    discount,
    total_price,
    bev_size,
    payment_method
FROM dwh_coffee_shop.dbo.coffee_shop_sales s
WHERE s.payment_method = 'card'
AND NOT EXISTS
(
    SELECT 1
    FROM dwh_coffee_shop.dbo.payment_card p
    WHERE p.beverage = s.beverage
);

--====================================================
-- LOAD VOUCHER PAYMENTS
--====================================================

INSERT INTO dwh_coffee_shop.dbo.voucher_payment
(
    beverage,
    price,
    discount,
    total_price,
    bev_size,
    payment_method
)
SELECT
    beverage,
    price,
    discount,
    total_price,
    bev_size,
    payment_method
FROM dwh_coffee_shop.dbo.coffee_shop_sales s
WHERE s.payment_method = 'voucher'
AND NOT EXISTS
(
    SELECT 1
    FROM dwh_coffee_shop.dbo.voucher_payment v
    WHERE v.beverage = s.beverage
);

--====================================================
-- VERIFY DATA
--====================================================

SELECT * FROM stg_coffee_shop.dbo.coffee_shop_sales;

SELECT * FROM dwh_coffee_shop.dbo.coffee_shop_sales;

SELECT * FROM dwh_coffee_shop.dbo.cash_payment;

SELECT * FROM dwh_coffee_shop.dbo.payment_card;

SELECT * FROM dwh_coffee_shop.dbo.voucher_payment;

SELECT DISTINCT payment_method
FROM dwh_coffee_shop.dbo.coffee_shop_sales;