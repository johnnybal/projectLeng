import Foundation
import Combine
import FirebaseAuth
import Contacts

enum OnboardingStep {
    case welcome
    case phoneVerification
    case verificationCode
    case profile
    case permissions
    case schoolSelection
    case tutorial
    case premiumOffer
}

class OnboardingViewModel: ObservableObject {
    @Published var currentStep: OnboardingStep = .welcome
    @Published var phoneNumber: String = ""
    @Published var verificationCode: String = ""
    @Published var verificationID: String = ""
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var username: String = ""
    @Published var selectedSchool: School?
    @Published var isLoading: Bool = false
    @Published var error: Error?
    
    // Permissions
    @Published var isContactsAuthorized = false
    @Published var isLocationAuthorized = false
    
    private let authService = AuthenticationService.shared
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Phone Verification
    func verifyPhoneNumber() async {
        isLoading = true
        do {
            let formattedPhone = formatPhoneNumber(phoneNumber)
            verificationID = try await authService.verifyPhoneNumber(formattedPhone)
            await MainActor.run {
                currentStep = .verificationCode
                isLoading = false
            }
        } catch {
            await MainActor.run {
                self.error = error
                isLoading = false
            }
        }
    }
    
    func submitVerificationCode() async {
        isLoading = true
        do {
            _ = try await authService.signIn(withVerificationID: verificationID, verificationCode: verificationCode)
            await MainActor.run {
                currentStep = .profile
                isLoading = false
            }
        } catch {
            await MainActor.run {
                self.error = error
                isLoading = false
            }
        }
    }
    
    // MARK: - Profile Creation
    func createProfile() async {
        isLoading = true
        do {
            _ = try await authService.createUser(
                firstName: firstName,
                lastName: lastName,
                phoneNumber: phoneNumber,
                username: username.isEmpty ? nil : username
            )
            await MainActor.run {
                currentStep = .permissions
                isLoading = false
            }
        } catch {
            await MainActor.run {
                self.error = error
                isLoading = false
            }
        }
    }
    
    // MARK: - Permissions
    func requestContactsAccess() {
        let store = CNContactStore()
        store.requestAccess(for: .contacts) { [weak self] granted, error in
            DispatchQueue.main.async {
                self?.isContactsAuthorized = granted
                if let error = error {
                    self?.error = error
                }
            }
        }
    }
    
    // MARK: - Helpers
    private func formatPhoneNumber(_ number: String) -> String {
        // Add proper phone number formatting logic here
        // For UK numbers, should handle +44 format
        return number
    }
    
    func moveToNextStep() {
        switch currentStep {
        case .welcome:
            currentStep = .phoneVerification
        case .phoneVerification:
            // Handled by verifyPhoneNumber()
            break
        case .verificationCode:
            // Handled by submitVerificationCode()
            break
        case .profile:
            // Handled by createProfile()
            break
        case .permissions:
            currentStep = .schoolSelection
        case .schoolSelection:
            currentStep = .tutorial
        case .tutorial:
            currentStep = .premiumOffer
        case .premiumOffer:
            // Complete onboarding
            break
        }
    }
} 