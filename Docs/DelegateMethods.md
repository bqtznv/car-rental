# UIKit delegate and data source checklist

All views are created in Swift with Auto Layout. The app starts with 12 cars: four in City, four in Electric, and four in Big cars. Both screens display the same shared data, so edits synchronize between tabs.

## UITableView — 19 methods

Implementation: `CarRental/FleetViewController.swift`. These are actual `UITableViewDataSource` / `UITableViewDelegate` requirements or optional hooks; none is an empty stub.

| # | Method | Purpose / demonstration |
| --- | --- | --- |
| 1 | `numberOfSections(in:)` | Three category sections in Car list. |
| 2 | `tableView(_:numberOfRowsInSection:)` | Four cars per category initially; tracks deletion. |
| 3 | `tableView(_:cellForRowAt:)` | Configures reusable custom cells with symbol, name, specs, price, and saved state. |
| 4 | `tableView(_:titleForHeaderInSection:)` | Category name and live row count. |
| 5 | `tableView(_:titleForFooterInSection:)` | Category explanation, or recovery instructions for an empty category. |
| 6 | `tableView(_:heightForRowAt:)` | Auto Layout self-sizing for long names and large fonts. |
| 7 | `tableView(_:estimatedHeightForRowAt:)` | Scaled row-height estimates improve initial scroll sizing. |
| 8 | `tableView(_:heightForHeaderInSection:)` | Automatic sizing for category header text. |
| 9 | `tableView(_:heightForFooterInSection:)` | Automatic sizing for wrapping descriptions. |
| 10 | `tableView(_:didSelectRowAt:)` | Pushes selected car details and deselects the row. |
| 11 | `tableView(_:canEditRowAt:)` | Enables standard editing and swipe controls for every demo vehicle. |
| 12 | `tableView(_:editingStyleForRowAt:)` | Shows deletion controls when Edit is tapped. |
| 13 | `tableView(_:commit:forRowAt:)` | Handles standard Edit-mode deletion in the shared store. |
| 14 | `tableView(_:trailingSwipeActionsConfigurationForRowAt:)` | Explicit Remove action; prevents accidental full-swipe deletion. |
| 15 | `tableView(_:leadingSwipeActionsConfigurationForRowAt:)` | Save/Unsave action and heart state synchronized across tabs. |
| 16 | `tableView(_:canMoveRowAt:)` | Enables reorder handles only for categories with multiple cars. |
| 17 | `tableView(_:targetIndexPathForMoveFromRowAt:toProposedIndexPath:)` | Constrains dragging to the original category. |
| 18 | `tableView(_:moveRowAt:to:)` | Updates shared vehicle order after a reorder. |
| 19 | `tableView(_:shouldHighlightRowAt:)` | Suppresses selection feedback in editing mode. |

## UICollectionView — 13 methods

Implementation: `CarRental/ExploreViewController.swift`. Layout methods conform to `UICollectionViewDelegateFlowLayout`, which inherits `UICollectionViewDelegate`.

| # | Method | Purpose / demonstration |
| --- | --- | --- |
| 1 | `numberOfSections(in:)` | Single filterable catalog section with one summary header. |
| 2 | `collectionView(_:numberOfItemsInSection:)` | 12 initially, then current filter results. |
| 3 | `collectionView(_:cellForItemAt:)` | Reuses and configures illustrated car cards. |
| 4 | `collectionView(_:viewForSupplementaryElementOfKind:at:)` | Displays intro and live result-count header. |
| 5 | `collectionView(_:layout:sizeForItemAt:)` | Responsive one/two/three-column sizing; grows cards for Dynamic Type. |
| 6 | `collectionView(_:layout:insetForSectionAt:)` | Aligns catalog margins and reserves bottom breathing room. |
| 7 | `collectionView(_:layout:minimumLineSpacingForSectionAt:)` | Consistent vertical row separation. |
| 8 | `collectionView(_:layout:minimumInteritemSpacingForSectionAt:)` | Horizontal gutters coordinated with the card-width calculation. |
| 9 | `collectionView(_:layout:referenceSizeForHeaderInSection:)` | Gives the summary header scaled height. |
| 10 | `collectionView(_:didSelectItemAt:)` | Opens details for the chosen card. |
| 11 | `collectionView(_:didHighlightItemAt:)` | Dims a card while pressed. |
| 12 | `collectionView(_:didUnhighlightItemAt:)` | Restores card appearance after release or cancellation. |
| 13 | `collectionView(_:contextMenuConfigurationForItemAt:point:)` | Long press offers Save/Unsave without navigation. |

## Additional behaviors

Cells use SF Symbols bundled with iOS, colored illustration backgrounds, rounded corners, typography, and layout spacing. No image downloads are required. The detail view lets you choose the number of days and shows the total in KZT. The rental summary uses the same price format.

Six XCTest cases validate model behavior, and a seventh checks the scene window, visible collection cards, and both catalogs at startup. Manual simulator checks cover UIKit layout, navigation, swipe interactions, edit controls, and screen synchronization. See `SimulatorRecording.md`.
