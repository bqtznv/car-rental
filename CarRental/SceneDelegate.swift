import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }

        // Retain the window and attach it to the scene UIKit is presenting.
        let window = UIWindow(windowScene: windowScene)
        window.backgroundColor = .systemBackground
        window.rootViewController = makeRootViewController()
        self.window = window
        window.makeKeyAndVisible()

        #if DEBUG
        NSLog("Car Rental: connected window to application scene.")
        #endif
    }

    private func makeRootViewController() -> UITabBarController {
        let tabs = UITabBarController()
        let explore = UINavigationController(rootViewController: ExploreViewController())
        explore.tabBarItem = UITabBarItem(title: "Cars", image: UIImage(systemName: "square.grid.2x2"), tag: 0)
        let fleet = UINavigationController(rootViewController: FleetViewController())
        fleet.tabBarItem = UITabBarItem(title: "Car list", image: UIImage(systemName: "list.bullet.rectangle"), tag: 1)
        tabs.viewControllers = [explore, fleet]
        tabs.tabBar.tintColor = Theme.accent
        let bar = UITabBarAppearance()
        bar.configureWithOpaqueBackground()
        bar.backgroundColor = .systemBackground
        tabs.tabBar.standardAppearance = bar
        tabs.tabBar.scrollEdgeAppearance = bar
        return tabs
    }
}
