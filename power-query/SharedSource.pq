// Query Name: SharedSource
// Depends On: None

let
    SiteUrl = "https://abbott.sharepoint.com/sites/GB-AN-HeadOffice",
    ApiVersion = 15,

    // Base connections
    Contents = SharePoint.Contents(SiteUrl, [ApiVersion = ApiVersion]),
    // Buffer SharePoint.Files to avoid multiple round-trips when filtering in dependent queries
    Files = Table.Buffer(SharePoint.Files(SiteUrl, [ApiVersion = ApiVersion])),

    // Common folders
    SharedDocuments = Contents{[Name="Shared Documents"]}[Content],
    GeneralFolder = SharedDocuments{[Name="General"]}[Content],
    DemandFolder = GeneralFolder{[Name="Demand"]}[Content],
    MasterDataFiles = DemandFolder{[Name="Master Data Files"]}[Content],
    DailyTrackerFolder = MasterDataFiles{[Name="Daily Tracker Files"]}[Content],
    DailyTrackerPbiFolder = MasterDataFiles{[Name="Daily Tracker Files UK Departures PBI"]}[Content],

    // Folder paths used with SharePoint.Files
    DailyTrackerPath = SiteUrl & "/Shared Documents/General/Demand/Master Data Files/Daily Tracker Files/",
    DailyTrackerPbiPath = SiteUrl & "/Shared Documents/General/Demand/Master Data Files/Daily Tracker Files UK Departures PBI/",

    // Helpers
    LatestTableEntry = (table as table) as table =>
        Table.FirstN(Table.Sort(table, {{"Date modified", Order.Descending}}), 1),
    LatestContent = (table as table) as binary =>
        let latestRow = Table.First(Table.Sort(table, {{"Date modified", Order.Descending}}))
        in latestRow[Content],
    LatestFileByPrefix = (folderPath as text, prefix as text, optional extension as nullable text) as record =>
        let
            expectedExtension = if extension = null then ".xlsx" else extension,
            filtered = Table.SelectRows(Files, each
                [Folder Path] = folderPath and
                Text.StartsWith([Name], prefix) and
                Text.EndsWith(Text.Lower([Name]), Text.Lower(expectedExtension))
            ),
            sorted = Table.Sort(filtered, {{"Date modified", Order.Descending}})
        in
            if Table.IsEmpty(sorted) then
                error "No files found in " & folderPath & " matching prefix '" & prefix & "' and extension '" & expectedExtension & "'."
            else
                sorted{0},
    LatestSheet = (folderPath as text, prefix as text, sheetName as text, optional extension as nullable text) as table =>
        let
            latestFile = LatestFileByPrefix(folderPath, prefix, extension),
            excelData = Excel.Workbook(latestFile[Content], null, true),
            sheet = try excelData{[Item=sheetName, Kind="Sheet"]}[Data] otherwise error "Sheet '" & sheetName & "' not found in file '" & latestFile[Name] & "'.",
            headers = Table.PromoteHeaders(sheet, [PromoteAllScalars=true])
        in
            Table.Buffer(headers) meta [FileName = latestFile[Name]],
    LatestCsvByPrefix = (folderPath as text, prefix as text) as table =>
        let
            latestFile = LatestFileByPrefix(folderPath, prefix, ".csv"),
            csvData = Csv.Document(latestFile[Content], [Delimiter=",", Encoding=1252, QuoteStyle=QuoteStyle.Csv]),
            headers = Table.PromoteHeaders(csvData, [PromoteAllScalars=true])
        in
            Table.Buffer(headers) meta [FileName = latestFile[Name]]
in
    [
        SiteUrl = SiteUrl,
        ApiVersion = ApiVersion,
        Contents = Contents,
        Files = Files,
        SharedDocuments = SharedDocuments,
        DemandFolder = DemandFolder,
        MasterDataFiles = MasterDataFiles,
        DailyTrackerFolder = DailyTrackerFolder,
        DailyTrackerPbiFolder = DailyTrackerPbiFolder,
        DailyTrackerPath = DailyTrackerPath,
        DailyTrackerPbiPath = DailyTrackerPbiPath,
        LatestTableEntry = LatestTableEntry,
        LatestContent = LatestContent,
        LatestFileByPrefix = LatestFileByPrefix,
        LatestSheet = LatestSheet,
        LatestCsvByPrefix = LatestCsvByPrefix
    ]
