let
    // Navigate to folder where SKU Bible resides
    DemandFolder = SharedSource[DemandFolder],

    // Locate SKU Bible file
    SKUFile = DemandFolder{[Name="SKU Bible V2.xlsx"]}[Content],

    // Load Excel workbook and select SKUBIBLE table
    ExcelData = Excel.Workbook(SKUFile, null, true),
    SKUBIBLE_Table = ExcelData{[Item="SKUBIBLE", Kind="Table"]}[Data],

    // Filter for UNITED KINGDOM affiliate
    FilteredRows = Table.SelectRows(SKUBIBLE_Table, each [AFFILIATE] = "UNITED KINGDOM")
in
    FilteredRows
