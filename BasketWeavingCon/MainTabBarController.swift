
import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let generalInfoVC = GeneralInfoViewController()
        generalInfoVC.tabBarItem = UITabBarItem(title: "Info", image: UIImage(systemName: "info.circle"), tag: 0)
        
        let talksVC = TalksPageViewController()
        talksVC.tabBarItem = UITabBarItem(title: "Talks", image: UIImage(systemName: "speaker"), tag: 1)
        
        let nameCardVC = NameCardViewController()
        nameCardVC.tabBarItem = UITabBarItem(title: "Name Card", image: UIImage(systemName: "person.crop.rectangle"), tag: 2)
        
        let viewControllers = [generalInfoVC, talksVC, nameCardVC]
        self.viewControllers = viewControllers.map { UINavigationController(rootViewController: $0) }
    }
}
