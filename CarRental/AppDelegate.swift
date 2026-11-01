import UIKit

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        let tabs = UITabBarController()
        let explore = UINavigationController(rootViewController: ExploreViewController())
        explore.tabBarItem = UITabBarItem(title: "Explore", image: UIImage(systemName: "square.grid.2x2"), tag: 0)
        let fleet = UINavigationController(rootViewController: FleetViewController())
        fleet.tabBarItem = UITabBarItem(title: "Fleet", image: UIImage(systemName: "list.bullet.rectangle"), tag: 1)
        tabs.viewControllers = [explore, fleet]
        tabs.tabBar.tintColor = Theme.accent
        let bar = UITabBarAppearance()
        bar.configureWithOpaqueBackground()
        bar.backgroundColor = .systemBackground
        tabs.tabBar.standardAppearance = bar
        tabs.tabBar.scrollEdgeAppearance = bar
        window.rootViewController = tabs
        window.makeKeyAndVisible()
        self.window = window
        return true
    }
}
