// Query Name: AUL_Inv_SKU
// Depends On: SharedSource

let
    Source = SharedSource[LatestSheet](SharedSource[DailyTrackerPath], "LX03", "Sheet1"),
    #"Removed Other Columns" = Table.SelectColumns(Source,{"Material", "Material Description", "Batch", "Available stock", "Pick quantity", "SLED/BBD", "Storage Bin", "Storage Type", "Plant"}),

    #"Added Warehouse" = Table.AddColumn(#"Removed Other Columns", "Warehouse", each "Limerick"),

    #"Added Net Inventory" = Table.AddColumn(#"Added Warehouse", "Net Inventory", each
        if [Available stock] = 0 then [Pick quantity] else [Available stock] - [Pick quantity]
    ),

    #"Added Combined Storage Type" = Table.AddColumn(#"Added Net Inventory", "Combined Storage Type", each
        if [Storage Type] = "012" then "AVAILABLE"
        else if [Storage Type] = "913" then "AVAILABLE"
        else if [Storage Type] = "903" then "ALLOCATED"
        else if [Storage Type] = "914" then "ALLOCATED"
        else if [Storage Type] = "915" then "ALLOCATED"
        else if [Storage Type] = "901" then "SCHROTT"
        else if [Storage Type] = "918" then "SCHROTT"
        else if [Storage Type] = "914" then "AVAILABLE"
        else if [Storage Type] = "914" then "ALLOCATED"
        else "NEW STORAGE TYPE TO BE DECIDED"
    ),

    #"Added Combined Storage Bin" = Table.AddColumn(#"Added Combined Storage Type", "Combined Storage Bin", each
        if [Combined Storage Type] = "AVAILABLE" and [Storage Bin] = "STAGE" then "RECEIPT"
        else if [Combined Storage Type] = "AVAILABLE" then "AVAILABLE"
        else if [Combined Storage Type] = "ALLOCATED" then "ALLOCATED"
        else if [Combined Storage Type] = "SCHROTT" and [Storage Bin] = "DISPOSAL" then "SCRAP"
        else if [Combined Storage Type] = "SCHROTT" and [Storage Bin] = "DAMAGED" then "DAMAGED"
        else if [Combined Storage Type] = "SCHROTT" and [Storage Bin] = "DISPLAY" then "EXPIRED"
        else if [Combined Storage Type] = "SCHROTT" and [Storage Bin] = "GRIR" then "ASK PHIL"
        else if [Combined Storage Type] = "SCHROTT" and [Storage Bin] = "TEST" then "TEST"
        else if [Combined Storage Type] = "SCHROTT" and [Storage Bin] = "TROLLEY" then "RETURN BLOCKED"
        else if [Combined Storage Type] = "SCHROTT" and [Storage Bin] = "RETURN" then "RETURN BLOCKED"
        else "NEW STORAGE BIN TO BE DECIDED"
    ),

    #"Removed Columns" = Table.RemoveColumns(#"Added Combined Storage Bin",{"Material Description", "Available stock", "Pick quantity", "Storage Bin", "Storage Type", "Plant", "Batch", "SLED/BBD"}),
    #"Renamed Columns" = Table.RenameColumns(#"Removed Columns",{{"Material", "Product Code"}}),
    #"Grouped Rows" = Table.Group(#"Renamed Columns", {"Product Code", "Warehouse", "Combined Storage Type", "Combined Storage Bin"}, {{"Total Net Inventory", each List.Sum([Net Inventory]), type number}})
in
    #"Grouped Rows"
