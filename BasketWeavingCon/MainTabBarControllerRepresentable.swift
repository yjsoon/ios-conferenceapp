
import SwiftUI
import UIKit

struct MainTabBarControllerRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UITabBarController {
        return MainTabBarController()
    }

    func updateUIViewController(_ uiViewController: UITabBarController, context: Context) {
        // No update needed
    }
}
