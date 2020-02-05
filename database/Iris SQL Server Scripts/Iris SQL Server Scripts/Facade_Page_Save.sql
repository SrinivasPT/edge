CREATE OR ALTER PROCEDURE dbo.Facade_Page_Save(@json NVARCHAR(MAX), @context VARCHAR(MAX))
AS
BEGIN

	SET NOCOUNT ON; SET XACT_ABORT ON;

	DECLARE @Page VARCHAR(MAX), @Section VARCHAR(MAX), @Control VARCHAR(MAX)

	SET @Page = JSON_QUERY(@json, '$.Page')
	SET @Section = JSON_QUERY(@json, '$.Section')
	SET @Control = JSON_QUERY(@json, '$.Control')

	BEGIN TRY

		BEGIN TRAN;

		IF @Page IS NOT NULL
			EXEC framework.Entity_Page_Save @Page, @context

		IF @Section IS NOT NULL
			EXEC framework.Entity_Section_Save @Section, @context

		IF @Control IS NOT NULL
			EXEC framework.Entity_Control_Save @Control, @context

		COMMIT;

	END TRY

    BEGIN CATCH
        IF XACT_STATE() <> 0 ROLLBACK;
        PRINT N'Unable to create the Page.';
        THROW;
        RETURN -1;
    END CATCH;
END
GO