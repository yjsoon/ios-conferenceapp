
import UIKit

class TalksPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    init() {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var talkViewControllers = [UIViewController]()
    private let pageControl = UIPageControl()
    
    private let talks = [
        Talk(title: "The Art of Underwater Basket Weaving", speaker: "John Doe", time: "10:00 AM", summary: "A deep dive into the history and techniques of underwater basket weaving."),
        Talk(title: "Modern Basket Weaving Materials", speaker: "Jane Smith", time: "11:00 AM", summary: "Exploring new and sustainable materials for basket weaving."),
        Talk(title: "Basket Weaving for Fun and Profit", speaker: "Peter Jones", time: "1:00 PM", summary: "How to turn your hobby into a successful business.")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        title = "Talks"

        dataSource = self
        delegate = self
        configurePages()
        configurePageControl()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func configurePages() {
        talkViewControllers = talks.map { TalkViewController(talk: $0) }
        if let firstViewController = talkViewControllers.first {
            setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        }
        pageControl.numberOfPages = talkViewControllers.count
        pageControl.currentPage = 0
    }

    private func configurePageControl() {
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.currentPageIndicatorTintColor = .label
        pageControl.pageIndicatorTintColor = UIColor.label.withAlphaComponent(0.2)
        pageControl.isUserInteractionEnabled = false
        pageControl.hidesForSinglePage = true
        view.addSubview(pageControl)
        view.bringSubviewToFront(pageControl)
        NSLayoutConstraint.activate([
            pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
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

    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard completed, let currentVC = viewControllers?.first, let index = talkViewControllers.firstIndex(of: currentVC) else { return }
        pageControl.currentPage = index
    }
}
