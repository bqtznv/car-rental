import UIKit

enum CarCategory: String, CaseIterable {
    case city = "City", electric = "Electric", adventure = "Adventure"

    var subtitle: String {
        switch self {
        case .city: return "Easy parking. Effortless everyday trips."
        case .electric: return "Quiet drives with charging included."
        case .adventure: return "Room for people, bags, and new places."
        }
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
    var dailyPrice: String { "$\(price) / day" }
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
        Car(id: "mini", name: "MINI Cooper", category: .city, price: 49, seats: 4, range: "Automatic · Petrol", color: .systemOrange, tagline: "Small footprint. Big personality."),
        Car(id: "golf", name: "Volkswagen Golf", category: .city, price: 55, seats: 5, range: "Automatic · Petrol", color: .systemBlue, tagline: "Your dependable city companion."),
        Car(id: "yaris", name: "Toyota Yaris", category: .city, price: 42, seats: 5, range: "Automatic · Hybrid", color: .systemRed, tagline: "Make every city mile count."),
        Car(id: "a3", name: "Audi A3", category: .city, price: 69, seats: 5, range: "Automatic · Petrol", color: .systemIndigo, tagline: "A little more comfort for your commute."),
        Car(id: "model3", name: "Tesla Model 3", category: .electric, price: 89, seats: 5, range: "Up to 440 km · Electric", color: .systemTeal, tagline: "A fresh perspective on the open road."),
        Car(id: "ioniq", name: "Hyundai IONIQ 5", category: .electric, price: 85, seats: 5, range: "Up to 450 km · Electric", color: .systemMint, tagline: "More space for a quieter journey."),
        Car(id: "leaf", name: "Nissan Leaf", category: .electric, price: 59, seats: 5, range: "Up to 270 km · Electric", color: .systemGreen, tagline: "An easy introduction to electric."),
        Car(id: "polestar", name: "Polestar 2", category: .electric, price: 95, seats: 5, range: "Up to 470 km · Electric", color: .systemCyan, tagline: "Thoughtful design at every turn."),
        Car(id: "rav4", name: "Toyota RAV4", category: .adventure, price: 79, seats: 5, range: "Automatic · Hybrid", color: .systemBrown, tagline: "Take the scenic route home."),
        Car(id: "defender", name: "Land Rover Defender", category: .adventure, price: 139, seats: 7, range: "Automatic · Diesel", color: .systemGreen, tagline: "Bring everyone. Leave ordinary behind."),
        Car(id: "cx5", name: "Mazda CX-5", category: .adventure, price: 75, seats: 5, range: "Automatic · Petrol", color: .systemPurple, tagline: "Weekend escapes, beautifully simple."),
        Car(id: "outback", name: "Subaru Outback", category: .adventure, price: 82, seats: 5, range: "Automatic · AWD", color: .systemBlue, tagline: "Pack your bags and follow your curiosity.")
    ]
}
