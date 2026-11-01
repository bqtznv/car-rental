import XCTest
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
