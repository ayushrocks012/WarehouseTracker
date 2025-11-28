// Query Name: Total_Inv_SKU
// Depends On: AUK_Inv_SKU, AUL_Inv_SKU

let
    Source = Table.Combine({AUK_Inv_SKU, AUL_Inv_SKU})
in
    Source
