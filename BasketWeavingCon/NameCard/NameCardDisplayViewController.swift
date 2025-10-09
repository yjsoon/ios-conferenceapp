import UIKit

/// Displays name card with photo, name, email, and auto-generated QR code
/// Read-only view - tap Edit to modify details
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

        // UIBarButtonItem with system icon and action
        // target: self = this view controller handles the action
        // action: #selector = converts method name to Objective-C selector
        // @objc is required on the method for #selector to work
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

        // viewWillAppear called every time view appears (including after modal dismissal)
        // Reload data in case it was edited in the modal
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

        // vCard is a standard format for business cards
        // When scanned, phone apps recognize it and offer to save as contact
        // """ is a multi-line string literal (Swift 4+)
        // \(data.name) = string interpolation (insert variable into string)
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
    /// Core Image is Apple's built-in image processing framework
    /// CIFilter = image filter (blur, color adjust, QR generation, etc.)
    /// - Parameter string: The text to encode in the QR code
    /// - Returns: UIImage with the QR code, or nil if generation fails
    private func generateQRCode(from string: String) -> UIImage? {
        // Convert string to Data (binary format required by filter)
        // .utf8 encoding handles international characters correctly
        guard let data = string.data(using: .utf8) else { return nil }

        // CIFilter(name:) creates filter by name
        // "CIQRCodeGenerator" is built into iOS, no external library needed
        guard let filter = CIFilter(name: "CIQRCodeGenerator") else { return nil }

        // Set the data to encode
        // Key-value coding: filters use string keys to set parameters
        filter.setValue(data, forKey: "inputMessage")

        // Error correction adds redundancy so damaged QR codes still scan
        // L = 7% (smallest QR), M = 15%, Q = 25%, H = 30% (largest QR)
        // Higher level = more damage tolerance but larger code
        filter.setValue("M", forKey: "inputCorrectionLevel")

        // Get the generated QR code as CIImage (Core Image format)
        guard let ciImage = filter.outputImage else { return nil }

        // QR codes generate at a very small size (e.g., 27x27 pixels)
        // CGAffineTransform scales it up 10x to be visible
        // scaleX/Y: how much to multiply width/height
        let transform = CGAffineTransform(scaleX: 10, y: 10)
        let scaledImage = ciImage.transformed(by: transform)

        // Convert from CIImage → CGImage → UIImage
        // CIImage = Core Image format (for processing)
        // CGImage = Core Graphics format (bitmap)
        // UIImage = UIKit format (for display in UIImageView)
        let context = CIContext()
        guard let cgImage = context.createCGImage(scaledImage, from: scaledImage.extent) else { return nil }

        return UIImage(cgImage: cgImage)
    }

    // MARK: - Actions

    /// Called when Edit button is tapped
    /// @objc required because we use #selector in viewDidLoad
    /// #selector is Objective-C feature for target-action pattern
    @objc private func editTapped() {
        let data = NameCardData.shared

        // Create edit view controller with current data
        let editVC = NameCardEditViewController(name: data.name, email: data.email, photo: data.photo)

        // Closure (anonymous function) that runs when user taps Done in edit modal
        // { parameters in code } syntax
        // [weak self] = capture list to prevent retain cycle (memory leak)
        // Without weak: editVC holds closure → closure holds self → self holds editVC = cycle!
        // With weak: closure holds weak reference, breaks cycle
        editVC.onSave = { [weak self] name, email, photo in
            // Save to singleton model
            NameCardData.shared.name = name
            NameCardData.shared.email = email
            NameCardData.shared.photo = photo

            // self? = optional chaining (safe unwrap)
            // If self is nil (view controller deallocated), this does nothing
            // If self exists, call loadData() to refresh UI
            self?.loadData()
        }

        // Modal presentation: slides up from bottom, user must dismiss to return
        // Wrap edit VC in navigation controller so it has a navigation bar
        // Navigation bar shows title and Done button
        let navController = UINavigationController(rootViewController: editVC)
        navController.navigationBar.prefersLargeTitles = true
        present(navController, animated: true)
    }
}
