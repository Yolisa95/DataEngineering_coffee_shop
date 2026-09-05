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

CREATE VIEW DISTINCT_PAYMENT_METHOD AS
SELECT DISTINCT payment_method
FROM dwh_coffee_shop.dbo.coffee_shop_sales;

SELECT * FROM DISTINCT_PAYMENT_METHOD;

CREATE PROCEDURE usp_test_table
AS
BEGIN

    CREATE TABLE dwh_coffee_shop.dbo.test_table
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

EXEC usp_test_table;