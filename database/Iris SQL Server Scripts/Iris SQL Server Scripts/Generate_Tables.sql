USE [Iris]
GO
/*********************************************************************************
Remove Versioning and drop history tables
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
GO

/*********************************************************************************
Now drop the tables in the order of dependency
*********************************************************************************/
DROP TABLE IF EXISTS [framework].[GridColumns];
DROP TABLE IF EXISTS [framework].[Grid];
DROP TABLE IF EXISTS [framework].[Control];
DROP TABLE IF EXISTS [framework].[ControlMaster];
DROP TABLE IF EXISTS [framework].[Section];
DROP TABLE IF EXISTS [framework].[Page];
DROP TABLE IF EXISTS [framework].[CodeVal];

/*********************************************************************************
Drop the Schema
*********************************************************************************/
DROP SCHEMA IF EXISTS audit
GO

CREATE SCHEMA audit
GO

/*********************************************************************************
Now Create tables
*********************************************************************************/
CREATE TABLE [framework].[Control](
	[ID] [int] NOT NULL IDENTITY(1,1) PRIMARY KEY,
	[ControlID] [int] NULL,
	[FormControlKey] [varchar](50) NULL,
	[SectionID] [int] NULL,
	[HideExpression] [varchar](50) NULL,
	[SortOrder] [int] NULL DEFAULT 1,
	[Checksum] [varchar](50) NULL,
	[LastUpdatedBy] [int] NULL,
	[IsActive] [bit] NULL DEFAULT 1,
    [ValidFrom] datetime2 GENERATED ALWAYS AS ROW START,
	[ValidTo] datetime2 GENERATED ALWAYS AS ROW END,
	PERIOD FOR SYSTEM_TIME (ValidFrom, ValidTo)
 )
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = audit.ControlHistory));
GO

CREATE TABLE [framework].[ControlMaster](
	[ID] [int] NOT NULL IDENTITY(1,1) PRIMARY KEY,
	[Name] [varchar](50) NULL,
	[FormControlKey] [varchar](50) NULL,
	[TypeCodeID] [int] NULL,
	[Label] [varchar](50) NULL,
	[PlaceHolder] [varchar](50) NULL DEFAULT 'Please enter value',
	[Width] [int] NULL DEFAULT 3,
	[DomainCategoryCodeID] [int] NULL,
	[ParentID] [int] NULL,
	[DefaultValue] [varchar](50) NULL,
	[Min] [int] NULL,
	[Max] [int] NULL,
	[MinLength] [int] NULL DEFAULT 0,
	[MaxLength] [int] NULL DEFAULT 50,
	[Pattern] [varchar](250) NULL,
	[TableName] [varchar](50) NULL,
	[ColumnName] [varchar](50) NULL,
	[Checksum] [varchar](50) NULL,
	[LastUpdatedBy] [int] NULL,
	[IsActive] [bit] NULL DEFAULT 1,
    [ValidFrom] datetime2 GENERATED ALWAYS AS ROW START,
	[ValidTo] datetime2 GENERATED ALWAYS AS ROW END,
	PERIOD FOR SYSTEM_TIME (ValidFrom, ValidTo)
 )
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = audit.ControlMasterHistory));
GO

CREATE TABLE [framework].[Grid](
	[ID] [int] NOT NULL PRIMARY KEY,
	[Name] [varchar](50) NULL,
	[HeaderButtons] [varchar](50) NULL,
	[InlineButtons] [varchar](50) NULL,
	[EditURL] [varchar](50) NULL,
	[SelectionCheckboxTypeCodeID] [int] NULL,
	[SortOrder] [int] NULL,
	[Checksum] [varchar](50) NULL,
	[LastUpdatedBy] [int] NULL,
	[IsActive] [bit] NULL DEFAULT 1,
    [ValidFrom] datetime2 GENERATED ALWAYS AS ROW START,
	[ValidTo] datetime2 GENERATED ALWAYS AS ROW END,
	PERIOD FOR SYSTEM_TIME (ValidFrom, ValidTo)
 )
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = audit.GridHistory));
GO

CREATE TABLE [framework].[GridColumns](
	[ID] [int] NOT NULL IDENTITY(1,1) PRIMARY KEY,
	[Name] [varchar](50) NULL,
	[ControlID] [int] NULL,
	[GridID] [int] NULL,
	[Filter] [varchar](50) NULL,
	[SortOrder] [int] NULL DEFAULT 1,
	[Checksum] [varchar](50) NULL,
	[LastUpdatedBy] [int] NULL,
	[IsActive] [bit] NULL DEFAULT 1,
    [ValidFrom] datetime2 GENERATED ALWAYS AS ROW START,
	[ValidTo] datetime2 GENERATED ALWAYS AS ROW END,
	PERIOD FOR SYSTEM_TIME (ValidFrom, ValidTo)
 )
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = audit.GridColumnsHistory));
GO

