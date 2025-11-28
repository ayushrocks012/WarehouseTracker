// Query Name: SharedSource
// Depends On: None

let
    SiteUrl = "https://abbott.sharepoint.com/sites/GB-AN-HeadOffice",
    ApiVersion = 15,

    // Base connections
    Contents = SharePoint.Contents(SiteUrl, [ApiVersion = ApiVersion]),
    Files = SharePoint.Files(SiteUrl, [ApiVersion = ApiVersion]),

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
        in latestRow[Content]
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
        LatestContent = LatestContent
    ]
