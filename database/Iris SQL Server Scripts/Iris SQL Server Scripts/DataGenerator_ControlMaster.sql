DELETE FROM framework.ControlMaster;

INSERT INTO framework.ControlMaster
(Name, FormControlKey, TypeCodeID, Label, PlaceHolder, Width, DomainCategoryCodeID, ParentID, DefaultValue, Min, Max, MinLength, MaxLength, Pattern, TableName, ColumnName, Checksum, LastUpdatedBy, IsActive)
SELECT
	COLUMN_NAME Name,
	COLUMN_NAME FormControlName,
	CASE
		WHEN CHARINDEX('CodeID', COLUMN_NAME) > 0 THEN framework.fnGetCodeValForValue('select')
		WHEN DATA_TYPE IN ('VARCHAR', 'NVARCHAR') THEN framework.fnGetCodeValForValue('input')
		WHEN DATA_TYPE IN ('INT', 'DECIMAL') THEN framework.fnGetCodeValForValue('input')
		WHEN DATA_TYPE IN ('DATETIME', 'DATETIME2') THEN framework.fnGetCodeValForValue('date-picker')
		WHEN DATA_TYPE IN ('BIT', 'NVARCHAR') THEN framework.fnGetCodeValForValue('checkbox')
		WHEN DATA_TYPE IN ('VARCHAR', 'NVARCHAR') THEN framework.fnGetCodeValForValue('input')
	END TypeCodeID,
	framework.PascalCaseToWordsSeparatedByDelimiter(COLUMN_NAME, ' ') Label,
	COLUMN_DEFAULT PlaceHolder,
	3 Width,
	(SELECT ID FROM framework.CodeVal WHERE Value = REPLACE(COLUMN_NAME, 'CodeID','') AND ParentCodeID = 1) DomainCategoryCodeID,
	NULL DDParentFieldID,
	NULL DefaultValue,
	NULL Min,
	NULL Max,
	CASE WHEN DATA_TYPE = 'VARCHAR' THEN 0 ELSE NULL END MinLength,
	CASE WHEN DATA_TYPE = 'VARCHAR' THEN CHARACTER_MAXIMUM_LENGTH ELSE NULL END MinLength,
	NULL Pattern,
	TABLE_NAME TableName,
	COLUMN_NAME ColumnName,
	0 Checksum,
	NULL LastUpdatedBy,
	1 IsActive
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'framework';

SELECT * FROM framework.ControlMaster;