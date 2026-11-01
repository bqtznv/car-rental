import UIKit

final class CarCardCell: UICollectionViewCell {
    static let reuseID = "CarCardCell"
    private let art = UIView()
    private let icon = UIImageView()
    private let heart = UIImageView(image: UIImage(systemName: "heart.fill"))
    private let name = Theme.label(style: .headline)
    private let category = Theme.label(style: .caption1, color: .secondaryLabel)
    private let price = Theme.label(style: .subheadline, color: Theme.accent)

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .secondarySystemGroupedBackground
        contentView.layer.cornerRadius = 20
        contentView.clipsToBounds = true
        art.layer.cornerRadius = 14
        icon.contentMode = .scaleAspectFit
        icon.preferredSymbolConfiguration = UIImage.SymbolConfiguration(pointSize: 60, weight: .medium)
        art.addSubview(icon)
        Theme.pin(icon, to: art, inset: 18)
        heart.tintColor = Theme.accent
        heart.contentMode = .scaleAspectFit
        art.addSubview(heart)
        heart.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            heart.topAnchor.constraint(equalTo: art.topAnchor, constant: 10),
            heart.trailingAnchor.constraint(equalTo: art.trailingAnchor, constant: -10),
            heart.widthAnchor.constraint(equalToConstant: 18), heart.heightAnchor.constraint(equalToConstant: 18)
        ])
        let stack = Theme.stack([art, category, name, price], spacing: 6)
        contentView.addSubview(stack)
        Theme.pin(stack, to: contentView, inset: 12)
        art.heightAnchor.constraint(greaterThanOrEqualToConstant: 80).isActive = true
        name.setContentCompressionResistancePriority(.required, for: .vertical)
        category.setContentCompressionResistancePriority(.required, for: .vertical)
        price.setContentCompressionResistancePriority(.required, for: .vertical)
        isAccessibilityElement = true
        accessibilityTraits = .button
    }

    required init?(coder: NSCoder) { fatalError("Programmatic UI only") }

    func configure(with car: Car, favorite: Bool) {
        icon.image = UIImage(systemName: car.symbol)
        icon.tintColor = car.color
        art.backgroundColor = car.color.withAlphaComponent(0.12)
        name.text = car.name
        category.text = car.category.rawValue.uppercased()
        price.text = car.dailyPrice
        heart.isHidden = !favorite
        accessibilityLabel = "\(car.name), \(car.category.rawValue), \(car.dailyPrice)\(favorite ? ", saved" : "")"
        accessibilityHint = "Opens rental details. Touch and hold for save options."
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        contentView.alpha = 1
        contentView.transform = .identity
    }
}

final class FleetCell: UITableViewCell {
    static let reuseID = "FleetCell"
    private let icon = UIImageView()
    private let name = Theme.label(style: .headline)
    private let specs = Theme.label(style: .caption1, color: .secondaryLabel)
    private let price = Theme.label(style: .subheadline, color: Theme.accent)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        icon.contentMode = .scaleAspectFit
        icon.layer.cornerRadius = 12
        icon.preferredSymbolConfiguration = UIImage.SymbolConfiguration(pointSize: 28)
        icon.widthAnchor.constraint(equalToConstant: 60).isActive = true
        icon.heightAnchor.constraint(equalToConstant: 60).isActive = true
        let labels = Theme.stack([name, specs, price], spacing: 5)
        let row = Theme.stack([icon, labels], spacing: 14, axis: .horizontal)
        row.alignment = .center
        contentView.addSubview(row)
        Theme.pin(row, to: contentView, inset: 14)
        accessoryType = .disclosureIndicator
    }

    required init?(coder: NSCoder) { fatalError("Programmatic UI only") }

    func configure(with car: Car, favorite: Bool) {
        name.text = car.name + (favorite ? " ♥" : "")
        specs.text = "\(car.seats) seats · \(car.range)"
        price.text = car.dailyPrice
        icon.image = UIImage(systemName: car.symbol)
        icon.tintColor = car.color
        icon.backgroundColor = car.color.withAlphaComponent(0.12)
        accessibilityLabel = "\(car.name), \(car.seats) seats, \(car.range), \(car.dailyPrice)\(favorite ? ", saved" : "")"
        accessibilityHint = "Opens rental details. Swipe for save or remove."
        isAccessibilityElement = true
    }
}

final class CollectionHeader: UICollectionReusableView {
    static let reuseID = "CollectionHeader"
    private let title = Theme.label(style: .title1)
    private let subtitle = Theme.label(style: .subheadline, color: .secondaryLabel)

    override init(frame: CGRect) {
        super.init(frame: frame)
        let stack = Theme.stack([title, subtitle], spacing: 6)
        addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            stack.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    required init?(coder: NSCoder) { fatalError("Programmatic UI only") }

    func configure(count: Int) {
        title.text = "Find your next drive."
        subtitle.text = "\(count) cars · One great escape.\nSample daily rates in USD."
    }
}
