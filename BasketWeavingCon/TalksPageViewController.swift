
import UIKit

class TalksPageViewController: UIPageViewController, UIPageViewControllerDataSource {

    private var talkViewControllers = [UIViewController]()
    
    private let talks = [
        Talk(title: "The Art of Underwater Basket Weaving", speaker: "John Doe", time: "10:00 AM", summary: "A deep dive into the history and techniques of underwater basket weaving."),
        Talk(title: "Modern Basket Weaving Materials", speaker: "Jane Smith", time: "11:00 AM", summary: "Exploring new and sustainable materials for basket weaving."),
        Talk(title: "Basket Weaving for Fun and Profit", speaker: "Peter Jones", time: "1:00 PM", summary: "How to turn your hobby into a successful business.")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Upcoming Talks"
        
        dataSource = self
        
        for talk in talks {
            talkViewControllers.append(TalkViewController(talk: talk))
        }
        
        if let firstViewController = talkViewControllers.first {
            setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = talkViewControllers.firstIndex(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return nil
        }
        
        guard talkViewControllers.count > previousIndex else {
            return nil
        }
        
        return talkViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = talkViewControllers.firstIndex(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        
        guard talkViewControllers.count != nextIndex else {
            return nil
        }
        
        guard talkViewControllers.count > nextIndex else {
            return nil
        }
        
        return talkViewControllers[nextIndex]
    }
}
