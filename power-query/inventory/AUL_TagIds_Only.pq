// Query Name: AUL_TagIds_Only
// Depends On: SharedSource

let
    Source = SharedSource[LatestSheet](SharedSource[DailyTrackerPath], "LX03", "Sheet1"),
    #"Removed Other Columns" = Table.SelectColumns(Source,{"Material"}),
    #"Removed Duplicates" = Table.Distinct(#"Removed Other Columns")
in
    #"Removed Duplicates"
