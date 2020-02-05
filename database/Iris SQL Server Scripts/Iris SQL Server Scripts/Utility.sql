/*********************************************************************************
DROP ALL Objects
*********************************************************************************/
DECLARE @ExecSQL AS NVARCHAR (MAX) = '';

SELECT @ExecSQL = @ExecSQL + 
    'DROP TABLE ' + QUOTENAME(S.name) + '.' + QUOTENAME(T.name) + '; ' 
FROM sys.tables T
JOIN sys.schemas S ON S.schema_id = T.schema_id
WHERE T.name IN ('A', 'B')

PRINT @ExecSQL
--EXEC (@ExecSQL)

/*********************************************************************************
DROP Temporal Tables
*********************************************************************************/
SET NOCOUNT ON ;
DECLARE @cmd NVARCHAR (MAX);

DECLARE
    @SchemaName VARCHAR(100),
    @TableName VARCHAR(100),
    @HistorySchemaName VARCHAR(100),
    @HistoryTableName VARCHAR(100);

SET @cmd = '' ;

SELECT TOP ( 1 )
       @SchemaName = SCHEMA_NAME(T1.schema_id ),
       @TableName = T1 .name,
       @HistorySchemaName = SCHEMA_NAME(T2.schema_id ),
       @HistoryTableName = T2 .name
FROM sys.tables T1
LEFT JOIN sys.tables T2
    ON T1.history_table_id = T2 .object_id
WHERE T1. temporal_type = 2
ORDER BY T1. name;


WHILE @@ROWCOUNT = 1
    BEGIN
        SET @cmd = 'ALTER TABLE ' + QUOTENAME (@SchemaName ) + '. ' + QUOTENAME(@TableName) + ' SET ( SYSTEM_VERSIONING = OFF );
DROP TABLE '       + QUOTENAME (@HistorySchemaName ) + '.' + QUOTENAME(@HistoryTableName );
        EXEC sp_executesql @cmd

        SELECT TOP ( 1 )
               @SchemaName = SCHEMA_NAME(T1.schema_id ),
               @TableName = T1 .name,
               @HistorySchemaName = SCHEMA_NAME(T2.schema_id ),
               @HistoryTableName = T2 .name
        FROM sys.tables T1
        LEFT JOIN sys.tables T2
            ON T1 .history_table_id = T2 .object_id
        WHERE
            T1 .temporal_type = 2
            AND T1 .name > @TableName
        ORDER BY T1 .name;
    END;

/*********************************************************************************
Pascal Case to Word Separated by Delimiter
*********************************************************************************/