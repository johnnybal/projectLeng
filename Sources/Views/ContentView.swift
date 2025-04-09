import SwiftUI
import FirebaseCore

struct ContentView: View {
    @StateObject private var onboardingViewModel = OnboardingViewModel()
    
    var body: some View {
        NavigationView {
            WelcomeView(viewModel: onboardingViewModel)
        }
        .environmentObject(onboardingViewModel)
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif 