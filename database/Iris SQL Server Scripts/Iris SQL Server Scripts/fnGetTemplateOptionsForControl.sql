CREATE OR ALTER FUNCTION framework.fnGetTemplateOptionsForControl(
	@ControlID INT,
	@Type VARCHAR(50)
)
RETURNS NVARCHAR(MAX)
AS
BEGIN

	DECLARE @json NVARCHAR(MAX), @DetailType VARCHAR(50), @RedirectURL VARCHAR(50)

	IF @Type = 'grid'
	BEGIN
		SET @json = (
			SELECT HeaderButtons,
				InlineButtons,
				EditURL,
				SelectionCheckboxTypeCodeID,
				ID controlID,
				(
					SELECT
						ControlMaster.Label headerName,
						FormControlKey field,
						framework.fnGetCodeValForID(TypeCodeID) type,
						1 sortable,
						1 filterable,
						GridColumns.filter,
						0 disabled,
						DomainCategoryCodeID domain,
						null parentDomain,
						0 hidden,
						min,
						max,
						minLength,
						maxLength,
						pattern,
						0 required,
						0 readOnly,
						0 GridColumnOrder,
						null localDomain
					FROM framework.Grid
						INNER JOIN framework.GridColumns ON grid.ID = GridColumns.GridID
						INNER JOIN framework.ControlMaster ON GridColumns.ControlID = ControlMaster.ID
					WHERE Grid.ID = @ControlID
					AND GridColumns.IsActive = 1
					ORDER BY GridColumns.SortOrder
					FOR JSON PATH, ROOT('columnDefs')
				) gridOptions
			FROM framework.Grid
			WHERE ID = @ControlID
			FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
		)
	END
	ELSE IF @Type = 'gridcolumns'
	BEGIN
		SET @json = (
			SELECT
				label,
				placeHolder,
				0 disabled,
				DomainCategoryCodeID domain,
				null parentDomain,
				0 hidden,
				min,
				max,
				MinLength,
				MaxLength,
				pattern,
				0 required,
				0 readOnly
			FROM framework.ControlMaster 
				INNER JOIN framework.GridColumns ON ControlMaster.ID = GridColumns.ControlID
			WHERE GridColumns.GridID = @ControlID
			AND ControlMaster.IsActive = 1
			FOR JSON AUTO, WITHOUT_ARRAY_WRAPPER
		)
	END
	ELSE 
	BEGIN
		SET @json = (
			SELECT
				label,
				placeHolder,
				0 disabled,
				DomainCategoryCodeID domain,
				null parentDomain,
				0 hidden,
				min,
				max,
				MinLength,
				MaxLength,
				pattern,
				0 required,
				SortOrder tabIndex,
				0 readOnly
			FROM framework.PageControlView
			WHERE ControlID = @ControlID
			AND IsActive = 1
			FOR JSON AUTO, WITHOUT_ARRAY_WRAPPER
		)
	END

	RETURN @json

END
GO