import SwiftUI
import FirebaseCore

@main
struct LengLengApp: App {
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            OnboardingContainerView()
        }
    }
} 