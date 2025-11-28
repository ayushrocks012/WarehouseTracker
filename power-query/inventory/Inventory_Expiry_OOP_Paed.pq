// Query Name: Inventory_Expiry_OOP_Paed
// Depends On: Total_Inv_Batch

let
    Source = Total_Inv_Batch,
    #"Filtered Rows" = Table.SelectRows(Source, each ([#"REIMBURSED/OOP"] = "OOP") and ([#"ADULT/PAED"] = "PEDIATRIC"))
in
    #"Filtered Rows"
