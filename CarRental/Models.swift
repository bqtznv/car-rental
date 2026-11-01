import UIKit

enum CarCategory: String, CaseIterable {
    case city = "City", electric = "Electric", adventure = "Big cars"

    var subtitle: String {
        switch self {
        case .city: return "Small cars for trips around town."
        case .electric: return "Electric cars with a charger included."
        case .adventure: return "More room for people and bags."
        }
    }
}

enum RentalPrice {
    private static let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "en_KZ")
        formatter.numberStyle = .decimal
        formatter.usesGroupingSeparator = true
        formatter.groupingSeparator = " "
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 0
        return formatter
    }()

    static func format(_ amount: Int) -> String {
        let number = formatter.string(from: NSNumber(value: amount)) ?? String(amount)
        return "\(number) KZT"
    }
}

struct Car: Identifiable {
    let id: String
    let name: String
    let category: CarCategory
    let price: Int
    let seats: Int
    let range: String
    let color: UIColor
    let tagline: String
    var symbol: String { category == .adventure ? "suv.side.fill" : "car.side.fill" }
    var dailyPrice: String { "\(RentalPrice.format(price)) / day" }
}

final class FleetStore {
    static let shared = FleetStore()
    static let didChange = Notification.Name("FleetStoreDidChange")
    private(set) var cars = FleetStore.seed
    private(set) var favorites: Set<String> = []

    func cars(in category: CarCategory) -> [Car] { cars.filter { $0.category == category } }
    func isFavorite(_ car: Car) -> Bool { favorites.contains(car.id) }

    func toggleFavorite(_ car: Car) {
        if favorites.contains(car.id) { favorites.remove(car.id) } else { favorites.insert(car.id) }
        announce()
    }

    func remove(_ car: Car) {
        cars.removeAll { $0.id == car.id }
        favorites.remove(car.id)
        announce()
    }

    func restore() {
        cars = Self.seed
        favorites = []
        announce()
    }

    // Only the order within one category changes; identity and category stay stable.
    func move(from source: Int, to destination: Int, in category: CarCategory) {
        let positions = cars.indices.filter { cars[$0].category == category }
        guard positions.indices.contains(source), positions.indices.contains(destination) else { return }
        var group = self.cars(in: category)
        let car = group.remove(at: source)
        group.insert(car, at: destination)
        for (offset, position) in positions.enumerated() { cars[position] = group[offset] }
        announce()
    }

    private func announce() { NotificationCenter.default.post(name: Self.didChange, object: self) }

    static let seed: [Car] = [
        Car(id: "mini", name: "MINI Cooper", category: .city, price: 25_000, seats: 4, range: "Automatic · Petrol", color: .systemOrange, tagline: "A small car for city trips."),
        Car(id: "golf", name: "Volkswagen Golf", category: .city, price: 28_000, seats: 5, range: "Automatic · Petrol", color: .systemBlue, tagline: "A comfortable car for everyday use."),
        Car(id: "yaris", name: "Toyota Yaris", category: .city, price: 22_000, seats: 5, range: "Automatic · Hybrid", color: .systemRed, tagline: "An easy car to park and drive."),
        Car(id: "a3", name: "Audi A3", category: .city, price: 35_000, seats: 5, range: "Automatic · Petrol", color: .systemIndigo, tagline: "A small car with extra comfort."),
        Car(id: "model3", name: "Tesla Model 3", category: .electric, price: 45_000, seats: 5, range: "Up to 440 km · Electric", color: .systemTeal, tagline: "An electric car for longer trips."),
        Car(id: "ioniq", name: "Hyundai IONIQ 5", category: .electric, price: 42_000, seats: 5, range: "Up to 450 km · Electric", color: .systemMint, tagline: "An electric car with more space."),
        Car(id: "leaf", name: "Nissan Leaf", category: .electric, price: 30_000, seats: 5, range: "Up to 270 km · Electric", color: .systemGreen, tagline: "An electric car for city trips."),
        Car(id: "polestar", name: "Polestar 2", category: .electric, price: 48_000, seats: 5, range: "Up to 470 km · Electric", color: .systemCyan, tagline: "A comfortable electric car."),
        Car(id: "rav4", name: "Toyota RAV4", category: .adventure, price: 40_000, seats: 5, range: "Automatic · Hybrid", color: .systemBrown, tagline: "More room for family trips."),
        Car(id: "defender", name: "Land Rover Defender", category: .adventure, price: 70_000, seats: 7, range: "Automatic · Diesel", color: .systemGreen, tagline: "Seven seats and plenty of space."),
        Car(id: "cx5", name: "Mazda CX-5", category: .adventure, price: 38_000, seats: 5, range: "Automatic · Petrol", color: .systemPurple, tagline: "A big car for weekend trips."),
        Car(id: "outback", name: "Subaru Outback", category: .adventure, price: 41_000, seats: 5, range: "Automatic · All-wheel drive", color: .systemBlue, tagline: "Extra space for people and bags.")
    ]
}
