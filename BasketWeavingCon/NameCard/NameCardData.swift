import UIKit

/// Model for storing name card data with persistence
class NameCardData {

    // MARK: - Singleton

    static let shared = NameCardData()

    // MARK: - Properties

    private let defaults = UserDefaults.standard
    private let nameKey = "nameCard.name"
    private let emailKey = "nameCard.email"
    private let photoFilename = "nameCardPhoto.jpg"

    var name: String {
        get { defaults.string(forKey: nameKey) ?? "" }
        set { defaults.set(newValue, forKey: nameKey) }
    }

    var email: String {
        get { defaults.string(forKey: emailKey) ?? "" }
        set { defaults.set(newValue, forKey: emailKey) }
    }

    var photo: UIImage? {
        get { loadPhoto() }
        set { savePhoto(newValue) }
    }

    // MARK: - Photo Persistence

    /// Get the file URL for the photo in the Documents directory
    private var photoURL: URL? {
        guard let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        return documentsPath.appendingPathComponent(photoFilename)
    }

    /// Save photo to Documents directory as JPEG
    private func savePhoto(_ image: UIImage?) {
        guard let url = photoURL else { return }

        if let image = image, let data = image.jpegData(compressionQuality: 0.8) {
            try? data.write(to: url)
        } else {
            // Delete photo if nil
            try? FileManager.default.removeItem(at: url)
        }
    }

    /// Load photo from Documents directory
    private func loadPhoto() -> UIImage? {
        guard let url = photoURL, FileManager.default.fileExists(atPath: url.path) else {
            return nil
        }
        guard let data = try? Data(contentsOf: url) else { return nil }
        return UIImage(data: data)
    }
}
