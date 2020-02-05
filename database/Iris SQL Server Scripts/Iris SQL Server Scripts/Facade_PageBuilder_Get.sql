CREATE OR ALTER PROCEDURE dbo.Facade_PageBuilder_Get(@PageName VARCHAR(50), @context VARCHAR(MAX))
AS
BEGIN

	DECLARE @PageHeader VARCHAR(2000), @PageBody VARCHAR(MAX)
	DECLARE @EscapeChar VARCHAR(20) = '&quot;'

	SELECT @PageHeader = CONCAT(
		'{"wrappers":["page-header"], "templateOptions": {"Title":"', DEscription,
		'","buttons":"', Buttons + '"}}')
	FROM framework.Page
	WHERE CONCAT(Name, framework.fnGetCodeValForID(TypeCodeID)) = @PageName

	SET @PageBody = (
		SELECT 
			Section.FormControlKey [key],
			JSON_QUERY(CONCAT('["', RTRIM(Section.Wrapper), '"]')) wrappers,
			JSON_QUERY((SELECT Section.label FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)) templateOptions,
			Section.ClassName fieldGroupClassName,
			Section.HideExpression,
			JSON_QUERY((
				SELECT
					PCV.FormControlKey [key],
					framework.fnGetCodeValForID(PCV.TypeCodeID) type,
					CONCAT('col-', PCV.Width) className,
					PCV.defaultValue,
					PCV.hideExpression,
					JSON_QUERY((
						SELECT framework.fnGetTemplateOptionsForControl(PCV.ControlID, framework.fnGetCodeValForID(PCV.TypeCodeID))
					)) templateOptions
				FROM framework.PageControlView PCV
					INNER JOIN framework.ControlMaster CM ON PCV.ControlID = CM.ID
				WHERE PCV.SectionID = Section.ID
				AND PCV.IsActive = 1
				ORDER BY PCV.SortOrder
				FOR JSON PATH
			)) fieldGroup
		FROM framework.Section
			INNER JOIN framework.Page ON Section.PageID = Page.ID
		WHERE CONCAT(Page.Name, framework.fnGetCodeValForID(TypeCodeID)) = @PageName
		AND Section.IsActive = 1 AND Page.IsActive = 1
		ORDER BY Section.SortOrder
		FOR JSON AUTO, WITHOUT_ARRAY_WRAPPER
	)

	IF @PageHeader IS NULL
		SELECT CONCAT('[', @PageBody, ']')
	ELSE
		SELECT CONCAT('[', @PageHeader, ',', @PageBody, ']')

END
GO