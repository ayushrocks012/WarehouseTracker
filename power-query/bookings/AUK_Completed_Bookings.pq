let
    // Navigate to folder where Completed Bookings files reside
    DailyTrackerFolder = SharedSource[DailyTrackerFolder],

    // Filter only Excel files starting with "Completed Bookings"
    FilteredFiles = Table.SelectRows(DailyTrackerFolder, each Text.StartsWith([Name], "Completed Bookings") and Text.EndsWith([Name], ".xlsx")),

    // Sort by Date modified descending and get latest file
    LatestFile = SharedSource[LatestContent](FilteredFiles),

    // Load Excel workbook and select "Data" sheet
    ExcelData = Excel.Workbook(LatestFile, null, true),
    DataSheet = ExcelData{[Item="Data", Kind="Sheet"]}[Data],

    // Promote headers and set types
    PromotedHeaders = Table.PromoteHeaders(DataSheet, [PromoteAllScalars=true]),
    // Remove unnecessary columns
    RemovedColumns = Table.RemoveColumns(PromotedHeaders,{"Pallet Qty", "Pallets Delivered", "Schedule Dstamp", "Schedule Duration", "Arrival", "Onsite", "Onsite Duration"}),
    ChangedTypes = Table.TransformColumnTypes(RemovedColumns,{
        {"Booking Reference", type text}, {"Carrier", type text}, {"Status", type text}
    })
in
    ChangedTypes
