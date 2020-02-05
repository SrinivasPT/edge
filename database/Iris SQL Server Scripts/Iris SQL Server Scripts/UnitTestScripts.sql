/*
SELECT CONCAT('EXEC framework.Entity_', TABLE_NAME, '_Save @json, null') 
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'framework'
*/

DECLARE @json NVARCHAR(MAX) = N'{"ID": 1}'
EXEC framework.Entity_Page_Save @json, null
EXEC framework.Entity_Page_Save @json, null
EXEC framework.Entity_Section_Save @json, null
EXEC framework.Entity_Control_Save @json, null
EXEC framework.Entity_ControlMaster_Save @json, null
EXEC framework.Entity_Grid_Save @json, null
EXEC framework.Entity_GridColumns_Save @json, null

SELECT * FROM framework.Page
SELECT * FROM framework.Section
SELECT * FROM framework.Control
SELECT * FROM framework.ControlMaster
SELECT * FROM framework.Grid
SELECT * FROM framework.GridColumns