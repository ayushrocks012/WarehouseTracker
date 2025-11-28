// Query Name: AUL_TagIds_Only
// Depends On: SharedSource

let
    Source = SharedSource[LatestFileByPrefix](SharedSource[DailyTrackerPath], "LX03"),
    ExcelBinary = Source[Content],
    ExcelData = Excel.Workbook(ExcelBinary, null, true),
    Data_Sheet = ExcelData{[Item="Sheet1", Kind="Sheet"]}[Data],
    #"Promoted Headers" = Table.PromoteHeaders(Data_Sheet, [PromoteAllScalars=true]),
    #"Removed Other Columns" = Table.SelectColumns(#"Promoted Headers",{"Material"}),
    #"Removed Duplicates" = Table.Distinct(#"Removed Other Columns")
in
    #"Removed Duplicates"
