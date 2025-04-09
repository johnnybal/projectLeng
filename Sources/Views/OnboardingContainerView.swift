import SwiftUI

struct OnboardingContainerView: View {
    @StateObject private var viewModel = OnboardingViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                switch viewModel.currentStep {
                case .welcome:
                    WelcomeView(viewModel: viewModel)
                case .phoneVerification:
                    PhoneVerificationView(viewModel: viewModel)
                case .codeVerification:
                    CodeVerificationView(viewModel: viewModel)
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
        }
    }
}

#Preview {
    OnboardingContainerView()
} 