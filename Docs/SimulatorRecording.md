# Simulator demonstration and runtime checklist

This recording must be produced on a Mac with Xcode; it is not included in the Linux-generated submission archive.

1. Open the project, choose CarRental, boot an iPhone simulator, and run the app. Alternatively, with that simulator already booted, run `bash scripts/build-and-test.sh`.
2. Run `bash scripts/record-simulator.sh` in another Terminal window. Leave it running while interacting with Simulator.
3. **Cars:** scroll through all 12 cars. Tap Electric, show the four filtered cars, then return to All. Long press a card and choose Save.
4. Open MINI Cooper. Check that the daily price is 25 000 KZT. Change the number of days from 1 to 3 and check that the total becomes 75 000 KZT. Tap View total and check that the alert shows the same amount. Toggle the heart and go back.
5. **Car list:** scroll to show all three categories and the 12 rows. Swipe right on a row to save it; swipe left on a different row and tap Remove. Show that its category count decreases.
6. Tap Edit. Drag a car within its category. Try dragging across categories to demonstrate that category membership is preserved. Delete a row using the red Edit-mode control, then tap Done.
7. Return to Cars and show that the removed cars are gone and saved hearts are synchronized. Tap Reset and show all 12 cars again.
8. Press Control-C in the recording Terminal. Wait for `simctl` to finish writing `build/CarRental-demo.mp4`. Play it back before submitting.

## Additional manual runtime checks

- Delete all 12 cars: both tabs should explain the empty state, and Reset should recover every car.
- Increase text size, including accessibility sizes. Confirm cards use one column at accessibility sizes, names remain readable, and the details page scrolls.
- Rotate the simulator; also run once on an iPad simulator. Check grid columns and scroll behavior.
- Toggle light/dark appearance and enable Reduce Motion; confirm contrast and press feedback remain usable.
- Enable VoiceOver and check card, row, save-button, and duration-stepper announcements.
- Relaunch: the original 12-car in-memory demo fleet should return.
- Check that the app icon is named Car Rental and both car views show prices in KZT.
- Confirm the Xcode test report shows all seven tests executed, including `AppLaunchTests`, not skipped or zero tests.

The assignment's successful-build, crash-free runtime, and simulator-recording requirements remain unverified until these Mac checks are completed.
