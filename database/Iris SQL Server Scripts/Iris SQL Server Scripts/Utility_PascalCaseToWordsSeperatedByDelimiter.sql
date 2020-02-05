CREATE OR ALTER FUNCTION framework.PascalCaseToWordsSeparatedByDelimiter (@Text VARCHAR(8000), @delimiter CHAR(1)= ' ')
RETURNS VARCHAR(8000)
AS
BEGIN

	DECLARE @Reset BIT, @Ret VARCHAR(8000), @i INT, @c CHAR(1)

	IF @Text IS NULL RETURN NULL

	SELECT @Reset = 1, @i = 1, @Ret = ''

	WHILE (@i <= len(@Text))
		SELECT @c = SUBSTRING(@Text, @i, 1),
			@Reset = CASE
				WHEN @c COLLATE Latin1_General_BIN LIKE '[A-Z]' THEN 0
				ELSE 1
				END,
			@Ret = @Ret + CASE WHEN @Reset = 0 THEN ' ' + @c ELSE @c END,
			@i = @i + 1

	RETURN LTRIM(@Ret)

END
GO