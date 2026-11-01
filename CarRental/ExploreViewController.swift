import UIKit

final class ExploreViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    private let store = FleetStore.shared
    private let filters = UISegmentedControl(items: ["All", "City", "Electric", "Adventure"])
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private var cars: [Car] {
        guard filters.selectedSegmentIndex > 0 else { return store.cars }
        return store.cars(in: CarCategory.allCases[filters.selectedSegmentIndex - 1])
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Open Road"
        view.backgroundColor = .systemGroupedBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Restore", style: .plain, target: self, action: #selector(restore))
        filters.selectedSegmentIndex = 0
        filters.addTarget(self, action: #selector(filterChanged), for: .valueChanged)
        filters.accessibilityLabel = "Filter fleet by category"
        collectionView.backgroundColor = .systemGroupedBackground
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.alwaysBounceVertical = true
        collectionView.register(CarCardCell.self, forCellWithReuseIdentifier: CarCardCell.reuseID)
        collectionView.register(CollectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CollectionHeader.reuseID)
        view.addSubview(filters)
        view.addSubview(collectionView)
        filters.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            filters.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            filters.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            filters.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            collectionView.topAnchor.constraint(equalTo: filters.bottomAnchor, constant: 8),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        NotificationCenter.default.addObserver(self, selector: #selector(reload), name: FleetStore.didChange, object: store)
    }

    deinit { NotificationCenter.default.removeObserver(self) }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { _ in self.collectionView.collectionViewLayout.invalidateLayout() })
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if previousTraitCollection?.preferredContentSizeCategory != traitCollection.preferredContentSizeCategory {
            collectionView.collectionViewLayout.invalidateLayout()
        }
    }

    @objc private func filterChanged() { reload() }
    @objc private func restore() { store.restore() }
    @objc private func reload() {
        collectionView.reloadData()
        let empty = Theme.label("No cars here yet.\nTap Restore to reset the demo fleet.", style: .headline, color: .secondaryLabel)
        empty.textAlignment = .center
        collectionView.backgroundView = cars.isEmpty ? empty : nil
    }

    // 1. A single catalog section keeps filtering simple and predictable.
    func numberOfSections(in collectionView: UICollectionView) -> Int { 1 }

    // 2. Filtered data controls the actual number of cards.
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { cars.count }

    // 3. Reusable custom cards show the model and synchronized saved state.
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CarCardCell.reuseID, for: indexPath) as! CarCardCell
        let car = cars[indexPath.item]
        cell.configure(with: car, favorite: store.isFavorite(car))
        return cell
    }

    // 4. The section header reports the current filtered result count.
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CollectionHeader.reuseID, for: indexPath) as! CollectionHeader
        header.configure(count: cars.count)
        return header
    }

    // 5. Adapt columns to rotation, iPad width, and accessibility text sizes.
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let accessible = traitCollection.preferredContentSizeCategory.isAccessibilityCategory
        let width = collectionView.bounds.width - collectionView.adjustedContentInset.left - collectionView.adjustedContentInset.right
        let columns: CGFloat = accessible ? 1 : (width >= 700 ? 3 : 2)
        let cardWidth = floor((width - 40 - (columns - 1) * 14) / columns)
        let scale = UIFontMetrics.default.scaledValue(for: 1)
        return CGSize(width: max(1, cardWidth), height: 120 + 145 * scale)
    }

    // 6. Insets align the cards with the top filter and section header.
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 4, left: 20, bottom: 24, right: 20)
    }

    // 7. Vertical rhythm between rows.
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat { 16 }

    // 8. Horizontal gutters match the column-width calculation.
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat { 14 }

    // 9. Header grows with Dynamic Type instead of clipping its description.
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        CGSize(width: collectionView.bounds.width, height: UIFontMetrics.default.scaledValue(for: 136))
    }

    // 10. Selection opens the chosen car's complete details.
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        navigationController?.pushViewController(CarDetailViewController(car: cars[indexPath.item]), animated: true)
    }

    // 11. Visible press feedback gives custom cards a button-like response.
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        UIView.animate(withDuration: UIAccessibility.isReduceMotionEnabled ? 0 : 0.15) {
            collectionView.cellForItem(at: indexPath)?.contentView.alpha = 0.65
        }
    }

    // 12. Restore appearance on release, including canceled selections.
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        UIView.animate(withDuration: UIAccessibility.isReduceMotionEnabled ? 0 : 0.15) {
            collectionView.cellForItem(at: indexPath)?.contentView.alpha = 1
        }
    }

    // 13. Long press offers a useful save action without opening details.
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let car = cars[indexPath.item]
        let saved = store.isFavorite(car)
        return UIContextMenuConfiguration(identifier: car.id as NSString, previewProvider: nil) { [weak self] _ in
            UIMenu(children: [UIAction(title: saved ? "Unsave car" : "Save car", image: UIImage(systemName: saved ? "heart.slash" : "heart")) { _ in
                self?.store.toggleFavorite(car)
            }])
        }
    }
}
