// Query Name: AUK_Inv_Batch
// Depends On: SharedSource

let
    Source = SharedSource[LatestSheet](SharedSource[DailyTrackerPath], "LX02", "Sheet1"),
    #"Removed Other Columns" = Table.SelectColumns(Source,{"Material", "Batch", "Available stock", "Pick quantity", "SLED/BBD", "Storage Bin", "Storage Type"}),

    #"Added Warehouse" = Table.AddColumn(#"Removed Other Columns", "Warehouse", each "075-UK"),

    #"Added Combined Storage Type" = Table.AddColumn(#"Added Warehouse", "Combined Storage Type", each
        if [Storage Type] = "014" or [Storage Type] = "011" then "AVAILABLE"
        else if [Storage Type] = "802" then "AVAILABLE"
        else if [Storage Type] = "904" then "SCHROTT"
        else if [Storage Type] = "916" then "ALLOCATED"
        else if [Storage Type] = "999" then "SCHROTT"
        else "NEW STORAGE TYPE TO BE DECIDED"
    ),
    #"Added Combined Storage Bin" = Table.AddColumn(#"Added Combined Storage Type", "Combined Storage Bin", each
        if [Combined Storage Type] = "AVAILABLE" then "AVAILABLE"
        else if [Storage Bin] = "STAGING" then "RECEIPT"
        else if [Combined Storage Type] = "ALLOCATED" then "ALLOCATED"
        else if [Combined Storage Type] = "SCHROTT" and [Storage Bin] = "DISPOSAL" then "SCRAP"
        else if [Combined Storage Type] = "SCHROTT" and [Storage Bin] = "DAMAGED" then "DAMAGED"
        else if [Combined Storage Type] = "SCHROTT" and [Storage Bin] = "CLOSEDOWN" then "ASK PHIL"
        else if [Combined Storage Type] = "SCHROTT" and [Storage Bin] = "DISPLAY" then "EXPIRED"
        else if [Combined Storage Type] = "SCHROTT" and [Storage Bin] = "GRIR" then "ASK PHIL"
        else if [Combined Storage Type] = "SCHROTT" and [Storage Bin] = "INVEST" then "ASK PHIL"
        else if [Combined Storage Type] = "SCHROTT" and [Storage Bin] = "MOOG" then "ASK PHIL"
        else if [Combined Storage Type] = "SCHROTT" and [Storage Bin] = "PGI" then "ASK PHIL"
        else if [Combined Storage Type] = "SCHROTT" and [Storage Bin] = "QAHOLD" then "QCHOLD"
        else if [Combined Storage Type] = "SCHROTT" and [Storage Bin] = "QUERY" then "TO BE INVESTIGATED"
        else if [Combined Storage Type] = "SCHROTT" and [Storage Bin] = "RETURNS" then "RETURN BLOCKED"
        else if [Combined Storage Type] = "SCHROTT" and [Storage Bin] = "SCHROTT" then "SHORTDATE"
        else if [Combined Storage Type] = "SCHROTT" and [Storage Bin] = "TROLLEY" then "RETURN BLOCKED"
        else if [Combined Storage Type] = "SCHROTT" and [Storage Bin] = "APPROVED" then "DESTRUCTION"
        else if [Combined Storage Type] = "SCHROTT" and [Storage Type] = "904" then "RETURN BLOCKED"
        else "NEW STORAGE BIN TO BE DECIDED"
    ),
    #"Added Net Inventory" = Table.AddColumn(#"Added Combined Storage Bin", "NET INVENTORY", each
        if [Available stock] = 0 then [Pick quantity] else [Available stock] - [Pick quantity]
    ),
    #"Removed Columns" = Table.RemoveColumns(#"Added Net Inventory",{ "Available stock", "Pick quantity", "Storage Bin", "Storage Type"}),
    #"Renamed Columns" = Table.RenameColumns(#"Removed Columns",{{"Material", "Product Code"}, {"SLED/BBD", "Expiry"}})
in
    #"Renamed Columns"
