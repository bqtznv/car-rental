import UIKit

final class CarDetailViewController: UIViewController {
    private let car: Car
    private let store = FleetStore.shared
    private let days = UIStepper()
    private let durationLabel = Theme.label(style: .headline)
    private let totalLabel = Theme.label(style: .title1, color: Theme.accent)

    init(car: Car) { self.car = car; super.init(nibName: nil, bundle: nil) }
    required init?(coder: NSCoder) { fatalError("Programmatic UI only") }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = car.name
        view.backgroundColor = .systemGroupedBackground
        navigationItem.largeTitleDisplayMode = .never
        updateSaveButton()

        let scroll = UIScrollView()
        view.addSubview(scroll)
        Theme.pin(scroll, to: view)
        let art = UIImageView(image: UIImage(systemName: car.symbol))
        art.contentMode = .scaleAspectFit
        art.tintColor = car.color
        art.backgroundColor = car.color.withAlphaComponent(0.12)
        art.layer.cornerRadius = 24
        art.preferredSymbolConfiguration = UIImage.SymbolConfiguration(pointSize: 120, weight: .medium)
        art.heightAnchor.constraint(equalToConstant: 200).isActive = true
        art.isAccessibilityElement = false
        let title = Theme.label(car.name, style: .largeTitle)
        let tagline = Theme.label(car.tagline, style: .title3, color: .secondaryLabel)
        let specs = Theme.label("\(car.category.rawValue) · \(car.seats) seats\n\(car.range)\n\(car.dailyPrice)", style: .body)
        let included = Theme.label("Included in this demo quote\n• 200 km per day\n• Basic roadside assistance\n• Flexible pickup at the city center", style: .body, color: .secondaryLabel)
        days.minimumValue = 1
        days.maximumValue = 14
        days.value = 1
        days.addTarget(self, action: #selector(updateQuote), for: .valueChanged)
        days.accessibilityLabel = "Rental duration, in days"
        let duration = Theme.stack([durationLabel, days], spacing: 16, axis: .horizontal)
        duration.alignment = .center
        let reserve = UIButton(type: .system)
        var config = UIButton.Configuration.filled()
        config.title = "Preview reservation"
        config.image = UIImage(systemName: "arrow.right")
        config.imagePlacement = .trailing
        config.imagePadding = 10
        config.baseBackgroundColor = Theme.accent
        config.cornerStyle = .large
        config.contentInsets = NSDirectionalEdgeInsets(top: 18, leading: 20, bottom: 18, trailing: 20)
        reserve.configuration = config
        reserve.addTarget(self, action: #selector(previewReservation), for: .touchUpInside)
        let notice = Theme.label("Demo only. No payment or real reservation is made. Prices and vehicle specifications are illustrative. Changes reset when the app restarts.", style: .footnote, color: .secondaryLabel)
        let stack = Theme.stack([art, title, tagline, specs, included, duration, totalLabel, reserve, notice], spacing: 22)
        scroll.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: scroll.contentLayoutGuide.topAnchor, constant: 20),
            stack.bottomAnchor.constraint(equalTo: scroll.contentLayoutGuide.bottomAnchor, constant: -32),
            stack.leadingAnchor.constraint(equalTo: scroll.contentLayoutGuide.leadingAnchor, constant: 24),
            stack.trailingAnchor.constraint(equalTo: scroll.contentLayoutGuide.trailingAnchor, constant: -24),
            stack.widthAnchor.constraint(equalTo: scroll.frameLayoutGuide.widthAnchor, constant: -48)
        ])
        updateQuote()
    }

    private func updateSaveButton() {
        let saved = store.isFavorite(car)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: saved ? "heart.fill" : "heart"), style: .plain, target: self, action: #selector(toggleFavorite))
        navigationItem.rightBarButtonItem?.accessibilityLabel = saved ? "Unsave car" : "Save car"
        navigationItem.rightBarButtonItem?.tintColor = Theme.accent
    }

    @objc private func toggleFavorite() {
        store.toggleFavorite(car)
        updateSaveButton()
    }

    @objc private func updateQuote() {
        let count = Int(days.value)
        durationLabel.text = "\(count) \(count == 1 ? "day" : "days")"
        totalLabel.text = "$\(car.price * count) estimated total"
        days.accessibilityValue = "\(count) \(count == 1 ? "day" : "days")"
    }

    @objc private func previewReservation() {
        let count = Int(days.value)
        let alert = UIAlertController(title: "Your next drive", message: "\(car.name)\n\(count) \(count == 1 ? "day" : "days") · $\(car.price * count)\n\nThis is a preview. No booking has been made.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Keep exploring", style: .default))
        present(alert, animated: true)
    }
}
