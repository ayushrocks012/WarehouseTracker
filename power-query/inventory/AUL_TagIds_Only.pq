// Query Name: AUL_TagIds_Only
// Depends On: SharedSource

let
    Source = SharedSource[LatestSheet](SharedSource[DailyTrackerPath], "LX03", "Sheet1"),
    WithSourceFile = SharedSource[WithFileNameColumn](Source),
    #"Removed Other Columns" = Table.SelectColumns(WithSourceFile,{"Material", "SourceFileName"}),
    #"Removed Duplicates" = Table.Distinct(#"Removed Other Columns", {"Material"})
in
    #"Removed Duplicates"
