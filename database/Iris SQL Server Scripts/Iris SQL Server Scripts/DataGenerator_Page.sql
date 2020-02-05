DECLARE @pageJson NVARCHAR(MAX) = N'[
{"ID": 1, "Name": "Page", "Label":"Page", "TypeCodeID":1, "Description": "Page", "Route": "/page", "Icon":"Page", "Buttons":"BACK,SAVE,CANCEL", "SortOrder":1, "Checksum":1, "LastUpdatedBy":1, "IsActive":1},
{"ID": 2, "Name": "Section", "Label":"Section", "TypeCodeID":1, "Description": "Section", "Route": "/section", "Icon":"section", "Buttons":"BACK,SAVE,CANCEL", "SortOrder":2, "Checksum":1, "LastUpdatedBy":1, "IsActive":1},
{"ID": 3, "Name": "Control", "Label":"Control", "TypeCodeID":1, "Description": "Control", "Route": "/control", "Icon":"control", "Buttons":"BACK,SAVE,CANCEL", "SortOrder":3, "Checksum":1, "LastUpdatedBy":1, "IsActive":1}
]'
EXEC framework.Entity_Page_Save @pageJson, null

DECLARE @sectionJson NVARCHAR(MAX) = N'[
{"ID":1, "Name":"Detail", "Label":"Detail", "FormControlKey":"Page", "ClassName":"d-flex flex-wrap", "HideExpression":"none", "Wrapper":"panel", "PageID": 1, "SortOrder":1, "Checksum":0, "LastUpdatedBy":1},
{"ID":2, "Name":"Sections", "Label":"Sections", "FormControlKey":"Section", "ClassName":"d-flex flex-wrap", "HideExpression":"none", "Wrapper":"panel", "PageID": 1, "SortOrder":1, "Checksum":0, "LastUpdatedBy":1}
]'
EXEC framework.Entity_Section_Save @sectionJson, null

DECLARE @controlJson NVARCHAR(MAX) = (
	SELECT 
		ROW_NUMBER() OVER (ORDER BY ID) ID, ID ControlID, FormControlKey, 
		CASE WHEN TableName = 'Page' THEN 1 WHEN TableName = 'Section' THEN 2 END SectionID, 
		'none' HideExpression, 1 SortOrder, 1 Checksum, 1 LastUpdatedBy, 1 IsActive
	FROM framework.ControlMaster
	WHERE TableName IN ('Page', 'Section')
	AND ColumnName NOT IN ('ValidFrom', 'ValidTo')
	FOR JSON PATH
);
EXEC framework.Entity_Control_Save @controlJson, null

DECLARE @domainJson NVARCHAR(MAX) = N'[
{"ID":1,"Value":"Root","CategoryCodeID":1,"ParentCodeID":1,"Description":"Root","TypeCodeID":"Root","SortOrder":1,"Checksum":1,"LastUpdatedBy":1},
{"ID":2,"Value":"ACCESS_LEVEL","CategoryCodeID":2,"ParentCodeID":1,"Description":"Access Type - Admin/System/Framework/General","SortOrder":2,"Checksum":1,"LastUpdatedBy":1},
{"ID":3,"Value":"Framework","CategoryCodeID":2,"ParentCodeID":2,"Description":"Framework Related Doamin","SortOrder":3,"Checksum":1,"LastUpdatedBy":1},
{"ID":4,"Value":"System","CategoryCodeID":2,"ParentCodeID":2,"Description":"Sytem Related Doamin","SortOrder":4,"Checksum":1,"LastUpdatedBy":1},
{"ID":5,"Value":"Admin","CategoryCodeID":2,"ParentCodeID":2,"Description":"Admin Related Doamin","SortOrder":5,"Checksum":1,"LastUpdatedBy":1},
{"ID":6,"Value":"General","CategoryCodeID":2,"ParentCodeID":2,"Description":"General Related Doamin","SortOrder":6,"Checksum":1,"LastUpdatedBy":1},
{"ID":7,"Value":"Framework","CategoryCodeID":2,"ParentCodeID":2,"Description":"Framework Related Doamin","SortOrder":3,"Checksum":1,"LastUpdatedBy":1},
{"ID":8,"Value":"Framework","CategoryCodeID":2,"ParentCodeID":2,"Description":"Framework Related Doamin","SortOrder":3,"Checksum":1,"LastUpdatedBy":1},
{"ID":9,"Value":"Framework","CategoryCodeID":2,"ParentCodeID":2,"Description":"Framework Related Doamin","SortOrder":3,"Checksum":1,"LastUpdatedBy":1},
{"ID":10,"Value":"Framework","CategoryCodeID":2,"ParentCodeID":2,"Description":"Framework Related Doamin","SortOrder":3,"Checksum":1,"LastUpdatedBy":1},
{"ID":11,"Value":"Framework","CategoryCodeID":2,"ParentCodeID":2,"Description":"Framework Related Doamin","SortOrder":3,"Checksum":1,"LastUpdatedBy":1},
{"ID":12,"Value":"Framework","CategoryCodeID":2,"ParentCodeID":2,"Description":"Framework Related Doamin","SortOrder":3,"Checksum":1,"LastUpdatedBy":1},
{"ID":13,"Value":"Framework","CategoryCodeID":2,"ParentCodeID":2,"Description":"Framework Related Doamin","SortOrder":3,"Checksum":1,"LastUpdatedBy":1},
]'
EXEC framework.Entity_CodeVal_Save @domainJson, null

SELECT * FROM framework.Page
SELECT * FROM framework.Section
SELECT * FROM framework.Control
SELECT * FROM framework.CodeVal




