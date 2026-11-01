# Open Road — UIKit car rental demo

A programmatic Swift/UIKit iOS app with a 12-car collection catalog and a 12-row, three-section fleet table. No SwiftUI, storyboard, third-party dependencies, API keys, or backend services are used.

## Open and run

Requires **macOS, Xcode 16 or newer, and an installed iOS Simulator runtime**. The minimum deployment target is iOS 16.0. Supports iPhone, iPad, light/dark appearance, rotation, and Dynamic Type.

1. Open `CarRental.xcodeproj`.
2. Select the shared **OpenRoad** scheme and an available iPhone simulator.
3. Press **⌘R**. No signing team is needed for the simulator.
4. Press **⌘U** to run seven tests: six `FleetStoreTests` model tests and one `AppLaunchTests` startup check.

For a physical device, select your own signing team under Signing & Capabilities and use a unique bundle identifier.

## Features

- **Explore:** responsive collection grid, category filters, result-count header, long-press save menu, and press feedback.
- **Fleet:** self-sizing table cells grouped by category, leading swipe to save, trailing swipe to remove, and Edit mode to delete or reorder within a category.
- **Details:** car specifications, save button, 1–14 day duration stepper, live price estimate, and reservation preview alert.
- **Restore:** resets the demo fleet after deleting cars, including after deleting every car. Both tabs share the same model.
- **Accessibility:** descriptive VoiceOver labels, scalable text, larger grid cards for accessibility sizes, semantic colors, and Reduce Motion support.

All data is illustrative and in memory. Relaunching resets changes. Reservation previews do not create real bookings or charges. Each screen starts with all 12 vehicles; applying a category filter or removing cars intentionally reduces the visible count.

## Assignment evidence

See [the method-by-method checklist](Docs/DelegateMethods.md) for **19 different UITableView methods** and **13 different UICollectionView methods**, with their purpose and how to demonstrate them. These counts exclude UIViewController lifecycle overrides, shared UIScrollView methods, and custom helper methods.

The `CarRentalTests` target includes six model tests covering initial data, favorite toggling, removal and restoration, reordering, empty data, and invalid moves. A seventh test checks that launch connects a visible scene window, renders collection cards, and loads both 12-car catalogs.

## Updating after a blank launch screen

Startup uses `SceneDelegate` to attach a retained `UIWindow` to the active `UIWindowScene`. The scene delegate is registered both in `Info.plist` and through `AppDelegate`'s scene configuration callback; no storyboard is required.

If you ran the earlier version that only created a window in `AppDelegate`, download the updated project or pull the latest commit. Open its `CarRental.xcodeproj`, remove the old Open Road app from the simulator, choose **Product → Clean Build Folder** (**⇧⌘K**), then run again with **⌘R**. Reinstalling clears any saved launch/scene configuration from the old build; the app only contains resettable demo data.

For a Debug build, the Xcode console should report `OpenRoad: connected window to application scene.` If the screen remains blank, capture the console messages from launch together with your Xcode and simulator iOS versions so the remaining failure can be diagnosed.

## Build, test, and record on a Mac

With one iPhone simulator booted, run:

```sh
bash scripts/build-and-test.sh
bash scripts/record-simulator.sh
```

The first script builds, runs XCTest, installs, and launches the app. The second records the booted simulator to `build/OpenRoad-demo.mp4`. Follow [the recording walkthrough](Docs/SimulatorRecording.md), then press **Control-C** to finalize the recording. Attach that MP4 alongside the project ZIP when submitting.

## Validation status

The project was authored in a Linux cloud environment without Xcode, Apple's iOS SDK, or Simulator. Static Swift parsing, project-reference checks, plist/scheme validation, and archive integrity are checked here. **An iOS build, all seven XCTest tests, visual/runtime checks, and simulator recording still need to be completed on a Mac.** Static checks do not establish successful compilation or crash-free execution. No simulator recording is included or claimed.

## Files

- `CarRental/`: app lifecycle, model/store, reusable views, and three screen controllers.
- `CarRental.xcodeproj/`: complete project and shared build/test/run scheme.
- `CarRentalTests/`: XCTest model tests.
- `Docs/`: method checklist and simulator demonstration steps.
- `scripts/`: Mac build/test/launch and recording helpers.
