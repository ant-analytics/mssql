USE Bikestores
GO

-- start create procedure
CREATE PROCEDURE check_null_duplicate
AS
BEGIN -- start logic

-- declare variables
DECLARE @table_name NVARCHAR(255)
DECLARE @column_name NVARCHAR(255)
DECLARE @sql NVARCHAR(MAX)

-- create cursor
DECLARE table_cursor CURSOR FOR
SELECT TABLE_NAME

END -- end logic
GO
