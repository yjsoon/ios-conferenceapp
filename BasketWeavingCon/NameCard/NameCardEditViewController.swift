import UIKit

/// Protocol for communicating name card edits back to the display view
/// Using protocol-delegate pattern instead of closures for better separation of concerns
protocol NameCardEditViewControllerDelegate: AnyObject {
    /// Called when user taps Done to save changes
    /// - Parameters:
    ///   - name: The updated name
    ///   - email: The updated email
    ///   - photo: The updated photo (optional)
    func nameCardEditDidSave(name: String, email: String, photo: UIImage?)
}

/// Edit modal for name card - allows user to change photo, name, and email
/// Presented modally from NameCardDisplayViewController
class NameCardEditViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // MARK: - Properties

    // Delegate property for communicating changes back to display view
    // weak: prevents retain cycle (display view owns edit view, edit view references display view)
    // AnyObject: ensures delegate is a class (required for weak reference)
    // Protocol conformance checked at compile time for type safety
    weak var delegate: NameCardEditViewControllerDelegate?

    private var selectedImage: UIImage?

    // MARK: - UI Components

    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let cardContainerView = UIView()
    private let imageView = UIImageView()
    private let nameTextField = UITextField()
    private let emailTextField = UITextField()
    private let photoButton = UIButton(type: .system)

    // MARK: - Lifecycle

    /// Custom initializer to pass in existing data for editing
    /// Default parameters (= "") allow calling init() with no arguments
    /// Example: init() or init(name: "John") or init(name: "John", email: "test@test.com")
    init(name: String = "", email: String = "", photo: UIImage? = nil) {
        super.init(nibName: nil, bundle: nil)

        // Set text field values (happens before viewDidLoad)
        nameTextField.text = name
        emailTextField.text = email
        if let photo = photo {
            selectedImage = photo
        }
    }

    /// Required by UIViewController when you implement a custom init
    /// This init is for loading from Storyboards/XIBs (we don't use those)
    /// fatalError() crashes if somehow called - forces you to use init(name:email:photo:)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        title = "Edit Name Card"
        navigationItem.largeTitleDisplayMode = .always

        // Done button dismisses modal and saves changes
        // .done shows checkmark icon
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(doneTapped)
        )

        setupScrollView()
        setupCardContainer()
        setupImageView()
        setupTextFields()
        setupPhotoButton()
        setupKeyboardDismissal()

        // Apply selectedImage if it was passed in init
        if let image = selectedImage {
            imageView.image = image
            imageView.contentMode = .scaleAspectFill
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    // MARK: - Actions

    @objc private func doneTapped() {
        // Get values from text fields
        // textField.text is optional (might be nil)
        // ?? "" means "if nil, use empty string instead"
        let name = nameTextField.text ?? ""
        let email = emailTextField.text ?? ""

        // Call delegate method if delegate is set
        // delegate? = optional chaining: only call if not nil
        // Using protocol-delegate pattern provides better compile-time safety
        delegate?.nameCardEditDidSave(name: name, email: email, photo: selectedImage)

        // Dismiss modal and return to display view
        dismiss(animated: true)
    }

    // MARK: - Setup Methods

    private func setupScrollView() {
        // Add scroll view to main view
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.alwaysBounceVertical = true

        // Pin scroll view to edges of safe area
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])

        // Add content view inside scroll view
        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false

        // Content view constraints determine scrollable area
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            // Width matches scroll view frame so content doesn't scroll horizontally
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor)
        ])
    }

    private func setupCardContainer() {
        // Configure card appearance
        cardContainerView.backgroundColor = .secondarySystemGroupedBackground
        cardContainerView.layer.cornerRadius = 16
        cardContainerView.layer.cornerCurve = .continuous

        contentView.addSubview(cardContainerView)
        cardContainerView.translatesAutoresizingMaskIntoConstraints = false

        // Card has padding from screen edges
        NSLayoutConstraint.activate([
            cardContainerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            cardContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            cardContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            cardContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }

    private func setupImageView() {
        // Configure image view as circular profile photo
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 80 // Half of width/height for perfect circle
        imageView.backgroundColor = .systemGray5
        imageView.layer.borderWidth = 4
        imageView.layer.borderColor = UIColor.systemBackground.cgColor

        // Add placeholder icon using SF Symbols
        let config = UIImage.SymbolConfiguration(pointSize: 50, weight: .light)
        let placeholderImage = UIImage(systemName: "person.circle.fill", withConfiguration: config)
        imageView.image = placeholderImage
        imageView.tintColor = .systemGray3
        imageView.contentMode = .center

        cardContainerView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: cardContainerView.topAnchor, constant: 32),
            imageView.centerXAnchor.constraint(equalTo: cardContainerView.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 160),
            imageView.heightAnchor.constraint(equalToConstant: 160)
        ])
    }

    private func setupTextFields() {
        // Configure name field
        nameTextField.placeholder = "Your Name"
        nameTextField.autocapitalizationType = .words
        nameTextField.returnKeyType = .next
        nameTextField.delegate = self
        configureTextField(nameTextField)

        // Configure email field
        emailTextField.placeholder = "your.email@example.com"
        emailTextField.autocapitalizationType = .none
        emailTextField.keyboardType = .emailAddress
        emailTextField.returnKeyType = .done
        emailTextField.delegate = self
        configureTextField(emailTextField)

        // Add to container
        cardContainerView.addSubview(nameTextField)
        cardContainerView.addSubview(emailTextField)

        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.translatesAutoresizingMaskIntoConstraints = false

        // Layout text fields below image view
        NSLayoutConstraint.activate([
            nameTextField.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 32),
            nameTextField.leadingAnchor.constraint(equalTo: cardContainerView.leadingAnchor, constant: 20),
            nameTextField.trailingAnchor.constraint(equalTo: cardContainerView.trailingAnchor, constant: -20),
            nameTextField.heightAnchor.constraint(equalToConstant: 50),

            emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 12),
            emailTextField.leadingAnchor.constraint(equalTo: cardContainerView.leadingAnchor, constant: 20),
            emailTextField.trailingAnchor.constraint(equalTo: cardContainerView.trailingAnchor, constant: -20),
            emailTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    /// Helper method to configure common text field styling
    /// This reduces code duplication between name and title fields
    private func configureTextField(_ textField: UITextField) {
        textField.font = .systemFont(ofSize: 17)
        textField.textAlignment = .center
        textField.backgroundColor = .tertiarySystemGroupedBackground
        textField.layer.cornerRadius = 10
        textField.layer.cornerCurve = .continuous

        // Add padding using invisible views on left and right
        let leftPadding = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 44))
        textField.leftView = leftPadding
        textField.leftViewMode = .always

        let rightPadding = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 44))
        textField.rightView = rightPadding
        textField.rightViewMode = .always
    }

    private func setupPhotoButton() {
        // Use iOS 26 Liquid Glass button style for premium look
        var config = UIButton.Configuration.prominentGlass()
        config.title = "Change Photo"
        config.image = UIImage(systemName: "camera.fill")
        config.imagePadding = 8
        config.buttonSize = .large

        photoButton.configuration = config
        photoButton.addTarget(self, action: #selector(photoButtonTapped), for: .touchUpInside)

        cardContainerView.addSubview(photoButton)
        photoButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            photoButton.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 32),
            photoButton.centerXAnchor.constraint(equalTo: cardContainerView.centerXAnchor),
            photoButton.bottomAnchor.constraint(equalTo: cardContainerView.bottomAnchor, constant: -32)
        ])
    }

    private func setupKeyboardDismissal() {
        // Add tap gesture to dismiss keyboard when tapping outside text fields
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false // Allow other views to still receive touches
        view.addGestureRecognizer(tapGesture)
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

    // MARK: - Photo Selection

    @objc private func photoButtonTapped() {
        // Show action sheet to choose between camera or photo library
        let alert = UIAlertController(title: "Choose Photo Source", message: nil, preferredStyle: .actionSheet)

        // Only show camera option if device has a camera (simulators don't)
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            alert.addAction(UIAlertAction(title: "Take Photo", style: .default) { [weak self] _ in
                // [weak self] prevents memory leak (retain cycle)
                self?.presentImagePicker(sourceType: .camera)
            })
        }

        // Photo library is always available
        alert.addAction(UIAlertAction(title: "Choose from Library", style: .default) { [weak self] _ in
            self?.presentImagePicker(sourceType: .photoLibrary)
        })

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        // On iPad, action sheets need a source view (where the popover points to)
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = photoButton
            popoverController.sourceRect = photoButton.bounds
        }

        present(alert, animated: true)
    }

    /// Presents the image picker with specified source (camera or photo library)
    private func presentImagePicker(sourceType: UIImagePickerController.SourceType) {
        let picker = UIImagePickerController()
        picker.delegate = self // We implement UIImagePickerControllerDelegate to receive callbacks
        picker.sourceType = sourceType
        picker.allowsEditing = true // Lets user crop/edit photo before selecting
        present(picker, animated: true)
    }

    // MARK: - UIImagePickerControllerDelegate

    /// Called when user selects a photo from the picker
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Try to get edited image first (if user cropped it)
        if let editedImage = info[.editedImage] as? UIImage {
            selectedImage = editedImage
            imageView.image = editedImage
            imageView.contentMode = .scaleAspectFill
        }
        // Fall back to original image if no editing was done
        else if let originalImage = info[.originalImage] as? UIImage {
            selectedImage = originalImage
            imageView.image = originalImage
            imageView.contentMode = .scaleAspectFill
        }

        // Dismiss the picker after selection
        picker.dismiss(animated: true)
    }

    /// Called when user cancels photo selection
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}

// MARK: - UITextFieldDelegate

extension NameCardEditViewController: UITextFieldDelegate {
    /// Handle return key press on text fields
    /// Return key on name field moves to email field
    /// Return key on email field dismisses keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameTextField {
            emailTextField.becomeFirstResponder() // Move to next field
        } else {
            textField.resignFirstResponder() // Dismiss keyboard
        }
        return true
    }
}
