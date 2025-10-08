
import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        tabBar.backgroundColor = .white
        tabBar.isTranslucent = false
    
        let generalInfoVC = GeneralInfoViewController()
        generalInfoVC.tabBarItem = UITabBarItem(title: "Info", image: UIImage(systemName: "info.circle"), tag: 0)
        
        let talksVC = TalksPageViewController()
        talksVC.tabBarItem = UITabBarItem(title: "Talks", image: UIImage(systemName: "speaker"), tag: 1)
        
        let nameCardVC = NameCardViewController()
        nameCardVC.tabBarItem = UITabBarItem(title: "Name Card", image: UIImage(systemName: "person.crop.rectangle"), tag: 2)
        
        let controllers = [generalInfoVC, talksVC, nameCardVC]
        let navigationControllers = controllers.map { viewController -> UINavigationController in
            viewController.navigationItem.largeTitleDisplayMode = .always
            let navigationController = UINavigationController(rootViewController: viewController)
            navigationController.navigationBar.prefersLargeTitles = true
            return navigationController
        }
        self.viewControllers = navigationControllers
    }
}
