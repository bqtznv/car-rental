import XCTest
import UIKit
@testable import OpenRoad

final class FleetStoreTests: XCTestCase {
    private let store = FleetStore.shared

    override func setUp() {
        super.setUp()
        store.restore()
    }

    override func tearDown() {
        store.restore()
        super.tearDown()
    }

    func testInitialFleetHasTwelveUniqueCarsInThreeCategories() {
        XCTAssertEqual(store.cars.count, 12)
        XCTAssertEqual(Set(store.cars.map(\.id)).count, 12)
        for category in CarCategory.allCases {
            XCTAssertEqual(store.cars(in: category).count, 4)
        }
    }

    func testFavoriteToggleIsReversible() {
        let car = store.cars[0]
        store.toggleFavorite(car)
        XCTAssertTrue(store.isFavorite(car))
        store.toggleFavorite(car)
        XCTAssertFalse(store.isFavorite(car))
    }

    func testRemovalAlsoRemovesFavoriteAndRestoreRecoversFleet() {
        let car = store.cars[0]
        store.toggleFavorite(car)
        store.remove(car)
        XCTAssertEqual(store.cars.count, 11)
        XCTAssertFalse(store.cars.contains { $0.id == car.id })
        XCTAssertFalse(store.isFavorite(car))
        store.restore()
        XCTAssertEqual(store.cars.count, 12)
        XCTAssertTrue(store.favorites.isEmpty)
    }

    func testMovePreservesCategoryMembershipAndOtherCategoryOrder() {
        let original = store.cars(in: .city).map(\.id)
        let electric = store.cars(in: .electric).map(\.id)
        store.move(from: 0, to: 3, in: .city)
        XCTAssertEqual(store.cars(in: .city).map(\.id), Array(original.dropFirst()) + [original[0]])
        XCTAssertEqual(store.cars(in: .electric).map(\.id), electric)
        XCTAssertEqual(store.cars.count, 12)
    }

    func testDeletingEntireFleetAndRestoring() {
        let original = store.cars
        for car in original { store.remove(car) }
        XCTAssertTrue(store.cars.isEmpty)
        for category in CarCategory.allCases { XCTAssertTrue(store.cars(in: category).isEmpty) }
        store.restore()
        XCTAssertEqual(store.cars.map(\.id), original.map(\.id))
    }

    func testInvalidMoveLeavesFleetUnchanged() {
        let original = store.cars.map(\.id)
        store.move(from: 99, to: 0, in: .city)
        store.move(from: 0, to: -1, in: .city)
        XCTAssertEqual(store.cars.map(\.id), original)
    }
}

final class AppLaunchTests: XCTestCase {
    func testLaunchAttachesVisibleSceneWindowAndLoadsBothCatalogs() {
        let checkedLaunch = expectation(description: "Application scene presents both catalogs")
        DispatchQueue.main.async {
            defer { checkedLaunch.fulfill() }
            FleetStore.shared.restore()

            let delegates = UIApplication.shared.connectedScenes.compactMap { $0.delegate as? SceneDelegate }
            guard let window = delegates.compactMap(\.window).first,
                  let tabs = window.rootViewController as? UITabBarController else {
                XCTFail("Launch must attach a retained window with the tab bar controller to an application scene.")
                return
            }
            XCTAssertNotNil(window.windowScene)
            XCTAssertFalse(window.isHidden)
            XCTAssertTrue(window.isKeyWindow)
            XCTAssertEqual(tabs.viewControllers?.count, 2)

            guard let exploreNavigation = tabs.viewControllers?.first as? UINavigationController,
                  let explore = exploreNavigation.viewControllers.first as? ExploreViewController,
                  let fleetNavigation = tabs.viewControllers?.last as? UINavigationController,
                  let fleet = fleetNavigation.viewControllers.first as? FleetViewController else {
                XCTFail("Both Explore and Fleet must be reachable from the root tabs.")
                return
            }
            explore.loadViewIfNeeded()
            fleet.loadViewIfNeeded()
            window.layoutIfNeeded()

            guard let collection = explore.view.subviews.compactMap({ $0 as? UICollectionView }).first,
                  let table = fleet.view.subviews.compactMap({ $0 as? UITableView }).first else {
                XCTFail("The launched screens must contain their collection and table views.")
                return
            }
            XCTAssertNotNil(collection.window)
            XCTAssertGreaterThan(collection.bounds.width, 0)
            XCTAssertGreaterThan(collection.bounds.height, 0)
            XCTAssertEqual(collection.numberOfItems(inSection: 0), 12)
            XCTAssertFalse(collection.visibleCells.isEmpty, "The initial catalog must actually render cards.")
            XCTAssertEqual(table.numberOfSections, 3)
            XCTAssertEqual((0..<table.numberOfSections).reduce(0) { $0 + table.numberOfRows(inSection: $1) }, 12)
        }
        wait(for: [checkedLaunch], timeout: 10)
    }
}
