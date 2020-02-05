EXEC dbo.Facade_PageBuilder_Get 'Page', null


--SELECT * FROM framework.Page WHERE ID = 1
--SELECT * FROM framework.Section WHERE PageID = 1
--SELECT * FROM framework.Control WHERE SectionID IN (SELECT ID FROM framework.Section WHERE PageID = 1)

--SELECT * FROM INFORMATION_SCHEMA.ROUTINES
--SELECT *  
--FROM INFORMATION_SCHEMA.TABLES  
--WHERE TABLE_SCHEMA = 'Framework'
--AND TABLE_TYPE = 'BASE TABLE'

SELECT JSON_QUERY(CONCAT('["', Section.Wrapper, '"]')) wrappers FROM framework.Section
SELECT CONCAT('["', Section.Wrapper, 'Yrs')  FROM framework.Section
SELECT CONCAT('a', Name, 'c') FROM framework.Section
SELECT CONCAT('a', 'b', 'c')
UPDATE framework.Section SET Wrapper = 'panel'