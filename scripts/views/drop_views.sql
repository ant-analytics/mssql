USE Bikestores
GO

-- drop views if they exist
IF OBJECT_ID('production_join', 'V') IS NOT NULL
    DROP VIEW production_join

IF OBJECT_ID('sales_join', 'V') IS NOT NULL
    DROP VIEW production_join
GO
