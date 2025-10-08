
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
        view.backgroundColor = .white
        
        let titleLabel = UILabel()
        titleLabel.text = talk.title
        titleLabel.font = .systemFont(ofSize: 24, weight: .bold)
        titleLabel.numberOfLines = 0
        
        let speakerLabel = UILabel()
        speakerLabel.text = "by \(talk.speaker)"
        speakerLabel.font = .systemFont(ofSize: 18, weight: .medium)
        
        let timeLabel = UILabel()
        timeLabel.text = talk.time
        timeLabel.font = .systemFont(ofSize: 16, weight: .regular)
        
        let summaryLabel = UILabel()
        summaryLabel.text = talk.summary
        summaryLabel.font = .systemFont(ofSize: 16, weight: .regular)
        summaryLabel.numberOfLines = 0
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, speakerLabel, timeLabel, summaryLabel])
        stackView.axis = .vertical
        stackView.spacing = 16
        
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
}
