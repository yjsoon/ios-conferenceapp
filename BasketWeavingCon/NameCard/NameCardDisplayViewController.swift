import UIKit

/// Displays name card with photo, name, title, and QR code
class NameCardDisplayViewController: UIViewController {

    // MARK: - UI Components

    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let cardContainerView = UIView()
    private let photoImageView = UIImageView()
    private let nameLabel = UILabel()
    private let emailLabel = UILabel()
    private let qrCodeImageView = UIImageView()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        title = "Name Card"
        navigationItem.largeTitleDisplayMode = .always

        // Add Edit button in toolbar
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .edit,
            target: self,
            action: #selector(editTapped)
        )

        setupScrollView()
        setupCardContainer()
        setupPhotoImageView()
        setupNameLabel()
        setupEmailLabel()
        setupQRCodeImageView()

        loadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true

        // Reload data in case it was edited
        loadData()
    }

    // MARK: - Setup

    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.alwaysBounceVertical = true

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])

        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor)
        ])
    }

    private func setupCardContainer() {
        cardContainerView.backgroundColor = .secondarySystemGroupedBackground
        cardContainerView.layer.cornerRadius = 16
        cardContainerView.layer.cornerCurve = .continuous

        contentView.addSubview(cardContainerView)
        cardContainerView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            cardContainerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            cardContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            cardContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            cardContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }

    private func setupPhotoImageView() {
        photoImageView.contentMode = .scaleAspectFill
        photoImageView.clipsToBounds = true
        photoImageView.layer.cornerRadius = 80
        photoImageView.backgroundColor = .systemGray5
        photoImageView.layer.borderWidth = 4
        photoImageView.layer.borderColor = UIColor.systemBackground.cgColor

        // Default placeholder
        let config = UIImage.SymbolConfiguration(pointSize: 50, weight: .light)
        let placeholderImage = UIImage(systemName: "person.circle.fill", withConfiguration: config)
        photoImageView.image = placeholderImage
        photoImageView.tintColor = .systemGray3

        cardContainerView.addSubview(photoImageView)
        photoImageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            photoImageView.topAnchor.constraint(equalTo: cardContainerView.topAnchor, constant: 32),
            photoImageView.centerXAnchor.constraint(equalTo: cardContainerView.centerXAnchor),
            photoImageView.widthAnchor.constraint(equalToConstant: 160),
            photoImageView.heightAnchor.constraint(equalToConstant: 160)
        ])
    }

    private func setupNameLabel() {
        nameLabel.font = .systemFont(ofSize: 28, weight: .bold)
        nameLabel.textAlignment = .center
        nameLabel.numberOfLines = 0
        nameLabel.text = "Your Name"

        cardContainerView.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: photoImageView.bottomAnchor, constant: 24),
            nameLabel.leadingAnchor.constraint(equalTo: cardContainerView.leadingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: cardContainerView.trailingAnchor, constant: -20)
        ])
    }

    private func setupEmailLabel() {
        emailLabel.font = .systemFont(ofSize: 18, weight: .medium)
        emailLabel.textAlignment = .center
        emailLabel.numberOfLines = 0
        emailLabel.textColor = .secondaryLabel
        emailLabel.text = "your.email@example.com"

        cardContainerView.addSubview(emailLabel)
        emailLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            emailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            emailLabel.leadingAnchor.constraint(equalTo: cardContainerView.leadingAnchor, constant: 20),
            emailLabel.trailingAnchor.constraint(equalTo: cardContainerView.trailingAnchor, constant: -20)
        ])
    }

    private func setupQRCodeImageView() {
        // QR code image view
        qrCodeImageView.contentMode = .scaleAspectFit
        qrCodeImageView.backgroundColor = .white
        qrCodeImageView.layer.cornerRadius = 12
        qrCodeImageView.layer.borderWidth = 1
        qrCodeImageView.layer.borderColor = UIColor.systemGray4.cgColor
        qrCodeImageView.clipsToBounds = true

        cardContainerView.addSubview(qrCodeImageView)
        qrCodeImageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            qrCodeImageView.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 32),
            qrCodeImageView.centerXAnchor.constraint(equalTo: cardContainerView.centerXAnchor),
            qrCodeImageView.widthAnchor.constraint(equalToConstant: 200),
            qrCodeImageView.heightAnchor.constraint(equalToConstant: 200),
            qrCodeImageView.bottomAnchor.constraint(equalTo: cardContainerView.bottomAnchor, constant: -32)
        ])
    }

    // MARK: - Data Loading

    /// Load data from NameCardData and update UI
    private func loadData() {
        let data = NameCardData.shared

        // Update labels
        nameLabel.text = data.name.isEmpty ? "Your Name" : data.name
        emailLabel.text = data.email.isEmpty ? "your.email@example.com" : data.email

        // Update photo
        if let photo = data.photo {
            photoImageView.image = photo
            photoImageView.contentMode = .scaleAspectFill
        } else {
            // Reset to placeholder
            let config = UIImage.SymbolConfiguration(pointSize: 50, weight: .light)
            let placeholderImage = UIImage(systemName: "person.circle.fill", withConfiguration: config)
            photoImageView.image = placeholderImage
            photoImageView.contentMode = .center
        }

        // Generate QR code
        updateQRCode()
    }

    /// Generate QR code containing name and email in vCard format
    private func updateQRCode() {
        let data = NameCardData.shared

        // Use vCard format for better QR code scanning compatibility
        let vCard = """
        BEGIN:VCARD
        VERSION:3.0
        FN:\(data.name)
        EMAIL:\(data.email)
        END:VCARD
        """

        if let qrImage = generateQRCode(from: vCard) {
            qrCodeImageView.image = qrImage
        }
    }

    /// Generate QR code image using Core Image
    /// - Parameter string: The text to encode in the QR code
    /// - Returns: UIImage with the QR code, or nil if generation fails
    private func generateQRCode(from string: String) -> UIImage? {
        // Convert string to data
        guard let data = string.data(using: .utf8) else { return nil }

        // Create QR code filter
        guard let filter = CIFilter(name: "CIQRCodeGenerator") else { return nil }

        // Set input data
        filter.setValue(data, forKey: "inputMessage")

        // Set error correction level (L = 7%, M = 15%, Q = 25%, H = 30%)
        filter.setValue("M", forKey: "inputCorrectionLevel")

        // Get the output image
        guard let ciImage = filter.outputImage else { return nil }

        // Scale up the QR code (default is tiny)
        let transform = CGAffineTransform(scaleX: 10, y: 10)
        let scaledImage = ciImage.transformed(by: transform)

        // Convert CIImage to UIImage
        let context = CIContext()
        guard let cgImage = context.createCGImage(scaledImage, from: scaledImage.extent) else { return nil }

        return UIImage(cgImage: cgImage)
    }

    // MARK: - Actions

    @objc private func editTapped() {
        let data = NameCardData.shared
        let editVC = NameCardEditViewController(name: data.name, email: data.email, photo: data.photo)

        // Handle save callback
        editVC.onSave = { [weak self] name, email, photo in
            NameCardData.shared.name = name
            NameCardData.shared.email = email
            NameCardData.shared.photo = photo
            self?.loadData()
        }

        // Present as modal with navigation controller
        let navController = UINavigationController(rootViewController: editVC)
        navController.navigationBar.prefersLargeTitles = true
        present(navController, animated: true)
    }
}
