import UIKit

class NameCardViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let cardContainerView = UIView()
    private let imageView = UIImageView()
    private let nameTextField = UITextField()
    private let titleTextField = UITextField()
    private let photoButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        title = "Name Card"
        navigationItem.largeTitleDisplayMode = .always

        setupScrollView()
        setupCardContainer()
        setupImageView()
        setupTextFields()
        setupPhotoButton()
        setupKeyboardDismissal()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }

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

    private func setupImageView() {
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 80
        imageView.backgroundColor = .systemGray5
        imageView.layer.borderWidth = 4
        imageView.layer.borderColor = UIColor.systemBackground.cgColor

        // Add placeholder icon
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
        // Name field
        nameTextField.placeholder = "Your Name"
        nameTextField.font = .systemFont(ofSize: 17)
        nameTextField.textAlignment = .center
        nameTextField.backgroundColor = .tertiarySystemGroupedBackground
        nameTextField.layer.cornerRadius = 10
        nameTextField.layer.cornerCurve = .continuous
        nameTextField.autocapitalizationType = .words
        nameTextField.returnKeyType = .next
        nameTextField.delegate = self

        let namePadding = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 44))
        nameTextField.leftView = namePadding
        nameTextField.leftViewMode = .always
        nameTextField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 44))
        nameTextField.rightViewMode = .always

        // Title field
        titleTextField.placeholder = "Your Title (e.g. Master Weaver)"
        titleTextField.font = .systemFont(ofSize: 17)
        titleTextField.textAlignment = .center
        titleTextField.backgroundColor = .tertiarySystemGroupedBackground
        titleTextField.layer.cornerRadius = 10
        titleTextField.layer.cornerCurve = .continuous
        titleTextField.autocapitalizationType = .words
        titleTextField.returnKeyType = .done
        titleTextField.delegate = self

        let titlePadding = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 44))
        titleTextField.leftView = titlePadding
        titleTextField.leftViewMode = .always
        titleTextField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 44))
        titleTextField.rightViewMode = .always

        cardContainerView.addSubview(nameTextField)
        cardContainerView.addSubview(titleTextField)

        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        titleTextField.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            nameTextField.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 32),
            nameTextField.leadingAnchor.constraint(equalTo: cardContainerView.leadingAnchor, constant: 20),
            nameTextField.trailingAnchor.constraint(equalTo: cardContainerView.trailingAnchor, constant: -20),
            nameTextField.heightAnchor.constraint(equalToConstant: 50),

            titleTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 12),
            titleTextField.leadingAnchor.constraint(equalTo: cardContainerView.leadingAnchor, constant: 20),
            titleTextField.trailingAnchor.constraint(equalTo: cardContainerView.trailingAnchor, constant: -20),
            titleTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    private func setupPhotoButton() {
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
            photoButton.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 32),
            photoButton.centerXAnchor.constraint(equalTo: cardContainerView.centerXAnchor),
            photoButton.bottomAnchor.constraint(equalTo: cardContainerView.bottomAnchor, constant: -32)
        ])
    }

    private func setupKeyboardDismissal() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

    @objc private func photoButtonTapped() {
        let alert = UIAlertController(title: "Choose Photo Source", message: nil, preferredStyle: .actionSheet)

        // Camera option
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            alert.addAction(UIAlertAction(title: "Take Photo", style: .default) { [weak self] _ in
                self?.presentImagePicker(sourceType: .camera)
            })
        }

        // Photo library option
        alert.addAction(UIAlertAction(title: "Choose from Library", style: .default) { [weak self] _ in
            self?.presentImagePicker(sourceType: .photoLibrary)
        })

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        // For iPad
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = photoButton
            popoverController.sourceRect = photoButton.bounds
        }

        present(alert, animated: true)
    }

    private func presentImagePicker(sourceType: UIImagePickerController.SourceType) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = sourceType
        picker.allowsEditing = true
        present(picker, animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[.editedImage] as? UIImage {
            imageView.image = editedImage
            imageView.contentMode = .scaleAspectFill
        } else if let originalImage = info[.originalImage] as? UIImage {
            imageView.image = originalImage
            imageView.contentMode = .scaleAspectFill
        }
        picker.dismiss(animated: true)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}

extension NameCardViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameTextField {
            titleTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
}
