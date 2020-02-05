/**********************************************************************************************
Drop all the framework related Entity Procedures and Functions
**********************************************************************************************/
DECLARE @ExecSQL AS NVARCHAR (MAX) = '';

SELECT @ExecSQL = @ExecSQL + 
    'DROP '+ ROUTINE_TYPE + '' + QUOTENAME(SPECIFIC_SCHEMA) + '.' + QUOTENAME(SPECIFIC_NAME) + '; ' 
FROM INFORMATION_SCHEMA.ROUTINES T
WHERE SPECIFIC_SCHEMA = 'framework'

PRINT @ExecSQL
EXEC (@ExecSQL)

/**********************************************************************************************
Gnerate the Procedures and Functions
**********************************************************************************************/
DECLARE @TableName VARCHAR(50), @SQL VARCHAR(max)

DECLARE table_cursor CURSOR FOR   
SELECT TABLE_NAME  
FROM INFORMATION_SCHEMA.TABLES  
WHERE TABLE_SCHEMA = 'Framework'
AND TABLE_TYPE = 'BASE TABLE'
  
OPEN table_cursor  
  
FETCH NEXT FROM table_cursor INTO @TableName

WHILE @@FETCH_STATUS = 0  
BEGIN  

	DECLARE @SchemaName sysname = 'Framework'		--> Name of the table where we want to insert JSON
	DECLARE @JsonColumns nvarchar(max) = '|CustomFields|'	--> List of pipe-separated NVARCHAR(MAX) column names that contain JSON text
	DECLARE @IgnoredColumns nvarchar(max) = N'ID, LastEditedBy' --> List of comma-separated columns that should not be imported

	SELECT @SQL = codegen.GenerateJsonRetrieveProcedure('Framework', @SchemaName, @TableName, @JsonColumns, @IgnoredColumns)
	EXEC (@SQL)
	
	SELECT @SQL = codegen.GenerateJsonUpsertProcedure('Framework', @SchemaName, @TableName, @JsonColumns, @IgnoredColumns)
	EXEC (@SQL)

    FETCH NEXT FROM table_cursor INTO @TableName

END   
CLOSE table_cursor;  
DEALLOCATE table_cursor;  
GO


