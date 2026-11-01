# Validation report

## Completed in the Linux cloud workspace

- Parsed all eight application Swift files and the XCTest Swift file using the tree-sitter Swift grammar; no syntax errors were reported. This is syntax parsing, not Swift compiler type checking.
- Parsed the OpenStep Xcode project and checked object-reference integrity, app/test source membership, target references, and scheme buildable references.
- Checked that the renamed `CarRental` target, shared scheme, test module, test host, and install script use the same app product. Checked `CFBundleDisplayName` and `CFBundleName` are both `Car Rental`.
- Checked all price displays use the shared KZT formatter, the 12 sample daily prices are stored in KZT, and the UI contains no USD price labels. Price formatting and totals still need the manual simulator checks in `SimulatorRecording.md`.
- Parsed `Info.plist` and the shared scheme as XML. Verified that the scene manifest maps the application role to `SceneDelegate`, that its configuration name matches the AppDelegate callback, and that `SceneDelegate.swift` belongs to the app's Sources build phase. No storyboards are used.
- Checked both Mac helper scripts with `bash -n`.
- Checked patch whitespace with `git diff --check`.
- Verified the submission ZIP's entry contents against the source files and checked archive integrity.

## Not executed here

- Xcode compilation and linking against the Apple iOS SDK.
- The seven XCTest tests (six model tests and a scene-launch regression test). They are included in the project and shared scheme, but have not been run.
- Simulator launch, visual checks, accessibility checks, and interaction/crash checks.
- Simulator video recording.

The Linux machine has no `xcodebuild`, `xcrun`, Apple SDK, or Simulator. Follow the README's Mac workflow to complete these remaining requirements. A successful static parse does not prove that an iOS app compiles or runs without crashes.
