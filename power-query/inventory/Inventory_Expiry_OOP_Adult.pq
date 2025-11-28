// Query Name: Inventory_Expiry_OOP_Adult
// Depends On: Total_Inv_Batch

let
    Source = Total_Inv_Batch,
    #"Filtered Rows" = Table.SelectRows(Source, each ([#"REIMBURSED/OOP"] = "OOP") and ([#"ADULT/PAED"] = "ADULT"))
in
    #"Filtered Rows"