CREATE TABLE [framework].[Page](
	[ID] [int] NOT NULL IDENTITY(1,1) PRIMARY KEY,
	[Name] [varchar](50) NULL,
	[Label] [varchar](50) NULL,
	[TypeCodeID] [int] NULL,
	[Description] [varchar](255) NULL DEFAULT '',
	[Route] [varchar](50) NULL,
	[Icon] [varchar](50) NULL,
	[ParentID] [int] NULL,
	[Buttons] [varchar](255) NULL,
	[SortOrder] [int] NULL DEFAULT 1,
	[Checksum] [varchar](50) NULL,
	[LastUpdatedBy] [int] NULL,
	[IsActive] [bit] NULL DEFAULT 1,
    [ValidFrom] datetime2 GENERATED ALWAYS AS ROW START,
	[ValidTo] datetime2 GENERATED ALWAYS AS ROW END,
	PERIOD FOR SYSTEM_TIME (ValidFrom, ValidTo)
 )
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = audit.PageHistory));
GO

CREATE TABLE [framework].[Section](
	[ID] [int] NOT NULL IDENTITY(1,1) PRIMARY KEY,
	[Name] [varchar](50) NULL,
	[Label] [varchar](50) NULL,
	[FormControlKey] [varchar](50) NULL,
	[ClassName] [varchar](50) NULL,
	[HideExpression] [varchar](50) NULL,
	[Wrapper] [nchar](10) NULL,
	[PageID] [int] NULL,
	[SortOrder] [int] NULL DEFAULT 1,
	[Checksum] [varchar](50) NULL,
	[LastUpdatedBy] [int] NULL,
	[IsActive] [bit] NULL DEFAULT 1,
    [ValidFrom] datetime2 GENERATED ALWAYS AS ROW START,
	[ValidTo] datetime2 GENERATED ALWAYS AS ROW END,
	PERIOD FOR SYSTEM_TIME (ValidFrom, ValidTo)
 )
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = audit.SectionHistory));
GO

CREATE TABLE [framework].[CodeVal](
	[ID] [int] NOT NULL IDENTITY(1,1) PRIMARY KEY,
	[Value] [varchar](50) NULL,
	[CategoryCodeID] [int] NULL,
	[ParentCodeID] [int] NULL,
	[Description] [varchar](50) NULL,
	[TypeCodeID] [int] NULL, -- System / Admin / General
	[SortOrder] [int] NULL,
	[Checksum] [varchar](50) NULL,
	[LastUpdatedBy] [int] NULL,
	[IsActive] [bit] NULL DEFAULT 1,
    [ValidFrom] datetime2 GENERATED ALWAYS AS ROW START,
	[ValidTo] datetime2 GENERATED ALWAYS AS ROW END,
	PERIOD FOR SYSTEM_TIME (ValidFrom, ValidTo)
 )
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = audit.CodeValHistory));
GO

ALTER TABLE [framework].[Control]  WITH CHECK ADD  CONSTRAINT [FK_Control_ControlMaster] FOREIGN KEY([ControlID])
REFERENCES [framework].[ControlMaster] ([ID])
GO
ALTER TABLE [framework].[Control] CHECK CONSTRAINT [FK_Control_ControlMaster]
GO
ALTER TABLE [framework].[Control]  WITH CHECK ADD  CONSTRAINT [FK_Control_Section] FOREIGN KEY([SectionID])
REFERENCES [framework].[Section] ([ID])
GO
ALTER TABLE [framework].[Control] CHECK CONSTRAINT [FK_Control_Section]
GO
ALTER TABLE [framework].[Grid]  WITH CHECK ADD  CONSTRAINT [FK_Grid_ControlMaster] FOREIGN KEY([ID])
REFERENCES [framework].[ControlMaster] ([ID])
GO
ALTER TABLE [framework].[Grid] CHECK CONSTRAINT [FK_Grid_ControlMaster]
GO
ALTER TABLE [framework].[GridColumns]  WITH CHECK ADD  CONSTRAINT [FK_GridColumns_ControlMaster] FOREIGN KEY([ControlID])
REFERENCES [framework].[ControlMaster] ([ID])
GO
ALTER TABLE [framework].[GridColumns] CHECK CONSTRAINT [FK_GridColumns_ControlMaster]
GO
ALTER TABLE [framework].[GridColumns]  WITH CHECK ADD  CONSTRAINT [FK_GridColumns_Grid] FOREIGN KEY([GridID])
REFERENCES [framework].[Grid] ([ID])
GO
ALTER TABLE [framework].[GridColumns] CHECK CONSTRAINT [FK_GridColumns_Grid]
GO
ALTER TABLE [framework].[Section]  WITH CHECK ADD  CONSTRAINT [FK_Section_Page] FOREIGN KEY([PageID])
REFERENCES [framework].[Page] ([ID])
GO
ALTER TABLE [framework].[Section] CHECK CONSTRAINT [FK_Section_Page]
GO
