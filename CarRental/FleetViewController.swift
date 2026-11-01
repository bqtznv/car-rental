import UIKit

final class FleetViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    private let store = FleetStore.shared
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    private var isMoving = false

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Car list"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = editButtonItem
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(restore))
        view.backgroundColor = .systemGroupedBackground
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(FleetCell.self, forCellReuseIdentifier: FleetCell.reuseID)
        tableView.allowsSelectionDuringEditing = false
        tableView.cellLayoutMarginsFollowReadableWidth = true
        view.addSubview(tableView)
        Theme.pin(tableView, to: view)
        NotificationCenter.default.addObserver(self, selector: #selector(reload), name: FleetStore.didChange, object: store)
        reload()
    }

    deinit { NotificationCenter.default.removeObserver(self) }

    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(editing, animated: animated)
    }

    @objc private func restore() {
        setEditing(false, animated: true)
        store.restore()
    }

    @objc private func reload() {
        guard !isMoving else { return }
        if store.cars.isEmpty { setEditing(false, animated: false) }
        tableView.reloadData()
        let empty = Theme.label("No cars in the list.\nTap Reset to show all 12 cars.", style: .headline, color: .secondaryLabel)
        empty.textAlignment = .center
        tableView.backgroundView = store.cars.isEmpty ? empty : nil
        editButtonItem.isEnabled = !store.cars.isEmpty
    }

    private func car(at indexPath: IndexPath) -> Car {
        store.cars(in: CarCategory.allCases[indexPath.section])[indexPath.row]
    }

    // 1. Group the fleet into three meaningful vehicle categories.
    func numberOfSections(in tableView: UITableView) -> Int { CarCategory.allCases.count }

    // 2. Each category reflects removals and restores immediately.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        store.cars(in: CarCategory.allCases[section]).count
    }

    // 3. Custom rows display price, seating, powertrain, and favorite state.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FleetCell.reuseID, for: indexPath) as! FleetCell
        let car = self.car(at: indexPath)
        cell.configure(with: car, favorite: store.isFavorite(car))
        return cell
    }

    // 4. Category titles also report their current car counts.
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let category = CarCategory.allCases[section]
        return "\(category.rawValue) · \(store.cars(in: category).count) cars"
    }

    // 5. Footers explain each category and how to recover an empty section.
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        let category = CarCategory.allCases[section]
        return store.cars(in: category).isEmpty ? "No cars of this type. Tap Reset to show all cars." : category.subtitle
    }

    // 6. Self-sizing rows accommodate long model names and Dynamic Type.
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { UITableView.automaticDimension }

    // 7. A realistic initial height reduces scroll-position jumps while sizing.
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        UIFontMetrics.default.scaledValue(for: 112)
    }

    // 8. Self-sized category headers support large accessibility fonts.
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat { UITableView.automaticDimension }

    // 9. Footer sizing respects the explanation's wrapping and text settings.
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat { UITableView.automaticDimension }

    // 10. Row selection opens the same detail experience as the collection.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        navigationController?.pushViewController(CarDetailViewController(car: car(at: indexPath)), animated: true)
    }

    // 11. Every demo vehicle can be removed or saved.
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool { true }

    // 12. Edit mode exposes the standard delete controls.
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle { .delete }

    // 13. Standard editing deletion updates the shared source of truth.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete { store.remove(car(at: indexPath)) }
    }

    // 14. A deliberate swipe removes a car; full-swipe deletion is disabled.
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let car = self.car(at: indexPath)
        let remove = UIContextualAction(style: .destructive, title: "Remove") { [weak self] _, _, completion in
            completion(true)
            self?.store.remove(car)
        }
        remove.image = UIImage(systemName: "trash")
        let config = UISwipeActionsConfiguration(actions: [remove])
        config.performsFirstActionWithFullSwipe = false
        return config
    }

    // 15. The opposite swipe saves or unsaves the selected vehicle.
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let car = self.car(at: indexPath)
        let saved = store.isFavorite(car)
        let save = UIContextualAction(style: .normal, title: saved ? "Unsave" : "Save") { [weak self] _, _, completion in
            completion(true)
            self?.store.toggleFavorite(car)
        }
        save.backgroundColor = Theme.accent
        save.image = UIImage(systemName: saved ? "heart.slash" : "heart")
        return UISwipeActionsConfiguration(actions: [save])
    }

    // 16. Reordering is offered only where there are multiple vehicles.
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        store.cars(in: CarCategory.allCases[indexPath.section]).count > 1
    }

    // 17. A car cannot change category by being dragged across a section.
    func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        guard sourceIndexPath.section != proposedDestinationIndexPath.section else { return proposedDestinationIndexPath }
        let last = store.cars(in: CarCategory.allCases[sourceIndexPath.section]).count - 1
        return IndexPath(row: proposedDestinationIndexPath.section < sourceIndexPath.section ? 0 : last, section: sourceIndexPath.section)
    }

    // 18. Persist the user's order in the shared in-memory fleet.
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        isMoving = true
        store.move(from: sourceIndexPath.row, to: destinationIndexPath.row, in: CarCategory.allCases[sourceIndexPath.section])
        isMoving = false
    }

    // 19. Edit mode communicates its purpose without a selection highlight.
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool { !tableView.isEditing }
}
