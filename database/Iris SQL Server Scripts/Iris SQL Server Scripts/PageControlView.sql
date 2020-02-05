CREATE OR ALTER VIEW framework.PageControlView
AS
SELECT
	Child.ID,
	Parent.ID ControlID,
	ISNULL(Child.FormControlKey, Parent.FormControlKey) FormControlKey,
	Parent.TypeCodeID,
	Parent.Label,
	Parent.PlaceHolder,
	Parent.Width,
	Parent.DomainCategoryCodeID,
	Parent.Min,
	Parent.Max,
	Parent.MinLength,
	Parent.MaxLength,
	Parent.Pattern,
	Parent.defaultValue,
	Child.HideExpression,
	Child.SortOrder,
	Child.SectionID,
	Child.IsActive
FROM framework.Control Child
	INNER JOIN framework.ControlMaster Parent ON Parent.ID = Child.ControlID
	AND Child.IsActive = 1 AND Parent.IsActive = 1