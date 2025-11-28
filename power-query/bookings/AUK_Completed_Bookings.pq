// Query Name: AUK_Completed_Bookings
// Depends On: SharedSource

let
    // Load latest "Completed Bookings" Excel sheet
    PromotedHeaders = SharedSource[LatestSheet](SharedSource[DailyTrackerPath], "Completed Bookings", "Data"),
    WithSourceFile = SharedSource[WithFileNameColumn](PromotedHeaders),
    // Remove unnecessary columns
    RemovedColumns = Table.RemoveColumns(WithSourceFile,{"Pallet Qty", "Pallets Delivered", "Schedule Dstamp", "Schedule Duration", "Arrival", "Onsite", "Onsite Duration"}),
    ChangedTypes = Table.TransformColumnTypes(RemovedColumns,{
        {"Booking Reference", type text}, {"Carrier", type text}, {"Status", type text}, {"SourceFileName", type text}
    })
in
    ChangedTypes
