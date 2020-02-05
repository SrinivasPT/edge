CREATE OR ALTER FUNCTION framework.fnGetCodeValForID(@id INT)
RETURNS VARCHAR(50)
AS
BEGIN
	RETURN (
		SELECT Value 
		FROM framework.CodeVal 
		WHERE ID = @id
	)
END
GO

CREATE OR ALTER FUNCTION framework.fnGetCodeValForValue(@value VARCHAR(50))
RETURNS INT
AS
BEGIN
	RETURN (
		SELECT ID 
		FROM framework.CodeVal 
		WHERE Value = @value
	)
END
GO