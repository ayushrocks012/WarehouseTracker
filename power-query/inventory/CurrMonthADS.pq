// Query Name: CurrMonthADS
// Depends On: SharedSource

let
    Source = SharedSource[LatestFileByPrefix](SharedSource[DailyTrackerPath], "CurrMonth"),
    ExcelBinary = Source[Content],
    ExcelData = Excel.Workbook(ExcelBinary, null, true),
    Data_Sheet = ExcelData{[Item="Sheet1", Kind="Sheet"]}[Data],
    #"Promoted Headers" = Table.PromoteHeaders(Data_Sheet, [PromoteAllScalars=true]),
    #"Removed Columns" = Table.RemoveColumns(#"Promoted Headers",{"Batch"})
in
    #"Removed Columns"
