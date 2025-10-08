
import UIKit

class TalkViewController: UIViewController {

    private let talk: Talk
    
    init(talk: Talk) {
        self.talk = talk
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        view.clipsToBounds = false

        let containerView = UIView()
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 20
        containerView.layer.cornerCurve = .continuous
        containerView.layer.shadowColor = UIColor.black.withAlphaComponent(0.1).cgColor
        containerView.layer.shadowOpacity = 1
        containerView.layer.shadowRadius = 10
        containerView.layer.shadowOffset = CGSize(width: 0, height: 4)
        containerView.layer.masksToBounds = false

        let titleLabel = UILabel()
        titleLabel.text = talk.title
        titleLabel.font = .systemFont(ofSize: 24, weight: .bold)
        titleLabel.numberOfLines = 0
        
        let speakerLabel = UILabel()
        speakerLabel.text = "by \(talk.speaker)"
        speakerLabel.font = .systemFont(ofSize: 18, weight: .medium)
        speakerLabel.textColor = .secondaryLabel

        let timeLabel = UILabel()
        timeLabel.text = talk.time
        timeLabel.font = .systemFont(ofSize: 16, weight: .regular)
        timeLabel.textColor = .tertiaryLabel

        let summaryLabel = UILabel()
        summaryLabel.text = talk.summary
        summaryLabel.font = .systemFont(ofSize: 16, weight: .regular)
        summaryLabel.numberOfLines = 0
        summaryLabel.textColor = .secondaryLabel
        
        let spacerView = UIView()
        spacerView.setContentHuggingPriority(.defaultLow, for: .vertical)
        spacerView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        let stackView = UIStackView(arrangedSubviews: [titleLabel, speakerLabel, timeLabel, summaryLabel, spacerView])
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = 16

        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24)
        ])

        containerView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 24),
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -24)
        ])
    }
}
