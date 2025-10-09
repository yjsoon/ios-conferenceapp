import UIKit

/// Model for storing name card data with persistence
/// Uses UserDefaults for text data and Documents directory for photo
class NameCardData {

    // MARK: - Singleton

    // Singleton pattern: Only one instance exists app-wide
    // Access it anywhere with NameCardData.shared
    // Benefits: Shared state, consistent data across app
    static let shared = NameCardData()

    // Private initializer prevents creating additional instances
    private init() {}

    // MARK: - Properties

    // UserDefaults: Simple key-value storage (like a dictionary that persists)
    // Good for: small text data, settings, preferences
    // NOT good for: large data, images, sensitive data (use Keychain for passwords)
    private let defaults = UserDefaults.standard
    private let nameKey = "nameCard.name"
    private let emailKey = "nameCard.email"
    private let photoFilename = "nameCardPhoto.jpg"

    // Computed properties with custom get/set
    // These look like regular properties but actually call methods behind the scenes
    var name: String {
        get {
            // ?? is the nil-coalescing operator: "if nil, use this default value"
            defaults.string(forKey: nameKey) ?? ""
        }
        set {
            // newValue is automatically provided in setters - it's what you're assigning
            defaults.set(newValue, forKey: nameKey)
        }
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
    /// Documents directory is permanent storage that survives app restarts
    /// Other directories: Caches (temporary), Temporary (cleared frequently)
    private var photoURL: URL? {
        // FileManager handles all file system operations
        // .documentDirectory = where app can save permanent user files
        // .userDomainMask = current user's directory (vs system-wide)
        guard let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil // Couldn't access Documents directory (very rare)
        }
        // Append filename to get full path like: /Documents/nameCardPhoto.jpg
        return documentsPath.appendingPathComponent(photoFilename)
    }

    /// Save photo to Documents directory as JPEG
    /// - Parameter image: UIImage to save, or nil to delete existing photo
    private func savePhoto(_ image: UIImage?) {
        guard let url = photoURL else { return }

        if let image = image, let data = image.jpegData(compressionQuality: 0.8) {
            // Convert UIImage to JPEG data (compressed to 80% quality)
            // Quality: 0.0 = heavily compressed, small file, low quality
            //          1.0 = no compression, large file, high quality
            // try? = attempt operation, return nil if it fails (ignores errors)
            try? data.write(to: url)
        } else {
            // No image provided, delete existing file
            try? FileManager.default.removeItem(at: url)
        }
    }

    /// Load photo from Documents directory
    /// - Returns: UIImage if photo exists, nil otherwise
    private func loadPhoto() -> UIImage? {
        // Check if URL exists AND file actually exists on disk
        guard let url = photoURL, FileManager.default.fileExists(atPath: url.path) else {
            return nil // No photo saved yet
        }

        // Load file data from disk
        guard let data = try? Data(contentsOf: url) else { return nil }

        // Convert data back to UIImage
        return UIImage(data: data)
    }
}
