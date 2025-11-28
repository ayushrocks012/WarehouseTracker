// Query Name: CurrMonthADS
// Depends On: SharedSource

let
    Source = SharedSource[LatestSheet](SharedSource[DailyTrackerPath], "CurrMonth", "Sheet1"),
    WithSourceFile = SharedSource[WithFileNameColumn](Source),
    #"Removed Columns" = Table.RemoveColumns(WithSourceFile,{"Batch"})
in
    #"Removed Columns"
