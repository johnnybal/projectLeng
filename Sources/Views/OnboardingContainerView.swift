import SwiftUI

struct OnboardingContainerView: View {
    @StateObject private var viewModel = OnboardingViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                switch viewModel.currentStep {
                case .welcome:
                    WelcomeView(viewModel: viewModel)
                case .phoneVerification:
                    PhoneVerificationView(viewModel: viewModel)
                case .verificationCode:
                    VerificationCodeView(viewModel: viewModel)
                case .profile:
                    ProfileSetupView(viewModel: viewModel)
                case .permissions:
                    PermissionsView(viewModel: viewModel)
                case .schoolSelection:
                    SchoolSelectionView(viewModel: viewModel)
                case .tutorial:
                    TutorialView(viewModel: viewModel)
                case .premiumOffer:
                    PremiumOfferView(viewModel: viewModel)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

// Placeholder views - these will be implemented in separate files
struct VerificationCodeView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    
    var body: some View {
        Text("Verification Code View")
    }
}

struct ProfileSetupView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    
    var body: some View {
        Text("Profile Setup View")
    }
}

struct PermissionsView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    
    var body: some View {
        Text("Permissions View")
    }
}

struct SchoolSelectionView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    
    var body: some View {
        Text("School Selection View")
    }
}

struct TutorialView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    
    var body: some View {
        Text("Tutorial View")
    }
}

struct PremiumOfferView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    
    var body: some View {
        Text("Premium Offer View")
    }
}

#Preview {
    OnboardingContainerView()
} 