/**********************************************************************************************
Check for teh missing standarad columns
***********************************************************************************************/
;WITH MasterCTE (TABLE_NAME, COLUMN_NAME)
AS
(
	SELECT tab.TABLE_NAME, Col.Value 
	FROM INFORMATION_SCHEMA.TABLES tab
	FULL OUTER JOIN (SELECT value FROM STRING_SPLIT('ID,Name,SortOrder,LastUpdatedBy,Checksum,IsActive', ',')) Col ON 1=1
	WHERE tab.TABLE_SCHEMA = 'Framework'
)
SELECT 'Missing the Standard Columns', MasterCTE.TABLE_NAME,  MasterCTE.COLUMN_NAME
FROM MasterCTE 
	LEFT OUTER JOIN INFORMATION_SCHEMA.COLUMNS Col ON Col.TABLE_NAME = MasterCTE.TABLE_NAME AND Col.COLUMN_NAME = MasterCTE.COLUMN_NAME
WHERE Col.TABLE_NAME IS NULL

/**********************************************************************************************
Check for the Column Data Type Mismatch across the tables
***********************************************************************************************/
SELECT 'Column Mismatch in Column Data Type', COLUMN_NAME, TABLE_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS Parent
WHERE Parent.COLUMN_NAME IN (
		SELECT Child.COLUMN_NAME
		FROM (SELECT DISTINCT COLUMN_NAME, DATA_TYPE FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = 'Framework') Child
		GROUP BY COLUMN_NAME
		HAVING COUNT(*) > 1
		)
AND TABLE_SCHEMA = 'Framework'
ORDER BY 1