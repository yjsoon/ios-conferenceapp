import UIKit

class MainTabBarController: UITabBarController {

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        // Create each tab's root view controller
        let generalInfoVC = GeneralInfoViewController()
        let talksVC = TalksPageViewController()
        let nameCardVC = NameCardViewController()

        // Configure tab bar items (icon and title shown in tab bar)
        generalInfoVC.tabBarItem = UITabBarItem(
            title: "Info",
            image: UIImage(systemName: "info.circle"),
            tag: 0
        )

        talksVC.tabBarItem = UITabBarItem(
            title: "Talks",
            image: UIImage(systemName: "speaker"),
            tag: 1
        )

        nameCardVC.tabBarItem = UITabBarItem(
            title: "Name Card",
            image: UIImage(systemName: "person.crop.rectangle"),
            tag: 2
        )

        // Wrap each view controller in a navigation controller
        // This gives each tab its own navigation stack (for pushing/popping screens)
        let generalInfoNav = createNavigationController(for: generalInfoVC)
        let talksNav = createNavigationController(for: talksVC)
        let nameCardNav = createNavigationController(for: nameCardVC)

        // Assign navigation controllers as tabs
        self.viewControllers = [generalInfoNav, talksNav, nameCardNav]
    }

    // MARK: - Helper Methods

    /// Creates a navigation controller with large titles enabled
    /// - Parameter rootViewController: The view controller to wrap in navigation
    /// - Returns: Navigation controller containing the root view controller
    private func createNavigationController(for rootViewController: UIViewController) -> UINavigationController {
        // Enable large titles for this view controller
        rootViewController.navigationItem.largeTitleDisplayMode = .always

        // Create navigation controller with this view controller as root
        let navigationController = UINavigationController(rootViewController: rootViewController)
        navigationController.navigationBar.prefersLargeTitles = true

        return navigationController
    }
}
