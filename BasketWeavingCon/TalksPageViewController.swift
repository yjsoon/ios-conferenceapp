import UIKit

class TalksPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    // MARK: - Properties

    private var talkViewControllers = [UIViewController]()
    private let pageControl = UIPageControl()

    /// Conference talks to display (swipe left/right to navigate)
    private let talks = [
        Talk(title: "The Art of Underwater Basket Weaving", speaker: "John Doe", time: "10:00 AM", summary: "A deep dive into the history and techniques of underwater basket weaving."),
        Talk(title: "Modern Basket Weaving Materials", speaker: "Jane Smith", time: "11:00 AM", summary: "Exploring new and sustainable materials for basket weaving."),
        Talk(title: "Basket Weaving for Fun and Profit", speaker: "Peter Jones", time: "1:00 PM", summary: "How to turn your hobby into a successful business.")
    ]

    // MARK: - Lifecycle

    init() {
        // UIPageViewController transitions between view controllers with gestures
        // .scroll gives us horizontal swiping between pages
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        title = "Talks"

        // Set ourselves as data source and delegate
        // Data source provides the view controllers for each page
        // Delegate tells us when page transitions complete
        dataSource = self
        delegate = self

        configurePages()
        configurePageControl()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    // MARK: - Setup

    private func configurePages() {
        // Create a view controller for each talk
        // map() transforms each Talk into a TalkViewController
        talkViewControllers = talks.map { TalkViewController(talk: $0) }

        // Set the initial page (first talk)
        if let firstViewController = talkViewControllers.first {
            setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        }

        // Configure page control to show correct number of dots
        pageControl.numberOfPages = talkViewControllers.count
        pageControl.currentPage = 0
    }

    private func configurePageControl() {
        pageControl.translatesAutoresizingMaskIntoConstraints = false

        // Style the page control dots
        pageControl.currentPageIndicatorTintColor = .label // Active dot
        pageControl.pageIndicatorTintColor = UIColor.label.withAlphaComponent(0.2) // Inactive dots

        pageControl.isUserInteractionEnabled = false // User can't tap dots, only swipe
        pageControl.hidesForSinglePage = true // Hide if only one page

        // Add page control on top of page view controller's content
        view.addSubview(pageControl)
        view.bringSubviewToFront(pageControl) // Ensure it's visible above other views

        // Position at bottom center of screen
        NSLayoutConstraint.activate([
            pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    // MARK: - UIPageViewControllerDataSource

    /// Returns the view controller before the current one (swipe right shows this)
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        // Find current view controller's position in our array
        guard let currentIndex = talkViewControllers.firstIndex(of: viewController) else {
            return nil // Current VC not found (shouldn't happen)
        }

        // Calculate previous index
        let previousIndex = currentIndex - 1

        // Check if previous index is valid (not negative)
        guard previousIndex >= 0 else {
            return nil // Already at first page, can't go back
        }

        return talkViewControllers[previousIndex]
    }

    /// Returns the view controller after the current one (swipe left shows this)
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        // Find current view controller's position in our array
        guard let currentIndex = talkViewControllers.firstIndex(of: viewController) else {
            return nil // Current VC not found (shouldn't happen)
        }

        // Calculate next index
        let nextIndex = currentIndex + 1

        // Check if next index is within array bounds
        guard nextIndex < talkViewControllers.count else {
            return nil // Already at last page, can't go forward
        }

        return talkViewControllers[nextIndex]
    }

    // MARK: - UIPageViewControllerDelegate

    /// Called after user finishes swiping to a new page
    /// We use this to update the page control dots
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        // Only update if transition actually completed (user didn't cancel mid-swipe)
        guard completed else { return }

        // Get the currently visible view controller
        guard let currentVC = viewControllers?.first else { return }

        // Find its index in our array
        guard let index = talkViewControllers.firstIndex(of: currentVC) else { return }

        // Update page control to show correct dot
        pageControl.currentPage = index
    }
}
