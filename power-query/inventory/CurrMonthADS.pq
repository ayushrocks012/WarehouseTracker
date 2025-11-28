// Query Name: CurrMonthADS
// Depends On: SharedSource

let
    Source = SharedSource[LatestSheet](SharedSource[DailyTrackerPath], "CurrMonth", "Sheet1"),
    #"Removed Columns" = Table.RemoveColumns(Source,{"Batch"})
in
    #"Removed Columns"
