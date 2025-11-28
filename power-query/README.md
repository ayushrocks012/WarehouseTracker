# Power Query script layout

This repository now organizes all `.pq` scripts under the `power-query/` folder. Subfolders group related queries and keep filenames aligned with their intended Power Query query names.

## Directory structure
- `shared/` – foundational queries reused elsewhere (e.g., `SharedSource.pq`).
- `bookings/` – booking and departure-related inputs.
- `inventory/` – SKU, batch, expiry, and inbound inventory transformations.
- `warehouse/` – warehouse-facing datasets and merges used by downstream views.

## Dependency-aware import order
Import queries in the following sequence to avoid missing references:
1. **Shared foundation**: `shared/SharedSource.pq` (update its `SiteUrl`/SharePoint settings before importing dependents).
2. **SharePoint-sourced inputs**: booking queries and warehouse inputs (`bookings/*.pq`, `warehouse/MergedData.pq`, `warehouse/PBI_Warehouse.pq`) plus inventory base extracts (`inventory/AUK_Inv_*.pq`, `inventory/AUL_Inv_*.pq`, `inventory/AUL_TagIds_Only.pq`, `inventory/CurrMonthADS.pq`, `inventory/SKUBIBLE.pq`).
3. **External reference**: `inventory/SKUBIBLE_V3.pq` (loads directly from the hosted SKU Bible file).
4. **Combined inventories**: `inventory/Total_Inv_Batch.pq` and `inventory/Total_Inv_SKU.pq` (depend on the base inventory queries and `SKUBIBLE_V3`).
5. **Derived reports**: expiry views (`inventory/Inventory_Expiry_*.pq`) that rely on `Total_Inv_Batch` and inbound view `inventory/OnOrderQty.pq` that relies on `PBI_Warehouse`.

## Importing the scripts
- In Power BI Desktop or Excel Power Query, create a blank query, open **Advanced Editor**, and paste the contents of each `.pq` file.
- **Align the query name** with the `.pq` filename (e.g., import `Total_Inv_Batch.pq` into a query named `Total_Inv_Batch`) so references resolve correctly.
- If your environment uses parameters for the SharePoint site or file paths, update them inside `SharedSource` **before** loading any dependent queries.

## Naming conventions
- Filenames are PascalCase with underscores to mirror the expected query names.
- Each file begins with a header noting the intended query name and its direct dependencies to assist with ordering and troubleshooting.
- `SharedSource` now exposes `LatestFileByPrefix(folderPath, prefix, [extension])` to quickly and reliably fetch the newest SharePoint file in a folder. This helper is used by inventory inputs to avoid repeated scans and throw clear errors when no matching file exists.
