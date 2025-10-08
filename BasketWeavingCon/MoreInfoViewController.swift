
import UIKit

class MoreInfoViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        title = "More Info"
        navigationItem.largeTitleDisplayMode = .always
        configureNavigationItems()
        configureContent()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    private func configureNavigationItems() {
        let feedbackItem = UIBarButtonItem(image: UIImage(systemName: "paperplane.fill"), style: .plain, target: self, action: #selector(sendFeedback))
        feedbackItem.accessibilityLabel = "Send Feedback"
        navigationItem.rightBarButtonItem = feedbackItem
    }

    private func configureContent() {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.alwaysBounceVertical = true
        scrollView.backgroundColor = .clear
        view.addSubview(scrollView)

        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])

        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 24
        stackView.alignment = .leading
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 24, leading: 20, bottom: 40, trailing: 20)
        stackView.translatesAutoresizingMaskIntoConstraints = false

        scrollView.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor)
        ])

        let introLabel = UILabel()
        introLabel.text = "Welcome to BasketWeavingCon 2025"
        introLabel.font = .systemFont(ofSize: 28, weight: .bold)
        introLabel.numberOfLines = 0
        stackView.addArrangedSubview(introLabel)

        let blurbs: [(String, String)] = [
            ("Hydration Strategy", "Complimentary pandan-infused water stations will be refreshed every odd hour. Bring your own eco-friendly tumbler to unlock the secret durian-cucumber spritzer option."),
            ("Workshop Dress Code", "Loose linen encouraged; synthetic fibres may eerily whistle during underwater demos. Flip-flops acceptable only if they match your loom."),
            ("Late Night Loom Lounge", "From 9 PM, join fellow weavers for experimental basket jazz, glow-in-the-dark reeds, and a karaoke segment featuring nothing but weaving puns."),
            ("Official Snack Pairing", "Day 1: kaya toast flight. Day 2: otah sliders. Day 3: a mystery dessert rumoured to be woven entirely from gula melaka."),
            ("Secret Achievement", "Scan three QR codes hidden around campus to unlock a limited-edition badge titled 'Thread Head Supreme'." )
        ]

        blurbs.forEach { title, detail in
            let titleLabel = UILabel()
            titleLabel.text = title
            titleLabel.font = .preferredFont(forTextStyle: .headline)
            titleLabel.numberOfLines = 0

            let detailLabel = UILabel()
            detailLabel.text = detail
            detailLabel.font = .preferredFont(forTextStyle: .body)
            detailLabel.numberOfLines = 0
            detailLabel.textColor = .secondaryLabel

            let sectionStack = UIStackView(arrangedSubviews: [titleLabel, detailLabel])
            sectionStack.axis = .vertical
            sectionStack.spacing = 8

            stackView.addArrangedSubview(sectionStack)
        }

        let footerLabel = UILabel()
        footerLabel.text = "Need something even more specific? Tap the paper plane to holler at the organisers."
        footerLabel.font = .preferredFont(forTextStyle: .footnote)
        footerLabel.numberOfLines = 0
        footerLabel.textColor = .tertiaryLabel
        stackView.addArrangedSubview(footerLabel)
    }

    @objc private func sendFeedback() {
        guard let url = URL(string: "mailto:feedback@basketweavingcon.sg?subject=Feedback%20for%20BasketWeavingCon") else {
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}
