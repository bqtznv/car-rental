import UIKit

enum Theme {
    static let accent = UIColor { $0.userInterfaceStyle == .dark
        ? UIColor(red: 0.28, green: 0.85, blue: 0.73, alpha: 1)
        : UIColor(red: 0.02, green: 0.42, blue: 0.36, alpha: 1) }

    static func label(_ text: String = "", style: UIFont.TextStyle = .body, color: UIColor = .label) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = .preferredFont(forTextStyle: style)
        label.adjustsFontForContentSizeCategory = true
        label.textColor = color
        label.numberOfLines = 0
        return label
    }

    static func stack(_ views: [UIView], spacing: CGFloat = 8, axis: NSLayoutConstraint.Axis = .vertical) -> UIStackView {
        let stack = UIStackView(arrangedSubviews: views)
        stack.axis = axis
        stack.spacing = spacing
        return stack
    }

    static func pin(_ child: UIView, to parent: UIView, inset: CGFloat = 0) {
        child.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            child.leadingAnchor.constraint(equalTo: parent.leadingAnchor, constant: inset),
            child.trailingAnchor.constraint(equalTo: parent.trailingAnchor, constant: -inset),
            child.topAnchor.constraint(equalTo: parent.topAnchor, constant: inset),
            child.bottomAnchor.constraint(equalTo: parent.bottomAnchor, constant: -inset)
        ])
    }
}
